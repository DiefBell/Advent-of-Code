Imports System
Imports System.IO

Public Structure Vector2
    Public X As Double
    Public Y As Double

    ' Constructor for Vector2
    Public Sub New(x As Double, y As Double)
        Me.X = x
        Me.Y = y
    End Sub

    ' Override ToString for better display
    Public Overrides Function ToString() As String
        Return $"({X}, {Y})"
    End Function
End Structure

Public Structure Button
    Public Value As Integer
    Public Direction As Vector2

    ' Constructor for Button
    Public Sub New(value As Integer, direction As Vector2)
        Me.Value = value
        Me.Direction = direction
    End Sub

    ' Override ToString for better display
    Public Overrides Function ToString() As String
        Return $"Button(Value: {Value}, Direction: {Direction})"
    End Function
End Structure

Public Class Game
    ' Fields for ButtonA and ButtonB
    Public Property ButtonA As Button
    Public Property ButtonB As Button

    ' Field for the Prize (Vector2)
    Public Property Prize As Vector2

    ' Constructor to initialize Game
    Public Sub New(buttonA As Button, buttonB As Button, prize As Vector2)
        Me.ButtonA = buttonA
        Me.ButtonB = buttonB
        Me.Prize = prize
    End Sub

    ' Method to display Game details
    Public Overrides Function ToString() As String
        Return $"Game(ButtonA: {ButtonA}, ButtonB: {ButtonB}, Prize: {Prize})"
    End Function
End Class

Module Program
    Sub Main()
        ' File path
        Dim filePath As String = "input.sample.txt"

        ' Read and parse the games
        Dim games As List(Of Game) = ParseGames(filePath)

        ' Display each Game object
        For Each game As Game In games
            Console.WriteLine(game)
        Next
    End Sub

    Function ParseGames(filePath As String) As List(Of Game)
        Dim games As New List(Of Game)()
        Dim lines = File.ReadAllLines(filePath)

        ' Accumulate lines for each game block
        Dim currentBlock As New List(Of String)()

        For Each line As String In lines
            If String.IsNullOrWhiteSpace(line) Then
                If currentBlock.Count = 3 Then
                    games.Add(ParseGameBlock(currentBlock))
                End If
                currentBlock.Clear()
            Else
                currentBlock.Add(line)
            End If
        Next

        ' Handle the last block
        If currentBlock.Count = 3 Then
            games.Add(ParseGameBlock(currentBlock))
        End If

        Return games
    End Function

    Function ParseGameBlock(block As List(Of String)) As Game
        ' Parse Button A
        Dim buttonA = ParseButton(block(0), 3)

        ' Parse Button B
        Dim buttonB = ParseButton(block(1), 1)

        ' Parse Prize
        Dim prize = ParseVector(block(2))

        ' Create and return the Game object
        Return New Game(buttonA, buttonB, prize)
    End Function

    Function ParseButton(line As String, value As Integer) As Button
        ' Extract X and Y values
        Dim match = Text.RegularExpressions.Regex.Match(line, "X([+=-]\d+), Y([+=-]\d+)")
        If match.Success Then
            Dim x = Double.Parse(match.Groups(1).Value)
            Dim y = Double.Parse(match.Groups(2).Value)
            Return New Button(value, New Vector2(x, y))
        Else
            Throw New FormatException($"Invalid button line format: {line}")
        End If
    End Function

    Function ParseVector(line As String) As Vector2
        ' Extract X and Y values
        Dim match = Text.RegularExpressions.Regex.Match(line, "X=([+-]?\d+), Y=([+-]?\d+)")
        If match.Success Then
            Dim x = Double.Parse(match.Groups(1).Value)
            Dim y = Double.Parse(match.Groups(2).Value)
            Return New Vector2(x, y)
        Else
            Throw New FormatException($"Invalid vector line format: {line}")
        End If
    End Function
End Module

