import sys
import re
from operator import itemgetter

def dumpIps(lst):
	lst.sort(key=lambda lst_entry: lst_entry[0]) 
	for i in range(0, len(lst)):
		print(str(lst[i][0]) + "\tPTR\t" + lst[i][1])
	

ipDomain = []
onNS = False

for line in sys.stdin.readlines():
	line = re.sub('[;;].*', '', line)
	line = re.sub('\s+', ' ', line)

	if onNS:
		matchObj = re.match(r"([^ ]+)\s+A\s+([0-9]+\.)+([0-9]+)", line, re.I)
		if matchObj:
			name = matchObj.group(1)
			ip = int(matchObj.group(3))
			ipDomain.append([ip, name + "." + actualDomain])
		else:
			onNS = False
			dumpIps(ipDomain)
			ipDomain = []

	if not onNS:
		matchObj = re.match(r".*NS\s*(.+\.)+", line)
		if matchObj:
			actualDomain = matchObj.group(1)
			print("\tNS\t" + actualDomain)
			spl = actualDomain.split(".")
			spl.pop(0)
			actualDomain = ".".join(spl)
			onNS = True

if ipDomain != []:
	dumpIps(ipDomain)
