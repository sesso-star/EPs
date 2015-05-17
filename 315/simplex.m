function simplex (A, b, c, m, n, x)
    % Calcula indices básicos (I.b) e não básicos (I.n)
    I = calculaBase(x, n, m);
    
    % Calcula B^-1
    invB = inv(A(:,I.b));

    printf("Simplex: Fase 2\n\n");
    printf("Iterando 0:\n")
    printXb(x, I, m);
    printCusto(x, c, n);

    imin = 0;
    it = 1;
    [redc, u, ij] = custoDirecao(A, invB, c, n, m, I);
    while redc < 0
        d = u2d(u, I.n(ij), I);
        [imin, teta] = calculaTeta(x, u, I);
        if imin == -1 % custo ótimo é -inf
            break;
        end
        
        % atualiza x
        x = atualizax(x, teta, u, I.n(ij), I); 
        % atualiza a base
        [I.b(imin), I.n(ij)] = deal(I.n(ij), I.b(imin));
        % atualiza B^-1
        for i = 1 : m
            %[imin, teta] = calculaTeta(x, u, I);
            if i != imin
                invB(i,:) -= -u(i) * invB(imin,:) / u(imin);
            else 
                invB(i,:) /= u(imin);
            end
        end

        printf("Iterando %d:\n", it);
        printXb(x, I, m);
        printCusto(x, c, n);

        it++;
        [redc, u, ij] = custoDirecao(A, invB, c, n, m, I);
    end

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
    % ij é o ij-ésimo componente não básico que vai se tornar básico

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
        invB
        ij
        A
        u = calculaDirecao(A, invB, I.n(ij));       % O(m^2)
        printf("Entra na base: %d\n", I.n(ij));
        %printDir(u, m);
    end
end

function [imin, teta] = calculaTeta(x, u, I) 
    % calcula o teta: min{ -x_b(i) / d_b(i) }, d_b(i) < 0, i em Ib
    % além de retornar teta, retorna o índice de Ib que minimiza a expressão acima
    imin = -1;
    teta = inf;

    printf("Vamos calcular o teta:\nu:\n");
    printDir(u, I, length(I.b));

    for i = 1 : length(I.b)
        if u(i) > 1e-8 % u_i > 0
            t = x(I.b(i)) / u(i); 
            if t < teta             
                teta = t;
                imin = i;
            end
        end
    end
        
    printf("Theta*\n%f\n\n", teta);
    if (imin != -1)
        printf("Sai da base: %d\n\n\n", I.b(imin));
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
        d(I.b(i)) = -u(i);
    end
    d = d'
end


function printXb(x, I, m)
    for i = 1 : m
        printf("%d %f\n", I.b(i), x(I.b(i)));
    end
    printf("\n");
end


function printDir(u, I, m)
    for i = 1 : m
        printf("%d %f\n", I.b(i), u(i));
    end
    printf("\n");
end


function printCusto(x, c, n)
    printf("Valor função objetivo: %f\n\n", x'*c);
end
