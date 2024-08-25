# ITFlow API - PowerShell examples
# https://itflow.org

# Update credential(s)

# API Key
$apiKey = "a1wEoh1F3omPhea6"

# Credential decryption key
$credKey = "JKyA0daoyOv7oKpw"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Data
#  Required fields are API Key, API Decryption Key, Login ID and Client ID
#  Only specify the fields you need to update, see create.ps1 for column names
$body = @"
{
    "api_key" : "$apiKey",
    "api_key_decrypt_password" : "$credKey",
    "login_id" : "6",
    "login_username" : "new_username",
    "login_password" : "changedPassword-123",
    "client_id" : "1"
}
"@

# Module / Endpoint
$module = "/api/v1/credentials/update.php"

# Build URI from defined data
$uri = $siteUrl + $module

# Request
# Use Invoke-WebRequest instead to see more info about the request/response
Invoke-RestMethod -Method Post -Uri $uri -Body $body
