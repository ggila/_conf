'''

Algorithm for finding minimum edit distance between two words

In information theory and computer science, the Levenshtein distance is a string metric for measuring
the difference between two sequences. Informally, the Levenshtein distance between two words is the 
minimum number of single-character edits (i.e. insertions, deletions or substitutions) required to 
change one word into the other. It is named after Vladimir Levenshtein, who considered this distance
in 1965.

Levenshtein distance may also be referred to as edit distance, although that may also denote a 
larger family of distance metrics.[2]:32 It is closely related to pairwise string alignments.


The Levenshtein distance has several simple upper and lower bounds. These include:
- It is always at least the difference of the sizes of the two strings.
- It is at most the length of the longer string.
- It is zero if and only if the strings are equal.
- If the strings are the same size, the Hamming distance is an upper bound on the Levenshtein distance.
- The Levenshtein distance between two strings is no greater than the sum of their Levenshtein distances 
  from a third string (triangle inequality).

'''

########################################################################################################
#
# The first version is a Dynamic Programming algorithm, with the added optimization that only the
# last two rows of the dynamic programming matrix are needed for the computation:
########################################################################################################

def levenshtein(s1, s2):
    if len(s1) < len(s2):
        return levenshtein(s2, s1)

    # len(s1) >= len(s2)
    if len(s2) == 0:
        return len(s1)

    previous_row = range(len(s2) + 1)
    for i, c1 in enumerate(s1):
        current_row = [i + 1]
        for j, c2 in enumerate(s2):
            insertions = previous_row[j + 1] + 1 # j+1 instead of j since previous_row and current_row are one character longer
            deletions = current_row[j] + 1       # than s2
            substitutions = previous_row[j] + (c1 != c2)
            current_row.append(min(insertions, deletions, substitutions))
        previous_row = current_row
    
    return previous_row[-1]
########################################################################################################
#
# Second version:
# (Note that while very compact, the runtime of this implementation is really poor, making it unusable
# in practical usage.)
#
########################################################################################################

def lev(a, b):
    if not a: return len(b)
    if not b: return len(a)
    return min(lev(a[1:], b[1:])+(a[0] != b[0]), lev(a[1:], b)+1, lev(a, b[1:])+1)

########################################################################################################
#
# Third version (works):
# (Note that while compact, the runtime of this implementation is relatively poor.)
#
########################################################################################################

def LD(s,t):
    s = ' ' + s
    t = ' ' + t
    d = {}
    S = len(s)
    T = len(t)
    for i in range(S):
        d[i, 0] = i
    for j in range (T):
        d[0, j] = j
    for j in range(1,T):
        for i in range(1,S):
            if s[i] == t[j]:
                d[i, j] = d[i-1, j-1]
            else:
                d[i, j] = min(d[i-1, j], d[i, j-1], d[i-1, j-1]) + 1
    return d[S-1, T-1]

########################################################################################################
#
# 4th version:
# (Note this implementation is O(N*M) time and O(M) space, for N and M the lengths of the two sequences.)
#
########################################################################################################

def levenshtein(seq1, seq2):
    oneago = None
    thisrow = range(1, len(seq2) + 1) + [0]
    for x in xrange(len(seq1)):
        twoago, oneago, thisrow = oneago, thisrow, [0] * len(seq2) + [x + 1]
        for y in xrange(len(seq2)):
            delcost = oneago[y] + 1
            addcost = thisrow[y - 1] + 1
            subcost = oneago[y - 1] + (seq1[x] != seq2[y])
            thisrow[y] = min(delcost, addcost, subcost)
    return thisrow[len(seq2) - 1]

########################################################################################################
#
#   5th, a vectorized version of the 1st, using NumPy. About 40% faster, on my test case.
#
########################################################################################################

def levenshtein(source, target):
    if len(source) < len(target):
        return levenshtein(target, source)

    # So now we have len(source) >= len(target).
    if len(target) == 0:
        return len(source)

    # We call tuple() to force strings to be used as sequences
    # ('c', 'a', 't', 's') - numpy uses them as values by default.
    source = np.array(tuple(source))
    target = np.array(tuple(target))

    # We use a dynamic programming algorithm, but with the
    # added optimization that we only need the last two rows
    # of the matrix.
    previous_row = np.arange(target.size + 1)
    for s in source:
        # Insertion (target grows longer than source):
        current_row = previous_row + 1

        # Substitution or matching:
        # Target and source items are aligned, and either
        # are different (cost of 1), or are the same (cost of 0).
        current_row[1:] = np.minimum(
                current_row[1:],
                np.add(previous_row[:-1], target != s))

        # Deletion (target grows shorter than source):
        current_row[1:] = np.minimum(
                current_row[1:],
                current_row[0:-1] + 1)

        previous_row = current_row

    return previous_row[-1]




########################################################################################################
#
#   (Note this implementation only works if the weight does not depend on the character edited.)
#   
#   6th version, from Wikipedia article on Levenshtein Distance; Iterative with two matrix rows.
#   
#   Christopher P. Matthews
#   christophermatthews1985@gmail.com
#   Sacramento, CA, USA
#
########################################################################################################

def levenshtein(s, t):
        ''' From Wikipedia article; Iterative with two matrix rows. '''
        if s == t: return 0
        elif len(s) == 0: return len(t)
        elif len(t) == 0: return len(s)
        v0 = [None] * (len(t) + 1)
        v1 = [None] * (len(t) + 1)
        for i in range(len(v0)):
            v0[i] = i
        for i in range(len(s)):
            v1[0] = i + 1
            for j in range(len(t)):
                cost = 0 if s[i] == t[j] else 1
                v1[j + 1] = min(v1[j] + 1, v0[j + 1] + 1, v0[j] + cost)
            for j in range(len(v0)):
                v0[j] = v1[j]
                
        return v1[len(t)]
