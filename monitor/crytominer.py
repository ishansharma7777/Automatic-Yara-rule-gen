import os,time,base64,random,json

C2="xl1.example.com"

def info():
    return {
        "user":os.getenv("USER"),
        "host":os.getenv("HOSTNAME"),
        "cwd":os.getcwd(),
        "time":time.time()
    }

def encode(d):
    return base64.b64encode(json.dumps(d).encode()).decode()

def beacon():
    d=info()
    print("beacon",C2)
    print("data",encode(d)[:60])

def commands():
    return ["whoami","ls","pwd","id","date"]

def select_cmd():
    return random.choice(commands())

def execute(c):
    print("exec",c)
    return {"cmd":c,"res":"ok_"+c}

def collect():
    data=[]
    for i in range(5):
        val=f"item_{i}"
        print("collect",val)
        data.append(val)
    return data

def exfil(d):
    print("exfil",C2)
    print("payload",encode(d)[:60])

def persist():
    print("persist_startup")
    print("persist_registry")
    print("persist_task")

def loop_once():
    beacon()

    c=select_cmd()

    r=execute(c)

    data=collect()

    exfil({"cmd":r,"data":data})

persist()

while True:
    loop_once()
    time.sleep(3)