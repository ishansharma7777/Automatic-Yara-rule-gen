$C2 = "stealer-adv.example.com"

function Enumerate-Paths {
    return @(
        "Chrome Login Data",
        "cookies.sqlite",
        "wallet.dat",
        "passwords.txt"
    )
}

function Read-Data {
    param($path)
    Write-Output "[SIM] Reading $path"
    return "dummy_data_$path"
}

function Encode {
    param($data)
    return [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($data))
}

function Exfiltrate {
    param($data)
    Write-Output "[SIM] Sending to $C2"
    Write-Output "[SIM] Data: $data"
}

function Persistence {
    Write-Output "[SIM] Copying file to hidden directory"
}

Persistence

$paths = Enumerate-Paths

foreach ($p in $paths) {
    $data = Read-Data $p
    $enc = Encode $data
    Exfiltrate $enc
}

while ($true) {
    Write-Output "[SIM] Monitoring for new data"
    Start-Sleep -Seconds 20
}