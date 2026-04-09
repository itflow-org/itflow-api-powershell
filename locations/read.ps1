# ITFlow API - PowerShell examples
# https://itflow.org

# Read locations

# API Key
$apiKey = "a1wEoh1F3omPhea6"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Module / Endpoint
$module = "/api/v1/locations/read.php"

# Build URI from defined data
# Will return all locations by default (single client/all clients depends on API key scope)
$uri = $siteUrl + $module + "?api_key=" + $apiKey


# Other URL examples

# All locations for a specific client ID
# $uri = $siteUrl + $module + "?api_key=" + $apiKey + "&client_id=10"

# Specific location ID
 #$uri = $siteUrl + $module + "?api_key=" + $apiKey + "&location_id=41"


# Request
# Use Invoke-WebMethod instead to see more info about the request/response
Invoke-RestMethod -Method GET -Uri $uri
