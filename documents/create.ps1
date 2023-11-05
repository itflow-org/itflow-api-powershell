# ITFlow API - PowerShell examples
# https://itflow.org

# Create documents(s)

# API Key
$apiKey = "a1wEoh1F3omPhea6"


# Base site URL
$siteUrl = "https://demo.itflow.org"

# Data
$body = @"
{
    "api_key" : "$apiKey",
    "document_name" : "My example document",
    "document_description" : "Initial add",
    "document_content" : "This is an <b>example</b> document",
    "client_id" : "10"
}
"@

# Module / Endpoint
$module = "/api/v1/documents/create.php"

# Build URI from defined data
$uri = $siteUrl + $module

# Request
# Use Invoke-WebRequest instead to see more info about the request/response
Invoke-RestMethod -Method Post -Uri $uri -Body $body

