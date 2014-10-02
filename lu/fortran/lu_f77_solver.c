/* lu_f77_solver.f -- translated by f2c (version 20100827).
   You must link the resulting object file with libf2c:
	on Microsoft Windows system, link with libf2c.lib;
	on Linux or Unix systems, link with .../path/to/libf2c.a -lm
	or, if you install libf2c.a in a standard place, with -lf2c -lm
	-- in that order, at the end of the command line, as in
		cc *.o -lf2c -lm
	Source for libf2c is in /netlib/f2c/libf2c.zip, e.g.,

		http://www.netlib.org/f2c/libf2c.zip
*/

#include "f2c.h"

/* Common Block Declarations */

struct {
    doublereal eps;
} const_;

#define const_1 const_

/* Table of constant values */

static integer c__9 = 9;
static integer c__1 = 1;
static integer c__3 = 3;
static integer c__5 = 5;

/* Main program */ int MAIN__(void)
{
    /* Builtin functions */
    integer s_cmp(char *, char *, ftnlen, ftnlen), s_wsle(cilist *), do_lio(
	    integer *, integer *, char *, ftnlen), e_wsle(void);

    /* Local variables */
    static doublereal a[1000000]	/* was [1000][1000] */, b[1000];
    static integer i__, n, p[1000];
    extern /* Subroutine */ int readmatrix_(doublereal *, doublereal *, 
	    integer *, integer *);
    static integer lda;
    static char arg[100];
    static integer res;
    static logical qtmd;
    extern /* Subroutine */ int printdvector_(doublereal *, integer *);
    static logical colmd;
    extern integer lucol_(integer *, integer *, doublereal *, integer *), 
	    sscol_(integer *, integer *, doublereal *, integer *, doublereal *
	    ), lurow_(integer *, integer *, doublereal *, integer *), ssrow_(
	    integer *, integer *, doublereal *, integer *, doublereal *);
    extern /* Subroutine */ int getarg_(integer *, char *, ftnlen);

    /* Fortran I/O blocks */
    static cilist io___9 = { 0, 6, 0, 0, 0 };
    static cilist io___12 = { 0, 6, 0, 0, 0 };
    static cilist io___13 = { 0, 6, 0, 0, 0 };
    static cilist io___14 = { 0, 6, 0, 0, 0 };
    static cilist io___15 = { 0, 6, 0, 0, 0 };
    static cilist io___16 = { 0, 6, 0, 0, 0 };


    colmd = FALSE_;
    qtmd = FALSE_;
    const_1.eps = 1e-16f;
    lda = 1000;
    readmatrix_(a, b, &lda, &n);
    for (i__ = 1; i__ <= 2; ++i__) {
	getarg_(&i__, arg, (ftnlen)100);
	if (s_cmp(arg, "-c", (ftnlen)100, (ftnlen)2) == 0) {
	    colmd = TRUE_;
	} else if (s_cmp(arg, "-q", (ftnlen)100, (ftnlen)2) == 0) {
	    qtmd = TRUE_;
	}
    }
    if (colmd) {
	s_wsle(&io___9);
	do_lio(&c__9, &c__1, "Calculando orientado a colunas", (ftnlen)30);
	e_wsle();
	res = lucol_(&n, &lda, a, p);
	if (res == 0) {
	    res = sscol_(&n, &lda, a, p, b);
	    if (res == 0) {
		if (! qtmd) {
		    printdvector_(b, &n);
		}
	    } else {
		s_wsle(&io___12);
		do_lio(&c__9, &c__1, "sscol: A matriz parece ser singular", (
			ftnlen)35);
		e_wsle();
	    }
	} else {
	    s_wsle(&io___13);
	    do_lio(&c__9, &c__1, "lucol: A matriz parece ser singular", (
		    ftnlen)35);
	    e_wsle();
	}
    } else {
	s_wsle(&io___14);
	do_lio(&c__9, &c__1, "Calculando orientado a linhas", (ftnlen)29);
	e_wsle();
	res = lurow_(&n, &lda, a, p);
	if (res == 0) {
	    res = ssrow_(&n, &lda, a, p, b);
	    if (res == 0) {
		if (! qtmd) {
		    printdvector_(b, &n);
		}
	    } else {
		s_wsle(&io___15);
		do_lio(&c__9, &c__1, "ssrow: A matriz parece ser singular", (
			ftnlen)35);
		e_wsle();
	    }
	} else {
	    s_wsle(&io___16);
	    do_lio(&c__9, &c__1, "lurow: A matriz parece ser singular", (
		    ftnlen)35);
	    e_wsle();
	}
    }
    return 0;
} /* MAIN__ */

