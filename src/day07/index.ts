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
	private _nextValues: number[];

	constructor(leafValue: number, nextValues: number[])
	{
		this._leafValue = leafValue;
		this._nextValues = nextValues;
	}

	public searchForTarget(target: number, tryConcat: boolean): boolean
	{
		if(this._leafValue > target)
		{
			return false;
		}

		if(this._nextValues.length === 0)
		{
			return this._leafValue === target;
		}

		const nextValues = this._nextValues.slice(1);

		const nextValue = this._nextValues[0];

		const plus = new Tree(this._leafValue + nextValue, nextValues)
			.searchForTarget(target, tryConcat);
		const multiply = new Tree(this._leafValue * nextValue, nextValues)
			.searchForTarget(target, tryConcat);
		const concat = tryConcat
			&& new Tree(this._concatNumbers(this._leafValue, nextValue), nextValues)
				.searchForTarget(target, tryConcat);

		return plus || multiply || concat;
	}

	private _concatNumbers(left: number, right: number): number
	{
		const concat = parseInt(`${left}${right}`);
		return concat;
	}
}

const getNumberValidEquations = (tryConcat: boolean): number =>
{
	let total = 0;
	for (const equation of equations)
	{
		const { target, values } = equation;
		const tree = new Tree(values[0], values.slice(1));
		if(tree.searchForTarget(target, tryConcat))
		{
			total += equation.target;
		}
	}
	return total;
};

const part1 = () =>
{
	const total = getNumberValidEquations(false);
	console.log(`Total WITHOUT concat operator: ${total}`);
};

const part2 = () =>
{
	const total = getNumberValidEquations(true);
	console.log(`Total WITH concat operator: ${total}`);
};

console.time("Part One");
part1();
console.timeEnd("Part One");

console.time("Part Two");
part2();
console.timeEnd("Part Two");
