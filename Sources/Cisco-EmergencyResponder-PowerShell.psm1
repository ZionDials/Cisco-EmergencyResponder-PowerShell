
# Source all PowerShell scripts in order to export module member functions
$cer_path = "$($env:userprofile)\AppData\Local\AdminTools\CER"
if (-Not (Test-Path -Path $cer_path)) { New-Item -Path $cer_path -ItemType Directory }

#Get public and private function definition files.
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
Foreach($import in @($Public + $Private)) {
    Try {
        . $import.fullname
    } Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# Export public functions
Export-ModuleMember -Function $Public.Basename
