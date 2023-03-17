# Assembly NPC Village
This is a program, that was made as a joke in python by some guy named uwunto, and I remade it in assembly... Best wasted hours of my life.
This is the original program:
```python
import random

names = ["Alice", "Bob", "Charlie", "David", "Eve"]
actions = ["runs", "jumps", "sleeps", "eats", "laughs", "works", "reads", "sings", "dances", "talks"]

for name in names:
    action = random.choice(actions)
    print(f"{name} {action}")
```

Firstly, I made that same program in C - [simple-village.c](./src/simple-village.c)
Then, I made another C program, just by using syscalls and making it closer to assembly - [village.c](./src/village.c)
And then - the assembly program: [village.asm](./src/village.asm)

It's x86 32-bit assembly with intel syntax, works on linux, but if you change the syscall numbers, it should work elsewhere too.
