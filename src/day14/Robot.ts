import { type Vector2 } from "./Vector2";

export class Robot
{
	private _position: Vector2;
	public get position(): Readonly<Vector2>
	{
		return this._position.clone();
	}

	private readonly _velocity: Vector2;

	constructor(startPosition: Vector2, velocity: Vector2)
	{
		this._position = startPosition;
		this._velocity = velocity;
	}

	public move(): void
	{
		this._position.add(this._velocity);
	}
}
