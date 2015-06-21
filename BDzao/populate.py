from random import choice
from random import randint
from random import uniform
import sys

class Instituto:
    def __init__(self, ID, nome, campus, sigla, cidade):
        self.InsID = ID
        self.INome = nome
        self.Campus = campus
        self.ISigla = sigla
        self.Cidade = cidade

    def __str__(self):
        return str(self.InsID + 1) + ", " + squote(self.INome) + ", " + squote(self.Campus) + ", " + squote(self.ISigla) + ", " + squote(self.Cidade)

class Departamento:
    def __init__(self, ID, nome, sigla, IID):
        self.DepID = ID
        self.DepNome = nome
        self.DepSigla = sigla
        self.IID = IID

    def __str__(self):
        return str(self.DepID + 1) + ", " + squote(self.DepNome) + ", " + squote(self.DepSigla) + ", " + str(self.IID + 1)

class Curso:
    def __init__(self, ID, nome, depid, desc, durac, pnusp):
        self.CurID = ID
        self.CNome = nome
        self.DepID = depid
        self.CDescricao = desc
        self.TempoDuracao = durac
        self.PNUSP = pnusp

    def __str__(self):
        return str(self.CurID + 1) + ", " + squote(self.CNome) + ", " + squote(self.CDescricao) + ", " + str(self.TempoDuracao) + ", " + str(self.PNUSP) + ", " + str(self.DepID + 1)

class Professor:
    def __init__(self, NUSP, nome, datain, dataout, depid):
        self.PNUSP = NUSP
        self.PNome = nome
        self.PDataIngresso = datain
        self.PDataSaida = dataout
        self.DepID = depid

    def __str__(self):
        if self.PDataSaida == "null":
            return str(self.PNUSP) + ", " + squote(self.PNome) + ", " + squote(self.PDataIngresso) + ", " + self.PDataSaida + ", " + str(self.DepID + 1)
        else:
            return str(self.PNUSP) + ", " + squote(self.PNome) + ", " + squote(self.PDataIngresso) + ", " + squote(self.PDataSaida) + ", " + str(self.DepID + 1)

class MatriculaEm:
    def __init__(self, ID, datafim, datainic, nusp, CID):
        self.MatID = ID 
        self.DataFimMatricula = datafim
        self.DataMatricula = datainic
        self.ANUSP = nusp
        self.CurID = CID 

    def __str__(self):
        return str(self.MatID + 1) + ", " + squote(self.DataFimMatricula) + ", " + squote(self.DataMatricula) + ", " + str(self.ANUSP) + ", " + str(self.CurID + 1)

class EObrigatoria:
    def __init__(self, ID, semestre, DID, CID):
        self.ObrID = ID
        self.SemestreIdeal = semestre
        self.DisID = DID
        self.CurID = CID

    def __str__(self):
        return str(self.ObrID + 1) + ", " + str(self.SemestreIdeal) + ", " + str(self.DisID + 1) + ", " + str(self.CurID + 1)

class Aluno:
    def __init__(self, nusp, nome):
        self.ANUSP = nusp
        self.Nome = nome

    def __str__(self):
        return str(self.ANUSP) + ", " + squote(self.Nome)

class Estuda:
    def __init__(self, ID, ano, semestre, media, situacao, PNUSP, DID, ANUSP):
        self.EstID = ID
        self.Ano = ano
        self.Semestre = semestre
        self.Media = media
        self.Situacao = situacao
        self.PNUSP = PNUSP
        self.DisID = DID
        self.ANUSP = ANUSP

    def __str__(self):
        return str(self.EstID + 1) + ", " + str(self.Ano) + ", " + str(self.Semestre) + ", " + \
               str(self.Media) + ", " + squote(self.Situacao) + ", " + str(self.PNUSP) + ", " + \
               str(self.DisID + 1) + ", " + str(self.ANUSP)

class Disciplina:
    def __init__(self, ID, sigla, nome, maxalunos, desc, depid):
        self.DisID = ID
        self.DisSIgla = sigla
        self.DisNome = nome
        self.MaxAlunos = maxalunos
        self.DisDescricao = desc
        self.DepID = depid

    def __str__(self):
        return str(self.DisID + 1) + ", " + squote(self.DisSIgla) + ", " + squote(self.DisNome) + ", " + str(self.MaxAlunos) + ", " + squote(self.DisDescricao) + ", " + str(self.DepID + 1)

class Aborda:
    def __init__(self, ID, TID, DID):
        self.AboID = ID
        self.TopID = TID 
        self.DisID = DID

    def __str__(self):
        return str(self.AboID + 1) + ", "  + str(self.TopID + 1) + ", " + str(self.DisID + 1)

