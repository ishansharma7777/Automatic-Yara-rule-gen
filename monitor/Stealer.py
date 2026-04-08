import os,time,base64,random

C2="xl2.example.com"

FILES=[f"file_{i}.txt" for i in range(25)]

def scan():
    found=[]
    for f in FILES:
        print("found",f)
        found.append(f)
    return found

def encode(x):
    return base64.b64encode(x.encode()).decode()

def transform(data):
    out=[]
    for d in data:
        e=encode(d)
        print("enc",d,e[:30])
        out.append(e)
    return out

def batch_send(data):
    for d in data:
        print("send",C2,d[:40])

def persist():
    print("persist_copy")
    print("persist_hidden")
    print("persist_cron")

def loop():
    data=scan()

    encd=transform(data)

    batch_send(encd)

persist()

while True:
    loop()
    print("cycle_done")
    time.sleep(4)