function inv = invert(a)
	n = length(a);
	id = eye(n);
	inv = [];

	%calcTime = cputime;
	[l, u, p] = lu_calc(a);
	%calcTime = cputime - calcTime

	%solveTime = cputime;
	for j = 1 : n
		e = id(:,j);

		inv = [inv lu_solve(l, u, e, p)];
	end
	%solveTime = cputime - solveTime
end


