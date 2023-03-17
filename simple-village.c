#include <stdio.h>
#include <stdlib.h>

const char* names[] = {"Alice", "Bob", "Charlie", "David", "Eve"};
const char* actions[] = {"runs", "jumps", "sleeps", "eats", "laughs", "works", "reads", "sings", "dances", "talks"};

#define ACTIONS_LENGTH 10
#define NAMES_LENGTH 5

int main() {

    for (int i = 0; i < NAMES_LENGTH; i++) {
        const char* action = actions[random() % ACTIONS_LENGTH];
        printf("%s %s\n", names[i], action);
    }

    return 0;
}