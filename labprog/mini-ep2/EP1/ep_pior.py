import sys

class Name():
    def __init__(self, name):
        names = name.split()
        
        length = len(names)
        if length == 0:
            self.first_name = ""
            self.last_name = ""
        elif length == 1:
            self.first_name = names[0]
            self.last_name = ""
        else:
            self.first_name = names[0]
            self.last_name = names[-1]

    def __eq__(self, other):
        return self.first_name == other.first_name and self.last_name == other.last_name

    def __str__(self):
        return self.first_name + ' ' + self.last_name

    def __hash__(self):
        return hash(str(self))

    def __cmp__(self, other):
        print('passei')
        return cmp(str(self), str(other))

names = dict()
if sys.argv[1] == '-a':
    for line in sys.stdin.readlines():
        if line[0] != '#':
            args = line.split(':')
            name = Name(args[4])
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



