-- ==========================================================================================
-- PROYECTO ACADÉMICO: Big Data con Datos Abiertos Reales (MINSA / RENIEC - CNV Perú)
-- CURSO: Gestión de Base de Datos | Big Data
-- INSTITUCIÓN: Escuela de Educación Superior Tecnológica La Pontificia
-- DOCENTE: Ing. Erick Jhonatan Palomino Ayala
-- ARCHIVO: 04_03_claves_primarias.sql
-- DESCRIPCIÓN: Definición explícita de Restricciones de Claves Primarias (Sin sentencias GO)
-- ==========================================================================================

USE BD_CNV_BIGDATA_PERU;

-- 1. Clave Primaria de la Dimensión Temporal
ALTER TABLE dbo.DIM_TIEMPO
ADD CONSTRAINT PK_DIM_TIEMPO PRIMARY KEY CLUSTERED (id_tiempo);

-- 2. Clave Primaria de la Dimensión Geográfica (Ubigeo)
ALTER TABLE dbo.DIM_UBIGEO
ADD CONSTRAINT PK_DIM_UBIGEO PRIMARY KEY CLUSTERED (ubigeo_cod);

-- 3. Clave Primaria de la Dimensión Perfil de la Madre
ALTER TABLE dbo.DIM_MADRE_PERFIL
ADD CONSTRAINT PK_DIM_MADRE_PERFIL PRIMARY KEY CLUSTERED (id_madre_perfil);

-- 4. Clave Primaria de la Dimensión Condición del Parto
ALTER TABLE dbo.DIM_CONDICION_PARTO
ADD CONSTRAINT PK_DIM_CONDICION_PARTO PRIMARY KEY CLUSTERED (id_condicion_parto);

-- 5. Clave Primaria de la Dimensión Atención y Cobertura
ALTER TABLE dbo.DIM_ATENCION_SALUD
ADD CONSTRAINT PK_DIM_ATENCION_SALUD PRIMARY KEY CLUSTERED (id_atencion_salud);

-- 6. Clave Primaria de la Dimensión de Establecimientos de Salud (IPRESS)
ALTER TABLE dbo.DIM_IPRESS
ADD CONSTRAINT PK_DIM_IPRESS PRIMARY KEY CLUSTERED (codigo_ipress);

-- 7. Clave Primaria de la Tabla Principal de Hechos (FACT_NACIMIENTO)
ALTER TABLE dbo.FACT_NACIMIENTO
ADD CONSTRAINT PK_FACT_NACIMIENTO PRIMARY KEY CLUSTERED (id_nacimiento);
