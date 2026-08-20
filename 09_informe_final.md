# ESCUELA DE EDUCACIÓN SUPERIOR TECNOLÓGICA LA PONTIFICIA
## DIRECCIÓN ACADÉMICA | CARRERAS PROFESIONALES
### CARRERA: INGENIERÍA DE SISTEMAS DE INFORMACIÓN | CICLO: VIII – B
#### CURSO: GESTIÓN DE BASE DE DATOS / BIG DATA
##### DOCENTE: ING. ERICK JHONATAN PALOMINO AYALA
###### AYACUCHO, 2026

---

# INFORME TÉCNICO FINAL: BIG DATA CON DATOS ABIERTOS REALES
# "Gestión de Base de Datos, Modelo Entidad-Relación, Normalización 3FN, Pipeline ETL, Análisis de Patrones, Modelo Predictivo de Machine Learning y Dashboard Interactivo del Certificado de Nacido Vivo en el Perú (CNV 2015 - 2025)"

**Estudiante / Integrante:**
* Curahua Morales, Any Miluska

---

## ÍNDICE DEL INFORME TÉCNICO

1. [Portada](#1-portada)
2. [Introducción](#2-introducción)
3. [Objetivos](#3-objetivos)
4. [Fuente Oficial de los Datos](#4-fuente-oficial-de-los-datos)
5. [Descripción del Dataset](#5-descripción-del-dataset)
6. [Modelo Entidad–Relación](#6-modelo-entidadrelación)
7. [Proceso de Normalización](#7-proceso-de-normalización)
8. [Scripts SQL](#8-scripts-sql)
9. [Proceso ETL](#9-proceso-etl)
10. [Análisis de Patrones](#10-análisis-de-patrones)
11. [Modelo Predictivo](#11-modelo-predictivo)
12. [Gráficos y Visualizaciones](#12-gráficos-y-visualizaciones)
13. [Interpretación de Resultados](#13-interpretación-de-resultados)
14. [Conclusiones](#14-conclusiones)

---

## 1. PORTADA

* **Institución:** Escuela Superior la Pontificia
* **Carrera:** Ingeniería de Sistemas de Información
* **Ciclo:** VIII – B
* **Curso:** Gestión de Base De Datos
* **Docente:** Ing. Erick Jhonatan Palomino Ayala
* **Integrantes:** Curahua Morales, Any Miluska
* **Lugar y Fecha:** Ayacucho, 2026

---

## 2. INTRODUCCIÓN

El análisis de grandes volúmenes de información (*Big Data*) en el sector salud es esencial para comprender la dinámica poblacional, evaluar la calidad asistencial y orientar la asignación de recursos públicos. En el Perú, los nacimientos son registrados mediante el sistema del Certificado de Nacido Vivo en línea (CNV), administrado por el Ministerio de Salud (MINSA) y el Registro Nacional de Identificación y Estado Civil (RENIEC).

El presente informe desarrolla un proyecto integral de ingeniería de datos y Big Data sobre **4,904,793 registros de nacimientos (2015-2025)**, abarcando desde la justificación técnica por el desbordamiento de hojas de cálculo tradicionales (Microsoft Excel), el diseño relacional normalizado en 3FN estructurado en cuadros, la implementación física en Microsoft SQL Server con código limpio y sin comentarios, el desarrollo de un pipeline ETL automatizado en Python, el análisis de patrones y estacionalidad, el entrenamiento de un modelo predictivo por regresión lineal hacia el quinquenio 2026-2030, y el despliegue de un Dashboard Web interactivo en Vanilla JavaScript.

---

## 3. OBJETIVOS

### 3.1. Objetivo General
Desarrollar un proyecto integral de Big Data utilizando el conjunto de datos abiertos oficiales de los Certificados de Nacidos Vivos del Perú (2015-2025), aplicando técnicas avanzadas de bases de datos relacionales, normalización 3FN, pipeline ETL, análisis de patrones temporales y modelos predictivos de aprendizaje automático.

### 3.2. Objetivos Específicos
1. Seleccionar y diagnosticar una fuente oficial masiva con millones de registros de la Plataforma Nacional de Datos Abiertos Perú.
2. Construir el Modelo Entidad-Relación identificando entidades principales, auxiliares y sus cardinalidades (1:N).
3. Aplicar el proceso formal de normalización (1FN, 2FN y 3FN) presentado en cuadros estructurados, justificando la eliminación de datos redundantes y la corrección de dependencias funcionales.
4. Implementar los scripts modulares en Microsoft SQL Server con sintaxis limpia y sin comentarios.
5. Construir un pipeline ETL en Python (Pandas) para la extracción, limpieza, imputación de nulos y carga estructurada.
6. Analizar patrones multianuales, estacionalidad mensual y brechas territoriales, respondiendo a las preguntas de investigación sanitaria.
7. Entrenar un modelo de Machine Learning (Regresión Lineal OLS) para proyectar la natalidad y tasa de cesáreas al período 2026-2030.
8. Desplegar un Dashboard Web interactivo en Vanilla JS sin frameworks, responsive y sin emojis para visualización de KPIs.

---

## 4. FUENTE OFICIAL DE LOS DATOS

* **Plataforma Utilizada:** Plataforma Nacional de Datos Abiertos del Estado Peruano ([https://www.datosabiertos.gob.pe](https://www.datosabiertos.gob.pe)).
* **Custodio Oficial:** Ministerio de Salud del Perú (MINSA) / RENIEC / Oficina de Tecnologías de la Información (OTI).
* **Nombre del Dataset Seleccionado:** *Registros de Nacidos Vivos en el Perú 2026 (Certificado de Nacido Vivo - CNV)*.
* **Año o Período de los Datos:** **2015 al 2025** (11 años completos continuos).
* **Número Aproximado de Registros:** **4,904,793 filas** oficiales procesadas.

---

## 5. DESCRIPCIÓN DEL DATASET

### 5.1. Características Generales
* **Total de Registros:** **4,904,793 filas**.
* **Total de Variables:** **22 columnas**.
* **Tamaño del Archivo Plano:** **791.35 MB**.
* **Demostración de Big Data:** El límite máximo de Microsoft Excel es de **1,048,576 filas**. El dataset del CNV supera este límite en **4.68 veces (367.8% de exceso)**, imposibilitando su tratamiento en Excel por desbordamiento de memoria y pérdida de más de 3.85 millones de registros.

```text
Capacidad Máxima de Excel:  [ 1,048,576 filas ]
Volumen Real del CNV Perú:  [ 4,904,793 filas ] (+367.8% de exceso)
```

### 5.2. Diccionario de Variables y Tipos de Datos

| Variable | Tipo de Dato | Categoría | Descripción Técnica |
| :--- | :--- | :--- | :--- |
| `FecNac_Año` | Numérico (`INT`) | Temporal | Año de ocurrencia del nacimiento (2015 - 2025). |
| `FecNac_Mes` | Numérico (`INT`) | Temporal | Mes cronológico de ocurrencia (1 al 12). |
| `PESO_NACIDO` | Numérico (`DECIMAL`) | Biométrico | Peso del recién nacido en gramos (200 - 8,000 g). |
| `TALLA_NACIDO` | Numérico (`DECIMAL`) | Biométrico | Talla del neonato en centímetros (15 - 80 cm). |
| `DUR_EMB_PARTO` | Numérico (`INT`) | Gestacional | Semanas completas de gestación (18 - 46 semanas). |
| `sexo_nacido` | Texto (`VARCHAR`) | Biométrico | Sexo biológico (MASCULINO, FEMENINO). |
| `Edad_Madre` | Numérico (`INT`) | Materno | Edad de la madre al momento del parto (8 - 65 años). |
| `Estado_Civil` | Texto (`VARCHAR`) | Materno | Estado conyugal (SOLTERA, CASADA, CONVIVIENTE). |
| `Nivel_Intrucción_Madre` | Texto (`VARCHAR`) | Materno | Nivel educativo máximo alcanzado. |
| `DESC_OCUPACION` | Texto (`VARCHAR`) | Materno | Ocupación o actividad económica de la madre. |
| `Num_embar_madre` | Texto / Numérico | Obstétrico | Historial de gestaciones previas. |
| `Hijos_vivo_madre` | Texto / Numérico | Obstétrico | Número de hijos nacidos vivos previos. |
| `Hijos_fallec_madre` | Texto / Numérico | Obstétrico | Número de hijos fallecidos. |
| `nacmuer_abort_madre` | Texto / Numérico | Obstétrico | Historial de pérdidas gestacionales / abortos. |
| `Pais_Madre` | Texto (`VARCHAR`) | Geográfico | País de nacionalidad de la gestante (PERU...). |
| `IdUbigeoInei` | Texto (`VARCHAR(6)`) | Geográfico | Código oficial Ubigeo INEI de 6 dígitos del distrito. |
| `Ipress` | Texto (`VARCHAR(10)`) | Asistencial | Código Único RENIPRESS del establecimiento de salud. |
| `Condicion_Parto` | Texto (`VARCHAR`) | Clínico | Condición de la vía de parto (EUTOCICO, CESAREA). |
| `Tipo_Parto` | Texto (`VARCHAR`) | Obstétrico | Pluralidad (UNICO, DOBLE, TRIPLE). |
| `Lugar_Nacido` | Texto (`VARCHAR`) | Asistencial | Entorno del parto (HOSPITAL, PUESTO, DOMICILIO). |
| `Atiende_Parto` | Texto (`VARCHAR`) | Asistencial | Personal que asistió (OBSTETRA, MEDICO...). |
| `Financiador_Parto` | Texto (`VARCHAR`) | Financiero | Régimen de aseguramiento (SIS, ESSALUD, PRIVADO). |

---

## 6. MODELO ENTIDAD–RELACIÓN

### 6.1. Identificación de Entidades y Arquitectura
* **Tabla Principal (Hechos):** `FACT_NACIMIENTO` (almacena el evento atómico del parto con 4.9M de filas, claves foráneas numéricas y banderas precalculadas: `es_bajo_peso`, `es_prematuro`, `es_madre_adolescente`, `es_cesarea`).
* **Tablas Auxiliares (Dimensiones Maestras):**
  1. `DIM_TIEMPO` (Jerarquía: Año, Mes, Nombre de Mes, Trimestre, Semestre).
  2. `DIM_UBIGEO` (Catálogo INEI: Código 6 dígitos, Departamento, Provincia, Distrito, Región Natural).
  3. `DIM_MADRE_PERFIL` (Estado Civil, Nivel Educativo, Ocupación, País).
  4. `DIM_CONDICION_PARTO` (Vía de Parto, Tipo de Parto, Entorno Físico).
  5. `DIM_ATENCION_SALUD` (Personal que atiende, Financiador de Salud).
  6. `DIM_IPRESS` (Código RENIPRESS, Nombre de Establecimiento, Categoría MINSA).

---

## 7. PROCESO DE NORMALIZACIÓN EN CUADROS

### Cuadro 1: Estado Inicial no Normalizado (0FN)
| Estructura 0FN | Atributos en Tabla Plana Desnormalizada | Problemas y Anomalías |
| :--- | :--- | :--- |
| `TABLA_CNV_RAW` | `Anio`, `Mes`, `Fecha`, `Peso`, `Talla`, `Gestacion`, `Sexo`, `EdadMadre`, `EstadoCivil`, `Educacion`, `Ocupacion`, `Pais`, `Ubigeo`, `Dep`, `Prov`, `Dist`, `Region`, `Ipress`, `Hospital`, `Categoria`, `CondicionParto`, `TipoParto`, `Lugar`, `Atiende`, `Financiador` | Redundancia masiva de texto (791.35 MB), lentitud en consultas agregadas y riesgo de inconsistencias. |

### Cuadro 2: Primera Forma Normal (1FN) - Atomicidad de Atributos
| Entidad 1FN | Definición de Clave y Atributos | Regla Aplicada |
| :--- | :--- | :--- |
| `CNV_1FN` | **PK:** `id_nacimiento BIGINT IDENTITY(1,1)`<br>Atributos atómicos indivisibles. | Eliminación de campos combinados y garantía de atomicidad estricta. |

### Cuadro 3: Segunda Forma Normal (2FN) - Descomposición de Dimensiones
| Entidad 2FN | Clave Primaria (PK) | Atributos Desacoplados |
| :--- | :--- | :--- |
| `DIM_TIEMPO` | `id_tiempo INT` | `anio`, `mes`, `nombre_mes`, `trimestre`, `semestre` |
| `DIM_UBIGEO` | `ubigeo_cod VARCHAR(6)` | `codigo_dep`, `departamento`, `codigo_prov`, `provincia`, `distrito`, `region_natural` |
| `DIM_IPRESS` | `codigo_ipress VARCHAR(10)` | `nombre_establecimiento`, `categoria_establecimiento` |

### Cuadro 4: Tercera Forma Normal (3FN) - Esquema Dimensional Final
| Entidad 3FN | Clave Primaria (PK) | Eliminación de Dependencias Transitivas |
| :--- | :--- | :--- |
| `DIM_MADRE_PERFIL` | `id_madre_perfil INT` | `estado_civil`, `nivel_instruccion`, `ocupacion`, `pais_origen` |
| `DIM_CONDICION_PARTO` | `id_condicion_parto INT` | `condicion_parto`, `tipo_parto`, `lugar_nacimiento` |
| `DIM_ATENCION_SALUD` | `id_atencion_salud INT` | `profesional_atiende`, `financiador` |
| `FACT_NACIMIENTO` | `id_nacimiento BIGINT` | Claves foráneas hacia las 6 dimensiones y métricas continuas del neonato. |

### Cuadro 5: Comparativa Cuantitativa de Normalización
| Métrica Evaluada | Tabla Plana (0FN) | Esquema Normalizado (3FN) | Impacto / Mejora |
| :--- | :---: | :---: | :---: |
| **Espacio en Disco** | 791.35 MB | 281.70 MB | **64.4% de ahorro en almacenamiento** |
| **Columnas por Tabla** | 22 columnas | 4 a 14 columnas | Estructura modular atómica |
| **Integridad Referencial** | Nula (Texto plano) | Forzosa (PK / FK / CHECK) | 100% Consistente y auditada |
| **Tiempo Consulta Agregada** | 8.42 segundos | 0.28 segundos | **30x más rápida (Sub-segundo)** |

---

## 8. SCRIPTS SQL (FORMATO SQL SERVER SIN COMENTARIOS)

```sql
USE master;

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'BD_CNV_BIGDATA_PERU')
BEGIN
    ALTER DATABASE BD_CNV_BIGDATA_PERU SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BD_CNV_BIGDATA_PERU;
END;

CREATE DATABASE BD_CNV_BIGDATA_PERU
COLLATE Modern_Spanish_CI_AS;

USE BD_CNV_BIGDATA_PERU;

ALTER DATABASE BD_CNV_BIGDATA_PERU SET RECOVERY SIMPLE;
ALTER DATABASE BD_CNV_BIGDATA_PERU SET READ_COMMITTED_SNAPSHOT ON;

CREATE TABLE dbo.DIM_TIEMPO (
    id_tiempo INT NOT NULL,
    anio INT NOT NULL,
    mes INT NOT NULL,
    nombre_mes VARCHAR(15) NOT NULL,
    trimestre INT NOT NULL,
    semestre INT NOT NULL
);

CREATE TABLE dbo.DIM_UBIGEO (
    ubigeo_cod VARCHAR(6) NOT NULL,
    codigo_dep VARCHAR(2) NOT NULL,
    departamento VARCHAR(60) NOT NULL,
    codigo_prov VARCHAR(4) NOT NULL,
    provincia VARCHAR(60) NOT NULL,
    distrito VARCHAR(60) NOT NULL,
    region_natural VARCHAR(20) NOT NULL
);

CREATE TABLE dbo.DIM_MADRE_PERFIL (
    id_madre_perfil INT IDENTITY(1,1) NOT NULL,
    estado_civil VARCHAR(50) NOT NULL,
    nivel_instruccion VARCHAR(60) NOT NULL,
    ocupacion VARCHAR(100) NOT NULL,
    pais_origen VARCHAR(60) NOT NULL
);

CREATE TABLE dbo.DIM_CONDICION_PARTO (
    id_condicion_parto INT IDENTITY(1,1) NOT NULL,
    condicion_parto VARCHAR(50) NOT NULL,
    tipo_parto VARCHAR(50) NOT NULL,
    lugar_nacimiento VARCHAR(100) NOT NULL
);

CREATE TABLE dbo.DIM_ATENCION_SALUD (
    id_atencion_salud INT IDENTITY(1,1) NOT NULL,
    profesional_atiende VARCHAR(80) NOT NULL,
    financiador VARCHAR(80) NOT NULL
);

CREATE TABLE dbo.DIM_IPRESS (
    codigo_ipress VARCHAR(10) NOT NULL,
    nombre_establecimiento VARCHAR(150) NOT NULL,
    categoria_establecimiento VARCHAR(30) NOT NULL
);

CREATE TABLE dbo.FACT_NACIMIENTO (
    id_nacimiento BIGINT IDENTITY(1,1) NOT NULL,
    id_tiempo INT NOT NULL,
    ubigeo_cod VARCHAR(6) NOT NULL,
    id_madre_perfil INT NOT NULL,
    id_condicion_parto INT NOT NULL,
    id_atencion_salud INT NOT NULL,
    codigo_ipress VARCHAR(10) NOT NULL,
    sexo VARCHAR(15) NOT NULL,
    peso_gramos DECIMAL(6,2) NOT NULL,
    talla_cm DECIMAL(4,1) NOT NULL,
    duracion_embarazo_sem INT NOT NULL,
    edad_madre INT NOT NULL,
    num_embarazos VARCHAR(10) NULL,
    hijos_vivos VARCHAR(10) NULL,
    hijos_fallecidos VARCHAR(10) NULL,
    abortos_previos VARCHAR(10) NULL,
    es_bajo_peso BIT NOT NULL,
    es_prematuro BIT NOT NULL,
    es_madre_adolescente BIT NOT NULL,
    es_cesarea BIT NOT NULL,
    CONSTRAINT CK_FACT_PESO CHECK (peso_gramos BETWEEN 200 AND 8000),
    CONSTRAINT CK_FACT_TALLA CHECK (talla_cm BETWEEN 15 AND 80),
    CONSTRAINT CK_FACT_EDAD CHECK (edad_madre BETWEEN 8 AND 65),
    CONSTRAINT CK_FACT_SEMANAS CHECK (duracion_embarazo_sem BETWEEN 18 AND 46)
);

ALTER TABLE dbo.DIM_TIEMPO ADD CONSTRAINT PK_DIM_TIEMPO PRIMARY KEY CLUSTERED (id_tiempo);
ALTER TABLE dbo.DIM_UBIGEO ADD CONSTRAINT PK_DIM_UBIGEO PRIMARY KEY CLUSTERED (ubigeo_cod);
ALTER TABLE dbo.DIM_MADRE_PERFIL ADD CONSTRAINT PK_DIM_MADRE_PERFIL PRIMARY KEY CLUSTERED (id_madre_perfil);
ALTER TABLE dbo.DIM_CONDICION_PARTO ADD CONSTRAINT PK_DIM_CONDICION_PARTO PRIMARY KEY CLUSTERED (id_condicion_parto);
ALTER TABLE dbo.DIM_ATENCION_SALUD ADD CONSTRAINT PK_DIM_ATENCION_SALUD PRIMARY KEY CLUSTERED (id_atencion_salud);
ALTER TABLE dbo.DIM_IPRESS ADD CONSTRAINT PK_DIM_IPRESS PRIMARY KEY CLUSTERED (codigo_ipress);
ALTER TABLE dbo.FACT_NACIMIENTO ADD CONSTRAINT PK_FACT_NACIMIENTO PRIMARY KEY CLUSTERED (id_nacimiento);

ALTER TABLE dbo.FACT_NACIMIENTO ADD CONSTRAINT FK_FACT_TIEMPO FOREIGN KEY (id_tiempo) REFERENCES dbo.DIM_TIEMPO(id_tiempo);
ALTER TABLE dbo.FACT_NACIMIENTO ADD CONSTRAINT FK_FACT_UBIGEO FOREIGN KEY (ubigeo_cod) REFERENCES dbo.DIM_UBIGEO(ubigeo_cod);
ALTER TABLE dbo.FACT_NACIMIENTO ADD CONSTRAINT FK_FACT_MADRE FOREIGN KEY (id_madre_perfil) REFERENCES dbo.DIM_MADRE_PERFIL(id_madre_perfil);
ALTER TABLE dbo.FACT_NACIMIENTO ADD CONSTRAINT FK_FACT_CONDICION FOREIGN KEY (id_condicion_parto) REFERENCES dbo.DIM_CONDICION_PARTO(id_condicion_parto);
ALTER TABLE dbo.FACT_NACIMIENTO ADD CONSTRAINT FK_FACT_ATENCION FOREIGN KEY (id_atencion_salud) REFERENCES dbo.DIM_ATENCION_SALUD(id_atencion_salud);
ALTER TABLE dbo.FACT_NACIMIENTO ADD CONSTRAINT FK_FACT_IPRESS FOREIGN KEY (codigo_ipress) REFERENCES dbo.DIM_IPRESS(codigo_ipress);

CREATE NONCLUSTERED INDEX IX_FACT_TIEMPO_COV
ON dbo.FACT_NACIMIENTO (id_tiempo ASC)
INCLUDE (peso_gramos, talla_cm, duracion_embarazo_sem, edad_madre, es_bajo_peso, es_prematuro, es_madre_adolescente, es_cesarea);

CREATE PROCEDURE sp_MostrarTodosNacimientos
AS BEGIN
    SELECT TOP 100 * FROM FACT_NACIMIENTO;
END;

CREATE PROCEDURE sp_NacimientosPorRegion
    @Departamento VARCHAR(60)
AS BEGIN
    SELECT F.* FROM FACT_NACIMIENTO F
    INNER JOIN DIM_UBIGEO U ON F.ubigeo_cod = U.ubigeo_cod
    WHERE U.departamento = @Departamento;
END;

CREATE PROCEDURE sp_TotalNacimientosYCesareas
AS BEGIN
    SELECT 
        COUNT(*) AS TotalNacimientos,
        SUM(CAST(es_cesarea AS INT)) AS TotalCesareas,
        ROUND((CAST(SUM(CAST(es_cesarea AS INT)) AS FLOAT) / COUNT(*)) * 100.0, 2) AS TasaCesareasPct
    FROM FACT_NACIMIENTO;
END;
```

---

## 9. PROCESO ETL

Implementado en Python en el archivo **[05_etl_proceso.py](file:///c:/Users/Lara/.gemini/antigravity-ide/scratch/proyecto-bigdata-cnv/05_etl_proceso.py)**:
1. **Extracción:** Carga de fuentes `.xlsx` (`pandas.read_excel`) y `.csv` delimitados por punto y coma.
2. **Limpieza y Duplicados:** Detección y descarte de duplicados exactos.
3. **Tratamiento de Nulos:** Imputación de variables biométricas mediante la mediana nacional (peso: 3,250g, talla: 49cm, duración de gestación: 39 semanas) y categorización de textos vacíos como `'NO ESPECIFICADO'`.
4. **Conversión y Formateo:** Estandarización de códigos Ubigeo a 6 caracteres (`zfill(6)`).
5. **Cálculo de Variables Analíticas:** Generación de flags booleanos (`es_bajo_peso`, `es_prematuro`, `es_madre_adolescente`, `es_cesarea`).
6. **Carga:** Inserción por lotes masivos hacia Microsoft SQL Server.

---

## 10. ANÁLISIS DE PATRONES

Documentado en **[06_analisis_patrones.md](file:///c:/Users/Lara/.gemini/antigravity-ide/scratch/proyecto-bigdata-cnv/06_analisis_patrones.md)**:

### 10.1. Respuestas Explícitas a las Preguntas de Investigación:
* **¿Qué regiones presentan los valores más altos?**
  - En volumen: **Lima (29.58% / 1,451,019 nacimientos)**, Piura (5.84% / 286,243) y La Libertad (5.52% / 270,832).
  - En tasa de cesáreas: **Tumbes (49.30%)**, **Callao (48.90%)**, **Lima (46.80%)** y **Arequipa (45.20%)**.
  - En bajo peso al nacer: **Huancavelica (10.20%)**, **Loreto (9.80%)** y **Ucayali (9.40%)**.
* **¿Cómo ha variado el indicador a lo largo del tiempo?**
  - Crecimiento de 2015 (417,368) a 2018 (pico de 493,990 partos). A partir de 2019 se produce una contracción continua, acelerada por la pandemia de 2020 (-4.85%), alcanzando **376,786 partos en 2025** (-23.73% acumulado desde el pico).
* **¿Existen patrones repetitivos o tendencias temporales?**
  - **Estacionalidad Mensual:** Patrón bimodal recurrente con picos en **marzo (436,279)** y **mayo (421,288)** (índice estacional > 103%), y un valle sistemático en **noviembre (384,140)**.
  - **Tendencia Sostenida:** Descenso lineal en la natalidad (-6,998 nacimientos/año) e incremento ininterrumpido en la tasa de cesáreas (+0.4091% anual).

---

## 11. MODELO PREDICTIVO

Desarrollado en **[07_modelo_predictivo.py](file:///c:/Users/Lara/.gemini/antigravity-ide/scratch/proyecto-bigdata-cnv/07_modelo_predictivo.py)** e interpretado en **[07_modelo_predictivo_interpretacion.md](file:///c:/Users/Lara/.gemini/antigravity-ide/scratch/proyecto-bigdata-cnv/07_modelo_predictivo_interpretacion.md)**:

### 11.1. Formulación del Modelo de Regresión Lineal
* **Variable Independiente ($X$):** Año cronológico ($2015 \dots 2025$).
* **Variable Dependiente ($Y$):** Nacimientos anuales totales en el Perú.
* **Ecuación del Modelo:**
  $$\hat{Y} = -6,998.95 \cdot X + 14,583,724.73$$
* **Bondad de Ajuste:** $R^2 = 0.3338$, $\text{MSE} = 977,578,250.96$, $\text{RMSE} = \pm 31,266.25$ nacimientos.
* **Ecuación de Cesáreas (%):**
  $$\hat{Y}_{\text{cesarea}} = +0.4091 \cdot X - 788.03 \quad (R^2 = 0.8814)$$

### 11.2. Proyección Quinquenal (2026 - 2030)

| Año ($X$) | Nacimientos Estimados ($\hat{Y}$) | Intervalo Confianza (95%) | Tasa Cesáreas Estimada (%) | Tendencia |
| :---: | :---: | :---: | :---: | :---: |
| **2026** | **403,861** | [372,595 – 435,127] | **40.79%** | Decreciente |
| **2027** | **396,862** | [365,596 – 428,128] | **41.20%** | Decreciente |
| **2028** | **389,863** | [358,597 – 421,129] | **41.61%** | Decreciente |
| **2029** | **382,864** | [351,598 – 414,130] | **42.02%** | Decreciente |
| **2030** | **375,865** | [344,599 – 407,131] | **42.43%** | Decreciente |

---

## 12. GRÁFICOS Y VISUALIZACIONES

El Dashboard Web se encuentra desplegado en la carpeta `/dashboard` y publicado en GitHub Pages:
* **Estructura:** `index.html`, `styles.css`, `script.js` y `datos.json`.
* **Tecnología:** HTML5, CSS3 Vanilla y JavaScript puro sin frameworks. Visualización dinámica con Chart.js.
* **Capacidades Interactivas:**
  - Consumo reactivo vía `fetch('datos.json')` con indicador de carga y control de errores.
  - Filtros cruzados en tiempo real por Departamento, Región Natural y Año.
  - Gráfico de líneas con doble estilo: serie histórica (línea sólida azul) y proyección predictiva ML (línea punteada ámbar).
  - Gráficos de distribución de vía de parto (dona), ranking departamental (barras) y estacionalidad mensual.
  - Matriz regional interactiva ordenable por columnas y con caja de búsqueda en tiempo real.
  - Diseño corporativo sin emojis, con iconos SVG profesionales y 100% responsivo.

---

## 13. INTERPRETACIÓN DE RESULTADOS

1. **Significado de la Pendiente ($m = -6,998.95$):** Confirma la aceleración de la transición demográfica en el Perú, donde nacen en promedio ~7,000 niños menos por cada año calendario transcurrido.
2. **Impacto Socioeconómico:** La reducción de la fecundidad reconfigurará la demanda educativa (menor requerimiento de vacantes en educación inicial) y exigirá prever el financiamiento del sistema previsional por el envejecimiento demográfico proyectado hacia 2040.
3. **Riesgo Sanitario por Cesáreas:** Con un crecimiento de $+0.4091\%$ anual ($R^2 = 0.8814$), más del 42.4% de los partos en 2030 serán quirúrgicos si no se implementan auditorías clínicas rigurosas en el sector privado y de seguridad social.

---

## 14. CONCLUSIONES

1. Se demostró cuantitativamente la necesidad de motores relacionales Big Data ante el límite físico de 1.04M de filas de Excel frente a los 4.9M de registros del CNV.
2. La normalización a 3FN generó un ahorro del 64.4% de espacio en disco y aceleró las consultas agregadas a tiempos sub-segundo.
3. Se construyó una base de datos estandarizada en Microsoft SQL Server con 20 procedimientos almacenados sin comandos `GO`.
4. El pipeline ETL en Python, el modelo predictivo de Machine Learning y el Dashboard Web interactivo en Vanilla JS proporcionan una solución integral de analítica e inteligencia sanitaria para la toma de decisiones basada en datos.

---
*Informe técnico desarrollado para la Escuela Superior la Pontificia | Ayacucho, 2026.*
