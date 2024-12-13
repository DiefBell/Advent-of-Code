Namespace AdventOfCode
Public Class Game
    ' Fields for ButtonA and ButtonB
    Public Property ButtonA As Button
    Public Property ButtonB As Button

    ' Field for the Prize (Vector2)
    Public Property Prize As Vector2

    ' Constructor to initialize Game
    Public Sub New(buttonA As Button, buttonB As Button, prize As Vector2)
        Me.ButtonA = buttonA
        Me.ButtonB = buttonB
        Me.Prize = prize
    End Sub

    ' Method to display Game details
    Public Overrides Function ToString() As String
        Return $"Game(ButtonA: {ButtonA}, ButtonB: {ButtonB}, Prize: {Prize})"
    End Function
End Class
End Namespace