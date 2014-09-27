import sys
import re 
from subprocess import check_output

f = open(sys.argv[1])
out = check_output(["python3", "ep3.py"], stdin = f)
out = out.decode('utf-8').split('\n')

dns = dict()

for line in out:
	cols = line.split('\t')
	if len(cols) == 3:
		if cols[1] == "PTR":
			key = re.match('(.*?)\..*\.', cols[2]).group(1)
			dns[current_ns][key] = cols[0]
		elif cols[1] == "NS":
			dns[cols[2]] = dict()
			current_ns = cols[2]

current_ns = None
f.seek(0)
for line in f.readlines():
	matchObj = re.match(r".*NS\s*(.+\.)+", line)
	if matchObj:
		if current_ns and not any(dns[current_ns]):
			sys.exit("O programa não passou no teste :(")
		current_ns = matchObj.group(1)

	matchObj = re.match(r"([^ ]+)\s+A\s+([0-9]+\.)+([0-9]+)", line, re.I)
	if matchObj:
		if not dns[current_ns][matchObj.group(1)]:
			sys.exit("O programa não passou no teste :(")
		dns[current_ns][matchObj.group(1)] = None

print("O programa passou no teste! :)")
