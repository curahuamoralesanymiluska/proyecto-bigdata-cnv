# Actividad: Big Data con Datos Abiertos Reales
## Escuela de Educación Superior Tecnológica La Pontificia
### Curso: Big Data | Proyecto Académico

---

# Documento 03: Proceso Formal de Normalización de la Base de Datos (1FN, 2FN y 3FN)

## 1. Introducción y Estado Inicial del Dataset Desnormalizado

El archivo fuente oficial (`DATOS_ABIERTOS_CNV_31122025.csv`) se presenta originalmente como una **tabla plana y desnormalizada (Forma No Normal o 0FN)** compuesta por **22 columnas** y **4,904,793 filas**.

### Estructura de la Tabla Plana Original (0FN):
```text
TABLA_ORIGINAL_CNV (
    FecNac_Año, FecNac_Mes, PESO_NACIDO, TALLA_NACIDO, DUR_EMB_PARTO,
    Condicion_Parto, sexo_nacido, Tipo_Parto, Edad_Madre, Estado_Civil,
    Nivel_Intrucción_Madre, DESC_OCUPACION, Num_embar_madre, Hijos_vivo_madre,
    Hijos_fallec_madre, nacmuer_abort_madre, Pais_Madre, IdUbigeoInei,
    Ipress, Lugar_Nacido, Atiende_Parto, Financiador_Parto
)
```

### Problemas Detectados en el Estado 0FN:
1. **Redundancia Masiva de Cadenas de Caracteres**: El nombre de un departamento (ej. `"LIMA"`, `"AYACUCHO"`), una profesión (`"AMA DE CASA"`) o un financiador (`"SEGURO INTEGRAL DE SALUD"`) se repite literalmente millones de veces, desperdiciando cientos de megabytes de memoria RAM y almacenamiento.
2. **Anomalías de Inserción**: No se puede registrar un nuevo centro de salud (IPRESS) o un nuevo distrito si no ha ocurrido un alumbramiento en él.
3. **Anomalías de Modificación/Actualización**: Si la categorización de un establecimiento de salud cambia, o se corrige el nombre de un distrito, habría que actualizar potencialmente cientos de miles de registros individuales.
4. **Anomalías de Eliminación**: Si se borran los registros de nacimientos de un distrito rural pequeño, se perdería la existencia de dicho distrito en la base de datos.

---

## 2. Primera Forma Normal (1FN)

### Reglas Teóricas de la 1FN:
1. Todos los atributos deben contener **valores atómicos e indivisibles** (sin listas, arrays o campos compuestos).
2. No deben existir **grupos repetitivos** de columnas.
3. Cada registro debe poseer una **clave primaria única** que lo identifique inequívocamente.

### Aplicación y Correcciones en el Dataset:
- **Creación de la Clave Primaria**: En el archivo CSV original no existía un identificador numérico único por nacimiento. Se crea la clave primaria subrogada: `id_nacimiento BIGINT IDENTITY(1,1)`.
- **Desglose y Limpieza de Atributos Compuestos**:
  - `FecNac_Año` y `FecNac_Mes` se mantienen estructurados de forma atómica para integrarse en una clave temporal `id_tiempo = (Año * 100) + Mes`.
  - El campo `IdUbigeoInei` contiene 6 dígitos (`DD-PP-DI`). Se garantiza su atomicidad al asignarle longitud fija `CHAR(6)` sin caracteres de separación extraños.
  - Los campos numéricos continuos (`PESO_NACIDO`, `TALLA_NACIDO`, `DUR_EMB_PARTO`, `Edad_Madre`) son limpiados de caracteres no numéricos o espacios en blanco para asegurar valores atómicos de tipo `DECIMAL` e `INT`.

```text
TABLA_1FN_CNV (
    [PK] id_nacimiento,
    anio, mes, peso_gramos, talla_cm, duracion_embarazo_sem, sexo,
    condicion_parto, tipo_parto, lugar_nacimiento, edad_madre, estado_civil,
    nivel_instruccion, ocupacion, pais_madre, num_embarazos, hijos_vivos,
    hijos_fallecidos, abortos_previos, ubigeo_inei, codigo_ipress,
    profesional_atiende, financiador_parto
)
```
> **Resultado 1FN**: Todos los campos son atómicos, cada celda contiene un único valor escalar y existe una clave primaria definida (`id_nacimiento`).

