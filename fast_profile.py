import csv
import json
import time
from collections import Counter

filepath = r"C:\Users\Lara\Downloads\DATOS_ABIERTOS_CNV_31122025.csv"
output_file = r"C:\Users\Lara\.gemini\antigravity-ide\scratch\proyecto-bigdata-cnv\dataset_stats.json"

print(f"Reading {filepath}...")
start = time.time()

stats = {
    "total_rows": 0,
    "columns": [],
    "years": Counter(),
    "months": Counter(),
    "sexo": Counter(),
    "condicion_parto": Counter(),
    "tipo_parto": Counter(),
    "lugar_nacido": Counter(),
    "atiende_parto": Counter(),
    "financiador_parto": Counter(),
    "nivel_instruccion": Counter(),
    "estado_civil": Counter(),
    "edad_madre_stats": {"min": 999, "max": -1, "sum": 0, "count": 0},
    "peso_stats": {"min": 99999, "max": -1, "sum": 0, "count": 0},
    "talla_stats": {"min": 999, "max": -1, "sum": 0, "count": 0},
    "dur_emb_stats": {"min": 999, "max": -1, "sum": 0, "count": 0},
    "null_counts": Counter(),
    "top_ubigeos": Counter(),
    "top_ocupaciones": Counter()
}

with open(filepath, 'r', encoding='latin1', errors='replace') as f:
    reader = csv.reader(f, delimiter=';')
    raw_header = next(reader)
    clean_header = [c.replace('ñ', 'n').replace('Ñ', 'N').replace('ó', 'o').replace('Ó', 'O').strip() for c in raw_header]
    stats["columns"] = clean_header
    stats["raw_columns"] = raw_header
    
    total = 0
    for row in reader:
        total += 1
        if len(row) != len(clean_header):
            continue
            
        d = dict(zip(clean_header, row))
        
        for k, v in d.items():
            val = v.strip()
            if not val or val in ('NULL', 'SIN INFORMACION', 'SD', 'DESCONOCIDO', '-1'):
                stats["null_counts"][k] += 1
                
        stats["years"][d.get('FecNac_Ano', d.get(clean_header[0], '')).strip()] += 1
        stats["months"][d.get('FecNac_Mes', '').strip()] += 1
        stats["sexo"][d.get('sexo_nacido', '').strip()] += 1
        stats["condicion_parto"][d.get('Condicion_Parto', '').strip()] += 1
        stats["tipo_parto"][d.get('Tipo_Parto', '').strip()] += 1
        stats["lugar_nacido"][d.get('Lugar_Nacido', '').strip()] += 1
        stats["atiende_parto"][d.get('Atiende_Parto', '').strip()] += 1
        stats["financiador_parto"][d.get('Financiador_Parto', '').strip()] += 1
        stats["nivel_instruccion"][d.get('Nivel_Intruccion_Madre', d.get(clean_header[10], '')).strip()] += 1
        stats["estado_civil"][d.get('Estado_Civil', '').strip()] += 1
        stats["top_ubigeos"][d.get('IdUbigeoInei', '').strip()[:2]] += 1 # Department code
        stats["top_ocupaciones"][d.get('DESC_OCUPACION', '').strip()] += 1

        # Numerical fields
        try:
            em = float(d.get('Edad_Madre', ''))
            if 8 <= em <= 65:
                s = stats["edad_madre_stats"]
                s["count"] += 1
                s["sum"] += em
                if em < s["min"]: s["min"] = em
                if em > s["max"]: s["max"] = em
        except:
            pass

        try:
            p = float(d.get('PESO_NACIDO', ''))
            if 200 <= p <= 7500:
                s = stats["peso_stats"]
                s["count"] += 1
                s["sum"] += p
                if p < s["min"]: s["min"] = p
                if p > s["max"]: s["max"] = p
        except:
            pass

        try:
            t = float(d.get('TALLA_NACIDO', ''))
            if 10 <= t <= 75:
                s = stats["talla_stats"]
                s["count"] += 1
                s["sum"] += t
                if t < s["min"]: s["min"] = t
                if t > s["max"]: s["max"] = t
        except:
            pass

        try:
            dur = float(d.get('DUR_EMB_PARTO', ''))
            if 15 <= dur <= 50:
                s = stats["dur_emb_stats"]
                s["count"] += 1
                s["sum"] += dur
                if dur < s["min"]: s["min"] = dur
                if dur > s["max"]: s["max"] = dur
        except:
            pass

    stats["total_rows"] = total

# Convert counters to dicts for json
json_stats = {
    "total_rows": stats["total_rows"],
    "columns_count": len(stats["columns"]),
    "columns": stats["columns"],
    "raw_columns": stats["raw_columns"],
    "years": dict(sorted(stats["years"].items())),
    "months": dict(sorted(stats["months"].items())),
    "sexo": dict(stats["sexo"].most_common()),
    "condicion_parto": dict(stats["condicion_parto"].most_common(10)),
    "tipo_parto": dict(stats["tipo_parto"].most_common(10)),
    "lugar_nacido": dict(stats["lugar_nacido"].most_common(10)),
    "atiende_parto": dict(stats["atiende_parto"].most_common(10)),
    "financiador_parto": dict(stats["financiador_parto"].most_common(10)),
    "nivel_instruccion": dict(stats["nivel_instruccion"].most_common(10)),
    "estado_civil": dict(stats["estado_civil"].most_common(10)),
    "department_counts": dict(stats["top_ubigeos"].most_common(30)),
    "top_ocupaciones": dict(stats["top_ocupaciones"].most_common(15)),
    "edad_madre": {
        "min": stats["edad_madre_stats"]["min"],
        "max": stats["edad_madre_stats"]["max"],
        "avg": round(stats["edad_madre_stats"]["sum"] / max(1, stats["edad_madre_stats"]["count"]), 2),
        "count": stats["edad_madre_stats"]["count"]
    },
    "peso": {
        "min": stats["peso_stats"]["min"],
        "max": stats["peso_stats"]["max"],
        "avg": round(stats["peso_stats"]["sum"] / max(1, stats["peso_stats"]["count"]), 2),
        "count": stats["peso_stats"]["count"]
    },
    "talla": {
        "min": stats["talla_stats"]["min"],
        "max": stats["talla_stats"]["max"],
        "avg": round(stats["talla_stats"]["sum"] / max(1, stats["talla_stats"]["count"]), 2),
        "count": stats["talla_stats"]["count"]
    },
    "duracion_embarazo": {
        "min": stats["dur_emb_stats"]["min"],
        "max": stats["dur_emb_stats"]["max"],
        "avg": round(stats["dur_emb_stats"]["sum"] / max(1, stats["dur_emb_stats"]["count"]), 2),
        "count": stats["dur_emb_stats"]["count"]
    },
    "null_counts": dict(stats["null_counts"])
}

with open(output_file, 'w', encoding='utf-8') as f:
    json.dump(json_stats, f, indent=2, ensure_ascii=False)

print(f"Finished profiling in {time.time() - start:.2f}s. Saved to {output_file}")
