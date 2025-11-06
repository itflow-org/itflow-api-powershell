# ITFlow API - PowerShell examples
# https://itflow.org

# Update client(s)

# API Key
$apiKey = "05438411f4fd492f"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Data
$body = @"
{
    "api_key" : "$apiKey",
    "client_id" : "1088",
    "client_name" : "Contoso",
    "client_type" : "Consultancy",
    "client_website" : "contoso.org",
    "client_referral" : "someone",
    "client_rate" : "300",
    "client_currency_code" : "USD",
    "client_net_terms" : "45",
    "client_abbreviation" : "CTSO",
    "client_tax_id_number" : "987654321Z",
    "client_is_lead" : "0",
    "client_notes" : "Updated client"
}
"@

# Module / Endpoint
$module = "/api/v1/clients/update.php"

# Build URI from defined data
$uri = $siteUrl + $module

# Request
# Use Invoke-WebRequest instead to see more info about the request/response
Invoke-RestMethod -Method Post -Uri $uri -Body $body
