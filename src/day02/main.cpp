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
bool is_safe(Report report, bool allowDampener)
{
	std::vector<int> diffs;
	for (int i = 1; i < report.size(); i++)
	{
		int diff = report[i] - report[i - 1];
		diffs.push_back(diff);
	}

	// Element we're testing we could remove
	int dampenedLevel = -1;

	for (int i = 0; i < diffs.size(); i++)
	{
		int diff = diffs[i];

		bool dampenerUsed = dampenedLevel != -1;
		if (std::abs(diff) < 1 || std::abs(diff) > 3)
		{
			if (dampenerUsed || !allowDampener)
			{
				return false;
			}

			dampenedLevel = i;
			continue;
		}

		// Special case: there's no "previous" diff for first element,
		// nor the second if the first is dampened
		if (i == 0 || (i == 1 && dampenedLevel == 0))
		{
			continue;
		}

		bool usingDampener = i - 1 == dampenedLevel;
		int prevDiff;
		if (usingDampener)
		{
			prevDiff = diffs[i - 2];
			// If we're using the dampener then the current diff becomes relative
			// to the element before the dampened one
			diff = diff + diffs[i - 1];
			diffs[i] = diff;
		}
		else
		{
			prevDiff = diffs[i - 1];
		}

		// check signs aren't different
		if (prevDiff < 0 != diff < 0)
		{
			if (dampenerUsed || !allowDampener)
			{
				return false;
			}
			dampenedLevel = i;
		}
	}

	return true;
}

int task01(std::vector<Report> reports)
{
	int safeReports = 0;
	for (int i = 0; i < reports.size(); i++)
	{
		Report report = reports[i];
		if (is_safe(report, false))
		{
			safeReports++;
		}
	}

	std::cout << "Number of safe reports without dampening: " << safeReports << std::endl;

	return safeReports;
}

int task02(std::vector<Report> reports)
{
	int safeReports = 0;
	for (int i = 0; i < reports.size(); i++)
	{
		Report report = reports[i];
		if (is_safe(report, true))
		{
			safeReports++;
		}
	}

	std::cout << "Number of safe reports with dampening: " << safeReports << std::endl;

	return safeReports;
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

	int sr1 = task01(reports);
	int sr2 = task02(reports);

	if (sr1 > sr2)
	{
		std::cout << "Somehow there are more safe reports WITHOUT dampening... WTF??" << std::endl;
	}

	return 0;
}
