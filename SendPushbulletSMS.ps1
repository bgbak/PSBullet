function Send-PushbulletSMS {
	<#
		.SYNOPSIS
		Send SMS with pushbullet
		.EXAMPLE
		
		.OUTPUT
		
	  #>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true)][string]$DeviceIden
		,[Parameter(Mandatory=$true)][string]$Number
		,[Parameter(Mandatory=$true)][string]$Message
		
	)
	begin {
		# Get the apikey
		$apikey = Get-PusbhulletApiKey
		Write-Verbose "Successfully got apikey"
		if($apikey -eq $null){
			Write-Error -Message "Could not read api key" -Category ReadError
		}
		else{
			# Set the apikey in the headers.
			$headers = @{Authorization = "Bearer $apikey"}
		}
	}

	process{
		
		$body = @{
						type = "push" 
						$push = @{
							type = 'messaging_extension_reply'
							package_name = 'com.pushbullet.android'
							target_device_iden = $DeviceIden
							conversation_iden = $Number
							message = $Message 
							}
							
						$push = $push | ConvertTo-Json
		
		write-verbose "Sending SMS"
		$Requestattempt = Invoke-WebRequest -Uri https://api.pushbullet.com/v2/ -Method post  -Headers $headers
		If ($Requestattempt.StatusCode -eq "200"){
			Write-Verbose = "SMS sent successfully"
			Return $Requestattempt.Content|Convertfrom-json
		}
		else {
			Write-Error -Message "Error: Something went wrong. Check `$attempt for info" -Category WriteError
			$global:attempt = $Requestattempt
		}
	}
}
Export-ModuleMember -Function *