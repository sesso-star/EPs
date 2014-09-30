module constants
    double precision, parameter :: eps = epsilon(0d0)
end module

program lu_solver
    !use constant

    implicit none
    integer, external :: lurow, ssrow, lucol, sscol
    integer :: x, i, j

    double precision, dimension(3, 3) :: A
    double precision, dimension(3) :: b
    integer :: n = 3
    integer :: lda = 1
    integer, dimension(3) :: p, b

    A = reshape((/ 1, 2, 3, 4, 8, 1, 7, 8, 9 /), shape(A))
    b = reshape((/7, 7, 7/), shape(b))
    
    print *, "A before:"
    call printMatrix(A, n)
    print *,"p before:"
    call printVector(p, n)

    x = lucol(n, lda, A, p)

    print "(/,a)", "A after:"
    call printMatrix(A, n)
    print *, "p after:"
    call printVector(p, n)
    print *, "x: ", x

    x = sscol(n, lda, A, p, b)

    print "(/,a)", "A final:"
    call printMatrix(A, n)
    print *, "b final:"
    print *, b
    !call printVector(p, n)
    print *, "x: ", x
    
end program

integer function lurow(n, lda, A, p)
    use constants
    integer, intent(in) :: n, lda
    integer, intent(inout) :: p(n)
    double precision, intent(inout) :: A(lda:n, lda:n)

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
    integer, intent(inout) :: p(n)
    double precision, intent(inout) :: A(lda:n, lda:n)
    double precision, intent(inout) :: b(lda:n)

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
    integer, intent(inout) :: p(n)
    double precision, intent(inout) :: A(lda:n, lda:n)

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
    integer, intent(inout) :: p(n)
    double precision, intent(inout) :: A(lda:n, lda:n)
    double precision, intent(inout) :: b(lda:n)

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
    implicit none
    
    integer, intent(in) :: n
    double precision, intent(in) :: A(n, n)

    integer :: i, j

    do i = 1, n
        do j = 1, n
            print "(f7.3$)", A(i, j)
        end do
        print *,""
    end do
end subroutine

subroutine printVector(v, n)
    implicit none

    integer, intent(in) :: n
    integer, intent(in) :: v(n)

    integer :: i

    do i = 1, n
        print "(i7)", v(i)
    end do
end subroutine

subroutine swap(a, b)
    double precision, intent(inout) :: a, b
    double precision :: temp

    temp = a
    a = b
    b = temp
end subroutine

subroutine readMatrix(A, b)
    double precision, dimension(1000, 1000), intent(out) :: A
    double precision, dimension(1000), intent(out) :: b
    integer, intent(out) :: n
    integer :: i, j
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
