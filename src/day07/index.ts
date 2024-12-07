import * as path from "path";
import * as fs from "fs";

const USE_SAMPLE = false;

const filePath = path.join(__dirname, USE_SAMPLE ? "input.sample.txt" : "input.txt");
const content = fs.readFileSync(filePath, "utf-8");

type Equation = {
	target: number,
	values: number[],
};

const lines = content.split("\n");
const equations: Equation[] = lines.map((line) =>
{
	const [targetString, valuesString] = line.split(":");
	const target = parseInt(targetString.trim());
	const values = valuesString.trim().split(" ").map((valueString) =>
		parseInt(valueString.trim())
	);
	return { target, values };
});

class Tree
{
	private _leafValue: number;
	private _plus: Tree | null;
	private _multiply: Tree | null;
	private _isLast: boolean;

	constructor(leafValue: number, nextValues: number[])
	{
		this._leafValue = leafValue;
		this._isLast = nextValues.length === 0;

		if(this._isLast)
		{
			this._plus = null;
			this._multiply = null;
		}
		else
		{
			const nextValue = nextValues[0]!;
			const withoutFirst = nextValues.slice(1);
			this._plus = new Tree(leafValue + nextValue, withoutFirst);
			this._multiply = new Tree(leafValue * nextValue, withoutFirst);
		}
	}

	public matchesTarget(target: number): boolean
	{
		if(this._isLast)
		{
			return this._leafValue === target;
		}

		return this._plus!.matchesTarget(target) || this._multiply!.matchesTarget(target);
	}
}

let total = 0;
for (const equation of equations)
{
	const { target, values } = equation;
	const tree = new Tree(values.shift()!, values);
	if(tree.matchesTarget(target))
	{
		total += equation.target;
	}
}

console.log("Num can compute: ", total);