integer lurow_(integer *n, integer *lda, doublereal *a, integer *p)
{
    /* System generated locals */
    integer a_dim1, a_offset, ret_val, i__1, i__2, i__3;
    doublereal d__1, d__2;

    /* Local variables */
    static integer i__, j, k, imax;
    extern /* Subroutine */ int swap_(doublereal *, doublereal *);

/*   SCALAR ARGUMENTS */
/*   ARRAY ARGUMENTS */
/*   GLOBAL SCALARS */
/*   LOCAL SCALARS */
    /* Parameter adjustments */
    --p;
    a_dim1 = *lda;
    a_offset = 1 + a_dim1;
    a -= a_offset;

    /* Function Body */
    i__1 = *n;
    for (k = 1; k <= i__1; ++k) {
	imax = k;
	i__2 = *n;
	for (i__ = k + 1; i__ <= i__2; ++i__) {
	    if ((d__1 = a[i__ + k * a_dim1], abs(d__1)) > (d__2 = a[imax + k *
		     a_dim1], abs(d__2))) {
		imax = i__;
	    }
	}
	if ((d__1 = a[imax + k * a_dim1], abs(d__1)) < const_1.eps) {
	    ret_val = -1;
	    return ret_val;
	}
	if (imax != k) {
	    i__2 = *n;
	    for (j = 1; j <= i__2; ++j) {
		swap_(&a[imax + j * a_dim1], &a[k + j * a_dim1]);
	    }
	}
	p[k] = imax;
	i__2 = *n;
	for (i__ = k + 1; i__ <= i__2; ++i__) {
	    a[i__ + k * a_dim1] /= a[k + k * a_dim1];
	    i__3 = *n;
	    for (j = k + 1; j <= i__3; ++j) {
		a[i__ + j * a_dim1] -= a[k + j * a_dim1] * a[i__ + k * a_dim1]
			;
	    }
	}
    }
    ret_val = 0;
    return ret_val;
} /* lurow_ */

integer ssrow_(integer *n, integer *lda, doublereal *a, integer *p, 
	doublereal *b)
{
    /* System generated locals */
    integer a_dim1, a_offset, ret_val, i__1, i__2;
    doublereal d__1;

    /* Local variables */
    static integer i__, k;
    extern /* Subroutine */ int swap_(doublereal *, doublereal *);

/*   SCALAR ARGUMENTS */
/*   ARRAY ARGUMENTS */
/*   GLOBAL SCALARS */
/*   LOCAL SCALARS */
    /* Parameter adjustments */
    --b;
    --p;
    a_dim1 = *lda;
    a_offset = 1 + a_dim1;
    a -= a_offset;

    /* Function Body */
    i__1 = *n;
    for (i__ = 1; i__ <= i__1; ++i__) {
	if (p[i__] != i__) {
	    swap_(&b[p[i__]], &b[i__]);
	}
    }
    i__1 = *n;
    for (i__ = 1; i__ <= i__1; ++i__) {
	i__2 = i__ - 1;
	for (k = 1; k <= i__2; ++k) {
	    b[i__] -= b[k] * a[i__ + k * a_dim1];
	}
    }
    for (i__ = *n; i__ >= 1; --i__) {
	i__1 = i__ + 1;
	for (k = *n; k >= i__1; --k) {
	    b[i__] -= b[k] * a[i__ + k * a_dim1];
	}
	if ((d__1 = a[i__ + i__ * a_dim1], abs(d__1)) < const_1.eps) {
	    ret_val = -1;
	    return ret_val;
	}
	b[i__] /= a[i__ + i__ * a_dim1];
    }
    ret_val = 0;
    return ret_val;
} /* ssrow_ */

