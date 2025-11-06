# ITFlow API - PowerShell examples
# https://itflow.org

# Create client(s)

# API Key (must be an ALL client API key)
$apiKey = "05438411f4fd492f"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Data
$body = @"
{
    "api_key" : "$apiKey",
    "client_name" : "Contoso",
    "client_type" : "Consultancy",
    "client_website" : "contoso.org",
    "client_referral" : "sally@itflow.org",
    "client_rate" : "250",
    "client_currency_code" : "USD",
    "client_net_terms" : "30",
    "client_abbreviation" : "CTS",
    "client_tax_id_number" : "987654321Z",
    "client_is_lead" : "0",
    "client_notes" : "New client"
}
"@

# Module / Endpoint
$module = "/api/v1/clients/create.php"

# Build URI from defined data
$uri = $siteUrl + $module

# Request
# Use Invoke-WebRequest instead to see more info about the request/response
Invoke-RestMethod -Method Post -Uri $uri -Body $body
