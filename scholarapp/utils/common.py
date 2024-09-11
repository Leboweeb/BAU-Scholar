import itertools


DOT = "•"


def join_with_dot(l: list):
    return DOT.join(l)


def split_at_dot(s: str):
    return s.split(DOT)


def zip_if_equal(labels: list, values: list):
    """
    zips two lists together if they are both of equal length, zips with a list of empty strings otherwise.
    """
    return (
        zip(labels, values)
        if values
        else zip(labels, itertools.repeat("", len(labels)))
    )
