# ClangC - Simplified C/C++ Code Compilation and Execution

ClangC is a Bash script that simplifies the process of compiling and running C/C++ code using the `clang` compiler. It is designed to work on both Android and GNU/Linux platforms, making it versatile for different development environments.

## Features

- Compile and run C/C++ code effortlessly.
- Check for compilation errors and display them.
- Install and uninstall the script as a convenient command-line tool.

## Usage

### Compile and Run Code

You can use ClangC to compile and run your C/C++ code with a single command:

```bash
clangc code.c [args]
```

- `code.c`: Path to your source code file.
- `[args]`: Optional command-line arguments for your compiled code.

If your code compiles successfully, ClangC will execute it, allowing you to provide additional arguments if needed.

### Installation

Install ClangC as a command-line tool for easy access:

```bash
bash clangc.sh-i
```

This command makes ClangC available as a system-wide command, so you can use it conveniently from any location in your terminal.

### Uninstallation

To uninstall ClangC when it's no longer needed, use:

```bash
bash clangc.sh -u
```

This command will remove the ClangC command-line tool from your system.

## Platform Support

ClangC supports both Android and GNU/Linux platforms, automatically adjusting file permissions and handling platform-specific paths as needed.

## Feedback and Contributions

If you encounter any issues or have suggestions for improvements, please don't hesitate to open an issue or submit a pull request. Your feedback is valuable in enhancing ClangC's functionality.

**Note:** Before using ClangC in a production environment, it's recommended to review and customize the script to meet your specific requirements.
``