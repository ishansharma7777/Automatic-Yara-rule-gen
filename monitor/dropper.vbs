Set objShell = CreateObject("WScript.Shell")

Sub DownloadPayload(url)
    WScript.Echo "[SIM] Downloading from " & url
End Sub

Sub LoadPayload(name)
    WScript.Echo "[SIM] Loading " & name & " into memory"
End Sub

Sub ExecutePayload(name)
    WScript.Echo "[SIM] Executing " & name
End Sub

Sub Persistence()
    WScript.Echo "[SIM] Writing Run key"
    WScript.Echo "[SIM] Creating scheduled task"
End Sub

Dim payloads
payloads = Array( _
    "http://example.com/payload1.exe", _
    "http://example.com/payload2.exe" _
)

Persistence()

For Each p In payloads
    DownloadPayload p
    LoadPayload p
    ExecutePayload p
Next

Do
    WScript.Echo "[SIM] Waiting for instructions..."
    WScript.Sleep 7000
Loop