<%@page import="com.mnl.eduportal.util.ServiceCodeUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Service Code Test - CREDO Integration (School-Based)</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .test-section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .special { background-color: #e8f5e8; }
        .default { background-color: #f0f8ff; }
        .code { font-family: monospace; background-color: #f5f5f5; padding: 2px 5px; }
    </style>
</head>
<body>
    <h1>CREDO Service Code Test Page (School-Based Logic)</h1>
    <p>This page demonstrates the hardcoded service code logic for school-specific bank routing.</p>
    
    <div class="test-section special">
        <h3>Special School (S001)</h3>
        <p><strong>Business Rule:</strong> School S001 uses special service code</p>
        
        <h4>School S001:</h4>
        <ul>
            <li>Service Code: <span class="code"><%= ServiceCodeUtil.getServiceCodeForSchool("S001") %></span></li>
            <li>Bank ID: <span class="code"><%= ServiceCodeUtil.getBankIdForSchool("S001") %></span></li>
            <li>Is Special: <span class="code"><%= ServiceCodeUtil.isSpecialSchool("S001") %></span></li>
            <li>Description: <span class="code"><%= ServiceCodeUtil.getServiceCodeDescription("S001") %></span></li>
        </ul>
    </div>
    
    <div class="test-section default">
        <h3>Default Schools (All Others)</h3>
        <p><strong>Business Rule:</strong> All other schools use default service code</p>
        
        <h4>School S002 (Example):</h4>
        <ul>
            <li>Service Code: <span class="code"><%= ServiceCodeUtil.getServiceCodeForSchool("S002") %></span></li>
            <li>Bank ID: <span class="code"><%= ServiceCodeUtil.getBankIdForSchool("S002") %></span></li>
            <li>Is Special: <span class="code"><%= ServiceCodeUtil.isSpecialSchool("S002") %></span></li>
            <li>Description: <span class="code"><%= ServiceCodeUtil.getServiceCodeDescription("S002") %></span></li>
        </ul>
        
        <h4>School S003 (Example):</h4>
        <ul>
            <li>Service Code: <span class="code"><%= ServiceCodeUtil.getServiceCodeForSchool("S003") %></span></li>
            <li>Bank ID: <span class="code"><%= ServiceCodeUtil.getBankIdForSchool("S003") %></span></li>
            <li>Is Special: <span class="code"><%= ServiceCodeUtil.isSpecialSchool("S003") %></span></li>
            <li>Description: <span class="code"><%= ServiceCodeUtil.getServiceCodeDescription("S003") %></span></li>
        </ul>
        
        <h4>School ENGR (Example):</h4>
        <ul>
            <li>Service Code: <span class="code"><%= ServiceCodeUtil.getServiceCodeForSchool("ENGR") %></span></li>
            <li>Bank ID: <span class="code"><%= ServiceCodeUtil.getBankIdForSchool("ENGR") %></span></li>
            <li>Is Special: <span class="code"><%= ServiceCodeUtil.isSpecialSchool("ENGR") %></span></li>
            <li>Description: <span class="code"><%= ServiceCodeUtil.getServiceCodeDescription("ENGR") %></span></li>
        </ul>
        
        <h4>Null School (Default):</h4>
        <ul>
            <li>Service Code: <span class="code"><%= ServiceCodeUtil.getServiceCodeForSchool(null) %></span></li>
            <li>Bank ID: <span class="code"><%= ServiceCodeUtil.getBankIdForSchool(null) %></span></li>
            <li>Is Special: <span class="code"><%= ServiceCodeUtil.isSpecialSchool(null) %></span></li>
            <li>Description: <span class="code"><%= ServiceCodeUtil.getServiceCodeDescription(null) %></span></li>
        </ul>
    </div>
    
    <div class="test-section">
        <h3>Implementation Summary</h3>
        <ul>
            <li><strong>Special Service Code:</strong> <span class="code">008219RFI2DJ</span> (for school S001)</li>
            <li><strong>Default Service Code:</strong> <span class="code">0082192DLY7O</span> (for all other schools)</li>
            <li><strong>Logic Location:</strong> <span class="code">ServiceCodeUtil.java</span></li>
            <li><strong>Integration Point:</strong> <span class="code">Etranzact2.java</span> servlet</li>
            <li><strong>Database Impact:</strong> Minimal - only adds service_code column to banks table</li>
        </ul>
    </div>
    
    <div class="test-section">
        <h3>How It Works (School-Based)</h3>
        <ol>
            <li>Payment is initiated via Etranzact2 servlet</li>
            <li>Servlet determines school ID from:
                <ul>
                    <li>Payment reference school relationship</li>
                    <li>Programme → Schoolprogrammes → School relationship</li>
                    <li>Session attribute SCHOOL_ID</li>
                </ul>
            </li>
            <li>ServiceCodeUtil.getServiceCodeForSchool() applies hardcoded logic</li>
            <li>Appropriate service code is included in CREDO API call</li>
            <li>CREDO routes payment to corresponding bank account</li>
            <li>Payment reference is updated with correct bank information</li>
        </ol>
    </div>
    
    <div class="test-section">
        <h3>School-Programme Relationship</h3>
        <p>The system now correctly traces the relationship:</p>
        <ul>
            <li><strong>Programme</strong> → offered in multiple schools</li>
            <li><strong>Schoolprogrammes</strong> → links programme to specific school</li>
            <li><strong>School</strong> → determines which bank account to use</li>
            <li><strong>Service Code</strong> → routes payment to correct account</li>
        </ul>
        <p><em>Example: Computer Science programme offered in School S001 → payments go to special account</em></p>
        <p><em>Example: Computer Science programme offered in School S002 → payments go to default account</em></p>
    </div>
</body>
</html>