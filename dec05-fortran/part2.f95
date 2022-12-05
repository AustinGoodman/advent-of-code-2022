program hello
	implicit none
	
	!num lines and max line size in input.txt
	integer, parameter :: stackCount = 9
	integer, parameter :: lineCount = 512
	integer, parameter :: maxLineLength = 48

	!reusable variables
	integer :: i
	integer :: i0
	integer :: j
	integer :: j0
	integer :: k
	integer :: k0
	character :: char
	character(len = maxLineLength) :: lineSTR
	character(len = 1):: stackSlice(9)
	
	!input lines
	character(len=maxLineLength), Allocatable :: strArray(:)

	!stacks
	character(len = 1):: stacks(stackCount, 50)
	integer :: stackCounters(stackCount)

	!moves
	integer :: moveCount = 0
	integer :: moves(1000, 3)


	!part 1 vars
	integer :: move_amount
	integer :: move_from
	integer :: move_to


	!allocate arrays
	allocate(strArray(lineCount))



	!open the file
	open(1, file = "./input.txt", form = "FORMATTED" )

	!for each line in the file, add the line to strArray
	do i = 1,lineCount  
		read(1, "(a)") lineSTR
		strArray(i) = lineSTR
		
		!print *, strArray(i)	
	end do 

	!loop through each line to get the moves
	do i = 1, lineCount
		lineSTR = strArray(i)

		!if the line details a movement
		if(lineSTR(1:4) == "move") then 
			!start at index 6 which contains the first number
			j = 6
			j0 = j
			
			!keep incrementing until we have white space to read the number
			do while (lineSTR(j:j) /= "")
				j = j + 1
			end do
			read (unit=lineSTR(j0:j),fmt=*) moves(moveCount + 1, 1) 

			!then add six to the index to get to the second number
			j = j + 6
			j0 = j

			!keep incrementing until we have white space to read the number
			do while (lineSTR(j:j) /= "")
				j = j + 1
			end do
			read (unit=lineSTR(j0:j),fmt=*) moves(moveCount + 1, 2) 

			!then add 4 to get to the to third number
			j = j + 4
			j0 = j

			!keep incrementing until we have white space to read the number
			do while (lineSTR(j:j) /= "")
				j = j + 1
			end do
			read (unit=lineSTR(j0:j),fmt=*) moves(moveCount + 1, 3) 

			!increment the move count
			moveCount = moveCount + 1
		end if

	end do 

	!get the stack values
	do i = 0, 8
		k = 1
		
		do j = 1, lineCount
			lineSTR = strArray(j)

			if(lineSTR(1:4) == "move") then 
			else if(lineSTR(1:2) == " 1") then 
			else if(lineSTR == "") then 
			else
				char = lineSTR(2 + i*4:2 + i*4)
				
				if(char /= "") then
					stacks(i + 1, k) = char
					stackCounters(i + 1) = k
					k = k + 1
				end if
			end if
		end do 
	end do

	!apply the moves
	do i = 1, moveCount
		move_amount = moves(i, 1)
		move_from = moves(i, 2)
		move_to = moves(i, 3)

		!shift destination stack up
		do j = 1, stackCounters(move_to)
			stacks(move_to, stackCounters(move_to) - j + 1 + move_amount) = stacks(move_to, stackCounters(move_to) - j + 1)
		end do
		stackCounters(move_to) = stackCounters(move_to) + move_amount

		!copy to destination stack
		do j = 1, move_amount
			stacks(move_to, j) = stacks(move_from, j)
		end do

		!shift destination stack down
		do j = 1, stackCounters(move_from) - move_amount
			stacks(move_from, j) = stacks(move_from, j + move_amount)
		end do
		stackCounters(move_from) = stackCounters(move_from) - move_amount
		
	end do

	!print the stacks
	do i = 1, 9
		do j = 1, stackCounters(i)
			write(*, "(a)", advance="no") stacks(i, j)
		end do
		write(*, *) 
	end do

	!close the file
	close(1) 

end program hello
