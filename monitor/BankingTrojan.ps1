$C2 = "banking-full.example.com"

function Capture-Session {
    $session = @{
        url = "bank.com/login"
        username = "user123"
        password = "securePass"
        otp = "123456"
    }
    return $session
}

function Encode-Session {
    param($session)
    $json = $session | ConvertTo-Json
    return [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($json))
}

function Send-To-C2 {
    param($data)
    Write-Output "[SIM] Sending session data to $C2"
    Write-Output "[SIM] Payload: $data"
}

function Inject-Browser {
    Write-Output "[SIM] Injecting script into browser session"
}

function Persistence {
    Write-Output "[SIM] Adding registry persistence"
    Write-Output "[SIM] Creating hidden task"
}

Persistence
Inject-Browser

while ($true) {
    $session = Capture-Session
    $encoded = Encode-Session $session
    Send-To-C2 $encoded
    Start-Sleep -Seconds 25
}