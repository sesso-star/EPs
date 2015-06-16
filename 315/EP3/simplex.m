function [ind, x, d] = simplex(A, b, c, m, n)
    % Recebe:
    %   A: Matriz de restrições
    %   b: Vetor tal que A*x = b
    %   c: Vetor de custos
    %   m: número de restrições
    %   n: número de variáveis
    %
    % Calcula solução ótima para o PL: min c'x, S.A.: Ax = b, x >= 0
    %
    % Retorna:
    %   ind: Retorna 0 se uma solução ótima foi encontrada.
    %   x: Solução ótima encontrada
    %   d: Vetor vazio
    %   I: Índices básicos da solução encontrada
    %   invB: B^-1 associada à solução encontrada
    %   Caso o problema tiver custo ótimo -inf, retorna-se: 
    %       ind = -1
    %       x: Última svb utilizada
    %       d: direção para a qual o custo vai a -inf
    %   Caso o problema for inviável, retorna-se:
    %       ind = 1
    %       x = []
    %       d = []
    
    % Arruma restrições para que b > 0
    for i = 1 : m
        if (b < 0)
            b *= -1;
            A(i, :)  *= -1;
        end
    end

    % Cria problema auxiliar para achar primeira solução para o problema inicial
    A = [A, eye(m)];
    x = [zeros(n, 1); b];
    c1 = [zeros(n, 1); ones(m, 1)];
    I = struct('b', [n + 1 : n + m], 'n', [1 : n]);
    invB = eye(m);

    % Resolve problema auxiliar
    printf("\n******************** Fase1 ********************\n\n");
    [ind, x, d, I, invB] = fase2(A, b, c1, m, n + m, x, I, invB);

    if x(n + 1 : n + m) != 0
        % Problema Inviável
        ind = 1;
        x = [];
        d = [];
        printf("\n\nO problema é inviável\n");
        return;
    end

    % Remove vaiáveis artificiais da base. (não altera x)
    [I, A, invB, m] = removeArtificials(A, I, invB, m, n, b);
    x = x(1 : n);


    % Resolve problema inicial, com solução encontrada
    printf("\n******************** Fase2 ********************\n\n");
    [ind, x, d, I, invB] = fase2(A, b, c, m, n, x, I, invB);

    if ind == -1
        printf("\n\nO custo ótimo é -infinito, com direção:\nd =\n\n");
        disp(d);
        printf("A partir de:\nx = \n\n");
    else
        printf("\n\nSolução encontrada: \nx = \n\n");
    end
    disp(x);
end

