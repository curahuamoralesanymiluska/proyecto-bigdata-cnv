# Escuela Superior la Pontificia
## Carrera: Ingeniería de Sistemas de Información | Ciclo: VIII – B
### Curso: Gestión de Base de Datos / Big Data
#### Docente: Ing. Erick Jhonatan Palomino Ayala
##### Ayacucho, 2026

---

# Documento 06: Análisis de Patrones y Secuencias Temporales

## 1. Introducción al Análisis Temporal de Datos Abiertos

El presente análisis explora la serie cronológica de **4,904,793 registros de nacimientos** en el Perú, correspondiente al período oficial **2015 - 2025** (MINSA / RENIEC). A través de la agregación de datos procesados mediante el pipeline ETL, se identifican patrones de comportamiento, estacionalidad mensual y dispersión geográfica departamental.

---

## 2. Tablas Resumen Multianual y Regional

### 2.1. Evolución Temporal Anual Nacional (2015 - 2025)

| Año | Nacimientos Registrados | Participación (%) | Variación Anual Absoluta | Tasa de Variación (%) | Partos por Cesárea | Tasa de Cesáreas (%) |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **2015** | 417,368 | 8.51% | — | — | 148,165 | 35.50% |
| **2016** | 459,690 | 9.37% | +42,322 | +10.14% | 166,408 | 36.20% |
| **2017** | 480,441 | 9.79% | +20,751 | +4.51% | 178,724 | 37.20% |
| **2018** | **493,990** | **10.07%** | **+13,549** | **+2.82%** | **188,704** | **38.20%** |
| **2019** | 485,235 | 9.89% | -8,755 | -1.77% | 187,786 | 38.70% |
| **2020** | 461,714 | 9.41% | -23,521 | -4.85% | 179,145 | 38.80% |
| **2021** | 462,633 | 9.43% | +919 | +0.20% | 179,502 | 38.80% |
| **2022** | 466,016 | 9.50% | +3,383 | +0.73% | 182,678 | 39.20% |
| **2023** | 410,465 | 8.37% | -55,551 | -11.92% | 162,134 | 39.50% |
| **2024** | 390,066 | 7.95% | -20,399 | -4.97% | 154,856 | 39.70% |
| **2025** | 376,786 | 7.68% | -13,280 | -3.40% | 150,336 | 39.90% |
| **TOTAL** | **4,904,793** | **100.00%** | — | — | **1,887,061** | **38.47%** |

---

### 2.2. Distribución y Concentración por Regiones / Departamentos

| # | Departamento | Región Natural | Nacimientos Totales | Participación (%) | Tasa Estimada Cesáreas (%) | Tasa Bajo Peso (<2500g) |
| :-: | :--- | :--- | :---: | :---: | :---: | :---: |
| 1 | **LIMA** | Costa / Metropolitana | 1,451,019 | 29.58% | 46.80% | 6.80% |
| 2 | **PIURA** | Costa | 286,243 | 5.84% | 36.10% | 7.50% |
| 3 | **LA LIBERTAD** | Costa | 270,832 | 5.52% | 38.40% | 7.10% |
| 4 | **CUSCO** | Sierra | 222,356 | 4.53% | 32.10% | 8.40% |
| 5 | **CAJAMARCA** | Sierra | 221,145 | 4.51% | 27.50% | 8.90% |
| 6 | **JUNIN** | Sierra | 212,291 | 4.33% | 34.60% | 8.20% |
| 7 | **AREQUIPA** | Sierra | 210,998 | 4.30% | 45.20% | 6.90% |
| 8 | **LORETO** | Selva | 209,946 | 4.28% | 29.40% | 9.80% |
| 9 | **LAMBAYEQUE** | Costa | 179,561 | 3.66% | 41.30% | 7.20% |
| 10 | **ANCASH** | Sierra / Costa | 179,158 | 3.65% | 35.80% | 7.60% |
| 11 | **PUNO** | Sierra | 162,011 | 3.30% | 24.30% | 9.10% |
| 12 | **HUANUCO** | Sierra / Selva | 158,563 | 3.23% | 28.70% | 8.80% |
| 13 | **CALLAO** | Costa | 157,973 | 3.22% | 48.90% | 7.00% |
| 14 | **SAN MARTIN** | Selva | 157,414 | 3.21% | 33.20% | 8.10% |
| 15 | **ICA** | Costa | 155,403 | 3.17% | 44.50% | 6.70% |
| 16 | **UCAYALI** | Selva | 127,730 | 2.60% | 31.80% | 9.40% |
| 17 | **AYACUCHO** | Sierra | 119,729 | 2.44% | 29.80% | 8.70% |
| 18 | **APURIMAC** | Sierra | 78,722 | 1.60% | 28.10% | 8.50% |
| 19 | **HUANCAVELICA**| Sierra | 75,644 | 1.54% | 21.20% | 10.20% |
| 20 | **AMAZONAS** | Selva | 59,699 | 1.22% | 26.40% | 9.30% |
| 21 | **PASCO** | Sierra | 50,416 | 1.03% | 29.10% | 8.90% |
| 22 | **TACNA** | Costa | 44,692 | 0.91% | 43.70% | 6.50% |
| 23 | **TUMBES** | Costa | 41,953 | 0.86% | 49.30% | 7.40% |
| 24 | **MADRE DE DIOS**| Selva | 36,817 | 0.75% | 34.20% | 8.90% |
| 25 | **MOQUEGUA** | Costa / Sierra | 25,360 | 0.52% | 42.10% | 6.40% |
| — | *Otros / Sin ubigeo* | — | 8,729 | 0.18% | — | — |
| **TOTAL** | **PERÚ (25 REGIONES)**| **NACIONAL** | **4,904,793** | **100.00%** | **38.47%** | **7.30%** |

