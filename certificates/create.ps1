# ITFlow API - PowerShell examples
# https://itflow.org

# Create certificate(s)

# API Key
$apiKey = "05438411f4fd492f"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Data
$body = @"
{
    "api_key" : "$apiKey",
    "certificate_name" : "Contoso Website",
    "certificate_description" : "Consultancy web ssl",
    "certificate_domain" : "example.com",
    "certificate_issued_by" : "Acme",
    "certificate_expire" : "2025-10-10",
    "certificate_public_key" : "",
    "certificate_notes" : "New cert",
    "certificate_domain_id" : "0",
    "client_id" : "1017"
}
"@

# Module / Endpoint
$module = "/api/v1/certificates/create.php"

# Build URI from defined data
$uri = $siteUrl + $module

# Request
# Use Invoke-WebRequest instead to see more info about the request/response
Invoke-RestMethod -Method Post -Uri $uri -Body $body
