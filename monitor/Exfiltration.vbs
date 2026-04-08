Set objShell = CreateObject("WScript.Shell")

C2 = "keylog.example.com"

Function CaptureKeys()
    Dim keys
    keys = Array("a","b","c","1","2","3")
    
    For Each k In keys
        WScript.Echo "[SIM] Key captured: " & k
    Next
End Function

Function Encode(data)
    Encode = "[ENC]" & data
End Function

Sub SendData(data)
    WScript.Echo "[SIM] Sending keystrokes to http://" & C2
    WScript.Echo "[SIM] Payload: " & data
End Sub

CaptureKeys()
SendData Encode("abc123")

Do
    WScript.Echo "[SIM] Logging keys..."
    WScript.Sleep 4000
Loop