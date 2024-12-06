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

/**
 * Returns next valid position guard can go to,
 * and the direction she'll be facing when she gets there.
 */
const findNextPosAndDir = (mapData, pos, dir) => {
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
};

const mapData = getMapData();
part1(mapData);
