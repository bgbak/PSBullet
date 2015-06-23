function Send-PushBulletNote {
  <#
  .SYNOPSIS
    Send pushbullet notification to your devices from PowerShell
    Enter your apikey in a file named pusbhullet.cfg, and place it in the same folder as this file.
  .DESCRIPTION
    Use PowerShell to send notification to your devices with Pushbullet.
    For now the only supported function is a text note, and it is not possible to specify devices.
  .EXAMPLE
    Send-PushBulletNote -Subject "Warning!" -Message "The coffemachine is out of coffe"
  .EXAMPLE
    Send-PushBulletNote -Subject "Message from $env:computername" -Message "User $env:username logge on to the computere"
  .PARAMETER Subject
    This will be de subject line in your note
  .PARAMETER Message
    This will be the message in your note
   #>
  param
  (
        [Parameter(Mandatory=$True)]
        [string]$Subject,
	
        [Parameter(Mandatory=$True)]
        [string]$Message,
        [string]$Device

  )

begin {
Write-Verbose "Fetching api key from file"
try {
    $apikey = get-content (Join-Path -Path $PSSCriptroot -ChildPath pushbullet.cfg)
     }
catch {Write-Output "Could not get apikey from config file. Exiting now."
Exit 1}
  


    $headers = @{
        Authorization = "Bearer $apikey"
        }

    $body = @{
        type = "note"
        title = $Subject
        body = $Message
        device_iden = $Device
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
  
    $cred = New-Object System.Management.Automation.PSCredential ($apikey,(get-Random -min 1 -max 10| ConvertTo-SecureString -AsPlainText -Force))
    
    write-verbose "Getting devices"
    $Requestattempt = Invoke-WebRequest -Uri https://api.pushbullet.com/v2/devices -Method Get  -Credential $cred
    If ($Requestattempt.StatusCode -eq "200"){
    Write-Verbose "Got devices successfully"
    $Requestattempt}
        else {Write-Warning "Something went wrong. Check `$attempt for info"
              $global:attempt = $Requestattempt  }
    }

    }