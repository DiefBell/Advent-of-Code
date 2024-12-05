import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.logging.*;

public class AdventOfCode
{
    private static final Logger logger = Logger.getLogger(AdventOfCode.class.getName());

    public static Input parseInputFile()
    {
        String filePath = "input.txt";

		String content;
		try
        {
            content = Files.readString(Paths.get(filePath)); // Java 11 and above
            String[] parts = content.split("\n\n", 2);

            String[] rulesStrings = parts[0].split("\n");

            Rules rules = new Rules();
            for(String ruleString : rulesStrings)
            {
                String[] ruleParts = ruleString.split("\\|", 2);
                Integer before = Integer.valueOf(ruleParts[0]);
                Integer after = Integer.valueOf(ruleParts[1]);

                if(!rules.containsKey(after))
                {
                    rules.put(after, new HashSet<>());
                }
                rules.get(after).add(before);
            }

            String[] updatesStrings = parts[1].split("\n");
            String[][] updateValueStrings = Arrays.stream(updatesStrings)
                .map(s -> s.split(","))  // Split each string by space
                .toArray(String[][]::new);  // Collect as a 2D array
            Integer[][] updates = Arrays.stream(updateValueStrings)
                .map(innerArray -> Arrays.stream(innerArray)
                    .map(Integer::parseInt)  // Parse each string to Integer
                    .toArray(Integer[]::new)) // Collect the result into Integer[]
                .toArray(Integer[][]::new);  // Collect the result into a 2D Integer array

            return new Input(
                rules,
                updates
            );
        }
        catch (IOException e)
        {
            throw new RuntimeException("An error occurred while reading the file", e);
        }
    }

    private static Integer GetValidUpdateMiddle(Rules rules, Integer[] update)
    {
        Set<Integer> blacklist = new HashSet<>();
        // integer division, rounds down
        int middleIndex = update.length / 2;
        Integer middle = null;

        for(int i = 0; i < update.length; i++)
        {
            Integer value = update[i];

            if(blacklist.contains(value))
            {
                return 0;
            }

            if(i == middleIndex)
            {
                middle = value;
            }

            if(rules.containsKey(value))
            {
                blacklist.addAll(rules.get(value));
            }
        }

        return middle;
    }

    public static void main(String[] args) {
        Input input = parseInputFile();

        Rules rules = input.rules();
        Integer[][] updates = input.updates();

        Integer count = 0;
        for(Integer[] update : updates)
        {
            count += GetValidUpdateMiddle(rules, update);
        }

        logger.log(Level.INFO, count.toString());
    }
}