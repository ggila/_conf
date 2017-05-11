from collections import Counter

letters = 'abcdefghijklmnopqrstuvwxyz'

def check(line):
    if len(line) != 26:
        return letters
    error = [
        letter for try_, letter
               in zip(line, letters)
               if try_ != letter
    ]
    return error

def compute_stats(lines):
    stats = Counter()
    for line in lines:
        error = check(line)
        stats.update(error)
    return stats

def do(lines):
    nb_tries = len(lines)
    stats = compute_stats(lines)
    nb_error = sum(stats.values())
    print 'last {} tries:'.format(nb_tries)
    prop_error = nb_error / (26.0 * nb_tries)
    print 'failed: {} ({:.1%})'.format(nb_error, prop_error)
    print 'most common mistakes:'
    for letter, nb in stats.most_common(n=3):
        prop_error = float(nb) / nb_error
        print '{}: {}/{} ({:.1%} of the error)'.format(letter, nb, nb_tries, prop_error)
    print ''

    

with open('.blindkey.txt') as f:
    lines = [l[:-1] for l in f.readlines()]
    do(lines)
    do(lines[:10])

