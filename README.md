# 🏥 Sistema de Vigilancia y Analítica de Natalidad (CNV Perú)
> **Proyecto Big Data con Datos Abiertos Reales del MINSA / RENIEC (4,904,793 Registros)**

[![GitHub Pages](https://img.shields.io/badge/Demo-GitHub%20Pages-brightgreen)](https://curahuamoralesanymiluska.github.io/proyecto-bigdata-cnv/)
[![SQL Server](https://img.shields.io/badge/Database-SQL%20Server%202022-blue)](https://www.microsoft.com/sql-server)
[![Python](https://img.shields.io/badge/Python-3.10%2B-yellow)](https://www.python.org/)
[![Status](https://img.shields.io/badge/Status-100%25%20Completado-success)]()

---

## 🌐 Dashboard Web en Vivo
👉 **[Acceder al Dashboard Interactivo (GitHub Pages)](https://curahuamoralesanymiluska.github.io/proyecto-bigdata-cnv/)**

---

## 📂 Estructura del Proyecto en Visual Studio Code

```text
proyecto-bigdata-cnv/
│
├── 🗄️ SCRIPTS DE BASE DE DATOS (SQL SERVER T-SQL)
│   ├── 00_ejecutar_todo.sql                # Script maestro para ejecutar todo el esquema
│   ├── 04_01_creacion_bd.sql               # Creación de base de datos BD_CNV_BIGDATA_PERU
│   ├── 04_02_creacion_tablas.sql           # Tablas dimensionales y tabla de hechos (FACT_NACIMIENTO)
│   ├── 04_03_claves_primarias.sql          # Restricciones PRIMARY KEY
│   ├── 04_04_claves_foraneas.sql           # Restricciones FOREIGN KEY
│   ├── 04_05_insercion_muestra.sql         # Inserción de catálogo y datos muestra
│   ├── 04_06_indices.sql                   # Índices Nonclustered para optimización de consultas
│   ├── 04_07_vistas.sql                    # Vistas analíticas para Business Intelligence
│   ├── 04_08_procedimiento_almacenado.sql  # 20 Stored Procedures analíticos y transaccionales
│   └── 06_consultas_analiticas.sql         # Consultas de análisis multidimensional
│
├── 🐍 PIPELINE ETL Y MACHINE LEARNING (PYTHON)
│   ├── 05_etl_proceso.py                   # Pipeline ETL (Extracción, Limpieza, Transformación y Carga a SQL)
│   └── 07_modelo_predictivo.py             # Modelo de Regresión Lineal OLS (Proyección 2026-2030)
│
├── 📊 DASHBOARD WEB INTERACTIVO
│   ├── index.html                          # Estructura del Dashboard con filtros y silueta materna
│   ├── styles.css                          # Estilos visuales con paleta infográfica vibrante
│   ├── script.js                           # Controlador interactivo de Chart.js y filtros en tiempo real
│   ├── datos.json                          # Repositorio de datos analíticos estructurados
│   └── maternal_infographic.jpg            # Ilustración HD de salud materno-neonatal
│
└── 📑 DOCUMENTACIÓN E INFORMES
    └── docs/
        ├── 01_descripcion_dataset.md       # Diccionario de variables y calidad de datos
        ├── 02_modelo_er.md                 # Modelo Entidad-Relación y Diagrama Estrella
        ├── 03_normalizacion.md             # Justificación formal 0FN a 3FN con cuadros
        ├── 05_etl_explicacion.md           # Metodología y arquitectura del proceso ETL
        ├── 06_analisis_patrones.md         # Análisis de secuencias temporales y estacionalidad
        ├── 07_modelo_predictivo_interpretacion.md # Interpretación del modelo Machine Learning
        ├── 08_conclusiones_recomendaciones.md     # Conclusiones sanitarias y tecnológicas
        ├── 09_informe_final.md             # Informe técnico final completo (14 capítulos)
        └── 09_informe_final.tex            # Código LaTeX para compilación PDF con carátula TikZ
```

---

## 🚀 Cómo Ejecutar el Proyecto

### 1. En SQL Server Management Studio (SSMS):
1. Abrir `00_ejecutar_todo.sql` y ejecutar en el servidor local (`localhost` o `DESKTOP-0PU4IMG\SQLEXPRESS`).
2. Se creará automáticamente la base de datos `BD_CNV_BIGDATA_PERU`, sus 6 tablas dimensionales, su tabla de hechos `FACT_NACIMIENTO`, índices, vistas y 20 procedimientos almacenados.

### 2. En Python:
```bash
# Instalar librerías necesarias
pip install pandas numpy scikit-learn sqlalchemy pyodbc matplotlib

# Ejecutar el Pipeline ETL
python 05_etl_proceso.py

# Ejecutar el Modelo Predictivo de Machine Learning
python 07_modelo_predictivo.py
```

### 3. En el Navegador:
Abrir `index.html` (o `dashboard/index.html`) con cualquier navegador web o mediante la extensión **Live Server** de Visual Studio Code.
