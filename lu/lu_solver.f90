program lu_solver
    implicit none
    integer, external :: lurow
    integer :: x, i, j

    double precision, dimension(3, 3) :: A
    integer :: n = 3
    integer :: lda = 1
    integer, dimension(3) :: p

    A = reshape((/ 1, 2, 3, 4, 8, 1, 7, 8, 9 /), shape(A))

    !print *, (A(1, i), i=1,3)

    x = lurow(n, lda, A, p)
    
    call printMatrix(A, 3)

end program

integer function lurow(n, lda, A, p)
    integer :: n
    integer :: p(n)
    double precision :: A(lda, n)

    integer :: k, i, j, imax
    real :: temp

    do k = 1, n
        imax = k
        do i = k + 1, n
            if (abs(A(i, k)) > abs(A(imax, k))) imax = i
        end do

        if (abs(A(i,k)) < 1e-16) lurow = -1
    
        if (imax /= k) then
            do j = 1, n
                temp = A(imax, j)
                A(imax, j) = A(k, j)
                A(k, j) = temp
            end do
        end if
        p(k) = imax

        do i = k + 1, n
            A(i, k) = A(i,k) / A(k, k)
            do j = k + 1, n
                A(i, j) = A(i, j) - A(k, j) * A(i, k)
            end do
        end do

        lurow = 0
    end do
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
