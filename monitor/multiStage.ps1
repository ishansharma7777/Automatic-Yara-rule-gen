$C2 = "multiStage.example.com"

function Stage1-Beacon {
    Write-Output "[SIM] Stage1: Initial beacon to $C2"
}

function Stage2-Download {
    Write-Output "[SIM] Stage2: Downloading modules"
}

function Stage3-Persistence {
    Write-Output "[SIM] Stage3: Establishing persistence"
}

function Stage4-Execution {
    $cmds = @("whoami", "Get-Service", "Get-Process")

    foreach ($c in $cmds) {
        Write-Output "[SIM] Executing $c"
    }
}

function Stage5-Exfiltration {
    $data = "sensitive_data"
    $encoded = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($data))

    Write-Output "[SIM] Exfiltrating data to $C2"
    Write-Output "[SIM] Payload: $encoded"
}

function Stage6-Loop {
    while ($true) {
        Stage1-Beacon
        Stage4-Execution
        Stage5-Exfiltration
        Start-Sleep -Seconds 20
    }
}

Stage1-Beacon
Stage2-Download
Stage3-Persistence
Stage4-Execution
Stage5-Exfiltration

Stage6-Loop