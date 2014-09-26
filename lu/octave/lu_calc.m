function [l, u, p] = lu_calc(a)
	n = length(a);
	A = a;
	p = zeros(n, 1);

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
	end

	l = eye(n) + tril(a, -1);
	u = triu(a);
end
