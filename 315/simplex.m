function simplex (A, b, c, m, n, x)
	% Calcula indices básicos (I.b) e não básicos (I.n)
	I = calculaBase(x, n, m);
	
	% Calcula B^-1
	invB = inv(A(:,I.b));

	printf("\n************* Inicio ****************\n");
	x
	I
        
        printf("Simplex: Fase 2\n\n");
        printf("Iterando 0:\n")
        %printXb(x, I, m);
        %printCusto(x, c, n);
    
        imin = 0;
        it = 1;
        [redc, u, ij] = custoDirecao(A, invB, c, n, m, I);
	while redc < 0
		[imin, teta] = calculaTeta(x, u, I);
                if imin == -1 % custo ótimo é -inf
                    break;
                end
		u2d(u, I.n(ij), I); %%%%%%%%%%%%% imprime d: so ta aqui pra imprimir pra agte ver bonitinho.. mas na moral naão precisa koapskoap

                printf("Iterando %d:\n");
		x = atualizax(x, teta, u, I.n(ij), I)


		% Rearruma a base
		[I.b(imin), I.n(ij)] = deal(I.n(ij), I.b(imin));
		for i = 1 : m
		    %[imin, teta] = calculaTeta(x, u, I);
			if i != imin
				invB(i,:) -= -u(i) * invB(imin,:) / u(imin);
			else 
				invB(i,:) /= u(imin);
			end
		end
                it++;
                [redc, u, ij] = custoDirecao(A, invB, c, n, m, I);
	end

	printf("\n\n\n************** Fim ***************\n");
	I.b
	I.n
	x
end 


%%%%%%%%%%%%%%% FUNÇÕES AUXILIARES %%%%%%%%%%%%%%%

function [redc, u, ij] = custoDirecao(A, invB, c, n, m, I)
	% Dado uma matriz A, a matriz Basica invertida e os indices básicos e não basicos
	% essa função acha um indice ij de indices não basicos, o qual o indice associado
	% gera uma direção onde o custo reduzido de I.n(ij) é < 0. 
	% Retorna-se o custo reduzido de tal indice, os valores da direção de indices basicos
	% e o indice ij
	% 
	% redc = c(j) - [(c.b)' * (invB)] * Aj
	% u = (invB) * Aj

	cbinvB = zeros (1, m);
	for i = 1 : m
		cbinvB += c(I.b(i)) * invB(i, :); % O(m^2)
	end
        
	% calcula o custo reduzido para todos indices não básicos
        rc = zeros (1, n - m);
        redc = 0;
        ij = -1;
        u = [];
        printf("Custos Reduzidos\n");
        for j = 1 : n - m % O(nm - m²)
            nj = I.n(j);
            rc(j) = custoReduzido(c(nj), cbinvB, A(:, nj)); % O(m)
            printf ("%d %f\n", nj, rc(j));
            if rc(j) < redc
                ij = j;
                redc = rc(j);
            end
        end
        
        if ij != -1        
            % Indice de ij em I.n
	    u = calculaDirecao(A, invB, ij);	% O(m^2)	TODO NÃO DA PRA REDUZIR ESSE ?? Acho que não! É multiplicação de uma matriz mxm e um vetor m. Então é soma de linha j de invB * escalar Aj(j)
            printf("Entra na base: %d\n", I.n(ij));
            printf("Custo reduzido %f\n", redc);
            %printDir(u, m);
        end
end

function [imin, teta] = calculaTeta(x, u, I) 
	% calcula o teta: min{ -x_b(i) / d_b(i) }, d_b(i) < 0, i em Ib
	% além de retornar teta, retorna o índice de Ib que minimiza a expressão acima
        printf ("A grandiosa função: calcula teta!\n");
	i = 1;
	% Verifica se existe um d_B(i) < 0
	while i <= length(I.b) && u(i) < 0
		i++;
	end

	if i <= length(I.b)
		teta = x(I.b(i)) / u(i);
		imin = i++;
		while(i <= length(I.b))
                        if abs(u(i)) < eps
			        t = x(I.b(i)) / u(i);d 
			        if t < teta             
				    teta = t;
				    imin = i;
			        end
                        end
		        i++;
		end
	else
		imin = -1;
		teta = 0;
	end

        printf("Theta*\n%f\n\n", teta);
        if (imin != -1)
            printf("Sai da base: %d\n", imin);
        end
end


function u = calculaDirecao(A, invB, j)
	% Calcula a j-ésima direção viável. Devolve em u
	% o vetor u = -db = B^-1 * A_j
	%

	u = invB * A(:,j);
end


function x = atualizax (x, t, u, j, I)
	for i = 1 : length(I.b)
		x(I.b(i)) -= t * u(i);
	end
	x(j) = t;
end

function redc = custoReduzido(cj, cbinvB, Aj)
	% Calcula o custo reduzido: c_j - c.b' * B^-1 * A_j
	%
	
        redc = cj - cbinvB * Aj;
end

function I = calculaBase(x, n, m);
	% Calcula indices basicos e não básicos a partir de x
	% I.b é o vetor de indices básicos 
    % I.n é o vetor de índices não-básicos

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
	% verifica se o x passado é degenerado ou não. Isso é, se x tem de fato (n - m) zeros
	assert(!(length(I.b) < m), "x é degenerado!");
	assert(length(I.b) == m, "Base não tem m elementos!");
end


function d = u2d(u, j, I)
	% Dado vetor u = -db, j e I retorna o vetor d tal que:
	% d_j = 1;
	% d_i = 0 se i \notin I.b
	% d_I.b(i) = u_i para i = 1..m
	%

	d = zeros(1, length(I.b) + length(I.n));
	d(j) = 1;
	for i = 1 : length(I.b)
		d(I.b(i)) = u(i);
	end
	d = d'
end




