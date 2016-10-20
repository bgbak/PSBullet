function Set-PushBulletApiKey{	
<#
	.SYNOPSIS
	Stores the API Key in registry under the users hive.
	.DESCRIPTION
	Stores the API key in the users hive to get around having it in a text file along with the module
	.EXAMPLE
	Set-PushbulletApiKey -ApiKey 
	.PARAMETER Path
	The API Key to store
#>	
	param(
		[Parameter(Mandatory=$True,Position=1)][string]$ApiKey
	)
	# Test if path exists. if not, create
    if(!(Test-Path HKCU:\Software\PSBullet))
        {
        Write-Debug "Registry path not found. Creating..."
        New-Item -Path HKCU:\SOFTWARE\PSBullet
        }

    # Store the actual key
    Set-ItemProperty -Path HKCU:\SOFTWARE\PSBullet -Name ApiKey -Value $ApiKey

    # Test if key is stored
    #Get-ItemProperty -Path HKCU:\SOFTWARE\PSBullet -Name ApiKey
}