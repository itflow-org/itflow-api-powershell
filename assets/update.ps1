# ITFlow API - PowerShell examples
# https://itflow.org

# Update asset(s)

# API Key
$apiKey = "a1wEoh1F3omPhea6"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Data
# Unspecified values will not be modified
# Client ID is required if the API key used has scope/access to all clients 
#  (ensure to remove trailing comma from network id if removing).
$body = @"
{
    "api_key" : "$apiKey",
    "asset_id" : "34",
    "asset_name" : "My Laptop 2",
    "asset_type" : "Laptop",
    "asset_make" : "Dell",
    "asset_model" : "Optiplex",
    "asset_serial" : "XYZ",
    "asset_os" : "Windows 10",
    "asset_ip" : "192.168.10.10",
    "asset_mac" : "",
    "asset_status" : "Deployed",
    "asset_purchase_date" : "",
    "asset_warranty_expire" : "2024-02-01",
    "asset_install_date" : "",
    "asset_notes" : "This is a cool laptop!",
    "asset_vendor_id" : "",
    "asset_location_id" : "",
    "asset_contact_id" : "",
    "asset_network_id" : "0",
    "client_id" : "1"
}
"@

# Module / Endpoint
$module = "/api/v1/assets/update.php"

# Build URI from defined data
$uri = $siteUrl + $module

# Request
# Use Invoke-WebRequest instead to see more info about the request/response
Invoke-RestMethod -Method Post -Uri $uri -Body $body

