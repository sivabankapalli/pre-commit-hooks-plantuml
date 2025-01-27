# Pre-Commit Hook for PlantUML Diagram Generation
This repository includes a pre-commit hook that automates the generation of `.png` files from `.puml` files using the `plantuml.jar` file.

## Overview
The pre-commit hook performs the following actions:
1. Identifies staged `.puml` files for processing.
2. Detects `.puml` files in the repository that do not have corresponding `.png` files.
3. Uses the `plantuml.jar` file to generate `.png` files in the same directory as the `.puml` files.
4. Automatically stages the generated `.png` files for commit.

This ensures that `.puml` and `.png` files remain in sync and no `.puml` files are left without their associated diagrams.

## Usage
### Adding the Pre-Commit Hook
1. Ensure the `plantuml.jar` file is located in the `tools/` directory of your repository.
2. Copy the `pre-commit-plantuml-to-png.sh` script into `.git/hooks/pre-commit-plantuml-to-png`.
3. Make the script executable:
   ```bash
   chmod +x .git/hooks/pre-commit-plantuml-to-png

## Generating Diagrams
The pre-commit-plantuml-to-png hook will automatically:
- Generate `.png` files for staged `.puml` files.
- Detect existing `.puml` files in the repository without corresponding `.png` files and generate the missing diagrams.

## Example Workflow
1. **Adding a New `.puml` File**
 - Create a new `.puml` file, e.g., `example-diagram.puml`:
   ```puml
   @startuml
   Alice -> Bob: Hello
   @enduml
 - Stage and commit the file:
   ```bash
   git add example-diagram.puml
   git commit -m "Add example diagram"
 - The hook will:
   - Generate `example-diagram.png` in the same directory.
   - Add `example-diagram.png` to the commit.

2. **Handling Missing `.png` Files**
 - If a `.puml` file exists without a `.png` file, the hook will detect it during the next commit and generate the missing `.png` file automatically.

3. **Updating an Existing `.puml` File**
 - Modify the content of a .puml file, stage it, and commit:
   ```bash
   git add existing-diagram.puml
   git commit -m "Update diagram"
 - The hook will regenerate the corresponding `.png` file and include it in the commit.

## Behavior on Errorss
1. If the .puml file has syntax errors or unsupported constructs, the hook will stop the commit and display an error message:
    ```plaintext
    Error: Failed to process diagram.puml. Check the syntax and try again.
2. Fix the error in the .puml file and reattempt the commit:
    ```bash
    git commit -m "Retry with fixed diagram"

## Setup
- Downnload plantuml.jar from https://sourceforge.net/projects/plantuml/files/plantuml.jar/download and copy to tools folder under your project folder.
- The pre-commit-plantuml-to-png hook is already included in this repository at .git/hooks/pre-commit-plantuml-to-png.
- Ensure the script is executable by running:
    ```bash
    chmod +x .git/hooks/pre-commit-plantuml-to-png

## Dependencies
**Required Files**
 - `plantuml.jar`: Must be located in the `tools/` directory.
**Environment**
 - Ensure Java is installed and available in the system's PATH:
   ```bash
   java -version

## Known Limitations
- The pre-commit hook requires Java to be available on all team members' machines.
- Large .puml files may take additional time to process.

## Best Practices
- **Always Commit `.puml` Files with `.png`**:
   - The hook ensures both files are synchronized.
- **Validate `.puml` Files Before Committing**:
  - Use an online PlantUML editor or IDE extensions to preview and validate diagrams.

## Troubleshooting
### Error: "Failed to Process `.puml` File"
- **Cause**: Syntax errors in the `.puml` file.
- **Solution**: Validate the `.puml` file and fix errors before committing.

### Error: Failed to generate PNG for <file>.puml
- **Cause**: Ensure the `.puml` file syntax is correct.
- **Solution**: Validate manually:
   ```bash
   java -jar tools/plantuml.jar -tpng <file>.puml

### Error: Java Not Found
- **Cause**: Java not installed on your system
- **Solution**: Ensure Java is installed:
   ```bash
   java -version

### Error: Missing `plantuml.jar`
- **Cause**: `plantyml.jar` is not present under `tools/plantuml.jar`
- **Solution**: Verify that `plantuml.jar` exists in the `tools/` directory.

### Error: "Pre-Commit Hook Doesn’t Run"
- **Cause**: Hook might not be executable.
- **Solution**: Ensure the hook has execute permissions:
  ```bash
  chmod +x .git/hooks/pre-commit-plantuml-to-png

## Contributing
Contributions are welcome! Feel free to open a pull request or submit issues to improve the hook or documentation.

## License
This project is licensed under the [MIT License]([LICENSE](https://github.com/sivabankapalli/pre-commit-hooks-plantuml-to-png/blob/main/LICENSE)). You are free to use, modify, and distribute this project under the terms of the license.

## Contract
For questions or support, please reach out to the repository maintauner `Siva.Bankapalli@yahoo.com`
