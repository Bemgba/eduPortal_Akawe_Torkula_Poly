/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.spec.AlgorithmParameterSpec;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.KeySpec;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Random;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.PBEParameterSpec;

import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import javax.imageio.ImageIO;

/**
 *
 * @author eaglescan
 */
public class Settings {

    public final String productName = "ATPOLY Portal";
    public final String fullName = "Akawe Torkula Polytechnic, MAKURDI";
    public final String universityName = "Akawe Torkula Polytechnic, MAKURDI";
    public final String universityAddress = "P.M.B. 102211,MAKURDI, Nigeria";
    public java.text.NumberFormat formatno = new java.text.DecimalFormat("###,###,###,###,###,###,###,###.00");
    public java.text.NumberFormat formatnoNoComma = new java.text.DecimalFormat("########################.00");
    public final int PASSPORT_HEIGHT = 151;
    public final int PASSPORT_WIDTH = 132;
    public int indigeneStateCode = 10035;
    public String logo = "assets/img/Akawe.png";
    public String chslogo = "assets/img/Akawe.png";
    public String inceptionDate = "2024-01-01";
    public String softwareInitialDate = "2025-12-13";
    //public String baseurl = "https://portal.atpoly.edu.ng/";
    public String baseurl = "http://localhost:8082"; // Development URL - commented out for production
    public String docUrl = baseurl + "/u12356";
    public String institutionDomain = "atpoly.edu.ng";

    //String home = System.getProperty("user.home");
    public String documentroot = "/home/jux1235";
    public String home = documentroot;
    public String backupFolder = documentroot + "/backups";
    public String db = "";
    public String dbuser = "admin";
    public String dbpw = "Jacob4Percy";

    ////Old epayment
    //customized for CHS
    public String chs_pay_item_id = "101";
    public String chs_product_id = "6207";
    public String chs_quickteller_url = "https://www.quickteller.com/chsbsu";
    public String chs_mac_key = "CEF793CBBE838AA0CBB29B74D571113B4EA6586D3BA77E7CFA0B95E278364EFC4526ED7BD255A366CDDE11F1F607F0F844B09D93B16F7CFE87563B2272007AB3";

// CREDO Configuration
// PRODUCTION: Using LIVE CREDO credentials for production deployment
    public String credo_base_url = "https://api.credocentral.com"; // LIVE CREDO API endpoint
//public String credo_base_url = "https://api.credodemo.com"; //DEMO CREDO API endpoint

    public String credo_public_key = "1PUB8219Jc1oqhAO5PYXXjt5Pt1gFfUiR24hP5"; // LIVE public key
    public String credo_secret_key = "1PRI8219uAVj0Q0tk60gzR79d3MdSzpq4pf88K"; // LIVE secret key
    //public String credo_public_key = "0PUB1712z6bdFg2fM9ra7zR5QLJwc0yE"; // Demo public key
    //public String credo_secret_key = "0PRI1712yqS1kE2Py2yxJBy75CpEqMdu"; // Demo secret key
// 

    public String credo_webhook_token = "wehok-token"; // PRODUCTION: Replace with live webhook token
    public String credo_business_code = "business-code"; // PRODUCTION: Replace with live business code

// Update existing variables to point to LIVE CREDO:
// PRODUCTION: URLs now point to live CREDO endpoints for production deployment
    public String quickteller_url = "https://api.credocentral.com"; // LIVE CREDO API endpoint
    public String interswitch_url = "https://api.credocentral.com/transaction/initialize"; // LIVE CREDO transaction endpoint
    public String interswitch_query_url = "https://api.credocentral.com/transaction/verify"; // LIVE CREDO verification endpoint

// X-Card Gateway Configuration (Resident Fintech)
    public String xcard_base_url = "https://devints.residentfintech.com"; // DEV/INT - replace with production URL when live
    public String xcard_client_id = "resident"; //TODO: Set your X-Card client_id
    public String xcard_client_secret = "resident"; //TODO: Set your X-Card client_secret
    public String xcard_product_id = "PROD001"; //TODO: Set your product ID
    public String xcard_mode = "live"; //"live" or "test"

// Map CREDO credentials to existing variable names for compatibility:
    public String product_id = credo_public_key; // Map public key to product_id
    public String mac_key = credo_secret_key; // Map secret key to mac_key
    public String pay_item_id = credo_business_code; // Map business code to pay_item_id

