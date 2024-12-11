program advent_of_code_2024
   implicit none
   integer(kind=8), parameter :: max_length = 256
   character(len=max_length) :: line
   integer(kind=4) :: number
   integer :: i, num_parsed_values, ios
   integer, parameter :: max_initial_values = 64
   integer(kind=8), dimension(max_initial_values) :: parsed_values

   ! Declare arrays for dictionary
   integer, parameter :: max_cache_items = 107374182
   integer(kind=8), dimension(max_cache_items) :: base_dict_keys   ! Store keys
   integer(kind=8), dimension(max_cache_items) :: base_dict_vals   ! Store corresponding values
   integer :: base_dict_size = 0  ! Initialize dictionary size

   open(unit=10, file="input.txt", status="old", action="read")

   read(10, '(A)', iostat=ios) line
   if (ios /= 0) then
      print *, "Error reading file!"
      stop
   end if

   num_parsed_values = 0
   do while (len_trim(line) > 0)
      read(line, *, iostat=ios) number
      if (ios /= 0) then
         print *, "Error reading a number!"
         exit
      end if
      num_parsed_values = num_parsed_values + 1
      if (num_parsed_values > max_initial_values) then
         print *, "Exceeded max_initial_values!"
         stop
      end if
      parsed_values(num_parsed_values) = number

      i = index(line, " ")
      if (i == 0) exit
      line = adjustl(line(i+1:))
   end do

   call part_one( &
      parsed_values, &
      num_parsed_values, &
      base_dict_keys, &
      base_dict_vals, &
      base_dict_size &
      )
   call part_two( &
      parsed_values, &
      num_parsed_values, &
      base_dict_keys, &
      base_dict_vals, &
      base_dict_size &
      )

   close(10)

contains

   subroutine part_one(values, num_items, dict_keys, dict_vals, dict_size)
      integer(kind=8), dimension(:), intent(in) :: values
      integer, intent(in) :: num_items
      integer(kind=8), dimension(:), intent(inout) :: dict_keys
      integer(kind=8), dimension(:), intent(inout) :: dict_vals
      integer, intent(inout) :: dict_size

      write(*,*) CHAR(10) // "Part one:"
      call count_stones(values, num_items, 25, dict_keys, dict_vals, dict_size)
   end subroutine part_one

   subroutine part_two(values, num_items, dict_keys, dict_vals, dict_size)
      integer(kind=8), dimension(:), intent(in) :: values
      integer, intent(in) :: num_items
      integer(kind=8), dimension(:), intent(inout) :: dict_keys
      integer(kind=8), dimension(:), intent(inout) :: dict_vals
      integer, intent(inout) :: dict_size

      write(*,*) CHAR(10) // "Part two:"
      call count_stones(values, num_items, 75, dict_keys, dict_vals, dict_size)
   end subroutine part_two

   subroutine count_stones(values, num_items, depth, dict_keys, dict_vals, dict_size)
      integer(kind=8), dimension(:), intent(in) :: values
      integer, intent(in) :: num_items, depth
      integer(kind=8), dimension(:), intent(inout) :: dict_keys
      integer(kind=8), dimension(:), intent(inout) :: dict_vals
      integer, intent(inout) :: dict_size
      integer(kind=8) :: count, num_stones
      real :: start_time, end_time, elapsed_time
      integer :: j

      call cpu_time(start_time)

      count = 0
      do j = 1, num_items
         num_stones = blink(values(j), depth, dict_keys, dict_vals, dict_size)
         count = count + num_stones
      end do

      call cpu_time(end_time)

      elapsed_time = end_time - start_time

      write(*,*) CHAR(9) // "Final count after processing all values: ", count
      if (elapsed_time < 1) then
         write(*,*) CHAR(9) // "Elapsed time for processing: ", elapsed_time * 1000, " milliseconds" // CHAR(10)
      else
         write(*,*) CHAR(9) // "Elapsed time for processing: ", elapsed_time, " seconds" // CHAR(10)
      end if
   end subroutine count_stones

   recursive function blink(value, depth, dict_keys, dict_vals, dict_size) result(res)
      integer(kind=8), intent(in) :: value
      integer, intent(in) :: depth
      integer(kind=8), dimension(:), intent(inout) :: dict_keys
      integer(kind=8), dimension(:), intent(inout) :: dict_vals
      integer, intent(inout) :: dict_size
      integer(kind=8) :: res
      integer(kind=8) :: left, right, unique_key
      integer :: num_digits, dict_index

      ! Base case: depth <= 0
      if (depth <= 0) then
         res = 1_8
         return
      end if

      ! Compute a unique key combining value and depth
      unique_key = value * 100_8 + depth

      ! Check if unique_key is already in dictionary
      do dict_index = 1, dict_size
         if (dict_keys(dict_index) == unique_key) then
            res = dict_vals(dict_index)
            return
         end if
      end do

      ! Key not found, proceed with recursion
      if (value == 0) then
         res = blink(1_8, depth - 1, dict_keys, dict_vals, dict_size)
      else
         num_digits = get_num_digits(value)
         if (mod(num_digits, 2) == 0) then
            call split_stone(value, num_digits, left, right)
            res = blink(left, depth - 1, dict_keys, dict_vals, dict_size) + &
               blink(right, depth - 1, dict_keys, dict_vals, dict_size)
         else
            res = blink(value * 2024, depth - 1, dict_keys, dict_vals, dict_size)
         end if
      end if

      ! Add the result to the dictionary
      if (dict_size < size(dict_keys)) then
         dict_size = dict_size + 1
         dict_keys(dict_size) = unique_key
         dict_vals(dict_size) = res
      end if
   end function blink



   function get_num_digits(value) result(num_digits)
      integer(kind=8), intent(in) :: value
      integer :: num_digits

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

      if (mod(num_digits, 2) /= 0) then
         print *, "Error: num_digits must be even!"
         stop
      end if

      divisor = 10**(num_digits / 2)
      res_left = value / divisor
      res_right = mod(value, divisor)

   end subroutine split_stone

end program advent_of_code_2024
