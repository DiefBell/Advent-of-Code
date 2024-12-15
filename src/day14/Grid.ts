type Quadrants = {
	topLeft: number,
	topRight: number,
	bottomLeft: number,
	bottomRight: number,
};

export class Grid
{
	private readonly _width: number;
	private readonly _height: number;

	private _tiles: number[][];
	public get tiles(): Readonly<number[][]>
	{
		return this._tiles;
	}

	constructor(width: number, height: number)
	{
		this._width = width;
		this._height = height;

		this._tiles = new Array(this._height);
		this.reset();
	}

	public reset(): void
	{
		this._tiles = new Array(this._height);
		for (let row = 0; row < this._tiles.length; row++)
		{
			this._tiles[row] = new Array(this._width).fill(0);
		}
	}

	public addToGrid(x: number, y: number, value: number)
	{
		try
		{
			this._tiles[y][x] += value;
		}
		catch (e)
		{
			console.error(`Failed to add ${value} to grid at (${x},${y})`);
			throw e;
		}
	}

	public getQuadrants(): Quadrants
	{
		return this._tiles.reduce<Quadrants>(
			(prev, curr, rowIndex) =>
			{
				const midRow = (this._height - 1) / 2;
				if(rowIndex == midRow)
				{
					return prev;
				}

				const isTop = rowIndex < midRow;
				for (const [colIndex, numBots] of curr.entries())
				{
					const midCol = (this._width - 1) / 2;
					if(colIndex === midCol)
					{
						continue;
					}

					const isLeft = colIndex < midCol;
					if(isTop)
					{
						if(isLeft)
						{
							prev.topLeft += numBots;
						}
						else
						{
							prev.topRight += numBots;
						}
					}
					else
					{
						if(isLeft)
						{
							prev.bottomLeft += numBots;
						}
						else
						{
							prev.bottomRight += numBots;
						}
					}
				}

				return prev;
			},
			{ topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0 }
		);
	}
}
