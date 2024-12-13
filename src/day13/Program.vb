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
				game.SetCost(gameCost) ' Set the cost if solvable
	
				' Add the cost of the current game to the total minimum cost
				totalMinCost += gameCost
			Else
				' Mark the game as unsolvable by setting the cost to -1
				game.SetCost(-1)
			End If
		Next
	
		' Output the total minimum cost
		Console.WriteLine($"Total minimum cost across all games: {totalMinCost}")
	End Sub

    ' Function to process the games with moved prize and calculate the total minimum cost
    Sub PartTwo(games As List(Of Game))
        ' ' Variable to hold the total minimum cost
        ' Dim totalMinCost As Double = 0

        ' ' Iterate through each game
        ' For Each game As Game In games
        '     ' Call MovePrize before processing the game
        '     game.MovePrize()

        '     ' Get ILP data from the game
        '     Dim ilpData = game.GetILPData()
        '     Dim objectiveFunction As Func(Of Double, Double, Double) = ilpData.Item1
        '     Dim constraintFunction As Func(Of Double, Double, Boolean) = ilpData.Item2
        '     Dim maxNA As Double = ilpData.Item3
        '     Dim maxNB As Double = ilpData.Item4

        '     ' Solve the ILP for the current game
        '     Dim result = ILPSolver.Solve(objectiveFunction, constraintFunction, maxNA, maxNB)

        '     ' Add the cost of the current game to the total minimum cost
        '     totalMinCost += result.Item1 * game.ButtonA.Value + result.Item2 * game.ButtonB.Value
        ' Next

        ' Output the total minimum cost for Part Two
        ' Console.WriteLine($"Total minimum cost across all games (Part Two): {totalMinCost}")
    End Sub
End Module

End Namespace
