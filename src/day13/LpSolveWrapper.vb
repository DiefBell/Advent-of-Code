Imports System
Imports System.Runtime.InteropServices

Namespace AdventOfCode
Public Class LpSolveWrapper
	''' <summary>
	''' Create and initialise a new lprec structure.
	''' https://web.mit.edu/lpsolve/doc/
	''' </summary>
	'''
	''' <remarks>
	''' The make_lp function constructs a new LP. Sets all variables to initial values.
	''' The LP has rows rows and columns columns.
	''' The matrix contains no values, but space for one value.
	''' All arrays that depend on rows and columns are allocated.
	''' It is advised not to read/write the lprec structure.
	''' Instead, use the function interface to communicate with the lp_solve library.
	''' This because the structure can change over time. The function interface will be more stable. 
	''' </remarks>
	'''
	''' <param name="rows">
	''' Initial number of rows.
	''' Can be 0 as new rows can be added via add_constraint, add_constraintex, str_add_constraint.
	''' </param>
	'''
	''' <param name="columns">
	''' Initial number of columns.
	''' Can be 0 as new columns can be added via add_column, add_columnex, str_add_column.
	''' </param>
	''' 
	''' <returns>
	''' Returns a pointer to a new lprec structure.
	''' This must be provided to almost all lp_solve functions.
	''' A NULL return value indicates an error.
	''' Specifically not enough memory available to setup an lprec structure.
	''' </returns>
	<DllImport("liblpsolve55.so", CallingConvention:=CallingConvention.Cdecl)>
	Public Shared Function make_lp(rows As Integer, columns as Integer) As Integer
	End Function

	''' <summary>
	''' Adds a constraint to the linear programming (LP) model.
	''' </summary>
	''' <param name="lp">A pointer to the previously created LP model (obtained from <c>make_lp</c> or similar functions).</param>
	''' <param name="row">An array representing the coefficients of the constraint. The array must have a size of <c>1 + get_Ncolumns</c>, where each element corresponds to a variable in the LP model.</param>
	''' <param name="constr_type">The type of the constraint:
	''' 1 for "Less than or equal" (<=),
	''' 2 for "Greater than or equal" (>=),
	''' 3 for "Equal to" (=).</param>
	''' <param name="rh">The right-hand side (RHS) value of the constraint. This is the value that the linear combination of variables must satisfy, according to the constraint type.</param>
	''' <returns>Returns <c>True</c> if the constraint was successfully added, or <c>False</c> if there was an error.</returns>
	''' <remarks>
	''' This method adds a constraint row to the LP model, where the first element in the <paramref name="row"/> array is ignored, and the rest correspond to the variables starting from column 1.
	''' The <paramref name="row"/> array contains the coefficients of the variables, with zero for variables not involved in the constraint.
	''' This method is a wrapper around <c>add_constraint</c>. In cases where the matrix is sparse, <c>add_constraintex</c> (which allows specifying only non-zero elements) should be used instead for better performance.
	''' It is recommended to set the objective function using <c>set_obj_fn</c> or similar functions before adding any constraints to the LP model.
	''' For performance optimization when adding many constraints, you can call <c>set_add_rowmode</c> before adding the constraints.
	''' </remarks>
	<DllImport("liblpsolve55.so", CallingConvention:=CallingConvention.Cdecl)>
	Public Shared Function add_constraint(lp As Integer, row As Double(), constr_type As Integer, rhs As Double) As Integer
	End Function

	''' <summary>
	''' Adds a constraint to the linear program model.
	''' </summary>
	''' <param name="lp">The linear program model (pointer to the LP model).</param>
	''' <param name="count">The number of non-zero elements in the row.</param>
	''' <param name="row">An array containing the coefficients of the variables in the constraint row.</param>
	''' <param name="colno">An array containing the zero-based indices of the columns corresponding to the non-zero values in the row.</param>
	''' <param name="constr_type">The type of the constraint. Use 1 for "<=" (less than or equal), 2 for ">=" (greater than or equal), or 3 for "=" (equal).</param>
	''' <param name="rhs">The right-hand side value of the constraint, i.e., the value the linear combination of the variables should be equal to (or less than/greater than depending on the type).</param>
	''' <returns>Returns TRUE (1) if the operation was successful, or FALSE (0) if there was an error.</returns>
	''' <remarks>
	''' This function adds a row to the linear program model, where the row represents a constraint.
	''' It allows the specification of a sparse matrix (i.e., a row with only a few non-zero elements), which improves performance for large models.
	''' The <paramref name="colno"/> parameter allows you to specify the column numbers for the non-zero elements in the <paramref name="row"/> array.
	''' If <paramref name="colno"/> is NULL, it will assume that every element in <paramref name="row"/> corresponds to a column in order.
	''' </remarks>
	<DllImport("liblpsolve55.so", CallingConvention:=CallingConvention.Cdecl)>
	Public Shared Function add_constraintex(lp As Integer, count As Integer, row As Double(), colno As Integer(), constr_type As Integer, rhs As Double) As Integer
	End Function

	' <summary>
	' Sets the objective function (row 0) of the matrix.
	' </summary>
	' <param name="lp">Pointer to the previously created LP model.</param>
	' <param name="row">An array containing the values of the objective function. 
	' Element 0 is ignored, and the values correspond to columns starting from 1.</param>
	' <returns>TRUE (1) if the operation was successful, FALSE (0) otherwise.</returns>
	' <remarks>
	' This function sets all values of the objective function at once. 
	' Element 0 of the array is not considered (i.e., ignored). 
	' Column 1 corresponds to element 1, column 2 corresponds to element 2, etc.
	' </remarks>
	<DllImport("liblpsolve55.so", CallingConvention:=CallingConvention.Cdecl)>
	Public Shared Function set_obj_fn(lp As IntPtr, row As Double()) As Integer
	End Function

	' <summary>
	' Sets the objective function (row 0) of the matrix with the possibility to specify only non-zero elements.
	' </summary>
	' <param name="lp">Pointer to the previously created LP model.</param>
	' <param name="count">The number of non-zero elements in the objective function row.</param>
	' <param name="row">An array containing the values of the objective function for non-zero columns.</param>
	' <param name="colno">An array with the column indices (starting from 1) corresponding to the non-zero values in row.</param>
	' <returns>TRUE (1) if the operation was successful, FALSE (0) otherwise.</returns>
	' <remarks>
	' This function sets the objective function for only the non-zero elements.
	' This can improve performance if the matrix is sparse with many zero values.
	' It is recommended to use this function instead of set_obj_fn for sparse models.
	' </remarks>
	<DllImport("liblpsolve55.so", CallingConvention:=CallingConvention.Cdecl)>
	Public Shared Function set_obj_fnex(lp As IntPtr, count As Integer, row As Double(), colno As Integer()) As Integer
	End Function

	' <summary>
	' Sets a single value of the objective function for a specific column in the matrix.
	' </summary>
	' <param name="lp">Pointer to the previously created LP model.</param>
	' <param name="column">The column number (starting from 1) for which the objective function value is to be set.</param>
	' <param name="value">The value to set for the specified column.</param>
	' <returns>TRUE (1) if the operation was successful, FALSE (0) otherwise.</returns>
	' <remarks>
	' This function sets the objective value for the specified column. 
	' If multiple objective values must be set, it is more efficient to use set_obj_fnex.
	' </remarks>
	<DllImport("liblpsolve55.so", CallingConvention:=CallingConvention.Cdecl)>
	Public Shared Function set_obj(lp As IntPtr, column As Integer, value As Double) As Integer
	End Function

	''' <summary>
    ''' Solves the linear programming model.
    ''' </summary>
    ''' <param name="lp">Pointer to the LP model created using make_lp or other functions like copy_lp, read_lp, etc.</param>
    ''' <returns>
    ''' Returns an integer indicating the status of the solution:
    ''' -2 (NOMEMORY): Out of memory
    ''' 0 (OPTIMAL): An optimal solution was obtained
    ''' 1 (SUBOPTIMAL): The model is sub-optimal. Occurs when there are integer variables and a suboptimal integer solution is found.
    ''' 2 (INFEASIBLE): The model is infeasible
    ''' 3 (UNBOUNDED): The model is unbounded
    ''' 4 (DEGENERATE): The model is degenerative
    ''' 5 (NUMFAILURE): Numerical failure encountered
    ''' 6 (USERABORT): The abort routine returned TRUE
    ''' 7 (TIMEOUT): A timeout occurred (set via set_timeout)
    ''' 9 (PRESOLVED): The model could be solved by presolve
    ''' 25 (NUMFAILURE): Accuracy error encountered
    ''' </returns>
    ''' <remarks>
    ''' This function solves the linear programming model. It can be called multiple times with the same model. 
    ''' Between calls, the model may be modified, including changes to restrictions, matrix values, and the addition or deletion of rows/columns.
    ''' If a timeout occurs during solving, and there was already an integer solution found, the function will return SUBOPTIMAL.
    ''' If presolve is active, the model might be solved during presolve without invoking the actual solve method, and the function may return PRESOLVED.
    ''' </remarks>
    ''' <example>
    ''' Dim lp As Integer = LpSolveWrapper.make_lp(0, 0)
    ''' If lp <> 0 Then
    '''     Dim result As Integer = LpSolveWrapper.solve(lp)
    '''     Console.WriteLine("Solve result: " & result)
    ''' End If
    ''' </example>
	<DllImport("liblpsolve55.so", CallingConvention:=CallingConvention.Cdecl)> _
    Public Shared Function solve(lp As Integer) As Integer
    End Function

	<DllImport("liblpsolve55.so", CallingConvention:=CallingConvention.Cdecl)> _
	Public Shared Function set_add_rowmode(lp As Integer, turnon As Boolean) As String
	End Function

End Class
End Namespace