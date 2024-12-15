export class Vector2
{
	private _x: number;
	public get x(): number
	{
		return this._x;
	}

	private _y: number;
	public get y(): number
	{
		return this._y;
	}

	constructor(vector: Vector2);
	constructor(x: number, y: number);
	constructor(vectorOrX: Vector2 | number, y?: number)
	{
		if(vectorOrX instanceof Vector2)
		{
			this._x = vectorOrX.x;
			this._y = vectorOrX.y;
		}
		else
		{
			this._x = vectorOrX;
			this._y = y!;
		}
	}

	public clone(): Vector2
	{
		return new Vector2(this);
	}

	public add(vec: Vector2 | [number, number])
	{
		if(vec instanceof Vector2)
		{
			this._x += vec.x;
			this._y += vec.y;
		}
		else
		{
			this._x += vec[0];
			this._y += vec[1];
		}
	}
}
