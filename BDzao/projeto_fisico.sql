-- Geração de Modelo físico
-- Sql ANSI 2003 - brModelo.

drop database projeto_bd;
create database projeto_bd;
USE projeto_bd;

CREATE TABLE Professor (
PNUSP INT PRIMARY KEY,
PNome VARCHAR(50),
PDataIngresso DATE,
PDataSaida DATE,
DepID INT
);

CREATE TABLE Topico (
TopID INT PRIMARY KEY,
TNome VARCHAR(50),
Resumo VARCHAR(500),
Bibliografia VARCHAR(500)
);

CREATE TABLE Aborda (
AboID INT PRIMARY KEY,
TopID INT,
DisID INT,
FOREIGN KEY(TopID) REFERENCES Topico (TopID)
);

CREATE TABLE Estuda (
EstID INT PRIMARY KEY,
Ano YEAR(4),
Semestre INT,
Media FLOAT,
Situacao CHARACTER(1),
PNUSP INT,
DisID INT,
ANUSP INT,
FOREIGN KEY(PNUSP) REFERENCES Professor (PNUSP)
);

CREATE TABLE Aluno (
ANUSP INT PRIMARY KEY,
Nome VARCHAR(50)
);

CREATE TABLE MatriculaEm (
MatID INT PRIMARY KEY,
DataFimMatricula DATE,
DataMatricula DATE,
ANUSP INT,
CurID INT,
FOREIGN KEY(ANUSP) REFERENCES Aluno (ANUSP)
);

CREATE TABLE Disciplina (
DisID INT PRIMARY KEY,
DisSigla VARCHAR(50),
DisNome VARCHAR(50),
MaxAlunos INT,
DisDescricao VARCHAR(500),
DepID INT
);

CREATE TABLE EObrigatoria (
ObrID INT PRIMARY KEY,
SemestreIdeal INT,
DisID INT,
CurID INT,
FOREIGN KEY(DisID) REFERENCES Disciplina (DisID)
);

CREATE TABLE Instituto (
InsID INT PRIMARY KEY,
INome VARCHAR(50),
ISigla VARCHAR(50),
Campus VARCHAR(50),
Cidade VARCHAR(50)
);

CREATE TABLE Curso (
CurID INT PRIMARY KEY,
CNome VARCHAR(50),
CDescricao VARCHAR(500),
TempoDuracao INT,
PNUSP INT,
DepID INT,
FOREIGN KEY(PNUSP) REFERENCES Professor (PNUSP)
);

CREATE TABLE Departamento (
DepID INT PRIMARY KEY,
DepNome VARCHAR(50),
DepSigla VARCHAR(50),
IID INT,
FOREIGN KEY(IID) REFERENCES Instituto (InsID)
);

ALTER TABLE Professor ADD FOREIGN KEY(DepID) REFERENCES Departamento (DepID);
ALTER TABLE Aborda ADD FOREIGN KEY(DisID) REFERENCES Disciplina (DisID);
ALTER TABLE Estuda ADD FOREIGN KEY(DisID) REFERENCES Disciplina (DisID);
ALTER TABLE Estuda ADD FOREIGN KEY(ANUSP) REFERENCES Aluno (ANUSP);
ALTER TABLE MatriculaEm ADD FOREIGN KEY(CurID) REFERENCES Curso (CurID);
ALTER TABLE Disciplina ADD FOREIGN KEY(DepID) REFERENCES Departamento (DepID);
ALTER TABLE EObrigatoria ADD FOREIGN KEY(CurID) REFERENCES Curso (CurID);
ALTER TABLE Curso ADD FOREIGN KEY(DepID) REFERENCES Departamento (DepID);
