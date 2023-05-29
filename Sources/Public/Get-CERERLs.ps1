Function global:Get-CERERLs {
    <#
    .SYNOPSIS
        Queries CER for Emergency Response Location(s)
    .DESCRIPTION
        Queries CER for Emergency Response Location(s)
    #>

    param(
        [switch]$Formatted
    )

    $URI = "/cerappservices/export/conventionalerl/info"

    $Response = Invoke-CERAPIRequest -URI $URI
    $Response.ConventionalERL.ERLDetails | ForEach-Object {

        $ELIN = ""

        if ($_.ELINSettings -like "*--*") {
            $ELIN = $_.ELINSettings.Split("--")[1]
        }

        if ($Formatted) {

            $Street = $(if ($_.ALIInfo.PrefixDirectional -ne "") { $_.ALIInfo.PrefixDirectional + " " } else { "" }) + $_.ALIInfo.StreetName + $(if ($_.ALIInfo.StreetSuffix -ne "") { " " + $_.ALIInfo.StreetSuffix } else { "" }) + $(if ($_.ALIInfo.PostDirectional -ne "") { " " + $_.ALIInfo.PostDirectional } else { "" })
            $hash = [ordered]@{
                'ELIN'        = [int64]$ELIN
                'ERLName'     = $_.ERLName
                'HouseNumber' = [int64]$_.ALIInfo.HouseNumber
                'Street'      = $Street
                'Location'    = $_.ALIInfo.Location
                'City'        = $_.ALIInfo.CommunityName
                'State'       = $_.ALIInfo.State
                'ZipCode'     = $_.ALIInfo.ZipCode + $(if ($_.ALIInfo.ZipCodeExt -ne "") { "-" + $_.ALIInfo.ZipCodeExt } else { "" })

            }
            $Result = New-Object PSObject -Property $hash
            return $Result
        }
        else {
            $hash = [ordered]@{
                'ERLName'               = $_.ERLName
                'ERLNotes'              = $_.ERLNotes
                'TestERL'               = $_.TestERL
                'ELINSettings'          = $_.ELINSettings
                'OnSiteAlertSettings'   = $_.OnsiteSettings
                'HouseNumber'           = $_.ALIInfo.HouseNumber
                'HouseNumberSuffix'     = $_.ALIInfo.HouseNumberSuffix
                'StreetName'            = $_.ALIInfo.StreetName
                'Prefix Directional'    = $_.ALIInfo.PrefixDirectional
                'Street Suffix'         = $_.ALIInfo.StreetSuffix
                'Post Directional'      = $_.ALIInfo.PostDirectional
                'Community Name'        = $_.ALIInfo.CommunityName
                'State'                 = $_.ALIInfo.State
                'MainNPA'               = $_.ALIInfo.MainNPA
                'Customer Name'         = $_.ALIInfo.CustomerName
                'Class of Service'      = $_.ALIInfo.COS
                'Type of Service'       = $_.ALIInfo.TOS
                'Exchange'              = $_.ALIInfo.Exchange
                'Main Telephone Number' = $_.ALIInfo.MainTelNum
                'Order Number'          = $_.ALIInfo.OrderNumber
                'County ID'             = $_.ALIInfo.CountyID
                'Company ID'            = $_.ALIInfo.CompanyID
                'ZIP Code'              = $_.ALIInfo.ZipCode
                'ZIP Code Ext'          = $_.ALIInfo.ZipCodeExt
                'Customer Code'         = $_.ALIInfo.CustomerCode
                'Comments'              = $_.ALIInfo.Comments
                'Longitude'             = $_.ALIInfo.Longitude
                'Latitude'              = $_.ALIInfo.Latitude
                'Elevation'             = $_.ALIInfo.Elevation
                'TAR Code'              = $_.ALIInfo.TARCode
                'Location'              = $_.ALIInfo.Location
                'ProviderReserved'      = $_.ALIInfo.ProvReserved
                'Time Zone'             = $_.TimeZone
                'ERL Type'              = $_.ALIInfo.ERLType
                'Level Of Service'      = "" # This is a blank field, but still within the CSV export from CER
            }
            $Result = New-Object PSObject -Property $hash
            return $Result
        }
    }
}
