-- ==========================================================================================
-- PROYECTO ACADÉMICO: Big Data con Datos Abiertos Reales (MINSA / RENIEC - CNV Perú)
-- CURSO: Gestión de Base de Datos | Big Data
-- INSTITUCIÓN: Escuela de Educación Superior Tecnológica La Pontificia
-- DOCENTE: Ing. Erick Jhonatan Palomino Ayala
-- ARCHIVO: 04_06_indices.sql
-- DESCRIPCIÓN: Creación de índices estratégicos para optimización de consultas (Sin sentencias GO)
-- ==========================================================================================

USE BD_CNV_BIGDATA_PERU;

-- ==========================================================================================
-- ÍNDICE 1: Índice Compuesto Cubriente por Tiempo y Geografía
-- ==========================================================================================
IF EXISTS (SELECT name FROM sys.indexes WHERE name = N'IX_FACT_TIEMPO_UBIGEO_COVERING')
    DROP INDEX IX_FACT_TIEMPO_UBIGEO_COVERING ON dbo.FACT_NACIMIENTO;

CREATE NONCLUSTERED INDEX IX_FACT_TIEMPO_UBIGEO_COVERING
ON dbo.FACT_NACIMIENTO (id_tiempo ASC, ubigeo_cod ASC)
INCLUDE (peso_gramos, talla_cm, duracion_embarazo_sem, edad_madre, es_bajo_peso, es_prematuro, es_madre_adolescente, es_cesarea);

-- ==========================================================================================
-- ÍNDICE 2: Índice para Auditoría de Vía de Parto y Monitoreo de Tasa de Cesáreas (OMS)
-- ==========================================================================================
IF EXISTS (SELECT name FROM sys.indexes WHERE name = N'IX_FACT_CONDICION_PARTO')
    DROP INDEX IX_FACT_CONDICION_PARTO ON dbo.FACT_NACIMIENTO;

CREATE NONCLUSTERED INDEX IX_FACT_CONDICION_PARTO
ON dbo.FACT_NACIMIENTO (id_condicion_parto ASC)
INCLUDE (es_cesarea, peso_gramos, id_tiempo);

-- ==========================================================================================
-- ÍNDICE 3: Índice de Cobertura y Financiador (SIS vs EsSalud vs Particulares)
-- ==========================================================================================
IF EXISTS (SELECT name FROM sys.indexes WHERE name = N'IX_FACT_ATENCION_SALUD')
    DROP INDEX IX_FACT_ATENCION_SALUD ON dbo.FACT_NACIMIENTO;

CREATE NONCLUSTERED INDEX IX_FACT_ATENCION_SALUD
ON dbo.FACT_NACIMIENTO (id_atencion_salud ASC)
INCLUDE (id_madre_perfil, es_madre_adolescente, es_bajo_peso);

-- ==========================================================================================
-- ÍNDICE 4: Índice Jerárquico en la Dimensión Geográfica (DIM_UBIGEO)
-- ==========================================================================================
IF EXISTS (SELECT name FROM sys.indexes WHERE name = N'IX_DIM_UBIGEO_DEP_PROV')
    DROP INDEX IX_DIM_UBIGEO_DEP_PROV ON dbo.DIM_UBIGEO;

CREATE NONCLUSTERED INDEX IX_DIM_UBIGEO_DEP_PROV
ON dbo.DIM_UBIGEO (codigo_dep ASC, codigo_prov ASC)
INCLUDE (departamento, provincia, distrito, region_natural);
