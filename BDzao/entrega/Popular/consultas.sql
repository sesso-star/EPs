# Selecione a média de notas de alunos para cada instituto. Como o programa gerou as notas dos alunos 
# aleatóriamente entre 0 e 10, a média de fato deve se encontrar em torno de 5.
Select INome, AVG(Media)
From Instituto AS I, Departamento AS D, Curso AS C, MatriculaEm AS M, Aluno AS A, Estuda AS E
Where I.InsID = D.IID AND D.DepID = C.DepID AND C.CurID = M.CurID AND M.ANUSP = A.ANUSP AND A.ANUSP = E.ANUSP
Group By I.InsID;

# Selecione todos os tópicos e resumos abordados por um curso
Select DepNome, CNome, TNome, Resumo
From Curso AS C, Departamento AS DE, Disciplina AS DI, Aborda AS A, Topico AS  T
Where C.DepID = DE.DepID AND DE.DepID = DI.DepID AND DI.DisID = A.DisID AND A.TopID = T.TopID;

# Seleciona todas as disciplinas que ocorreram em 2015.
Select DisNome, Ano, Semestre, PNome 
From Disciplina AS d, Estuda AS e, Professor AS p 
Where e.pnusp = p.pnusp AND e.DisID = d.DisID AND ano = 2015 
Group By DisNome
Order By Ano, Semestre;

# Seleciona a grade (Disciplinas obrigatórias) do curso com ID = 1.
Select CNome, DisNome, MaxAlunos, SemestreIdeal
From Curso AS c, EObrigatoria as eo, Disciplina as d
Where c.CurID = eo.CurID AND eo.DisID = d.DisID AND c.CurID = 1
Order By SemestreIdeal;