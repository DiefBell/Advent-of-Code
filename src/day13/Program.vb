Imports System

Namespace AdventOfCode

Module Program
    Sub Main()
        ' File path
        Dim filePath As String = "input.sample.txt"
        ' Dim filePath As String = "input.txt"

        ' Read and parse the games using Game's static method
        Dim games As List(Of Game) = Game.ParseGames(filePath)

        ' Call PartOne to process the games
        PartOne(games)

        ' Call PartTwo to process the games with moved prizes
        PartTwo(games)
    End Sub

    ' Function to process the games and calculate the total minimum cost
	Sub PartOne(games As List(Of Game))
		Console.WriteLine(Environment.NewLine & Environment.NewLine & "===== PART 2 =====")
		' Variable to hold the total minimum cost
		Dim totalMinCost As Double = 0
	
		' Iterate through each game
		For Each game As Game In games
			' Get ILP data from the game
			Dim ilpData = game.GetILPData()
			Dim objectiveFunction As Func(Of Double, Double, Double) = ilpData.Item1
			Dim constraintFunction As Func(Of Double, Double, Boolean) = ilpData.Item2
			Dim maxNA As Double = ilpData.Item3
			Dim maxNB As Double = ilpData.Item4
	
			' Solve the ILP for the current game
			Dim result = ILPSolver.Solve(objectiveFunction, constraintFunction, maxNA, maxNB)
	
			' Check if both items in the result tuple are non-zero
			If result.Item1 <> 0 AndAlso result.Item2 <> 0 Then
				' Store the cost for the game
				Dim gameCost As Double = result.Item1 * game.ButtonA.Value + result.Item2 * game.ButtonB.Value
				game.SetCostOne(gameCost) ' Set the cost if solvable
	
				' Add the cost of the current game to the total minimum cost
				totalMinCost += gameCost
				Console.WriteLine(Environment.NewLine & $"Target solvable for game: {game}")
			Else
				' Mark the game as unsolvable by setting the cost to -1
				game.SetCostOne(-1)
				Console.WriteLine(Environment.NewLine & $"Target not solvable for game: {game}")
			End If
		Next
	
		' Output the total minimum cost
		Console.WriteLine(Environment.NewLine & $"Total minimum cost across all games: {totalMinCost}")
	End Sub

	Sub PartTwo(games As List(Of Game))
		Console.WriteLine(Environment.NewLine & Environment.NewLine & "===== PART 2 =====")
	
		' Variable to hold the total minimum cost
		Dim totalMinCost As Double = 0
	
		' Iterate through each game that is solvable
		For Each game As Game In games
			Dim lp as Integer = LpSolveWrapper.make_lp(0, 0)
		Next
	
		' Output the total minimum cost for Part Two
		Console.WriteLine(Environment.NewLine & $"Total minimum cost across all solvable games (Part Two): {totalMinCost}")
	End Sub
		
		
		

End Module

End Namespace
