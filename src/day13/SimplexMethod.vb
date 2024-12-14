Imports System

Module SimplexMethod
    ''' <summary>
    ''' Solves a linear programming problem using the Simplex method.
    ''' </summary>
    ''' <param name="objectiveCoefficients">Array containing the coefficients of the objective function (maximize).</param>
    ''' <param name="constraintCoefficients">2D array containing the coefficients of the constraints.</param>
    ''' <param name="constraintConstants">Array containing the right-hand side values of the constraints.</param>
    ''' <returns>An array with the optimal values of the decision variables.</returns>
    Function SolveLinearProgramming(
		objectiveCoefficients As Double(),
		constraintCoefficients As Double()(),
		constraintConstants As Double()
	) As Double()
        Dim numConstraints As Integer = constraintConstants.Length  ' Number of constraints (2 in this case)
        Dim numVariables As Integer = objectiveCoefficients.Length  ' Number of variables (2 in this case)

        ' Initialize the Simplex tableau. 
        ' The tableau has 3 rows (for 2 constraints and 1 objective row) and 3 columns (for 2 variables + right-hand side)
        Dim tableau(numConstraints, numVariables) As Double

        ' Fill the tableau with constraint coefficients and constants
        For constraintRow As Integer = 0 To numConstraints - 1
            For variableColumn As Integer = 0 To numVariables - 1
                tableau(constraintRow, variableColumn) = constraintCoefficients(constraintRow)(variableColumn)
            Next
            tableau(constraintRow, numVariables) = constraintConstants(constraintRow)
        Next

        ' Fill the objective function row with the negative of the objective coefficients
        For variableColumn As Integer = 0 To numVariables - 1
            tableau(numConstraints, variableColumn) = -objectiveCoefficients(variableColumn)
        Next
        tableau(numConstraints, numVariables) = 0 ' Right-hand side for the objective row

        ' Perform the Simplex algorithm loop
        While True
            ' Step 1: Check for optimality (i.e., no negative values in the objective row)
            Dim pivotColumn As Integer = -1
            For variableColumn As Integer = 0 To numVariables - 1
                If tableau(numConstraints, variableColumn) < 0 Then
                    pivotColumn = variableColumn
                    Exit For
                End If
            Next

            ' If no negative values in the objective row, optimal solution is found
            If pivotColumn = -1 Then
                Exit While
            End If

            ' Step 2: Perform the minimum ratio test to find the pivot row
            Dim pivotRow As Integer = -1
            Dim minRatio As Double = Double.MaxValue
            For constraintRow As Integer = 0 To numConstraints - 1
                If tableau(constraintRow, pivotColumn) > 0 Then
                    Dim ratio As Double = tableau(constraintRow, numVariables) / tableau(constraintRow, pivotColumn)
                    If ratio < minRatio Then
                        minRatio = ratio
                        pivotRow = constraintRow
                    End If
                End If
            Next

            ' If no valid pivot row is found, the problem is unbounded
            If pivotRow = -1 Then
                Throw New InvalidOperationException("The LP is unbounded.")
            End If

            ' Step 3: Perform the pivot operation
            Pivot(tableau, pivotRow, pivotColumn, numConstraints, numVariables)
        End While

        ' Extract the solution (values of the decision variables)
        Dim solution(numVariables - 1) As Double
        For variableIndex As Integer = 0 To numVariables - 1
            solution(variableIndex) = 0
        Next

        ' Set the solution for basic variables
        For constraintRow As Integer = 0 To numConstraints - 1
            Dim basicVariable As Integer = -1
            For variableColumn As Integer = 0 To numVariables - 1
                If tableau(constraintRow, variableColumn) = 1 Then
                    basicVariable = variableColumn
                    Exit For
                End If
            Next
            If basicVariable >= 0 Then
                solution(basicVariable) = tableau(constraintRow, numVariables)
            End If
        Next

        Return solution
    End Function

    ''' <summary>
    ''' Performs the pivot operation to update the Simplex tableau.
    ''' </summary>
    ''' <param name="tableau">The current Simplex tableau.</param>
    ''' <param name="pivotRow">The index of the pivot row.</param>
    ''' <param name="pivotColumn">The index of the pivot column.</param>
    ''' <param name="numConstraints">The number of constraints.</param>
    ''' <param name="numVariables">The number of variables.</param>
    Sub Pivot(tableau As Double(,), pivotRow As Integer, pivotColumn As Integer, numConstraints As Integer, numVariables As Integer)
        ' The pivot element is the intersection of the pivot row and pivot column
        Dim pivotElement As Double = tableau(pivotRow, pivotColumn)

        ' Normalize the pivot row by dividing by the pivot element
        For column As Integer = 0 To numVariables
            tableau(pivotRow, column) /= pivotElement
        Next

        ' Update all other rows by subtracting the appropriate multiple of the pivot row
        For row As Integer = 0 To numConstraints
            If row <> pivotRow Then
                Dim factor As Double = tableau(row, pivotColumn)
                For column As Integer = 0 To numVariables
                    tableau(row, column) -= factor * tableau(pivotRow, column)
                Next
            End If
        Next
    End Sub
End Module
