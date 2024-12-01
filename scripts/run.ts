import * as path from "node:path";

const [,, dayNo, taskNo ] = Bun.argv;
const filePath = path.join(__dirname, "..", "src", dayNo, taskNo, "index.ts");

console.info(`Running code at: "${filePath}\n"`);
await import(filePath);
