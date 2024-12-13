Imports System
Imports System.Collections.Generic

Namespace AdventOfCode
Public Class DPHelper
    ' Function to determine if target is solvable using Dynamic Programming
    Public Shared Function IsTargetSolvable(targetX As Double, targetY As Double, buttonA As Button, buttonB As Button) As Boolean
        ' We can solve the problem using dynamic programming.
        ' We'll use a dictionary to store sub-problems results.
        Dim dp As New Dictionary(Of (Double, Double), Boolean)

        ' Initialize with starting point (0,0) as True
        dp((0, 0)) = True

        ' Iterate over all possible reachable coordinates
        For Each position In dp.Keys.ToList()
            ' Access the tuple components manually
            Dim x As Double = position.Item1
            Dim y As Double = position.Item2

            ' Try to move in the direction of Button A
            Dim newX = x + buttonA.Direction.X
            Dim newY = y + buttonA.Direction.Y
            If Not dp.ContainsKey((newX, newY)) Then
                dp((newX, newY)) = True
            End If

            ' Try to move in the direction of Button B
            newX = x + buttonB.Direction.X
            newY = y + buttonB.Direction.Y
            If Not dp.ContainsKey((newX, newY)) Then
                dp((newX, newY)) = True
            End If
        Next

        ' If the target position (targetX, targetY) is reachable, return True, otherwise False
        Return dp.ContainsKey((targetX, targetY))
    End Function
End Class
End Namespace
