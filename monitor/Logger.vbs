Set objFSO = CreateObject("Scripting.FileSystemObject")

logFile = "app_log.txt"

Function GetTimestamp()
    GetTimestamp = Now
End Function

Sub WriteLog(msg)
    Dim f
    Set f = objFSO.OpenTextFile(logFile, 8, True)
    
    f.WriteLine GetTimestamp() & " - " & msg
    
    f.Close
End Sub

Sub RunLogger()
    Dim i
    
    For i = 1 To 30
        WriteLog "Running iteration " & i
    Next
End Sub

RunLogger()

WScript.Echo "Logging completed"