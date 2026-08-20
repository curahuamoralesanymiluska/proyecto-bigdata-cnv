import csv
import time
from collections import Counter

filepath = r"C:\Users\Lara\Downloads\DATOS_ABIERTOS_CNV_31122025.csv"

# Test encodings
for enc in ['utf-8', 'latin1', 'cp1252', 'iso-8859-1']:
    try:
        with open(filepath, 'r', encoding=enc) as f:
            h = f.readline()
            print(f"Encoding {enc} success, header: {h[:120]}")
            break
    except UnicodeDecodeError:
        print(f"Encoding {enc} failed")

print("\nStarting robust dataset profile...")
start_time = time.time()

total_rows = 0
years = Counter()
months = Counter()
sexos = Counter()
condiciones = Counter()
tipos_parto = Counter()
lugares = Counter()
atiendes = Counter()
financiadores = Counter()
nivel_instruccion = Counter()
estados_civiles = Counter()
null_counts = Counter()

# Numerical stats counters
weight_valid = 0
weight_sum = 0
weight_min = 99999
weight_max = -1

talla_valid = 0
talla_sum = 0
talla_min = 999
talla_max = -1

edad_valid = 0
edad_sum = 0
edad_min = 999
edad_max = -1

with open(filepath, 'r', encoding='latin1', errors='replace') as f:
    reader = csv.reader(f, delimiter=';')
    raw_header = next(reader)
    # Clean header names (remove accents and special chars)
    header = [c.replace('ñ', 'n').replace('Ñ', 'N').replace('ó', 'o').replace('Ó', 'O') for c in raw_header]
    col_count = len(header)
    
    for row in reader:
        total_rows += 1
        if len(row) != col_count:
            continue
            
        row_dict = dict(zip(header, row))
        
        # Check nulls/blanks
        for k, v in row_dict.items():
            val = v.strip()
            if not val or val in ('NULL', 'SIN INFORMACION', 'SD', 'DESCONOCIDO', '-1'):
                null_counts[k] += 1
                
        years[row_dict.get('FecNac_Ano', row_dict.get(header[0], '')).strip()] += 1
        sexos[row_dict.get('sexo_nacido', '').strip()] += 1
        condiciones[row_dict.get('Condicion_Parto', '').strip()] += 1
        tipos_parto[row_dict.get('Tipo_Parto', '').strip()] += 1
        atiendes[row_dict.get('Atiende_Parto', '').strip()] += 1
        financiadores[row_dict.get('Financiador_Parto', '').strip()] += 1
        lugares[row_dict.get('Lugar_Nacido', '').strip()] += 1
        nivel_instruccion[row_dict.get('Nivel_Intruccion_Madre', row_dict.get(header[10], '')).strip()] += 1
        estados_civiles[row_dict.get('Estado_Civil', '').strip()] += 1
        
        # Numerical parses
        try:
            w = float(row_dict.get('PESO_NACIDO', ''))
            if 300 <= w <= 7000:
                weight_valid += 1
                weight_sum += w
                if w < weight_min: weight_min = w
                if w > weight_max: weight_max = w
        except:
            pass

        try:
            t = float(row_dict.get('TALLA_NACIDO', ''))
            if 15 <= t <= 70:
                talla_valid += 1
                talla_sum += t
                if t < talla_min: talla_min = t
                if t > talla_max: talla_max = t
        except:
            pass

        try:
            em = float(row_dict.get('Edad_Madre', ''))
            if 8 <= em <= 65:
                edad_valid += 1
                edad_sum += em
                if em < edad_min: edad_min = em
                if em > edad_max: edad_max = em
        except:
            pass
        
        if total_rows % 1000000 == 0:
            print(f"Processed {total_rows:,} rows in {time.time() - start_time:.1f}s...")

elapsed = time.time() - start_time
print("\n" + "="*60)
print(f"DONE in {elapsed:.2f} seconds")
print(f"Total Rows: {total_rows:,}")
print(f"Total Columns: {col_count}")
print("\nCleaned Column Names:")
for idx, col in enumerate(header):
    print(f"  {idx+1}. {col} (Original: {raw_header[idx]})")

print("\n--- Years Distribution ---")
for y, c in sorted(years.items()):
    print(f"  {y}: {c:,} ({c/total_rows*100:.2f}%)")

print("\n--- Sex Distribution ---")
for s, c in sexos.most_common():
    print(f"  {s}: {c:,} ({c/total_rows*100:.2f}%)")

print("\n--- Delivery Condition (Condicion_Parto) ---")
for cp, c in condiciones.most_common(5):
    print(f"  {cp}: {c:,} ({c/total_rows*100:.2f}%)")

print("\n--- Attended By (Atiende_Parto) ---")
for ap, c in atiendes.most_common(5):
    print(f"  {ap}: {c:,} ({c/total_rows*100:.2f}%)")

print("\n--- Financer (Financiador_Parto) ---")
for fp, c in financiadores.most_common(5):
    print(f"  {fp}: {c:,} ({c/total_rows*100:.2f}%)")

print("\n--- Delivery Place (Lugar_Nacido) ---")
for ln, c in lugares.most_common(5):
    print(f"  {ln}: {c:,} ({c/total_rows*100:.2f}%)")

print("\n--- Mother Civil Status (Estado_Civil) ---")
for ec, c in estados_civiles.most_common(6):
    print(f"  {ec}: {c:,} ({c/total_rows*100:.2f}%)")

print("\n--- Mother Education Level ---")
for ni, c in nivel_instruccion.most_common(8):
    print(f"  {ni}: {c:,} ({c/total_rows*100:.2f}%)")

print("\n--- Numerical Summary (Averages & Ranges) ---")
if weight_valid:
    print(f"Peso (gramos): Min={weight_min:.1f}, Max={weight_max:.1f}, Avg={weight_sum/weight_valid:.2f} g (Valid: {weight_valid:,})")
if talla_valid:
    print(f"Talla (cm): Min={talla_min:.1f}, Max={talla_max:.1f}, Avg={talla_sum/talla_valid:.2f} cm (Valid: {talla_valid:,})")
if edad_valid:
    print(f"Edad Madre (anos): Min={edad_min:.1f}, Max={edad_max:.1f}, Avg={edad_sum/edad_valid:.2f} anos (Valid: {edad_valid:,})")

print("\n--- Missing / Special Value Count per Column ---")
for idx, col in enumerate(header):
    nc = null_counts[col]
    print(f"  {col:25}: {nc:,} ({nc/total_rows*100:.2f}%)")
