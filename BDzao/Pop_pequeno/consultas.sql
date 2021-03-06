# Selecione a média de notas de alunos para cada instituto
Select INome, AVG(Media)
From Instituto AS I, Departamento AS D, Curso AS C, MatriculaEm AS M, Aluno AS A, Estuda AS E
Where I.InsID = D.IID AND D.DepID = C.DepID AND C.CurID = M.CurID AND M.ANUSP = A.ANUSP AND A.ANUSP = E.ANUSP
Group By I.InsID;

# Selecione todos os tópicos e resumos abordados por um curso
Select CNome, TNome, Resumo
From Curso AS C, Departamento AS DE, Disciplina AS DI, Aborda AS A, Topico AS  T
Where C.DepID = DE.DepID AND DE.DepID = DI.DepID AND DI.DisID = A.DisID AND A.TopID = T.TopID;

# Mostre a grade ideal do curso <CURSO> do instituto <INSTITUTO>
Select DisNome, SemestreIdeal
From Instituto AS I, Departamento AS DE, Curso AS C, EObrigatoria AS O, Disciplina AS DI
Where I.INome = "FIS - SÃO CARLOS" AND DE.IID = I.InsID AND C.CNome = "Curso 1" AND C.DepID = DE.DepID AND O.CurID = C.CurID
