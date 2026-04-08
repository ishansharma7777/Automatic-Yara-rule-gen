$C2 = "stealer-full.example.com"

function Get-UserInfo {
    return @{
        User = $env:USERNAME
        Host = $env:COMPUTERNAME
    }
}

function Capture-Keystrokes {
    $keys = @("a","b","c","1","2","3")

    foreach ($k in $keys) {
        Write-Output "[SIM] Key captured: $k"
    }
}

function Collect-Files {
    $targets = @(
        "Desktop\passwords.txt",
        "Documents\accounts.xlsx",
        "Chrome Login Data"
    )

    foreach ($file in $targets) {
        Write-Output "[SIM] Found file: $file"
    }

    return $targets
}

function Encode-And-Send {
    param($data)

    $encoded = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($data))

    Write-Output "[SIM] Sending data to http://$C2/exfil"
    Write-Output "[SIM] Payload: $encoded"
}

function Drop-Payload {
    Write-Output "[SIM] Downloading payload from http://payload.example.com"
    Write-Output "[SIM] Injecting payload into memory"
}

function Persistence {
    Write-Output "[SIM] Writing registry persistence"
    Write-Output "[SIM] Copying to startup folder"
}

function Beacon {
    $info = Get-UserInfo | ConvertTo-Json
    Write-Output "[SIM] Beacon: $info"
}

Persistence
Drop-Payload

$files = Collect-Files

foreach ($f in $files) {
    Encode-And-Send $f
}

Capture-Keystrokes

while ($true) {
    Beacon
    Start-Sleep -Seconds 25
}