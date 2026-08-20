# Actividad: Big Data con Datos Abiertos Reales
## Escuela de Educación Superior Tecnológica La Pontificia
### Curso: Big Data | Proyecto Académico

---

# Documento 08: Conclusiones Técnicas, Hallazgos Sanitarios y Recomendaciones Estratégicas

## 1. Conclusiones del Proyecto

### A. Dimensión Técnica y Arquitectura Big Data
1. **Superación Demostrada del Límite de Herramientas Tradicionales**:
   El conjunto de datos analizado (**4,904,793 registros** de nacidos vivos entre 2015 y 2025) superó casi 5 veces la capacidad física de una hoja de cálculo estándar de Microsoft Excel (1,048,576 filas). La persistencia de este volumen en formatos planos tradicionales genera bloqueos de memoria y pérdida de información.
2. **Eficiencia del Modelado Dimensional y Normalización 3FN**:
   La transformación de la tabla plana desnormalizada (0FN) hacia un modelo híbrido relacional en **Esquema Estrella (3FN)** con 6 dimensiones (`DIM_TIEMPO`, `DIM_UBIGEO`, `DIM_MADRE_PERFIL`, `DIM_CONDICION_PARTO`, `DIM_ATENCION_SALUD`, `DIM_IPRESS`) y una tabla de hechos (`FACT_NACIMIENTO`):
   - Redujo el consumo de almacenamiento en disco en un **64.4%** (de 791.35 MB a ~281.7 MB).
   - Eliminó por completo las anomalías de inserción, actualización y borrado.
   - Habilitó tiempos de respuesta en consultas analíticas de menos de 1 segundo mediante indexación estratégica (*Index Covering*).
3. **Robustez del Pipeline ETL en Python**:
   El proceso automatizado con **Pandas y SQLAlchemy / PyODBC** resolvió con éxito las inconsistencias del origen: imputación lógica de nulos sin sesgar promedios, corrección de Ubigeos con padding (`zfill`), tipificación numérica estricta y generación de banderas booleanas optimizadas para analítica y Machine Learning.

---

### B. Dimensión Analítica y de Salud Pública en el Perú
1. **Contracción Demográfica y Tendencia de la Natalidad**:
   Tras alcanzar un máximo histórico en el año **2018 con 493,990 nacimientos**, el Perú ha experimentado una reducción continua de nacimientos anuales, registrando **376,786 partos en 2025** (-23.7% respecto al pico). Esta tendencia refleja cambios socioculturales, mayor acceso a planificación familiar y el impacto económico post-pandemia.
2. **Sobre-intervención Quirúrgica (Tasa de Cesáreas Alarmante)**:
   La tasa nacional de cesáreas se situó en **38.47%**, muy por encima del umbral máximo del **15% recomendado por la Organización Mundial de la Salud (OMS)**. En regiones de la costa (Lima, Callao, Tumbes) y en el sector privado / clínicas, esta cifra supera el 50% al 65%, lo que evidencia un uso excesivo e injustificado de procedimientos quirúrgicos.
3. **Determinantes Sociales en la Salud Neonatal**:
   Se comprobó estadísticamente una correlación directa entre el **nivel de instrucción de la madre**, la **edad materna temprana** (menores de 18 años) y la incidencia de **bajo peso al nacer (< 2,500 g)** y prematurez. Las madres sin educación formal presentan el doble de prevalencia de neonatos con bajo peso frente a madres con formación superior.
4. **Rol Protector del Seguro Integral de Salud (SIS)**:
   El SIS financió más del **68.5%** de todos los partos ocurridos en el país en los últimos 11 años, constituyendo la columna vertebral del aseguramiento público en salud materna para las poblaciones de mayor vulnerabilidad económica y geográfica.

---

## 2. Recomendaciones Estratégicas

### A. Recomendaciones Técnicas y de Ingeniería de Datos
1. **Evolución hacia un Data Lakehouse / Cloud Data Warehouse**:
   Para la ingesta continua y en tiempo real de los certificados de recién nacidos (corte 2026 en adelante), se recomienda implementar una arquitectura basada en **Databricks / Delta Lake** o **Google BigQuery**, particionando los datos por `anio_nacimiento` y `codigo_dep` para maximizar el paralelismo.
2. **Gobernanza de Datos y Validación en Origen**:
   El MINSA y RENIEC deben implementar reglas de validación en la interfaz de usuario del sistema en línea del CNV para evitar que el personal asistencial ingrese valores atípicos (como pesos menores a 300g en nacidos a término o edades maternas inconsistentes), reduciendo la necesidad de imputaciones en la fase ETL.
3. **Automatización de Pipelines con Orquestadores (Apache Airflow)**:
   Programar ejecuciones periódicas mensuales del script ETL (`05_etl_proceso.py`) mediante DAGs de Airflow, incorporando alertas automáticas de desviación de calidad de datos (*Data Quality Alerts*).

---

### B. Recomendaciones para Políticas Públicas de Salud (MINSA / Gobiernos Regionales)
1. **Auditoría Clínica de Cesáreas en Clínicas y Hospitales**:
   Establecer protocolos de supervisión y desincentivos económicos para frenar la práctica de cesáreas electivas innecesarias, promoviendo el parto humanizado y respetado de acuerdo con las guías de la OMS.
2. **Focalización del Programa de Salud Materna en Zonas Críticas**:
   Priorizar la inversión en casas de espera materna y equipamiento de centros de salud I-3 / I-4 en las regiones de la Amazonía (Loreto, Ucayali, Amazonas) y la Sierra andina, donde aún persisten partos domiciliarios atendidos por personal no calificado.
3. **Estrategias Intersectoriales para Prevenir el Embarazo Adolescente**:
   Articular programas conjuntos entre el Ministerio de Educación (MINEDU) y el MINSA para fortalecer la educación sexual integral y el acompañamiento psicosocial en distritos con mayor concentración de maternidad precoz.

---

## 3. Matriz Síntesis del Proyecto

| Eje Evaluado | Situación Inicial (Dataset Crudo) | Logro con Big Data (Solución Implementada) |
| :--- | :--- | :--- |
| **Volumen de Datos** | 4,904,793 filas imposibles de abrir en Excel. | Base de datos SQL Server estructurada y optimizada. |
| **Calidad de Datos** | 22 columnas con nulos, Ubigeos truncados y redundancias. | Pipeline ETL en Python con limpieza, imputación y validación. |
| **Estructura** | Tabla plana 0FN con 791 MB. | Esquema Estrella 3FN ocupando ~281 MB (-64.4% espacio). |
| **Tiempo de Consulta** | Minutos de procesamiento en archivos de texto. | Consultas OLAP instantáneas (<1 seg) con índices cubrientes. |
| **Valor de Negocio** | Datos aislados sin interpretación. | 6 Consultas de KPIs, Dashboard HTML interactivo y Plan de Políticas Públicas. |

---
*Informe académico concluido para el curso de Big Data | Escuela de Educación Superior Tecnológica La Pontificia.*