integer lucol_(integer *n, integer *lda, doublereal *a, integer *p)
{
    /* System generated locals */
    integer a_dim1, a_offset, ret_val, i__1, i__2, i__3;
    doublereal d__1, d__2;

    /* Local variables */
    static integer i__, j, k, imax;
    extern /* Subroutine */ int swap_(doublereal *, doublereal *);

/*   SCALAR ARGUMENTS */
/*   ARRAY ARGUMENTS */
/*   GLOBAL SCALARS */
/*   LOCAL SCALARS */
    /* Parameter adjustments */
    --p;
    a_dim1 = *lda;
    a_offset = 1 + a_dim1;
    a -= a_offset;

    /* Function Body */
    i__1 = *n;
    for (k = 1; k <= i__1; ++k) {
	imax = k;
	i__2 = *n;
	for (i__ = k + 1; i__ <= i__2; ++i__) {
	    if ((d__1 = a[i__ + k * a_dim1], abs(d__1)) > (d__2 = a[imax + k *
		     a_dim1], abs(d__2))) {
		imax = i__;
	    }
	}
	if ((d__1 = a[imax + k * a_dim1], abs(d__1)) < const_1.eps) {
	    ret_val = -1;
	    return ret_val;
	}
	if (imax != k) {
	    i__2 = *n;
	    for (j = 1; j <= i__2; ++j) {
		swap_(&a[imax + j * a_dim1], &a[k + j * a_dim1]);
	    }
	}
	p[k] = imax;
	i__2 = *n;
	for (i__ = k + 1; i__ <= i__2; ++i__) {
	    a[i__ + k * a_dim1] /= a[k + k * a_dim1];
	}
	i__2 = *n;
	for (j = k + 1; j <= i__2; ++j) {
	    i__3 = *n;
	    for (i__ = k + 1; i__ <= i__3; ++i__) {
		a[i__ + j * a_dim1] -= a[k + j * a_dim1] * a[i__ + k * a_dim1]
			;
	    }
	}
    }
    ret_val = 0;
    return ret_val;
} /* lucol_ */

integer sscol_(integer *n, integer *lda, doublereal *a, integer *p, 
	doublereal *b)
{
    /* System generated locals */
    integer a_dim1, a_offset, ret_val, i__1, i__2;
    doublereal d__1;

    /* Local variables */
    static integer i__, k;
    extern /* Subroutine */ int swap_(doublereal *, doublereal *);

/*   SCALAR ARGUMENTS */
/*   ARRAY ARGUMENTS */
/*   GLOBAL SCALARS */
/*   LOCAL SCALARS */
    /* Parameter adjustments */
    --b;
    --p;
    a_dim1 = *lda;
    a_offset = 1 + a_dim1;
    a -= a_offset;

    /* Function Body */
    i__1 = *n;
    for (i__ = 1; i__ <= i__1; ++i__) {
	if (p[i__] != i__) {
	    swap_(&b[p[i__]], &b[i__]);
	}
    }
    i__1 = *n;
    for (k = 1; k <= i__1; ++k) {
	i__2 = *n;
	for (i__ = k + 1; i__ <= i__2; ++i__) {
	    b[i__] -= b[k] * a[i__ + k * a_dim1];
	}
    }
    for (k = *n; k >= 1; --k) {
	if ((d__1 = a[k + k * a_dim1], abs(d__1)) < const_1.eps) {
	    ret_val = -1;
	    return ret_val;
	}
	b[k] /= a[k + k * a_dim1];
	for (i__ = k - 1; i__ >= 1; --i__) {
	    b[i__] -= b[k] * a[i__ + k * a_dim1];
	}
    }
    ret_val = 0;
    return ret_val;
} /* sscol_ */

/* Subroutine */ int printmatrix_(doublereal *a, integer *n)
{
    /* System generated locals */
    integer i__1, i__2;

    /* Builtin functions */
    integer s_wsfe(cilist *), do_fio(integer *, char *, ftnlen), e_wsfe(void),
	     s_wsle(cilist *), do_lio(integer *, integer *, char *, ftnlen), 
	    e_wsle(void);

    /* Local variables */
    static integer i__, j;

    /* Fortran I/O blocks */
    static cilist io___31 = { 0, 6, 0, "(f7.3$)", 0 };
    static cilist io___32 = { 0, 6, 0, 0, 0 };


    /* Parameter adjustments */
    a -= 1001;

    /* Function Body */
    i__1 = *n;
    for (i__ = 1; i__ <= i__1; ++i__) {
	i__2 = *n;
	for (j = 1; j <= i__2; ++j) {
	    s_wsfe(&io___31);
	    do_fio(&c__1, (char *)&a[i__ + j * 1000], (ftnlen)sizeof(
		    doublereal));
	    e_wsfe();
	}
	s_wsle(&io___32);
	do_lio(&c__9, &c__1, "", (ftnlen)0);
	e_wsle();
    }
    return 0;
} /* printmatrix_ */

