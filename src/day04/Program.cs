using System;
using System.IO;
using System.Collections.Generic;

class Program
{

	private static bool ElementsAreMas(char first, char second, char third)
	{
		return first == 'M' && second == 'A' && third == 'S';
	}

	/// <summary>
	/// For a starting letter X at the given row and column,
	/// finds any XMAS from it.
	/// </summary>
	/// <param name="lines"></param>
	/// <param name="row"></param>
	/// <param name="col"></param>
	/// <returns></returns>
	private static int CountXmas(string[] lines, int row, int col)
	{
		int rows = lines.Length;
		int cols = lines[0].Length;

		int count = 0;

		// diagonally up-left
		if (col > 2 && row > 2)
		{
			char l2 = lines[row - 1][col - 1];
			char l3 = lines[row - 2][col - 2];
			char l4 = lines[row - 3][col - 3];
			if (ElementsAreMas(l2, l3, l4))
			{
				count++;
			}
		}

		// straight left
		if (col > 2)
		{
			char l2 = lines[row][col - 1];
			char l3 = lines[row][col - 2];
			char l4 = lines[row][col - 3];
			if (ElementsAreMas(l2, l3, l4))
			{
				count++;
			}
		}

		// diagonally down-left
		if (col > 2 && row < rows - 3)
		{
			char l2 = lines[row + 1][col - 1];
			char l3 = lines[row + 2][col - 2];
			char l4 = lines[row + 3][col - 3];
			if (ElementsAreMas(l2, l3, l4))
			{
				count++;
			}
		}

		// straight down
		if (row < rows - 3)
		{
			char l2 = lines[row + 1][col];
			char l3 = lines[row + 2][col];
			char l4 = lines[row + 3][col];
			if (ElementsAreMas(l2, l3, l4))
			{
				count++;
			}
		}

		// diagonally down-right
		if (row < rows - 3 && col < cols - 3)
		{
			char l2 = lines[row + 1][col + 1];
			char l3 = lines[row + 2][col + 2];
			char l4 = lines[row + 3][col + 3];
			if (ElementsAreMas(l2, l3, l4))
			{
				count++;
			}
		}

		// straight right
		if (col < cols - 3)
		{
			char l2 = lines[row][col + 1];
			char l3 = lines[row][col + 2];
			char l4 = lines[row][col + 3];
			if (ElementsAreMas(l2, l3, l4))
			{
				count++;
			}
		}

		// diagonally up-right
		if (row > 2 && col < cols - 3)
		{
			char l2 = lines[row - 1][col + 1];
			char l3 = lines[row - 2][col + 2];
			char l4 = lines[row - 3][col + 3];
			if (ElementsAreMas(l2, l3, l4))
			{
				count++;
			}
		}

		// straight up
		if (row > 2)
		{
			char l2 = lines[row - 1][col];
			char l3 = lines[row - 2][col];
			char l4 = lines[row - 3][col];
			if (ElementsAreMas(l2, l3, l4))
			{
				count++;
			}
		}

		return count;
	}

	/// <summary>
	/// For a starting letter A at the given row and column,
	///	finds if it's at the centre of an MAS cross.
	/// </summary>
	/// <param name="lines"></param>
	/// <param name="row"></param>
	/// <param name="col"></param>
	/// <returns></returns>
	private static bool IsMasCross(string[] lines, int row, int col)
	{
		int rows = lines.Length;
		int cols = lines[0].Length;

		if(row < 1 || row > rows - 2 || col < 1 || col > cols - 2)
		{
			return false;
		}

		char centre = lines[row][col];
		char tl = lines[row-1][col-1];
		char tr = lines[row-1][col+1];
		char bl = lines[row+1][col-1];
		char br = lines[row+1][col+1];

		bool tlbr = ElementsAreMas(tl, centre, br);
		bool trbl = ElementsAreMas(tr, centre, bl);
		bool bltr = ElementsAreMas(bl, centre, tr);
		bool brtl = ElementsAreMas(br, centre, tl);

		return (brtl || tlbr) && (trbl || bltr);
	}

	static void Main()
	{

		string[] lines = File.ReadAllLines("input.txt");
		int rows = lines.Length;

		int xmasCount = 0;
		int masCrossCount = 0;

		for (int row = 0; row < rows; row++)
		{
			string line = lines[row];
			int cols = line.Length;

			for (int col = 0; col < cols; col++)
			{
				char letter = line[col];
				if (letter == 'X')
				{
					xmasCount += CountXmas(lines, row, col);
				}
				else if(letter == 'A' && IsMasCross(lines, row, col))
				{
					masCrossCount++;
				}
			}
		}

		Console.WriteLine($"Found XMAS {xmasCount} times.");
		Console.WriteLine($"Found MAX cross {masCrossCount} times.");
	}
}