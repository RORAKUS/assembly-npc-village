#include <unistd.h>
#include <sys/random.h>

const char* names[] = {"Alice", "Bob", "Charlie", "David", "Eve"};
const char* actions[] = {"runs", "jumps", "sleeps", "eats", "laughs", "works", "reads", "sings", "dances", "talks"};

#define ACTIONS_LENGTH 10
#define NAMES_LENGTH 5
#define MAX_RESULT_LENGTH 20

int rnm;
char result[MAX_RESULT_LENGTH];

int random(int);
void merge_strings(char*, const char*, const char*);
int strlen_(const char*);

int main() {
    int ecx = 0;
    label:
        ;
        int eax = random(ACTIONS_LENGTH);
        const char* ebx = actions[eax];
        merge_strings(result, names[ecx], ebx);
        write(STDOUT_FILENO, result, strlen_(result));
        ecx++;
        if (ecx != NAMES_LENGTH) goto label;

    _exit(0);
}
int random(int max) {
    getrandom(&rnm, 4, GRND_NONBLOCK | GRND_RANDOM);
    if (rnm < 0) rnm = -rnm;
    return rnm % max;
}
void merge_strings(char* res, const char* first, const char* second) {
    int edx = 0;
    int ecx = 0;
    label1:
        if (first[ecx]=='\0') goto out;
        res[edx] = first[ecx];
        ecx++;
        edx++;
        goto label1;
    out:
    res[edx] = ' ';
    edx++;
    ecx = 0;
    label2:
        if (second[ecx]=='\0') goto out2;
        res[edx] = second[ecx];
        ecx++;
        edx++;
        goto label2;
    out2:
    res[edx] = '\n';
    edx++;
    res[edx] = '\0';
}
int strlen_(const char* string) {
    int ecx = -1;
    label1:
        ecx++;
        if (string[ecx] != '\0') goto label1;
    return ecx;
}