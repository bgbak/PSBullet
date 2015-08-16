function Get-PusbhulletApiKey{	
<#
	.SYNOPSIS
	Get apikey from file
	.DESCRIPTION
	Gets the apikey from the specified path.
	If no path is specified, the file is assumed to be in the script root in a file named apikey.txt
	.EXAMPLE
	Get-PushbulletApiKey
	.EXAMPLE
    Get-PushbulletApiKey -Path "C:\Pusbullet\apikey.cfg"
	.PARAMETER Path
	The path to the file with the apikey
#>	
	param(
		[string]$Path = (Join-Path -Path $PSSCriptroot -ChildPath apikey.txt)
	)
	Write-Verbose "Fetching api key from file"
	try {
		$apikey = Get-Content $Path
		Write-Verbose "PSScriptRoot: $PSSCriptroot"
		Write-Verbose "Got api key: $apikey"
		Return $apikey	
		}

	catch {Write-Output "Could not get apikey from config file. Exiting now."
	Return $Null
		}
}