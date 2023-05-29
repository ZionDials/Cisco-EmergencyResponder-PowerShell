Function global:Get-CERSettingsFile {
	<#
	.SYNOPSIS
		Generates config file if not exist

	.DESCRIPTION
		Runs through Q&A to create config file and store in AppData.
		If Settings.xml or .cred file is in the current working directory those will
		supercede when Get-CERSettingsFile is called.

	.PARAMETER Force
		Switch True/False

		# Toggles check if file exists, if used, ignores existing and creates new.

	.EXAMPLE
		Get-CERSettingsFile

		# Returns settings from XML file if exists, else creates new then returns

	.EXAMPLE
		Get-CERSettingsFile -Force

		# Creates new settings XML file
	#>
	param(
		[switch]$Force
	)

	# If Settings.xml is in current directory, use that instead of AppData version
	if (-not (Get-ChildItem Settings.xml -ErrorAction SilentlyContinue)) {
		$cer_path = $MyInvocation.MyCommand.Module.PrivateData['cer_path']
	} else {
		$cer_path = (Get-Location).Path
	}

	# Get absolute path to module
	$mod_path  = $MyInvocation.MyCommand.Module.ModuleBase

	# If Settings.xml doesn't exist, run through Q&A for setup
	if (!(Test-Path -Path "$cer_path\Settings.xml") -or $Force) {
		if (-not $Force) {
			Write-Warning "Unable to find '$cer_path\Settings.xml' file"
			$createone = Read-Host "Would you like to create a new settings file? [Y/N]"
		} else { $createone = "Y" }
		if ($createone -eq "Y") {
			[string]$CERURI        = Read-Host "Enter URI of Cisco CER AXL"
			if ($CERCredential = $host.ui.PromptForCredential('Cisco CER Credentials Required', 'Please enter credentials for Cisco Emergency Responder.', '', "")){} else {
				Write-Warning "Need CER credentials in order to proceed.`r`nPlease re-run script and enter the appropriate credentials."
				break
			}
			$CERCredential | Export-CliXml -Path "$cer_path\cer.cred"

			Write-Host "Generating XML File..."

			[xml]$ConfigFile = (Get-Content "$mod_path\bin\SettingsTemplate.xml")
			$ConfigFile.Settings.CER.uri     = $CERURI
			$ConfigFile.Settings.CER.auth    = "$cer_path\cer.cred"
			$ConfigFile.Save("$cer_path\Settings.xml") | Out-Null

			Write-Host "File Created in '$cer_path'"
		} else {
			Write-Warning "Need a settings.xml file in order to proceed`nQuitting..."
			exit
		}
	}

	# Import Settings XML File
	[xml]$ConfigFile = Get-Content "$cer_path\Settings.xml"

	# If *.cred files are in current path, replace creds in $ConfigFile instance with those
	$whereAmI = (Get-Location).Path
	if (Test-Path -Path "$whereAmI\*.cred") {
		if (Test-Path -Path "$whereAmI\cer.cred") {
			$ConfigFile.Settings.CER.auth = "$whereAmI\cer.cred"
		}
	}

	return $ConfigFile
}
