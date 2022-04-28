# ITFlow API - PowerShell examples
# https://itflow.org

# Create asset(s)

# API Key
$apiKey = "a1wEoh1F3omPhea6"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Data
$body = @"
{
    "api_key" : "$apiKey",
    "asset_name" : "My Laptop 2",
    "asset_type" : "Laptop",
    "asset_make" : "Dell",
    "asset_model" : "Optiplex",
    "asset_serial" : "XYZ",
    "asset_os" : "Windows 10",
    "asset_ip" : "192.168.10.10",
    "asset_mac" : "",
    "asset_purchase_date" : "",
    "asset_warranty_expire" : "2024-02-01",
    "asset_install_date" : "",
    "asset_notes" : "This is a cool laptop!",
    "asset_meshcentral_id" : "",
    "asset_vendor_id" : "",
    "asset_location_id" : "",
    "asset_contact_id" : "",
    "asset_network_id" : "16",
    "client_id" : "10"
}
"@

# Module / Endpoint
$module = "/api/v1/assets/create.php"

# Build URI from defined data
$uri = $siteUrl + $module

# Request
# Use Invoke-WebMethod instead to see more info about the request/response
Invoke-RestMethod -Method Post -Uri $uri -Body $body

