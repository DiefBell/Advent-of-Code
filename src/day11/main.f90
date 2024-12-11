program advent_of_code_2024
    implicit none
    integer, parameter :: max_length = 256
    character(len=max_length) :: line
    integer :: number
    integer :: i, num_items, ios, j
    integer, parameter :: max_items = 100
    integer, dimension(max_items) :: values
  
    ! Open the file
    open(unit=10, file="input.sample.txt", status="old", action="read")
  
    ! Read the single line from the file
    read(10, '(A)', iostat=ios) line
    if (ios /= 0) then
       print *, "Error reading file!"
       stop
    end if
  
    ! Split line into integers
    num_items = 0
    do while (len_trim(line) > 0)
       read(line, *, iostat=ios) number
       if (ios /= 0) then
          print *, "Error reading a number!"
          exit
       end if
       num_items = num_items + 1
       if (num_items > max_items) then
          print *, "Exceeded max_items!"
          stop
       end if
       values(num_items) = number
  
       ! Trim the already processed number
       i = index(line, " ")
       if (i == 0) exit  ! No more spaces, done with the line
       line = adjustl(line(i+1:))
    end do
  
    ! Output the parsed integers
    print *, "Parsed integers from the line:"
    print *, (values(j), j=1, num_items)
  
    close(10)
  end program advent_of_code_2024
  