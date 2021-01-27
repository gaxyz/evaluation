#!/usr/bin/env python3
import argparse
import glob

parser = argparse.ArgumentParser(description="Collect simulation parameters into single file.")
parser.add_argument("--out", type=str, required=True)
parser.add_argumnet("--extension", type=str, required=True)


args = parser.parse_args()

outfile = args.out
extension = args.extension

files = glob.glob("*" + extension)

header = "replicate,s,m,conditioned_frequency,N,sample_size,sampling_scheme,ne_variation"


with open(outfile, 'w') as handle:

    handle.write(header+'\n')
    for f in files:
        with open(f, 'r') as infile:
            data = infile.readline().strip()
        handle.write(data + '\n')
