Set objShell = CreateObject("WScript.Shell")

C2 = "backdoor-vbs.example.com"

Sub Beacon()
    WScript.Echo "[SIM] Beacon to " & C2
End Sub

Function GetCommand()
    GetCommand = "dir"
End Function

Sub Execute(cmd)
    WScript.Echo "[SIM] Executing command: " & cmd
End Sub

Sub SendResult()
    WScript.Echo "[SIM] Sending result to C2"
End Sub

Sub Persistence()
    WScript.Echo "[SIM] Installing persistence"
End Sub

Persistence()

Do
    Beacon()
    cmd = GetCommand()
    Execute cmd
    SendResult()
    WScript.Sleep 5000
Loop