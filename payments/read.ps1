# ITFlow API - PowerShell examples
# https://itflow.org

# Read payments (requires "All Clients" API key)

# API Key
$apiKey = "a1wEoh1F3omPhea6"

# Base site URL
$siteUrl = "https://demo.itflow.org"

# Module / Endpoint
$module = "/api/v1/payments/read.php"

# Build URI from defined data
# Will return all payments by default
$uri = $siteUrl + $module + "?api_key=" + $apiKey


# Other URL examples (uncomment to use)

# Specific payment ID
# $payment_id = 1
# $uri = $siteUrl + $module + "?api_key=" + $apiKey + "&payment_id=" + $payment_id


# Specific invoice ID
# $payment_invoice_id = 46
# $uri = $siteUrl + $module + "?api_key=" + $apiKey + "&payment_invoice_id=" + $payment_invoice_id

# Request
# Use Invoke-WebMethod instead to see more info about the request/response
$payments = (Invoke-RestMethod -Method GET -Uri $uri).data


# Show payments
For ($i=0; $i -le ($payments.Count - 1); $i++) {
    Write-Host "`n"
    Write-Host "Date:" $payments[$i].payment_date
    Write-Host "Method:" $payments[$i].payment_method
    Write-Host "Amount:" $payments[$i].payment_amount
    Write-Host "Invoice ID:" $payments[$i].payment_invoice_id
    Write-Host "Ref:" $payments[$i].payment_reference
}