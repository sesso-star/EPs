n = input("n: ");
m = input("m: ");

A = (10 * randn(n, m));
x = [1 : m]';
b = A * x;

%rand("seed", 2);
%_A = A = fix(10 * rand(n, m));
%_x = fix(10 * rand(m, 1));
%_b = b = _A * _x;

filename = input("Arquivo a ser salvo: ", "s");

f = fopen(filename, "w");

fputs(f, [mat2str(n) " " mat2str(m) "\n"]);
for i = 1 : n
	for j = 1 : m
		fputs(f, [mat2str(i - 1) " " mat2str(j - 1) " \t" mat2str(A(i, j)) "\n"]);
	end
end

for i = 1 : n
	fputs(f, [mat2str(i - 1) " \t" mat2str(b(i)) "\n"]);
end

fclose(f);


[q, r] = qr(A);

answer = r \ (q' * b)
q
r

f = fopen([filename "-answer"], "w");

fputs(f, "x = \n");
dlmwrite(f, answer);

fputs(f, "\nq = \n");
dlmwrite(f, q);

fputs(f, "\nr = \n");
dlmwrite(f, r);

fclose(f);

