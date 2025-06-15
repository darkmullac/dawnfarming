#!/usr/bin/env python3
import sys
import os
import csv

SAVE_FILE = "last_import.txt"


def read_input():
    data = None
    if len(sys.argv) > 1 and sys.argv[1] != '-':
        with open(sys.argv[1], 'r', encoding='utf-8') as f:
            data = f.read()
    else:
        if len(sys.argv) > 1 and sys.argv[1] == '-':
            print("Paste your data. Press Ctrl-D (Ctrl-Z on Windows) when done:", file=sys.stderr)
            data = sys.stdin.read()
        elif os.path.exists(SAVE_FILE):
            with open(SAVE_FILE, 'r', encoding='utf-8') as f:
                data = f.read()
        else:
            print("Paste your data. Press Ctrl-D (Ctrl-Z on Windows) when done:", file=sys.stderr)
            data = sys.stdin.read()

    with open(SAVE_FILE, 'w', encoding='utf-8') as f:
        if data:
            f.write(data)
    return [line.strip() for line in (data or '').splitlines() if line.strip()]


def parse_line(line):
    parts = line.split()
    if len(parts) < 6:
        return None
    name = parts[0]
    level = int(parts[1])
    ilevel = int(parts[2])
    classname = parts[3]
    username = parts[-1]
    spec = " ".join(parts[4:-1])
    return {
        'name': name,
        'level': level,
        'ilevel': ilevel,
        'class': classname,
        'spec': spec,
        'user': username,
    }


def make_groups(characters):
    chars = characters[:]
    groups = []
    while True:
        used = set()
        group = []
        indices = []
        for i, c in enumerate(chars):
            if c['user'] not in used:
                used.add(c['user'])
                group.append(c)
                indices.append(i)
                if len(group) == 5:
                    break
        if len(group) == 5:
            for idx in reversed(indices):
                chars.pop(idx)
            groups.append(group)
        else:
            break
    return groups, chars


def output_groups(groups, leftover):
    for g in groups:
        for c in g:
            print(f"{c['name']} {c['level']}")
        print()
    if leftover:
        for c in leftover:
            print(f"{c['name']} {c['level']}")


def export_csv(groups, leftover, path='groups.csv'):
    with open(path, 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile)
        for g in groups:
            for c in g:
                writer.writerow([c['name'], c['level']])
            writer.writerow([])
        if leftover:
            for c in leftover:
                writer.writerow([c['name'], c['level']])


def main():
    lines = read_input()
    chars = []
    for line in lines:
        c = parse_line(line)
        if c:
            chars.append(c)
    groups, leftover = make_groups(chars)
    output_groups(groups, leftover)
    if '--csv' in sys.argv:
        export_csv(groups, leftover)


if __name__ == '__main__':
    main()
