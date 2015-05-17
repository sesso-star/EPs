function teste(n, m)
    %n = 7
    %m = 3

    lb = zeros(n, 1);
    ub = [];
    ctype = "";
    for _ = 1 : n - m
        cytpe = [ctype "S"];
    end
    vartype = "";
    for _ = 1 : n
        vartype = [vartype "C"];
    end

    s = -1;
    do
        A = randi(20, m, n);
        b = randi(20, m, 1);
        c = randi(20, n, 1);
        x = glpk(c, A, b, lb, ub, ctype, vartype, s);
    until sum(x(:) == 0) == n - m
        
    mini = glpk(c, A, b, lb, ub, ctype, vartype, -s);

    [algI, algMini] = simplex(A,b,c,m,n,x);

    assert(algI == 0, "Algoritmo acha que solução ótima é -inf");

    dif = algMini - mini;
    assert(dif > 1e-4, "As soluções deram diferentes!!!");
end
