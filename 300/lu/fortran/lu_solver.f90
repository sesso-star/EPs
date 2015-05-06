module constants
    double precision, parameter :: eps = epsilon(0d0)
    integer, parameter :: NMAX = 1000
end module

program lu_solver
    use constants

    implicit none
    integer, external :: lurow, ssrow, lucol, sscol
    integer :: res, i, j

    double precision, dimension(NMAX, NMAX) :: A
    double precision, dimension(NMAX) :: b
    integer, dimension(NMAX) :: p 
    integer :: n = 3
    integer :: lda = 1

    call readMatrix(A, b, n)   
 
    print *, "A before:"
    call printMatrix(A, n)
    print *,"p before:"
    call printiVector(p, n)
    print *,"b before:"
    call printdVector(b, n)

    res = lucol(n, lda, A, p)

    print "(/,a)", "A after:"
    call printMatrix(A, n)
    print *, "p after:"
    call printiVector(p, n)
    print *, "res: ", res

    res = sscol(n, lda, A, p, b)

    print "(/,a)", "A final:"
    call printMatrix(A, n)
    print *, "b final:"
    call printdVector(b, n)
    print *, "res: ", res
    
end program

integer function lurow(n, lda, A, p)
    use constants
    integer, intent(in) :: n, lda
    integer, intent(inout) :: p(NMAX)
    double precision, intent(inout) :: A(lda:NMAX, lda:NMAX)

    integer :: k, i, j, imax

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
end function

integer function ssrow(n, lda, A, p, b)
    use constants
    implicit none
    integer, intent(in) :: n, lda
    integer, intent(inout) :: p(NMAX)
    double precision, intent(inout) :: A(lda:NMAX, lda:NMAX)
    double precision, intent(inout) :: b(lda:NMAX)

    integer :: k, i

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
end function

integer function lucol(n, lda, A, p)
    use constants
    implicit none
    integer, intent(inout) :: n, lda
    integer, intent(inout) :: p(NMAX)
    double precision, intent(inout) :: A(lda:NMAX, lda:NMAX)

    integer :: k, i, j, imax

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
end function

integer function sscol(n, lda, A, p, b)
    use constants
    implicit none
    integer, intent(in) :: n, lda
    integer, intent(inout) :: p(NMAX)
    double precision, intent(inout) :: A(lda:NMAX, lda:NMAX)
    double precision, intent(inout) :: b(lda:NMAX)

    integer :: k, i

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
end function


subroutine printMatrix(A, n)
    use constants
    implicit none
    
    integer, intent(in) :: n
    double precision, intent(in) :: A(NMAX, NMAX)

    integer :: i, j

    do i = 1, n
        do j = 1, n
            print "(f7.3$)", A(i, j)
        end do
        print *,""
    end do
end subroutine

subroutine printdVector(v, n)
    use constants
    implicit none
    integer, intent(in) :: n
    double precision, intent(in) :: v(NMAX)
    integer :: i
    do i = 1, n
        print "(f7.3$)", v(i)
    end do
end subroutine

subroutine printiVector(v, n)
    use constants
    implicit none
    integer, intent(in) :: n
    integer, intent(in) :: v(NMAX)
    integer :: i
    do i = 1, n
        print "(i3)", v(i)
    end do
end subroutine


subroutine swap(a, b)
    implicit none
    double precision, intent(inout) :: a, b
    double precision :: temp

    temp = a
    a = b
    b = temp
end subroutine

subroutine readMatrix(A, b, n)
    use constants
    implicit none
    double precision, dimension(NMAX, NMAX), intent(out) :: A
    double precision, dimension(NMAX), intent(out) :: b
    integer, intent(out) :: n
    integer :: i, j, k
    integer :: nsquare
    read *, n
    nsquare = n ** 2
    do k = 1, nsquare
        read *, i, j, A(i, j)
    end do
    do k = 1, n
        read *, i, b(i)
    end do
end subroutine
