import * as path from "path";
import * as fs from "fs";

const SAMPLE = true;

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
	console.log("\n=== Part One ===");
	console.time("Part One");
	const roomLines = roomText.split("\n");
	const roomWidth = roomLines[0].length;
	const room = roomLines.join("").split("");

	const moves = movesString.split("").map((char) => charToMoveString(char, roomWidth));

	const wallIndices = new Set(
		room
			.map((char, index) => index)
			.filter((index) => room[index] === WALL)
	);
	console.log("Walls", wallIndices.size);

	const boxIndices = new Set(
		room
			.map((char, index) => index)
			.filter((index) => room[index] === BOX)
	);
	console.log("Boxes", boxIndices.size);

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
	console.log(`GPS total: ${gpsTotal}`);
	console.timeEnd("Part One");
};

const partTwo = () =>
{
	console.log("\n=== Part Two ===");
	console.time("Part Two");

	type Box = {
		leftIndex: number,
		rightIndex: number,
	};

	const WIDE_BOX_LEFT = "[";
	const WIDE_BOX_RIGHT = "]";

	let doubleRoomStr = "";
	for (const char of Array.from(roomText))
	{
		switch (char)
		{
			case "\n":
				doubleRoomStr += "\n";
				break;
			case ".":
				doubleRoomStr += "..";
				break;
			case ROBOT:
				doubleRoomStr += ROBOT + ".";
				break;
			case WALL:
				doubleRoomStr += WALL + WALL;
				break;
			case BOX:
				doubleRoomStr += WIDE_BOX_LEFT + WIDE_BOX_RIGHT;
				break;
			default:
				throw new Error(`Encountered unknown room input value: "${char}"`);
		}
	}
	console.log(doubleRoomStr);

	const roomWidth = doubleRoomStr[0].length;
	const doubleRoom = doubleRoomStr.split("\n").join("").split("");

	const moves = movesString.split("").map((char) => charToMoveString(char, roomWidth));

	const wallIndices = new Set(
		doubleRoom
			.map((char, index) => index)
			.filter((index) => doubleRoom[index] === WALL)
	);
	console.log("Walls", wallIndices.size);

	const boxIndices = new Set(
		doubleRoom
			.map((char, index) => index)
			.filter(
				(index) => doubleRoom[index] === WIDE_BOX_LEFT || doubleRoom[index] === WIDE_BOX_RIGHT
			)
	);
	console.log("Boxes", boxIndices.size / 2);

	const boxes: Record<number, Box> = {};
	boxIndices.forEach(
		(idx) =>
		{
			// In initial setup, all boxes' left side will be on even position
			if(idx % 2 !== 0) return;
			const box: Box = {
				leftIndex: idx,
				rightIndex: idx + 1,
			};
			boxes[idx] = box;
			boxes[idx + 1] = box;
		}
	);

	let robotIndex = doubleRoom.indexOf(ROBOT);

	for (const move of moves)
	{
		const horizontal = Math.abs(move) === 1; // left or right movement
		const newBoxes: Box[] = [];

		let i = robotIndex + move;
		let box = boxes[i];
		while (box !== undefined)
		{
			delete boxes[box.leftIndex];
			delete boxes[box.rightIndex];
			newBoxes.push({
				leftIndex: box.leftIndex + move,
				rightIndex: box.rightIndex + move,
			});

			i += horizontal ? move * 2 : move;
			box = boxes[i];
		}

		// means next non-box position is a wall
		if(wallIndices.has(i))
		{
			continue;
		}

		// make sure we work backwards so we don't have overlapping boxes that get deleted
		for (const newBox of newBoxes.reverse())
		{
			boxes[newBox.leftIndex] = newBox;
			boxes[newBox.rightIndex] = newBox;
		}
		robotIndex += move;
	}

	let str = "";
	for (let i = 0; i < doubleRoom.length; i++)
	{
		if(i === robotIndex)
		{
			str += "@";
		}
		else if(wallIndices.has(i))
		{
			str += "#";
		}
		else if(boxes[i])
		{
			str += "[]";
			i++;
		}
		else
		{
			str += ".";
		}

		if((i + 1) % roomWidth === 0)
		{
			str += "\n";
		}
	}
	console.log(str);

	const boxesGps = Object.values(boxes).map((box: Box) =>
	{
		const x = box.leftIndex % roomWidth;
		const y = Math.floor(box.leftIndex / roomWidth);

		return 100 * y + x;
	});

	const gpsTotal = boxesGps.reduce((prev, curr) => prev + curr, 0);
	console.log(`GPS total: ${gpsTotal}`);
	console.timeEnd("Part Two");
};

// Just exporting to make this a module
export const day15 = () =>
{
	partOne(); // 1463512
	partTwo();
};
day15();
