$C2Server = "c2-full.example.com"
$C2Port = 8080

function Get-SystemInfo {
    $sys = @{}
    $sys["Computer"] = $env:COMPUTERNAME
    $sys["User"] = $env:USERNAME
    $sys["OS"] = (Get-WmiObject Win32_OperatingSystem).Caption
    $sys["CPU"] = (Get-WmiObject Win32_ComputerSystem).NumberOfProcessors
    $sys["Time"] = Get-Date
    return $sys
}

function Encode-Data {
    param($data)
    return [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($data))
}

function Beacon {
    $data = Get-SystemInfo | ConvertTo-Json
    $encoded = Encode-Data $data

    Write-Output "[SIM] Sending beacon to http://$C2Server:$C2Port/beacon"
    Write-Output "[SIM] Encoded payload: $encoded"
}

function Fetch-Command {
    Write-Output "[SIM] Fetching command from C2"
    $commands = @("Get-Process", "Get-Service", "whoami")
    return Get-Random $commands
}

function Execute-Command {
    param($cmd)
    Write-Output "[SIM] Executing command: $cmd"

    try {
        $result = Invoke-Expression $cmd
        Write-Output "[SIM] Execution completed"
    } catch {
        Write-Output "[SIM] Execution failed"
    }
}

function Simulate-Persistence {
    Write-Output "[SIM] Creating scheduled task"
    Write-Output "[SIM] Writing registry run key"
}

function Exfiltrate-Data {
    $fakeData = @("file1.txt", "passwords.db", "notes.docx")

    foreach ($f in $fakeData) {
        $encoded = Encode-Data $f
        Write-Output "[SIM] Exfiltrating $f"
        Write-Output "[SIM] Data: $encoded"
    }
}

Simulate-Persistence

while ($true) {
    Beacon

    $cmd = Fetch-Command
    Execute-Command $cmd

    Exfiltrate-Data

    Start-Sleep -Seconds 20
}