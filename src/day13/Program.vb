Imports System

Namespace AdventOfCode

Module Program
    Sub Main()
        ' File path
        Dim filePath As String = "input.sample.txt"
        ' Dim filePath As String = "input.txt"

        ' Read and parse the games using Game's static method
        Dim games As List(Of Game) = Game.ParseGames(filePath)

        ' ' Call PartOne to process the games
        ' PartOne(games)

        ' Call PartTwo to process the games with moved prizes
        PartTwo(games)
    End Sub

    ' ' Function to process the games and calculate the total minimum cost
	' Sub PartOne(games As List(Of Game))
	' 	Console.WriteLine(Environment.NewLine & Environment.NewLine & "===== PART 2 =====")
	' 	' Variable to hold the total minimum cost
	' 	Dim totalMinCost As Double = 0
	
	' 	' Iterate through each game
	' 	For Each game As Game In games
	' 		' Get ILP data from the game
	' 		Dim ilpData = game.GetILPData()
	' 		Dim objectiveFunction As Func(Of Double, Double, Double) = ilpData.Item1
	' 		Dim constraintFunction As Func(Of Double, Double, Boolean) = ilpData.Item2
	' 		Dim maxNA As Double = ilpData.Item3
	' 		Dim maxNB As Double = ilpData.Item4
	
	' 		' Solve the ILP for the current game
	' 		Dim result = ILPSolver.Solve(objectiveFunction, constraintFunction, maxNA, maxNB)
	
	' 		' Check if both items in the result tuple are non-zero
	' 		If result.Item1 <> 0 AndAlso result.Item2 <> 0 Then
	' 			' Store the cost for the game
	' 			Dim gameCost As Double = result.Item1 * game.ButtonA.Value + result.Item2 * game.ButtonB.Value
	' 			game.SetCostOne(gameCost) ' Set the cost if solvable
	
	' 			' Add the cost of the current game to the total minimum cost
	' 			totalMinCost += gameCost
	' 			Console.WriteLine(Environment.NewLine & $"Target solvable for game: {game}")
	' 		Else
	' 			' Mark the game as unsolvable by setting the cost to -1
	' 			game.SetCostOne(-1)
	' 			Console.WriteLine(Environment.NewLine & $"Target not solvable for game: {game}")
	' 		End If
	' 	Next
	
	' 	' Output the total minimum cost
	' 	Console.WriteLine(Environment.NewLine & $"Total minimum cost across all games: {totalMinCost}")
	' End Sub

	Sub PartTwo(games As List(Of Game))
		Console.WriteLine(Environment.NewLine & Environment.NewLine & "===== PART 2 =====")
		
		' Variable to hold the total minimum cost
		Dim totalMinCost As Double = 0
	
		' Iterate through each game that is solvable
		For Each game As Game In games
			' Create the full constraint coefficients array (2D array)
			Dim xConstraintRow() As Double = {game.ButtonA.Direction.X, game.ButtonB.Direction.X}
			Dim yConstraintRow() As Double = {game.ButtonA.Direction.Y, game.ButtonB.Direction.Y}
			Dim constraintCoefficients()() As Double = {
				xConstraintRow, ' First constraint (coefficients of X in the first constraint)
				yConstraintRow  ' Second constraint (coefficients of Y in the second constraint)
			}
	
			' The constraint constants (right-hand side of the constraints)
			' Assuming the constraints are in the form: ax + by = constant
			Dim constraintConstants() As Double = {game.Prize.X, game.Prize.Y}
	
			' The objective function (values associated with ButtonA and ButtonB)
			Dim objFunctionRow() As Double = {game.ButtonA.value, game.ButtonB.value}
	
			' Call the Simplex method to solve the LP
			Dim solution() As Double = SimplexMethod.SolveLinearProgramming(objFunctionRow, constraintCoefficients, constraintConstants)
	
			' Output the solution (values of the decision variables)
			Console.WriteLine("Optimal solution:")
			For variableIndex As Integer = 0 To solution.Length - 1
				Console.WriteLine("x" & (variableIndex + 1) & " = " & solution(variableIndex))
        	Next

			' Calculate the final cost (objective function value at the optimal point)
			Dim finalCost As Double = 0
			For i As Integer = 0 To solution.Length - 1
				finalCost += objFunctionRow(i) * solution(i)  ' c1*x1 + c2*x2 (maximize c1*x1 + c2*x2)
			Next
			Console.WriteLine("Final cost (objective value): " & finalCost)
		

			

			' ' Create the LP model with 2 rows (constraints) and 2 columns (variables)
			' Dim lp As Integer = LpSolveWrapper.make_lp(2, 2)

	
			' ' Ensure the LP was successfully created
			' If lp = 0 Then
			' 	Console.WriteLine("Error: Unable to create LP model")
			' 	Return
			' Else
			' 	Console.WriteLine($"LP: {lp}")
			' End If

			' Try
			' 	Console.WriteLine("Setting RowMode")
			' 	LpSolveWrapper.set_add_rowmode(lp, true)
			' Catch ex As Exception
			' 	Console.WriteLine("Error setting RowMode")
			' End Try
			
			' ' Log before adding x-direction constraint
			' Try
			' 	' Set up the x-direction constraint
			' 	Dim row() As Double = { Nothing, game.ButtonA.Direction.X, game.ButtonB.Direction.X }
			' 	Dim targetX As Double = game.Prize.X

			' 	' Add the x-direction constraint (equality)
			' 	Console.WriteLine($"Adding x-direction constraint: ButtonA.X = {game.ButtonA.Direction.X}, ButtonB.X = {game.ButtonB.Direction.X}, TargetX = {targetX}")
			' 	LpSolveWrapper.add_constraint(lp, row, 3, targetX)
			' Catch ex As Exception
			' 	Console.WriteLine($"Error adding x direction constraint: {ex.Message}")
			' End Try
	
			' ' Set up the y-direction constraint
			' Try
			' 	Dim row() As Double = { Nothing, game.ButtonA.Direction.Y, game.ButtonB.Direction.Y }
			' 	Dim targetY As Double = game.Prize.Y
				
			' 	' Add the y-direction constraint (equality)
			' 	Console.WriteLine($"Adding y-direction constraint: ButtonA.Y = {game.ButtonA.Direction.Y}, ButtonB.Y = {game.ButtonB.Direction.Y}, TargetY = {targetY}")
			' 	LpSolveWrapper.add_constraint(lp, row, 3, targetY)
			' Catch ex As Exception
			' 	Console.WriteLine($"Error adding y direction constraint: {ex.Message}")
			' End Try
			
			' Try
			' 	Dim objRow() As Double = { Nothing, game.ButtonA.Value, game.ButtonB.Value}

			' 	' Set the objective function using set_obj_fn
			' 	Console.WriteLine($"Setting objective function: ButtonA.Value = {game.ButtonA.Value}, ButtonB.Value = {game.ButtonB.Value}")
			' 	LpSolveWrapper.set_obj_fn(lp, objRow)
			' Catch ex As Exception
			' 	Console.WriteLine($"Error setting objective function: {ex.Message}")
			' End Try
	
			' ' Now solve the LP model
			' Try
			' 	' Log before solving the LP
			' 	Console.WriteLine("Solving the LP model...")
			' 	LpSolveWrapper.solve(lp)
			' 	Console.WriteLine("Solved!")
			' Catch ex As Exception
			' 	Console.WriteLine($"Error solving LP: {ex.Message}")
			' End Try
		Next
	
		' Output the total minimum cost for Part Two
		Console.WriteLine(Environment.NewLine & $"Total minimum cost across all solvable games (Part Two): {totalMinCost}")
	End Sub
End Module

End Namespace
