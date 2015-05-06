function compareInvs(a)
	my_time = cputime;
	invert(a);
	my_time = cputime - my_time

	oct_time = cputime;
	inv(a);
	oct_time = cputime - oct_time

	humilhation = my_time / oct_time
end
