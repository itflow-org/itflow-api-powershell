# ITFlow API - PowerShell examples
# https://itflow.org

# Add invoice item

# API Key
$apiKey = "a1wEoh1F3omPhea6"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Data
$body = @"
{
    "api_key" : "$apiKey",
    "client_id" : "1091",
    "invoice_id" : "243",
    "name" : "Test",
    "description" : "Monthly managed services - August 2026",
    "qty" : "4",
    "price" : "150.00",
    "tax_id" : "0",
    "item_order" : "1",
    "product_id" : "0"
}
"@

# Module / Endpoint
$module = "/api/v1/invoice_items/create.php"

# Build URI from defined data
$uri = $siteUrl + $module

# Request
# Use Invoke-WebRequest instead to see more info about the request/response
Invoke-RestMethod -Method Post -Uri $uri -Body $body
