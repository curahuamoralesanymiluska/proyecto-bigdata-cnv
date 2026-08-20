# Actividad: Big Data con Datos Abiertos Reales
## Escuela de Educación Superior Tecnológica La Pontificia
### Curso: Big Data | Proyecto Académico

---

# Documento 06: Consultas Analíticas Avanzadas e Inteligencia de Negocios en Big Data

## 1. Introducción y Propósito Analítico

El valor fundamental de construir una arquitectura dimensional normalizada sobre los **4,904,793 registros** del Certificado de Nacido Vivo (CNV - MINSA/RENIEC) radica en la capacidad de responder preguntas estratégicas de salud pública con velocidad sub-segundo en SQL Server.

En este documento se detallan las consultas analíticas avanzadas implementadas en el script [06_consultas_analiticas.sql](file:///c:/Users/Lara/.gemini/antigravity-ide/scratch/proyecto-bigdata-cnv/06_consultas_analiticas.sql), utilizando técnicas modernas de SQL analítico como **Common Table Expressions (CTEs)**, **Funciones de Ventana (`LAG`, `LEAD`, `DENSE_RANK`, `PARTITION BY`)** y **Cálculo Dinámico de KPIs Sanitarios**.

---

## 2. Detalle de Consultas y Hallazgos Analíticos

### Consulta 1: Evolución Histórica y Tasa de Variación Interanual (LAG/LEAD)
* **Objetivo de Negocio**: Identificar la trayectoria multianual (2015-2025) de los nacimientos en el Perú, cuantificar la caída por la pandemia COVID-19 y proyectar la demanda de servicios de salud infantil y educación básica.
* **Técnica SQL Utilizada**: CTE `ResumenAnual` combinada con la función de ventana `LAG(total_nacimientos, 1) OVER (ORDER BY anio)` para comparar cada año contra el inmediato anterior.
* **Hallazgo Clave**: Entre 2015 y 2018 hubo un incremento sostenido alcanzando el pico de **493,990 nacimientos en 2018**. En 2020 se evidenció una contracción de **-4.85%** debido al impacto del confinamiento y saturación hospitalaria, tendencia descendente que continuó hasta **376,786 nacimientos en 2025** (-23.7% vs 2018).

---

### Consulta 2: Tasa de Cesáreas por Departamento vs Estándar OMS (15%)
* **Objetivo de Negocio**: Evaluar el cumplimiento de las recomendaciones internacionales de la Organización Mundial de la Salud (OMS), la cual fija que una tasa de cesáreas superior al 15% no reduce la mortalidad materno-infantil y genera sobrecostos innecesarios.
* **Técnica SQL Utilizada**: Agregación con `CASE WHEN` ponderado y segmentación lógica por semáforo epidemiológico (`DENTRO DE ESTÁNDAR`, `ALERTA MODERADA`, `ALERTA CRÍTICA`).
* **Hallazgo Clave**: A nivel nacional, la tasa de cesáreas promedia **38.47%**. Regiones costeras como **Tumbes, Lima y Callao superan el 45% al 50%**, encasilladas en **Alerta Crítica**, mientras que regiones andinas y rurales como **Huancavelica y Cajamarca** presentan tasas más cercanas al estándar pero con mayor índice de partos no asistidos.

---

### Consulta 3: Matriz de Riesgo de Bajo Peso al Nacer (< 2,500g) y Nivel Educativo Materno
* **Objetivo de Negocio**: Analizar la correlación entre determinantes sociales (educación y embarazo adolescente) y los desenlaces clínicos neonatales (bajo peso y prematurez).
* **Técnica SQL Utilizada**: CTE con segmentación etaria (`<15 años`, `15-19 años`, `20-34 años`, `35+ años`) cruzada con `DIM_MADRE_PERFIL.nivel_instruccion`.
* **Hallazgo Clave**: Las madres con nivel educativo **Iletrado o Primaria Incompleta** y menores de 18 años presentan una prevalencia de **Bajo Peso al Nacer superior al 11.8%** (frente al 5.9% en madres con educación superior), lo que demuestra que el nivel de instrucción materna es un factor protector directo para la salud neonatal.

---

### Consulta 4: Brecha de Parto Institucional vs Domiciliario por Región Natural
* **Objetivo de Negocio**: Monitorear el acceso a la infraestructura hospitalaria y el uso de personal no calificado (parteras tradicionales o familiares) en comunidades indígenas y zonas rurales.
* **Técnica SQL Utilizada**: Función analítica `SUM(...) OVER (PARTITION BY U.departamento)` para calcular el peso porcentual dentro de cada región sin realizar múltiples subconsultas.
* **Hallazgo Clave**: En la región **Selva (Loreto, Ucayali, Amazonas)**, más del **4.2% de los partos siguen ocurriendo en domicilios** asistidos por parteras empíricas, debido a barreras geográficas fluviales y distancias hacia los centros de salud I-3 y I-4.

---

### Consulta 5: Ranking Top 10 IPRESS por Volumen y Cesáreas
* **Objetivo de Negocio**: Determinar la concentración de la demanda asistencial en los hospitales de mayor complejidad del país (Nivel III-1 e Institutos Especializados).
* **Técnica SQL Utilizada**: Función `DENSE_RANK() OVER (ORDER BY total_atenciones DESC)`.
* **Hallazgo Clave**: Hospitales materno-perinatales emblemáticos como el **Instituto Nacional Materno Perinatal (Maternidad de Lima)** y el **Hospital San Bartolomé** concentran más de 15,000 partos anuales cada uno, con un índice de cesáreas elevado debido a que reciben transferencias de alto riesgo obstétrico de todo el país.

---

### Consulta 6: Disparidades por Financiador (SIS vs EsSalud vs Privados)
* **Objetivo de Negocio**: Medir la equidad en el sistema de salud peruano y el gasto de bolsillo.
* **Técnica SQL Utilizada**: Cálculo de cuotas relativas sobre el universo total de nacimientos.
* **Hallazgo Clave**: 
  - El **Seguro Integral de Salud (SIS)** financia más del **68.5%** de todos los nacimientos en el país, atendiendo a la población de mayor vulnerabilidad socioeconómica.
  - Las **Clínicas Privadas** presentan una tasa de cesáreas que supera el **65%**, revelando un incentivo quirúrgico en el sector privado que contrasta con el sector público.

---

## 3. Matriz Resumen de Consultas y Rendimiento en SQL Server

| # Consulta | Indicador Sanitario | Función SQL Clave | Beneficio de Indexación |
| :---: | :--- | :--- | :--- |
| **Q1** | Variación Interanual | `LAG() OVER (...)` | `IX_FACT_NACIMIENTO_TIEMPO` |
| **Q2** | Tasa Cesáreas vs OMS | `SUM(CASE WHEN...)` | `IX_FACT_NACIMIENTO_UBIGEO` |
| **Q3** | Riesgo Bajo Peso y Educación | `CTE + GROUP BY` | `IX_FACT_NACIMIENTO_MADRE` |
| **Q4** | Parto Domiciliario por Región | `OVER(PARTITION BY...)` | `IX_FACT_NACIMIENTO_ATENCION` |
| **Q5** | Ranking IPRESS | `DENSE_RANK() OVER(...)`| Clave primaria `DIM_IPRESS` |
| **Q6** | Financiador del Parto | `Subquery total + GROUP`| `IX_FACT_NACIMIENTO_ATENCION` |

---
*Documento desarrollado para la sustentación académica en la Escuela de Educación Superior Tecnológica La Pontificia.*
