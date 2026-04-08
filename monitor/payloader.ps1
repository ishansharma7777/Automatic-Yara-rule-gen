$PAYLOADS = @(
    "http://example.com/payload1.exe",
    "http://example.com/payload2.exe",
    "http://example.com/payload3.exe"
)

function Download-Payload {
    param($url)
    Write-Output "[SIM] Downloading from $url"
}

function Load-InMemory {
    param($name)
    Write-Output "[SIM] Injecting $name into memory"
}

function Execute-Payload {
    param($name)
    Write-Output "[SIM] Executing $name"
}

function Persistence {
    Write-Output "[SIM] Writing startup entry"
}

Persistence

foreach ($p in $PAYLOADS) {
    Download-Payload $p
    Load-InMemory $p
    Execute-Payload $p
}

while ($true) {
    Write-Output "[SIM] Waiting for new payload instructions"
    Start-Sleep -Seconds 30
}