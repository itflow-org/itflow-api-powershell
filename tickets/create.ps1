# ITFlow API - PowerShell examples
# https://itflow.org

# Create ticket(s)

# API Key
$apiKey = "a1wEoh1F3omPhea6"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Data
$body = @"
{
    "api_key" : "$apiKey",
    "ticket_subject" : "Having issues with database",
    "ticket_details" : "User X is having issues with the database",
    "ticket_priority" : "Low",
    "ticket_assigned_to" : "0",
    "ticket_contact_id" : "0",
    "client_id" : "5"
}
"@

# Module / Endpoint
$module = "/api/v1/tickets/create.php"

# Build URI from defined data
$uri = $siteUrl + $module

# Request
# Use Invoke-WebRequest instead to see more info about the request/response
Invoke-RestMethod -Method Post -Uri $uri -Body $body

