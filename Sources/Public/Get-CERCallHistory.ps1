Function global:Get-CERCallHistory {
    <#
    .SYNOPSIS
        Queries CER for  Call History
    .DESCRIPTION
        Queries CER for Call History
    #>

    $URI = "/cerappservices/export/callhistory/info"

    $Response = Invoke-CERAPIRequest -URI $URI
    $Response.callhistory.details | Format-Table
}
