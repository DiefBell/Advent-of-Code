import * as fs from "fs";
import * as path from "path";

const getMapData = () => {
	const inputFilePath = path.join(__dirname, "input.txt");
	const content = fs.readFileSync(inputFilePath, "utf-8");

	const rows = content.split("\n");
	const height = rows.length;
	const width = rows[0].length;

	return { mapString: rows.join(""), height, width };
};

let depth = 0;

/**
 * Returns next valid position guard can go to,
 * and the direction she'll be facing when she gets there.
 *
 * Throws if too many levels of recursion were reached.
 */
const findNextPosAndDir = (mapData, pos, dir) => {
	if(++depth > mapData.mapString.length) {
		depth = 0;
		throw new Error("TOO DEEP");
	}
	if(
		(dir === 0 && Math.floor(pos / mapData.width) === 0)
		|| (dir === 2 && Math.floor(pos / mapData.width) === mapData.height - 1)
		|| (dir === 1 && (pos % mapData.width) === mapData.width - 1)
		|| (dir === 3 && (pos % mapData.width) === 0)
	) {
		return { nextPos: -1, nextDir: dir };
	}

	const possibleNextPos = (dir % 2 === 0) * (pos + ((dir - 1) * mapData.width))
		+ (dir % 2 === 1) * (pos - (dir - 2));

	return mapData.mapString[possibleNextPos] === "#"
		? findNextPosAndDir(mapData, pos, (dir + 1) % 4)
		: { nextPos: possibleNextPos, nextDir: dir };
};

const part1 = (mapData) => {
	const visitedPositions = new Set();

	let dir = 0; // zero is up
	let pos = mapData.mapString.indexOf("^");

	while (pos != -1) {
		visitedPositions.add(pos);
		const { nextPos, nextDir } = findNextPosAndDir(mapData, pos, dir);
		pos = nextPos;
		dir = nextDir;
	}

	console.log("Distinct positions: ", visitedPositions.size);
	return visitedPositions;
};

const part2 = (mapData, visitedPositions) => {
	const replaceCharAt = (str, index, replacement) => {
		if(index < 0 || index >= str.length) {
			throw new Error("Index out of bounds");
		}
		return str.slice(0, index) + replacement + str.slice(index + 1);
	};

	let obstaclePositions = 0;
	for (const possibleObstactlePosition of visitedPositions) {
		const newMapData = {
			...mapData,
			mapString: replaceCharAt(mapData.mapString, possibleObstactlePosition, "#"),
		};

		depth = 0;
		try {
			let dir = 0; // zero is up
			let pos = mapData.mapString.indexOf("^");

			while (pos != -1) {
				const { nextPos, nextDir } = findNextPosAndDir(newMapData, pos, dir);
				pos = nextPos;
				dir = nextDir;
			}
		} catch (e) {
			if(e.message === "TOO DEEP") {
				obstaclePositions++;
			} else {
				throw e;
			}
		}
	}

	console.log("Number of possible obstacle positions: ", obstaclePositions);
};

const mapData = getMapData();
const visitedPositions = part1(mapData);

console.time("Part 2 execution time");
part2(mapData, visitedPositions);
console.timeEnd("Part 2 execution time");
