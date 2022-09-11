# ITFlow API - PowerShell examples
# https://itflow.org

# Create contact(s)

# API Key
$apiKey = "NZp4bSecIGyP3CJX"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Data
$body = @"
{
    "api_key" : "$apiKey",
    "contact_name" : "Sally Suzie",
    "contact_title" : "Head of Accounting",
    "contact_department" : "Accounts",
    "contact_phone" : "123456",
    "contact_extension" : "",
    "contact_mobile" : "",
    "contact_email" : "sally@itflow.orgg",
    "contact_notes" : "We like Sally",
    "contact_auth_method" : "local",
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
Invoke-RestMethod -Method Post -Uri $uri -Body $body -ErrorVariable $a