/* Subroutine */ int printdvector_(doublereal *v, integer *n)
{
    /* System generated locals */
    integer i__1;

    /* Builtin functions */
    integer s_wsfe(cilist *), do_fio(integer *, char *, ftnlen), e_wsfe(void);

    /* Local variables */
    static integer i__;

    /* Fortran I/O blocks */
    static cilist io___34 = { 0, 6, 0, "(f7.3$)", 0 };


    /* Parameter adjustments */
    --v;

    /* Function Body */
    i__1 = *n;
    for (i__ = 1; i__ <= i__1; ++i__) {
	s_wsfe(&io___34);
	do_fio(&c__1, (char *)&v[i__], (ftnlen)sizeof(doublereal));
	e_wsfe();
    }
    return 0;
} /* printdvector_ */

/* Subroutine */ int printivector_(integer *v, integer *n)
{
    /* System generated locals */
    integer i__1;

    /* Builtin functions */
    integer s_wsfe(cilist *), do_fio(integer *, char *, ftnlen), e_wsfe(void);

    /* Local variables */
    static integer i__;

    /* Fortran I/O blocks */
    static cilist io___36 = { 0, 6, 0, "(i3)", 0 };


    /* Parameter adjustments */
    --v;

    /* Function Body */
    i__1 = *n;
    for (i__ = 1; i__ <= i__1; ++i__) {
	s_wsfe(&io___36);
	do_fio(&c__1, (char *)&v[i__], (ftnlen)sizeof(integer));
	e_wsfe();
    }
    return 0;
} /* printivector_ */

/* Subroutine */ int swap_(doublereal *a, doublereal *b)
{
    static doublereal temp;

    temp = *a;
    *a = *b;
    *b = temp;
    return 0;
} /* swap_ */

/* Subroutine */ int readmatrix_(doublereal *a, doublereal *b, integer *lda, 
	integer *n)
{
    /* System generated locals */
    integer a_dim1, a_offset, i__1;

    /* Builtin functions */
    integer s_rsle(cilist *), do_lio(integer *, integer *, char *, ftnlen), 
	    e_rsle(void);

    /* Local variables */
    static integer i__, j, k, nsquare;

    /* Fortran I/O blocks */
    static cilist io___38 = { 0, 5, 0, 0, 0 };
    static cilist io___41 = { 0, 5, 0, 0, 0 };
    static cilist io___44 = { 0, 5, 0, 0, 0 };


/*   SCALAR ARGUMENTS */
/*   ARRAY ARGUMENTS */
/*   LOCAL SCALARS */
    /* Parameter adjustments */
    --b;
    a_dim1 = *lda;
    a_offset = 1 + a_dim1;
    a -= a_offset;

    /* Function Body */
    s_rsle(&io___38);
    do_lio(&c__3, &c__1, (char *)&(*n), (ftnlen)sizeof(integer));
    e_rsle();
/* Computing 2nd power */
    i__1 = *n;
    nsquare = i__1 * i__1;
    i__1 = nsquare;
    for (k = 1; k <= i__1; ++k) {
	s_rsle(&io___41);
	do_lio(&c__3, &c__1, (char *)&i__, (ftnlen)sizeof(integer));
	do_lio(&c__3, &c__1, (char *)&j, (ftnlen)sizeof(integer));
	do_lio(&c__5, &c__1, (char *)&a[i__ + 1 + (j + 1) * a_dim1], (ftnlen)
		sizeof(doublereal));
	e_rsle();
    }
    i__1 = *n;
    for (k = 1; k <= i__1; ++k) {
	s_rsle(&io___44);
	do_lio(&c__3, &c__1, (char *)&i__, (ftnlen)sizeof(integer));
	do_lio(&c__5, &c__1, (char *)&b[i__ + 1], (ftnlen)sizeof(doublereal));
	e_rsle();
    }
    return 0;
} /* readmatrix_ */

/* Main program alias */ int lu_solver__ () { MAIN__ (); return 0; }
