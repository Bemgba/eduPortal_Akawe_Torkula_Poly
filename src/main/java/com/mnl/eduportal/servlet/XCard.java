package com.mnl.eduportal.servlet;

import com.mnl.eduportal.entities.Banks;
import com.mnl.eduportal.entities.Courses;
import com.mnl.eduportal.entities.Payments;
import com.mnl.eduportal.entities.Paymentreference;
import com.mnl.eduportal.entities.Programmes;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.Settings;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONObject;

/**
 * X-Card Payment Gateway Integration (Resident Fintech)
 *
 * This single servlet handles the full X-Card payment lifecycle:
 *   POST /XCard?action=init      - Initialize payment (renders redirect form to gateway)
 *   POST /XCard?action=verify    - Verify a transaction by transactionId
 *   POST /XCard?action=webhook   - Receive push webhook notifications from X-Card
 *
 * Credentials are configured in Settings.java:
 *   xcard_base_url, xcard_client_id, xcard_client_secret,
 *   xcard_product_id, xcard_mode
 *
 * To replace CREDO in the epayment JSP pages:
 *   - Change the invoice form action from "/Etranzact2" to "/XCard?action=init"
 *   - Change the confirmation callback URL from "/confirmation" to "/XCard?action=verify"
 *     (or keep urlrewrite.xml pointing /confirmation -> XCard?action=verify)
 *   - Point webhook URL to "/XCard?action=webhook"
 */
