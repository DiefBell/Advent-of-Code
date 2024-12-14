import * as fs from "fs";
import * as path from "path";

const SAMPLE = false;
const FILE_PATH = path.join(__dirname, SAMPLE ? "input.sample.txt" : "input.txt");

const fileContent = fs.readFileSync(FILE_PATH, "utf-8");

type Vec2 = [number, number];

class Robot
{
	public readonly startPos: Vec2;
	public readonly velocity: Vec2;

	constructor(
		startPos: Vec2,
		velocity: Vec2
	)
	{
		this.startPos = startPos;
		this.velocity = velocity;
	}
}

const robots = new Array<Robot>();

for (const line of fileContent.split("\n"))
{
	const [left, right] = line.split(" ");
	const startPos = left.replace("p=", "").split(",").map((s) => parseInt(s)) as Vec2;
	const velocity = right.replace("v=", "").split(",").map((s) => parseInt(s)) as Vec2;
	robots.push(
		new Robot(
			startPos, velocity
		)
	);
}

const ITERATIONS = 100;
const WIDTH = SAMPLE ? 11 : 101;
const HEIGHT = SAMPLE ? 7 : 103;

const quadrants = [0, 0, 0, 0];
for (const robot of robots)
{
	let finalX = robot.startPos[0] + (ITERATIONS * robot.velocity[0]);
	while (finalX < 0) finalX += WIDTH;
	while (finalX >= WIDTH) finalX -= WIDTH;

	let finalY = robot.startPos[1] + (ITERATIONS * robot.velocity[1]);
	while (finalY < 0) finalY += HEIGHT;
	while (finalY >= HEIGHT) finalY -= HEIGHT;

	// const finalPosition = [
	// 	finalX % WIDTH,
	// 	finalY % HEIGHT,
	// ];

	if(finalX === ((WIDTH - 1) / 2) || finalY === ((HEIGHT - 1) / 2))
	{
		continue;
	}

	const left = finalX < (WIDTH - 1) / 2;
	const top = finalY < (HEIGHT - 1) / 2;

	console.log([finalX, finalY]);

	if(top)
	{
		if(left)
		{
			quadrants[0] += 1;
		}
		else
		{
			quadrants[1] += 1;
		}
	}
	else
	{
		if(left)
		{
			quadrants[2] += 1;
		}
		else
		{
			quadrants[3] += 1;
		}
	}
}

console.log(quadrants);
console.log(quadrants[0] * quadrants[1] * quadrants[2] * quadrants[3]);
