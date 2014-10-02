       program lu_solver
           implicit none
           integer lurow, ssrow, lucol, sscol
       
           double precision eps
           integer NMAX
           parameter(NMAX = 1000)
           common /const/ eps

           double precision A(NMAX, NMAX)
           double precision b(NMAX)
           integer p(NMAX)
           integer res, n
           integer lda
           character*100 arg

           call GETARG(1, arg)
           print *, "arg: ", arg



           lda = NMAX
       
           eps = 1e-16
           call readMatrix(A, b, lda, n)   
           res = lurow(n, lda, A, p) 
           if (res == 0) then
               res = ssrow(n, lda, A, p, b)
               if (res == 0) then
                   call printdVector(b, n)
               else
                   print *, "CAGOU"
               end if
           else
               print *, "CAGOU1"
           end if
       end
       
       integer function lurow(n, lda, A, p)
           implicit none
c   SCALAR ARGUMENTS
           integer n, lda
c   ARRAY ARGUMENTS
           integer p(n)
           double precision A(lda, n)
c   GLOBAL SCALARS
           double precision eps
           common /const/ eps
c   LOCAL SCALARS       
           integer k, i, j, imax
       
           do k = 1, n
               imax = k
               do i = k + 1, n
                   if (abs(A(i, k)) > abs(A(imax, k))) imax = i
               end do
       
               if (abs(A(imax,k)) < eps) then
                   lurow = -1 
                   return
               end if
           
               if (imax /= k) then
                   do j = 1, n
                       call swap(A(imax, j), A(k, j))
                   end do
               end if
               p(k) = imax
       
               do i = k + 1, n
                   A(i, k) = A(i,k) / A(k, k)
                   do j = k + 1, n
                       A(i, j) = A(i, j) - A(k, j) * A(i, k)
                   end do
               end do
           end do
           lurow = 0
       end
       
       integer function ssrow(n, lda, A, p, b)
           implicit none
c   SCALAR ARGUMENTS
           integer n, lda
c   ARRAY ARGUMENTS
           integer p(n)
           double precision A(lda, n)
           double precision b(n)
c   GLOBAL SCALARS
           double precision eps
           common /const/ eps
c   LOCAL SCALARS
           integer k, i
       
           do i = 1, n
               if (p(i) /= i) call swap(b(p(i)), b(i))
           end do
       
           do i = 1, n
               do k = 1, i - 1
                   b(i) = b(i) - b(k) * A(i, k)
               end do
           end do
       
           do i = n, 1, -1
               do k = n, i + 1, -1
                   b(i) = b(i) - b(k) * A(i, k)
               end do
               if (abs(A(i,i)) < eps) then
                   ssrow = -1
                   return
               end if
               b(i) = b(i) / A(i, i)
           end do
           ssrow = 0
       end
       
       integer function lucol(n, lda, A, p)
           implicit none
c   SCALAR ARGUMENTS
           integer n, lda
c   ARRAY ARGUMENTS
           integer p(n)
           double precision A(lda, n)
c   GLOBAL SCALARS
           double precision eps
           common /const/ eps
c   LOCAL SCALARS       
           integer k, i, j, imax
           do k = 1, n
               imax = k
               do i = k + 1, n
                   if (abs(A(i, k)) > abs(A(imax, k))) imax = i
               end do
               
               if (abs(A(imax, k)) < eps) then
                   lucol = -1
                   return
               end if
       
               if (imax /= k) then
                   do j = 1, n
                       call swap(A(imax, j), A(k, j))
                   end do
               end if
               p(k) = imax
       
               do i = k + 1, n
                   A(i, k) = A(i, k) / A(k, k)
               end do
       
               do j = k + 1, n
                   do i = k + 1, n
                       A(i, j) = A(i, j) - A(k, j) * A(i, k)
                   end do
               end do
           end do
           lucol = 0
       end
       
       integer function sscol(n, lda, A, p, b)
           implicit none
c   SCALAR ARGUMENTS
           integer n, lda
c   ARRAY ARGUMENTS
           integer p(n)
           double precision A(lda, n)
           double precision b(n)
c   GLOBAL SCALARS
           double precision eps
           common /const/ eps
c   LOCAL SCALARS
           integer k, i
       
           do i = 1, n
               if (p(i) /= i) call swap(b(p(i)), b(i))
           end do
       
           do k = 1, n
               do i = k + 1, n
                   b(i) = b(i) - b(k) * A(i, k)
               end do
           end do
           
           do k = n, 1, -1
               if (abs(A(k, k)) < eps) then
                   sscol = -1
                   return
               end if
               b(k) = b(k) / A(k, k)
               do i = k - 1, 1, -1
                   b(i) = b(i) - b(k) * A(i, k)
               end do
           end do
           sscol = 0
       end
       
       
       subroutine printMatrix(A, n)
           implicit none
           integer NMAX
           parameter (NMAX = 1000)
 
           integer n
           double precision A(NMAX, n)
       
           integer i, j
       
           do i = 1, n
               do j = 1, n
                   print "(f7.3$)", A(i, j)
               end do
               print *,""
           end do
       end
       
       subroutine printdVector(v, n)
           implicit none

           integer n
           double precision v(n)
           integer i
           do i = 1, n
               print "(f7.3$)", v(i)
           end do
       end
       
       subroutine printiVector(v, n)
           implicit none

           integer n
           integer v(n)
           integer i
           do i = 1, n
               print "(i3)", v(i)
           end do
       end
       
       
       subroutine swap(a, b)
           implicit none
           double precision a, b
           double precision temp
       
           temp = a
           a = b
           b = temp
       end
       
       subroutine readMatrix(A, b, lda, n)
           implicit none
c   SCALAR ARGUMENTS
           integer n, lda
c   ARRAY ARGUMENTS
           double precision A(lda, n)
           double precision b(n)
c   LOCAL SCALARS
           integer i, j, k
           integer nsquare

           read *, n
           nsquare = n ** 2
           do k = 1, nsquare
               read *, i, j, A(i + 1, j + 1)
           end do
           do k = 1, n
               read *, i, b(i + 1)
           end do
       end
