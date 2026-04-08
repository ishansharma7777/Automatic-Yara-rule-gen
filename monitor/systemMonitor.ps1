$interval = 3

function Get-SystemInfo {
    $info = @{
        User = $env:USERNAME
        Computer = $env:COMPUTERNAME
        Time = Get-Date
    }
    return $info
}

function Get-CPUUsage {
    $cpu = Get-Counter '\Processor(_Total)\% Processor Time'
    return [math]::Round($cpu.CounterSamples.CookedValue,2)
}

function Get-MemoryUsage {
    $mem = Get-Counter '\Memory\Available MBytes'
    return $mem.CounterSamples.CookedValue
}

function Display-Stats {
    $info = Get-SystemInfo
    $cpu = Get-CPUUsage
    $mem = Get-MemoryUsage

    Write-Output "User: $($info.User)"
    Write-Output "Computer: $($info.Computer)"
    Write-Output "Time: $($info.Time)"
    Write-Output "CPU: $cpu %"
    Write-Output "Memory Available: $mem MB"
    Write-Output "---------------------------"
}

while ($true) {
    Display-Stats
    Start-Sleep -Seconds $interval
}