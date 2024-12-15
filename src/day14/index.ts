import * as fs from "fs";
import * as path from "path";
import { Vector2 } from "./Vector2";
import { Robot } from "./Robot";

const SAMPLE = false;
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

const ITERATIONS = 100;
const WIDTH = SAMPLE ? 11 : 101;
const HEIGHT = SAMPLE ? 7 : 103;

const quadrants = [0, 0, 0, 0];
for (let i = 0; i < ITERATIONS; i++)
{
	for (const robot of robots)
	{
		robot.move();
	}
}

for (const robot of robots)
{
	let finalX = robot.position.x;
	while (finalX < 0) finalX += WIDTH;
	while (finalX >= WIDTH) finalX -= WIDTH;

	let finalY = robot.position.y;
	while (finalY < 0) finalY += HEIGHT;
	while (finalY >= HEIGHT) finalY -= HEIGHT;

	if(finalX === ((WIDTH - 1) / 2) || finalY === ((HEIGHT - 1) / 2))
	{
		continue;
	}

	const left = finalX < (WIDTH - 1) / 2;
	const top = finalY < (HEIGHT - 1) / 2;

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
