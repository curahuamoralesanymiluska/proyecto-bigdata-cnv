-- ==========================================================================================
-- PROYECTO ACADÉMICO: Big Data con Datos Abiertos Reales (MINSA / RENIEC - CNV Perú)
-- CURSO: Gestión de Base de Datos | Big Data
-- INSTITUCIÓN: Escuela de Educación Superior Tecnológica La Pontificia
-- DOCENTE: Ing. Erick Jhonatan Palomino Ayala
-- ARCHIVO: 04_02_creacion_tablas.sql
-- DESCRIPCIÓN: Creación de tablas dimensionales y de hechos normalizadas (Sin sentencias GO)
-- ==========================================================================================

USE BD_CNV_BIGDATA_PERU;

-- ==========================================================================================
-- SECCIÓN 1: ELIMINACIÓN PREVIA DE TABLAS (SI EXISTEN, EN ORDEN DE DEPENDENCIAS)
-- ==========================================================================================
IF OBJECT_ID('dbo.FACT_NACIMIENTO', 'U') IS NOT NULL DROP TABLE dbo.FACT_NACIMIENTO;
IF OBJECT_ID('dbo.DIM_IPRESS', 'U') IS NOT NULL DROP TABLE dbo.DIM_IPRESS;
IF OBJECT_ID('dbo.DIM_ATENCION_SALUD', 'U') IS NOT NULL DROP TABLE dbo.DIM_ATENCION_SALUD;
IF OBJECT_ID('dbo.DIM_CONDICION_PARTO', 'U') IS NOT NULL DROP TABLE dbo.DIM_CONDICION_PARTO;
IF OBJECT_ID('dbo.DIM_MADRE_PERFIL', 'U') IS NOT NULL DROP TABLE dbo.DIM_MADRE_PERFIL;
IF OBJECT_ID('dbo.DIM_UBIGEO', 'U') IS NOT NULL DROP TABLE dbo.DIM_UBIGEO;
IF OBJECT_ID('dbo.DIM_TIEMPO', 'U') IS NOT NULL DROP TABLE dbo.DIM_TIEMPO;

-- ==========================================================================================
-- SECCIÓN 2: CREACIÓN DE TABLAS DIMENSIONALES (MAESTRAS)
-- ==========================================================================================

-- 2.1. Dimensión Temporal
CREATE TABLE dbo.DIM_TIEMPO (
    id_tiempo INT NOT NULL,                          -- Formato YYYYMM (ej. 202506)
    anio INT NOT NULL,                               -- Año calendario (2015-2025)
    mes INT NOT NULL,                                -- Mes numérico (1-12)
    nombre_mes VARCHAR(20) NOT NULL,                 -- 'Enero', 'Febrero', etc.
    trimestre INT NOT NULL,                          -- 1, 2, 3, 4
    semestre INT NOT NULL                            -- 1, 2
);

-- 2.2. Dimensión Geográfica (Ubigeo Oficial INEI)
CREATE TABLE dbo.DIM_UBIGEO (
    ubigeo_cod VARCHAR(6) NOT NULL,                  -- Código Ubigeo INEI de 6 dígitos
    codigo_dep VARCHAR(2) NOT NULL,                  -- Código de Departamento (2 dígitos)
    departamento VARCHAR(60) NOT NULL,               -- Nombre del Departamento
    codigo_prov VARCHAR(4) NOT NULL,                 -- Código de Provincia (4 dígitos)
    provincia VARCHAR(60) NOT NULL,                  -- Nombre de Provincia
    distrito VARCHAR(60) NOT NULL,                   -- Nombre de Distrito
    region_natural VARCHAR(30) NOT NULL              -- 'COSTA', 'SIERRA', 'SELVA', 'LIMA METROPOLITANA'
);

-- 2.3. Dimensión Sociodemográfica de la Madre
CREATE TABLE dbo.DIM_MADRE_PERFIL (
    id_madre_perfil INT IDENTITY(1,1) NOT NULL,      -- Clave subrogada autoincremental
    estado_civil VARCHAR(40) NOT NULL,               -- SOLTERO, CASADO, CONVIVIENTE, etc.
    nivel_instruccion VARCHAR(60) NOT NULL,          -- SECUNDARIA COMPLETA, SUPERIOR UNIV., etc.
    ocupacion VARCHAR(100) NOT NULL,                 -- AMA DE CASA, DOCENTE, COMERCIANTE, etc.
    pais_origen VARCHAR(60) NOT NULL                 -- PERU, VENEZUELA, COLOMBIA, etc.
);

