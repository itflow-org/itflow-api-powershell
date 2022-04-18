# Hyper-V to ITFlow

# Example script to sync data from Hyper-V into a single ITFlow client
# This could be adapted to sync different VMs to multiple clients, but would need a way to define which VM is for what client


#######################################################################################################
# Functions

# Function to check if a string ($itfAssetID) contains only numbers
function Is-Numeric ($Value) {
    return $Value -match "^[\d\.]+$"
}
#######################################################################################################



#######################################################################################################
# HYPER-V Settings

# Host
$hypHost = ' ';

#######################################################################################################



#######################################################################################################
# ITFlow Settings
# https://itflow.org/docs.php?doc=api

# ITFlow Base URL
$itfBaseURL = 'http://127.0.0.1/itflow'

# ITFlow API Key
$itfAPIKey = 'De5sxSVMjWdS3QX4'

# ITFlow Client ID (for adding assets)
$itfClientID = '8'


$itfReadURL = $itfBaseURL + "/api/v1/assets/read.php?api_key=" + $itfAPIKey
$itfCreateURL = $itfBaseURL + "/api/v1/assets/create.php"
$itfUpdateURL = $itfBaseURL + "/api/v1/assets/update.php"

######################################################################################################

# ITFlow credential check
$iftLoginTest = Invoke-RestMethod -Method GET -Uri $itfReadURL -ErrorAction Stop
if(!$?){
    Write-Host "ITFLOW - Something went wrong connecting to $itfReadURL"
    Exit
}
Write-Host -ForegroundColor Green "ITFLOW - Successfully authenticated."


Write-Host
Write-Host "------"
Write-Host

# Get all Hyper-V VMs on this host
$VMs = Get-VM -ComputerName $hypHost | Select -ExpandProperty Networkadapters | select VMName, MacAddress, IPAddresses

if($VMs -eq $null){
    Write-Host "No VMs found! Do you have rights to run Get-VM?"
}

foreach ($VM in $VMs) {

    $urlName = $itfReadURL + "&asset_name=" + $VM.VMName

    # Variables
    $itfAssetID = $false
    $name = $VM.VMName
    $mac = $VM.MacAddress
    $ip = $VM.IPAddresses[0] # Just the first (hopefully IPv4)

    # ITFlow - query via asset name
    $itfAssetName = Invoke-RestMethod -Method GET -Uri "$urlName"


    # Checks to determine the ITFlow asset ID

    if($itfAssetName.success -eq "True"){
        $itfAssetID = $itfAssetName.data.asset_id
    }

    # Check if asset already exists (if ITFlow knows about the AP)

    if(Is-Numeric $itfAssetID){
        # We found the asset - update details

        Write-Host -ForegroundColor Green "Found asset" $name "as ITFlow ID" $itfAssetID " - updating it.."

        # Asset attributes to be updated
        $itfAssetClientID = $itfAssetName.data.asset_client_id
        $body = @"
        {
            "api_key" : "$itfAPIKey",
            "asset_id" : "$itfAssetID",
            "asset_name" : "$name",
            "asset_type" : "Virtual Machine",
            "asset_model" : "$hypHost",
            "asset_ip" : "$ip",
            "asset_mac" : "$mac",
            "client_id" : "$itfAssetClientID"
        }
"@ # This seemingly cannot be indented..


        # Update asset
        Invoke-RestMethod -Method Post -Uri $itfUpdateURL -Body $body

    }

    else{
        # Couldn't find asset, add it

        Write-Host -ForegroundColor Yellow "Could not find asset" $name "- adding it.."

        # New asset attributes
        $body = @"
        {
            "api_key" : "$itfAPIKey",
            "asset_name" : "$name",
            "asset_type" : "Virtual Machine",
            "asset_model" : "$hypHost",
            "asset_ip" : "$ip",
            "asset_mac" : "$mac",
            "asset_notes" : "Added via script",
            "client_id" : "$itfClientID"
        }
"@ # This seemingly cannot be indented..


        # Add asset
        Invoke-RestMethod -Method Post -Uri $itfCreateURL -Body $body

    }

    # Blank line for console output readability
    Write-Host
}