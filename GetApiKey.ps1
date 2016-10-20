function Get-PushBulletApiKey{	
<#
	.SYNOPSIS
	Get the api key from registry
	.EXAMPLE
    $ApiKey = Get-PushbulletApiKey
	
#>	
	if(!(Test-Path -Path HKCU:\software\PSBullet))
        {Write-Error "Path to PSBullet API key not found in registry. Try to save it with Set-PushBulletApiKey" -Category ReadError
        break}

    $ApiKey = (Get-ItemProperty -Path HKCU:\SOFTWARE\PSBullet -Name ApiKey).ApiKey
    
}