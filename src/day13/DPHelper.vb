Imports System
Imports System.Collections.Generic

Namespace AdventOfCode
    Public Class DPHelper
        Public Shared Function IsTargetSolvable(targetX As Double, targetY As Double, buttonA As Button, buttonB As Button) As Boolean
            ' We can solve the problem using dynamic programming.
            ' We'll use a dictionary to store sub-problems results.
            Dim dp As New Dictionary(Of (Double, Double), Boolean)

            ' Initialize with starting point (0,0) as True
            dp((0, 0)) = True
            ' Console.WriteLine("Starting DP search from (0,0)")

            ' Queue for BFS-like iteration
            Dim queue As New Queue(Of (Double, Double))()
            queue.Enqueue((0, 0))

            ' Iterate until the queue is empty
            While queue.Count > 0
                ' Get the current position from the queue
                Dim currentPosition = queue.Dequeue()
                Dim x As Double = currentPosition.Item1
                Dim y As Double = currentPosition.Item2
                ' Console.WriteLine($"Processing position: ({x}, {y})")

                ' Check if target is within bounds
                If x > targetX OrElse y > targetY Then
                    Continue While ' Skip if position exceeds the target
                End If

                ' Try to move in the direction of Button A
                Dim newX = x + buttonA.Direction.X
                Dim newY = y + buttonA.Direction.Y
                If Not dp.ContainsKey((newX, newY)) Then
                    dp((newX, newY)) = True
                    queue.Enqueue((newX, newY)) ' Enqueue for further processing
                    ' Console.WriteLine($"  Moving to Button A: ({newX}, {newY})")
                End If

                ' Try to move in the direction of Button B
                newX = x + buttonB.Direction.X
                newY = y + buttonB.Direction.Y
                If Not dp.ContainsKey((newX, newY)) Then
                    dp((newX, newY)) = True
                    queue.Enqueue((newX, newY)) ' Enqueue for further processing
                    ' Console.WriteLine($"  Moving to Button B: ({newX}, {newY})")
                End If
            End While

            ' Log final result
            If dp.ContainsKey((targetX, targetY)) Then
                ' Console.WriteLine($"Target solvable: ({targetX}, {targetY})")
                Return True
            Else
                ' Console.WriteLine($"Target NOT solvable: ({targetX}, {targetY})")
                Return False
            End If
        End Function
    End Class
End Namespace
