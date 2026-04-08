import time

texts=["alpha","beta","gamma","delta","epsilon"]

def upper(t):
    return t.upper()

def lower(t):
    return t.lower()

def reverse(t):
    return t[::-1]

def process_one(t):
    print("Original:",t)
    print("Upper:",upper(t))
    print("Lower:",lower(t))
    print("Reverse:",reverse(t))

def process_all():
    for t in texts:
        process_one(t)

def repeat(n):
    for _ in range(n):
        process_all()

def loop():
    while True:
        repeat(2)
        print("Done batch")
        time.sleep(6)

loop()