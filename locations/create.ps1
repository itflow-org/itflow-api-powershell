# https://itflow.org

# Create location(s)

# API Key
$apiKey = "05438411f4fd492f"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Data
$body = @"
{
    "api_key" : "$apiKey",
    "location_name" : "Head Office",
    "location_description" : "HQ",
    "location_country" : "United Kingdom",
    "location_address" : "10 Downing Street",
    "location_city" : "London",
    "location_state" : "London",
    "location_zip" : "SW1A 2AA",
    "location_hours" : "9-5",
    "location_notes" : "Fairly important location",
    "location_primary" : "1",
    "client_id" : "1017"
}
"@

# Module / Endpoint
$module = "/api/v1/locations/create.php"

# Build URI from defined data
$uri = $siteUrl + $module

# Request
# Use Invoke-WebRequest instead to see more info about the request/response
Invoke-RestMethod -Method Post -Uri $uri -Body $body
