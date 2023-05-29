Function global:Get-CERSNMPv3List {
    <#
    .SYNOPSIS
        Queries CER for SNMPv3 settings information detail
    .DESCRIPTION
        Queries CER for SNMPv3 settings information detail
    #>

    $URI = "/cerappservices/export/snmpv3list/info"

    $Response = Invoke-CERAPIRequest -URI $URI
    $Response.snmpv3settings.details | Format-Table
}
