"""
==========================================================================================
PROYECTO ACADÉMICO: Big Data con Datos Abiertos Reales (MINSA / RENIEC - CNV Perú)
CURSO: Big Data | Escuela de Educación Superior Tecnológica La Pontificia
ARCHIVO: 05_etl_proceso.py
DESCRIPCIÓN: Pipeline ETL Completo en Python (Extracción, Limpieza, Transformación y Carga)
ENTORNO: Python 3.10+ / Pandas / SQLAlchemy / PyODBC
==========================================================================================
"""

import os
import sys
import time
import logging
from typing import Tuple, Dict
import pandas as pd
import numpy as np

# Configuración del Logger para auditoría del proceso ETL
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)]
)
logger = logging.getLogger("ETL_CNV_PERU")


# ==========================================================================================
# 1. PARÁMETROS DE CONFIGURACIÓN Y CONEXIÓN
# ==========================================================================================
CONFIG = {
    # Rutas de datos
    "input_excel_path": "DATOS_ABIERTOS_CNV_31122025.xlsx",
    "input_csv_fallback": "DATOS_ABIERTOS_CNV_31122025.csv",
    "output_clean_csv": "DATOS_LIMPIOS_CNV_TRANSFORMADOS.csv",
    
    # Parámetros de SQL Server (T-SQL)
    "db_server": "localhost",
    "db_name": "BD_CNV_BIGDATA_PERU",
    "db_user": "sa",
    "db_password": "TuPasswordSeguro123*",  # Reemplazar con credencial local
    "db_driver": "ODBC Driver 17 for SQL Server",
    "use_windows_auth": False,               # True para autenticación integrada de Windows
    
    # Tamaño de lote para Big Data
    "batch_size": 10000
}


# ==========================================================================================
# 2. FASE DE EXTRACCIÓN (E - EXTRACT)
# ==========================================================================================
def extract_dataset(filepath_excel: str, filepath_csv: str) -> pd.DataFrame:
    """
    Lee el archivo de datos original.
    Prioriza lectura de Excel (.xlsx) con pd.read_excel() según requerimiento,
    e implementa fallback a CSV delimitado por punto y coma si el Excel no está presente.
    """
    logger.info("==================================================================")
    logger.info("FASE 1: EXTRACCIÓN DE DATOS")
    logger.info("==================================================================")
    
    start_time = time.time()
    
    if os.path.exists(filepath_excel):
        logger.info(f"Leyendo archivo Excel oficial: {filepath_excel} usando pandas.read_excel()...")
        df = pd.read_excel(filepath_excel, engine="openpyxl")
    elif os.path.exists(filepath_csv):
        logger.info(f"Archivo Excel no encontrado. Leyendo archivo CSV original: {filepath_csv}...")
        df = pd.read_csv(
            filepath_csv,
            sep=";",
            encoding="latin-1",
            low_memory=False
        )
    else:
        logger.warning("No se encontró archivo físico local. Generando muestra sintética basada en datos reales para validación...")
        # Generación de muestra representativa para pruebas
        sample_data = {
            "FecNac_Año": [2025, 2025, 2025, 2024, 2024],
            "FecNac_Mes": [6, 5, 4, 12, 11],
            "PESO_NACIDO": [3450.0, 2350.0, 3120.0, 3800.0, 2400.0],
            "TALLA_NACIDO": [50.0, 45.0, 48.5, 51.5, 45.5],
            "DUR_EMB_PARTO": [39, 35, 38, 40, 36],
            "Condicion_Parto": ["EUTOCICO", "EUTOCICO", "CESAREA", "CESAREA", "EUTOCICO"],
            "sexo_nacido": ["MASCULINO", "MASCULINO", "FEMENINO", "MASCULINO", "MASCULINO"],
            "Tipo_Parto": ["UNICO", "UNICO", "UNICO", "UNICO", "UNICO"],
            "Edad_Madre": [26, 17, 31, 29, 16],
            "Estado_Civil": ["SOLTERO", "SOLTERO", "CASADO", "CONVIVIENTE", "SOLTERO"],
            "Nivel_Intrucción_Madre": ["SECUNDARIA COMPLETA", "SECUNDARIA INCOMPLETA", "SUPERIOR UNIV.", "SECUNDARIA COMPLETA", "SECUNDARIA INCOMPLETA"],
            "DESC_OCUPACION": ["AMA DE CASA", "AMA DE CASA", "DOCENTE", "COMERCIANTE", "ESTUDIANTE"],
            "Num_embar_madre": ["1", "1", "2", "3", "1"],
            "Hijos_vivo_madre": ["1", "1", "2", "3", "1"],
            "Hijos_fallec_madre": ["0", "0", "0", "0", "0"],
            "nacmuer_abort_madre": ["0", "0", "0", "0", "0"],
            "Pais_Madre": ["PERU", "PERU", "PERU", "PERU", "PERU"],
            "IdUbigeoInei": ["150101", "050108", "150101", "150132", "200104"],
            "Ipress": ["00006240", "00002155", "00006240", "00006321", "00010210"],
            "Lugar_Nacido": ["ESTABLECIMIENTO DE SALUD", "ESTABLECIMIENTO DE SALUD", "ESTABLECIMIENTO DE SALUD", "ESTABLECIMIENTO DE SALUD", "ESTABLECIMIENTO DE SALUD"],
            "Atiende_Parto": ["OBSTETRA", "OBSTETRA", "MEDICO GINECO-OBSTETRA", "MEDICO GINECO-OBSTETRA", "OBSTETRA"],
            "Financiador_Parto": ["SIS", "SIS", "ESSALUD", "SIS", "SIS"]
        }
        df = pd.DataFrame(sample_data)
        
    duration = time.time() - start_time
    logger.info(f"Extracción finalizada exitosamente: {len(df):,} filas y {len(df.columns)} columnas cargadas en {duration:.2f}s.")
    return df


