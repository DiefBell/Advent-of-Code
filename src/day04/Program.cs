using System;
using System.IO;
using System.Collections.Generic;

string[] lines = File.ReadAllLines("input.txt");
int rows = lines.Length;

bool ElementsAreMas(char first, char second, char third)
{
	return first == 'M' && second == 'A' && third == 'S';
}

int count = 0;
for(int row = 0; row < rows; row++)
{
	string line = lines[row];
	int cols = line.Length;

	for(int col = 0; col < cols; col++)
	{
		char letter = line[col];
		if(letter != 'X')
		{
			continue;
		}

		// diagonally up-left
		if(col > 2 && row > 2)
		{
			char l2 = lines[row-1][col-1];
			char l3 = lines[row-2][col-2];
			char l4 = lines[row-3][col-3];
			if(ElementsAreMas(l2, l3, l4))
			{
				count++;
			}
		}

		// straight left
		if(col > 2)
		{
			char l2 = lines[row][col-1];
			char l3 = lines[row][col-2];
			char l4 = lines[row][col-3];
			if(ElementsAreMas(l2, l3, l4))
			{
				count++;
			}
		}

		// diagonally down-left
		if(col > 2 && row < rows - 3)
		{
			char l2 = lines[row+1][col-1];
			char l3 = lines[row+2][col-2];
			char l4 = lines[row+3][col-3];
			if(ElementsAreMas(l2, l3, l4))
			{
				count++;
			}
		}

		// straight down
		if(row < rows - 3)
		{
			char l2 = lines[row+1][col];
			char l3 = lines[row+2][col];
			char l4 = lines[row+3][col];
			if(ElementsAreMas(l2, l3, l4))
			{
				count++;
			}
		}

		// diagonally down-right
		if(row < rows - 3 && col < cols - 3)
		{
			char l2 = lines[row+1][col+1];
			char l3 = lines[row+2][col+2];
			char l4 = lines[row+3][col+3];
			if(ElementsAreMas(l2, l3, l4))
			{
				count++;
			}
		}
		
		// straight right
		if(col < cols - 3)
		{
			char l2 = lines[row][col+1];
			char l3 = lines[row][col+2];
			char l4 = lines[row][col+3];
			if(ElementsAreMas(l2, l3, l4))
			{
				count++;
			}
		}
		
		// diagonally up-right
		if(row > 2 && col < cols - 3)
		{
			char l2 = lines[row-1][col+1];
			char l3 = lines[row-2][col+2];
			char l4 = lines[row-3][col+3];
			if(ElementsAreMas(l2, l3, l4))
			{
				count++;
			}
		}
		
		// straight up
		if(row > 2)
		{
			char l2 = lines[row-1][col];
			char l3 = lines[row-2][col];
			char l4 = lines[row-3][col];
			if(ElementsAreMas(l2, l3, l4))
			{
				count++;
			}
		}
	}
}

Console.WriteLine($"Found XMAS {count} times.");
