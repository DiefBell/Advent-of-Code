import re as regex
from typing import cast

type InputPair = tuple[int, int]

INPUT_FILE: str = "./input.txt"

'''
Parses the file string, returning a list of tuples of values to multiply together.
'''
def parse_file(file_input: str) -> list[InputPair]:
	muls: list[str] = regex.findall("mul\\(\\d+,\\d+\\)", file_input)
	pairs: list[InputPair] = []

	for m in muls:
		num_strings = cast(tuple[str, str], regex.findall("\\d+", m))
		pair = cast(InputPair, tuple(int(s) for s in num_strings))
		pairs.append(pair)
	
	return pairs

if __name__ == "__main__":
	f = open(INPUT_FILE, "r")
	fileContent = f.read()
	pairs = parse_file(fileContent)
	result = sum(a * b for a, b in pairs)
	print(f"Result: {result}")