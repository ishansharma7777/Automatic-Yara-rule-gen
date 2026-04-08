Set objShell = CreateObject("WScript.Shell")

BTC_WALLET = "1FAKEBTCADDRESS123"

Sub ScanFiles()
    Dim files
    files = Array("file1.docx", "file2.pdf", "file3.xlsx")

    For Each f In files
        WScript.Echo "[SIM] Found file: " & f
    Next
End Sub

Sub EncryptFile(file)
    WScript.Echo "[SIM] Encrypting " & file & " using AES-256"
End Sub

Sub CreateRansomNote()
    WScript.Echo "==== RANSOM NOTE ===="
    WScript.Echo "Your files are encrypted."
    WScript.Echo "Send BTC to: " & BTC_WALLET
End Sub

Sub DisableSecurity()
    WScript.Echo "[SIM] Disabling Defender"
    WScript.Echo "[SIM] Disabling Firewall"
End Sub

Sub Persistence()
    WScript.Echo "[SIM] Adding startup persistence"
End Sub

DisableSecurity()
Persistence()
ScanFiles()

Dim files
files = Array("file1.docx", "file2.pdf")

For Each f In files
    EncryptFile f
Next

CreateRansomNote()

Do
    WScript.Echo "[SIM] Waiting for payment..."
    WScript.Sleep 6000
Loop