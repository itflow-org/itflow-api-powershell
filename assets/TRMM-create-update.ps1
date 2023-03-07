<#
.SYNOPSIS
    Create or update asset from Tactical RMM to ITFlow. Uses PC serial number to check if asset exists in ITFlow.

.REQUIREMENTS
    - ITFlow API key.
    - Global key in TacticalRMM named "ITFlow_API" with your ITFlow API key as the value.
    - Global key in TacticalRMM named "ITFlow_url" with your ITFlow URL as the value.
    - Client custom field in TacticalRMM named "ITFlow_client_ID".
    - Each client in TacticalRMM should have its ITFlow_client_ID populated with the client_id found in ITFlow. (To find the id, check the URL in ITFlow once you select a client)

.NOTES
    - Uses PC serial number to check if asset exists in ITFlow. Make sure to add the below script arguments to the script arguments section in TacticalRMM. This script can be adapted to any RMM. TacticalRMM is only used to store the ITFlow URL, ITFlow API key, and client IDs. 

.SCRIPT_ARGUMENTS
    -ITFlow_API 
    -ITFlow_url 
    -ITFlow_client_ID 

.TODO
    - Error flags
    
.VERSION
    - v1.0 Initial Release
     
#>


param(
    [string] $ITFlow_API,
    [string] $ITFlow_url,
    [string] $ITFlow_client_ID
)

    # Get PC info
    $asset_name = $Env:ComputerName
    $agent_make = (Get-WmiObject -Class:Win32_ComputerSystem).Manufacturer
    $agent_model = (Get-WmiObject -Class:Win32_ComputerSystem).Model
    $agent_serial = (Get-WmiObject -Class:Win32_BIOS).SerialNumber
    $asset_os = (Get-WmiObject Win32_OperatingSystem).Caption
    $asset_mac = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration | where {$_.DHCPEnabled -ne $null -and $_.DefaultIPGateway -ne $null}).macaddress | Select-Object -First 1
    $install = ([DateTime](Get-Item -Force 'C:\System Volume Information\').CreationTime).ToString('yyyy/MM/dd')
    $local_ip = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration | where {$_.DHCPEnabled -ne $null -and $_.DefaultIPGateway -ne $null}).IPAddress | Select-Object -First 1
    
# Check if laptop
function Test-IsLaptop {
    $HardwareType = (Get-CimInstance -Class Win32_ComputerSystem -Property PCSystemType).PCSystemType
    # https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32-computersystem
    # Mobile = 2
    $HardwareType -eq 2
}

# Check if server OS
function Test-IsServer {
    $osInfo = (Get-CimInstance -Class:Win32_OperatingSystem).ProductType
    $osInfo -ne 1
}

    # If asset is server os, type is server. Otherwise, if chasis is mobile, type is laptop. Otherwise, type is desktop.
    if (Test-IsServer) { $asset_type = "Server" }
    else
    {if (Test-IsLaptop) { $asset_type = "Laptop" } 
    else
    { $asset_type = "Desktop" }}

    


# Read Module / Endpoint
$read_module = "/api/v1/assets/read.php"

# Search all clients in ITFlow by serial to see if this asset already exists
$uri_read = $ITFlow_url + $read_module + "?api_key=" + $ITFlow_API + "&asset_serial=" + $agent_serial

# Request
$obj0 = Invoke-RestMethod -Method GET -Uri $uri_read
$asset_id = $obj0.data.asset_id

# Data
$body = @"
{
    "api_key" : "$ITFlow_API",
    "asset_name" : "$asset_name",
    "asset_type" : "$asset_type",
    "asset_make" : "$agent_make",
    "asset_model" : "$agent_model",
    "asset_serial" : "$agent_serial",
    "asset_os" : "$asset_os",
    "asset_ip" : "$local_ip",
    "asset_mac" : "$asset_mac",
    "asset_install_date" : "$install",
    "asset_status" : "Deployed",
    "client_id" : "$ITFlow_client_ID",
    "asset_id" : "$asset_id"
}
"@

# If the asset exists update it, if not create it.
if ($obj0.success -eq "False"){
    $module = "/api/v1/assets/create.php"
    Write-Host "Asset does not exist - Creating"
    
    }else{
    
    $module = "/api/v1/assets/update.php"
    Write-Host "Asset already exists - Updating"
    }

$uri_write = $ITFlow_url + $module
$obj1 = Invoke-RestMethod -Method Post -Uri $uri_write -Body $body

if ($obj0.success -eq "True")
    { if ($obj1.success -eq "True"){ Write-Host "Asset pdated" }
    else { Write-Host "No changes to update" }}
else
    { if ($obj1.success -eq "True"){ Write-Host "Asset created" }
    else { Write-Host "Failed to create asset" }}
