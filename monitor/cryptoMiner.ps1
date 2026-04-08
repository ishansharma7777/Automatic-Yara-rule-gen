$POOL = "stratum+tcp://miner.sim.example:4444"

function Initialize-Miner {
    Write-Output "[SIM] Initializing miner configuration"
    $config = @{
        threads = 4
        algorithm = "randomx"
        pool = $POOL
    }
    return $config
}

function Simulate-CPU-Usage {
    for ($i=1; $i -le 15; $i++) {
        $cpu = Get-Random -Minimum 85 -Maximum 100
        Write-Output "[SIM] Mining loop $i - CPU usage: $cpu%"
        Start-Sleep -Milliseconds 300
    }
}

function Submit-Hashes {
    Write-Output "[SIM] Submitting hashes to $POOL"
}

function Persistence {
    Write-Output "[SIM] Adding miner to startup"
    Write-Output "[SIM] Creating scheduled task"
}

$config = Initialize-Miner
Persistence
Simulate-CPU-Usage
Submit-Hashes

while ($true) {
    Simulate-CPU-Usage
    Submit-Hashes
    Start-Sleep -Seconds 20
}