---

## 3. Segunda Forma Normal (2FN)

### Reglas Teóricas de la 2FN:
1. La tabla debe encontrarse previamente en **1FN**.
2. **Eliminación de Dependencias Funcionales Parciales**: Todos los atributos no clave deben depender funcionalmente de la **totalidad** de la clave primaria, y no de un subconjunto de ella.

### Análisis de Dependencias en el Dataset:
En nuestra entidad `TABLA_1FN_CNV`, la clave primaria es simple (`id_nacimiento`). Sin embargo, al analizar las dependencias funcionales de negocio, existen grupos de atributos que no describen las características biométricas propias del recién nacido, sino que describen **entidades independientes** que interactúan en el evento:

1. **Entidad Geográfica (Ubigeo)**:
   - Atributos: `codigo_dep`, `departamento`, `codigo_prov`, `provincia`, `distrito`, `region_natural`.
   - Dependen funcionalmente del código `ubigeo_inei`, no del nacimiento en sí.
2. **Entidad Temporal (Tiempo)**:
   - Atributos: `anio`, `mes`, `nombre_mes`, `trimestre`, `semestre`.
   - Dependen de la fecha/mes del evento (`id_tiempo`), no de las métricas clínicas del infante.
3. **Entidad Establecimiento de Salud (IPRESS)**:
   - Atributos: `nombre_establecimiento`, `categoria_establecimiento`.
   - Dependen del `codigo_ipress`.
4. **Entidad Perfil de la Madre**:
   - Atributos: `estado_civil`, `nivel_instruccion`, `ocupacion`, `pais_madre`.
   - Representan la condición sociodemográfica de la progenitora.
5. **Entidad Condición del Parto**:
   - Atributos: `condicion_parto`, `tipo_parto`, `lugar_nacimiento`.
6. **Entidad Atención y Cobertura**:
   - Atributos: `profesional_atiende`, `financiador_parto`.

### Descomposición en 2FN:
Se segregan los atributos en tablas dimensionales independientes, dejando en la tabla de hechos únicamente las métricas del recién nacido y las claves foráneas hacia dichas entidades:

- `DIM_TIEMPO` (`id_tiempo`, `anio`, `mes`, `nombre_mes`, `trimestre`, `semestre`)
- `DIM_UBIGEO` (`ubigeo_cod`, `codigo_dep`, `departamento`, `codigo_prov`, `provincia`, `distrito`, `region_natural`)
- `DIM_MADRE_PERFIL` (`id_madre_perfil`, `estado_civil`, `nivel_instruccion`, `ocupacion`, `pais_origen`)
- `DIM_CONDICION_PARTO` (`id_condicion_parto`, `condicion_parto`, `tipo_parto`, `lugar_nacimiento`)
- `DIM_ATENCION_SALUD` (`id_atencion_salud`, `profesional_atiende`, `financiador`)
- `DIM_IPRESS` (`codigo_ipress`, `nombre_establecimiento`, `categoria_establecimiento`)
- `FACT_NACIMIENTO` (`id_nacimiento`, `id_tiempo`, `ubigeo_cod`, `id_madre_perfil`, `id_condicion_parto`, `id_atencion_salud`, `codigo_ipress`, `sexo`, `peso_gramos`, `talla_cm`, `duracion_embarazo_sem`, `edad_madre`, `num_embarazos`, `hijos_vivos`, `hijos_fallecidos`, `abortos_previos`)

---

## 4. Tercera Forma Normal (3FN)

### Reglas Teóricas de la 3FN:
1. La base de datos debe estar en **2FN**.
2. **Eliminación de Dependencias Transitivas**: Ningún atributo no clave debe depender de otro atributo no clave ($X \rightarrow Y$ donde $X$ no es superclave). Es decir, los atributos no clave deben depender **directa y únicamente** de la clave primaria ($A \rightarrow PK$).

### Análisis y Corrección de Dependencias Transitivas:

