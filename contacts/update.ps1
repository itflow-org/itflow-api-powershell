# ITFlow API - PowerShell examples
# https://itflow.org

# Update contact(s)

# API Key
$apiKey = "05438411f4fd492f"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Data
$body = @"
{
    "api_key" : "$apiKey",
    "contact_id" : "48",
    "contact_name" : "Suzanne Sallie",
    "contact_title" : "Head of Accounting",
    "contact_department" : "Accounts",
    "contact_email" : "sally@itflow.org",
    "contact_phone" : "1234567",
    "contact_extension" : "",
    "contact_mobile" : "",
    "contact_notes" : "We like Suzanne - she pays us (a lot)!",
    "contact_auth_method" : "local",
    "contact_important" : "1",
    "contact_billing" : "1",
    "contact_technical" : "0",
    "contact_location_id" : "0",
    "client_id" : "1"
}
"@

# Module / Endpoint
$module = "/api/v1/contacts/update.php"

# Build URI from defined data
$uri = $siteUrl + $module

# Request
# Use Invoke-WebRequest instead to see more info about the request/response
Invoke-RestMethod -Method Post -Uri $uri -Body $body -ErrorVariable $a