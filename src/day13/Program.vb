Imports System
Imports System.IO

Namespace AdventOfCode

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

End Namespace