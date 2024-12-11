program advent_of_code_2024
   implicit none
   integer(kind=8), parameter :: max_length = 256
   character(len=max_length) :: line
   integer(kind=4) :: number
   integer :: i, num_items, ios, j
   integer, parameter :: max_items = 100
   integer(kind=8), dimension(max_items) :: values
   real :: start_time, end_time, elapsed_time
   integer(kind=8) :: count, num_stones

   open(unit=10, file="input.txt", status="old", action="read")

   read(10, '(A)', iostat=ios) line
   if (ios /= 0) then
      print *, "Error reading file!"
      stop
   end if

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

      i = index(line, " ")
      if (i == 0) exit
      line = adjustl(line(i+1:))
   end do

   call cpu_time(start_time)

   count = 0
   do j = 1, num_items
      num_stones = blink(values(j), 25)
      count = count + num_stones
   end do

   call cpu_time(end_time)

   elapsed_time = end_time - start_time

   write(*,*) CHAR(10) // CHAR(10) // "Final count after processing all values: ", count
   write(*,*) "Elapsed time for processing: ", elapsed_time * 1000, " milliseconds" // CHAR(10) // CHAR(10)

   close(10)

contains

   recursive function blink(value, depth) result(res)
      integer(kind=8), intent(in) :: value
      integer, intent(in) :: depth
      integer(kind=8) :: res
      integer(kind=8) :: left, right
      integer :: num_digits

      ! Recursively processes the value based on its number of digits and depth.
      if (depth <= 0) then
         res = 1_8
      else
         if (value == 0) then
            res = blink(1_8, depth - 1)
         else
            num_digits = get_num_digits(value)
            if (mod(num_digits, 2) == 0) then
               call split_stone(value, num_digits, left, right)
               res = blink(left, depth - 1) + blink(right, depth - 1)
            else
               res = blink(value * 2024, depth - 1)
            end if
         end if
      end if
   end function blink

   function get_num_digits(value) result(num_digits)
      integer(kind=8), intent(in) :: value
      integer :: num_digits

      ! Returns the number of digits in a given value.
      if (value == 0) then
         num_digits = 1
      else
         num_digits = int(log10(real(abs(value)))) + 1
      end if
   end function get_num_digits

   subroutine split_stone(value, num_digits, res_left, res_right)
      integer(kind=8), intent(in) :: value
      integer, intent(in) :: num_digits
      integer(kind=8), intent(out) :: res_left, res_right
      integer(kind=8) :: divisor

      ! Splits the value into two parts based on its number of digits.
      if (mod(num_digits, 2) /= 0) then
         print *, "Error: num_digits must be even!"
         stop
      end if

      divisor = 10**(num_digits / 2)
      res_left = value / divisor
      res_right = mod(value, divisor)

   end subroutine split_stone

end program advent_of_code_2024
