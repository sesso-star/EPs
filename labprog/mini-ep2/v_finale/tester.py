#como utilizar: tester.py (-a ou -u) 'nome do arquivo com a saida produzida pelo programa' < 'entrada utilizada para tal saida'
import sys

option = ""
try:
	option = sys.argv[1]
except IndexError:
	print("Passe a opcao do teste como argumento!\nTomando opcao -a como padrão")
	option = "-a"

answerArchive = ""
try:
	answerArchive = sys.argv[2]
except IndexError:
	print("Faltou o nome do arquivo com a saída produzida pelo programa")
	print("Uso: tester.py (-a ou -u) 'nome do arquivo com a saida produzida pelo programa' < 'entrada utilizada para tal saida'")
	sys.exit()

saida = open(answerArchive, 'r')
answerDict = dict()

if (option == "-a"):
	for line in saida:
		linev = line.split(":")
		name = linev.pop(0)
		users = linev[0].split(",")
		users[-1] = users[-1].replace("\n", "")
		answerDict[name] = users
	for line in sys.stdin.readlines():
		args = line.split(':')
		name = args[4].split()
		if len(name) == 0:
			name = ''
		elif len(name) == 1:
			name = name[0]
		elif len(name) > 1:
			name = name[0] + ' ' + name[-1]
		user = args[0]

		#se a lista de usarios de nome "nome" contem todos usuarios de nome "nome"
		if ((name in answerDict) and (user not in answerDict[name])):
			print("O teste falhou! =(")
			sys.exit()
		#se todo usuario na lista de usuarios de nome "nome" possui o nome "nome"
		for nameKey, userList in answerDict.items():
			if (user in userList):
				if (nameKey != name):
					print("O teste falhou! =(")
					sys.exit()
				else:
					break
	print("O teste passou com sucesso =D")

elif (option == "-u"):
	for line in saida:
		linev = line.split(":")
		userId = linev.pop(0)
		users = linev[0].split(",")
		users[-1] = users[-1].replace("\n", "")
		answerDict[userId] = users
	
	for line in sys.stdin.readlines():
		if line[0] != '#':
			args = line.split(':')
			userId = args[2]
			user = args[0]
		#se a lista de usuarios de id "userId" contem todos usuarios de id "userId"
		if ((userId in answerDict) and (user not in answerDict[userId])):
			print("O teste falhou! =(")
			sys.exit()
		#se todo usario na lista de usuarios de id "userId" possui o id "userId"
		for idKey, userList in answerDict.items():
			if (user in userList):
				if(idKey != userId):
					print("O teste falhou! =(")
					sys.exit()
				else:
					break
	print("O teste passou com sucesso =D")

else:
	print("Argumento invalido")
	print("Uso: tester.py (-a ou -u) 'nome do arquivo com a saida produzida pelo programa' < 'entrada utilizada para tal saida'")
