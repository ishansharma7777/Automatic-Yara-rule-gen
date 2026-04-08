Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

C2_HOST = "example-test-domain.com"
C2_PORT = 443

Sub SimulateBeacon()
    WScript.Echo "Simulating network beacon to https://" & C2_HOST & ":" & C2_PORT & "/beacon"
End Sub

Sub SimulatePersistence()
    startup_folder = objShell.SpecialFolders("Startup")
    test_file = startup_folder & "\TestSimulation.txt"
    Set f = objFSO.CreateTextFile(test_file, True)
    f.WriteLine "Persistence simulation"
    f.Close
End Sub

Sub SimulateCommandExecution()
    suspicious_cmd = "powershell.exe -Command Write-Output Test"
    WScript.Echo "Simulated command: " & suspicious_cmd
End Sub

Sub SimulateCredentialAccess()
    suspicious_paths = Array( _
        "Desktop\passwords.txt", _
        "Documents\login.xlsx", _
        "AppData\Local\Google\Chrome\User Data\Default\Login Data" _
    )

    For Each path In suspicious_paths
        WScript.Echo "Simulated access to: " & path
    Next
End Sub

SimulateBeacon()
SimulatePersistence()
SimulateCommandExecution()
SimulateCredentialAccess()

WScript.Echo "Simulation complete."