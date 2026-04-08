import os, time, base64, random

C2 = "rat1.example.com"

def get_system_info():
    return {
        "user": os.getenv("USER"),
        "host": os.getenv("HOSTNAME")
    }

def encode(data):
    return base64.b64encode(str(data).encode()).decode()

def beacon():
    info = get_system_info()
    print("[SIM] Beacon ->", C2)
    print("[SIM] Data:", encode(info))

def fetch_command():
    return random.choice(["whoami", "ls", "pwd"])

def execute(cmd):
    print("[SIM] Executing:", cmd)
    return f"output_{cmd}"

def exfiltrate(data):
    print("[SIM] Exfil ->", C2)
    print("[SIM] Payload:", encode(data))

while True:
    beacon()
    cmd = fetch_command()
    res = execute(cmd)
    exfiltrate(res)
    time.sleep(3)