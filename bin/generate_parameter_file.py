#!/usr/bin/env python3

import argparse

parser = argparse.ArgumentParser( description = "Store simulation parameters in text file.")
parser.add_argument("--replicate", type =str, required=True)
parser.add_argument("--s", type =str, required=True)
parser.add_argument("--m", type =str, required=True)
parser.add_argument("--cond_freq", type =str, required=True)
parser.add_argument("--N", type =str, required=True)
parser.add_argument("--sample_size", type =str, required=True)
parser.add_argument("--sampling", type =str, required=True)
parser.add_argument("--ne_variation", type =str, required=True)
parser.add_argument("--out", type =str, required=True)

args = parser.parse_args()

outfile = args.out
header = "replicate,s,m,conditioned_frequency,N,sample_size,sampling_scheme,ne_variation"
data = [args.replicate,
        args.s,
        args.m,
        args.cond_freq,
        args.N,
        args.sample_size,
        args.sampling,
        args.ne_variation]


with open( outfile, 'w' ) as handle:

    handle.write(header+'\n')
    handle.write(','.join(data)+'\n')