class Topico:
    def __init__(self, ID, nome, resumo, bib):
        self.TopID = ID
        self.TNome = nome
        self.Resumo = resumo
        self.Bibliografia = bib

    def __str__(self):
        return str(self.TopID + 1) + ", " + squote(self.TNome) + ", " + squote(self.Resumo) + ", " + squote(self.Bibliografia)

############## FUNÇÕES ###################

def initInstitutos(n):
    AZ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    campuses = ["São Paulo", "São Carlos", "Ribeirão Preto"]
    
    siglas = []
    for _ in range(n):
        sigla = choice("IF") + choice(AZ) + choice(AZ)
        siglas.append(sigla)

    insts = []
    nomes = []
    for id in range(n):
        city = choice(campuses)
        nome = siglas[id] + " - " + city
        while nome in nomes:
            city = choice(campuses)
            nome = siglas[id] + " - " + city
        nomes.append(nome)

        inst = Instituto(id, nome, "Campus - " + city, siglas[id], city)
        insts.append(inst)

    return insts

def initDepartamentos(n, insts):
    AZ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    nomes = []
    deps = []

    if n < len(insts):
        print("FERROU n < len(insts)")
        return;

    for id in range(len(insts)):
        inst = insts[id]

        sigla = "D" + choice(AZ) + choice(AZ)
        nome = sigla + " - " + inst.ISigla
        while nome in nomes:
            sigla = "D" + choice(AZ) + choice(AZ)
            nome = sigla + " - " + inst.ISigla
        nomes.append(nome)

        dep = Departamento(id, nome, sigla, inst.InsID)
        deps.append(dep)

    for id in range(n - len(insts)):
        inst = choice(insts)
        
        sigla = "D" + choice(AZ) + choice(AZ)
        nome = sigla + " - " + inst.ISigla
        while nome in nomes:
            sigla = "D" + choice(AZ) + choice(AZ)
            nome = sigla + " - " + inst.ISigla
        nomes.append(nome)

        dep = Departamento(id + len(insts), nome, sigla, inst.InsID)
        deps.append(dep)

    return deps

def initProfessores(n, deps):
    randNames = ["Antonio", "Jose", "Maria", "Marcos", "Pedro", "Julia"]
    if n < len(deps):
        print("FERROU n < len(deps)")
        return;

    nusps = []
    profs = []
    for dep in deps:
        nusp = randint(100000, 400000)
        while nusp in nusps:
            nusp = randint(100000, 400000)
        nusps.append(nusp)

        datain = str(randint(1970, 1990)) + "-" + str(randint(1, 12)).zfill(2) + "-" + str(randint(1,28)).zfill(2)
        dataout = choice([str(randint(1991, 2015)) + "-" + str(randint(1, 12)).zfill(2) + "-" + str(randint(1,28)).zfill(2), "null"])
        prof = Professor(nusp, choice(randNames), datain, dataout, dep.DepID)
        profs.append(prof)

    for _ in range(n - len(deps)):
        nusp = randint(100000, 400000)
        while nusp in nusps:
            nusp = randint(100000, 400000)
        nusps.append(nusp)

        datain = str(randint(1970, 1990)) + "-" + str(randint(1, 12)).zfill(2) + "-" + str(randint(1,28)).zfill(2)
        dataout = choice([str(randint(1991, 2015)) + "-" + str(randint(1, 12)).zfill(2) + "-" + str(randint(1,28)).zfill(2), "null"])
        prof = Professor(nusp, choice(randNames), datain, dataout, choice(deps).DepID)
        profs.append(prof)

    return profs

def initCursos(n, profs, deps):
    if n < len(deps):
        print("FERROU n < len(deps)")
        return;
    if n > len(profs):
        print("FERROU n > len(profs)")
        return;

    depcourses = [1] * len(deps)
    pnusps = []
    cursos = []

    for id in range(len(deps)):
        dep = deps[id]
        nome = "Curso " + str(depcourses[dep.DepID])
        depcourses[dep.DepID] += 1
        desc = nome + " do " + dep.DepNome
        durac = randint(4, 7)
        pnusp = choice(profs).PNUSP
        while pnusp in pnusps:
            pnusp = choice(profs).PNUSP
        pnusps.append(pnusp)

        curso = Curso(id, nome, dep.DepID, desc, durac, pnusp)
        cursos.append(curso)

    for id in range(n - len(deps)):
        dep = choice(deps)
        nome = "Curso " + str(depcourses[dep.DepID])
        depcourses[dep.DepID] += 1
        desc = nome + " do " + dep.DepNome
        durac = randint(4, 7)
        pnusp = choice(profs).PNUSP
        while pnusp in pnusps:
            pnusp = choice(profs).PNUSP
        pnusps.append(pnusp)

        curso = Curso(id + len(deps), nome, dep.DepID, desc, durac, pnusp)
        cursos.append(curso)

    return cursos

