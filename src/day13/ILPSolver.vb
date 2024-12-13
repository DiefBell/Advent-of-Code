Namespace AdventOfCode
Public Class ILPSolver
    Public Shared Function Solve(objectiveFunction As Func(Of Integer, Integer, Double),
                                  constraintFunction As Func(Of Integer, Integer, Boolean),
                                  maxNA As Integer,
                                  maxNB As Integer) As (Integer, Integer)
        Dim minCost As Double = Double.MaxValue
        Dim bestNA As Integer = 0
        Dim bestNB As Integer = 0

        ' Exhaustive search for nA and nB
        For nA As Integer = 0 To maxNA
            For nB As Integer = 0 To maxNB
                ' Check feasibility
                If constraintFunction(nA, nB) Then
                    ' Calculate cost
                    Dim cost As Double = objectiveFunction(nA, nB)
                    If cost < minCost Then
                        minCost = cost
                        bestNA = nA
                        bestNB = nB
                    End If
                End If
            Next
        Next

        Return (bestNA, bestNB)
    End Function
End Class
End Namespace
