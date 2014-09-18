import sys

names = dict()
if sys.argv[1] == '-a':
    for line in sys.stdin.readlines():
        if line[0] != '#':
            args = line.split(':')
            name = args[4].split()
            if len(name) == 0:
                name.append('')
            elif len(name) == 1:
                name.append('')
            name = name[0] + ' ' + name[-1]
            user = args[0]

            user_list = names.get(name, [])
            user_list.append(user)
            names[name] = user_list

elif sys.argv[1] == '-u':
    for line in sys.stdin.readlines():
        if line[0] != '#':
            args = line.split(':')
            uid = args[2]
            user = args[0]

            user_list = names.get(uid, [])
            user_list.append(user)
            names[uid] = user_list

else:
    print('Invalid argument')

for key, value in names.items():
    if len(value) > 1:
        print(key, ':', ','.join(value), sep='')



