$C2 = "reverse-shell.example.com"

function Connect-C2 {
    Write-Output "[SIM] Establishing reverse shell connection to $C2"
}

function Receive-Command {
    $cmds = @("dir", "whoami", "Get-Process")
    return Get-Random $cmds
}

function Execute {
    param($cmd)
    Write-Output "[SIM] Running command: $cmd"
}

function Send-Output {
    Write-Output "[SIM] Sending output back to C2"
}

function Persistence {
    Write-Output "[SIM] Creating service for persistence"
}

Persistence
Connect-C2

while ($true) {
    $cmd = Receive-Command
    Execute $cmd
    Send-Output
    Start-Sleep -Seconds 15
}