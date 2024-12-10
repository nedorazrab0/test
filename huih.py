#!/usr/bin/env python3

def main():
    a = 0
    for i in range(2147483647):
        a = a + 1

    return a

if __name__ == "__main__":
    print(main())
