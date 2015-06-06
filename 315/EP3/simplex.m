function [ind, v] = simplex (A, b, c, m, n, x)
    [ind, v] = phase2 (A, b, c, m, n, x)
end

function [ind, v] = phase2 (A, b, c, m, n, x)
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
    while redc < 0 % se essa condição falha, x é ótimo
        [imin, teta] = calculaTeta(x, u, I);
        if imin == -1 % custo ótimo é -inf e u tem a direção
            break;
        end

        % atualiza x
        x = atualizax(x, teta, u, I.n(ij), I); 
        % atualiza a base
        [I.b(imin), I.n(ij)] = deal(I.n(ij), I.b(imin));
        % atualiza B^-1
        for i = 1 : m
            if i != imin
                invB(i,:) += (-u(i) * invB(imin,:)) / u(imin);
            end
        end
        invB(imin,:) /= u(imin);

        printf("Iterando %d:\n", it);
        printXb(x, I, m);
        printCusto(x, c, n);

        it++;
        [redc, u, ij] = custoDirecao(A, invB, c, n, m, I);
    end

    if imin == -1
        ind = -1;
        v = u2d(u, I.n(ij), I);
        printf("Solução é -inf na direção:\n");
    else
        ind = 0;
        v = x;
        printf("Solução ótima encontrada:\n");
    end
    v
end 


%%%%%%%%%%%%%%% FUNÇÕES AUXILIARES %%%%%%%%%%%%%%%

function [redc, u, ij] = custoDirecao(A, invB, c, n, m, I)
    % Dado uma matriz A, a matriz Basica invertida e os indices básicos e não basicos
    % essa função acha um indice ij de indices não basicos, o qual o indice associado
    % gera uma direção onde o custo reduzido de I.n(ij) é < 0. 
    % Retorna-se o custo reduzido de tal indice, os valores da direção de indices 
    % basicos e o indice ij. Além disso, o índice ij é o menor indice não-básico com
    % custo reduzino menor do que zero.
    % 
    % redc = c(j) - [(c.b)' * (invB)] * Aj
    % u = (invB) * Aj
    % ij é o ij-ésimo componente não básico que vai se tornar básico
    % p = cb * invB
    %
    % Esta função é O(nm)

    p = zeros (1, m);
    for i = 1 : m
        p += c(I.b(i)) * invB(i, :); % O(m^2)
    end

    % calcula o custo reduzido para todos indices não básicos
    redc = 0;
    ij = -1;
    u = [];
    printf("Custos Reduzidos\n");
    j = 1;
    
    while ((j <= n - m) && (redc == 0)) % O(nm - m²)
        nj = I.n(j);
        rc(j) = custoReduzido(c(nj), p, A(:, nj)); % O(m)
        printf ("%d %f\n", nj, rc(j));
        if rc(j) < redc - 1e-10
            ij = j;
            redc = rc(j);
        end
        j++;
    end
    
    if ij != -1        
        u = calculaDirecao(A, invB, I.n(ij));       % O(m^2)
        printf("\nEntra na base: %d\n\n", I.n(ij));
        printDir(u, I, m);
    end
end

function [imin, teta] = calculaTeta(x, u, I) 
    % Calcula o teta: min{ -x_b(i) / d_b(i) }, d_b(i) < 0, i em Ib. Além de retornar 
    % teta, retorna o menor índice de Ib que minimiza a expressão acima.
    % Essa função é O(m)
    imin = -1;
    teta = inf;
    
    for i = 1 : length(I.b)
        if u(i) > 1e-10 % u_i > 0
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
    d = d';
end


function printXb(x, I, m)
    for i = 1 : m
        printf("%d %f\n", I.b(i), x(I.b(i)));
    end
    printf("\n");
end


function printDir(u, I, m)
    printf("Direção:\n");
    for i = 1 : m
        printf("%d %f\n", I.b(i), u(i));
    end
    printf("\n");
end


function printCusto(x, c, n)
    printf("Valor função objetivo: %f\n\n", x'*c);
end
