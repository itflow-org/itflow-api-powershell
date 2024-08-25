# ITFlow API - PowerShell examples
# https://itflow.org

# Read credentials (originally called "logins")
# Warning: Anyone in possession of the API Key & Decryption key can decrypt all credentials/logins via the API. 
#  Whilst running this script directly on user endpoints is convenient, consider how you will keep the keys safe from compromise.

# API Key
$apiKey = "a1wEoh1F3omPhea6"

# Credential decryption key
$credKey = "JKyA0daoyOv7oKpw"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Module / Endpoint
$module = "/api/v1/credentials/read.php"

# Build URI from defined data
# Will return all assets by default (single client/all clients depends on API key scope)
$uri = $siteUrl + $module + "?api_key=" + $apiKey + "&api_key_decrypt_password=" + $credKey

# Another URL example: Specific credential/login ID
#$uri = $siteUrl + $module + "?api_key=" + $apiKey + "&api_key_decrypt_password=" + $credKey + "&login_id=7"

# Request
# Use Invoke-WebMethod instead to see more info about the request/response
$a = Invoke-RestMethod -Method GET -Uri $uri
