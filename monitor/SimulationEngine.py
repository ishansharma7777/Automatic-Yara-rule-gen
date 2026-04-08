import random,time

def generate():
    data=[]
    for _ in range(20):
        data.append(random.randint(1,100))
    return data

def analyze(d):
    print("Max:",max(d))
    print("Min:",min(d))
    print("Avg:",sum(d)/len(d))

def loop():
    while True:
        d=generate()
        analyze(d)
        print("Simulation done")
        time.sleep(5)

loop()