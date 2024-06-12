<#
.SYNOPSIS
    Create or update asset from Tactical RMM to ITFlow. Uses MAC address to check if asset exists in ITFlow.

.REQUIREMENTS
    - ITFlow API key.
    - Global key in TacticalRMM named "ITFlow_API" with your ITFlow API key as the value.
    - Global key in TacticalRMM named "ITFlow_url" with your ITFlow URL as the value.
    - Client custom field in TacticalRMM named "ITFlow_client_ID".
    - Site custom field in TacticalRMM named "ITFlow_location_ID"
    - Site custom field in TacticalRMM named "ITFlow_network_ID"
    - Each client in TacticalRMM should have its ITFlow_client_ID populated with the client_id found in ITFlow.
        To find the ID, check the URL in ITFlow once you select a client.
    - Each client site in TacticalRMM should have ITFlow_location_ID and ITFlow_network_ID populated with the IDs.
        To find the IDs run this script on one PC. Assign the PC to a location and network in ITFlow. Run this script again and take note of the location and network IDs.

.NOTES
    - Uses PC MAC address to check if asset exists in ITFlow.
    - Make sure to add the below script arguments to the script arguments section in TacticalRMM.
    - This script can be adapted to any RMM. TacticalRMM is only used to store the ITFlow URL, ITFlow API key, and client IDs. 

.SCRIPT_ARGUMENTS
    -ITFlow_API {{global.ITFlow_API}}
    -ITFlow_url {{global.ITFlow_url}}
    -ITFlow_client_ID {{client.ITFlow_client_ID}}
    -ITFlow_location_ID {{site.ITFlow_location_ID}}
    -ITFlow_network_ID {{site.ITFlow_network_ID}}

.VERSION
    - v1.3 - 2024-06-12 - JQ - Fixed asset_make spelling, Remove Inc. from Make string, remove Microsoft from OS String, Capitalize First letter of each word in Make String, except for HP capitize both letters.
    - v1.2 Changed search from serial to MAC address, added location ID and network ID
    - v1.1 Added verbosity, forced TLS 1.2, added exit if API read failure
    - v1.0 Initial Release
     
#>

param(
    [string] $ITFlow_API,
    [string] $ITFlow_url,
    [string] $ITFlow_client_ID,
    [string] $ITFlow_location_ID,
    [string] $ITFlow_network_ID
)

# Function to capitalize the first letter of each word and handle specific cases
function Capitalize-FirstLetter {
    param (
        [string]$inputString
    )
    if ($inputString -eq "hp") {
        return "HP"
    } elseif ($inputString -eq "ibm") {
        return "IBM"
    } else {
        return ($inputString -split ' ' | ForEach-Object { 
            if ($_.Length -gt 1) { 
                $_.Substring(0,1).ToUpper() + $_.Substring(1).ToLower() 
            } else { 
                $_.ToUpper() 
            } 
        }) -join ' '
    }
}

# Get PC info
$asset_name = $Env:ComputerName
$asset_make = (Get-WmiObject -Class Win32_ComputerSystem).Manufacturer
$asset_make = $asset_make -replace 'Inc\.', '' -replace 'inc\.', '' -replace 'Inc', '' -replace 'inc', ''
$asset_make = Capitalize-FirstLetter -inputString $asset_make
$asset_model = (Get-WmiObject -Class:Win32_ComputerSystem).Model
$asset_serial = (Get-WmiObject -Class:Win32_BIOS).SerialNumber
$asset_os = (Get-WmiObject Win32_OperatingSystem).Caption -replace 'Microsoft', ''
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
if (Test-IsServer) {
    $asset_type = "Server"
} else {
    if (Test-IsLaptop) {
    $asset_type = "Laptop"
    } else {
    $asset_type = "Desktop"
    }
}

# Read Module
$read_module = "/api/v1/assets/read.php"

# Search all clients in ITFlow by serial to see if this asset already exists
$uri_read = $ITFlow_url + $read_module + "?api_key=" + $ITFlow_API + "&asset_mac=" + $asset_mac

# Force TLS 1.2 for this script
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Check if PC exists in ITFlow database
$exists = Invoke-RestMethod -Method GET -Uri $uri_read

$asset_id = $exists.data.asset_id
$asset_location_id = $ITFlow_location_ID
$asset_network_id = $ITFlow_network_ID

# If the asset exists update it, if not create it.
if ($exists.success -eq "False") {
    $module = "/api/v1/assets/create.php"
    Write-Host "Asset does not exist - Creating..."
} else {
    if ($exists.success -eq "True") {
        $module = "/api/v1/assets/update.php"
        Write-Host "ITFlow IDs - Location ID: " $exists.data.asset_location_id "Network ID: " $exists.data.asset_network_id
        
        if ( $ITFlow_location_ID -eq "0" ) {
            $asset_location_id = $exists.data.asset_location_id
        }

        if ( $ITFlow_network_ID -eq "0" ) {
            $asset_network_id = $exists.data.asset_network_id
        }
        
        Write-Host "Asset already exists - Updating..."
    } else {
        Write-Host "API connection error. Aborting..."
        Exit
    }
}

# Data
$body = @"
{
    "api_key"               : "$ITFlow_API",
    "asset_name"            : "$asset_name",
    "asset_type"            : "$asset_type",
    "asset_make"            : "$asset_make",
    "asset_model"           : "$asset_model",
    "asset_serial"          : "$asset_serial",
    "asset_os"              : "$asset_os",
    "asset_ip"              : "$local_ip",
    "asset_mac"             : "$asset_mac",
    "asset_install_date"    : "$install",
    "asset_status"          : "Deployed",
    "client_id"             : "$ITFlow_client_ID",
    "asset_location_id"     : "$asset_location_id",
    "asset_network_id"      : "$asset_network_id",
    "asset_id"              : "$asset_id"
}
"@

$uri_write = $ITFlow_url + $module
$write = Invoke-RestMethod -Method Post -Uri $uri_write -Body $body

if ($exists.success -eq "True" -And $write.success -eq "True") {
    Write-Host "Asset updated."
}
    
if ($exists.success -eq "True" -And $write.success -eq "False") {
    Write-Host "No changes to update." 
}

if ($exists.success -eq "False" -And $write.success -eq "True") {
    Write-Host "Asset created." 
}
if ($exists.success -eq "False" -And $write.success -eq "False") {
    Write-Host "Failed to create asset."
}
