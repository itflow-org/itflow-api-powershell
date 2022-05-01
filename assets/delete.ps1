# ITFlow API - PowerShell examples
# https://itflow.org

# Delete asset

# API Key
$apiKey = "B0pqpqXmVi12borC"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Data
# Asset ID to delete
# Client ID is required if the API key used has scope/access to all clients 
$body = @"
{
    "api_key" : "$apiKey",
    "asset_id" : "9",
    "client_id" : "1"
}
"@

# Module / Endpoint
$module = "/api/v1/assets/delete.php"

# Build URI from defined data
$uri = $siteUrl + $module

# Request
# Use Invoke-WebRequest instead to see more info about the request/response
Invoke-RestMethod -Method Post -Uri $uri -Body $body

