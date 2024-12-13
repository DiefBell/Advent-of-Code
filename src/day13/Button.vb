Namespace AdventOfCode
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
End Namespace