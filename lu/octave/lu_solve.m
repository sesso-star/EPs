function x = lu_solve(l, u, b, p)
	n = length(l);

	for i = 1 : n
		if p(i) != i
			[b(i), b(p(i))] = deal(b(p(i)), b(i));
		end
	end

	for k = 1 : n
		for i = k + 1 : n
			b(i) = b(i) - b(k) * l(i, k);
		end
	end

	for k = fliplr(1 : n)
		if u(k, k) == 0
			printf("PARA TUDO");
		end
		b(k) = b(k) / u(k, k);
		for i = fliplr(1 : k - 1)
			b(i) = b(i) - b(k) * u(i, k);
		end
	end

	x = b;
end
