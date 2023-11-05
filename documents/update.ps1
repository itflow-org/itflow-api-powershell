# ITFlow API - PowerShell examples
# https://itflow.org

# Update documents(s)

# API Key
$apiKey = "a1wEoh1F3omPhea6"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Data
$body = @"
{
    "api_key" : "$apiKey",
    "document_id" : "42",
    "document_name" : "Test doc",
    "document_description" : "Updated via API",
    "document_content" : "I updated this test doc via the API!!",
    "client_id" : "1"
}
"@

# Module / Endpoint
$module = "/api/v1/documents/update.php"

# Build URI from defined data
$uri = $siteUrl + $module

# Request
# Use Invoke-WebRequest instead to see more info about the request/response
Invoke-RestMethod -Method Post -Uri $uri -Body $body

