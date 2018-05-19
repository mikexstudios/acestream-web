#!/usr/bin/env python2.7
# Converts all *.json configuration files to their equivalent *.pickle file.
# Usage: ./json_to_pickle.py
# (Must run using python2.7 so that the generated pickle output is readable by
# acestream's unpickling).
import glob, os
import json, pickle

for json_file in glob.glob("*.json"):
  root, _ = os.path.splitext(json_file)
  j = json.load(open(json_file))
  pickle.dump(j, open(root + ".pickle", "wb"))
  print "Processed %s." % root