#!/usr/bin/env python

# Really, this is more of a shell script than a python script. But some of the
# logic is just too annoying to write in a shell script, so it's into python for
# easier maintainability.

import os
import re
import subprocess
import sys

searchRe = re.compile(r'''\bread_csv\s*\(\s*(['"])([^'"]*)\1[,\)]''')

if len(sys.argv) != 2:
    print >>sys.stderr, "Usage: %s <graphtools path>" % sys.argv[0]
    sys.exit(1)

# The name of the file we use for argv[0] in later commands
maker = os.path.join(sys.argv[1], "graphmaker.py")

# Get graphs/, making sure to work if graph-all.py is not in the cwd.
graphs_dir = os.path.join(os.path.dirname(os.path.realpath(__file__)), "graphs")

for filename in os.listdir(graphs_dir):
    full = os.path.join(graphs_dir, filename)

    uses = set()
    with open(full) as fd:
        text = fd.read()
        for match in searchRe.finditer(text):
            uses.add(match.group(2))
    for f in uses:
        print f
        if not os.path.exists(f):
            print "%s can't find file %s, skipping" % (filename, f)
            break
    else:
        # In this block, we have all the files we need.
        target = os.path.splitext(filename)[0] + ".png"
        subprocess.Popen([maker, '-o', target, full])
