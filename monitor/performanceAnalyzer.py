import os,time,platform

def get_user():
    return os.getenv("USER")

def get_host():
    return platform.node()

def get_platform():
    return platform.system()

def get_version():
    return platform.version()

def get_cwd():
    return os.getcwd()

def get_time():
    return time.ctime()

def format_line(k,v):
    return f"{k}: {v}"

def display_block():
    data={
        "User":get_user(),
        "Host":get_host(),
        "Platform":get_platform(),
        "Version":get_version(),
        "Path":get_cwd(),
        "Time":get_time()
    }

    for k in data:
        print(format_line(k,data[k]))

    print("-"*40)

def repeat_display(n):
    for _ in range(n):
        display_block()

def run_cycle():
    repeat_display(2)

def main_loop():
    while True:
        run_cycle()
        time.sleep(5)

main_loop()