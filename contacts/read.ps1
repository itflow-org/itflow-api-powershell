# ITFlow API - PowerShell examples
# https://itflow.org

# Read contacts

# API Key
$apiKey = "a1wEoh1F3omPhea6"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Module / Endpoint
$module = "/api/v1/contacts/read.php"

# Build URI from defined data
# Will return all contacts by default (single client/all clients depends on API key scope)
#$uri = $siteUrl + $module + "?api_key=" + $apiKey


# Other URL examples

# All contacts for a specific client ID
# $uri = $siteUrl + $module + "?api_key=" + $apiKey + "&client_id=10"

# Contact via email
# $uri = $siteUrl + $module + "?api_key=" + $apiKey + "&contact_email=someone@example.com"

# Contact via number
# $uri = $siteUrl + $module + "?api_key=" + $apiKey + "&contact_phone_or_mobile=1199"

# Specific contact ID
# $uri = $siteUrl + $module + "?api_key=" + $apiKey + "&contact_id=22"


# Request
# Use Invoke-WebMethod instead to see more info about the request/response
Invoke-RestMethod -Method GET -Uri $uri