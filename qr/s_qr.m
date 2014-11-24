n = 3
m = 3

rand("seed", 2)
_A = A = fix(10 * rand(n, m));
_x = fix(10 * rand(m, 1));
_b = b = _A * _x;

sigma = zeros(m, 1);

for j = 1 : m
	mx = abs(A(1, j));
	for i = 2 : n
		if abs(A(i, j)) > mx
			mx = abs(A(i, j));
		end
	end

	for i = 1 : n
		normalized = A(i, j) / mx;
		sigma(j) += normalized * normalized;
	end
	sigma(j) = sqrt(sigma(j));
	sigma(j) *= mx;
end

for j = 1 : m
	% swap columns
	mx = sigma(j);
	maxI = j;
	for k = j + 1 : m
		if sigma(k) > mx
			mx = sigma(k);
			maxI = k;
		end
	end
	if maxI != j
		for i = 1 : n
			aux = A(i, j);
			A(i, j) = A(i, k);
			A(i, k) = aux;
			aux = sigma(j);
			sigma(j) = sigma(k);
			sigma(k) = aux;
		end
	end
	
	mySigma = sigma(j);
	if A(j, j) < 0
		mySigma *= -1;
	end
	
	A(j, j) += mySigma;

	gama = 1 / (mySigma * A(j, j));

	mySigma
	
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

	A(j, j) = -mySigma;

	for k = j + 1 : m
		sigma(k) = sqrt( sigma(k) * sigma(k) - A(j, k) * A(j, k) );
	end
end

for i = m : -1 : 1
	for j = i + 1 : m
		b(i) -= A(i, j) * b(j);
	end
	b(i) /= A(i, i);
end

