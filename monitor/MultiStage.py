import time,base64,random

C2="multi.example.com"

def stage1():
    print("s1")

def stage2():
    print("s2")

def stage3():
    data=str(random.randint(1,100))
    return base64.b64encode(data.encode()).decode()

def stage4(d):
    print("send",C2,d[:20])

while True:
    stage1()
    stage2()
    d=stage3()
    stage4(d)
    time.sleep(3)