Namespace AdventOfCode
Public Class ILPSolver
    Public Shared Function Solve(objectiveFunction As Func(Of Double, Double, Double),
                                  constraintFunction As Func(Of Double, Double, Boolean),
                                  maxNA As Double,
                                  maxNB As Double) As (Double, Double)
        Dim minCost As Double = Double.MaxValue
        Dim bestNA As Double = 0
        Dim bestNB As Double = 0

        ' Exhaustive search for nA and nB
        For nA As Double = 0 To maxNA
            For nB As Double = 0 To maxNB
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
