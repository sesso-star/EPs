import sys

option = ""
try:
    option = sys.argv[1]
except IndexError:
    print("Passe a opcao do programa como argumento!\nTomando opcao -a como padrão")
    option = "-a"

names = dict()
if option == '-a':
    for line in sys.stdin.readlines():
        if line[0] != '#':
            args = line.split(':')
            name = args[4].split()
            if len(name) == 0:
                name = ''
            elif len(name) == 1:
                name = name[0]
            elif len(name) > 1:
                name = name[0] + ' ' + name[-1]

            user = args[0]

            user_list = names.get(name, [])
            user_list.append(user)
            names[name] = user_list

elif option == '-u':
    for line in sys.stdin.readlines():
        if line[0] != '#':
            args = line.split(':')
            uid = args[2]
            user = args[0]

            user_list = names.get(uid, [])
            user_list.append(user)
            names[uid] = user_list

else:
    print('Argumento invalido')

for key, value in names.items():
    if len(value) > 1:
        print(key, ':', ','.join(value), sep='')



