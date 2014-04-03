import os
import subprocess

import settings

def winepath(windowspath):
    """Convert a Windows path to a Unix path."""
    return subprocess.check_output(["winepath", "-u", windowspath])[:-1]

def search_startswith(a, elems):
    """Search for the first element of the array a that startswith any of the
    members of elems, and return it. Return None if no match was found."""
    for e in elems:
        if a.startswith(e):
            return e
    return None

def popen_faketime(*args, **kwargs):
    """Does subprocess.Popen after setting faketime environment variables."""
    return subprocess.Popen(*args, **kwargs)
