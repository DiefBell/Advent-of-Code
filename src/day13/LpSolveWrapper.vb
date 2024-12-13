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
	''' Initial number of rows. Can be 0 as new rows can be added via add_constraint, add_constraintex, str_add_constraint.
	''' </param>
	'''
	''' <param name="columns">
	''' Initial number of columns. Can be 0 as new columns can be added via add_column, add_columnex, str_add_column.
	''' </param>
	''' 
	''' <returns>
	''' Returns a pointer to a new lprec structure.
	''' This must be provided to almost all lp_solve functions.
	''' A NULL return value indicates an error.
	''' Specifically not enough memory available to setup an lprec structure.
	''' </returns>
	<DllImport("../../lp_solve_5.5/lpsolve55/bin/ux64/liblpsolve55.so", CallingConvention:=CallingConvention.Cdecl)>
	Public Shared Function make_lp(rows As Integer, columns as Integer) As Integer
	End Function
End Class
End Namespace