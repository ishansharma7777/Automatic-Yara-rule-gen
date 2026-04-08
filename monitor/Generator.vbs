Randomize

Function GenerateNumber()
    GenerateNumber = Int((100 * Rnd) + 1)
End Function

Sub PrintNumbers()
    Dim i
    
    For i = 1 To 15
        WScript.Echo "Number: " & GenerateNumber()
    Next
End Sub

Sub RunCycle()
    PrintNumbers()
End Sub

Do
    RunCycle()
    WScript.Sleep 3000
Loop