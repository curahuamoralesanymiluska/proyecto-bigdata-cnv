import csv
import os
import sys
import time

filepath = r"C:\Users\Lara\Downloads\DATOS_ABIERTOS_CNV_31122025.csv"

print(f"Analyzing file: {filepath}")
file_size_mb = os.path.getsize(filepath) / (1024 * 1024)
print(f"File size: {file_size_mb:.2f} MB")

start_time = time.time()

with open(filepath, 'r', encoding='latin1', errors='replace') as f:
    # Check first line / delimiter
    sample = f.readline()
    print(f"Sample header raw: {sample[:200]}...")
    delimiter = ';' if ';' in sample else (',' if ',' in sample else '\t')
    print(f"Detected delimiter: '{delimiter}'")
    
    f.seek(0)
    reader = csv.reader(f, delimiter=delimiter)
    header = next(reader)
    print(f"Total columns: {len(header)}")
    print("Columns:")
    for idx, col in enumerate(header):
        print(f"  {idx+1}. {col}")

    # Inspect first 5 rows
    print("\n--- Sample 3 rows ---")
    for i in range(3):
        try:
            row = next(reader)
            print(f"Row {i+1}: {dict(zip(header, row))}")
        except StopIteration:
            break

print(f"\nHeader reading took {time.time() - start_time:.2f}s")
