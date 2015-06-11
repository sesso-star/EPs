function [ind, v] = simplex(A, b, c, m, n)
    % Arruma restrições para que b > 0
    for i = 1 : m
        if (b < 0)
            b *= -1;
            A(i, :)  *= -1;
        end
    end

    % Cria problema auxiliar para achar primeira solução para o problema primal
    A = [A, eye(m)];
    x = [zeros(n, 1); b];
    c1 = [zeros(n, 1); ones(m, 1)];
    I = struct('b', [n + 1 : n + m], 'n', [1 : n]);
    invB = inv(A(:, I.b));

    % Resolve problema auxiliar
    printf("\n******************** Fase1 ********************\n\n");
    [ind, x, I, invB] = fase2(A, b, c1, m, n + m, x, I, invB);

    % Verifica se o problema primal é viável
    if x(n + 1 : n + m) != 0
        ind = 1;
        v = x = [];
        return;
    end

    % Remove vaiáveis artificiais da base. (não altera x)
    [I, A, invB, m] = removeArtificials(A, I, invB, m, n);
    x = x(1 : n);

    % Resolve problema primal, com solução encontrada
    printf("\n******************** Fase2 ********************\n\n");
    [ind, v, I, invB] = fase2(A, b, c, m, n, x, I, invB);
end

function [ind, v, I, invB] = fase2(A, b, c, m, n, x, I, invB)
    %
    %
    %

    it = 0;
    printf("\nIteração %d:\n", it);
    printXb(x, I, m);
    printCusto(x, c, n);

    [redc, u, ij] = custoDirecao(A, invB, c, n, m, I);
    while redc < 0                              % se essa condição falha, x é ótimo
        [imin, teta] = calculaTeta(x, u, I);
        if imin == -1                           % custo ótimo é -inf e u tem a direção
            ind = -1;
            v = u2d(u, I.n(ij), I);
            return;
        end

        % atualiza x
        x = atualizax(x, teta, u, I.n(ij), I); 
        [I, invB] = atualizaBase(I, invB, u, imin, ij, m);

        it++;
        printf("\nIteração %d:\n", it);
        printXb(x, I, m);
        printDir(u, I, m);
        printCusto(x, c, n);
        printf("|  => entra na base <=: x%d\n", I.n(ij)); 
        printf("|  <=  sai da base  =>: x%d\n", I.b(imin));
        printf("|  Teta: %f\n", teta);

        [redc, u, ij] = custoDirecao(A, invB, c, n, m, I);
    end

    v = x;
    ind = 0;
end 


%%%%%%%%%%%%%%% FUNÇÕES AUXILIARES %%%%%%%%%%%%%%%

function [redc, u, ij] = custoDirecao(A, invB, c, n, m, I)
    % Recebe:
    %   A: Matriz de restrições
    %   invB: Inversa da matriz B (colunas de A com indice básico)
    %   c: Vetor de custos
    %   n: número de variáveis
    %   m: número de restrições
    %   I: estrutura de indices básicos (I.b) e não básicos (I.n)
    %
    % Procura por uma direção a partir de uma solução (consegue-se isso, pois temos invB)
    % na qual o custo reduzido (custo na solução encontrada a partir da direção) é menor 
    % que zero.
    %
    % Retorna:
    %   redc: custo reduzido associado à direção encontrada.
    %   u: Direção na qual o custo reduzido é menor que 0. 
    %   ij: indice tal que I.n(ij) == j e j é o indice associado à direção u.
    %   Caso não haja custo reduzido menor que 0, retorna-se redc = 0, u = [], ij = -1
    %
    % Esta função é O(nm)

    % Calcula c_b' * B^-1 para evitar contas repetidas.   ~ O(m^2)
    cbinvB = c(I.b)' * invB;

    % itera pelos indices não básicos, procurando custo reduzido < 0.   ~ O(nm)
    j = 1;
    while j <= n - m
        redc = c(I.n(j)) - cbinvB * A(:, I.n(j));

        if redc < -1e-10
            ij = j;
            u = invB * A(:, I.n(ij)); % O(m^2)

            % Retorna o primeiro custo reduzido < 0. (Regra anti-ciclagem pelo menor indice)
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
        if u(i) > 1e-10 
            t = x(I.b(i)) / u(i);
            if t < teta
                teta = t;
                imin = i;
            end
        end
    end
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
    
    x(I.b) -= t * u;
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


function [I, A, invB, m] = removeArtificials(A, I, invB, m, n)
    % Dado uma base I da primeira fase do simplex, esta função remove da base os
    % índices das variáveis artificiais. Se for necessário, deleta linhas LD de A
    
    for l = I.b(I.b > n)
        k = 1;
        while ((k <= n - m) && abs(invB(l, :) * A(:, I.n(k))) <= 1e-10)  %% por que abs? o_O
            k++;
        end

        if k > n - m
            % Siginifica que B^-1(l, :) * Aj = 0 para todo j, isso significa que A tem
            % suas linhas LD. Ou seja, podemos remover uma de suas linhas. Vamos remover
            % a l-ésima linha.
            m--;
            A(l, :) = [];
        else
            % vamos trocar a base do indice l para j
            u = invB * A(:, I.n(ij));
            [I, invB] = atualizaBase(I, invB, u, l, k, m);
        end
    end
    A = A(:, 1 : n);
    I.n(I.n > n) = [];
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
    vb = "Var Basicas";
    vbl = length(vb);
    v = "Valor";
    vl = length(v) + 5;

    printf("|  %*s\t%*s\n|  ", vbl, vb, vl, v);
    for _ = 1 : vbl
        printf("=");
    end
    printf("\t");
    for _ = 1 : vl
        printf("=");
    end
    printf("\n");

    for i = 1 : m
        printf("|  %*s\t%*f\n", vbl, ["x" num2str(I.b(i))], vl, x(I.b(i)));
    end
    printf("|  \n");
end


function printDir(u, I, m)
    %% Formatar direção
    printf("|  Direção:\n");
    for i = 1 : m
        printf("|  %d %f\n", I.b(i), u(i));
    end
    printf("|  \n");
end


function printCusto(x, c, n)
    printf("|  Valor função objetivo: %f\n", x'*c);
end
