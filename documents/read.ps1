# ITFlow API - PowerShell examples
# https://itflow.org

# Read documents

# API Key
$apiKey = "a1wEoh1F3omPhea6"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Module / Endpoint
$module = "/api/v1/documents/read.php"

# Build URI from defined data
# Will return all assets by default (single client/all clients depends on API key scope)
$uri = $siteUrl + $module + "?api_key=" + $apiKey


# Other URL examples

# All documents for a specific client ID
# $uri = $siteUrl + $module + "?api_key=" + $apiKey + "&client_id=10"

# Specific document ID
 #$uri = $siteUrl + $module + "?api_key=" + $apiKey + "&document_id=41"


# Request
# Use Invoke-WebMethod instead to see more info about the request/response
Invoke-RestMethod -Method GET -Uri $uri