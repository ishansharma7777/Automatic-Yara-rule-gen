$Wallet = "1ABCXYZ123"
$TargetPath = "C:\Users\Public\Documents"

function Scan-Files {
    Write-Output "[SIM] Scanning directory: $TargetPath"
    return @("file1.docx", "file2.pdf", "file3.xlsx")
}

function Simulate-Encryption {
    param($file)

    Write-Output "[SIM] Encrypting $file using AES-256"
    $fake = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($file))
    Write-Output "[SIM] Encrypted content: $fake"
}

function Create-RansomNote {
    $note = @"
Your files have been encrypted.
Send 0.5 BTC to wallet: $Wallet
Contact: attacker@protonmail.com
"@

    Write-Output "[SIM] Creating ransom note"
    Write-Output $note
}

function Disable-Security {
    Write-Output "[SIM] Disabling Defender (simulated)"
    Write-Output "[SIM] Disabling Firewall (simulated)"
}

function Persistence {
    Write-Output "[SIM] Adding startup persistence"
}

Disable-Security
Persistence

$files = Scan-Files

foreach ($file in $files) {
    Simulate-Encryption $file
}

Create-RansomNote

while ($true) {
    Write-Output "[SIM] Waiting for payment confirmation..."
    Start-Sleep -Seconds 30
}