# ITFlow API - PowerShell examples
# https://itflow.org

# Read clients

# API Key
$apiKey = "a1wEoh1F3omPhea6"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Module / Endpoint
$module = "/api/v1/clients/read.php"

# Build URI from defined data
# Will return all clients by default
$uri = $siteUrl + $module + "?api_key=" + $apiKey

# Other URL examples

# Specific client name
$uri = $siteUrl + $module + "?api_key=" + $apiKey + "&client_name=ExampleOrg"

# Request
# Use Invoke-WebMethod instead to see more info about the request/response
Invoke-RestMethod -Method GET -Uri $uri
