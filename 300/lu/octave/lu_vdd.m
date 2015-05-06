n = 5;

A = a = randn(n);
X = randn(n, 1);
B = b =  A * X;

p = zeros(n, 1);

time = cputime;
printf("\nParte1:\n000%%");
for k = 1 : n
    if a(k, k) == 0
        printf("PARAAA");
    end
    
    imax = k;
    for i = k + 1 : n
        if abs(a(i, k)) > abs(a(imax, k))
            imax = i;
        end
    end
    if abs(a(imax, k)) < eps
        print("PARAAA");
    end
    if imax != k
        for j = 1 : n
            [a(k, j), a(imax, j)] = deal(a(imax, j), a(k, j));
        end
    end
    p(k) = imax; 

    for i = k + 1 : n
        a(i, k) = a(i, k) / a(k, k);
        for j = k + 1 : n
            a(i, j) = a(i, j) - a(k, j) * a(i, k);
        end
    end
    printf("\b\b\b\b%03.f%%", k * 100 / n);
end

l = eye(n) + tril(a, -1);
u = triu(a);

printf("\n\nParte2:\n000%%");
for i = 1 : n
    if p(i) != i
        [b(i), b(p(i))] = deal(b(p(i)), b(i));
    end
    printf("\b\b\b\b%03.f%%", i * 100 / n);
end

bBack = b;
printf("\n\nParte3:\n000%%");
for k = 1 : n
    for i = k + 1 : n
        b(i) = b(i) - b(k) * l(i, k);
    end
    printf("\b\b\b\b%03.f%%", k * 100 / n);
end

bBack2 = b;
printf("\n\nParte3:\n000%%");
for k = fliplr(1 : n)
    if u(k, k) == 0
        printf("PARA TUDO");
    end
    b(k) = b(k) / u(k, k);
    for i = fliplr(1 : k - 1)
        b(i) = b(i) - b(k) * u(i, k);
    end
    printf("\b\b\b\b%03.f%%", (n - k + 1) * 100 / n);
end
printf("\n\n");
time = cputime - time

%M = eye(n);
%for i = 1 : n
%    if p(i) != i
%        k = p(i);
%        x = eye(n);
%
%        [x(i, i), x(k, i)] = deal(x(k, i), x(i, i));
%        [x(k, k), x(i, k)] = deal(x(i, k), x(k, k));
%
%        M = x * M;
%    end
%end

diff = X - b;
for i = 1 : n
    if abs(diff(i)) > 1e-10
        printf("\nb(%d) - X(%d) = %f\n", i, i, abs(diff(i)));
    end
end

