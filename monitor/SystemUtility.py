import os,time,platform

def get_user():
    return os.getenv("USER")

def get_host():
    return platform.node()

def get_cwd():
    return os.getcwd()

def get_time():
    return time.ctime()

def display():
    print("User:",get_user())
    print("Host:",get_host())
    print("Path:",get_cwd())
    print("Time:",get_time())
    print("----------------------")

def loop():
    while True:
        display()
        time.sleep(5)

loop()