function simplex (A, b, c, m, n, x)

    % Calcular indices basicos e não básicos a partir de x
    j = 1;
    k = 1;

    % I.b é o vetor de indices básicos e I.n é o vetor de índices não-básicos em x
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
    
    % Calcula cb e B
    k = 1;
    for i = I.b
        B(:,k++) = A(:,i);
    end
	invB = inv(B);
	clear("B");

    % calcula custo reduzido de j, indice não básico, até achar um custo < 0 ou testar todos os indices
    [redc, u, ij] = custoDirecao(A, invB, c, n, m, I);
    [imin, teta] = calculaTeta(x, u, I);
    while redc < 0 && imin != -1
        printf("\nCalcula novo ponto x\n");
		x = x + teta * u.d % ISSO NÂO FAZ MAIS SENTIDO PKE U EH RM

        % Rearruma a base
        [I.b(imin), I.n(ij)] = deal(I.n(ij), I.b(imin));
		for i = 1 : m
			if i != imin
				invB(i,:) -= -d(i) * invB(imin,:) / u(imin);
			else 
				invB(i,:) /= u(imin);
			end
		end

        % recalcula as bagaça
        [redc, u, ij] = custoDirecao(A, invB, c, n, m, I);
        [imin, teta] = calculaTeta(x, u, I);
    end

    printf("\nFim:\n");
    I.b
    I.n
    x
end 

%%%%%%%%%%%%%%% FUNÇÕES AUXILIARES %%%%%%%%%%%%%%%

% Calcula a direção e custo reduzido a partir de um ponto x
% retorna o custo, a direção e o indice ij de In de onde o custo
% reduzido passou a ser < 0
function [redc, d, ij] = custoDirecao(A, B, c, n, m, I)
    i = 1;
    do
        j = I.n(i);
        printf("\nCalcula Custo reduzido referente a direção d%d\n", j);
        d = direcaoViavel(A, inverse(B), n, m, j, I);
        redc = custoReduzido(c, d, j)
        i++;

        d.d 
    until (redc < 0) || (i > n - m)
    ij = i - 1 % Indice de j em In
end

% Calcula a j-ésima direção viável: 
% d.b = -B^-1 * A_j
% d.d = (0,...,0) + ej + e_B(1)
function d = direcaoViavel(A, invB, n, m, j, I)
    d = struct('d', [], 'b', []);

    d.d = zeros(n, 1);
    d.d(j) = 1;

    d.b = -invB * A(:,j);
    for k = 1 : m
        d.d(I.b(k)) = d.b(k);
    end
end

% calcula o teta: min{ -x_b(i) / d_b(i) }, d_b(i) < 0, i em Ib
% além de retornar teta, retorna o índice de Ib que minimiza a expressão acima
function [imin, teta] = calculaTeta(x, d, I) 
    i = 1;

    % Verifica se existe um d_B(i) < 0
    while i <= length(I.b) && d.d(I.b(i)) >= 0
        i++;
    end

    if i <= length(I.b)
        teta = -x(I.b(i)) / d.d(I.b(i));                                                  
        imin = I.b(i++);                     
        while(i <= length(I.b))
            t = -x(I.b(i)) / d.d(I.b(i));       % conseguimos garantir que esse d.d(I.b(i)) é menor que zero?
                                                % só queremos olhar para i básico em que di < 0.
            if t < teta  && t >= 0              % uma possivel solução
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
