import { readFileSync } from "node:fs";
import { join } from "node:path";

type Input = [ number[], number[] ];

const parseInputFile = (text: string): Input =>
{
	const lines = text.split("\n");
	const input: Input = [[], []];

	for (const line of lines)
	{
		const [left, right] = line.split("   ");
		input[0].push(parseInt(left));
		input[1].push(parseInt(right));
	}

	return input;
};

/**
 * Radix sorts a list of numbers in-place.
 * @param $numbers List of numbers to sort.
 * @param maxDigits Highest number of digits that any number in the list has.
 */
function radixSort(numbers: number[], maxDigits = 5): number[]
{
	const base = 10; // Base for decimal system

	for (let digit = 0; digit < maxDigits; digit++)
	{
		// Create buckets for each digit (0-9)
		const buckets: number[][] = Array.from({ length: base }, () => []);

		// Distribute numbers into buckets based on the current digit
		for (const number of numbers)
		{
			const digitValue = Math.floor(number / Math.pow(base, digit)) % base;
			buckets[digitValue].push(number);
		}

		// Flatten buckets back into the numbers array
		numbers = ([] as number[]).concat(...buckets);
	}

	return numbers;
}

const inputPath = join(__dirname, "input.txt");
const rawInput = readFileSync(inputPath, "utf-8");
const input = parseInputFile(rawInput);

const left = radixSort(input[0]);
const right = radixSort(input[1]);

const task01 = () =>
{
	let diff = 0;
	for (let i = 0; i < left.length; i++)
	{
		diff += Math.abs(left[i] - right[i]);
	}
	console.log("Diff: ", diff);
};

const task02 = () =>
{
	let score = 0;
	let count = 0;

	for (let i = 0, j = 0; i < left.length && j < right.length;)
	{
		const l = left[i];
		const r = right[j];

		if(l === r)
		{
			count++;
			j++;

			// If this is the last element on the right, count it then leave
			if(j === right.length)
			{
				score += count * l;
				break;
			}

			continue;
		}

		// will be 0 if there wasn't a match before
		score += count * l;
		count = 0;

		l < r ? i++ : j++;
	}

	console.log("Score: ", score);
};

task01();
task02();
