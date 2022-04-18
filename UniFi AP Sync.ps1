# UniFi API access

# Example script to sync data from a single site into a single ITFlow client
# This could be adapted to sync multiple sites to multiple clients, but would need a way to define which UniFi site ID relates to which client 
#  (see: https://gcits.com/knowledge-base/sync-unifi-sites-with-it-glue/ for inspiration)


#######################################################################################################
# Functions

# Function to check if a string ($itfAssetID) contains only numbers
function Is-Numeric ($Value) {
    return $Value -match "^[\d\.]+$"
}
#######################################################################################################


#######################################################################################################
# UniFi Settings
# https://blog.darrenjrobinson.com/accessing-your-ubiquiti-unifi-network-configuration-with-powershell/

# Unifi Controller Login Base URI
$unfURL = ' ' # e.g 'https://192.168.1.2:8443'

# Identifier of the site in UniFi. Set to default for the default site
$unfSiteID = "default"

# UniFi Admin Username
$unfUsername = ' ' # yourAdmin UserID

# UniFi Password
$unfPassword = ' '

$unfAuthBody = @{"username" = $unfUsername; "password" = $unfPassword }
$unfHeaders = @{"Content-Type" = "application/json" }
$unfLogin = $null
#######################################################################################################


#######################################################################################################
# ITFlow Settings

# ITFlow Base URL
$itfBaseURL = 'http://127.0.0.1/itflow'

# ITFlow API Key
$itfAPIKey = 'pkNAjIpeNILa7StO'

# ITFlow Client ID (for adding assets)
$itfClientID = '8'


$itfReadURL = $itfBaseURL + "/api/v1/assets/read.php?api_key=" + $itfAPIKey
$itfCreateURL = $itfBaseURL + "/api/v1/assets/create.php"
$itfUpdateURL = $itfBaseURL + "/api/v1/assets/update.php"

######################################################################################################


# UniFi Login
$unfLogin = Invoke-RestMethod -Method Post -Uri "$($unfURL)/api/login" -Body ($unfAuthBody | convertto-json) -Headers $unfHeaders -SessionVariable UBNT -ErrorAction Stop

# Check UniFi login success
if($unfLogin.meta.rc -notContains "ok" -or $unfLogin.meta.rc -contains "error"){
    Write-Host "UNIFI - Something went wrong connecting to $($unfURL) as $($unfUsername)"
    Write-Host $unfLogin
    Exit
}
Write-Host -ForegroundColor Green "UNIFI - Successfully authenticated."

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

# Get all Devices for this site
$unfDevices = Invoke-RestMethod -Method Get -Uri "$($unfURL)/api/s/$($unfSiteID)/stat/device" -WebSession $UBNT -Headers $unfHeaders

foreach ($AP in $unfDevices.data) {

    $urlName = $itfReadURL + "&asset_name=" + $AP.Name
    $urlSerial = $itfReadURL + "&asset_serial=" + $AP.serial

    # Variables
    $itfAssetID = $false
    $name = $AP.name
    $serial = $AP.serial
    $model = $AP.model
    $os = $AP.version
    $ip = $AP.ip
    $mac = $AP.mac

    # ITFlow - query via asset serial number
    $itfAssetSN = Invoke-RestMethod -Method GET -Uri "$urlSerial"

    # ITFlow - query via asset name
    $itfAssetName = Invoke-RestMethod -Method GET -Uri "$urlName"

    # Checks to determine the ITFlow asset ID

    if($itfAssetSN.success -eq "True"){
        $itfAssetID = $itfAssetSN.data.asset_id
        $itfAssetData = $itfAssetSN
        #Write-Host -ForegroundColor Green $AP.Name "lookup success via SN. ITFlow ID" $itfAssetID
    }
    elseif($itfAssetName.success -eq "True"){
        $itfAssetID = $itfAssetName.data.asset_id
        $itfAssetData = $itfAssetSN
        #Write-Host -ForegroundColor Green $AP.Name "lookup success via name. ITFlow ID:" $itfAssetID
    }

    # Check if asset already exists (if ITFlow knows about the AP)
    if(Is-Numeric $itfAssetID){
        # We found the asset - update details?

        Write-Host -ForegroundColor Green "Found asset" $AP.Name $AP.Serial "as ITFlow ID" $itfAssetID " - updating it.."

        # Asset attributes to be updated
        $body = @"
        {
            "api_key" : "$itfAPIKey",
            "asset_id" : "$itfAssetID",
            "asset_name" : "$name",
            "asset_type" : "Access Point",
            "asset_make" : "UniFi",
            "asset_model" : "$model",
            "asset_serial" : "$serial",
            "asset_os" : "$os",
            "asset_ip" : "$ip",
            "asset_mac" : "$mac"
        }
"@ # This seemingly cannot be indented..


        # Update asset
        Invoke-RestMethod -Method Post -Uri $itfUpdateURL -Body $body

    }

    else{
        # Couldn't find asset

        Write-Host -ForegroundColor Yellow "Could not find asset" $AP.Name $AP.Serial "- adding it.."

        # New asset attributes
        $body = @"
        {
            "api_key" : "$itfAPIKey",
            "asset_name" : "$name",
            "asset_type" : "Access Point",
            "asset_make" : "UniFi",
            "asset_model" : "$model",
            "asset_serial" : "$serial",
            "asset_os" : "$os",
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