    public String utmeEngId = "1001";
    public String olEngId = "s53003";
    public String olMathId = "s77380";
    public String listSession = "2025/2026";

    public String admissionChecking = "ADMISSION CHECKING";
    public String acceptanceLetter = "ACCEPTANCE LETTER";
    public String defermentName = "DEFERMENT FEES";
    public String summerscholregFee = "SUMMER SEMESTER FEES";
    public String summerscholappFee = "SUMMER SEMESTER REGISTRATION";
    /////////////////
    private Matcher matcher;
    private final String DOMAIN_NAME_PATTERN
            = "([a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?\\.)+[a-zA-Z]{2,15}";
    private Pattern patrn = Pattern.compile(DOMAIN_NAME_PATTERN);

    String secretKey = "ATPOLY202413";

    Cipher ecipher;
    Cipher dcipher;
    // 8-byte Salt
    byte[] salt = {
        (byte) 0xA9, (byte) 0x9B, (byte) 0xC8, (byte) 0x32,
        (byte) 0x56, (byte) 0x35, (byte) 0xE3, (byte) 0x03
    };
    // Iteration count
    int iterationCount = 19;

    public Settings() {

    }

    public int getCurrentYear() {
        int year = 2024;
        try {
            year = Integer.parseInt(inceptionDate.split("-")[0]);
        } catch (NumberFormatException j) {
        }
        try {
            java.util.Calendar cal = new java.util.GregorianCalendar();
            year = cal.get(GregorianCalendar.YEAR);
        } catch (Exception j) {
        }

        return year;
    }

    public String[] getYears() {
        int startyear = 2012;
        try {
            startyear = Integer.parseInt(inceptionDate.split("-")[0]);
        } catch (NumberFormatException j) {
        }
        int endyear = getCurrentYear();
        int diff = endyear - startyear;

        String[] sessions = new String[diff];
        for (int i = 0; i < diff; i++) {
            sessions[i] = endyear + "";
            endyear--;
        }

        return sessions;
    }

    public String generateId(String prefix, int size) {
        String pin;
        Random ra = new Random();
        long l1 = ra.nextLong() % 100000000;
        if (l1 < 0) {
            l1 = (-1) * l1;
        }
        long l2 = ra.nextLong() % 100000000;
        if (l2 < 0) {
            l2 = (-1) * l2;
        }
        long l3 = ra.nextLong() % 100000000;
        if (l3 < 0) {
            l3 = (-1) * l3;
        }
        long l4 = ra.nextLong() % 100000000;
        if (l4 < 0) {
            l4 = (-1) * l4;
        }

        String f = Long.toString(l1) + Long.toString(l2) + Long.toString(l3) + Long.toString(l4);
        String cor = "1234567890987654321123456789";
        pin = (prefix + f + cor).substring(0, size);
        return pin;
    }

    public String getTodaysdate() {
        String month1;
        String day1;
        java.util.Calendar cal = new java.util.GregorianCalendar();
        int year = cal.get(GregorianCalendar.YEAR);
        int month = (cal.get(GregorianCalendar.MONTH) + 1);
        int day = cal.get(GregorianCalendar.DATE);
        if (Integer.toString(month).length() < 2) {
            month1 = "0" + month;
        } else {
            month1 = month + "";
        }
        if (Integer.toString(day).length() < 2) {
            day1 = "0" + day;
        } else {
            day1 = day + "";
        }

        String TODAY = year + "-" + month1 + "-" + day1;
        return TODAY;
    }

    public long getDaysBetweenDates(String fromDate, String toDate) {
        long days = 0;
        try {
            LocalDate dateBefore = LocalDate.parse(fromDate);
            LocalDate dateAfter = LocalDate.parse(toDate);

            days = ChronoUnit.DAYS.between(dateBefore, dateAfter);
        } catch (Exception k) {
        }
        return days;
    }

