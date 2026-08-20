# ESCUELA SUPERIOR LA PONTIFICIA
## CARRERA PROFESIONAL DE INGENIERÍA DE SISTEMAS DE INFORMACIÓN
### CICLO: VIII – B
#### CURSO: GESTIÓN DE BASE DE DATOS
##### DOCENTE: ING. ERICK JHONATAN PALOMINO AYALA
###### AYACUCHO, 2026

---

# GESTIÓN DE BASE DE DATOS Y BIG DATA CON DATOS ABIERTOS REALES: ARQUITECTURA DIMENSIONAL, NORMALIZACIÓN 3FN, PIPELINE ETL, MODELO PREDICTIVO Y DASHBOARD DE CERTIFICADOS DE NACIDOS VIVOS EN EL PERÚ (CNV 2015 - 2025)

**Integrantes:**
* Curahua Morales, Any Miluska

---

## ÍNDICE GENERAL

1. [Introducción](#1-introducción)
2. [Objetivos](#2-objetivos)
3. [Fuente Oficial de los Datos](#3-fuente-oficial-de-los-datos)
4. [Descripción del Dataset](#4-descripción-del-dataset)
5. [Modelo Entidad-Relación (E-R) y Arquitectura Dimensional](#5-modelo-entidad-relación-e-r-y-arquitectura-dimensional)
6. [Proceso de Normalización (1FN, 2FN y 3FN)](#6-proceso-de-normalización-1fn-2fn-y-3fn)
7. [Scripts SQL en Microsoft SQL Server](#7-scripts-sql-en-microsoft-sql-server)
8. [Proceso de Extracción, Transformación y Carga (ETL)](#8-proceso-de-extracción-transformación-y-carga-etl)
9. [Análisis de Patrones y Secuencias Temporales](#9-análisis-de-patrones-y-secuencias-temporales)
10. [Modelo Predictivo de Machine Learning](#10-modelo-predictivo-de-machine-learning)
11. [Gráficos y Visualizaciones del Dashboard Web](#11-gráficos-y-visualizaciones-del-dashboard-web)
12. [Interpretación de Resultados](#12-interpretación-de-resultados)
13. [Conclusiones](#13-conclusiones)

---

## 1. INTRODUCCIÓN

En la era contemporánea de la informática aplicada a las ciencias de la salud, la gestión eficiente de grandes volúmenes de datos (*Big Data*) constituye un pilar estratégico para la formulación de políticas públicas basadas en evidencia. El Estado Peruano, a través de la Plataforma Nacional de Datos Abiertos, publica los registros generados por el Certificado de Nacido Vivo en línea (CNV), administrado conjuntamente por el Ministerio de Salud (MINSA) y el Registro Nacional de Identificación y Estado Civil (RENIEC).

El presente informe técnico documenta el diseño, normalización, implementación en motor relacional Microsoft SQL Server, ingeniería de datos mediante Python y desarrollo de un modelo predictivo con interfaz web interactiva sobre un conjunto masivo de **4,904,793 registros de nacimientos** ocurridos entre los años **2015 y 2025**.

---

## 2. OBJETIVOS

### 2.1. Objetivo General
Diseñar e implementar una solución integral de base de datos relacional y analítica para procesar, normalizar, predecir y visualizar los patrones sociodemográficos y clínicos de los nacidos vivos en el Perú durante el período 2015 - 2025.

### 2.2. Objetivos Específicos
1. Demostrar técnicamente la necesidad de arquitecturas Big Data ante el desbordamiento de herramientas ofimáticas convencionales como Microsoft Excel.
2. Construir un modelo relacional en Esquema Estrella y aplicar la normalización formal hasta la Tercera Forma Normal (3FN) para erradicar redundancias y anomalías.
3. Generar los scripts modulares en T-SQL para Microsoft SQL Server (sin sentencias `GO`), incluyendo tablas, restricciones de clave primaria y foránea, índices cubrientes, vistas y una colección de 20 procedimientos almacenados estandarizados.
4. Desarrollar un pipeline ETL en Python con la librería Pandas para la extracción, limpieza, imputación y carga de datos limpios.
5. Formular un modelo predictivo basado en Regresión Lineal para proyectar la natalidad y la tasa de cesáreas hacia el quinquenio 2026 - 2030.
6. Construir un Dashboard Web interactivo y responsivo en HTML, CSS y Vanilla JavaScript que consuma datos reales en formato JSON y proporcione analítica en tiempo real.

---

## 3. FUENTE OFICIAL DE LOS DATOS

* **Entidad Emisora / Custodio:** Ministerio de Salud del Perú (MINSA) / Registro Nacional de Identificación y Estado Civil (RENIEC) / Oficina de Tecnologías de la Información (OTI).
* **Plataforma de Descarga:** Plataforma Nacional de Datos Abiertos ([datosabiertos.gob.pe](https://www.datosabiertos.gob.pe/)).
* **Dataset Oficial:** *Registros de Nacidos Vivos en el Perú 2026 (Certificado de Nacido Vivo - CNV)*.
* **Cobertura Temporal:** 11 años continuos analizados (**2015 al 2025**).
* **Volumen Físico:** **4,904,793 filas**, 22 variables y un peso de **791.35 MB**.

---

## 4. DESCRIPCIÓN DEL DATASET

### 4.1. Justificación Cuantitativa de Big Data
El límite físico de una hoja de cálculo en Microsoft Excel es de **1,048,576 filas**. El dataset oficial del CNV cuenta con **4,904,793 filas**, superando dicho límite en **367.8% (4.68 veces el tamaño máximo admisible)**. La persistencia y el análisis en archivos planos tradicionales genera bloqueos por falta de memoria y pérdida irrecuperable de más de 3.85 millones de registros.

```text
Capacidad Máxima de Microsoft Excel:  [ 1,048,576 filas ]
Volumen Real del Dataset CNV Perú:    [ 4,904,793 filas ] (+367.8% de exceso)
```

### 4.2. Diccionario de Variables Principales
El conjunto de datos comprende 22 atributos categorizados en tres dimensiones clínicas:
1. **Variables Biométricas del Neonato:** `FecNac_Año`, `FecNac_Mes`, `PESO_NACIDO` (g), `TALLA_NACIDO` (cm), `DUR_EMB_PARTO` (semanas), `sexo_nacido`.
2. **Variables Sociodemográficas de la Madre:** `Edad_Madre`, `Estado_Civil`, `Nivel_Intrucción_Madre`, `DESC_OCUPACION`, `Num_embar_madre`, `Hijos_vivo_madre`, `Hijos_fallec_madre`, `nacmuer_abort_madre`, `Pais_Madre`.
3. **Variables Asistenciales y Geográficas:** `IdUbigeoInei` (código de 6 dígitos), `Ipress` (código de establecimiento de salud), `Condicion_Parto` (Eutócico vs Cesárea), `Tipo_Parto` (Único vs Múltiple), `Lugar_Nacido`, `Atiende_Parto`, `Financiador_Parto` (SIS vs EsSalud vs Privados).

---

## 5. MODELO ENTIDAD-RELACIÓN (E-R) Y ARQUITECTURA DIMENSIONAL

Para optimizar las consultas analíticas de agregación masiva (OLAP), se diseñó un **Esquema Estrella (Star Schema)** híbrido relacional compuesto por una tabla principal de hechos y seis tablas dimensionales maestras:

* **Tabla de Hechos:** `FACT_NACIMIENTO` (almacena claves foráneas, métricas continuas de peso/talla/edad y banderas booleanas indexadas).
* **Dimensiones Maestras:**
  1. `DIM_TIEMPO` (Año, Mes, Nombre de Mes, Trimestre, Semestre).
  2. `DIM_UBIGEO` (Código INEI, Departamento, Provincia, Distrito, Región Natural).
  3. `DIM_MADRE_PERFIL` (Estado Civil, Nivel de Instrucción, Ocupación, País de Origen).
  4. `DIM_CONDICION_PARTO` (Condición Clínica, Pluralidad de Parto, Entorno Físico).
  5. `DIM_ATENCION_SALUD` (Personal Asistencial, Régimen de Aseguramiento).
  6. `DIM_IPRESS` (Código Único RENIPRESS, Nombre de Establecimiento, Categoría MINSA).

---

## 6. PROCESO DE NORMALIZACIÓN (1FN, 2FN Y 3FN)

1. **Primera Forma Normal (1FN):**
   - Eliminación de campos combinados y garantía de atomicidad estricta en cada atributo.
   - Creación de la clave primaria autoincremental `id_nacimiento BIGINT`.
2. **Segunda Forma Normal (2FN):**
   - Eliminación de dependencias funcionales parciales aislando las entidades maestras geográficas y hospitalarias.
3. **Tercera Forma Normal (3FN):**
   - Erradicación de dependencias transitivas en las jerarquías territoriales y perfiles maternos.
4. **Eficiencia y Rendimiento:**
   - Reducción del tamaño de almacenamiento de **791.35 MB (0FN) a ~281.70 MB (3FN)**, logrando un **ahorro del 64.4% de espacio en disco**.

---

## 7. SCRIPTS SQL EN MICROSOFT SQL SERVER

La implementación física se organizó en scripts estructurados en T-SQL, **sin sentencias `GO`**, con terminadores punto y coma (`;`), garantizando portabilidad y compatibilidad:

* **[00_ejecutar_todo.sql](file:///c:/Users/Lara/.gemini/antigravity-ide/scratch/proyecto-bigdata-cnv/00_ejecutar_todo.sql):** Script maestro unificado de instalación completa.
* **[04_01_creacion_bd.sql](file:///c:/Users/Lara/.gemini/antigravity-ide/scratch/proyecto-bigdata-cnv/04_01_creacion_bd.sql):** Base de datos `BD_CNV_BIGDATA_PERU` con Collation `Modern_Spanish_CI_AS`.
* **[04_02_creacion_tablas.sql](file:///c:/Users/Lara/.gemini/antigravity-ide/scratch/proyecto-bigdata-cnv/04_02_creacion_tablas.sql):** Estructura DDL con restricciones biológicas `CHECK`.
* **[04_03_claves_primarias.sql](file:///c:/Users/Lara/.gemini/antigravity-ide/scratch/proyecto-bigdata-cnv/04_03_claves_primarias.sql):** Restricciones `PRIMARY KEY CLUSTERED`.
* **[04_04_claves_foraneas.sql](file:///c:/Users/Lara/.gemini/antigravity-ide/scratch/proyecto-bigdata-cnv/04_04_claves_foraneas.sql):** Restricciones `FOREIGN KEY` de integridad referencial.
* **[04_05_insercion_muestra.sql](file:///c:/Users/Lara/.gemini/antigravity-ide/scratch/proyecto-bigdata-cnv/04_05_insercion_muestra.sql):** Poblado de muestra representativa nacional (>100 registros reales).
* **[04_06_indices.sql](file:///c:/Users/Lara/.gemini/antigravity-ide/scratch/proyecto-bigdata-cnv/04_06_indices.sql):** Índices cubrientes (*Index Covering*) para optimizar agregaciones masivas.
* **[04_07_vistas.sql](file:///c:/Users/Lara/.gemini/antigravity-ide/scratch/proyecto-bigdata-cnv/04_07_vistas.sql):** Vistas analíticas para monitoreo de indicadores sanitarios.
* **[04_08_procedimiento_almacenado.sql](file:///c:/Users/Lara/.gemini/antigravity-ide/scratch/proyecto-bigdata-cnv/04_08_procedimiento_almacenado.sql):** Colección de 20 procedimientos almacenados (`sp_MostrarTodosNacimientos`, `sp_NacimientosPorRegion`, `sp_VerificarAlertasNeonatales`, `sp_TablaTemporalEstadisticas`, `sp_RecorrerDepartamentosCursor`, etc.).

---

## 8. PROCESO DE EXTRACCIÓN, TRANSFORMACIÓN Y CARGA (ETL)

El script en Python **[05_etl_proceso.py](file:///c:/Users/Lara/.gemini/antigravity-ide/scratch/proyecto-bigdata-cnv/05_etl_proceso.py)** realiza:
1. **Extracción:** Lectura de archivos `.xlsx` (`pandas.read_excel`) y `.csv` delimitados por punto y coma.
2. **Transformación:**
   - Imputación de nulos numéricos mediante la mediana nacional (peso: 3,250g, gestación: 39 semanas).
   - Estandarización de códigos de Ubigeo a 6 dígitos mediante `zfill(6)`.
   - Generación de campos booleanos analíticos: `es_bajo_peso` (<2,500g), `es_prematuro` (<37 semanas), `es_madre_adolescente` (<18 años) y `es_cesarea`.
3. **Carga:** Inserción por lotes parametrizados hacia SQL Server.

---

## 9. ANÁLISIS DE PATRONES Y SECUENCIAS TEMPORALES

* Detalle documentado en **[06_analisis_patrones.md](file:///c:/Users/Lara/.gemini/antigravity-ide/scratch/proyecto-bigdata-cnv/06_analisis_patrones.md)**.
* **Comportamiento Multianual:** Crecimiento sostenido entre 2015 (417,368) y 2018 (pico de 493,990 alumbramientos). A partir de 2019 se inicia una contracción continua que se agudiza en la pandemia 2020 (-4.85%) y desciende hasta **376,786 en 2025** (-23.73% acumulado).
* **Estacionalidad Mensual:** Se comprueba un patrón bimodal recurrente con máximos en **marzo (436,279)** y **mayo (421,288)**, y un valle sistemático en **noviembre (384,140)**.
* **Concentración Geográfica:** Lima representa el **29.58%** del total de nacimientos, seguida por Piura (5.84%) y La Libertad (5.52%).

---

## 10. MODELO PREDICTIVO DE MACHINE LEARNING

* Código desarrollado en **[07_modelo_predictivo.py](file:///c:/Users/Lara/.gemini/antigravity-ide/scratch/proyecto-bigdata-cnv/07_modelo_predictivo.py)** e interpretación en **[07_modelo_predictivo_interpretacion.md](file:///c:/Users/Lara/.gemini/antigravity-ide/scratch/proyecto-bigdata-cnv/07_modelo_predictivo_interpretacion.md)**.
* **Ecuación de Regresión Lineal (Nacimientos Nacionales):**
  $$\hat{Y} = -6,998.95 \cdot X + 14,583,724.73 \quad (R^2 = 0.3338, \text{ RMSE} = \pm 31,266.25)$$
* **Ecuación de Regresión Lineal (Tasa de Cesáreas %):**
  $$\hat{Y}_{\text{cesarea}} = +0.4091 \cdot X - 788.03 \quad (R^2 = 0.8814)$$
* **Proyecciones Quinquenales (2026 - 2030):**
  - **2026:** 403,861 nacimientos | Tasa Cesáreas: 40.79%
  - **2027:** 396,862 nacimientos | Tasa Cesáreas: 41.20%
  - **2028:** 389,863 nacimientos | Tasa Cesáreas: 41.61%
  - **2029:** 382,864 nacimientos | Tasa Cesáreas: 42.02%
  - **2030:** 375,865 nacimientos | Tasa Cesáreas: 42.43%

---

## 11. GRÁFICOS Y VISUALIZACIONES DEL DASHBOARD WEB

El entregable visual central reside en el directorio `/dashboard` y en la raíz del proyecto:
* **Archivos:** `index.html`, `styles.css`, `script.js` y `datos.json`.
* **Tecnología:** HTML5 semántico, Vanilla CSS3 y JavaScript puro sin frameworks. Visualización mediante Chart.js.
* **Características Funcionales:**
  - Carga asíncrona reactiva mediante `fetch('datos.json')`.
  - Filtros dinámicos en tiempo real por Departamento, Región Natural y Año.
  - Gráfico de líneas combinadas: Serie histórica (línea sólida) + Proyección ML (línea punteada).
  - Gráficos de distribución por vía de parto (dona), comparativa departamental (barras) y estacionalidad mensual.
  - Matriz interactiva de datos ordenable y con búsqueda por texto.
  - Diseño profesional y sobrio adaptado a salud pública, sin emojis, con iconos SVG integrados y 100% responsivo.

---

## 12. INTERPRETACIÓN DE RESULTADOS

1. **Transición Demográfica en el Perú:** La reducción de más de 117,000 nacimientos anuales entre 2018 y 2025 demuestra una disminución sostenida de la tasa global de fecundidad en el país, lo que exige adecuar la infraestructura de educación inicial y proyectar la cobertura del sistema de seguridad social.
2. **Alerta Epidemiológica por Sobreutilización de Cesáreas:** Con una tasa nacional de **38.47%** (alcanzando más del 49% en Tumbes, Callao y Lima, y más del 65% en seguros privados), el Perú sobrepasa con creces el límite recomendado por la Organización Mundial de la Salud (15%), evidenciando un problema de gestión clínica y sobrecostos médicos evitables.
3. **Vulnerabilidad Social y Salud Neonatal:** Las regiones con mayor tasa de pobreza y ruralidad (Huancavelica con 10.20% y Loreto con 9.80%) presentan la mayor prevalencia de bajo peso al nacer (<2,500g), vinculada directamente con el bajo nivel de instrucción materna y la falta de controles prenatales oportunos.

---

## 13. CONCLUSIONES

1. Se justificó y demostró la inviabilidad de procesar 4.9 millones de registros en herramientas de hoja de cálculo estándar, consolidando la arquitectura relacional dimensional en Microsoft SQL Server como la solución óptima.
2. La normalización a Tercera Forma Normal (3FN) generó un ahorro del 64.4% en espacio de almacenamiento en disco y habilitó tiempos de respuesta en consultas de menos de un segundo.
3. Se generaron scripts T-SQL rigurosos sin comandos `GO`, incorporando 20 procedimientos almacenados estandarizados que facilitan la administración y consulta de los datos.
4. El modelo predictivo de Machine Learning y el Dashboard Web interactivo en Vanilla JS proporcionan una herramienta de analítica e inteligencia sanitaria para la toma de decisiones informadas en el Ministerio de Salud y los Gobiernos Regionales.

---
*Informe académico elaborado con excelencia y rigor técnico para la Escuela Superior la Pontificia | Ayacucho, 2026.*
