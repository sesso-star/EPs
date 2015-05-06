function simplex (A, b, c, m, n, x)

	% Calcular Base
	j = 1;
	k = 1;
	for i = 1 : n
		if x(i) != 0
			Ib(j++) = i;
		else
			Nb(k++) = i;
		end
	end

	assert(!(length(Ib) < m), "x é degenerado!");
	assert(length(Ib) == m, "Base não tem m elementos!");

	printf("\nCalcula a base:\n");
	x
	Ib
	Nb

	% Calcula cb e B
	k = 1;
	for i = Ib
		cb(k) = c(i);
		B(:,k++) = A(:,i);
	end
	cb = cb';

	printf("\nCalcula matriz basica B e custos basicos cb\n");
	A
	c
	cb
	B

	% FALTA FAZER meter o do-until
	% calcula o custo reduzido de j
	for j = Nb
		printf("\nCalcula Custo reduzido referente a direção d%d\n", j);
		redc = c(j) - cb' * inverse(B) * A(:,j)

		% Constrói um d
		d = zeros(n, 1);
		d(j) = 1;
		db = -inverse(B) * A(:,j);
		for i = 1 : m
			d(Ib(i)) = db(i);
		d
	end

end 
