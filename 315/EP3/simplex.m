function [ind, v] = simplex (A, b, c, m, n)
    [A, b, invB, I, m] = phase1(A, b, c, m, n)
    %[ind, v] = phase2(A, b, c, m, n, x, I, invB)
end

function [A, b, invB, I, rankA] =  phase1 (A, b, c, m, n)
    printf("Fase 1\n\n") ;
    for i = 1 : m
        if (b < 0)
            b *= -1;
            A(i, :)  *= -1;
        end
    end
    A
    A1 = [A, eye(m)]
    c1 = [zeros(n, 1); ones(m, 1)]
    % solução inicial x = 0, y = b
    x1 = [zeros(n, 1); b]
    I.b = [n + 1 : n + m]
    I.n = [1 : n]
    invB = inv(A1(:, I.b))
    [ind, x, I] = phase2(A1, b, c1, m, n + m, x1, I, invB); 
    % aqui precisamos verificar se todas variaveis articificiais valem zero. Se isso não
    % aconteceu, temos que o problema inicial é inviável. 
    [I, A, invB, m] = removeArtificials(x, I, A, invB, m, n);
end

function [ind, v, I] = phase2 (A, b, c, m, n, x, I, invB)
    printf("Iterando 0:\n")
    printXb(x, I, m);
    printCusto(x, c, n);

    imin = 0;
    it = 1;
    [redc, u, ij] = custoDirecao(A, invB, c, n, m, I);
    while redc < 0 % se essa condição falha, x é ótimo
        [imin, teta] = calculaTeta(x, u, I);
        if imin == -1 % custo ótimo é -inf e u tem a direção
            ind = -1;
            v = u2d(u, I.n(ij), I);
            printf("Solução é -inf na direção:\n");
            return;
        end

        % atualiza x
        x = atualizax(x, teta, u, I.n(ij), I, m); 
        [I, invB] = atualizaBase(I, invB, u, imin, ij, m); 
        printf("Iterando %d:\n", it);
        printXb(x, I, m);
        printCusto(x, c, n);

        it++;
        [redc, u, ij] = custoDirecao(A, invB, c, n, m, I);
    end

    ind = 0;
    v = x;
    printf("Solução ótima encontrada:\n");
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

    cbinvB = zeros (1, m);
    for i = 1 : m
        cbinvB += c(I.b(i)) * invB(i, :); % O(m^2)
    end

    printf("Custos Reduzidos\n");
    j = 1;
    while j <= n - m % O(nm - m²)
        redc = c(I.n(j)) - cbinvB * A(:, I.n(j));

        if redc < -1e-10
            % Achou um custo reduzido < 0
            ij = j;

            % Calcula direção u
            u = calculaDirecao(A, invB, I.n(ij));       % O(m^2)
            printf("\nEntra na base: %d\n\n", I.n(ij));
            printDir(u, I, m);
            
            return;
        end

        j++;
    end

    % Se chegou aqui é porque todos os custos reduzidos >= 0 (Solucão ótima!!)
    u = [];
    ij = -1;
    redc = 0;
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


function [I, invB] = atualizaBase(I, invB, u, imin, ij, m)
    % Dada uma base, e dois indices imin e ij, retira da base o imin-ésimo elemento 
    % básico (I.b(imin)) adiciona a base o ij-ésimo elemento não básico (I.n(ij)).
    % O vetor u vale B^-1 * A(I.n(ij))
    % Além disso atualiza a inversa da matriz básica.

    [I.b(imin), I.n(ij)] = deal(I.n(ij), I.b(imin));
    
    for i = 1 : m
        if i != imin
            invB(i,:) += (-u(i) * invB(imin,:)) / u(imin);
        end
    end
    invB(imin,:) /= u(imin);
end


function x = atualizax (x, t, u, j, I)
    % Dados x, theta, u e a variável j que entrou na base, atualiza o x s.v.b.
    % 
    
    for i = 1 : length(I.b)
        x(I.b(i)) -= t * u(i);
    end
    x(j) = t;
end


function I = calculaBase(x, n, m);
    % Calcula indices basicos e não básicos a partir de x não-degenerado
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


function [I, A, invB, m] = removeArtificials(x, I, A, invB, m, n)
    % Dado uma base I da primeira fase do simplex, esta função remove da base os
    % índices das variáveis artificiais. Se for necessário, deleta linhas LD de A
    
    artindex = I.b(I.b > n);
    
    for l = artindex
        k = 1;
        while ((k <= n - m) && abs(invB(l, :) * A(:, I.n(k))) <= 1e-10)  %% por que abs? o_O
            k++;
        end

        if k > n - m
            % Siginifica que B^-1(l, :) * Aj = 0 para todo j, isso significa que A tem
            % suas linhas LD. Ou seja, podemos remover uma de suas linhas. Vamos remover
            % a l-ésima linha.
            m -= 1;
            A(l, :) = [];
        else
            % vamos trocar a base do indice l para j
            u = invB * A(:, I.n(ij));
            [I, invB] = atualizaBase(I, invB, u, l, k, m);
        end
    end
end

function d = u2d(u, j, I)
    % Dado vetor u = -db, j e I retorna o vetor d tal que:
    % d_j = 1;
    % d_i = 0 se i \notin I.b
    % d_I.b(i) = u_i para i = 1..m

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
