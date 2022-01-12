#!/usr/bin/env python3
import pandas as pd
import pathlib
import sys
from scipy.stats import mstats
from argparse import ArgumentParser

parser = ArgumentParser(description="Winsorizes the input CSV file")
parser.add_argument("-l", "--lower-bound", dest="lower_bound",
                    help="lower quantile for winsorization", type=float, default=0)
parser.add_argument("-u", "--upper-bound", dest="upper_bound",
                    help="upper quantile for winsorization", type=float, default=0.1)
parser.add_argument("-c", "--column", dest="column",
                    help="column name to winsorize", type=str, required=True)
parser.add_argument("-i", "--index_column", dest="index_column",
                    help="index column (usually the market_name column)", type=str, default="market_name")
parser.add_argument("-f", "--filename", dest="filename",
                    help="file name to use as input for winsorization", type=pathlib.Path, required=True)
parser.add_argument("-t", "--target-column", dest="target_column",
                    help="winsorized column name", type=str, default=None)
parser.add_argument('--verbose', '-v', action='count', default=0)
args = parser.parse_args()

lower_bound = args.lower_bound
upper_bound = args.upper_bound
col = args.column
index_column = args.index_column
filename = args.filename
verbose = args.verbose
target_column = args.target_column or ('%s_winsorized' % col)

if verbose:
  print(args, file=sys.stderr)

def winsor_f(s):
  return mstats.winsorize(s, limits=[lower_bound, upper_bound], inplace=False) # between the 0-th and the 90-th quantile

input_data = pd.read_csv(filename, index_col = index_column)

for c in input_data.index.values:
  input_data.loc[input_data.index == c, target_column] = winsor_f(input_data.loc[c][col])

print(input_data.to_csv(path_or_buf=None))
