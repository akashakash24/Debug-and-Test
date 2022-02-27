import getpass
import telnetlib

HOST = "http://localhost:8000/"
user = raw_input("Enter your remote account: ")
password = getpass.getpass()

tn = telnetlib.Telnet(HOST)

tn.read_until("login: ")
tn.write(user + "\n")
if password:
    tn.read_until("Password: ")
    tn.write(password + "\n")

tn.write("ls\n")
tn.write("exit\n")

print tn.read_all()

------------------------------------------------------

import getpass
import telnetlib

HOST = "localhost"
tn = telnetlib.Telnet(HOST,999)
tn.write("hello world\n")
tn.write("exit\n")

print tn.read_all()

