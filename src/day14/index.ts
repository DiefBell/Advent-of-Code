import * as fs from "fs";
import * as path from "path";
import { Vector2 } from "./Vector2";
import { Robot } from "./Robot";
import { Grid } from "./Grid";

const SAMPLE = false;
const ITERATIONS = 100;
const WIDTH = SAMPLE ? 11 : 101;
const HEIGHT = SAMPLE ? 7 : 103;

const FILE_PATH = path.join(__dirname, SAMPLE ? "input.sample.txt" : "input.txt");

const fileContent = fs.readFileSync(FILE_PATH, "utf-8");

const robots = new Array<Robot>();

for (const line of fileContent.split("\n"))
{
	const [left, right] = line.split(" ");
	const [startX, startY] = left.replace("p=", "").split(",").map((s) => parseInt(s));
	const [velocityX, velocityY] = right.replace("v=", "").split(",").map((s) => parseInt(s));
	robots.push(
		new Robot(
			new Vector2(startX, startY), new Vector2(velocityX, velocityY)
		)
	);
}

const greatestXVelocity = robots.reduce<number>(
	(prev, robot) => Math.max(prev, robot.velocity.x),
	0
);

const greatestYVelocity = robots.reduce<number>(
	(prev, robot) => Math.max(prev, robot.velocity.y),
	0
);

console.log(`Greatest velocity values: (${greatestXVelocity},${greatestYVelocity})`);

const grid = new Grid(WIDTH, HEIGHT);
for (let i = 0; i < Number.POSITIVE_INFINITY; i++)
{
	for (const robot of robots)
	{
		robot.move();
		robot.teleport(WIDTH, HEIGHT);

		grid.addToGrid(
			// add width/height to prevent negatives
			(robot.position.x + WIDTH) % WIDTH,
			(robot.position.y + HEIGHT) % HEIGHT,
			1
		);
	}

	if(i == ITERATIONS - 1)
	{
		break;
	}

	grid.reset();
}

const quadrants = grid.getQuadrants();
console.log(quadrants.topLeft * quadrants.topRight * quadrants.bottomLeft * quadrants.bottomRight);
