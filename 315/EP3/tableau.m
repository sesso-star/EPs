function [ind, v] = tableau (A, b, c, m, n, x)
    Ib = calculaBase(x, n, m);
    invB = inv(A(:, Ib));

    tableaux = [0,       c' - c(Ib)' * invB * A;
               invB * b, invB * A];

    
    while (j = getJ(tableaux)) != 0
        l = getL(tableaux, j);
        if l == 0
            % Entra aqui se não existe u > 0, logo custo ótimo é -inf
            ind = -inf;
            v = 0; % ERRADO
            return;
        end

        tableaux = pivotate(tableaux, l, j);
        Ib(l - 1) = j - 1;
    end

    ind = 0;
    v = getX(tableaux, Ib);
end

function j = getJ(tab)
    % Devolve a j-ésima coluna do tableaux, usando regra anti-ciclagem de menor indice. 
    % Caso não haja custo reduzido < 0, função retorna 0.
    i = 2;
    while i <= columns(tab)
        if tab(1, i) < -1e-10
            j = i;
            return;
        end
        i++;
    end
    j = 0;
end

function l = getL(tab, j)
    % Devolve a l-ésima linha do tableaux.
    % Caso não haja u > 0, retorna 0.
    i = 2;
    while i <= rows(tab) && tab(i, j) <= 1e-10
        i++;
    end
    if i > rows(tab)
        l = 0;
        return;
    end

    l = i;
    mini = tab(i, 1) / tab(i, j);
    i++;

    while i <= rows(tab)
        if tab(i, j) > 1e-10
            quoc = tab(i, 1) / tab(i, j);
            if quoc < mini
                l = i;
                mini = quoc;
            end
        end
        i++;
    end
end

function x = getX(tab, Ib)
    % Retorna o x a partir de uma base e um tableaux
    x = zeros(columns(tab) - 1, 1);
    for i = 1 : rows(tab) - 1
        x(Ib(i)) = tab(i + 1, 1);
    end
end

function tab = pivotate(tab, l, j)
    % pivoteia o tableau utilizando o elemento tab(l, j) como pivot
    for i = 1 : rows(tab)
        if i != l
            tab(i, :) -= tab(i, j) / tab(l, j) * tab(l, :);
        end
    end
    tab(l, :) /= tab(l, j);
end

function Ib = calculaBase(x, n, m);
    % Calcula indices basicos e não básicos a partir de x não-degenerado
    % Ib é o vetor de indices básicos 
    Ib = zeros(m, 1);
    j = 1;
    for i = 1 : n
        if x(i) != 0
            Ib(j++) = i;
        end
    end
    % verifica se o x passado é degenerado ou não. Isso é, se x tem de fato (n - m) zeros
    assert(!(length(Ib) < m), "x é degenerado!");
    assert(length(Ib) == m, "Base não tem m elementos!");
end