function [ind, x, d, I, invB] = fase2(A, b, c, m, n, x, I, invB)
    % Recebe:
    %   A: Matriz de restrições
    %   b: Vetor tal que A*x = b
    %   c: Vetor de custos
    %   m: número de restrições
    %   n: número de variáveis
    %   x: Solução viável básica
    %   I: estrutura de indices básicos (I.b) e não básicos (I.n)
    %   invB: Inversa da matriz B (colunas de A com indice básico)
    %
    % Calcula solução ótima para o PL: min c'x, S.A.: Ax = b, x >= 0, sabendo que o problema é viável
    %
    % Retorna:
    %   ind: Retorna 0 se uma solução ótima foi encontrada.
    %   x: Solução ótima encontrada
    %   d: vetor vazio
    %   I: Índices básicos da solução encontrada
    %   invB: B^-1 associada à solução encontrada
    %   Caso o problema tiver custo ótimo -inf, retorna-se: 
    %       ind = -1
    %       x: Última svb utilizada
    %       d: direção para a qual o custo vai a -inf

    it = 0;
    printf("\nIteração %d:\n", it);
    printXb(x, I, m);
    printCusto(x, c);

    [redc, u, ij] = custoDirecao(A, invB, c, n, m, I);
    while redc < 0                              % se essa condição falha, x é ótimo
        [imin, teta] = calculaTeta(x, u, I);
        if imin == -1                           % custo ótimo é -inf e u tem a direção
            ind = -1;
            d = u2d(u, I.n(ij), I);
            return;
        end

        % atualiza
        x = atualizax(x, teta, u, I.n(ij), I); 
        [I, invB] = atualizaBase(I, invB, u, imin, ij, m);

        it++;
        printf("\nIteração %d:\n", it);
        printXb(x, I, m);
        printDir(u, I, m);
        printResto(x, c, I, ij, imin, teta);

        [redc, u, ij] = custoDirecao(A, invB, c, n, m, I);
    end
    
    d = [];
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

    % Calcula c_b' * B^-1 para evitar contas repetidas.
    cbinvB = c(I.b)' * invB;

    % itera pelos indices não básicos, procurando custo reduzido < 0.
    j = 1;
    while j <= n - m
        redc = c(I.n(j)) - cbinvB * A(:, I.n(j));

        if redc < -1e-10
            ij = j;
            u = invB * A(:, I.n(ij)); 

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
    % Recebe:
    %   x: Solução viável básica
    %   u: Componentes de indices básicos de uma direção viável
    %   I: estrutura de indices básicos (I.b) e não básicos (I.n)
    %
    % Calcula o teta: min{ -x_b(i) / d_b(i) }, d_b(i) < 0, i em Ib. 
    %
    % Retorna:
    %   imin: indice de I.b tal que teta = x(I.b(imin)) / u(I.b(imin))
    %   teta: Coeficiente tal que x + teta * d é uma nova svb
    %   Caso não haja d_b(i) < 0, isto é o custo ótimo é -inf, retorna-se imin = -1, teta = inf
    %
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
    % Recebe:
    %   I: estrutura de indices básicos (I.b) e não básicos (I.n)
    %   invB: Inversa da matriz B (colunas de A com indice básico)
    %   u: Componentes de indices básicos de uma direção viável
    %   imin: Indice de I.b
    %   ij: Indice de I.n
    %   m: número de restrições
    % 
    % Recalcula invB e I, de forma que x(I.b(imin)) saia da base e x(I.n(ij)) entre.
    % 
    % Retorna:
    %   invB: B^-1 recalculada
    %   I: índices recalculados
    %
    % Essa função é O(nm)
    [I.b(imin), I.n(ij)] = deal(I.n(ij), I.b(imin));
    
    for i = 1 : m
        if i != imin
            invB(i,:) += (-u(i) * invB(imin,:)) / u(imin);
        end
    end

    invB(imin,:) /= u(imin);
end


function x = atualizax (x, t, u, j, I)
    % Recebe:
    %   x: Solução viável básica
    %   teta: Coeficiente tal que x + teta * d é uma nova svb
    %   u: Componentes de indices básicos de uma direção viável
    %   j: Indice de x, tal que x(j) não era da base e agora entrou
    %   I: estrutura de indices básicos (I.b) e não básicos (I.n)
    %
    % Calcula nova svb x = x + teta * d
    %
    % Retorna:
    %   x: Nova svb
    %
    % Essa função é O(n)
    
    x(I.b) -= t * u;
    x(j) = t;
end


function I = calculaBase(x, n, m);
    % Recebe
    %   x: Solução viável básica
    %   n: número de variáveis
    %   m: número de restrições
    %
    % Calcula indices basicos e não básicos a partir de x não-degenerado
    % 
    % Retorna:
    %   I: estrutura tal que:
    %       I.b é o vetor de indices básicos 
    %       I.n é o vetor de índices não-básicos
    %
    % Essa função é O(nm^2)

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


function [I, A, invB, m] = removeArtificials(A, I, invB, m, n, b)
    % Recebe:
    %   A: Matriz de restrições
    %   I: estrutura de indices básicos (I.b) e não básicos (I.n)
    %   invB: Inversa da matriz B (colunas de A com indice básico)
    %   m: número de restrições
    %   n: número de variáveis
    %
    % Remove da base os índices das variáveis artificiais. Se for necessário, deleta linhas LD de A
    %
    % Retorna:
    %   I, A, invB, m recalculados.
    %
    % Essa função é O(m)
    
    for l = (1 : m)(I.b > n) % indexes of I.b with content greater than n
        b_cand = (1 : n)(I.n <= n);
        x = length(b_cand);
        k = 1;
        while ((k <= x) && abs(invB(l, :) * A(:, I.n(b_cand(k)))) <= 1e-10)  %% por que abs? o_O  % só quero saber se é diferente de zero, mas corro o risco de não dar exatamente zero
            k = k + 1;
        end
        
        if k > x
            % Siginifica que B^-1(l, :) * Aj = 0 para todo j (restrição redundante)
			invB(:,l) = [];
			invB(l,:) = [];
            I.b(l) = [];
            m--;
            A(l, :) = [];
            b(l) = [];
        else
            % vamos trocar a base do indice l (artificial) para j (não artificial)
            u = invB * A(:, I.n(b_cand(k))); 
            [I, invB] = atualizaBase(I, invB, u, l, b_cand(k), m);
        end
    end

    % "Recorta" variáveis artificiais de A e I.n
    A = A(:, 1 : n);
    I.n(I.n > n) = [];
