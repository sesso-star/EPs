function simplex (A, b, c, m, n, x)

	% Calcular indices basicos e não básicos a partir de x
	j = 1;
	k = 1;
	I = struct('b', [], 'n', []);
	for i = 1 : n
		if x(i) != 0
			I.b(j++) = i;
		else
			I.n(k++) = i;
		end
	end

	assert(!(length(I.b) < m), "x é degenerado!");
	assert(length(I.b) == m, "Base não tem m elementos!");

	% print resultados
	printf("\nCalcula a base:\n");
	x
	I
	
	% Calcula cb e B
	c = struct('c', c, 'b', []);
	k = 1;
	for i = I.b
		c.b(k) = c.c(i);
		B(:,k++) = A(:,i);
	end
	c.b = c.b';

	% print resultados
	printf("\nCalcula matriz basica B e custos basicos cb\n");
	A
	c.c
	c.b
	B

	% calcula custo reduzido de j, indice não básico, até achar um custo < 0 ou testar todos os indices
	do
		i = 1;
		do
			printf("\nCalcula Custo reduzido referente a direção d%d\n", j);

			j = I.n(i);
			d = direcaoViavel(A, inverse(B), n, m, j, I);
			redc = custoReduzido(c, d, j)
			i++;

			d.d	
		until (redc < 0) || (i > n - m)
		ij = i - 1 % Indice de j em In

		if redc < 0
			% Muda para novo ponto
			printf("\nCalcula novo ponto x\n");
			[imin, teta] = teta(x, d, I);
			if imin > 0
				x = x + teta * d.d

				% Rearruma a base
				[I.b(imin), I.n(ij)] = deal(I.n(ij), I.b(imin));
				c.b(imin) = c.c(I.b(imin));
				B(:,imin) = A(:,I.b(imin));
			end
		end
	until (redc >= 0 || imin == -1)

	printf("\nFim:\n");
	I.b
	I.n
	x
end 

%%%%%%%%%%%%%%% FUNÇÕES AUXILIARES %%%%%%%%%%%%%%%


% Calcula a j-ésima direção viável: -B^-1 * A_j
function d = direcaoViavel(A, invB, n, m, j, I)
	d = struct('d', [], 'b', []);

	d.d = zeros(n, 1);
	d.d(j) = 1;

	for k = 1 : m
		d.d(I.b(k)) = -invB(k, :) * A(:, j);
		d.b(k) = d.d(I.b(k));
	end
end

% Calcula o custo reduzido: c_j - c.b' * B^-1 * A_j
function redc = custoReduzido(c, d, j)
	redc = c.c(j) + c.b' * d.b;
end

% calcula o teta: min{ -x_b(i) / d_b(i) }, d_b(i) < 0, i em Ib
% além de retornar teta, retorna o índice de Ib que minimiza a expressão acima
function [imin, teta] = teta(x, d, I) 
	i = 1;

	% Verifica se existe um d_B(i) < 0
	while i <= length(I.b) && d.d(I.b(i)) >= 0
		i++;
	end

	if i <= length(I.b)
		teta = -x(I.b(i)) / d.d(I.b(i));
		imin = I.b(i++);
		while(i < length(I.b))
			t = -x(I.b(i)) / d.d(I.b(i));
			if t < teta
				teta = t;
				imin = I.b(i);
			end
			i++;
		end
	else
		imin = -1;
		teta = 0;
	end
end