def initAlunos(n):
    nusps = []
    randNames = ["Antonio", "Jose", "Maria", "Marcos", "Pedro", "Julia"]
    alunos = []

    for _ in range(n):
        nusp = randint(400000, 800000)
        while nusp in nusps:
            nusp = randint(400000, 800000)
        nusps.append(nusp)

        alunos.append(Aluno(nusp, choice(randNames)))

    return alunos

def initDisciplinas(n, deps):
    if n < len(deps):
        print("FERROU n < len(deps)")

    discN = [100] * len(deps)
    disciplinas = []

    for id in range(len(deps)):
        dep = deps[id]
        sigla = dep.DepSigla + str(discN[dep.DepID])
        discN[dep.DepID] += 1
        nome = "Introdução ao " + dep.DepNome + " " + str(discN[dep.DepID] - 100)
        maxAlunos = randint(3, 10) * 10
        desc = "Introdução de métodos essenciais no " + dep.DepNome

        disc = Disciplina(id, sigla, nome, maxAlunos, desc, dep.DepID)
        disciplinas.append(disc)

    for id in range(n - len(deps)):
        dep = choice(deps)
        sigla = dep.DepSigla + str(discN[dep.DepID])
        discN[dep.DepID] += 1
        nome = "Introdução ao " + dep.DepNome + " " + str(discN[dep.DepID] - 100)
        maxAlunos = randint(3, 10) * 10
        desc = "Introdução de métodos essenciais no " + dep.DepNome

        disc = Disciplina(id + len(deps), sigla, nome, maxAlunos, desc, dep.DepID)        
        disciplinas.append(disc)

    return disciplinas

def initTopicos(n):
    topicos = []

    for id in range(n):
        nome = "Topico " + str(id)
        resumo = "Resumo do " + nome
        bib = choice(["www.google.com", "www.wikipedia.org", "www.bing.com"])

        topicos.append(Topico(id, nome, resumo, bib))

    return topicos

def initAborda(prob, disciplinas, topicos):
    abordas = []

    id = 0
    for disc in disciplinas:
        for topico in topicos:
            if randint(1, 100) < prob:
                abordas.append(Aborda(id, topico.TopID, disc.DisID))
                id += 1

    return abordas

def initEobrigatoria(prob, cursos, disciplinas):
    obrigatorias = []

    id = 0
    for curso in cursos:
        curDiscs = []
        for semestre in range(curso.TempoDuracao * 2):
            for disciplina in disciplinas:
                if randint(1, 100) < prob:
                    disc = choice(disciplinas)
                    while disc.DisID in curDiscs:
                        disc = choice(disciplinas)
                    curDiscs.append(disc)

                    obrigatorias.append(EObrigatoria(id, semestre, disc.DisID, curso.CurID))
                    id += 1
    return obrigatorias

def initMatriculaEm_estuda(prob1, prob2, cursos, alunos, professores, disciplinas):
    matriculas = []
    id = 0
    id_est = 0
    estudas = []
    oferecidas = {}

    for ano in range(1970, 2022):
        for semestre in range(1, 3):
            for disc in disciplinas:
                if randint(1, 100) < prob2:
                    if (ano, semestre) not in oferecidas:
                        oferecidas[(ano, semestre)] = []
                    oferecidas[(ano, semestre)].append({'id' : disc.DisID, 'prof' : choice(professores).PNUSP})


    for aluno in alunos:
        curso = choice(cursos)
        aninc = randint(2000, 2015)
        datainic = str(aninc) + "-02-01"
        datafim = str(aninc + curso.TempoDuracao) + "-02-01"
        id += 1

        matriculas.append(MatriculaEm(id, datafim, datainic, aluno.ANUSP, curso.CurID))

        discCursadas = []
        for semestre in range(curso.TempoDuracao * 2):
            for ndisc in range(randint(2, 8)):
                ano = aninc + semestre // 2
                disc_prof = choice(oferecidas[(ano, semestre % 2 + 1)])
                while disc_prof["id"] in discCursadas:
                    disc_prof = choice(oferecidas[(ano, semestre % 2 + 1)])
                discCursadas.append(disc_prof["id"])
                media = round(uniform(0, 10), 1)
                situacao = choice("RCTA")

                estudas.append(Estuda(id_est, ano, semestre % 2 + 1, media, situacao, \
                    disc_prof["prof"], disc_prof["id"], aluno.ANUSP))
                id_est += 1



        if randint(1, 100) < prob1:
            curso = choice(cursos)
            aninc = randint(1970, 1995)
            mes = choice([2, 8])
            datainic = str(aninc) + "-02-01"
            datafim = str(aninc + curso.TempoDuracao) + "-02-01"
            id += 1

            matriculas.append(MatriculaEm(id, datafim, datainic, aluno.ANUSP, curso.CurID))

            discCursadas = []
            for semestre in range(curso.TempoDuracao * 2):
                for ndisc in range(randint(2, 8)):
                    ano = aninc + semestre // 2
                    disc_prof = choice(oferecidas[(ano, semestre % 2 + 1)])
                    while disc_prof["id"] in discCursadas:
                        disc_prof = choice(oferecidas[(ano, semestre % 2 + 1)])
                    discCursadas.append(disc_prof["id"])
                    media = round(uniform(0, 10), 1)
                    situacao = choice("RCTA")

                    estudas.append(Estuda(id_est, ano, semestre % 2 + 1, media, situacao, \
                        disc_prof["prof"], disc_prof["id"], aluno.ANUSP))
                    id_est += 1


    return matriculas, estudas

