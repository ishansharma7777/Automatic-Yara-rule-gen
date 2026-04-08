Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

C2_HOST = "rat-vbs.example.com"
C2_PORT = 8080

Function GetSystemInfo()
    Dim info
    info = "User=" & objShell.ExpandEnvironmentStrings("%USERNAME%") & _
           ";Computer=" & objShell.ExpandEnvironmentStrings("%COMPUTERNAME%")
    GetSystemInfo = info
End Function

Sub SimulateBeacon()
    Dim data
    data = GetSystemInfo()
    WScript.Echo "[SIM] Beacon to http://" & C2_HOST & ":" & C2_PORT & "/beacon"
    WScript.Echo "[SIM] Data: " & data
End Sub

Sub SimulateCommandFetch()
    WScript.Echo "[SIM] Fetching command from C2"
End Sub

Sub SimulateExecution()
    Dim cmd
    cmd = "cmd.exe /c whoami"
    WScript.Echo "[SIM] Executing: " & cmd
End Sub

Sub SimulatePersistence()
    Dim path
    path = objShell.SpecialFolders("Startup") & "\Updater.vbs"
    WScript.Echo "[SIM] Writing persistence file to " & path
End Sub

Sub SimulateExfiltration()
    WScript.Echo "[SIM] Sending data to http://" & C2_HOST & "/exfil"
End Sub

SimulatePersistence()

Do
    SimulateBeacon()
    SimulateCommandFetch()
    SimulateExecution()
    SimulateExfiltration()
    WScript.Sleep 5000
Loop