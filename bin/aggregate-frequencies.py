#!/usr/bin/env python3
import argparse
import pandas as pd
from pathlib import Path

parser = argparse.ArgumentParser( description = 'Aggregate mutation frequency files for several populations.')
parser.add_argument("directory", type=str, help="Directory that contains .mut files")
parser.add_argument("outfile", type=str, help="Output filename")

args = parser.parse_args()

mutfiles = sorted( Path(args.directory).glob("p*.mut") )

for i, f in enumerate(mutfiles):
    if i == 0:
        final = pd.read_table(f, sep = " ", index_col = 0)
    else:
        tmp = pd.read_table(f, sep=" ", index_col=0)
        final = tmp.join(final, on="generation", how= "right")


(final
    .set_index("generation")
    .to_csv(args.outfile, sep=" ", index_label="generation", na_rep="NA"))