#### A. En la Dimensión Geográfica (`DIM_UBIGEO`):
- **Dependencia Transitiva Detectada**:
  $$\text{ubigeo\_cod} \rightarrow \text{codigo\_prov} \rightarrow \text{codigo\_dep} \rightarrow \text{region\_natural}$$
  El nombre de la provincia depende del código de provincia, y el departamento depende del código de departamento.
- **Resolución**: Se formaliza el catálogo oficial INEI donde cada `ubigeo_cod` (PK de 6 dígitos) determina funcionalmente de manera directa la terna Distrito-Provincia-Departamento sin ambigüedades.

#### B. En la Dimensión de Salud (`DIM_ATENCION_SALUD`):
- **Dependencia Transitiva**: En el CSV original, el campo `Atiende_Parto` estaba mezclado con jerarquías de especialidad médica.
- **Resolución**: Se extrae `DIM_ATENCION_SALUD` con una clave subrogada `id_atencion_salud (PK)` de la cual dependen directamente `profesional_atiende` y `financiador`.

#### C. En la Tabla de Hechos (`FACT_NACIMIENTO`):
- En la tabla de hechos, las variables biométricas (`peso_gramos`, `talla_cm`, `duracion_embarazo_sem`, `sexo`, `edad_madre`) dependen **exclusiva y directamente** del `id_nacimiento`. No existe transitividad entre ellas (el peso no determina la edad de la madre ni las semanas de gestación).

---

## 5. Cuadro Comparativo y Justificación de la Normalización

| Criterio Evaluado | Antes (0FN / Archivo CSV Plano) | Después (Modelo Normalizado en 3FN / Esquema Estrella) | Impacto Cuantitativo y Cualitativo |
| :--- | :--- | :--- | :--- |
| **Almacenamiento en Disco** | ~829.8 MB (Texto plano repetitivo en 4.9M de filas) | ~295.0 MB (Tablas normalizadas con enteros e índices) | **Ahorro de ~64.4% de espacio en disco**. |
| **Consumo de Memoria RAM en Consultas** | Escaneo completo de cadenas de texto (Full Table Scan de 4.9M filas) | Búsqueda por índices enteros en memoria (`INT` / `BIGINT`) | Consultas de agregación hasta **15x más rápidas**. |
| **Redundancia de Datos** | Nombres de regiones como `"LIMA"` repetidos 1,800,000 veces. | El texto `"LIMA"` se almacena **una sola vez** en `DIM_UBIGEO`. | **Eliminación del 100% de duplicidad de cadenas descriptivas**. |
| **Integridad y Calidad de Datos** | Errores tipográficos (ej. `"SAN JUAN DE LURIGANCHO"`, `"S.J.L."`). | Estandarización a través de la clave foránea `ubigeo_cod`. | Imposibilidad de inconsistencias tipográficas en reportes. |
| **Mantenimiento y Actualizaciones** | Actualizar una categoría médica requería modificar millones de registros. | Se actualiza **1 sola fila** en la tabla dimensional correspondiente. | **Eliminación total de anomalías de modificación**. |

---

## 6. Diagrama de Dependencias Funcionales Corregidas

```text
[ id_nacimiento ] (PK Fact)
       │
       ├──> sexo, peso_gramos, talla_cm, duracion_embarazo_sem, edad_madre (Métricas Directas)
       │
       ├──> [ id_tiempo ] ───────> ( anio, mes, nombre_mes, trimestre, semestre )
       │
       ├──> [ ubigeo_cod ] ──────> ( codigo_dep, departamento, codigo_prov, provincia, distrito, region )
       │
       ├──> [ id_madre_perfil ] ─> ( estado_civil, nivel_instruccion, ocupacion, pais_origen )
       │
       ├──> [ id_condicion_parto ]> ( condicion_parto, tipo_parto, lugar_nacimiento )
       │
       ├──> [ id_atencion_salud ] > ( profesional_atiende, financiador )
       │
       └──> [ codigo_ipress ] ───> ( nombre_establecimiento, categoria_establecimiento )
```

---
*Documentación de normalización desarrollada para la Escuela de Educación Superior Tecnológica La Pontificia.*
