Set objFSO = CreateObject("Scripting.FileSystemObject")

Function GetFolderPath()
    GetFolderPath = "."
End Function

Sub ListFiles(path)
    Dim folder, file
    Set folder = objFSO.GetFolder(path)
    
    WScript.Echo "Listing files in: " & path
    
    For Each file In folder.Files
        WScript.Echo "File: " & file.Name
    Next
End Sub

Sub ListFolders(path)
    Dim folder, subf
    Set folder = objFSO.GetFolder(path)
    
    For Each subf In folder.SubFolders
        WScript.Echo "Folder: " & subf.Name
    Next
End Sub

Sub RunExplorer()
    Dim p
    p = GetFolderPath()
    
    ListFiles p
    ListFolders p
End Sub

RunExplorer()