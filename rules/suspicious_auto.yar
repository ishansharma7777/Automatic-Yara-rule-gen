/* Auto-generated from dashboard labels */

rule suspicious_AdvanceStealer_ps1
{
    meta:
        source_file = "AdvanceStealer.ps1"
        label = "suspicious"
        sha256 = "174979618f8c30e7a0472e43018f363b1e510b841c3e00c5516380339bd3add6"
        updated_at = "2026-03-22 18:16:44 UTC"
    strings:
        $s1 = "$C2 = \"stealer-adv.example.com\"" nocase
        $s2 = "function Enumerate-Paths {" nocase
        $s3 = "return @(" nocase
        $s4 = "\"Chrome Login Data\"," nocase
        $s5 = "\"cookies.sqlite\"," nocase
        $s6 = "\"wallet.dat\"," nocase
        $s7 = "\"passwords.txt\"" nocase
        $s8 = ")" nocase
        $s9 = "function Read-Data {" nocase
        $s10 = "param($path)" nocase
        $s11 = "Write-Output \"[SIM] Reading $path\"" nocase
        $s12 = "return \"dummy_data_$path\"" nocase
    condition:
        1 of them
}
rule suspicious_BankingTrojan_ps1
{
    meta:
        source_file = "BankingTrojan.ps1"
        label = "suspicious"
        sha256 = "20bbf7b714eb9c56c3aa3077277876b81094fbeb26ca4fab9cd6a0c24e61d641"
        updated_at = "2026-03-22 18:14:59 UTC"
    strings:
        $s1 = "$C2 = \"banking-full.example.com\"" nocase
        $s2 = "function Capture-Session {" nocase
        $s3 = "$session = @{" nocase
        $s4 = "url = \"bank.com/login\"" nocase
        $s5 = "username = \"user123\"" nocase
        $s6 = "password = \"securePass\"" nocase
        $s7 = "otp = \"123456\"" nocase
        $s8 = "}" nocase
        $s9 = "return $session" nocase
        $s10 = "function Encode-Session {" nocase
        $s11 = "param($session)" nocase
        $s12 = "$json = $session | ConvertTo-Json" nocase
    condition:
        1 of them
}
rule suspicious_BrowserCredentials_vbs
{
    meta:
        source_file = "BrowserCredentials.vbs"
        label = "suspicious"
        sha256 = "de30d1f6f0ffcc21b67452a0a458acb03a7c2e9277f3aea35bd276ce17325813"
        updated_at = "2026-03-22 18:15:12 UTC"
    strings:
        $s1 = "Set objShell = CreateObject(\"WScript.Shell\")" nocase
        $s2 = "Sub ExtractBrowserData()" nocase
        $s3 = "Dim paths" nocase
        $s4 = "paths = Array( _" nocase
        $s5 = "\"Chrome\\User Data\\Default\\Login Data\", _" nocase
        $s6 = "\"Edge\\User Data\\Default\\Cookies\" _" nocase
        $s7 = ")" nocase
        $s8 = "For Each p In paths" nocase
        $s9 = "WScript.Echo \"[SIM] Accessing: \" & p" nocase
        $s10 = "Next" nocase
        $s11 = "End Sub" nocase
        $s12 = "Sub SendToServer()" nocase
    condition:
        1 of them
}
rule suspicious_Dropper_ps1
{
    meta:
        source_file = "Dropper.ps1"
        label = "suspicious"
        sha256 = "509312d2f771a1b213e8288fe4b4522b13e4c06c2a374786d6f944e697e564b8"
        updated_at = "2026-03-22 18:16:49 UTC"
    strings:
        $s1 = "$C2 = \"stealer.example.com\"" nocase
        $s2 = "function Encode-And-Send {" nocase
        $s3 = "param($content)" nocase
        $s4 = "$encoded = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($content))" nocase
        $s5 = "Write-Output \"[SIM] Sending to http://$C2/exfil\"" nocase
        $s6 = "Write-Output \"[SIM] Data: $encoded\"" nocase
        $s7 = "function Drop-Payload {" nocase
        $s8 = "Write-Output \"[SIM] Downloading payload from http://malware.example.com\"" nocase
        $s9 = "Write-Output \"[SIM] Executing payload\"" nocase
        $s10 = "function Persistence {" nocase
        $s11 = "Write-Output \"[SIM] Writing registry run key\"" nocase
        $s12 = "function Beacon {" nocase
    condition:
        1 of them
}
rule suspicious_Exfiltration_vbs
{
    meta:
        source_file = "Exfiltration.vbs"
        label = "suspicious"
        sha256 = "436005ae67cfc7053d44eb118569c10c713a4dc71d48ed679157b3ac388552c6"
        updated_at = "2026-03-22 18:16:54 UTC"
    strings:
        $s1 = "Set objShell = CreateObject(\"WScript.Shell\")" nocase
        $s2 = "C2 = \"keylog.example.com\"" nocase
        $s3 = "Function CaptureKeys()" nocase
        $s4 = "Dim keys" nocase
        $s5 = "keys = Array(\"a\",\"b\",\"c\",\"1\",\"2\",\"3\")" nocase
        $s6 = "For Each k In keys" nocase
        $s7 = "WScript.Echo \"[SIM] Key captured: \" & k" nocase
        $s8 = "Next" nocase
        $s9 = "End Function" nocase
        $s10 = "Function Encode(data)" nocase
        $s11 = "Encode = \"[ENC]\" & data" nocase
        $s12 = "Sub SendData(data)" nocase
    condition:
        1 of them
}
rule suspicious_FileExplorer_vbs
{
    meta:
        source_file = "FileExplorer.vbs"
        label = "suspicious"
        sha256 = "6c60fc1e103a1e721650ee639a1118086b970536cff5a7324b7b900ba3dd2134"
        updated_at = "2026-03-22 18:20:51 UTC"
    strings:
        $s1 = "Set objFSO = CreateObject(\"Scripting.FileSystemObject\")" nocase
        $s2 = "Function GetFolderPath()" nocase
        $s3 = "GetFolderPath = \".\"" nocase
        $s4 = "End Function" nocase
        $s5 = "Sub ListFiles(path)" nocase
        $s6 = "Dim folder, file" nocase
        $s7 = "Set folder = objFSO.GetFolder(path)" nocase
        $s8 = "WScript.Echo \"Listing files in: \" & path" nocase
        $s9 = "For Each file In folder.Files" nocase
        $s10 = "WScript.Echo \"File: \" & file.Name" nocase
        $s11 = "Next" nocase
        $s12 = "End Sub" nocase
    condition:
        1 of them
}
rule suspicious_FileOrganizer_ps1
{
    meta:
        source_file = "FileOrganizer.ps1"
        label = "suspicious"
        sha256 = "b3d6823c42d7d19f6ed48f41365a363261407f505c8bbd99a953f78c5ddafa6b"
        updated_at = "2026-03-22 18:20:57 UTC"
    strings:
        $s1 = "$source = \".\"" nocase
        $s2 = "$extensions = @{" nocase
        $s3 = "\"Images\" = \"*.jpg\",\"*.png\"" nocase
        $s4 = "\"Docs\" = \"*.txt\",\"*.pdf\"" nocase
        $s5 = "function Create-Folders {" nocase
        $s6 = "foreach ($key in $extensions.Keys) {" nocase
        $s7 = "if (-not (Test-Path $key)) {" nocase
        $s8 = "New-Item -ItemType Directory -Name $key | Out-Null" nocase
        $s9 = "}" nocase
        $s10 = "function Move-Files {" nocase
        $s11 = "foreach ($ext in $extensions[$key]) {" nocase
        $s12 = "Get-ChildItem -Path $source -Filter $ext | ForEach-Object {" nocase
    condition:
        1 of them
}
rule suspicious_MultiStage_py
{
    meta:
        source_file = "MultiStage.py"
        label = "suspicious"
        sha256 = "ca903e0b4aefab73d41bee34e951980a83c88885fd33c4097763d910f4a90808"
        updated_at = "2026-03-22 18:21:25 UTC"
    strings:
        $s1 = "import time,base64,random" nocase
        $s2 = "C2=\"multi.example.com\"" nocase
        $s3 = "def stage1():" nocase
        $s4 = "print(\"s1\")" nocase
        $s5 = "def stage2():" nocase
        $s6 = "print(\"s2\")" nocase
        $s7 = "def stage3():" nocase
        $s8 = "data=str(random.randint(1,100))" nocase
        $s9 = "return base64.b64encode(data.encode()).decode()" nocase
        $s10 = "def stage4(d):" nocase
        $s11 = "print(\"send\",C2,d[:20])" nocase
        $s12 = "while True:" nocase
    condition:
        1 of them
}
rule suspicious_MultiStage_vbs
{
    meta:
        source_file = "MultiStage.vbs"
        label = "suspicious"
        sha256 = "b3b5e5ed3f95d7586f1aad5ceb3236a1b1f5f6517c901b6f14772e761051df55"
        updated_at = "2026-03-22 18:21:28 UTC"
    strings:
        $s1 = "Set objShell = CreateObject(\"WScript.Shell\")" nocase
        $s2 = "Sub Stage1()" nocase
        $s3 = "WScript.Echo \"[SIM] Stage 1: Initial beacon\"" nocase
        $s4 = "End Sub" nocase
        $s5 = "Sub Stage2()" nocase
        $s6 = "WScript.Echo \"[SIM] Stage 2: Download modules\"" nocase
        $s7 = "Sub Stage3()" nocase
        $s8 = "WScript.Echo \"[SIM] Stage 3: Execute modules\"" nocase
        $s9 = "Sub Stage4()" nocase
        $s10 = "WScript.Echo \"[SIM] Stage 4: Exfiltrate data\"" nocase
        $s11 = "Stage1()" nocase
        $s12 = "Stage2()" nocase
    condition:
        1 of them
}
rule suspicious_ObfuscatedLoader_ps1
{
    meta:
        source_file = "ObfuscatedLoader.ps1"
        label = "suspicious"
        sha256 = "c3fc1d5c7596d11178b2b4311ddfb39342e3b10dbec2be530ea9e7889de57f90"
        updated_at = "2026-03-22 18:21:16 UTC"
    strings:
        $s1 = "$payload = \"Invoke-SimulatedPayload\"" nocase
        $s2 = "function Encode {" nocase
        $s3 = "param($data)" nocase
        $s4 = "return [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($data))" nocase
        $s5 = "function Decode {" nocase
        $s6 = "param($enc)" nocase
        $s7 = "return [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($enc))" nocase
        $s8 = "function Execute {" nocase
        $s9 = "param($cmd)" nocase
        $s10 = "Write-Output \"[SIM] Executing decoded payload: $cmd\"" nocase
        $s11 = "function Persistence {" nocase
        $s12 = "Write-Output \"[SIM] Writing hidden registry key\"" nocase
    condition:
        1 of them
}
rule suspicious_Stealer_py
{
    meta:
        source_file = "Stealer.py"
        label = "suspicious"
        sha256 = "849ea726b63ffe1199f147b937000b128e97ec01fce9fde81f243e073585caa0"
        updated_at = "2026-03-22 18:23:25 UTC"
    strings:
        $s1 = "import os,time,base64,random" nocase
        $s2 = "C2=\"xl2.example.com\"" nocase
        $s3 = "FILES=[f\"file_{i}.txt\" for i in range(25)]" nocase
        $s4 = "def scan():" nocase
        $s5 = "found=[]" nocase
        $s6 = "for f in FILES:" nocase
        $s7 = "print(\"found\",f)" nocase
        $s8 = "found.append(f)" nocase
        $s9 = "return found" nocase
        $s10 = "def encode(x):" nocase
        $s11 = "return base64.b64encode(x.encode()).decode()" nocase
        $s12 = "def transform(data):" nocase
    condition:
        1 of them
}
rule suspicious_SystemInfo_vbs
{
    meta:
        source_file = "SystemInfo.vbs"
        label = "suspicious"
        sha256 = "042ca4e3ea0076896796825650536f74a5b37870d651431476526e684399c7a2"
        updated_at = "2026-03-22 18:23:32 UTC"
    strings:
        $s1 = "Set objShell = CreateObject(\"WScript.Shell\")" nocase
        $s2 = "Function GetUser()" nocase
        $s3 = "GetUser = objShell.ExpandEnvironmentStrings(\"%USERNAME%\")" nocase
        $s4 = "End Function" nocase
        $s5 = "Function GetComputer()" nocase
        $s6 = "GetComputer = objShell.ExpandEnvironmentStrings(\"%COMPUTERNAME%\")" nocase
        $s7 = "Function GetTime()" nocase
        $s8 = "GetTime = Now" nocase
        $s9 = "Sub DisplayHeader()" nocase
        $s10 = "WScript.Echo \"----- SYSTEM INFO -----\"" nocase
        $s11 = "End Sub" nocase
        $s12 = "Sub DisplayFooter()" nocase
    condition:
        1 of them
}
rule suspicious_c2_ps1
{
    meta:
        source_file = "c2.ps1"
        label = "suspicious"
        sha256 = "c0b323cca58572a05b7ccb60dcd1c36594cf72b403ba23ce562bf202266ca235"
        updated_at = "2026-03-22 18:21:41 UTC"
    strings:
        $s1 = "$C2Server = \"c2-full.example.com\"" nocase
        $s2 = "$C2Port = 8080" nocase
        $s3 = "function Get-SystemInfo {" nocase
        $s4 = "$sys = @{}" nocase
        $s5 = "$sys[\"Computer\"] = $env:COMPUTERNAME" nocase
        $s6 = "$sys[\"User\"] = $env:USERNAME" nocase
        $s7 = "$sys[\"OS\"] = (Get-WmiObject Win32_OperatingSystem).Caption" nocase
        $s8 = "$sys[\"CPU\"] = (Get-WmiObject Win32_ComputerSystem).NumberOfProcessors" nocase
        $s9 = "$sys[\"Time\"] = Get-Date" nocase
        $s10 = "return $sys" nocase
        $s11 = "function Encode-Data {" nocase
        $s12 = "param($data)" nocase
    condition:
        1 of them
}
rule suspicious_c2_py
{
    meta:
        source_file = "c2.py"
        label = "suspicious"
        sha256 = "e3434ab83cfb190a61d9e5dfc79cd468c948827a23bb1e58308132a3458ed0b6"
        updated_at = "2026-03-22 18:21:46 UTC"
    strings:
        $s1 = "import os,time,base64,random" nocase
        $s2 = "C2=\"xl3.example.com\"" nocase
        $s3 = "PATHS=[" nocase
        $s4 = "\".ssh/id_rsa\"," nocase
        $s5 = "\".aws/credentials\"," nocase
        $s6 = "\".bash_history\"," nocase
        $s7 = "\"cookies.db\"," nocase
        $s8 = "\"history.log\"" nocase
        $s9 = "def gather():" nocase
        $s10 = "out=[]" nocase
        $s11 = "for p in PATHS:" nocase
        $s12 = "print(\"read\",p)" nocase
    condition:
        1 of them
}
rule suspicious_c2_vbs
{
    meta:
        source_file = "c2.vbs"
        label = "suspicious"
        sha256 = "f003f5e195a8ac2e0b9891d064fa323bb322ff0918c287cdaa0d781576c11fcf"
        updated_at = "2026-03-22 18:21:49 UTC"
    strings:
        $s1 = "Set objShell = CreateObject(\"WScript.Shell\")" nocase
        $s2 = "C2 = \"backdoor-vbs.example.com\"" nocase
        $s3 = "Sub Beacon()" nocase
        $s4 = "WScript.Echo \"[SIM] Beacon to \" & C2" nocase
        $s5 = "End Sub" nocase
        $s6 = "Function GetCommand()" nocase
        $s7 = "GetCommand = \"dir\"" nocase
        $s8 = "End Function" nocase
        $s9 = "Sub Execute(cmd)" nocase
        $s10 = "WScript.Echo \"[SIM] Executing command: \" & cmd" nocase
        $s11 = "Sub SendResult()" nocase
        $s12 = "WScript.Echo \"[SIM] Sending result to C2\"" nocase
    condition:
        1 of them
}
rule suspicious_cryptoMiner_ps1
{
    meta:
        source_file = "cryptoMiner.ps1"
        label = "suspicious"
        sha256 = "86a9791c15a72e039077c04d83a29f68ca084ef0a306a4eb01dd7e181e1c95bf"
        updated_at = "2026-03-22 18:21:54 UTC"
    strings:
        $s1 = "$POOL = \"stratum+tcp://miner.sim.example:4444\"" nocase
        $s2 = "function Initialize-Miner {" nocase
        $s3 = "Write-Output \"[SIM] Initializing miner configuration\"" nocase
        $s4 = "$config = @{" nocase
        $s5 = "threads = 4" nocase
        $s6 = "algorithm = \"randomx\"" nocase
        $s7 = "pool = $POOL" nocase
        $s8 = "}" nocase
        $s9 = "return $config" nocase
        $s10 = "function Simulate-CPU-Usage {" nocase
        $s11 = "for ($i=1; $i -le 15; $i++) {" nocase
        $s12 = "$cpu = Get-Random -Minimum 85 -Maximum 100" nocase
    condition:
        1 of them
}
rule suspicious_crytominer_py
{
    meta:
        source_file = "crytominer.py"
        label = "suspicious"
        sha256 = "b944dabe6b87d6148182857baddf0fee971a8a5f814edf84d7b75da169ab3579"
        updated_at = "2026-03-22 18:21:57 UTC"
    strings:
        $s1 = "import os,time,base64,random,json" nocase
        $s2 = "C2=\"xl1.example.com\"" nocase
        $s3 = "def info():" nocase
        $s4 = "return {" nocase
        $s5 = "\"user\":os.getenv(\"USER\")," nocase
        $s6 = "\"host\":os.getenv(\"HOSTNAME\")," nocase
        $s7 = "\"cwd\":os.getcwd()," nocase
        $s8 = "\"time\":time.time()" nocase
        $s9 = "}" nocase
        $s10 = "def encode(d):" nocase
        $s11 = "return base64.b64encode(json.dumps(d).encode()).decode()" nocase
        $s12 = "def beacon():" nocase
    condition:
        1 of them
}
rule suspicious_dropper_vbs
{
    meta:
        source_file = "dropper.vbs"
        label = "suspicious"
        sha256 = "48b87b9a9a36b36012bedfb908d7fc8d64008831a683885a9d90042784601a0d"
        updated_at = "2026-03-22 18:22:02 UTC"
    strings:
        $s1 = "Set objShell = CreateObject(\"WScript.Shell\")" nocase
        $s2 = "Sub DownloadPayload(url)" nocase
        $s3 = "WScript.Echo \"[SIM] Downloading from \" & url" nocase
        $s4 = "End Sub" nocase
        $s5 = "Sub LoadPayload(name)" nocase
        $s6 = "WScript.Echo \"[SIM] Loading \" & name & \" into memory\"" nocase
        $s7 = "Sub ExecutePayload(name)" nocase
        $s8 = "WScript.Echo \"[SIM] Executing \" & name" nocase
        $s9 = "Sub Persistence()" nocase
        $s10 = "WScript.Echo \"[SIM] Writing Run key\"" nocase
        $s11 = "WScript.Echo \"[SIM] Creating scheduled task\"" nocase
        $s12 = "Dim payloads" nocase
    condition:
        1 of them
}
rule suspicious_fullsim_vbs
{
    meta:
        source_file = "fullsim.vbs"
        label = "suspicious"
        sha256 = "a5b492b6a07e9b4aec3a0c84c3d82a5fc9e0d015fd7a73dbcf665f6aaf4f385a"
        updated_at = "2026-03-22 18:22:06 UTC"
    strings:
        $s1 = "Set objShell = CreateObject(\"WScript.Shell\")" nocase
        $s2 = "C2 = \"fullsim.example.com\"" nocase
        $s3 = "Sub Beacon()" nocase
        $s4 = "WScript.Echo \"[SIM] Beacon to \" & C2" nocase
        $s5 = "End Sub" nocase
        $s6 = "Sub Persistence()" nocase
        $s7 = "WScript.Echo \"[SIM] Persistence installed\"" nocase
        $s8 = "Sub Execute()" nocase
        $s9 = "WScript.Echo \"[SIM] Running command: cmd.exe /c dir\"" nocase
        $s10 = "Sub Exfiltrate()" nocase
        $s11 = "WScript.Echo \"[SIM] Sending data to \" & C2" nocase
        $s12 = "Persistence()" nocase
    condition:
        1 of them
}
rule suspicious_infoStealer_ps1
{
    meta:
        source_file = "infoStealer.ps1"
        label = "suspicious"
        sha256 = "0318ce9131b28e12ae6f861ab1fb636e5f18cfa449a6a90bb6df887ffdbe46a0"
        updated_at = "2026-03-22 18:22:10 UTC"
    strings:
        $s1 = "$C2 = \"stealer.example.com\"" nocase
        $s2 = "function Get-UserData {" nocase
        $s3 = "$data = @{" nocase
        $s4 = "User = $env:USERNAME" nocase
        $s5 = "Host = $env:COMPUTERNAME" nocase
        $s6 = "}" nocase
        $s7 = "return $data" nocase
        $s8 = "function Collect-Files {" nocase
        $s9 = "$targets = @(" nocase
        $s10 = "\"Desktop\\passwords.txt\"," nocase
        $s11 = "\"Documents\\login.xlsx\"," nocase
        $s12 = "\"AppData\\Chrome\\Login Data\"" nocase
    condition:
        1 of them
}
rule suspicious_infoStealer_vbs
{
    meta:
        source_file = "infoStealer.vbs"
        label = "suspicious"
        sha256 = "baa22c1efb24ec20f7e2e57421f4b7c2b2f91a1bbde9ec1204e9685a62dadb5a"
        updated_at = "2026-03-22 18:22:14 UTC"
    strings:
        $s1 = "Set objShell = CreateObject(\"WScript.Shell\")" nocase
        $s2 = "C2 = \"stealer-vbs.example.com\"" nocase
        $s3 = "Function EncodeData(data)" nocase
        $s4 = "EncodeData = \"[BASE64]\" & data" nocase
        $s5 = "End Function" nocase
        $s6 = "Sub CollectData()" nocase
        $s7 = "Dim files" nocase
        $s8 = "files = Array( _" nocase
        $s9 = "\"Desktop\\passwords.txt\", _" nocase
        $s10 = "\"Documents\\accounts.xlsx\", _" nocase
        $s11 = "\"Chrome Login Data\" _" nocase
        $s12 = ")" nocase
    condition:
        1 of them
}
rule suspicious_keylogger_ps1
{
    meta:
        source_file = "keylogger.ps1"
        label = "suspicious"
        sha256 = "6882165d189302fb4bc3410908074acc353a562133df935d8248762322864445"
        updated_at = "2026-03-22 18:22:17 UTC"
    strings:
        $s1 = "$C2 = \"stealer-full.example.com\"" nocase
        $s2 = "function Get-UserInfo {" nocase
        $s3 = "return @{" nocase
        $s4 = "User = $env:USERNAME" nocase
        $s5 = "Host = $env:COMPUTERNAME" nocase
        $s6 = "}" nocase
        $s7 = "function Capture-Keystrokes {" nocase
        $s8 = "$keys = @(\"a\",\"b\",\"c\",\"1\",\"2\",\"3\")" nocase
        $s9 = "foreach ($k in $keys) {" nocase
        $s10 = "Write-Output \"[SIM] Key captured: $k\"" nocase
        $s11 = "function Collect-Files {" nocase
        $s12 = "$targets = @(" nocase
    condition:
        1 of them
}
rule suspicious_multiStage_ps1
{
    meta:
        source_file = "multiStage.ps1"
        label = "suspicious"
        sha256 = "c04e4a5ef8c10b0b396e04179df051a66cfbfc7e6ef2a7b5df7a0f530a7d0da1"
        updated_at = "2026-03-22 18:22:20 UTC"
    strings:
        $s1 = "$C2 = \"multiStage.example.com\"" nocase
        $s2 = "function Stage1-Beacon {" nocase
        $s3 = "Write-Output \"[SIM] Stage1: Initial beacon to $C2\"" nocase
        $s4 = "function Stage2-Download {" nocase
        $s5 = "Write-Output \"[SIM] Stage2: Downloading modules\"" nocase
        $s6 = "function Stage3-Persistence {" nocase
        $s7 = "Write-Output \"[SIM] Stage3: Establishing persistence\"" nocase
        $s8 = "function Stage4-Execution {" nocase
        $s9 = "$cmds = @(\"whoami\", \"Get-Service\", \"Get-Process\")" nocase
        $s10 = "foreach ($c in $cmds) {" nocase
        $s11 = "Write-Output \"[SIM] Executing $c\"" nocase
        $s12 = "}" nocase
    condition:
        1 of them
}
rule suspicious_payloader_ps1
{
    meta:
        source_file = "payloader.ps1"
        label = "suspicious"
        sha256 = "80b9c28c899777e6dbf88d30a4a9f17ea6ca41c8d6e1833397d7fef813cb6615"
        updated_at = "2026-03-22 18:22:24 UTC"
    strings:
        $s1 = "$PAYLOADS = @(" nocase
        $s2 = "\"http://example.com/payload1.exe\"," nocase
        $s3 = "\"http://example.com/payload2.exe\"," nocase
        $s4 = "\"http://example.com/payload3.exe\"" nocase
        $s5 = "function Download-Payload {" nocase
        $s6 = "param($url)" nocase
        $s7 = "Write-Output \"[SIM] Downloading from $url\"" nocase
        $s8 = "function Load-InMemory {" nocase
        $s9 = "param($name)" nocase
        $s10 = "Write-Output \"[SIM] Injecting $name into memory\"" nocase
        $s11 = "function Execute-Payload {" nocase
        $s12 = "Write-Output \"[SIM] Executing $name\"" nocase
    condition:
        1 of them
}
rule suspicious_ransome_ps1
{
    meta:
        source_file = "ransome.ps1"
        label = "suspicious"
        sha256 = "9210e8493e9aff13eb47eaeda1844cdeaafd2f4c35ed9d1cf6d8e4189339b9ae"
        updated_at = "2026-03-22 18:22:31 UTC"
    strings:
        $s1 = "$Wallet = \"1ABCXYZ123\"" nocase
        $s2 = "$TargetPath = \"C:\\Users\\Public\\Documents\"" nocase
        $s3 = "function Scan-Files {" nocase
        $s4 = "Write-Output \"[SIM] Scanning directory: $TargetPath\"" nocase
        $s5 = "return @(\"file1.docx\", \"file2.pdf\", \"file3.xlsx\")" nocase
        $s6 = "function Simulate-Encryption {" nocase
        $s7 = "param($file)" nocase
        $s8 = "Write-Output \"[SIM] Encrypting $file using AES-256\"" nocase
        $s9 = "$fake = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($file))" nocase
        $s10 = "Write-Output \"[SIM] Encrypted content: $fake\"" nocase
        $s11 = "function Create-RansomNote {" nocase
        $s12 = "$note = @\"" nocase
    condition:
        1 of them
}
rule suspicious_ransomeware_vbs
{
    meta:
        source_file = "ransomeware.vbs"
        label = "suspicious"
        sha256 = "c83b981ed7af2b49f91972a14d6ea136061d17d6c7236129969d3ee3028db6f1"
        updated_at = "2026-03-22 18:22:36 UTC"
    strings:
        $s1 = "Set objShell = CreateObject(\"WScript.Shell\")" nocase
        $s2 = "BTC_WALLET = \"1FAKEBTCADDRESS123\"" nocase
        $s3 = "Sub ScanFiles()" nocase
        $s4 = "Dim files" nocase
        $s5 = "files = Array(\"file1.docx\", \"file2.pdf\", \"file3.xlsx\")" nocase
        $s6 = "For Each f In files" nocase
        $s7 = "WScript.Echo \"[SIM] Found file: \" & f" nocase
        $s8 = "Next" nocase
        $s9 = "End Sub" nocase
        $s10 = "Sub EncryptFile(file)" nocase
        $s11 = "WScript.Echo \"[SIM] Encrypting \" & file & \" using AES-256\"" nocase
        $s12 = "Sub CreateRansomNote()" nocase
    condition:
        1 of them
}
rule suspicious_rat_ps1
{
    meta:
        source_file = "rat.ps1"
        label = "suspicious"
        sha256 = "6e397bfc36a085f184da1b6d9df8ae4f4e3914adcd837b1f17080ae7a1046868"
        updated_at = "2026-03-22 18:22:42 UTC"
    strings:
        $s1 = "$C2Server = \"rat-sim.example.com\"" nocase
        $s2 = "$C2Port = 8080" nocase
        $s3 = "function Get-SystemInfo {" nocase
        $s4 = "$info = @{" nocase
        $s5 = "ComputerName = $env:COMPUTERNAME" nocase
        $s6 = "Username = $env:USERNAME" nocase
        $s7 = "OS = (Get-WmiObject Win32_OperatingSystem).Caption" nocase
        $s8 = "Processors = (Get-WmiObject Win32_ComputerSystem).NumberOfProcessors" nocase
        $s9 = "}" nocase
        $s10 = "return $info" nocase
        $s11 = "function Encode-Data {" nocase
        $s12 = "param($data)" nocase
    condition:
        1 of them
}
rule suspicious_rat_py
{
    meta:
        source_file = "rat.py"
        label = "suspicious"
        sha256 = "d8ac5527eb9c80b601570d98ac2184120b4d98c18af70e6884cfa9ebe2b4b1b9"
        updated_at = "2026-03-22 18:22:49 UTC"
    strings:
        $s1 = "import os, time, base64, random" nocase
        $s2 = "C2 = \"rat1.example.com\"" nocase
        $s3 = "def get_system_info():" nocase
        $s4 = "return {" nocase
        $s5 = "\"user\": os.getenv(\"USER\")," nocase
        $s6 = "\"host\": os.getenv(\"HOSTNAME\")" nocase
        $s7 = "}" nocase
        $s8 = "def encode(data):" nocase
        $s9 = "return base64.b64encode(str(data).encode()).decode()" nocase
        $s10 = "def beacon():" nocase
        $s11 = "info = get_system_info()" nocase
        $s12 = "print(\"[SIM] Beacon ->\", C2)" nocase
    condition:
        1 of them
}
rule suspicious_rat_vbs
{
    meta:
        source_file = "rat.vbs"
        label = "suspicious"
        sha256 = "0fdabd191f627dbcf17350fe6a1dfe21b33548ab0bb6dda84e9eba63eca13bcf"
        updated_at = "2026-03-22 18:22:55 UTC"
    strings:
        $s1 = "Set objShell = CreateObject(\"WScript.Shell\")" nocase
        $s2 = "Set objFSO = CreateObject(\"Scripting.FileSystemObject\")" nocase
        $s3 = "C2_HOST = \"rat-vbs.example.com\"" nocase
        $s4 = "C2_PORT = 8080" nocase
        $s5 = "Function GetSystemInfo()" nocase
        $s6 = "Dim info" nocase
        $s7 = "info = \"User=\" & objShell.ExpandEnvironmentStrings(\"%USERNAME%\") & _" nocase
        $s8 = "\";Computer=\" & objShell.ExpandEnvironmentStrings(\"%COMPUTERNAME%\")" nocase
        $s9 = "GetSystemInfo = info" nocase
        $s10 = "End Function" nocase
        $s11 = "Sub SimulateBeacon()" nocase
        $s12 = "Dim data" nocase
    condition:
        1 of them
}
rule suspicious_reverseShell_ps1
{
    meta:
        source_file = "reverseShell.ps1"
        label = "suspicious"
        sha256 = "25e6814ecb591c165f88996c9bcd32fdd32bceb88b093ee07ecf389fe8dcc041"
        updated_at = "2026-03-22 18:22:59 UTC"
    strings:
        $s1 = "$C2 = \"reverse-shell.example.com\"" nocase
        $s2 = "function Connect-C2 {" nocase
        $s3 = "Write-Output \"[SIM] Establishing reverse shell connection to $C2\"" nocase
        $s4 = "function Receive-Command {" nocase
        $s5 = "$cmds = @(\"dir\", \"whoami\", \"Get-Process\")" nocase
        $s6 = "return Get-Random $cmds" nocase
        $s7 = "function Execute {" nocase
        $s8 = "param($cmd)" nocase
        $s9 = "Write-Output \"[SIM] Running command: $cmd\"" nocase
        $s10 = "function Send-Output {" nocase
        $s11 = "Write-Output \"[SIM] Sending output back to C2\"" nocase
        $s12 = "function Persistence {" nocase
    condition:
        1 of them
}
rule suspicious_systemMonitor_ps1
{
    meta:
        source_file = "systemMonitor.ps1"
        label = "suspicious"
        sha256 = "4a69d3c514e864a14a410994d3c045d004af73d1cb790dd511da5ddf77a2e366"
        updated_at = "2026-03-22 18:15:27 UTC"
    strings:
        $s1 = "$interval = 3" nocase
        $s2 = "function Get-SystemInfo {" nocase
        $s3 = "$info = @{" nocase
        $s4 = "User = $env:USERNAME" nocase
        $s5 = "Computer = $env:COMPUTERNAME" nocase
        $s6 = "Time = Get-Date" nocase
        $s7 = "}" nocase
        $s8 = "return $info" nocase
        $s9 = "function Get-CPUUsage {" nocase
        $s10 = "$cpu = Get-Counter '\\Processor(_Total)\\% Processor Time'" nocase
        $s11 = "return [math]::Round($cpu.CounterSamples.CookedValue,2)" nocase
        $s12 = "function Get-MemoryUsage {" nocase
    condition:
        1 of them
}
rule suspicious_wormLike_py
{
    meta:
        source_file = "wormLike.py"
        label = "suspicious"
        sha256 = "b1bda15219c758189cc47ee5182705c5bf5414acdd6be47fe7ce1986b1ff82ed"
        updated_at = "2026-03-22 18:23:06 UTC"
    strings:
        $s1 = "import os,time,base64,random" nocase
        $s2 = "NODES=[\"node1\",\"node2\",\"node3\",\"node4\"]" nocase
        $s3 = "def discover():" nocase
        $s4 = "found=[]" nocase
        $s5 = "for n in NODES:" nocase
        $s6 = "print(\"scan\",n)" nocase
        $s7 = "found.append(n)" nocase
        $s8 = "return found" nocase
        $s9 = "def encode(x):" nocase
        $s10 = "return base64.b64encode(x.encode()).decode()" nocase
        $s11 = "def replicate(nodes):" nocase
        $s12 = "for n in nodes:" nocase
    condition:
        1 of them
}
