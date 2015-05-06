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

	x
	Ib
	Nb

	% Calcula cb e B
	k = 1;
	for i = Ib
		cb(k) = c(i);
		B(:,k++) = A(:,i);
	end

	A
	c
	cb
	B

	% FALTA FAZER
	% calcula o custo reduzido de j
	for j = Nb
		redc = c(j) - cb * inverse(B) * A(:,j)
	end

end 
