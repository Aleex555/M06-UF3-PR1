package cat.iesesteveterradas;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Stream;

import org.basex.api.client.ClientSession;
import org.basex.core.*;
import org.basex.core.cmd.*;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Main {
    private static final Logger logger = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) {
        // Initialize connection details
        String host = "127.0.0.1";
        int port = 1984;
        String username = "admin"; // Default username
        String password = "admin"; // Default password

        // Directory containing the XQuery files and the output directory
        String inputDirPath = "./data/input/";
        String outputDirPath = "./data/output/";

        // Establish a connection to the BaseX server
        try (ClientSession session = new ClientSession(host, port, username, password)) {
            logger.info("Connected to BaseX server.");

            // Open the desired database
            session.execute(new Open("anime.stackexchange"));

            // Create a Stream to iterate over the files in the directory
            try (Stream<Path> paths = Files.walk(Paths.get(inputDirPath))) {
                paths.filter(Files::isRegularFile).forEach(filePath -> {
                    // For each file in the directory
                    try {
                        // Read the query from the file
                        String myQuery = new String(Files.readAllBytes(filePath), StandardCharsets.UTF_8);

                        // Execute the query
                        String result = session.execute(new XQuery(myQuery));

                        // Prepare the output file path
                        Path outputFile = Paths.get(outputDirPath).resolve(filePath.getFileName().toString().replaceAll("\\..*", ".xml"));
                        
                        // Write the result to the output file
                        Files.write(outputFile, result.getBytes(StandardCharsets.UTF_8));
                        
                        logger.info("Saved query result to " + outputFile);
                    } catch (IOException e) {
                        logger.error("Error reading the query file or writing the output file: " + e.getMessage());
                    }
                });
            }
        } catch (BaseXException e) {
            logger.error("Error connecting to the BaseX server: " + e.getMessage());
        } catch (IOException e) {
            logger.error("Error establishing connection or reading files: " + e.getMessage());
        }
    }
}
