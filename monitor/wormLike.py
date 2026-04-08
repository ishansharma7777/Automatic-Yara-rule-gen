import os,time,base64,random

NODES=["node1","node2","node3","node4"]

def discover():
    found=[]
    for n in NODES:
        print("scan",n)
        found.append(n)
    return found

def encode(x):
    return base64.b64encode(x.encode()).decode()

def replicate(nodes):
    for n in nodes:
        print("copy",n,encode(n)[:20])

def beacon():
    print("b","worm.net")

def loop():
    nodes=discover()
    replicate(nodes)

while True:
    beacon()
    loop()
    time.sleep(4)