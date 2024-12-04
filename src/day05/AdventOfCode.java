import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AdventOfCode {
    private static final Logger LOGGER = Logger.getLogger(AdventOfCode.class.getName());

    public static void main(String[] args) {
        String filePath = "input.txt";

		// line-by-line
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                System.out.println(line);
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "An error occurred while reading the file", e);
        }

		// whole file in single string
		try {
            String content = Files.readString(Paths.get(filePath)); // Java 11 and above
            System.out.println(content);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "An error occurred while reading the file", e);
        }
    }
}

