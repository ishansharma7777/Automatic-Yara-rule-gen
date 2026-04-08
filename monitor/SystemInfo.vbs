Set objShell = CreateObject("WScript.Shell")

Function GetUser()
    GetUser = objShell.ExpandEnvironmentStrings("%USERNAME%")
End Function

Function GetComputer()
    GetComputer = objShell.ExpandEnvironmentStrings("%COMPUTERNAME%")
End Function

Function GetTime()
    GetTime = Now
End Function

Sub DisplayHeader()
    WScript.Echo "----- SYSTEM INFO -----"
End Sub

Sub DisplayFooter()
    WScript.Echo "-----------------------"
End Sub

Sub ShowInfo()
    DisplayHeader
    
    WScript.Echo "User: " & GetUser()
    WScript.Echo "Computer: " & GetComputer()
    WScript.Echo "Time: " & GetTime()
    
    DisplayFooter
End Sub

Do
    ShowInfo()
    WScript.Sleep 4000
Loop