import sys
option = ""
try:
	option = sys.argv[1]
except IndexError:
	print("Passe a opcao do programa como argumento!\nTomando opcao -a como padrão")
	option = "-a"

dicti = dict()
if (option == "-a"):
	for line in sys.stdin:
		words = line.split(":")
		fullName = words[4]
		username = words[0]
		if (fullName == ""):
			continue
		splitedName = fullName.split()
		name = splitedName.pop(0)
		if (len(splitedName) > 0):
			name = name + " " + splitedName[len(splitedName) - 1]
		if (name in dicti):
			namesakes = dicti.get(name)
		else:
			namesakes = []
		namesakes.append(username)
		dictiEntry = {name : namesakes}
		dicti.update(dictiEntry)
else:
	for line in sys.stdin:
		words = line.split(":")
		usrId = words[2]
		username = words[0]
		if (usrId in dicti):
			users = dicti.get(usrId)
		else:
			users = []
		users.append(username)
		dictiEntry = {usrId : users}
		dicti.update(dictiEntry)
for entry in dicti:
	print(entry  + ":" + ','.join(dicti.get(entry)))
