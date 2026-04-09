# ITFlow API - PowerShell examples
# https://itflow.org

# Read certificates

# API Key
$apiKey = "05438411f4fd492f"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Module / Endpoint
$module = "/api/v1/certificates/read.php"

# Build URI from defined data
# Will return all assets by default (single client/all clients depends on API key scope)
$uri = $siteUrl + $module + "?api_key=" + $apiKey


# Other URL examples

# All assets for a specific certificate ID
# $uri = $siteUrl + $module + "?api_key=" + $apiKey + "&certificate_id=10"

# Specific certificate name
# $uri = $siteUrl + $module + "?api_key=" + $apiKey + "&certificate_name=itflow.org"


# Request
# Use Invoke-WebMethod instead to see more info about the request/response
Invoke-RestMethod -Method GET -Uri $uri
