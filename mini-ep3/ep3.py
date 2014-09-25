import sys
import re

nsDict = dict()
actualDomain = ""
state = "onNS"
state = "offNS"

for line in sys.stdin.readlines():
	spline = line.split()
	if ";" in spline:
		idx = index(";")
		for i in range(idx, len(spline)):
			spline.pop(i)
	line = " ".join(spline)

	if state == "onNS":
		#print(line)
		matchObj = re.match(r"([^ ]+)\s+A\s+([0-9]+\.)+([0-9]+)", line, re.I)
		if matchObj:
			name = matchObj.group(1)
			ip = matchObj.group(3)
			#print(name + " " + ip)
			dictEntry = [name, ip]
			nsDict[actualDomain].append(dictEntry)
		else:
			state = "offNS"

	if state == "offNS" and "NS" in spline:
		print(line)
		matchObj = re.match(r"NS\s*[^.]+\.(.+\.)+", line, re.I)
		if matchObj:
			print(matchObj.group(1))
			actualDomain = matchObj.group(1)
			nsDict[actualDomain] = []
			state = "onNS"
	else:
		pass
for domain in nsDict:
	#print("\tNS ns.")
	#print(domain + " " + " ".join(nsDict[domain][0]))

