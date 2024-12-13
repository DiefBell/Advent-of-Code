Imports System

Namespace AdventOfCode

Module Program
    Sub Main()
        ' File path
        ' Dim filePath As String = "input.sample.txt"
        Dim filePath As String = "input.txt"

        ' Read and parse the games using Game's static method
        Dim games As List(Of Game) = Game.ParseGames(filePath)

        ' Call PartOne to process the games
        PartOne(games)
    End Sub

    ' Function to process the games and calculate the total minimum cost
    Sub PartOne(games As List(Of Game))
        ' Variable to hold the total minimum cost
        Dim totalMinCost As Double = 0

        ' Iterate through each game
        For Each game As Game In games
            ' Get ILP data from the game
            Dim ilpData = game.GetILPData()
            Dim objectiveFunction As Func(Of Integer, Integer, Double) = ilpData.Item1
            Dim constraintFunction As Func(Of Integer, Integer, Boolean) = ilpData.Item2
            Dim maxNA As Integer = ilpData.Item3
            Dim maxNB As Integer = ilpData.Item4

            ' Solve the ILP for the current game
            Dim result = ILPSolver.Solve(objectiveFunction, constraintFunction, maxNA, maxNB)

            ' Add the cost of the current game to the total minimum cost
            totalMinCost += result.Item1 * game.ButtonA.Value + result.Item2 * game.ButtonB.Value
        Next

        ' Output the total minimum cost
        Console.WriteLine($"Total minimum cost across all games: {totalMinCost}")
    End Sub
End Module

End Namespace