-- 2.4. Dimensión Clínica del Parto
CREATE TABLE dbo.DIM_CONDICION_PARTO (
    id_condicion_parto INT IDENTITY(1,1) NOT NULL,   -- Clave subrogada autoincremental
    condicion_parto VARCHAR(40) NOT NULL,            -- EUTOCICO, CESAREA, INSTRUMENTADO
    tipo_parto VARCHAR(30) NOT NULL,                 -- UNICO, DOBLE, TRIPLE, MAS DE TRES
    lugar_nacimiento VARCHAR(60) NOT NULL            -- ESTABLECIMIENTO DE SALUD, DOMICILIO, VIA PUBLICA
);

-- 2.5. Dimensión Asistencial y Cobertura
CREATE TABLE dbo.DIM_ATENCION_SALUD (
    id_atencion_salud INT IDENTITY(1,1) NOT NULL,    -- Clave subrogada autoincremental
    profesional_atiende VARCHAR(60) NOT NULL,        -- OBSTETRA, MEDICO GINECO-OBSTETRA, etc.
    financiador VARCHAR(50) NOT NULL                 -- SIS, ESSALUD, PARTICULAR, PRIVADOS, etc.
);

-- 2.6. Dimensión de Establecimientos de Salud (IPRESS - SUSALUD / MINSA)
CREATE TABLE dbo.DIM_IPRESS (
    codigo_ipress VARCHAR(10) NOT NULL,              -- Código Único RENIPRESS / SUSALUD
    nombre_establecimiento VARCHAR(150) NOT NULL,    -- Nombre del Hospital o Centro de Salud
    categoria_establecimiento VARCHAR(30) NOT NULL   -- I-1, I-2, I-3, I-4, II-1, II-2, III-1, III-E
);

-- ==========================================================================================
-- SECCIÓN 3: CREACIÓN DE LA TABLA PRINCIPAL DE HECHOS (FACT_NACIMIENTO)
-- ==========================================================================================
CREATE TABLE dbo.FACT_NACIMIENTO (
    id_nacimiento BIGINT IDENTITY(1,1) NOT NULL,     -- Clave primaria autoincremental
    
    -- Claves Foráneas dimensionales
    id_tiempo INT NOT NULL,
    ubigeo_cod VARCHAR(6) NOT NULL,
    id_madre_perfil INT NOT NULL,
    id_condicion_parto INT NOT NULL,
    id_atencion_salud INT NOT NULL,
    codigo_ipress VARCHAR(10) NOT NULL,
    
    -- Métricas biométricas del recién nacido
    sexo VARCHAR(15) NOT NULL,
    peso_gramos DECIMAL(6,2) NOT NULL,
    talla_cm DECIMAL(4,1) NOT NULL,
    duracion_embarazo_sem INT NOT NULL,
    
    -- Variables sociodemográficas y reproductivas de la madre
    edad_madre INT NOT NULL,
    num_embarazos VARCHAR(10) NULL,
    hijos_vivos VARCHAR(10) NULL,
    hijos_fallecidos VARCHAR(10) NULL,
    abortos_previos VARCHAR(20) NULL,
    
    -- Indicadores booleanos
    es_bajo_peso BIT NOT NULL DEFAULT 0,
    es_prematuro BIT NOT NULL DEFAULT 0,
    es_madre_adolescente BIT NOT NULL DEFAULT 0,
    es_cesarea BIT NOT NULL DEFAULT 0,
    
    -- Restricciones CHECK
    CONSTRAINT CHK_FACT_PESO CHECK (peso_gramos BETWEEN 200.00 AND 8000.00),
    CONSTRAINT CHK_FACT_TALLA CHECK (talla_cm BETWEEN 15.0 AND 80.0),
    CONSTRAINT CHK_FACT_SEMANAS CHECK (duracion_embarazo_sem BETWEEN 18 AND 46),
    CONSTRAINT CHK_FACT_EDAD_MADRE CHECK (edad_madre BETWEEN 8 AND 65)
);
