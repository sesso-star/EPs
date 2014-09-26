n = 5
A = a = randn(n);

for k = 1 : n
    if a(k, k) == 0
        printf("PARAA TUDO");
    end
    for i = k + 1 : n
        a(i, k) = a(i, k) / a(k, k);
        for j = k + 1 : n
            a(i, j) = a(i, j) - a(k, j) * a(i, k);
        end
    end
end

l = tril(a, -1) + eye(n)
u = triu(a)
