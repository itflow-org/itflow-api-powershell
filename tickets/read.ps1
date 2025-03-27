# ITFlow API - PowerShell examples
# https://itflow.org

# Read tickets

# API Key
$apiKey = "a1wEoh1F3omPhea6"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Module / Endpoint
$module = "/api/v1/tickets/read.php"

# Build URI from defined data
# Will return all tickets by default (single client/all clients depends on API key scope)
$uri = $siteUrl + $module + "?api_key=" + $apiKey

# Other URL examples

# Specific ticket ID
# $uri = $siteUrl + $module + "?api_key=" + $apiKey + "&ticket_id=22"

# Request
# Use Invoke-WebMethod instead to see more info about the request/response
Invoke-RestMethod -Method GET -Uri $uri
