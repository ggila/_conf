from collections import Counter

letters = 'abcdefghijklmnopqrstuvwxyz'

def check(line):
    error = [letter for i, j in enumerate(letters)
                    if line[i] != letter]

def compute_stats(lines):
    stats = Counter()
    for line in lines:
        error = check(line)
        stats.update(error)

def print_res(stats):

    

with open('.blindkey.txt') as f:
    lines = f.readlines()
    do(lines)
    do(lines[-10:])
    stats_all = compute_stats(lines)
    stats_ten_last = compute_stats(lines[-10:])
    print_stats(stats_all, -1)
    print_stats(stats_last_ten, 10)

