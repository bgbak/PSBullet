function Send-PushbulletNote {
  <#
  .SYNOPSIS
    Send pushbullet notification to your devices from PowerShell
    Enter your apikey in a file named pusbhullet.cfg, and place it in the same folder as this file.
  .DESCRIPTION
    Use PowerShell to send notification to your devices with Pushbullet.
    For now the only supported function is a text note, and it is not possible to specify devices.
  .EXAMPLE
    Send-PushbulletNote -Subject "Warning!" -Message "The coffemachine is out of coffe"
  .EXAMPLE
    Send-PushbulletNote -Subject "Message from $env:computername" -Message "User $env:username logge on to the computere"
  .EXAMPLE
    Send-PushbulletNote -Subject "To Device" -Message "Sent to specific device" -Device u1qSJddxeKwOGuGW
  .EXAMPLE
    Send-PushbulletNote -Subject "To Email" -Message "Sent to email" -Email george@georgemail.com
  .PARAMETER Subject
    This will be de subject line in your note
  .PARAMETER Message
    This will be the message in your note
  .PARAMETER Device
    Only send the push to these devices. Find the device_iden with Get-PushbulletDevices
   #>
  param
  (
        [Parameter(Mandatory=$True)]
        [string]$Subject,
	
        [Parameter(Mandatory=$True)]
        [string]$Message,
        [string]$Device,
        [string]$Email

  )

begin {
Write-Verbose "Fetching api key from file"
try {
    $apikey = get-content (Join-Path -Path $PSSCriptroot -ChildPath pushbullet.cfg)
     }
catch {Write-Output "Could not get apikey from config file. Exiting now."
Exit 1}
  


    $headers = @{Authorization = "Bearer $apikey"}

    $body = @{
        type = "note"
        title = $Subject
        body = $Message
        device_iden = $Device
        email = $Email
        }


    write-verbose "Sending push"
    $Sendattempt = Invoke-WebRequest -Uri https://api.pushbullet.com/v2/pushes -Method Post  -Headers $headers -Body $body
    If ($Sendattempt.StatusCode -eq "200"){Write-Verbose "Push sent successfully"}
        else {Write-Warning "Something went wrong. Check `$attempt for info"
              $global:attempt = $Sendattempt  }
    }

    }

function Get-PushBulletDevices {
  <#
  .SYNOPSIS
    Get a list of devices asociated with your pushbullet account.
    Enter your apikey in a file named pusbhullet.cfg, and place it in the same folder as this file.
  .EXAMPLE
    Get-PushBulletDevices
  #>
  param
  (
  )

begin {
Write-Verbose "Fetching api key from file"
try {
    $apikey = get-content (Join-Path -Path $PSSCriptroot -ChildPath pushbullet.cfg)
     }
catch {Write-Output "Could not get apikey from config file. Exiting now."
Exit 1}
  
    $headers = @{Authorization = "Bearer $apikey"}
    
    write-verbose "Getting devices"
    $Requestattempt = Invoke-WebRequest -Uri https://api.pushbullet.com/v2/devices -Method Get  -Credential $cred
    If ($Requestattempt.StatusCode -eq "200"){
    Write-Verbose "Got devices successfully"
    ($Devices = $Requestattempt.Content|Convertfrom-json).Devices
    Write-Verbose "Request returned $($Devices.Count) devices"
    #$Devices
    }
        else {Write-Warning "Something went wrong. Check `$attempt for info"
              $global:attempt = $Requestattempt  }
    }

    }