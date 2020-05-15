#!/usr/bin/env python
import pyarrow.parquet as pq

import argparse

parser = argparse.ArgumentParser(description='Prints the schema for the given Parquet file')
parser.add_argument('parquet_file', metavar='parquet_file', type=argparse.FileType('r'), help='path to the Parquet file')

args = parser.parse_args()

pqfile = pq.ParquetFile(args.parquet_file.name)

print(pqfile.schema)