# ==========================================================================================
# 3. FASE DE TRANSFORMACIÓN Y LIMPIEZA (T - TRANSFORM)
# ==========================================================================================
def clean_and_transform(df_raw: pd.DataFrame) -> Tuple[pd.DataFrame, Dict[str, pd.DataFrame]]:
    """
    Ejecuta el pipeline de limpieza y transformación:
    1. Estandarización de nombres de columnas.
    2. Deduplicación de registros.
    3. Imputación y tipado de variables biométricas y sociodemográficas.
    4. Homogeneización de textos y ubigeos.
    5. Creación de variables calculadas (Flags analíticos).
    6. Creación de tablas dimensionales en memoria (Modelo Estrella 3FN).
    """
    logger.info("==================================================================")
    logger.info("FASE 2: TRANSFORMACIÓN Y LIMPIEZA DE DATOS")
    logger.info("==================================================================")
    
    df = df_raw.copy()
    initial_rows = len(df)
    
    # 3.1. Estandarización de Nombres de Columnas
    column_mapping = {
        "FecNac_Año": "anio",
        "FecNac_Mes": "mes",
        "PESO_NACIDO": "peso_gramos",
        "TALLA_NACIDO": "talla_cm",
        "DUR_EMB_PARTO": "duracion_embarazo_sem",
        "Condicion_Parto": "condicion_parto",
        "sexo_nacido": "sexo",
        "Tipo_Parto": "tipo_parto",
        "Edad_Madre": "edad_madre",
        "Estado_Civil": "estado_civil",
        "Nivel_Intrucción_Madre": "nivel_instruccion",
        "DESC_OCUPACION": "ocupacion",
        "Num_embar_madre": "num_embarazos",
        "Hijos_vivo_madre": "hijos_vivos",
        "Hijos_fallec_madre": "hijos_fallecidos",
        "nacmuer_abort_madre": "abortos_previos",
        "Pais_Madre": "pais_origen",
        "IdUbigeoInei": "ubigeo_cod",
        "Ipress": "codigo_ipress",
        "Lugar_Nacido": "lugar_nacimiento",
        "Atiende_Parto": "profesional_atiende",
        "Financiador_Parto": "financiador"
    }
    df.rename(columns=column_mapping, inplace=True)
    logger.info("Columnas renombradas a formato estándar en minúsculas snake_case.")
    
    # 3.2. Eliminación de Duplicados Exactos
    df.drop_duplicates(inplace=True)
    duplicates_removed = initial_rows - len(df)
    logger.info(f"Registros duplicados eliminados: {duplicates_removed:,}")
    
    # 3.3. Estandarización de Cadenas de Texto (Mayúsculas y eliminación de espacios)
    text_cols = ["condicion_parto", "sexo", "tipo_parto", "estado_civil", "nivel_instruccion", 
                 "ocupacion", "pais_origen", "lugar_nacimiento", "profesional_atiende", "financiador"]
    for col in text_cols:
        if col in df.columns:
            df[col] = df[col].astype(str).str.strip().str.upper()
            df[col] = df[col].replace({"NAN": "NO REGISTRADO", "NONE": "NO REGISTRADO", "": "NO REGISTRADO"})
            
    # 3.4. Limpieza y Formato de Clave Temporal y Geográfica
    df["anio"] = pd.to_numeric(df["anio"], errors="coerce").fillna(2025).astype(int)
    df["mes"] = pd.to_numeric(df["mes"], errors="coerce").fillna(1).astype(int)
    df["id_tiempo"] = df["anio"] * 100 + df["mes"]
    
    # Formatear ubigeo a 6 dígitos con ceros a la izquierda
    df["ubigeo_cod"] = df["ubigeo_cod"].astype(str).str.replace(r"\.0$", "", regex=True).str.zfill(6)
    df["ubigeo_cod"] = df["ubigeo_cod"].apply(lambda x: x if len(x) == 6 else "150101")
    
    # Formatear código IPRESS a 8 o 10 caracteres
    df["codigo_ipress"] = df["codigo_ipress"].astype(str).str.replace(r"\.0$", "", regex=True).str.zfill(8)
    
    # 3.5. Limpieza y Validación de Variables Numéricas Biométricas
    # Peso (gramos): Rango clínico válido 300g - 7000g. Imputación con mediana si es nulo o fuera de rango
    df["peso_gramos"] = pd.to_numeric(df["peso_gramos"], errors="coerce")
    median_weight = df["peso_gramos"].median() if not df["peso_gramos"].isna().all() else 3250.0
    df["peso_gramos"] = df["peso_gramos"].apply(lambda x: x if (300 <= x <= 7000) else median_weight)
    df["peso_gramos"] = df["peso_gramos"].round(2)
    
    # Talla (cm): Rango clínico válido 20cm - 75cm
    df["talla_cm"] = pd.to_numeric(df["talla_cm"], errors="coerce")
    median_height = df["talla_cm"].median() if not df["talla_cm"].isna().all() else 49.0
    df["talla_cm"] = df["talla_cm"].apply(lambda x: x if (20.0 <= x <= 75.0) else median_height)
    df["talla_cm"] = df["talla_cm"].round(1)
    
    # Semanas de gestación: Rango 20 - 45 semanas
    df["duracion_embarazo_sem"] = pd.to_numeric(df["duracion_embarazo_sem"], errors="coerce").fillna(39).astype(int)
    df["duracion_embarazo_sem"] = df["duracion_embarazo_sem"].apply(lambda x: x if (20 <= x <= 45) else 39)
    
    # Edad de la Madre: Rango 8 a 65 años
    df["edad_madre"] = pd.to_numeric(df["edad_madre"], errors="coerce").fillna(28).astype(int)
    df["edad_madre"] = df["edad_madre"].apply(lambda x: x if (8 <= x <= 65) else 28)
    
    # 3.6. Creación de Variables Analíticas Derivadas (Flags Booleanos)
    df["es_bajo_peso"] = (df["peso_gramos"] < 2500.0).astype(int)
    df["es_prematuro"] = (df["duracion_embarazo_sem"] < 37).astype(int)
    df["es_madre_adolescente"] = (df["edad_madre"] < 18).astype(int)
    df["es_cesarea"] = (df["condicion_parto"].str.contains("CESAREA", na=False)).astype(int)
    
    # 3.7. Generación de Tablas Dimensionales Normalizadas
    logger.info("Generando tablas dimensionales normalizadas (Esquema Estrella)...")
    
    # Dimensión Madre Perfil
    dim_madre = df[["estado_civil", "nivel_instruccion", "ocupacion", "pais_origen"]].drop_duplicates().reset_index(drop=True)
    dim_madre["id_madre_perfil"] = dim_madre.index + 1
    df = df.merge(dim_madre, on=["estado_civil", "nivel_instruccion", "ocupacion", "pais_origen"], how="left")
    
    # Dimensión Condición Parto
    dim_parto = df[["condicion_parto", "tipo_parto", "lugar_nacimiento"]].drop_duplicates().reset_index(drop=True)
    dim_parto["id_condicion_parto"] = dim_parto.index + 1
    df = df.merge(dim_parto, on=["condicion_parto", "tipo_parto", "lugar_nacimiento"], how="left")
    
    # Dimensión Atención Salud
    dim_atencion = df[["profesional_atiende", "financiador"]].drop_duplicates().reset_index(drop=True)
    dim_atencion["id_atencion_salud"] = dim_atencion.index + 1
    df = df.merge(dim_atencion, on=["profesional_atiende", "financiador"], how="left")
    
    # Dimensión Tiempo
    dim_tiempo = df[["id_tiempo", "anio", "mes"]].drop_duplicates().sort_values("id_tiempo").reset_index(drop=True)
    meses_nombres = {1: "Enero", 2: "Febrero", 3: "Marzo", 4: "Abril", 5: "Mayo", 6: "Junio",
                     7: "Julio", 8: "Agosto", 9: "Setiembre", 10: "Octubre", 11: "Noviembre", 12: "Diciembre"}
    dim_tiempo["nombre_mes"] = dim_tiempo["mes"].map(meses_nombres).fillna("Desconocido")
    dim_tiempo["trimestre"] = ((dim_tiempo["mes"] - 1) // 3) + 1
    dim_tiempo["semestre"] = ((dim_tiempo["mes"] - 1) // 6) + 1
    
    # Selección de columnas finales para la tabla de hechos FACT_NACIMIENTO
    fact_cols = [
        "id_tiempo", "ubigeo_cod", "id_madre_perfil", "id_condicion_parto", "id_atencion_salud",
        "codigo_ipress", "sexo", "peso_gramos", "talla_cm", "duracion_embarazo_sem", "edad_madre",
        "num_embarazos", "hijos_vivos", "hijos_fallecidos", "abortos_previos",
        "es_bajo_peso", "es_prematuro", "es_madre_adolescente", "es_cesarea"
    ]
    df_fact = df[fact_cols].copy()
    
    dimensions = {
        "DIM_TIEMPO": dim_tiempo,
        "DIM_MADRE_PERFIL": dim_madre,
        "DIM_CONDICION_PARTO": dim_parto,
        "DIM_ATENCION_SALUD": dim_atencion
    }
    
    logger.info("Transformación y normalización completada exitosamente.")
    return df_fact, dimensions


# ==========================================================================================
# 4. FASE DE CARGA A BASE DE DATOS (L - LOAD)
# ==========================================================================================
def load_to_sql_server(df_fact: pd.DataFrame, dimensions: Dict[str, pd.DataFrame], config: dict):
    """
    Inserta los datos limpios en la base de datos SQL Server.
    Utiliza SQLAlchemy con fast_executemany para alto rendimiento.
    Si SQL Server no está disponible, exporta los archivos procesados en CSV de respaldo.
    """
    logger.info("==================================================================")
    logger.info("FASE 3: CARGA DE DATOS A SQL SERVER")
    logger.info("==================================================================")
    
    try:
        from sqlalchemy import create_engine
        
        # Construcción de la cadena de conexión ODBC
        if config.get("use_windows_auth"):
            conn_str = f"mssql+pyodbc://@{config['db_server']}/{config['db_name']}?driver={config['db_driver']}&trusted_connection=yes"
        else:
            conn_str = f"mssql+pyodbc://{config['db_user']}:{config['db_password']}@{config['db_server']}/{config['db_name']}?driver={config['db_driver']}"
            
        logger.info(f"Intentando conectar a SQL Server en: {config['db_server']} (BD: {config['db_name']})...")
        engine = create_engine(conn_str, fast_executemany=True)
        
        with engine.connect() as conn:
            logger.info("Conexión establecida exitosamente.")
            
            # Cargar dimensiones
            for table_name, df_dim in dimensions.items():
                logger.info(f"Insertando {len(df_dim)} registros en {table_name}...")
                df_dim.to_sql(table_name.lower(), con=engine, if_exists="append", index=False)
                
            # Cargar tabla de hechos en lotes (batch_size)
            logger.info(f"Cargando {len(df_fact):,} registros en FACT_NACIMIENTO por lotes de {config['batch_size']}...")
            df_fact.to_sql("fact_nacimiento", con=engine, if_exists="append", index=False, chunksize=config["batch_size"])
            
        logger.info("¡Carga completa en SQL Server finalizada con éxito!")
        
    except Exception as e:
        logger.warning(f"Aviso de conexión a SQL Server: {e}")
        logger.info("Exportando respaldo local de datos transformados a formato CSV limpio...")
        df_fact.to_csv(config["output_clean_csv"], index=False, sep=";")
        logger.info(f"Archivo exportado correctamente: {config['output_clean_csv']} ({len(df_fact):,} registros listos para BCP o Import Wizard).")


# ==========================================================================================
# 5. FUNCIÓN PRINCIPAL DE EJECUCIÓN
# ==========================================================================================
def main():
    logger.info(">>> INICIANDO PROCESO ETL AUTOMATIZADO - CERTIFICADO DE NACIDO VIVO (CNV PERÚ) <<<")
    total_start = time.time()
    
    # 1. Extracción
    df_raw = extract_dataset(CONFIG["input_excel_path"], CONFIG["input_csv_fallback"])
    
    # 2. Transformación
    df_fact, dimensions = clean_and_transform(df_raw)
    
    # 3. Carga
    load_to_sql_server(df_fact, dimensions, CONFIG)
    
    total_duration = time.time() - total_start
    logger.info(f">>> PROCESO ETL FINALIZADO CON ÉXITO EN {total_duration:.2f} SEGUNDOS <<<")


if __name__ == "__main__":
    main()
