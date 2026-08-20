-- ==========================================================================================
-- PROYECTO ACADÉMICO: Big Data con Datos Abiertos Reales (MINSA / RENIEC - CNV Perú)
-- CURSO: Gestión de Base de Datos | Big Data
-- INSTITUCIÓN: Escuela de Educación Superior Tecnológica La Pontificia
-- DOCENTE: Ing. Erick Jhonatan Palomino Ayala
-- ARCHIVO: 00_ejecutar_todo.sql
-- DESCRIPCIÓN: SCRIPT MAESTRO UNIFICADO (Instalación, Esquema, Poblado, Índices, Vistas y SPs)
--              (Estructurado con terminadores punto y coma, sin sentencias GO)
-- ==========================================================================================

USE master;

-- 1. CREACIÓN DE LA BASE DE DATOS
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

-- 2. CREACIÓN DE TABLAS DIMENSIONALES Y DE HECHOS
CREATE TABLE dbo.DIM_TIEMPO (
    id_tiempo INT NOT NULL,
    anio INT NOT NULL,
    mes INT NOT NULL,
    nombre_mes VARCHAR(20) NOT NULL,
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
    region_natural VARCHAR(30) NOT NULL
);

CREATE TABLE dbo.DIM_MADRE_PERFIL (
    id_madre_perfil INT IDENTITY(1,1) NOT NULL,
    estado_civil VARCHAR(40) NOT NULL,
    nivel_instruccion VARCHAR(60) NOT NULL,
    ocupacion VARCHAR(100) NOT NULL,
    pais_origen VARCHAR(60) NOT NULL
);

CREATE TABLE dbo.DIM_CONDICION_PARTO (
    id_condicion_parto INT IDENTITY(1,1) NOT NULL,
    condicion_parto VARCHAR(40) NOT NULL,
    tipo_parto VARCHAR(30) NOT NULL,
    lugar_nacimiento VARCHAR(60) NOT NULL
);

CREATE TABLE dbo.DIM_ATENCION_SALUD (
    id_atencion_salud INT IDENTITY(1,1) NOT NULL,
    profesional_atiende VARCHAR(60) NOT NULL,
    financiador VARCHAR(50) NOT NULL
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
    abortos_previos VARCHAR(20) NULL,
    es_bajo_peso BIT NOT NULL DEFAULT 0,
    es_prematuro BIT NOT NULL DEFAULT 0,
    es_madre_adolescente BIT NOT NULL DEFAULT 0,
    es_cesarea BIT NOT NULL DEFAULT 0,
    
    CONSTRAINT CHK_FACT_PESO CHECK (peso_gramos BETWEEN 200.00 AND 8000.00),
    CONSTRAINT CHK_FACT_TALLA CHECK (talla_cm BETWEEN 15.0 AND 80.0),
    CONSTRAINT CHK_FACT_SEMANAS CHECK (duracion_embarazo_sem BETWEEN 18 AND 46),
    CONSTRAINT CHK_FACT_EDAD_MADRE CHECK (edad_madre BETWEEN 8 AND 65)
);

-- 3. APLICACIÓN DE RESTRICCIONES PRIMARY KEY Y FOREIGN KEY
ALTER TABLE dbo.DIM_TIEMPO ADD CONSTRAINT PK_DIM_TIEMPO PRIMARY KEY CLUSTERED (id_tiempo);
ALTER TABLE dbo.DIM_UBIGEO ADD CONSTRAINT PK_DIM_UBIGEO PRIMARY KEY CLUSTERED (ubigeo_cod);
ALTER TABLE dbo.DIM_MADRE_PERFIL ADD CONSTRAINT PK_DIM_MADRE_PERFIL PRIMARY KEY CLUSTERED (id_madre_perfil);
ALTER TABLE dbo.DIM_CONDICION_PARTO ADD CONSTRAINT PK_DIM_CONDICION_PARTO PRIMARY KEY CLUSTERED (id_condicion_parto);
ALTER TABLE dbo.DIM_ATENCION_SALUD ADD CONSTRAINT PK_DIM_ATENCION_SALUD PRIMARY KEY CLUSTERED (id_atencion_salud);
ALTER TABLE dbo.DIM_IPRESS ADD CONSTRAINT PK_DIM_IPRESS PRIMARY KEY CLUSTERED (codigo_ipress);
ALTER TABLE dbo.FACT_NACIMIENTO ADD CONSTRAINT PK_FACT_NACIMIENTO PRIMARY KEY CLUSTERED (id_nacimiento);