    public String getFirstDateOfWeek(String currentdate) {
        String date = currentdate;
        try {
            LocalDate cDate = LocalDate.parse(currentdate);
            DayOfWeek dow = cDate.getDayOfWeek();
            int point = dow.getValue();

            int prev = point - 1;

            date = getDateBefore(currentdate, prev);
        } catch (Exception k) {
        }
        return date;
    }

    public String getDateAhead(String currentDate, long no) {
        String newdate = currentDate;
        try {
            LocalDate cDate = LocalDate.parse(currentDate);
            cDate = cDate.plusDays(no);
            newdate = cDate.toString();
        } catch (Exception k) {
        }
        return newdate;
    }

    public String getDateBefore(String currentDate, long no) {
        String newdate = currentDate;
        try {
            LocalDate cDate = LocalDate.parse(currentDate);
            cDate = cDate.minusDays(no);
            newdate = cDate.toString();
        } catch (Exception k) {
        }
        return newdate;
    }

    public String getCurrentTime() {
        String hr1;
        String min1;
        String sec1;
        java.util.Calendar cal = new java.util.GregorianCalendar();
        int hr = cal.get(GregorianCalendar.HOUR_OF_DAY);
        int min = cal.get(GregorianCalendar.MINUTE);
        int sec = cal.get(GregorianCalendar.SECOND);
        if (Integer.toString(hr).length() < 2) {
            hr1 = "0" + hr;
        } else {
            hr1 = hr + "";
        }
        if (Integer.toString(min).length() < 2) {
            min1 = "0" + min;
        } else {
            min1 = min + "";
        }
        if (Integer.toString(sec).length() < 2) {
            sec1 = "0" + sec;
        } else {
            sec1 = sec + "";
        }

        String TIME = hr1 + ":" + min1 + ":" + sec1;
        return TIME;
    }

    public double Round(double number, int decimalPlaces) {
        double modifier = Math.pow(10.0, decimalPlaces);
        return Math.round(number * modifier) / modifier;
    }

