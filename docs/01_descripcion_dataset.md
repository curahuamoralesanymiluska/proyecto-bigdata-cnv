# Actividad: Big Data con Datos Abiertos Reales
## Escuela de Educación Superior Tecnológica La Pontificia
### Curso: Big Data | Proyecto Académico

---

# Documento 01: Descripción del Conjunto de Datos Oficial

## 1. Ficha Técnica del Dataset

| Parámetro | Detalle |
| :--- | :--- |
| **Plataforma de Origen** | Plataforma Nacional de Datos Abiertos del Perú ([datosabiertos.gob.pe](https://www.datosabiertos.gob.pe/)) |
| **Nombre Oficial del Dataset** | *Registros de nacidos vivos en el Perú 2026* (Certificado de Nacido Vivo - CNV) |
| **Entidad Productora / Custodio** | Ministerio de Salud del Perú (MINSA) / RENIEC / OTI |
| **URL Oficial de Descarga** | [https://www.datosabiertos.gob.pe/dataset/registros-de-nacidos-vivos-en-el-per%C3%BA-2026](https://www.datosabiertos.gob.pe/dataset/registros-de-nacidos-vivos-en-el-per%C3%BA-2026) |
| **Nombre Interno del Archivo** | `DATOS_ABIERTOS_CNV_31122025.csv` (Corte oficial al 31/12/2025) |
| **Formato y Peso** | Archivo CSV delimitado por punto y coma (`;`), codificación Latin-1 / UTF-8, **791.35 MB** (~829.8 MB en disco) |
| **Período Temporal** | 11 años completos: **2015 al 2025** (con proyección y continuidad hacia el 2026) |
| **Total Real de Registros** | **4,904,793 filas** (4.90 millones de nacimientos analizados) |
| **Total de Variables / Columnas** | **22 variables** |

---

## 2. Hallazgo Crítico sobre el Volumen de Datos (Big Data vs Límite de Excel)

> [!IMPORTANT]
> **Verificación del límite de filas de Microsoft Excel:**
> Al abrir este archivo en Microsoft Excel tradicional, la aplicación trunca automáticamente la visualización al registro **1,048,576** (límite físico de una hoja de cálculo `.xlsx`), arrojando un mensaje de datos incompletos.
> 
> Al procesar el archivo mediante **Python (Pandas / Streaming CSV)**, se verificó que el conjunto de datos contiene **4,904,793 filas reales**, lo que representa **casi 5 veces más información** de lo que Excel es capaz de visualizar. Esto justifica y valida plenamente el uso de tecnologías de **Big Data y procesamiento analítico programático** para este proyecto.

### Distribución Temporal de Registros por Año (2015 - 2025)

```
2015: ████████████████ 417,368 nacimientos (8.51%)
2016: █████████████████ 459,690 nacimientos (9.37%)
2017: ██████████████████ 480,441 nacimientos (9.80%)
2018: ███████████████████ 493,990 nacimientos (10.07%) [Pico histórico]
2019: ███████████████████ 485,235 nacimientos (9.89%)
2020: ██████████████████ 461,714 nacimientos (9.41%) [Pandemia COVID-19]
2021: ██████████████████ 462,633 nacimientos (9.43%)
2022: ██████████████████ 466,016 nacimientos (9.50%)
2023: ████████████████ 410,465 nacimientos (8.37%)
2024: ███████████████ 390,066 nacimientos (7.95%)
2025: ██████████████ 376,786 nacimientos (7.68%)
```
*Total acumulado: 4,904,793 registros analizados.*

---

## 3. Diccionario Completo de Variables y Tipos de Datos

El dataset cuenta con **22 columnas** que capturan información biométrica del neonato, perfil sociodemográfico de la madre y condiciones clínicas del parto.

| # | Nombre de Columna Original | Nombre Normalizado | Tipo de Dato | Naturaleza Estadística | Descripción y Rango de Valores | % Nulos / Vacíos |
| :-: | :--- | :--- | :--- | :--- | :--- | :-: |
| **1** | `FecNac_Año` | `anio_nacimiento` | `INTEGER` | Cuantitativa Discreta | Año de nacimiento del infante (Rango: 2015 - 2025). | 0.00% |
| **2** | `FecNac_Mes` | `mes_nacimiento` | `VARCHAR(2)` | Categórica Ordinal | Mes de nacimiento en formato dos dígitos ('01' a '12'). | 0.00% |
| **3** | `PESO_NACIDO` | `peso_gramos` | `DECIMAL(6,2)` | Cuantitativa Continua | Peso del recién nacido en gramos. Promedio: **3,248.8 g**, Mínimo válido: **300 g**, Máximo: **7,010 g**. | 0.03% |
| **4** | `TALLA_NACIDO` | `talla_cm` | `DECIMAL(4,1)` | Cuantitativa Continua | Talla del recién nacido en centímetros. Promedio: **49.15 cm**, Rango: **22.0 - 74.9 cm**. | 0.10% |
| **5** | `DUR_EMB_PARTO` | `duracion_semanas` | `INTEGER` | Cuantitativa Discreta | Edad gestacional al momento del parto en semanas. Promedio: **38.62 semanas** (Rango clínico: 20 - 43 semanas). | 0.01% |
| **6** | `Condicion_Parto` | `condicion_parto` | `VARCHAR(30)` | Categórica Nominal | Condición médica del parto: `EUTOCICO` (61.06%), `CESAREA` (38.47%), `INSTRUMENTADO` (0.14%), `IGNORADO` (0.32%). | 0.00% |
| **7** | `sexo_nacido` | `sexo` | `VARCHAR(15)` | Categórica Nominal | Sexo del recién nacido: `MASCULINO` (51.08%), `FEMENINO` (48.91%), `IGNORADO` (188 casos). | 0.00% |
| **8** | `Tipo_Parto` | `tipo_parto` | `VARCHAR(20)` | Categórica Nominal | Pluralidad del nacimiento: `UNICO` (98.09%), `DOBLE` (1.70%), `TRIPLE` (0.03%), `MAS DE TRES` (78 casos). | 0.00% |
| **9** | `Edad_Madre` | `edad_madre` | `INTEGER` | Cuantitativa Discreta | Edad cronológica de la madre en años cumplidos. Promedio: **28.30 años**, Mínimo: **8 años** (embarazo infantil extremo), Máximo: **62 años**. | 0.01% |
| **10** | `Estado_Civil` | `estado_civil_madre`| `VARCHAR(20)` | Categórica Nominal | Estado civil de la madre: `SOLTERO` (84.61%), `CASADO` (9.13%), `CONVIVIENTE` (1.67%), `DIVORCIADO` (0.39%), `VIUDO` (0.04%), `IGNORADO` (4.15%). | 0.00% |
| **11** | `Nivel_Intrucción_Madre` | `nivel_instruccion_madre` | `VARCHAR(40)` | Categórica Ordinal | Nivel educativo máximo alcanzado por la madre: Secundaria Completa (35.09%), Secundaria Incompleta (16.77%), Superior No Univ. (17.43%), Superior Univ. (16.11%), Primaria (13.68%), Iletrado (0.84%). | 0.00% |
| **12** | `DESC_OCUPACION` | `ocupacion_madre` | `VARCHAR(80)` | Categórica Nominal | Ocupación laboral principal de la madre: `AMA DE CASA` (83.82%), Contador, Docente, Administrador, Comerciante, etc. | 0.00% |
| **13** | `Num_embar_madre` | `num_embarazos` | `VARCHAR(10)` | Cuantitativa / Categórica | Número total de embarazos de la madre ('1', '2', '3', '4', '>=5'). | 1.02% |
| **14** | `Hijos_vivo_madre` | `hijos_vivos` | `VARCHAR(10)` | Cuantitativa / Categórica | Número de hijos que nacieron vivos y continúan con vida ('1', '2', '3', '4', '>=5'). | 0.77% |
| **15** | `Hijos_fallec_madre` | `hijos_fallecidos` | `VARCHAR(10)` | Cuantitativa / Categórica | Cantidad de hijos previos nacidos vivos que fallecieron posteriormente. | 96.97% (Valor '-1' / No aplica) |
| **16** | `nacmuer_abort_madre` | `abortos_muertos` | `VARCHAR(20)` | Categórica / Discreta | Antecedentes de óbitos fetales o abortos previos ('NINGUNO', '1', '2', '>=3'). | 0.00% |
| **17** | `Pais_Madre` | `pais_madre` | `VARCHAR(40)` | Categórica Nominal | País de origen/nacionalidad de la madre (`PERU` >98%, `VENEZUELA`, `COLOMBIA`, `ECUADOR`, etc.). | 0.00% |
| **18** | `IdUbigeoInei` | `ubigeo_inei` | `VARCHAR(6)` | Categórica / Geográfica | Código oficial de 6 dígitos del INEI (Departamento [2], Provincia [2], Distrito [2]). | 0.18% |
| **19** | `Ipress` | `codigo_ipress` | `VARCHAR(10)` | Identificador Clínico | Código Único del Registro Nacional de Instituciones Prestadoras de Servicios de Salud (RENIPRESS / SUSALUD). | <0.01% |
| **20** | `Lugar_Nacido` | `lugar_nacimiento` | `VARCHAR(40)` | Categórica Nominal | Entorno físico donde ocurrió el parto: `ESTABLECIMIENTO DE SALUD` (98.10%), `DOMICILIO` (1.20%), `OTRO` (0.60%), `VIA PUBLICA` (0.05%). | 0.00% |
| **21** | `Atiende_Parto` | `profesional_atiende` | `VARCHAR(40)` | Categórica Nominal | Personal calificado que asistió el alumbramiento: `OBSTETRA` (50.96%), `MEDICO GINECO-OBSTETRA` (37.79%), `MEDICO` (9.20%), `FAMILIAR` (0.86%), `PARTERA` (0.40%). | 0.00% |
| **22** | `Financiador_Parto` | `financiador_parto` | `VARCHAR(30)` | Categórica Nominal | Cobertura o seguro de salud utilizado: `SIS` (70.08%), `ESSALUD` (17.97%), `PARTICULAR` (5.83%), `PRIVADOS` (4.87%), `SANIDAD FFAA/PNP` (0.45%). | 0.00% |

---

## 4. Selección de Variables Críticas para el Análisis y Modelado

Para la fase de análisis estadístico, Big Data y Machine Learning, se priorizan las siguientes variables clave:

1. **Indicadores de Salud Neonatal**: `PESO_NACIDO`, `TALLA_NACIDO`, `DUR_EMB_PARTO`, `sexo_nacido`.
   - Permiten categorizar clínicamente al recién nacido: *Bajo Peso al Nacer (<2500g)*, *Muy Bajo Peso (<1500g)*, *Prematuro (<37 semanas)* o *Macrocefálico/Macrosómico (>4000g)*.
2. **Determinantes Sociodemográficos Maternos**: `Edad_Madre`, `Nivel_Intrucción_Madre`, `Estado_Civil`, `Num_embar_madre`.
   - Permiten segmentar a la población materna e identificar factores de riesgo como el *embarazo adolescente (<18 años)* o *edad materna avanzada (>35 años)*.
3. **Calidad y Acceso al Sistema de Salud**: `Condicion_Parto` (Cesárea vs Eutócico), `Atiende_Parto`, `Financiador_Parto`, `Lugar_Nacido`.
   - Evalúa la sobreutilización de cesáreas frente al estándar internacional y el alcance del parto institucional vs domiciliario.
4. **Dimensión Espacio-Temporal**: `IdUbigeoInei` (Departamento / Provincia / Distrito) y `FecNac_Año` / `FecNac_Mes`.
   - Permite monitorear tendencias multianuales (2015-2025) y disparidades territoriales entre costa, sierra y selva.

---

## 5. Problemas Sociales y de Salud Pública a Estudiar

A partir de los datos oficiales analizados, el proyecto aborda cuatro problemas públicos estratégicos para el Perú:

### A. Prevalencia de Bajo Peso al Nacer (BPN) y Prematuridad como Factor de Riesgo Infantil
- **Problema**: El bajo peso al nacer (<2,500 g) es el principal predictor de morbimortalidad neonatal, desnutrición crónica infantil y retraso en el desarrollo cognitivo.
- **Utilidad de los datos**: Cuantificar la tasa de BPN por departamento y distrito, e identificar si está fuertemente correlacionado con la falta de instrucción materna, la duración del embarazo y la falta de controles prenatales.

### B. Análisis del Embarazo Adolescente y Maternidad Precoz en el Perú
- **Problema**: El dataset revela registros de madres desde los 8 años hasta los 17 años, con una alta concentración en departamentos de la Amazonía y zonas rurales andinas.
- **Utilidad de los datos**: Medir el impacto del embarazo adolescente sobre el peso del recién nacido, la vía del parto y el financiamiento público (SIS), proporcionando evidencia para focalizar programas de educación sexual integral y prevención de violencia de género.

### C. Disparidad en la Tasa de Cesáreas vs Partos Eutócicos (Estándar OMS)
- **Problema**: La Organización Mundial de la Salud (OMS) recomienda que la tasa de cesáreas no supere el **10% al 15%**. En este dataset nacional, la tasa alcanza un alarmante **38.47%**, superando el 50% en seguros privados y clínicas.
- **Utilidad de los datos**: Comparar la tasa de cesáreas según financiador (`SIS` vs `EsSalud` vs `PRIVADOS`) y según departamento, detectando posibles sobrecostos e intervenciones quirúrgicas innecesarias.

### D. Brecha en el Parto Institucional Calificado y Mortalidad Materno-Perinatal
- **Problema**: A pesar de los avances nacionales, aún existen más de 58,000 partos domiciliarios atendidos por familiares o parteras empíricas, principalmente en comunidades nativas y zonas altoandinas.
- **Utilidad de los datos**: Mapear los focos geográficos de partos no institucionales para orientar la inversión en casas de espera materna y centros de salud I-3 / I-4 del MINSA.

---
*Documentación generada con base en el análisis integral de 4,904,793 registros oficiales de Datos Abiertos Perú.*
