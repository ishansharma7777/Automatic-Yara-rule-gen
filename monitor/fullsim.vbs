Set objShell = CreateObject("WScript.Shell")

C2 = "fullsim.example.com"

Sub Beacon()
    WScript.Echo "[SIM] Beacon to " & C2
End Sub

Sub Persistence()
    WScript.Echo "[SIM] Persistence installed"
End Sub

Sub Execute()
    WScript.Echo "[SIM] Running command: cmd.exe /c dir"
End Sub

Sub Exfiltrate()
    WScript.Echo "[SIM] Sending data to " & C2
End Sub

Persistence()

Do
    Beacon()
    Execute()
    Exfiltrate()
    WScript.Sleep 4000
Loop