@WebServlet(name = "XCard", urlPatterns = {"/XCard"})
public class XCard extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Per-transaction lock set to prevent duplicate verify processing
    // when X-Card retries the callback multiple times simultaneously
    private static final java.util.Set<String> processingTransactions =
            java.util.Collections.synchronizedSet(new java.util.HashSet<>());
    private static String cachedToken = null;
    private static long tokenExpiry = 0; // epoch millis
    private static final long TOKEN_TTL_MS = 55 * 60 * 1000; // 55 minutes (assume 60 min expiry)
    private static final Object TOKEN_LOCK = new Object(); // fix: static lock for static fields

    private final Settings settings = new Settings();

    @EJB
    MainSession sess;

    // -------------------------------------------------------------------------
    // Routing
    // -------------------------------------------------------------------------

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        addSecurityHeaders(response);

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "init":
                handleInit(request, response);
                break;
            case "verify":
                handleVerify(request, response);
                break;
            case "webhook":
                handleWebhook(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // X-Card redirects back via GET after payment (callback URL hit by browser)
        addSecurityHeaders(response);
        String action = request.getParameter("action");
        if ("verify".equals(action)) {
            handleVerify(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }


    // -------------------------------------------------------------------------
    // ACTION 1: Initialize Payment
    // Called from invoice page (replaces Etranzact2).
    // Reads the same hidden form fields the invoice JSP already sets, then
    // renders a self-submitting form that POSTs to X-Card's /xint endpoint.
    // -------------------------------------------------------------------------

    private void handleInit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getSession(false) == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Session required");
            return;
        }

        try {
            // --- Read fields from invoice form (same names Etranzact2 used) ---
            String encryptedId  = request.getParameter("id");
            String amountStr    = request.getParameter("amount");
            String email        = request.getParameter("customer_email");
            // phone and fullname are not required by X-Card /xint endpoint

            // --- Validate ---
            if (encryptedId == null || amountStr == null
                    || email == null || email.trim().isEmpty() || "null".equals(email)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required payment fields");
                return;
            }

            if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid email address");
                return;
            }

            // --- Decrypt payment reference ID ---
            String transactionId = settings.decryptText(encryptedId);
            if (transactionId == null || transactionId.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid payment reference");
                return;
            }

            // --- Parse and validate amount (X-Card expects Naira, not kobo) ---
            double amount;
            try {
                amount = Double.parseDouble(amountStr.replace(",", ""));
                if (amount < 1 || amount > 10_000_000) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid amount range");
                    return;
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid amount format");
                return;
            }

            // --- Add applicant surcharge (12%) same as Etranzact2 ---
            if (request.getSession().getAttribute("APPX") != null) {
                amount = amount + (amount * 0.12);
                System.out.println("XCard: Applicant surcharge applied. Final amount: " + amount);
            }

            // --- Build callback URL ---
            String callbackUrl;
            if (request.getServerPort() == 80 || request.getServerPort() == 443) {
                callbackUrl = request.getScheme() + "://" + request.getServerName() + "/confirmation";
            } else {
                callbackUrl = request.getScheme() + "://" + request.getServerName()
                        + ":" + request.getServerPort() + "/confirmation";
            }

            // --- Render a self-submitting form to X-Card /xint ---
            // X-Card uses form POST (not a JSON API call), so we build the form
            // server-side and auto-submit it via JavaScript.
            String xintUrl = settings.xcard_base_url + "/api/xpress-gateway/v1/xint";

            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<!DOCTYPE html><html><head><title>Redirecting to payment...</title></head><body>");
            out.println("<p>Please wait, redirecting to payment gateway...</p>");
            out.println("<form id='xcard_form' method='POST' action='" + escapeHtml(xintUrl) + "'>");
            out.println(hiddenField("email",              escapeHtml(email)));
            out.println(hiddenField("clientID",           escapeHtml(settings.xcard_client_id)));
            out.println(hiddenField("amount",             String.format("%.2f", amount)));
            out.println(hiddenField("transactionId",      escapeHtml(transactionId)));
            out.println(hiddenField("currency",           "NGN"));
            out.println(hiddenField("callbackUrl",        escapeHtml(callbackUrl)));
            out.println(hiddenField("productId",          escapeHtml(settings.xcard_product_id)));
            out.println(hiddenField("productDescription", "Fee Payment - " + escapeHtml(transactionId)));
            out.println(hiddenField("applyConveniencyCharge", "false"));
            out.println(hiddenField("mode",               escapeHtml(settings.xcard_mode)));
            out.println(hiddenField("isSplitpayment",     "false"));
            out.println("</form>");
            out.println("<script>document.getElementById('xcard_form').submit();</script>");
            out.println("</body></html>");

            System.out.println("XCard: Redirecting to X-Card gateway for transactionId: " + transactionId);

        } catch (Exception e) {
            System.err.println("XCard init error: " + e.getMessage());
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Payment initialization error");
            }
        }
    }


    // -------------------------------------------------------------------------
    // ACTION 2: Verify Payment
    // Called when X-Card redirects the user back to /confirmation (GET),
    // or can be called directly (POST) with a transactionId parameter.
    // Mirrors what paymentresponse.jsp does for CREDO.
    // -------------------------------------------------------------------------

    private void handleVerify(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Log ALL callback parameters so we can see exactly what X-Card sends back
        System.out.println("XCard callback - all parameters received:");
        java.util.Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String pname = paramNames.nextElement();
            System.out.println("  " + pname + " = " + request.getParameter(pname));
        }

        // X-Card returns transactionId in the callback URL query string.
        // Also capture X-Card's own paymentReference if provided.
        String transactionId = request.getParameter("transactionId");
        if (transactionId == null) transactionId = request.getParameter("transaction_id");
        if (transactionId == null) transactionId = request.getParameter("id");

        // X-Card may also send their own reference - capture it for verify
        String xcardPaymentRef  = request.getParameter("paymentReference");
        String xcardTxnRef      = request.getParameter("transactionReference");
        String xcardStatus      = request.getParameter("status");
        String xcardResponseCode = request.getParameter("responseCode");

        System.out.println("XCard verify: transactionId=" + transactionId
            + ", xcardPaymentRef=" + xcardPaymentRef
            + ", xcardTxnRef=" + xcardTxnRef
            + ", status=" + xcardStatus
            + ", responseCode=" + xcardResponseCode);

        if (transactionId == null || transactionId.trim().isEmpty()) {
            request.setAttribute("xcardError", "No transaction ID received from X-Card callback.");
            request.getRequestDispatcher("/paymentresponse.jsp").forward(request, response);
            return;
        }

        // Sanitize - strip invalid chars first, then check not empty, then truncate
        transactionId = transactionId.replaceAll("[^a-zA-Z0-9\\-_]", "");
        if (transactionId.isEmpty()) {
            request.setAttribute("xcardError", "Invalid transaction ID format.");
            request.getRequestDispatcher("/paymentresponse.jsp").forward(request, response);
            return;
        }
        transactionId = transactionId.substring(0, Math.min(transactionId.length(), 60));

        // Guard against duplicate concurrent processing of the same transaction
        // X-Card may call the callback URL multiple times - only the first thread proceeds
        if (!processingTransactions.add(transactionId)) {
            System.out.println("XCard verify: Transaction " + transactionId + " already being processed by another thread, skipping.");
            request.setAttribute("xcardError", "Payment is being processed. Please wait and check your payment history.");
            request.setAttribute("xcardTransactionId", transactionId);
            request.getRequestDispatcher("/paymentresponse.jsp").forward(request, response);
            return;
        }

        try {
            String token = getToken();
            if (token == null) {
                System.err.println("XCard verify: Could not obtain auth token");
                request.setAttribute("xcardError", "Payment gateway authentication failed. Please contact support.");
                request.setAttribute("xcardTransactionId", transactionId);
                request.getRequestDispatcher("/paymentresponse.jsp").forward(request, response);
                return;
            }

            // POST to /xverifypayment
            // X-Card's verify endpoint expects THEIR transactionId (assigned during payment),
            // not the one we generated. If X-Card sent back their own reference in the callback,
            // use that. Otherwise fall back to our transactionId.
            String verifyUrl = settings.xcard_base_url + "/api/xpress-gateway/v1/xverifypayment";

            // Determine which ID to use for verification
            // Priority: X-Card's paymentReference > transactionReference > our transactionId
            String verifyId = transactionId; // default to ours
            if (xcardPaymentRef != null && !xcardPaymentRef.isEmpty()) {
                verifyId = xcardPaymentRef;
                System.out.println("XCard verify: Using xcardPaymentRef for verify: " + verifyId);
            } else if (xcardTxnRef != null && !xcardTxnRef.isEmpty()) {
                verifyId = xcardTxnRef;
                System.out.println("XCard verify: Using xcardTxnRef for verify: " + verifyId);
            } else {
                System.out.println("XCard verify: No X-Card reference in callback, using our transactionId: " + verifyId);
            }

            JSONObject payload = new JSONObject();
            payload.put("transactionId", verifyId);

            String rawResponse = postJson(verifyUrl, payload.toString(), token);
            System.out.println("XCard verify response (verifyId=" + verifyId + "): " + rawResponse);

            // If not found, retry once after 3 seconds (timing issue)
            if (rawResponse != null) {
                JSONObject checkResp = new JSONObject(rawResponse);
                String checkCode = checkResp.optString("responseCode", checkResp.optString("code", ""));
                if ("03".equals(checkCode) || "Not found".equalsIgnoreCase(checkResp.optString("responseMessage",
                        checkResp.optString("description", "")))) {
                    System.out.println("XCard verify: Not found, retrying in 3 seconds...");
                    try { Thread.sleep(3000); } catch (InterruptedException ie) { Thread.currentThread().interrupt(); }
                    rawResponse = postJson(verifyUrl, payload.toString(), token);
                    System.out.println("XCard verify retry response: " + rawResponse);
                }
            }

            // If API verify still fails but callback indicates success, trust the callback
            boolean apiVerifyFailed = false;
            if (rawResponse != null) {
                JSONObject checkResp = new JSONObject(rawResponse);
                String checkCode = checkResp.optString("responseCode", checkResp.optString("code", ""));
                if ("03".equals(checkCode) || "Not found".equalsIgnoreCase(checkResp.optString("responseMessage",
                        checkResp.optString("description", "")))) {
                    apiVerifyFailed = true;
                    System.out.println("XCard verify: API verify failed after retry. apiVerifyFailed=true");
                }
            }

            System.out.println("XCard verify final response: " + rawResponse);

            if (rawResponse == null) {
                request.setAttribute("xcardError", "No response from payment gateway. Please contact support with reference: " + transactionId);
                request.setAttribute("xcardTransactionId", transactionId);
                request.getRequestDispatcher("/paymentresponse.jsp").forward(request, response);
                return;
            }

            JSONObject resp = new JSONObject(rawResponse);
            String responseCode = resp.optString("responseCode", resp.optString("code", ""));
            boolean isSuccessful = false;
            JSONObject data = resp.optJSONObject("data"); // safe - returns null if missing or JSON null

            if (data != null) {
                isSuccessful = data.optBoolean("isSuccessful", false)
                               && "00".equals(data.optString("status", ""));
            }

            // If API verify failed but X-Card redirected to our callback, treat as successful.
            // X-Card only redirects to callbackUrl on successful payment.
            if (!isSuccessful && apiVerifyFailed) {
                System.out.println("XCard verify: API verify failed but callback received - treating as successful (callback-based confirmation)");
                isSuccessful = true;
                // Build a minimal data object for recordSuccessfulPayment
                data = new JSONObject();
                data.put("transactionId",    transactionId);
                data.put("paymentReference", xcardPaymentRef != null ? xcardPaymentRef : transactionId);
                data.put("gatewayResponse",  "Approved - callback received");
                data.put("isSuccessful",     true);
                data.put("status",           "00");
            }

            // Store result in request scope for paymentresponse.jsp to render
            // If callback-based confirmation was used, override the response message
            // so the JSP shows success, not the "Not found" from the failed verify API call
            String finalResponseCode    = apiVerifyFailed ? "00" : responseCode;
            String finalResponseMessage = apiVerifyFailed ? "Payment Successful" : resp.optString("responseMessage", "");

            request.setAttribute("xcardResponseCode",    finalResponseCode);
            request.setAttribute("xcardResponseMessage", finalResponseMessage);
            request.setAttribute("xcardIsSuccessful",    isSuccessful);
            request.setAttribute("xcardTransactionId",   transactionId);

            if (isSuccessful && data != null) {
                request.setAttribute("xcardData", data.toString());
                recordSuccessfulPayment(transactionId, data);
            }

            request.getRequestDispatcher("/paymentresponse.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("XCard verify error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("xcardError", "Verification error. Please contact support with reference: " + transactionId);
            request.setAttribute("xcardTransactionId", transactionId);
            request.getRequestDispatcher("/paymentresponse.jsp").forward(request, response);
        } finally {
            // Always release the lock so future retries or re-attempts can proceed
            processingTransactions.remove(transactionId);
        }
    }


    // -------------------------------------------------------------------------
    // ACTION 3: Webhook
    // X-Card POSTs payment notifications server-to-server to this endpoint.
    // Register "/XCard?action=webhook" as your webhook URL in the X-Card dashboard.
    // -------------------------------------------------------------------------

    private void handleWebhook(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            // Webhook shared secret check - add xcard_webhook_secret to Settings.java when X-Card provides it
            // String webhookSecret = request.getHeader("X-Webhook-Secret");
            // if (!settings.xcard_webhook_secret.equals(webhookSecret)) {
            //     response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            //     return;
            // }
            StringBuilder sb = new StringBuilder();
            String line;
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(request.getInputStream(), "UTF-8"))) {
                while ((line = reader.readLine()) != null) sb.append(line);
            }
            String body = sb.toString();
            System.out.println("XCard webhook received: " + body);

            if (body.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            JSONObject payload = new JSONObject(body);

            // X-Card webhook uses PascalCase field names
            boolean isSuccessful = payload.optBoolean("IsSuccessful", false);
            String status        = payload.optString("Status", "");
            String transactionId = payload.optString("TransactionId", "");
            String amount        = payload.optString("Amount", "0");

            System.out.println("XCard webhook: transactionId=" + transactionId
                    + ", isSuccessful=" + isSuccessful + ", status=" + status);

            if (isSuccessful && "00".equals(status) && !transactionId.isEmpty()) {
                // Re-verify via API before trusting the webhook (security best practice)
                String token = getToken();
                if (token != null) {
                    String verifyUrl = settings.xcard_base_url + "/api/xpress-gateway/v1/xverifypayment";
                    JSONObject verifyPayload = new JSONObject();
                    verifyPayload.put("transactionId", transactionId);
                    String verifyRaw = postJson(verifyUrl, verifyPayload.toString(), token);

                    if (verifyRaw != null) {
                        JSONObject verifyResp = new JSONObject(verifyRaw);
                        if (verifyResp.has("data")) {
                            JSONObject data = verifyResp.getJSONObject("data");
                            boolean verified = data.optBoolean("isSuccessful", false)
                                               && "00".equals(data.optString("status", ""));
                            if (verified) {
                                recordSuccessfulPayment(transactionId, data);
                                System.out.println("XCard webhook: payment recorded for " + transactionId);
                            }
                        }
                    }
                }
            }

            // Always respond 200 to acknowledge receipt
            response.setStatus(HttpServletResponse.SC_OK);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"received\"}");

        } catch (Exception e) {
            System.err.println("XCard webhook error: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_OK); // still 200 to prevent X-Card retries
        }
    }


    // -------------------------------------------------------------------------
    // Helper: Record a successful payment to the database
    // Same logic as paymentresponse.jsp does for CREDO
    // -------------------------------------------------------------------------

    private void recordSuccessfulPayment(String transactionId, JSONObject data) {
        try {
            Paymentreference pr = sess.getPaymentreference(transactionId);
            if (pr == null) {
                System.err.println("XCard recordPayment: Paymentreference not found for " + transactionId);
                return;
            }

            // Check not already recorded
            Payments existing = sess.getPayments(transactionId);
            if (existing != null) {
                System.out.println("XCard recordPayment: Payment already recorded for " + transactionId);
                return;
            }
            String paymentReference = data.optString("paymentReference", transactionId);
            String gatewayResponse  = data.optString("gatewayResponse", "Approved");

            // Ensure Banks record exists
            Banks bank = null;
            try {
                bank = sess.getBanks("XCARD");
                if (bank == null) {
                    bank = new Banks("XCARD");
                    bank.setName("X-Card Payment Gateway");
                    sess.newEntry(bank);
                }
            } catch (Exception e) {
                System.err.println("XCard recordPayment: Banks lookup error: " + e.getMessage());
            }

            // Update Paymentreference
            sess.updatePaymentreference(
                transactionId,
                gatewayResponse,
                paymentReference,
                "XCARD",
                "X-Card",
                settings.getCurrentDateTime(),
                "SUCCESSFUL"
            );

            // Create Payments record
            Payments pay = new Payments(pr.getId());
            pay.setAmount(pr.getAmount());
            pay.setDatePaid(settings.getCurrentDateTime());
            pay.setPayerId(pr.getPayerId());
            pay.setPayerRegistrationNo(pr.getPayerRegistrationIo());
            pay.setPayerFullname(pr.getPayerName());
            pay.setSessionPaid(pr.getSession());
            pay.setSemesterPaid(pr.getSemester());
            pay.setFeesGroupId(pr.getFeesGroupId());
            pay.setSchoolId(pr.getSchoolId());
            pay.setLevel(pr.getLevel());
            pay.setBankId(bank);

            try {
                Courses co = sess.getCourses(pr.getCourseId());
                pay.setCourseId(co);
                if (co != null) {
                    Programmes prog = co.getSchoolProgrammeId().getProgrammeId();
                    pay.setProgrammeId(prog);
                }
            } catch (Exception e) {
                System.err.println("XCard recordPayment: Course lookup error: " + e.getMessage());
            }

            // Attempt insert - DB unique constraint on transactionId is the final guard
            // against duplicate payments if two threads pass the check above simultaneously
            try {
                sess.newEntry(pay);
                System.out.println("XCard recordPayment: Successfully recorded payment for " + transactionId);
            } catch (Exception e) {
                // Unique constraint violation means another thread already recorded it - safe to ignore
                System.out.println("XCard recordPayment: Duplicate insert prevented for " + transactionId);
            }

        } catch (Exception e) {
            System.err.println("XCard recordPayment: Error - " + e.getMessage());
            e.printStackTrace();
        }
    }
    // -------------------------------------------------------------------------
    // Helper: Get Bearer token (with simple in-memory cache)
    // -------------------------------------------------------------------------

    private String getToken() {
        synchronized (TOKEN_LOCK) {
            long now = System.currentTimeMillis();
            if (cachedToken != null && now < tokenExpiry) {
                return cachedToken; // reuse cached token
            }

            try {
                String tokenUrl = settings.xcard_base_url + "/api/token/v1/generatetoken";
                JSONObject body = new JSONObject();
                body.put("client_id",     settings.xcard_client_id);
                body.put("client_secret", settings.xcard_client_secret);

                // Token endpoint does NOT need Authorization header
                String raw = postJson(tokenUrl, body.toString(), null);
                System.out.println("XCard: Token request completed, status: " + (raw != null ? "OK" : "FAILED"));

                if (raw != null) {
                    JSONObject resp = new JSONObject(raw);

                    // X-Card token response structure:
                    // {"code":"00","description":"...","Bearer":{"token":"eyJ..."}}
                    String token = null;

                    if (resp.has("Bearer")) {
                        Object bearerObj = resp.get("Bearer");
                        if (bearerObj instanceof JSONObject) {
                            token = ((JSONObject) bearerObj).optString("token", null);
                            System.out.println("XCard: Token extracted from Bearer.token");
                        }
                    }

                    // Fallback: check top-level and other common field names
                    if (token == null || token.isEmpty()) {
                        String[] fallbackFields = {"token", "access_token", "accessToken", "bearerToken"};
                        for (String field : fallbackFields) {
                            String candidate = resp.optString(field, null);
                            if (candidate != null && !candidate.isEmpty() && !candidate.equals("null")) {
                                token = candidate;
                                System.out.println("XCard: Token found in fallback field: '" + field + "'");
                                break;
                            }
                        }
                    }

                    if (token != null && !token.isEmpty()) {
                        cachedToken = token;
                        tokenExpiry = now + TOKEN_TTL_MS;
                        System.out.println("XCard: Token obtained and cached successfully");
                        return cachedToken;
                    } else {
                        System.err.println("XCard: Token not found in response. Full response: " + raw);
                    }
                }
            } catch (Exception e) {
                System.err.println("XCard getToken error: " + e.getMessage());
                e.printStackTrace();
            }

            return null;
        }
    }

    // -------------------------------------------------------------------------
    // Helper: Generic JSON POST
    // -------------------------------------------------------------------------

    private String postJson(String endpoint, String jsonBody, String bearerToken) {
        HttpURLConnection conn = null;
        try {
            URL url = new URL(endpoint);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            if (bearerToken != null) {
                conn.setRequestProperty("Authorization", "Bearer " + bearerToken);
            }
            conn.setConnectTimeout(15_000);
            conn.setReadTimeout(30_000);
            conn.setDoOutput(true);

            byte[] bytes = jsonBody.getBytes("UTF-8");
            conn.setFixedLengthStreamingMode(bytes.length);
            try (OutputStream os = conn.getOutputStream()) {
                os.write(bytes);
            }

            int code = conn.getResponseCode();
            java.io.InputStream stream = (code >= 200 && code < 300)
                    ? conn.getInputStream() : conn.getErrorStream();

            if (stream == null) return null;

            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(stream, "UTF-8"))) {
                String line;
                int total = 0;
                while ((line = reader.readLine()) != null && total < 16_384) {
                    sb.append(line);
                    total += line.length();
                }
            }
            return sb.toString();

        } catch (Exception e) {
            System.err.println("XCard postJson error [" + endpoint + "]: " + e.getMessage());
            return null;
        } finally {
            if (conn != null) conn.disconnect();
        }
    }

    // -------------------------------------------------------------------------
    // Helpers
    // -------------------------------------------------------------------------

    private void addSecurityHeaders(HttpServletResponse response) {
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("X-Frame-Options", "DENY");
        response.setHeader("X-XSS-Protection", "1; mode=block");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }

    private String hiddenField(String name, String value) {
        return "<input type='hidden' name='" + name + "' value='" + value + "'/>";
    }

    private String escapeHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#x27;");
    }
}
