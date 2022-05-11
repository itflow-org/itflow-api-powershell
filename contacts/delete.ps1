# ITFlow API - PowerShell examples
# https://itflow.org

# Delete contact

# API Key
$apiKey = "6j6vczwbONUt4JQZ"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Data
# Contact ID to delete
# Client ID is required if the API key used has scope/access to all clients 
$body = @"
{
    "api_key" : "$apiKey",
    "contact_id" : "47",
    "client_id" : "10"
}
"@

# Module / Endpoint
$module = "/api/v1/contacts/delete.php"

# Build URI from defined data
$uri = $siteUrl + $module

# Request
# Use Invoke-WebRequest instead to see more info about the request/response
Invoke-RestMethod -Method Post -Uri $uri -Body $body

