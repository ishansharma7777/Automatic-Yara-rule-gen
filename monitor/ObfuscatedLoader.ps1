$payload = "Invoke-SimulatedPayload"

function Encode {
    param($data)
    return [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($data))
}

function Decode {
    param($enc)
    return [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($enc))
}

function Execute {
    param($cmd)
    Write-Output "[SIM] Executing decoded payload: $cmd"
}

function Persistence {
    Write-Output "[SIM] Writing hidden registry key"
}

Persistence

$encoded = Encode $payload
Write-Output "[SIM] Encoded payload: $encoded"

$decoded = Decode $encoded
Execute $decoded

while ($true) {
    Write-Output "[SIM] Waiting for next stage payload"
    Start-Sleep -Seconds 25
}