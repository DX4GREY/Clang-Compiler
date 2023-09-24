#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h> // Tambahkan ini untuk getcwd()

// Define color codes
char reset_color[] = "\033[0m";
char red_color[] = "\033[31m";
char green_color[] = "\033[32m";

void title() {
    printf("%s   (    (                        (    %s\n", red_color, reset_color);
    printf("%s   )\\   )\\    )         (  (     )\\   %s\n", red_color, reset_color);
    printf("%s (((_) ((_)( /(   (     )\\))(  (((_)  %s\n", red_color, reset_color);
    printf("%s )\\___  _  )(_))  )\\ ) ((_))\\  )\\___  %s\n", red_color, reset_color);
    printf("%s((/ __|| |((_)_  _(_/(  (()(_)((/ __| %s\n", red_color, reset_color);
    printf("%s | (__ | |/ _\\` || ' \\))/ _\\` |  | (__  %s\n", red_color, reset_color);
    printf("%s  \\___||_|\\__,_||_||_| \\__, |   \\___| %s\n", red_color, reset_color);
    printf("%s                       |___/           %s\n", red_color, reset_color);
}

void helpRun() {
    printf("usage: clangc [file]\n");
    printf("   or: clangc -u [for uninstall]\n");
    printf("\n");
    printf("Options:\n");
    printf("  -c     Open config file\n");
    printf("  -h     For show help option\n");
    printf("  -u     Uninstall this project\n");
}

int main(int argc, char *argv[]) {
    char characters_numbers[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    int length = strlen(characters_numbers);
    char shuffled[length];
    strcpy(shuffled, characters_numbers);

    // Shuffle the characters
    srand(time(NULL));
    for (int i = 0; i < length - 1; i++) {
        int j = i + rand() % (length - i);
        char temp = shuffled[i];
        shuffled[i] = shuffled[j];
        shuffled[j] = temp;
    }

    // Get a random combination of 8 characters
    char random_combination[9];
    strncpy(random_combination, shuffled, 8);
    random_combination[8] = '\0';

    // Get the current working directory
    char current[1024];
    if (getcwd(current, sizeof(current)) == NULL) {
        perror("getcwd() error");
        return 1;
    }

    // Check for the -h option
    if (argc == 2 && strcmp(argv[1], "-h") == 0) {
        // Print the help message
        helpRun();
        return 0;
    }

    // Check for the existence of a configuration file
    char *configuration = "";
    printf("%s[*]%s Checking configuration...\n", green_color, reset_color);
    if (access("~/.config/clangc.txt", F_OK) != -1) {
        // Configuration file exists, read its contents
        FILE *config_file = fopen("~/.config/clangc.txt", "r");
        if (config_file) {
            fseek(config_file, 0, SEEK_END);
            long file_size = ftell(config_file);
            fseek(config_file, 0, SEEK_SET);
            configuration = (char *)malloc(file_size + 1);
            if (configuration) {
                fread(configuration, 1, file_size, config_file);
                configuration[file_size] = '\0';
                fclose(config_file);
            }
        }
    } else {
        printf("%s[*]%s No configuration file...\n", red_color, reset_color);
        printf("%s[*]%s Continues without configuration file...\n", green_color, reset_color);
    }

    // Check if the input file exists
    if (access(argv[1], F_OK) != -1) {
        printf("%s[*]%s Checking out exist...\n", green_color, reset_color);

        // Create the output directory
        char out_directory[1024];
        snprintf(out_directory, sizeof(out_directory), "%s/.out", getenv("HOME"));
        mkdir(out_directory, 0777);

        // Compile the C program
        printf("%s[*]%s Start compile clang...\n", green_color, reset_color);
        char compile_command[1024];
        snprintf(compile_command, sizeof(compile_command), "clang -o \"%s/%s\" \"%s\" %s 2>&1", out_directory, random_combination, argv[1], configuration);
        FILE *compile_pipe = popen(compile_command, "r");
        char response[1024];
        while (fgets(response, sizeof(response), compile_pipe)) {
            printf("%s", response);
            if (strstr(response, "error")) {
                pclose(compile_pipe);
                rmdir(out_directory);
                printf("%s[*]%s Compilation failed with errors, Please fix to run...\n", red_color, reset_color);
                return 1;
            }
        }
        pclose(compile_pipe);

        // Change permissions
        printf("%s[*]%s Change root permission...\n", green_color, reset_color);
        char permission_command[1024];
        if (strcmp(getenv("TERMUX_ARCH"), "aarch64") == 0) {
            snprintf(permission_command, sizeof(permission_command), "chmod 777 \"%s/%s\"", out_directory, random_combination);
        } else {
            snprintf(permission_command, sizeof(permission_command), "chmod +x \"%s/%s\"", out_directory, random_combination);
        }
        system(permission_command);

        // Run the program
        printf("%s[*]%s Running...\n", green_color, reset_color);
        chdir(out_directory);
        printf("%s[*]%s Running Success\n", green_color, reset_color);
        sleep(1);
        printf("\n%s[*]%s OutPut:\n\n", green_color, reset_color);
        char run_command[1024];
        snprintf(run_command, sizeof(run_command), "./%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s", random_combination, argv[2], argv[3], argv[4], argv[5], argv[6], argv[7], argv[8], argv[9], argv[10], argv[11], argv[12], argv[13], argv[14], argv[15]);
        system(run_command);

        // Clean up and return
        rmdir(out_directory);
        chdir(current);
    } else {
        printf("%s[*]%s File does not exist.\n", red_color, reset_color);
    }

    return 0;
}
