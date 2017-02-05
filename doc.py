'''
In [19]: a = object()

In [20]: a.__doc__
Out[20]: 'The most base type'

In [22]: class a(object):
    ...:     __doc__ = 'bla'
    ...:

In [23]: a?
Docstring: bla
Type:      type

'''

def facto(n, acc=1):
    '''
        >>> facto(0)
        1
        >>> facto(1)
        1
        >>> facto(6)
        720
    '''
    return acc if n <= 1 else facto(n-1, n*acc)


def facto2(n):
    '''
        >>> facto2(0)
        1
        >>> facto2(1)
        1
        >>> facto2(6)
        720
    '''
    if n <= 1:
        return 1
    else:
        return n * facto(n-1)

def facto3(n):
    '''
        >>> facto3(0)
        1
        >>> facto3(1)
        1
        >>> facto3(6)
        720
    '''
    return 1 if n <= 1 else n * facto(n-1)

def facto4(n):
    '''
        >>> facto4(0)
        1
        >>> facto4(1)
        1
        >>> facto4(6)
        720
    '''
    return n * facto(n-1) if n > 1 else 1
