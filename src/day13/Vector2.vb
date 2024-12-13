Namespace AdventOfCode
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
End Namespace