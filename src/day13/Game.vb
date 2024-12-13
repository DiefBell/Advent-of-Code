Imports System.IO
Imports System.Text.RegularExpressions

Namespace AdventOfCode
Public Class Game
    Public Property ID As Integer ' Add ID property
    Public Property ButtonA As Button
    Public Property ButtonB As Button
    Public Property Prize As Vector2
    Public Property CostOne As Double? ' Nullable Double to store cost or -1 for unsolvable
	Public Property CostTwo As Double? ' Nullable Double to store cost or -1 for unsolvable

    ' Constructor
    Public Sub New(buttonA As Button, buttonB As Button, prize As Vector2, id As Integer)
        Me.ButtonA = buttonA
        Me.ButtonB = buttonB
        Me.Prize = prize
        Me.CostOne = Nothing ' Default to null for unsolved games
        Me.CostTwo = Nothing ' Default to null for unsolved games
        Me.ID = id ' Initialize the ID
    End Sub

    ' Set the cost, use -1 for unsolvable games
    Public Sub SetCostOne(cost As Double)
        Me.CostOne = cost
    End Sub

	' Set the cost, use -1 for unsolvable games
	Public Sub SetCostTwo(cost As Double)
		Me.CostTwo = cost
	End Sub

    ' Generate inputs for ILPSolver
    Public Function GetILPData() As (
        Func(Of Double, Double, Double),
        Func(Of Double, Double, Boolean),
        Double,
        Double
    )
        ' Objective function: Minimize cost
        Dim objectiveFunction As Func(Of Double, Double, Double) =
            Function(nA, nB) nA * ButtonA.Value + nB * ButtonB.Value

        ' Constraint function: Match prize location
        Dim constraintFunction As Func(Of Double, Double, Boolean) =
            Function(nA, nB)
                Dim xResult As Double = nA * ButtonA.Direction.X + nB * ButtonB.Direction.X
                Dim yResult As Double = nA * ButtonA.Direction.Y + nB * ButtonB.Direction.Y
                Return xResult = Prize.X AndAlso yResult = Prize.Y
            End Function

        ' Upper bounds for search
        Dim maxNA As Double = Math.Ceiling(Prize.X / Math.Max(1, ButtonA.Direction.X))
        Dim maxNB As Double = Math.Ceiling(Prize.Y / Math.Max(1, ButtonB.Direction.Y))

        Return (objectiveFunction, constraintFunction, maxNA, maxNB)
    End Function

    ' ToString override for display
    Public Overrides Function ToString() As String
        Return $"Game(ID: {ID}, " +
			$"ButtonA: {ButtonA}, ButtonB: {ButtonB}, " +
			$"Prize: {Prize}, " +
			$"CostOne: {If(CostOne = -1, "Unsolvable", CostOne.ToString())}, " +
			$"CostTwo: {If(CostTwo = -1, "Unsolvable", CostTwo.ToString())})"
    End Function

    ' Static method to parse the games from a file
    Public Shared Function ParseGames(filePath As String) As List(Of Game)
        Dim games As New List(Of Game)()
        Dim lines = File.ReadAllLines(filePath)

        ' Accumulate lines for each game block
        Dim currentBlock As New List(Of String)()

        ' Counter for the ID
        Dim currentID As Integer = 1

        For Each line As String In lines
            If String.IsNullOrWhiteSpace(line) Then
                If currentBlock.Count = 3 Then
                    ' Pass the currentID when creating the game
                    games.Add(ParseGameBlock(currentBlock, currentID))
                    currentID += 1 ' Increment ID for the next game
                End If
                currentBlock.Clear()
            Else
                currentBlock.Add(line)
            End If
        Next

        ' Handle the last block
        If currentBlock.Count = 3 Then
            games.Add(ParseGameBlock(currentBlock, currentID))
        End If

        Return games
    End Function

    ' Helper method to parse each game block
    Private Shared Function ParseGameBlock(block As List(Of String), id As Integer) As Game
        ' Parse Button A (with value 3)
        Dim buttonA = ParseButton(block(0), 3)

        ' Parse Button B (with value 1)
        Dim buttonB = ParseButton(block(1), 1)

        ' Parse Prize
        Dim prize = ParseVector(block(2))

        ' Create and return the Game object with the ID
        Return New Game(buttonA, buttonB, prize, id)
    End Function

    ' Helper method to parse a button line
    Private Shared Function ParseButton(line As String, value As Integer) As Button
        ' Extract X and Y values
        Dim match = Regex.Match(line, "X([+=-]\d+), Y([+=-]\d+)")
        If match.Success Then
            Dim x = Double.Parse(match.Groups(1).Value)
            Dim y = Double.Parse(match.Groups(2).Value)
            Return New Button(value, New Vector2(x, y))
        Else
            Throw New FormatException($"Invalid button line format: {line}")
        End If
    End Function

    ' Helper method to parse a vector line
    Private Shared Function ParseVector(line As String) As Vector2
        ' Extract X and Y values
        Dim match = Regex.Match(line, "X=([+-]?\d+), Y=([+-]?\d+)")
        If match.Success Then
            Dim x = Double.Parse(match.Groups(1).Value)
            Dim y = Double.Parse(match.Groups(2).Value)
            Return New Vector2(x, y)
        Else
            Throw New FormatException($"Invalid vector line format: {line}")
        End If
    End Function
End Class
End Namespace
