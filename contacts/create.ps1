# ITFlow API - PowerShell examples
# https://itflow.org

# Create contact(s)

# API Key
$apiKey = "05438411f4fd492f"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Data
$body = @"
{
    "api_key" : "$apiKey",
    "contact_name" : "Sally Suzie",
    "contact_title" : "Head of Accounting",
    "contact_department" : "Accounts",
    "contact_email" : "sally@itflow.org",
    "contact_phone" : "123456",
    "contact_extension" : "",
    "contact_mobile" : "",
    "contact_notes" : "We like Sally - she pays us!",
    "contact_auth_method" : "local",
    "contact_primary" : "0",
    "contact_important" : "1",
    "contact_billing" : "1",
    "contact_technical" : "0",
    "contact_location_id" : "0",
    "client_id" : "1"
}
"@

# Module / Endpoint
$module = "/api/v1/contacts/create.php"

# Build URI from defined data
$uri = $siteUrl + $module

# Request
# Use Invoke-WebRequest instead to see more info about the request/response
Invoke-RestMethod -Method Post -Uri $uri -Body $body
