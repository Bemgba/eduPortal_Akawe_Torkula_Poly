<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>UAST Ihugh - Predegree & Certificate Application</title>
    <link rel="stylesheet" href="resources/css/style.css">
</head>
<body>
    <div class="container">
        <h2 class="page-title">UAST Ihugh Admission Application Form</h2>

        <form class="form-box">

            <!-- Programme Information -->
            <div class="form-section">
                <h3 class="section-title">Programme Information</h3>

                <label for="programmeType">Programme Type</label>
                <select id="programmeType" name="programmeType">
                    <option>Pre-Degree</option>
                    <option>JUPEB</option>
                    <option>Certificate Course</option>
                </select>

                <label for="programmeCategory">Programme Category</label>
                <select id="programmeCategory" name="programmeCategory">
                    <option>Agriculture</option>
                    <option>Health</option>
                    <option>IT & Digital</option>
                    <option>Technical Skills</option>
                    <option>Science & Technology</option>
                </select>

                <label for="courseTitle">Course Title</label>
                <input type="text" id="courseTitle" name="courseTitle" placeholder="E.g., Artificial Intelligence and Machine Learning">
            </div>

            <!-- Personal Information -->
            <div class="form-section">
                <h3 class="section-title">Personal Information</h3>

                <label for="surname">Surname</label>
                <input type="text" id="surname" name="surname">

                <label for="firstName">First Name</label>
                <input type="text" id="firstName" name="firstName">

                <label for="middleName">Middle Name</label>
                <input type="text" id="middleName" name="middleName">

                <label for="gender">Gender</label>
                <select id="gender" name="gender">
                    <option>Male</option>
                    <option>Female</option>
                    <option>Non-Binary</option>
                    <option>Prefer Not to Say</option>
                </select>

                <label for="dob">Date of Birth</label>
                <input type="date" id="dob" name="dob">

                <label for="nationality">Nationality</label>
                <input type="text" id="nationality" name="nationality">
            </div>

            <!-- Contact Information -->
            <div class="form-section">
                <h3 class="section-title">Contact Information</h3>

                <label for="phone">Mobile Number</label>
                <input type="text" id="phone" name="phone">

                <label for="email">Email Address</label>
                <input type="email" id="email" name="email">

                <label for="address">Home Address</label>
                <textarea id="address" name="address" rows="3"></textarea>
            </div>

            <!-- Educational Background -->
            <div class="form-section">
                <h3 class="section-title">Educational Background</h3>

                <label for="qualification">Highest Qualification</label>
                <select id="qualification" name="qualification">
                    <option>WAEC</option>
                    <option>NECO</option>
                    <option>OND</option>
                    <option>NCE</option>
                    <option>HND</option>
                    <option>B.Sc.</option>
                </select>

                <label for="institution">Institution Attended</label>
                <input type="text" id="institution" name="institution">

                <label for="certificateUpload">Upload Certificate</label>
                <input type="file" id="certificateUpload" name="certificateUpload">
            </div>

            <!-- Payment Information -->
            <div class="form-section">
                <h3 class="section-title">Payment Information</h3>

                <label for="amountPaid">Amount Paid</label>
                <input type="text" id="amountPaid" name="amountPaid">

                <label for="paymentMethod">Payment Method</label>
                <select id="paymentMethod" name="paymentMethod">
                    <option>Bank Transfer</option>
                    <option>Remita</option>
                    <option>POS</option>
                </select>

                <label for="transactionRef">Transaction Reference</label>
                <input type="text" id="transactionRef" name="transactionRef">

                <label for="paymentProof">Upload Evidence of Payment</label>
                <input type="file" id="paymentProof" name="paymentProof">
            </div>

            <!-- Declaration -->
            <div class="form-section">
                <h3 class="section-title">Declaration</h3>
                <label>
                    <input type="checkbox" name="declaration">
                    I declare that the information provided is true and correct.
                </label>
            </div>

            <!-- Submit Button -->
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Submit Application</button>
            </div>

        </form>
    </div>
</body>
</html>
