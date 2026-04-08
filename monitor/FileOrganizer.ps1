$source = "."
$extensions = @{
    "Images" = "*.jpg","*.png"
    "Docs" = "*.txt","*.pdf"
}

function Create-Folders {
    foreach ($key in $extensions.Keys) {
        if (-not (Test-Path $key)) {
            New-Item -ItemType Directory -Name $key | Out-Null
        }
    }
}

function Move-Files {
    foreach ($key in $extensions.Keys) {
        foreach ($ext in $extensions[$key]) {
            Get-ChildItem -Path $source -Filter $ext | ForEach-Object {
                Move-Item $_.FullName $key -Force
            }
        }
    }
}

Create-Folders
Move-Files
Write-Output "Files organized successfully"