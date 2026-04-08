Set objShell = CreateObject("WScript.Shell")

Function GetUser()
    GetUser = objShell.ExpandEnvironmentStrings("%USERNAME%")
End Function

Function GetPath()
    GetPath = objShell.CurrentDirectory
End Function

Sub Display()
    WScript.Echo "User: " & GetUser()
    WScript.Echo "Path: " & GetPath()
End Sub

Sub Run()
    Dim i
    
    For i = 1 To 5
        Display()
    Next
End Sub

Run()