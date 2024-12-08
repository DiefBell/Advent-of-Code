import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.logging.*;

public class AdventOfCode
{
    private static final Logger logger = Logger.getLogger(AdventOfCode.class.getName());

	/**
	 * A map of the rules,
	 * keyed by a number that should come BEFORE all of that key's values.
	 */
	private static final Rules rulesByEarliest = new Rules();
	/**
	 * A map of the rules,
	 * keyed by a number that should come AFTER all of that key's values.
	 */
	private static final Rules rulesByLatest = new Rules();
	private static Integer[][] updates;

	/**
	 * Parses the input file,
	 * saves the updates and rules to the class.
	 */
    public static void parseInputFile()
    {
        String filePath = "input.txt";

		String content;
		try
        {
            content = Files.readString(Paths.get(filePath)); // Java 11 and above
            String[] parts = content.split("\n\n", 2);

            String[] rulesStrings = parts[0].split("\n");

            for(String ruleString : rulesStrings)
            {
                String[] ruleParts = ruleString.split("\\|", 2);
                Integer before = Integer.valueOf(ruleParts[0]);
                Integer after = Integer.valueOf(ruleParts[1]);

				if(!rulesByEarliest.containsKey(before))
				{
					rulesByEarliest.put(before, new HashSet<>());
				}
				rulesByEarliest.get(before).add(after);

                if(!rulesByLatest.containsKey(after))
                {
                    rulesByLatest.put(after, new HashSet<>());
                }
                rulesByLatest.get(after).add(before);
            }

            String[] updatesStrings = parts[1].split("\n");
            String[][] updateValueStrings = Arrays.stream(updatesStrings)
                .map(s -> s.split(","))  // Split each string by space
                .toArray(String[][]::new);  // Collect as a 2D array
            updates = Arrays.stream(updateValueStrings)
                .map(innerArray -> Arrays.stream(innerArray)
                    .map(Integer::parseInt)  // Parse each string to Integer
                    .toArray(Integer[]::new)) // Collect the result into Integer[]
                .toArray(Integer[][]::new);  // Collect the result into a 2D Integer array
        }
        catch (IOException e)
        {
            throw new RuntimeException("An error occurred while reading the file", e);
        }
    }

	/**
	 * Returns a set of the indexes of any pages in the given (partial) update
	 * that are not valid for the given rules.
	 */
	private static Integer[] GetInvalidPages(Integer[] partialUpdate)
	{
		/**
		 * List of numbers we don't expect to see again.
		 */
        Set<Integer> blacklist = new HashSet<>();
		ArrayList<Integer> failIndexes = new ArrayList<>();

		for(int i = 0; i < partialUpdate.length; i++)
		{
            Integer value = partialUpdate[i];

            if(blacklist.contains(value))
			{
				failIndexes.add(i);
			}

            if(rulesByLatest.containsKey(value))
            {
                blacklist.addAll(rulesByLatest.get(value));
            }
		}

		return failIndexes.toArray(Integer[]::new);
	}

	/**
	 * For valid updates, returns the value of its middle element.
	 * Returns 0 for invalid updates.
	 */
    private static Integer GetValidUpdateMiddle(Integer[] update)
    {
		Integer[] fails = GetInvalidPages(update);
		if(fails.length != 0)
		{
			return 0;
		}

        // integer division, rounds down
        int middleIndex = update.length / 2;
        Integer middle = update[middleIndex];

        return middle;
    }

	private static void Part1()
	{
        Integer count = 0;
        for(Integer[] update : updates)
        {
            count += GetValidUpdateMiddle(update);
        }

        logger.log(
			Level.INFO,
			"Sum of middles for valid updates: {0}",
			new Object[]{count.toString()}
		);
	}

	// Method to check if there is any overlap between Integer[] and Set<Integer>
    public static boolean HasOverlap(Integer[] subArray, Set<Integer> set) {
		if(set == null)
		{
			return false;
		}

		if(subArray.length == 0)
		{
			return false;
		}

        for (Integer element : subArray) {
            if (set.contains(element)) {
                return true; // Return true if an element is found in both the array and the set
            }
        }
        return false; // No overlap
    }

	private static Integer[] SortUpdate(Integer[] partialUpdate)
	{
		Integer[] fails = GetInvalidPages(partialUpdate);
		if(fails.length == 0)
		{
			return partialUpdate;
		}

		Integer[] sortedFails = SortUpdate(fails);

		ArrayList<Integer> sortedUpdate = new ArrayList<>();

		for(
			int idx_sf = sortedFails.length - 1, idx_pu = partialUpdate.length - 1;
			idx_pu >= 0 && idx_sf >= 0;
		)
		{
			Integer sortedFailValue = sortedFails[idx_sf];
			Set<Integer> blacklist = rulesByEarliest.get(sortedFailValue);

			Integer[] updateBefore = Arrays.copyOfRange(partialUpdate, 0, idx_pu);

			if(HasOverlap(updateBefore, blacklist))
			{
				sortedUpdate.add(sortedFailValue);
				idx_sf--;
			}
			else
			{
				sortedUpdate.add(partialUpdate[idx_pu]);
				idx_pu--;
			}
		}

		Collections.reverse(sortedUpdate);
		return sortedUpdate.toArray(Integer[]::new);
	}

	/**
	 * For an invalid update, sorts it and returns the value of its middle element.
	 * Returns 0 if the update is valid.
	 */
	private static Integer GetInvalidUpdateMiddle(Integer[] update)
    {
		Integer[] fails = GetInvalidPages(update);
		if(fails.length == 0)
		{
			return 0;
		}

		Integer[] sortedUpdate = SortUpdate(update);

        // integer division, rounds down
        int middleIndex = sortedUpdate.length / 2;
        Integer middle = sortedUpdate[middleIndex];

        return middle;
    }

	private static void Part2()
	{
        Integer count = 0;
        for(Integer[] update : updates)
        {
            count += GetInvalidUpdateMiddle(update);
        }

		logger.log(
			Level.INFO,
			"Sum of middles of sorted invalid updates: {0}",
			new Object[]{count.toString()}
		);
	}

    public static void main(String[] args) {
        parseInputFile();
		Part1();
		Part2(); // > 4791
    }
}
