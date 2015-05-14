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
    [redc, d, ij] = custoDirecao(A, B, c, n, m, I);
    [imin, teta] = calculaTeta(x, d, I);
    while redc < 0 && imin != -1
        printf("\nCalcula novo ponto x\n");
        x = x + teta * d.d

        % Rearruma a base
        [I.b(imin), I.n(ij)] = deal(I.n(ij), I.b(imin));
        c.b(imin) = c.c(I.b(imin));
        B(:,imin) = A(:,I.b(imin));
        [redc, d, ij] = custoDirecao(A, B, c, n, m, I);

        % recalcula teta
        [imin, teta] = calculaTeta(x, d, I);
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
% 
% redc = c(ij) - [(c.b)^t * (invB)] * Aj
% d = -(invB) * Aj
function [redc, u, ij] = custoDirecao(A, invB, c, n, m, I)
    i = 1;
    cbinvB = c.b' * invB; % O(m^2) 
    do                    % O(n - m)
        j = I.n(i);
        printf("\nCalcula Custo reduzido referente a direção j = %d\n", j);
        redc = custoReduzido(c.c(j), cbinvB, A(:, j)) % O (1)
        i++;
    until (redc < 0) || (i > n - m)

    ij = i - 1 % Indice de j em In
    u = calculaDirecao(A, invB, n, m, ij, I);
end


% Calcula a j-ésima direção viável. Devolve em u
% o vetor u = -db = B^-1 * A_j
%
function u = calculaDirecao(A, invB, j)
    u = -invB * A(:,j);
end


% Dado vetor u = -db, j e I retorna o vetor d tal que:
% d_j = 1;
% d_i = 0 se i \notin I.b
% d_I.b(i) = u_i para i = 1..m
%
function d = u2d(u, j, I)
    d = zeros(1, n);
    d(j) = 1;
    for i = 1 : m
        d(I.b(i)) = u(i);
    end
end

% Calcula o custo reduzido: c_j - c.b' * B^-1 * A_j
%
function redc = custoReduzido(cj, cbinvB, Aj)
    redc = cj - cbinvB * Aj;
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
        while(i < length(I.b))
            t = -x(I.b(i)) / d.d(I.b(i));       % conseguimos garantir que esse d.d(I.b(i)) é menor que zero?
                                                % só queremos olhar para i básico em que di < 0.
            if t < teta % && t >= 0             uma possivel solução
                teta = t;
                imin = I.b(i);
            end
            i++;
        end
    else
        imin = -1;
        teta = 0;
    end
     % tentativa 2
     %
     % while (i <= length (I.b))
     %   
end



