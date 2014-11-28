n = 5;
m = 3;
A = rand(n, m);
b = rand(n, 1);
firstA = A
firstb = b;
%calcula todas as normas antes (column oriented)
for j = 1 : m
    infnorm = 0;
    %acha norma infinita da coluna
    for i = 1 : n
        if abs(A(i, j)) > infnorm
            infnorm = abs(A(i, j));
        end
    end
    %calcula a norma2/infnorm de cada coluna
    norm2 = 0;
    for i = 1 : n
        x = A(i, j) / infnorm;
        norm2 = norm2 + x * x;
    end
    sigma(j) = sqrt(norm2) * infnorm;
end

%norm(firstA(:,2), 2)
for k = 1 : m
    %pega maior norma dois e permuta
    maxn2 = 0;
    maxj = k;
    for j = k : m
        if sigma(j) > maxn2
            maxn2 = sigma(j);
            maxj = j;
        end
    end
    
    %permuta
    if maxj != k
        temp = A(:, maxj);
        A(:, maxj) = A(:, k);
        A(:, k) = temp;
        temp = sigma(k);
        sigma(k) = sigma(maxj);
        sigma(maxj) = temp;
    end
    perms(k) = maxj;

    %atualiza as outras normas
    for j = k + 1 : m
        sigma(j) = sqrt(sigma(j) * sigma(j) - A(k, j) * A(k, j));
    end

    %guarda o u
    if A(k, k) < 0
        sigma(k) = -sigma(k);
    end
    A(k, k) = A(k, k) + sigma(k);

    %guarda o gama
    gama(k) = 1 / (sigma(k) * A(k, k));

    %multiplica Q_k por A_k
    % A - gama * u * u^t A
    for l = k + 1 : m
        w = 0;
        for h = k : n
            w = w + A(h, k) * A(h, l);
        end
        for h = k : n
            A(h, l) = A(h, l) - gama(k) * w * A(h, k);
        end
    end
end
A
perms
sigma

%resolve b
%despermuta b
for i = 1 : m
    temp = b(i);
    b(i) = b(perms(i));
    b(perms(i)) = temp;
end
%multiplica as Q_k por b
for k = 1 : m
    innerp = 0;
    for i = k : n
        innerp += A(i, k) * b(j);
    end
    for i = k : n
        b(i) -= gama(k) * innerp * A(i, k);
    end
end
b


