# ITFlow API - PowerShell examples
# https://itflow.org

# Resolve a ticket

# API Key
$apiKey = "a1wEoh1F3omPhea6"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Data
$body = @"
{
    "api_key" : "$apiKey",
    "ticket_id" : "558",
    "client_id" : "1017"
}
"@

# Module / Endpoint
$module = "/api/v1/tickets/resolve.php"

# Build URI from defined data
$uri = $siteUrl + $module

# Request
# Use Invoke-WebRequest instead to see more info about the request/response
Invoke-RestMethod -Method Post -Uri $uri -Body $body