    public String getMD5(String str) {
        String co = str;
        MessageDigest md;
        try {
            md = MessageDigest.getInstance("MD5");
            byte[] pb = str.getBytes();
            md.reset();
            byte[] dbx = md.digest(pb);
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < dbx.length; i++) {
                sb.append(Integer.toHexString(0xff & dbx[i]));
            }
            co = sb.toString();
        } catch (NoSuchAlgorithmException j) {
        }
        return co;
    }

    public String toCamelCase(String inputString) {
        String result = "";
        if (inputString.length() == 0) {
            return result;
        }
        char firstChar = inputString.charAt(0);
        char firstCharToUpperCase = Character.toUpperCase(firstChar);
        result = result + firstCharToUpperCase;
        for (int i = 1; i < inputString.length(); i++) {
            char currentChar = inputString.charAt(i);
            char previousChar = inputString.charAt(i - 1);
            if (previousChar == ' ') {
                char currentCharToUpperCase = Character.toUpperCase(currentChar);
                result = result + currentCharToUpperCase;
            } else {
                char currentCharToLowerCase = Character.toLowerCase(currentChar);
                result = result + currentCharToLowerCase;
            }
        }
        return result;
    }

    public String generateId() {
        UUID uid = UUID.randomUUID();
        String id = String.valueOf(uid).replaceAll("-", "");
        return id;
    }

    public String getMonthName(String code) {
        String mo = "";
        if (code.equalsIgnoreCase("01")) {
            mo = "January";
        }
        if (code.equalsIgnoreCase("02")) {
            mo = "February";
        }
        if (code.equalsIgnoreCase("03")) {
            mo = "March";
        }
        if (code.equalsIgnoreCase("04")) {
            mo = "April";
        }
        if (code.equalsIgnoreCase("05")) {
            mo = "May";
        }
        if (code.equalsIgnoreCase("06")) {
            mo = "June";
        }
        if (code.equalsIgnoreCase("07")) {
            mo = "July";
        }
        if (code.equalsIgnoreCase("08")) {
            mo = "August";
        }
        if (code.equalsIgnoreCase("09")) {
            mo = "September";
        }
        if (code.equalsIgnoreCase("10")) {
            mo = "October";
        }
        if (code.equalsIgnoreCase("11")) {
            mo = "November";
        }
        if (code.equalsIgnoreCase("12")) {
            mo = "December";
        }
        mo = mo.toUpperCase();

        return mo;
    }

    public String getMonthNameShort(String code) {
        String mo = "";
        if (code.equalsIgnoreCase("01")) {
            mo = "Jan";
        }
        if (code.equalsIgnoreCase("02")) {
            mo = "Feb";
        }
        if (code.equalsIgnoreCase("03")) {
            mo = "Mar";
        }
        if (code.equalsIgnoreCase("04")) {
            mo = "Apr";
        }
        if (code.equalsIgnoreCase("05")) {
            mo = "May";
        }
        if (code.equalsIgnoreCase("06")) {
            mo = "Jun";
        }
        if (code.equalsIgnoreCase("07")) {
            mo = "Jul";
        }
        if (code.equalsIgnoreCase("08")) {
            mo = "Aug";
        }
        if (code.equalsIgnoreCase("09")) {
            mo = "Sep";
        }
        if (code.equalsIgnoreCase("10")) {
            mo = "Oct";
        }
        if (code.equalsIgnoreCase("11")) {
            mo = "Nov";
        }
        if (code.equalsIgnoreCase("12")) {
            mo = "Dec";
        }
        mo = mo.toUpperCase();

        return mo;
    }

    public static String formatDays(long days) {
        days = Math.abs(days);
        String com = "";
        try {
            long months = days / 30;
            days = days % 30;
            long years = months / 12;
            months = months % 12;
            if (years == 0) {
                if (months == 0) {
                    com = days + " Dys";
                } else {
                    com = months + " Mths, " + days + " Dys";
                }
            } else {
                com = years + " Yrs, " + months + " Mths, " + days + " Dys";
            }
        } catch (Exception j) {
        }
        return com;
    }

    public String encryptText(String plainText) {
        //Key generation for enc and desc
        String encStr = null;
        try {
            KeySpec keySpec = new PBEKeySpec(secretKey.toCharArray(), salt, iterationCount);
            SecretKey key = SecretKeyFactory.getInstance("PBEWithMD5AndDES").generateSecret(keySpec);
            // Prepare the parameter to the ciphers
            AlgorithmParameterSpec paramSpec = new PBEParameterSpec(salt, iterationCount);

            //Enc process
            ecipher = Cipher.getInstance(key.getAlgorithm());
            ecipher.init(Cipher.ENCRYPT_MODE, key, paramSpec);
            String charSet = "UTF-8";
            byte[] in = plainText.getBytes(charSet);
            byte[] out = ecipher.doFinal(in);
            encStr = new String(Base64.getEncoder().encode(out));
        } catch (UnsupportedEncodingException | InvalidAlgorithmParameterException | InvalidKeyException | NoSuchAlgorithmException | InvalidKeySpecException | BadPaddingException | IllegalBlockSizeException | NoSuchPaddingException e) {

        }
        return encStr;
    }

    public String decryptText(String encryptedText) {
        //Key generation for enc and desc
        String plainStr = null;
        try {
            KeySpec keySpec = new PBEKeySpec(secretKey.toCharArray(), salt, iterationCount);
            SecretKey key = SecretKeyFactory.getInstance("PBEWithMD5AndDES").generateSecret(keySpec);
            // Prepare the parameter to the ciphers
            AlgorithmParameterSpec paramSpec = new PBEParameterSpec(salt, iterationCount);
            //Decryption process; same key will be used for decr
            dcipher = Cipher.getInstance(key.getAlgorithm());
            dcipher.init(Cipher.DECRYPT_MODE, key, paramSpec);
            byte[] enc = Base64.getDecoder().decode(encryptedText);
            byte[] utf8 = dcipher.doFinal(enc);
            String charSet = "UTF-8";
            plainStr = new String(utf8, charSet);
        } catch (UnsupportedEncodingException | InvalidAlgorithmParameterException | InvalidKeyException | NoSuchAlgorithmException | InvalidKeySpecException | BadPaddingException | IllegalBlockSizeException | NoSuchPaddingException j) {
        }
        return plainStr;
    }

    public String encodeUrl(String value) {
        String v = value;
        try {
            v = URLEncoder.encode(value, StandardCharsets.UTF_8.toString());
        } catch (UnsupportedEncodingException j) {
        }
        return v;
    }

    public String decodeUrl(String value) {
        String v = value;
        try {
            v = URLDecoder.decode(value, StandardCharsets.UTF_8.toString());
        } catch (UnsupportedEncodingException j) {
        }
        return v;
    }

    public String generateEmailBody(String text) {
        String body = null;
        try {
            StringBuilder sb = new StringBuilder();
            sb.append("<html><head><title>" + productName + "</title><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">");
            sb.append("<style>a {color: #007CC7; text-decoration: none;} a:hover {color: #0b0b0b;text-decoration: underline;}</style>");
            sb.append("</head><body><div style=\"border: 10px solid #EEE; padding: 10px; width: 60%\"><div><img src=\"").append(baseurl).append("/").append(logo).append("\" style=\"height:50px; width:auto\" alt=\"" + productName + "\"/>");
            sb.append("</div><div>");
            sb.append(text);
            sb.append("<br/><br/><br/><a href=\"").append(baseurl).append("/index.jsp\">Click here to visit site</a></div></div></body></html>");

            body = sb.toString();
        } catch (Exception j) {
        }
        return body;
    }

    public EmailSettings convertLinestoObject(List<String> lines) {
        EmailSettings obj = null;
        try {
            if (lines.size() >= 4) {
                obj = new EmailSettings(lines.get(0).split("::")[1], lines.get(1).split("::")[1], lines.get(2).split("::")[1], lines.get(3).split("::")[1]);
            }
        } catch (Exception k) {
        }
        return obj;
    }

    public Date getCurrentDateTime() {
        Date date = null;
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        try {
            date = simpleDateFormat.parse(this.getTodaysdate() + " " + this.getCurrentTime());
        } catch (ParseException k) {
        }
        return date;

    }

    public static String generateHash512(String target) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-512");
            md.update(target.getBytes());

            byte byteData[] = md.digest();

            //convert the byte to hex format method 1
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < byteData.length; i++) {
                sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
            }
            return sb.toString().toUpperCase();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }

    public String formatDate(Date date) {
        if (date == null) {
            return "";
        }
        String sdate = date.toString();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            sdate = sdf.format(date);
        } catch (Exception k) {
        }

        return sdate;
    }

    public String getRegistrationStatusLabel(String code) {
        String label = code;
        if (code.equalsIgnoreCase("0")) {
            label = "PENDING";
        }
        if (code.equalsIgnoreCase("1")) {
            label = "REGISTERED";
        }
        if (code.equalsIgnoreCase("2")) {
            label = "RESULT POSTED";
        }
        if (code.equalsIgnoreCase("3")) {
            label = "DEPARTMENT APPROVAL";
        }
        if (code.equalsIgnoreCase("4")) {
            label = "FACULTY APPROVAL";
        }
        if (code.equalsIgnoreCase("5")) {
            label = "SENATE APPROVAL";
        }
        if (code.equalsIgnoreCase("6")) {
            label = "VC APPROVAL";
        }

        return label;
    }

    public String getSessionBefore(String session) {
        String sess = session;
        try {
            String[] se = session.split("/");
            int i = Integer.parseInt(se[0]);
            int pre = i - 1;
            sess = pre + "/" + i;
        } catch (NumberFormatException k) {
        }
        return sess;
    }

    public String getSessionAfter(String session) {
        String sess = session;
        try {
            String[] se = session.split("/");
            int i = Integer.parseInt(se[1]);
            int post = i + 1;
            sess = i + "/" + post;
        } catch (NumberFormatException k) {
        }
        return sess;
    }

    public List<String> getSessionsBefore(String session, int no) {
        List<String> sess = new ArrayList();
        sess.add(session);
        try {
            for (int i = 0; i < no; i++) {
                session = getSessionBefore(session);
                sess.add(session);
            }
        } catch (Exception k) {
        }
        return sess;
    }

    public void resizeImage(byte[] imageBytes, int width, int height, String outputFilePath) {
        try {
            ByteArrayInputStream bais = new ByteArrayInputStream(imageBytes);
            BufferedImage originalImage = ImageIO.read(bais);
            BufferedImage resizedImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
            Graphics2D g2d = resizedImage.createGraphics();
            g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
            g2d.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
            g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            g2d.drawImage(originalImage.getScaledInstance(width, height, Image.SCALE_SMOOTH), 0, 0, null);
            g2d.dispose();
            File outputFile = new File(outputFilePath);
            if (!outputFile.getParentFile().exists()) {
                outputFile.getParentFile().mkdirs(); // Create directories if they don't exist
            }
            ImageIO.write(resizedImage, "png", outputFile);

        } catch (IOException e) {
        }
    }

    public String INterswitchIPs() {
        String ips = "41.223.145.174;154.72.34.174;154.68.226.14";
        //41.223.145.177, 41.223.145.235 Interswitch Test IP
        //10.10.6.89 is my own IP
        //41.223.145.174;154.72.34.174 Interswitch Live IP

        return ips;
    }

    public String generateExamcardNumber(String matno, String currSemester) {
        String examNo = matno;
        try {
            String code;

            //get current semester
            //String currSemester = "Second";
            if (currSemester.equalsIgnoreCase("First")) {
                code = "FSE/";
            } else {
                code = "SSE/";
            }
            try {
                int position = matno.lastIndexOf("/") + 1;
                examNo = matno.substring(0, position) + code + matno.substring(position);
            } catch (Exception fc) {
                examNo = code + matno;
            }

        } catch (Exception ex) {
        }
        return examNo;
    }

    public String getExamCardSignatures(String schoolid) {
        String signatures = "";
        try {
            if (schoolid.equalsIgnoreCase("S001")
                    || schoolid.equalsIgnoreCase("S003")) {
                //Main uni and CHS
                signatures = baseurl + "/" + "assets/img/signatures/acdm_offc.jpg";
            } else if (schoolid.equalsIgnoreCase("S002")) {
                //Postgraduate school
                signatures = baseurl + "/" + "assets/img/signatures/pg_sec.jpg";
            } else if (schoolid.equalsIgnoreCase("S004")) {
                signatures = baseurl + "/" + "assets/img/signatures/cce_dir.jpg";
            } else if (schoolid.equalsIgnoreCase("S005")) {
                signatures = baseurl + "/" + "assets/img.signatures/cefter_sec.jpg";
            } else {
                signatures = baseurl + "/" + "assets/img/signatures/acdm_offc.jpg";
            }
        } catch (Exception hg) {
        }
        return signatures;
    }

    public List<String> getemploymentTypes() {
        List<String> types = new ArrayList();
        types.add("Full Time");
        types.add("Contract");
        return types;
    }

    public List<String> getsalaryGrade() {
        List<String> types = new ArrayList();
        types.add("CONPCASS I");
        types.add("CONPCASS II");
        types.add("CONTEDISS I");
        types.add("CONTEDISS II");
        return types;
    }

    public void postPaymentStatus(String id, boolean status) {
        try {
            UnsafeTrustManager.disableCertificateValidation();
            URL url = new URL(baseurl + "/ConfirmPaymentStatus");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/json");
            String jsonInputString = "{\"paymentRef\":\"" + id + "\",\"status\":" + status + "}";
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonInputString.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            // Check the response code
            int responseCode = conn.getResponseCode();

            // Optional: Read the response
            try (var reader = new java.io.BufferedReader(
                    new java.io.InputStreamReader(conn.getInputStream(), "utf-8"))) {
                StringBuilder response = new StringBuilder();
                String responseLine;
                while ((responseLine = reader.readLine()) != null) {
                    response.append(responseLine.trim());
                }
            }

        } catch (Exception k) {
            k.printStackTrace();
        }
    }

}
