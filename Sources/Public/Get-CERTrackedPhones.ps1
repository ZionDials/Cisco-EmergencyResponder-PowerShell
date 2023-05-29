Function global:Get-CERTrackedPhones {
    <#
    .SYNOPSIS
        Queries CER for Tracked Phone(s)
    .DESCRIPTION
        Queries CER for Tracked Phone(s)
    #>

    $URI = "/cerappservices/export/trackedphones/info"

    $Response = Invoke-CERAPIRequest -URI $URI
    $Response.TrackedPhones.TrackedPhonesDetails | Format-Table
}
