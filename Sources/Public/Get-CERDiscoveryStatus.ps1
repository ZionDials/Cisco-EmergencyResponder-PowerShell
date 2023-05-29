Function global:Get-CERDiscoveryStatus {
    <#
    .SYNOPSIS
        Queries CER for data discovery status
    .DESCRIPTION
        Queries CER for data discovery status
    #>

    $URI = "/cerappservices/export/discoverystatus"

    $Response = Invoke-CERAPIRequest -URI $URI
    $Response.discoverystatus.status | Format-Table
}
