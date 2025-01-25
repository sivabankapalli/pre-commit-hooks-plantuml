# Pre-Commit Hook for PlantUML Diagrams

## Purpose
This repository includes a pre-commit hook to ensure `.puml` files (PlantUML diagrams) are synchronized with their corresponding `.svc` (SVG) files. It automates the generation of `.svc` files, ensuring they are always up to date and consistent with the `.puml` source.

---

## How It Works
1. When you commit changes that include `.puml` files, the pre-commit hook:
   - Identifies staged `.puml` files.
   - Processes each `.puml` file to generate a corresponding `.svc` file.
   - Stages the updated `.svc` file along with the `.puml` file.

2. If any `.puml` file contains syntax errors, the hook:
   - Stops the commit process.
   - Reports which file failed to process so you can fix it before retrying.

---

## Usage
1. Modify or create a `.puml` file, for example:
   ```plaintext
   @startuml
   Alice -> Bob: Hello
   Bob --> Alice: Hi
   @enduml

2. Stage the file(s):
   ```bash
   git add diagram.puml

3. Commit your changes:
   ```bashs
   git commit -m "Updated diagram.puml"

---

## Behavior on Errorss
1. If the .puml file has syntax errors or unsupported constructs, the hook will stop the commit and display an error message:
    ```plaintext
    Error: Failed to process diagram.puml. Check the syntax and try again.
2. Fix the error in the .puml file and reattempt the commit:
    ```bash
    git commit -m "Retry with fixed diagram"

---

## Setup
- The pre-commit hook is already included in this repository at .git/hooks/pre-commit.
- Ensure the script is executable by running:
    ```bash
    chmod +x .git/hooks/pre-commit

---

## Best Practices
- **Always Commit `.puml` Files with `.svc`**:
The hook ensures both files are synchronized.
- **Validate `.puml` Files Before Committing**:
  - Use an online PlantUML editor or IDE extensions to preview and validate diagrams.

---

## Troubleshooting

### Error: "Failed to Process `.puml` File"
- **Cause**: Syntax errors in the `.puml` file.
- **Solution**: Validate the `.puml` file and fix errors before committing.

### Error: "Pre-Commit Hook Doesn’t Run"
- **Cause**: Hook might not be executable.
- **Solution**: Ensure the hook has execute permissions:
  ```bash
  chmod +x .git/hooks/pre-commit




