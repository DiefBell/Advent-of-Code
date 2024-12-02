#ifndef ADVENT_OF_CODE_2024_DAY_2_H
#define ADVENT_OF_CODE_2024_DAY_2_H

#include <vector>
#include <string>

namespace AdventOfCode2024 {
namespace Day02 {
// Type alias for a report
using Report = std::vector<int>;

/**
 * @brief Splits a string by spaces, parses the substrings into integers, and returns them as a vector.
 *
 * This function takes a space-separated string of numbers, splits it into individual tokens,
 * converts each token to an integer, and stores the integers in a vector. Invalid tokens
 * (non-numeric or out-of-range values) are skipped, and a warning is printed to the standard error stream.
 *
 * @param input The input string containing space-separated numbers.
 * @return A vector of integers parsed from the input string.
 */
std::vector<int> splitAndParse(const std::string &input);

/**
 * @brief Creates a copy of a report, except with the element at `index` removed.
 * 
 * @param report Report to copy.
 * @param index Index of element to not copy.
 * @return A new report with the element at `index` removed.
 */
Report copy_report_without_element(Report report, int index);

/**
 * @brief Determines if a report is safe based on two conditions:
 *   - The levels are either all increasing or all decreasing.
 *   - Any two adjacent levels differ by at least one and at most three.
 *
 * @param report The input report.
 * @param allowDampening Whether dampening is allowed to make the report safe.
 * @return True if the report is safe, otherwise false.
 */
bool is_safe(Report report, bool allowDampening);

/**
 * @brief Processes a list of reports to count those that are safe without dampening.
 *
 * @param reports A vector of reports to process.
 * @return The number of safe reports without dampening.
 */
int task01(std::vector<Report> reports);

/**
 * @brief Processes a list of reports to count those that are safe with dampening.
 *
 * @param reports A vector of reports to process.
 * @return The number of safe reports with dampening.
 */
int task02(std::vector<Report> reports);

} // namespace Day02
} // namespace AdventOfCode2024

#endif // ADVENT_OF_CODE_2024_H
