import { type Vector2 } from "./Vector2";

export class Robot
{
	private _position: Vector2;
	public get position(): Readonly<Vector2>
	{
		return this._position.clone();
	}

	private readonly _velocity: Vector2;
	public get velocity(): Readonly<Vector2>
	{
		return this._velocity.clone();
	}

	constructor(startPosition: Vector2, velocity: Vector2)
	{
		this._position = startPosition;
		this._velocity = velocity;
	}

	public move(): void
	{
		this._position.add(this._velocity);
	}

	public teleport(width: number, height: number)
	{
		while (this._position.x < 0) this._position.add([width, 0]);
		while (this.position.x > width) this._position.add([-width, 0]);

		while (this._position.y < 0) this._position.add([0, height]);
		while (this.position.y > width) this._position.add([0, -height]);
	}
}
