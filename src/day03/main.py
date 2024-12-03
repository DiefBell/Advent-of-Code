import re
from typing import cast

type InputPair = tuple[int, int]

INPUT_FILE: str = "./input.txt"

'''
Parses the file string, returning a list of tuples of values to multiply together.
'''
def parse_file(file_input: str, enable_do_dont: bool) -> list[InputPair]:
	pattern = re.compile("do\\(\\)|don\\'t\\(\\)|mul\\(\\d+,\\d+\\)")
	tokens: list[str] = pattern.findall(file_input)

	pairs: list[InputPair] = []

	do = True
	for token in tokens:
		if token == "do()":
			do = not enable_do_dont or True
		elif token == "don't()":
			do = not enable_do_dont or False
		elif do:
			num_strings = cast(tuple[str, str], re.findall("\\d+", token))
			pair = cast(InputPair, tuple(int(s) for s in num_strings))
			pairs.append(pair)
	
	return pairs

def part_one(fileContent: str):
	pairs = parse_file(fileContent, False)
	result = sum(a * b for a, b in pairs)
	print(f"Result for part one: {result}")

def part_two(fileContent: str):
	pairs = parse_file(fileContent, True)
	result = sum(a * b for a, b in pairs)
	print(f"Result for part two: {result}")


if __name__ == "__main__":
	f = open(INPUT_FILE, "r")
	file_content = f.read()
	part_one(file_content)
	part_two(file_content)
