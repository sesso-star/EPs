import re
from urllib.request import urlopen

url = "http://www.usp.br/coseas/cardapio.html"
sock = urlopen(url)
content = sock.read().decode('latin1')

#f = open('qui.html', 'r', encoding='latin1')
#content = f.read()

table = re.findall('<table.*?>.*</table>', content, re.S | re.I)
rows = re.findall('<tr>.*?</tr>', table[0], flags = re.S | re.I)

for i in range(0, len(rows)):
    rows[i] = re.findall('<td.*?>.*?</td>', rows[i], flags = re.S | re.I)
    for j in range(0, len(rows[i])):
        rows[i][j] = re.sub('&nbsp;', '', rows[i][j], flags = re.I)
        rows[i][j] = re.sub('<.*?>', '', rows[i][j], flags = re.S)
        rows[i][j] = re.sub(' {2,}','', rows[i][j])
        rows[i][j] = re.sub('\n+','\n', rows[i][j])
print('**' + rows[3][1] + '**')

