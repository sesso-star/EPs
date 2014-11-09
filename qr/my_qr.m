n = 18
m = 5

rand("seed", 2)
_A = A = fix(10 * rand(n, m));
_x = fix(10 * rand(m, 1));
_b = b = _A * _x;

for j = 1 : m
	maks = max(abs(A(j * (n - 1) + j : j * n)));
	if maks == 0
		gama = 0;
	else
		A((j - 1) * n + j : j * n) ./= maks;

		sigma = norm(A((j - 1) * n + j : j * n));

		if A(j, j) < 0
			sigma *= -1;
		end
		A(j, j) = A(j, j) + sigma;

		gama = 1 / (sigma * A(j, j));
		sigma *= maks;
	end
% Multiplica Q_j por A_j
	for k = j + 1 : m
		alpha = 0;
		for i = j : n
			alpha += A(i, j) * A(i, k);
		end
		for i = j : n
			A(i, k) -= gama * alpha * A(i, j);
		end
	end

	beta = 0;
	for i = j : n
		beta += A(i, j) * b(i);
	end
	for i = j : n
		b(i) -= gama * beta * A(i, j);
	end

	A(j, j) = -sigma;
end

R = triu(A);
c = b;
