# ITFlow API - PowerShell examples
# https://itflow.org

# Read assets

# API Key
$apiKey = "a1wEoh1F3omPhea6"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Module / Endpoint
$module = "/api/v1/assets/read.php"

# Build URI from defined data
# Will return all assets by default (single client/all clients depends on API key scope)
$uri = $siteUrl + $module + "?api_key=" + $apiKey


# Other URL examples

# All assets for a specific client ID
# $uri = $siteUrl + $module + "?api_key=" + $apiKey + "&client_id=10"

# All assets of a specific type
# $uri = $siteUrl + $module + "?api_key=" + $apiKey + "&asset_type=Laptop"

# Specific asset ID
# $uri = $siteUrl + $module + "?api_key=" + $apiKey + "&asset_id=22"


# Specific asset name
# $uri = $siteUrl + $module + "?api_key=" + $apiKey + "&asset_name=SRV01"


# Request
# Use Invoke-WebMethod instead to see more info about the request/response
Invoke-RestMethod -Method GET -Uri $uri