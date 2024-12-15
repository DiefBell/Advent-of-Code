import * as path from "path";
import * as fs from "fs";

const SAMPLE = false;

const inputPath = path.join(__dirname, SAMPLE ? "input.sample.txt" : "input.txt");
const inputText = fs.readFileSync(inputPath, "utf-8");

const [roomText, rulesText] = inputText.split("\n\n");

const movesString = rulesText.split("\n").join("");

/**
 * Converts the given robot move character to a number
 * to add/subtrace from the index of the current position in 1D
 * representing all locations in the room.
 * @param char Character. Should be "<", ">", "^", "v".
 * @param width Width of the room
 */
const charToMoveString = (char: string, width: number): number =>
{
	switch (char)
	{
		case "<":
			return -1;
		case ">":
			return 1;
		case "^":
			return -width;
		case "v":
			return width;
		default:
			throw new Error("Encountered unknown move character: " + char);
	}
};

const WALL = "#";
const ROBOT = "@";
const BOX = "O";

const partOne = () =>
{
	const roomLines = roomText.split("\n");
	const roomWidth = roomLines[0].length;
	const room = roomLines.join("").split("");

	const moves = movesString.split("").map((char) => charToMoveString(char, roomWidth));

	const wallIndices = new Set(
		room
			.map((char, index) => index)
			.filter((index) => room[index] === WALL)
	);
	const boxIndices = new Set(
		room
			.map((char, index) => index)
			.filter((index) => room[index] === BOX)
	);

	let robotIndex = room.indexOf(ROBOT);

	for (const move of moves)
	{
		const boxes: number[] = [];
		let i = robotIndex + move;
		while (boxIndices.has(i))
		{
			boxes.push(i);
			i += move;
		}

		// means next non-box position is a wall
		if(wallIndices.has(i))
		{
			continue;
		}

		// make sure we work backwards so we don't have overlapping boxes that get deleted
		for (const box of boxes.reverse())
		{
			boxIndices.delete(box);
			boxIndices.add(box + move);
		}
		robotIndex += move;
	}

	const boxesGps = Array.from(boxIndices).map((i) =>
	{
		const x = i % roomWidth;
		const y = Math.floor(i / roomWidth);

		return 100 * y + x;
	});

	const gpsTotal = boxesGps.reduce((prev, curr) => prev + curr, 0);
	console.log(`[part one] GPS total: ${gpsTotal}`);
};

const partTwo = () =>
{

};

// Just exporting to make this a module
export const day15 = () =>
{
	partOne(); // 1463512
};
day15();
