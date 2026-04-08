import random,time

def generate():
    return [random.randint(1,100) for _ in range(25)]

def analyze(d):
    total=sum(d)
    avg=total/len(d)
    print("Total:",total)
    print("Avg:",avg)

def sort_data(d):
    return sorted(d)

def display(d):
    for x in d[:10]:
        print("Val:",x)

def cycle():
    d=generate()
    analyze(d)
    s=sort_data(d)
    display(s)

def loop():
    while True:
        cycle()
        print("Iteration done")
        time.sleep(5)

loop()