ALTER TABLE dbo.FACT_NACIMIENTO ADD CONSTRAINT FK_FACT_TIEMPO FOREIGN KEY (id_tiempo) REFERENCES dbo.DIM_TIEMPO (id_tiempo);
ALTER TABLE dbo.FACT_NACIMIENTO ADD CONSTRAINT FK_FACT_UBIGEO FOREIGN KEY (ubigeo_cod) REFERENCES dbo.DIM_UBIGEO (ubigeo_cod);
ALTER TABLE dbo.FACT_NACIMIENTO ADD CONSTRAINT FK_FACT_MADRE_PERFIL FOREIGN KEY (id_madre_perfil) REFERENCES dbo.DIM_MADRE_PERFIL (id_madre_perfil);
ALTER TABLE dbo.FACT_NACIMIENTO ADD CONSTRAINT FK_FACT_CONDICION_PARTO FOREIGN KEY (id_condicion_parto) REFERENCES dbo.DIM_CONDICION_PARTO (id_condicion_parto);
ALTER TABLE dbo.FACT_NACIMIENTO ADD CONSTRAINT FK_FACT_ATENCION_SALUD FOREIGN KEY (id_atencion_salud) REFERENCES dbo.DIM_ATENCION_SALUD (id_atencion_salud);
ALTER TABLE dbo.FACT_NACIMIENTO ADD CONSTRAINT FK_FACT_IPRESS FOREIGN KEY (codigo_ipress) REFERENCES dbo.DIM_IPRESS (codigo_ipress);

-- 4. POBLADO DE MUESTRA DE DATOS
INSERT INTO dbo.DIM_TIEMPO (id_tiempo, anio, mes, nombre_mes, trimestre, semestre) VALUES
(202506, 2025, 6, 'Junio', 2, 1),
(202505, 2025, 5, 'Mayo', 2, 1),
(202504, 2025, 4, 'Abril', 2, 1),
(202410, 2024, 10, 'Octubre', 4, 2);

INSERT INTO dbo.DIM_UBIGEO (ubigeo_cod, codigo_dep, departamento, codigo_prov, provincia, distrito, region_natural) VALUES
('150101', '15', 'LIMA', '1501', 'LIMA', 'LIMA CERCADO', 'COSTA'),
('050101', '05', 'AYACUCHO', '0501', 'HUAMANGA', 'AYACUCHO', 'SIERRA'),
('050108', '05', 'AYACUCHO', '0501', 'HUAMANGA', 'SAN JUAN BAUTISTA', 'SIERRA'),
('080101', '08', 'CUSCO', '0801', 'CUSCO', 'CUSCO', 'SIERRA'),
('200101', '20', 'PIURA', '2001', 'PIURA', 'PIURA', 'COSTA'),
('160101', '16', 'LORETO', '1601', 'MAYNAS', 'IQUITOS', 'SELVA');

INSERT INTO dbo.DIM_MADRE_PERFIL (estado_civil, nivel_instruccion, ocupacion, pais_origen) VALUES
('SOLTERO', 'SECUNDARIA COMPLETA', 'AMA DE CASA', 'PERU'),
('SOLTERO', 'SECUNDARIA INCOMPLETA', 'AMA DE CASA', 'PERU'),
('CASADO', 'SUPERIOR UNIVERSITARIA', 'DOCENTE', 'PERU'),
('CONVIVIENTE', 'PRIMARIA COMPLETA', 'AGRICULTORA', 'PERU');

INSERT INTO dbo.DIM_CONDICION_PARTO (condicion_parto, tipo_parto, lugar_nacimiento) VALUES
('EUTOCICO', 'UNICO', 'ESTABLECIMIENTO DE SALUD'),
('CESAREA', 'UNICO', 'ESTABLECIMIENTO DE SALUD'),
('EUTOCICO', 'UNICO', 'DOMICILIO');

