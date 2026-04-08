Set objShell = CreateObject("WScript.Shell")

Sub Stage1()
    WScript.Echo "[SIM] Stage 1: Initial beacon"
End Sub

Sub Stage2()
    WScript.Echo "[SIM] Stage 2: Download modules"
End Sub

Sub Stage3()
    WScript.Echo "[SIM] Stage 3: Execute modules"
End Sub

Sub Stage4()
    WScript.Echo "[SIM] Stage 4: Exfiltrate data"
End Sub

Stage1()
Stage2()
Stage3()
Stage4()

Do
    Stage1()
    WScript.Sleep 5000
Loop