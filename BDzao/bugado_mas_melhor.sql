-- Geração de Modelo físico
-- Sql ANSI 2003 - brModelo.
drop database projeto_bd;
create database projeto_bd;
USE projeto_bd;


CREATE TABLE Instituto (
INome VARCHAR(50),
ISigla VARCHAR(50),
Campus VARCHAR(50),
Cidade VARCHAR(50),
PRIMARY KEY(INome,Campus)
);

CREATE TABLE Departamento (
DepNome VARCHAR(50) PRIMARY KEY,
DepSigla VARCHAR(50),
INome VARCHAR(50),
Campus VARCHAR(50),
FOREIGN KEY(INome, Campus) REFERENCES Instituto (INome,Campus)
);

CREATE TABLE Professor (
PNome VARCHAR(50),
PDataIngresso VARCHAR(50),
PNUSP INT PRIMARY KEY,
PDataSaida DATE,
DepNome VARCHAR(50),
FOREIGN KEY(DepNome) REFERENCES Departamento (DepNome)
);

CREATE TABLE Topico (
Resumo VARCHAR(500),
Bibliografia VARCHAR(500),
TNome VARCHAR(50) PRIMARY KEY
);

CREATE TABLE Aborda (
TNome VARCHAR(50),
DisSigla VARCHAR(50),
FOREIGN KEY(TNome) REFERENCES Topico (TNome)
);

CREATE TABLE Estuda (
Ano YEAR(4),
Semestre INT,
Media FLOAT,
Situacao CHARACTER(1),
PNUSP INT,
DisSigla VARCHAR(50),
ANUSP VARCHAR(50),
PRIMARY KEY(PNUSP, DisSigla, ANUSP)
);

CREATE TABLE Curso (
CNome VARCHAR(50),
CDescricao VARCHAR(500),
TempoDuracao INT,
PNUSP INT,
DepNome VARCHAR(50),
PRIMARY KEY(CNome, DepNome),
FOREIGN KEY(PNUSP) REFERENCES Professor (PNUSP),
FOREIGN KEY(DepNome) REFERENCES Departamento (DepNome)
);

CREATE TABLE Aluno (
ANUSP VARCHAR(50) PRIMARY KEY,
Nome VARCHAR(50)
);

CREATE TABLE MatriculaEm (
DataFimMatricula DATE,
DataMatricula DATE,
CNome VARCHAR(50),
ANUSP VARCHAR(50),
DepNome VARCHAR(50),
FOREIGN KEY(CNome, DepNome) REFERENCES Curso (CNome,DepNome),
FOREIGN KEY(ANUSP) REFERENCES Aluno (ANUSP)
);

CREATE TABLE EObrigatoria (
SemestreIdeal INT,
DisSigla VARCHAR(50),
CNome VARCHAR(50),
DepNome VARCHAR(50),
FOREIGN KEY(CNome, DepNome) REFERENCES Curso (CNome,DepNome)
);


CREATE TABLE Disciplina (
DisSigla VARCHAR(50) PRIMARY KEY,
DisNome VARCHAR(50),
MaxAlunos INT,
DisDescricao VARCHAR(500),
DepNome VARCHAR(50),
FOREIGN KEY(DepNome) REFERENCES Departamento (DepNome)
);

ALTER TABLE Aborda ADD FOREIGN KEY(DisSigla) REFERENCES Disciplina (DisSigla);
ALTER TABLE EObrigatoria ADD FOREIGN KEY(DisSigla) REFERENCES Disciplina (DisSigla);