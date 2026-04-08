$C2Server = "rat-sim.example.com"
$C2Port = 8080

function Get-SystemInfo {
    $info = @{
        ComputerName = $env:COMPUTERNAME
        Username = $env:USERNAME
        OS = (Get-WmiObject Win32_OperatingSystem).Caption
        Processors = (Get-WmiObject Win32_ComputerSystem).NumberOfProcessors
    }
    return $info
}

function Encode-Data {
    param($data)
    return [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($data))
}

function Simulate-Beacon {
    $data = Get-SystemInfo | ConvertTo-Json
    $encoded = Encode-Data $data

    Write-Output "[SIM] Beacon to http://$C2Server:$C2Port/beacon"
    Write-Output "[SIM] Payload: $encoded"
}

function Simulate-CommandFetch {
    Write-Output "[SIM] Fetching command from C2"
    return "Get-Process"
}

function Simulate-Execution {
    param($cmd)
    Write-Output "[SIM] Executing: $cmd"
    try {
        $result = Invoke-Expression $cmd
        Write-Output "[SIM] Execution result captured"
    } catch {
        Write-Output "[SIM] Execution failed"
    }
}

function Simulate-Persistence {
    Write-Output "[SIM] Creating scheduled task WindowsUpdateService"
    Write-Output "[SIM] Adding registry persistence key"
}

function Simulate-Exfiltration {
    $data = "sample sensitive data"
    $encoded = Encode-Data $data

    Write-Output "[SIM] Sending data to http://$C2Server/exfil"
    Write-Output "[SIM] Encoded: $encoded"
}

Simulate-Persistence

while ($true) {
    Simulate-Beacon
    $cmd = Simulate-CommandFetch

    if ($cmd) {
        Simulate-Execution $cmd
        Simulate-Exfiltration
    }

    Start-Sleep -Seconds 20
}