Function Invoke-CERAPIRequest {
	<#
	.SYNOPSIS
		Makes API call to Cisco Emergency Responder Web Service

	.DESCRIPTION
		Accepts SOAP XML as parameter and POSTs it to the Cisco Emergency Responder Web Service

	.PARAMETER Request
		SOAP XML Query

	.EXAMPLE
		Invoke-CERAPIRequest -Request $SOAP

		# Submits SOAP request to CER AXL Service
	#>
	param(
		[parameter(Mandatory)]$URI,
        [parameter()]$Request
	)
    $ConfigFile = Get-CERSettingsFile
	$cer_path = $MyInvocation.MyCommand.Module.PrivateData['cer_path']
	$cred = Import-CliXml -Path "$cer_path\cer.cred"

	[System.Net.ServicePointManager]::ServerCertificateValidationCallback={$True}
	$parms  = @{
        'Uri' = $ConfigFile.Settings.CER.uri + $URI
		'ContentType' = 'text/xml'
		'Credential' = $cred
        'Method' = 'Get'
	}

	try {
	    return [xml](Invoke-WebRequest @parms).Content
    } catch {
	    $result = $_.Exception.Response.GetResponseStream()
	    $reader = New-Object System.IO.StreamReader($result)
	    $reader.BaseStream.Position = 0
	    $reader.DiscardBufferedData()
		$content = $reader.ReadToEnd()
		$xml = [xml]$content
		$fault = $xml.Envelope.Body.Fault

		$message = @{
			'faultcode'      = $fault.faultcode
			'faultstring'    = $fault.faultstring
			'detail_message' = $fault.detail.AxlError.axlMessage
			'detail_request' = $fault.detail.AxlError.request
		}

		Write-Host "Failed with fault code '$($message.faultcode)' for request '$($message.detail_request)' - $($message.detail_message)"

	    return $xml
    }
}