def squote(s):
    return "\"" + s + "\""

####################### MAIN #####################

ninsts = 30
ndeps = 150
nprofs = 5000
ncursos = 500
nalunos = 15000
ndiscs = 3000
ntopicos = 10000
pabordas = 5
pobrig = 4
pmatricula = 5
pestuda = 60


print("Institutos", file = sys.stderr)
insts = initInstitutos(ninsts)
print("INSERT INTO Instituto VALUES")
print(",\n".join(map(lambda x: "\t" + "(" + str(x) + ")", insts)) + ";")

print("\n\n")

print("Departamentos", file = sys.stderr)   
deps = initDepartamentos(ndeps, insts)
print("INSERT INTO Departamento VALUES")
print(",\n".join(map(lambda x: "\t" + "(" + str(x) + ")", deps)) + ";")

print("\n\n")

print("Professores", file = sys.stderr) 
profs = initProfessores(nprofs, deps)
print("INSERT INTO Professor VALUES")
print(",\n".join(map(lambda x: "\t" + "(" + str(x) + ")", profs)) + ";")

print("\n\n")

print("Cursos", file = sys.stderr)  
cursos = initCursos(ncursos, profs, deps)
print("INSERT INTO Curso VALUES")
print(",\n".join(map(lambda x: "\t" + "(" + str(x) + ")", cursos)) + ";")

print("\n\n")

print("Alunos", file = sys.stderr)  
alunos = initAlunos(nalunos)
print("INSERT INTO Aluno VALUES")
print(",\n".join(map(lambda x: "\t" + "(" + str(x) + ")", alunos)) + ";")

print("\n\n")

print("Disciplinas", file = sys.stderr) 
disciplinas = initDisciplinas(ndiscs, deps)
print("INSERT INTO Disciplina VALUES")
print(",\n".join(map(lambda x: "\t" + "(" + str(x) + ")", disciplinas)) + ";")

print("\n\n")

print("Topicos", file = sys.stderr) 
topicos = initTopicos(ntopicos)
print("INSERT INTO Topico VALUES")
print(",\n".join(map(lambda x: "\t" + "(" + str(x) + ")", topicos)) + ";")

print("\n\n")

print("Aborda", file = sys.stderr)  
abordas = initAborda(pabordas, disciplinas, topicos)
print("INSERT INTO Aborda VALUES")
print(",\n".join(map(lambda x: "\t" + "(" + str(x) + ")", abordas)) + ";")

print("\n\n")

print("Obrigatorias", file = sys.stderr)    
obrigatorias = initEobrigatoria(pobrig, cursos, disciplinas)
print("INSERT INTO EObrigatoria VALUES")
print(",\n".join(map(lambda x: "\t" + "(" + str(x) + ")", obrigatorias)) + ";")

print("\n\n")

print("Matricula / Estuda", file = sys.stderr)  
matriculas, estudas = initMatriculaEm_estuda(pmatricula, pestuda, cursos, alunos, profs, disciplinas)
print("INSERT INTO MatriculaEm VALUES")
print(",\n".join(map(lambda x: "\t" + "(" + str(x) + ")", matriculas)) + ";")

print("\n\n")

print("INSERT INTO Estuda VALUES")
print(",\n".join(map(lambda x: "\t" + "(" + str(x) + ")", estudas)) + ";")

print("\n\n")



