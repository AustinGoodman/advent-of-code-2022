Imports System, System.Collections.Generic

Module Main
	Public Function GetInstructionList() As List(Of String)
		Dim streamReader As System.IO.StreamReader = My.Computer.FileSystem.OpenTextFileReader("./input.txt")
		Dim lineList = New List(Of String)()

		Do While streamReader.Peek() <> -1
			lineList.Add(streamReader.ReadLine())
		Loop

		Return lineList
	End Function

	Sub Main()
		Dim instructionList = GetInstructionList()

		Dim signalLog = New List(Of Integer)()
		signalLog.Add(0)

		Dim screenWidth = 40
		Dim screenHeight = 6
		Dim pixels(screenWidth, screenHeight) As Char

		Dim clockCycle = 0
		Dim instructionTimer = 1
		Dim PC As Integer = 0
		Dim X As Integer = 1

		Do While PC < instructionList.Count
			clockCycle += 1

			Dim curPixelX = (clockCycle - 1) Mod screenWidth
			Dim curPixelY = (clockCycle - 1) \ screenWidth

			Dim instruction = instructionList(PC)
			Dim instructionSplit = instruction.Split(" ")
			Dim instructionName = instructionSplit(0)
			Dim signalStrength = X*clockCycle

			signalLog.Add(signalStrength)

			If curPixelX >= X-1 And curPixelX <= X+1 Then
				pixels(curPixelX, curPixelY) = "#"
			Else 
				pixels(curPixelX, curPixelY) = "."
			End If
			
			If instructionTimer > 0 Then
				instructionTimer -= 1
				Continue Do
			End If

			If instructionTimer = 0 Then
				PC += 1
				
				If instructionName = "noop" Then
					instructionTimer = 0
				End If

				If instructionName = "addx" then
					instructionTimer = 1
					X += Convert.toInt32(instructionSplit(1)) 
				End If
			End If
		Loop

		Dim signalSum = 0
		For i = 0 To 5
			Dim index = 20 + i*40
			signalSum += signalLog(index)
		Next
		Console.WriteLine("Signal sum: " & signalSum)

		For y = 0 To screenHeight-1
			For x = 0 To screenWidth-1
				Console.Write(pixels(x, y))
			Next
			Console.WriteLine()
		Next

		End Sub

End Module