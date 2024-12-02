#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <cmath>
#include <algorithm>
#include "main.hpp"

#define TEST

namespace AdventOfCode2024 {
namespace Day02 {

using Report = std::vector<int>;

std::vector<int> splitAndParse(const std::string &input) {
    Report report;
    std::istringstream stream(input);
    std::string token;

    while (stream >> token) {
        try {
            report.push_back(std::stoi(token));
        } catch (const std::invalid_argument &) {
            std::cerr << "Invalid number: " << token << std::endl;
        } catch (const std::out_of_range &) {
            std::cerr << "Number out of range: " << token << std::endl;
        }
    }
    return report;
}

Report copy_report_without_element(Report report, int index)
{
	Report newReport;
	newReport.reserve(report.size() - 1);

	for(int i = 0; i < report.size(); i++)
	{
		if(i != index)
		{
			newReport.push_back(report[i]);
		}
	}

	return newReport;
}

bool is_safe(Report report, bool allowDampening) {
    int prevDiff;
    for (int i = 1; i < report.size(); i++) {
        int diff = report[i] - report[i - 1];

        if (std::abs(diff) < 1 || std::abs(diff) > 3) {
            if (!allowDampening) return false;
            return is_safe(copy_report_without_element(report, i-1), false)
				|| is_safe(copy_report_without_element(report, i), false)
				// Special case where we may want to remove the very first element
				|| (i == 2 && is_safe(copy_report_without_element(report, i-2), false));
        }

        if (i == 1) {
            prevDiff = diff;
            continue;
        }
        if ((prevDiff < 0) != (diff < 0)) {
            if (!allowDampening) return false;
            return is_safe(copy_report_without_element(report, i-1), false)
				|| is_safe(copy_report_without_element(report, i), false)
				// Special case where we may want to remove the very first element
				|| (i == 2 && is_safe(copy_report_without_element(report, i-2), false));
        }
        prevDiff = diff;
    }
    return true;
}

int task01(std::vector<Report> reports) {
    int safeReports = 0;
    for (int i = 0; i < reports.size(); i++) {
        if (is_safe(reports[i], false)) {
            // std::cout << "Safe report: " << i << std::endl;
            safeReports++;
        }
    }
    std::cout << "Number of safe reports without dampening: " << safeReports << std::endl;
    return safeReports;
}

int task02(std::vector<Report> reports) {
    int safeReports = 0;
    for (int i = 0; i < reports.size(); i++) {
        if (is_safe(reports[i], true)) {
            // std::cout << "Safe report: " << i << std::endl;
            safeReports++;
        }
		else
		{
			std::cout << "Unsafe report: " << i << std::endl;
		}
    }
    std::cout << "Number of safe reports with dampening: " << safeReports << std::endl;
    return safeReports;
}

} // namespace Day02
} // namespace AdventOfCode2024


int main() {
	// clear crap at start of console
	std::cout << "-\n-\n" << std::endl;

    std::ifstream inputFile(
#ifdef TEST
        "input.esina.txt"
#else
        "input.txt"
#endif
    );
    std::string fileLine;
    std::vector<AdventOfCode2024::Day02::Report> reports;

    while (getline(inputFile, fileLine)) {
        reports.push_back(AdventOfCode2024::Day02::splitAndParse(fileLine));
    }

    // int sr1 = AdventOfCode2024::Day02::task01(reports);
    int sr2 = AdventOfCode2024::Day02::task02(reports);

    return 0;
}