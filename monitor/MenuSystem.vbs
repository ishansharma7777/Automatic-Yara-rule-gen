Function ShowMenu()
    WScript.Echo "1. Option A"
    WScript.Echo "2. Option B"
    WScript.Echo "3. Exit"
End Function

Sub HandleOption(opt)
    If opt = 1 Then
        WScript.Echo "Selected A"
    ElseIf opt = 2 Then
        WScript.Echo "Selected B"
    Else
        WScript.Echo "Exit"
    End If
End Sub

Dim i
For i = 1 To 3
    ShowMenu()
    HandleOption i
Next