---

### 2.3. Estacionalidad Mensual Acumulada (Patrón Intra-anual)

| Mes Calendario | Nacimientos Acumulados | Participación (%) | Índice Estacional (Base 100) | Observación |
| :---: | :---: | :---: | :---: | :--- |
| **Enero** | 414,253 | 8.45% | 101.35 | Nivel medio alto |
| **Febrero** | 393,863 | 8.03% | 96.36 | Mes corto (28/29 días) |
| **Marzo** | **436,279** | **8.89%** | **106.74** | **Pico máximo del primer semestre** |
| **Abril** | 415,773 | 8.48% | 101.72 | Nivel medio alto |
| **Mayo** | **421,288** | **8.59%** | **103.07** | **Segundo mes con mayor frecuencia** |
| **Junio** | 403,571 | 8.23% | 98.74 | Nivel medio |
| **Julio** | 412,636 | 8.41% | 100.95 | Nivel medio alto |
| **Agosto** | 408,318 | 8.32% | 99.90 | Nivel promedio |
| **Setiembre** | 417,214 | 8.51% | 102.08 | Repunte del tercer trimestre |
| **Octubre** | 403,373 | 8.22% | 98.69 | Nivel medio |
| **Noviembre** | **384,140** | **7.83%** | **93.98** | **Mes con menor volumen de registros** |
| **Diciembre** | 393,696 | 8.03% | 96.32 | Nivel medio bajo |

---

## 3. Respuestas Explícitas a las Preguntas de Investigación

### Pregunta 1: ¿Qué regiones presentan los valores más altos del indicador elegido?
1. **En Volumen Total de Nacimientos**:
   - **Lima Metropolitana y Región Lima** concentra el **29.58% (1,451,019 nacimientos)** del total nacional, superando ampliamente a los siguientes departamentos más poblados: **Piura (5.84% / 286,243)** y **La Libertad (5.52% / 270,832)**.
   - Las 7 principales regiones (Lima, Piura, La Libertad, Cusco, Cajamarca, Junín y Arequipa) concentran el **58.08%** de todos los partos del Perú.
2. **En Tasa de Cesáreas (Sobre-intervención Quirúrgica)**:
   - Las regiones con tasas más elevadas corresponden a la Costa norte y Lima: **Tumbes (49.30%)**, **Callao (48.90%)**, **Lima (46.80%)**, **Arequipa (45.20%)** e **Ica (44.50%)**. En estas regiones, prácticamente 1 de cada 2 partos se realiza por vía quirúrgica.
3. **En Riesgo de Bajo Peso al Nacer (< 2,500 g)**:
   - Las regiones de la Sierra central/sur y Selva registran las tasas más críticas: **Huancavelica (10.20%)**, **Loreto (9.80%)**, **Ucayali (9.40%)**, **Amazonas (9.30%)** y **Puno (9.10%)**, correlacionadas con altos niveles de pobreza rural y menor acceso a controles prenatales.

---

### Pregunta 2: ¿Cómo ha variado el indicador a lo largo del tiempo?
* **Fase de Crecimiento (2015 - 2018)**:
  Los nacimientos se incrementaron progresivamente de **417,368 en 2015** hasta alcanzar el **pico histórico de 493,990 en 2018** (+18.36%), impulsado por la expansión de la cobertura del Certificado de Nacido Vivo en línea (CNV) del MINSA/RENIEC.
* **Fase de Contracción y Efecto Pandemia (2019 - 2022)**:
  A partir de 2019 se observa una caída leve (-1.77%), seguida de una contracción brusca en **2020 de -4.85% (461,714 nacimientos)** provocada por el confinamiento de la pandemia de COVID-19, la saturación del sistema hospitalario y la postergación de proyectos familiares.
* **Fase de Decrecimiento Estructural Sostenido (2023 - 2025)**:
  Entre 2022 y 2025 se evidencia una aceleración del declive demográfico nacional:
  - 2023: 410,465 (-11.92%)
  - 2024: 390,066 (-4.97%)
  - 2025: 376,786 (-3.40%)
  En el balance global 2018 vs 2025, el Perú registra una **reducción neta de -117,204 nacimientos anuales (-23.73%)**, marcando el inicio de una transición demográfica acelerada con menor tasa global de fecundidad.

---

### Pregunta 3: ¿Existen patrones repetitivos o tendencias temporales (estacionalidad, tendencia sostenida)?
1. **Patrón Estacional Intra-anual (Ciclo Repetitivo Mensual)**:
   - Se identifica un patrón recurrente bimodal: el **primer pico ocurre consistentemente en marzo y mayo** (índice estacional > 103%), correspondiente a concepciones generadas entre junio y agosto del año anterior.
   - El **valle estacional se produce de forma sistemática en noviembre** (índice estacional de 93.98%), siendo el mes con menor registro de alumbramientos a nivel nacional.
2. **Tendencia Sostenida y Estructural**:
   - **Descendente en Natalidad**: La pendiente multianual post-2018 es estrictamente decreciente a un ritmo promedio de **-16,740 nacimientos por año**.
   - **Ascendente en Tasa de Cesáreas**: A diferencia del volumen de partos que disminuye, el porcentaje de partos por cesárea muestra una **tendencia creciente ininterrumpida**, pasando de **35.50% en 2015 a 39.90% en 2025**, distanciándose progresivamente del estándar internacional de la OMS (15.00%).

---
*Análisis desarrollado para la Escuela Superior la Pontificia | Ayacucho, 2026.*
