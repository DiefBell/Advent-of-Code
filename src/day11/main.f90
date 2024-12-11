program advent_of_code_2024
   implicit none
   integer, parameter :: max_length = 256
   character(len=max_length) :: line
   integer :: number
   integer :: i, num_items, ios, j, count, depth_result
   integer, parameter :: max_items = 100
   integer, dimension(max_items) :: values
   real :: start_time, end_time, elapsed_time

   ! Open the file
   open(unit=10, file="input.txt", status="old", action="read")
   ! open(unit=10, file="input.sample.txt", status="old", action="read")

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

   ! Start the timer before processing integers with blink
   call cpu_time(start_time)

   ! Process each integer with blink and accumulate results
   count = 0
   do j = 1, num_items
      depth_result = blink(values(j), 25)  ! Using depth 25 as specified
      count = count + depth_result
   end do

   ! Stop the timer after processing
   call cpu_time(end_time)

   ! Calculate elapsed time
   elapsed_time = end_time - start_time

   ! Log the final count and elapsed time
   write(*,*) CHAR(10) // CHAR(10) // "Final count after processing all values: ", count
   write(*,*) "Elapsed time for processing: ", elapsed_time * 1000, " milliseconds" // CHAR(10) // CHAR(10)

   close(10)

contains

   recursive function blink(value, depth) result(res)
      integer, intent(in) :: value, depth
      integer :: res
      integer :: num_digits, left, right

      if (depth <= 0) then
         res = 1
      else
         if (value == 0) then
            res = blink(1, depth - 1)  ! Recursive call with value set to 0 and reduced depth
         else
            ! Get the number of digits in the value
            num_digits = get_num_digits(value)

            ! Check if the number of digits is even
            if (mod(num_digits, 2) == 0) then
               ! Call split_stone to get left and right parts
               call split_stone(value, num_digits, left, right)
               res = blink(left, depth - 1) + blink(right, depth - 1)
            else
               res = blink(value * 2024, depth - 1)
            end if
         end if
      end if
   end function blink

   function get_num_digits(value) result(num_digits)
      integer, intent(in) :: value
      integer :: num_digits

      ! Handle value 0 separately as log10(0) is undefined
      if (value == 0) then
         num_digits = 1
      else
         num_digits = int(log10(real(abs(value)))) + 1
      end if
   end function get_num_digits

   subroutine split_stone(value, num_digits, res_left, res_right)
      integer, intent(in) :: value, num_digits
      integer, intent(out) :: res_left, res_right
      integer :: divisor

      ! Check if num_digits is even
      if (mod(num_digits, 2) /= 0) then
         print *, "Error: num_digits must be even!"
         stop
      end if

      ! write(*,*) CHAR(9) // "Splitting '", value, "' with '", num_digits, "' digits."

      ! Create divisor as 10^num_digits
      divisor = 10**(num_digits / 2)

      ! write(*,*) CHAR(9) // "Divisor: '", divisor, "'."

      ! Integer division for res_value
      res_left = value / divisor

      ! Modulo operation for res_digits
      res_right = mod(value, divisor)

      ! write(*,*) CHAR(9) // "Split '", value, "' into '", res_left, "' and '", res_right, "'." // CHAR(10)

   end subroutine split_stone

end program advent_of_code_2024
