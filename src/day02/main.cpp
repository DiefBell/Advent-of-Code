#include <stdio.h>
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>
#include <cmath>

#define Report std::vector<int>

/**
 * @brief Splits a string by spaces, parses the substrings into integers, and returns them as a vector.
 *
 * This function takes a space-separated string of numbers, splits it into individual tokens,
 * converts each token to an integer, and stores the integers in a vector. Invalid tokens
 * (non-numeric or out-of-range values) are skipped, and a warning is printed to the standard error stream.
 *
 * @param input The input string containing space-separated numbers.
 * @return A vector of integers parsed from the input string.
 *
 * @note If a token cannot be converted to an integer, it is ignored, and a warning message is printed.
 */
std::vector<int> splitAndParse(const std::string &input)
{
	Report report;
	std::istringstream stream(input);
	std::string token;

	while (stream >> token)
	{ // Extract tokens separated by spaces
		try
		{
			report.push_back(std::stoi(token)); // Convert token to integer and add to result
		}
		catch (const std::invalid_argument &e)
		{
			std::cerr << "Invalid number: " << token << std::endl;
		}
		catch (const std::out_of_range &e)
		{
			std::cerr << "Number out of range: " << token << std::endl;
		}
	}
	return report;
}

/**
 * A report only counts as safe if both of the following are true:
 *   - The levels are either all increasing or all decreasing.
 *   - Any two adjacent levels differ by at least one and at most three.
 */
bool is_safe(Report report)
{
	int prevDiff;
	for(size_t i = 1; i < report.size(); i++)
	{
		int diff = report[i] - report[i-1];

		if(std::abs(diff) < 1 || std::abs(diff) > 3)
		{
			return false;
		}
		
		// Special case: if this is the very first element
		if(i == 1)
		{
			prevDiff = diff;
			continue;
		}

		// check signs aren't different
		if(prevDiff < 0 != diff < 0)
		{
			return false;
		}

		prevDiff = diff;
	}

	return true;
}

int main()
{
	std::ifstream inputFile("input.txt");
	std::string fileLine;

	std::vector<Report> reports;

	while (getline(inputFile, fileLine))
	{
		Report report = splitAndParse(fileLine);
		reports.push_back(report);
	}

	int safeReports = 0;
	for(size_t i = 0; i < reports.size(); i++)
	{
		Report report = reports[i];
		if(is_safe(report))
		{
			safeReports++;
		}
	}

	std::cout << "Number of safe reports: " << safeReports << std::endl;

	return 0;
}
