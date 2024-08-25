# ITFlow API - PowerShell examples
# https://itflow.org

# Create credential(s)

# API Key
$apiKey = "a1wEoh1F3omPhea6"

# Credential decryption key
$credKey = "JKyA0daoyOv7oKpw"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Data
$body = @"
{
    "api_key" : "$apiKey",
    "api_key_decrypt_password" : "$credKey",
    "login_name" : "SRV-03 ILO",
    "login_description" : "Lights out for SRV-03",
    "login_uri" : "https://10.0.0.1",
    "login_uri_2" : "",
    "login_username" : "admin",
    "login_password" : "Passw0rd",
    "login_otp_secret" : "",
    "login_note" : "Very important login entry",
    "login_important" : "0",
    "login_contact_id" : "0",
    "login_vendor_id" : "0",
    "login_asset_id" : "0",
    "login_software_id" : 0,
    "client_id" : "1"
}
"@

# Module / Endpoint
$module = "/api/v1/credentials/create.php"

# Build URI from defined data
$uri = $siteUrl + $module

# Request
# Use Invoke-WebRequest instead to see more info about the request/response
Invoke-RestMethod -Method Post -Uri $uri -Body $body
