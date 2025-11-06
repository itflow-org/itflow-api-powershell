# ITFlow API - PowerShell examples
# https://itflow.org

# Archive contact(s)

# API Key
$apiKey = "05438411f4fd492f"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Data
$body = @"
{
    "api_key" : "$apiKey",
    "contact_id" : "1074",
    "client_id" : "1017"
}
"@

# Module / Endpoint
$module = "/api/v1/contacts/archive.php"

# Build URI from defined data
$uri = $siteUrl + $module

# Request
# Use Invoke-WebRequest instead to see more info about the request/response
Invoke-RestMethod -Method Post -Uri $uri -Body $body
