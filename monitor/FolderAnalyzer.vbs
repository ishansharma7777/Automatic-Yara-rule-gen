Set objFSO = CreateObject("Scripting.FileSystemObject")

Function GetFolderSize(path)
    Dim folder, file, total
    total = 0
    
    Set folder = objFSO.GetFolder(path)
    
    For Each file In folder.Files
        total = total + file.Size
    Next
    
    GetFolderSize = total
End Function

Function GetFileCount(path)
    Dim folder
    Set folder = objFSO.GetFolder(path)
    
    GetFileCount = folder.Files.Count
End Function

Sub DisplayStats(path)
    WScript.Echo "Size: " & GetFolderSize(path)
    WScript.Echo "Files: " & GetFileCount(path)
End Sub

DisplayStats "."