end

function d = u2d(u, j, I)
    % Recebe
    %   u: Componentes de indices básicos de uma direção viável
    %   j: Indice de x, tal que x(j) não era da base e agora entrou
    %   I: estrutura de indices básicos (I.b) e não básicos (I.n)
    %
    % Retorna d tal que:
    %   d_j = 1;
    %   d_i = 0 se i \notin I.b
    %   d_I.b(i) = -u_i para i = 1..m

    d = zeros(1, length(I.b) + length(I.n));
    d(j) = 1;
    
    for i = 1 : length(I.b)
        d(I.b(i)) = -u(i);
    end
    d = d';
end


%%%%%%%%%%%%%%% FUNÇÕES DE IMPRESSÃO %%%%%%%%%%%%%%%

function printXb(x, I, m)
    % Recebe:
    %   x: Solução viável básica
    %   m: número de restrições
    %   I: estrutura de indices básicos (I.b) e não básicos (I.n)
    %
    % Imprime índices das variáveis básicas e seus respectivos valores

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
    % Recebe:
    %   u: Componentes de indices básicos de uma direção viável
    %   I: estrutura de indices básicos (I.b) e não básicos (I.n)
    %   m: número de restrições
    % 
    % Imprime índices das variáveis básicas e os valores correspondentes das componentes da direção d

    ind = "Indice var basicas";
    indl = length(ind);
    d = "Componente da direcao";
    dl = length(d);

    printf("|  %*s\t%*s\n|  ", indl, ind, dl, d);
    for _ = 1 : indl
        printf("=");
    end
    printf("\t");
    for _ = 1 : dl
        printf("=");
    end
    printf("\n");

    for i = 1 : m
        printf("|  %*d\t%*f\n", indl, I.b(i), dl, -u(i));
    end
    printf("|  \n");
end

function printResto(x, c, I, ij, imin, teta)
    % Recebe:
    %   x: Solução viável básica
    %   c: Vetor de custos
    %   I: estrutura de indices básicos (I.b) e não básicos (I.n)
    %   ij: Indice de I.n
    %   imin: Indice de I.b
    %   teta: Coeficiente tal que x + teta * d é uma nova svb
    % 
    %
    % Imprime o custo em x, teta, variável que entrou na base e a que saiu.
    cx = "Custo em x";
    cxl = length(cx);
    t = "   Teta   ";
    tl = length(t);
    in = "Entra na Base";
    inl = length(in);
    out = "Sai da Base";
    outl = length(out);

    printf("|  %*s\t%*s\t%*s\t%*s\n|  ", cxl, cx, tl, t, inl, in, outl, out);
    for _ = 1 : cxl
        printf("=");
    end
    printf("\t");
    for _ = 1 : tl
        printf("=");
    end
    printf("\t");
    for _ = 1 : inl
        printf("=");
    end
    printf("\t");
    for _ = 1 : outl
        printf("=");
    end
    printf("\n");

    printf("|  %*.3f\t%*.3f\t%*s\t%*s\n", cxl, (x'*c), tl, teta, inl, ["x" num2str(I.b(imin))], outl, ["x" num2str(I.n(ij))]);
    printf("|  \n");
end

function printCusto(x, c)
    % Recebe:
    %   x: Solução viável básica
    %   c: Vetor de custos
    %
    % Imprime o custo em x

    cx = "Custo em x";
    cxl = length(cx);

    printf("|  %*s\n|  ", cxl, cx);
    for _ = 1 : cxl
        printf("=");
    end
    printf("\n");
    printf("|  %*.3f\n", cxl, x'*c);
    printf("|  \n");
end
