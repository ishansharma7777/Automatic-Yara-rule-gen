Set objShell = CreateObject("WScript.Shell")

Sub ExtractBrowserData()
    Dim paths
    paths = Array( _
        "Chrome\User Data\Default\Login Data", _
        "Edge\User Data\Default\Cookies" _
    )

    For Each p In paths
        WScript.Echo "[SIM] Accessing: " & p
    Next
End Sub

Sub SendToServer()
    WScript.Echo "[SIM] Sending browser data to C2"
End Sub

ExtractBrowserData()
SendToServer()