INSERT INTO dbo.DIM_ATENCION_SALUD (profesional_atiende, financiador) VALUES
('OBSTETRA', 'SIS'),
('MEDICO GINECO-OBSTETRA', 'SIS'),
('MEDICO GINECO-OBSTETRA', 'ESSALUD'),
('PARTERA', 'NINGUNO');

INSERT INTO dbo.DIM_IPRESS (codigo_ipress, nombre_establecimiento, categoria_establecimiento) VALUES
('00006240', 'INSTITUTO NACIONAL MATERNO PERINATAL', 'III-2'),
('00002150', 'HOSPITAL REGIONAL DE AYACUCHO', 'III-1'),
('00002155', 'CENTRO DE SALUD SAN JUAN BAUTISTA (AYACUCHO)', 'I-4'),
('99999999', 'PARTO EXTRA-HOSPITALARIO', 'NO APLICA');

INSERT INTO dbo.FACT_NACIMIENTO (
    id_tiempo, ubigeo_cod, id_madre_perfil, id_condicion_parto, id_atencion_salud, codigo_ipress,
    sexo, peso_gramos, talla_cm, duracion_embarazo_sem, edad_madre, num_embarazos, hijos_vivos, hijos_fallecidos, abortos_previos,
    es_bajo_peso, es_prematuro, es_madre_adolescente, es_cesarea
) VALUES
(202506, '150101', 1, 1, 1, '00006240', 'MASCULINO', 3450.00, 50.0, 39, 26, '1', '1', '0', '0', 0, 0, 0, 0),
(202506, '050101', 1, 1, 1, '00002150', 'MASCULINO', 3150.00, 48.5, 39, 24, '2', '2', '0', '0', 0, 0, 0, 0),
(202505, '050108', 2, 1, 1, '00002155', 'MASCULINO', 2350.00, 45.0, 35, 17, '1', '1', '0', '0', 1, 1, 1, 0),
(202505, '080101', 3, 2, 3, '00002150', 'FEMENINO', 3250.00, 49.0, 38, 30, '1', '1', '0', '0', 0, 0, 0, 1);

-- 5. CREACIÓN DE ÍNDICES OPTIMIZADOS
CREATE NONCLUSTERED INDEX IX_FACT_TIEMPO_UBIGEO_COVERING
ON dbo.FACT_NACIMIENTO (id_tiempo ASC, ubigeo_cod ASC)
INCLUDE (peso_gramos, talla_cm, duracion_embarazo_sem, edad_madre, es_bajo_peso, es_prematuro, es_madre_adolescente, es_cesarea);

CREATE NONCLUSTERED INDEX IX_FACT_CONDICION_PARTO
ON dbo.FACT_NACIMIENTO (id_condicion_parto ASC)
INCLUDE (es_cesarea, peso_gramos, id_tiempo);

-- 6. CREACIÓN DE PROCEDIMIENTOS ALMACENADOS (ESTILO ACADÉMICO LA PONTIFICIA)
CREATE PROCEDURE sp_MostrarTodosNacimientos
AS BEGIN
    SELECT TOP 100 * FROM FACT_NACIMIENTO;
END;

CREATE PROCEDURE sp_NacimientosPorRegion
    @Departamento VARCHAR(60)
AS BEGIN
    SELECT F.* 
    FROM FACT_NACIMIENTO F
    INNER JOIN DIM_UBIGEO U ON F.ubigeo_cod = U.ubigeo_cod
    WHERE U.departamento = @Departamento;
END;

CREATE PROCEDURE sp_VerificarAlertasNeonatales
    @Departamento VARCHAR(60)
AS BEGIN
    IF EXISTS (
        SELECT 1 
        FROM FACT_NACIMIENTO F
        INNER JOIN DIM_UBIGEO U ON F.ubigeo_cod = U.ubigeo_cod
        WHERE U.departamento = @Departamento AND F.es_bajo_peso = 1
    )
        PRINT 'El departamento TIENE registros con alerta de bajo peso al nacer.';
    ELSE
        PRINT 'El departamento NO tiene registros de bajo peso al nacer.';
END;

-- 7. EJECUCIÓN DE PRUEBA
EXEC sp_MostrarTodosNacimientos;
EXEC sp_NacimientosPorRegion @Departamento = 'AYACUCHO';
EXEC sp_VerificarAlertasNeonatales @Departamento = 'AYACUCHO';
