-- ==========================================================================================
-- PROYECTO ACADÉMICO: Big Data con Datos Abiertos Reales (MINSA / RENIEC - CNV Perú)
-- CURSO: Gestión de Base de Datos | Big Data
-- INSTITUCIÓN: Escuela de Educación Superior Tecnológica La Pontificia
-- DOCENTE: Ing. Erick Jhonatan Palomino Ayala
-- ARCHIVO: 04_07_vistas.sql
-- DESCRIPCIÓN: Creación de Vistas Analíticas para Business Intelligence (Sin sentencias GO)
-- ==========================================================================================

USE BD_CNV_BIGDATA_PERU;

-- ==========================================================================================
-- VISTA 1: Tablero Geoespacial y Temporal de Indicadores Neonatales por Departamento
-- ==========================================================================================
IF OBJECT_ID('dbo.VW_ANALISIS_NACIMIENTOS_REGIONAL', 'V') IS NOT NULL
    DROP VIEW dbo.VW_ANALISIS_NACIMIENTOS_REGIONAL;

CREATE VIEW dbo.VW_ANALISIS_NACIMIENTOS_REGIONAL
AS
SELECT 
    t.anio AS [Año],
    t.nombre_mes AS [Mes],
    u.departamento AS [Departamento],
    u.region_natural AS [Región Natural],
    COUNT(f.id_nacimiento) AS [Total Nacimientos],
    
    -- Métricas biométricas promedio
    CAST(AVG(f.peso_gramos) AS DECIMAL(6,2)) AS [Peso Promedio (g)],
    CAST(AVG(f.talla_cm) AS DECIMAL(4,1)) AS [Talla Promedio (cm)],
    CAST(AVG(CAST(f.duracion_embarazo_sem AS DECIMAL(4,1))) AS DECIMAL(4,1)) AS [Semanas Gestación Promedio],
    CAST(AVG(CAST(f.edad_madre AS DECIMAL(4,1))) AS DECIMAL(4,1)) AS [Edad Materna Promedio],
    
    -- Conteo de casos de riesgo clínico
    SUM(CAST(f.es_bajo_peso AS INT)) AS [Casos Bajo Peso (<2500g)],
    SUM(CAST(f.es_prematuro AS INT)) AS [Casos Prematuros (<37sem)],
    SUM(CAST(f.es_madre_adolescente AS INT)) AS [Casos Embarazo Adolescente (<18a)],
    SUM(CAST(f.es_cesarea AS INT)) AS [Total Cesáreas],
    
    -- Indicadores porcentuales clave (KPIs de Salud Pública)
    CAST((SUM(CAST(f.es_bajo_peso AS DECIMAL(10,2))) / COUNT(f.id_nacimiento)) * 100.0 AS DECIMAL(5,2)) AS [Tasa Bajo Peso (%)],
    CAST((SUM(CAST(f.es_prematuro AS DECIMAL(10,2))) / COUNT(f.id_nacimiento)) * 100.0 AS DECIMAL(5,2)) AS [Tasa Prematuridad (%)],
    CAST((SUM(CAST(f.es_madre_adolescente AS DECIMAL(10,2))) / COUNT(f.id_nacimiento)) * 100.0 AS DECIMAL(5,2)) AS [Tasa Embarazo Adolescente (%)],
    CAST((SUM(CAST(f.es_cesarea AS DECIMAL(10,2))) / COUNT(f.id_nacimiento)) * 100.0 AS DECIMAL(5,2)) AS [Tasa Cesáreas (%)]
FROM dbo.FACT_NACIMIENTO f
INNER JOIN dbo.DIM_TIEMPO t ON f.id_tiempo = t.id_tiempo
INNER JOIN dbo.DIM_UBIGEO u ON f.ubigeo_cod = u.ubigeo_cod
GROUP BY t.anio, t.nombre_mes, u.departamento, u.region_natural;

-- ==========================================================================================
-- VISTA 2: Evaluación de Calidad Asistencial y Vía de Parto por Financiador
-- ==========================================================================================
IF OBJECT_ID('dbo.VW_INDICADORES_SALUD_FINANCIADOR', 'V') IS NOT NULL
    DROP VIEW dbo.VW_INDICADORES_SALUD_FINANCIADOR;

CREATE VIEW dbo.VW_INDICADORES_SALUD_FINANCIADOR
AS
SELECT 
    t.anio AS [Año],
    s.financiador AS [Financiador de Salud],
    s.profesional_atiende AS [Profesional Asistencial],
    cp.condicion_parto AS [Vía de Parto],
    cp.lugar_nacimiento AS [Lugar de Nacimiento],
    COUNT(f.id_nacimiento) AS [Cantidad Atenciones],
    CAST(AVG(f.peso_gramos) AS DECIMAL(6,2)) AS [Peso Promedio (g)],
    CAST(AVG(CAST(f.edad_madre AS DECIMAL(4,1))) AS DECIMAL(4,1)) AS [Edad Promedio Madre]
FROM dbo.FACT_NACIMIENTO f
INNER JOIN dbo.DIM_TIEMPO t ON f.id_tiempo = t.id_tiempo
INNER JOIN dbo.DIM_ATENCION_SALUD s ON f.id_atencion_salud = s.id_atencion_salud
INNER JOIN dbo.DIM_CONDICION_PARTO cp ON f.id_condicion_parto = cp.id_condicion_parto
GROUP BY t.anio, s.financiador, s.profesional_atiende, cp.condicion_parto, cp.lugar_nacimiento;

-- ==========================================================================================
-- VISTA 3: Determinantes Sociales de la Madre y Resultados Perinatales
-- ==========================================================================================
IF OBJECT_ID('dbo.VW_PERFIL_MATERNO_VULNERABILIDAD', 'V') IS NOT NULL
    DROP VIEW dbo.VW_PERFIL_MATERNO_VULNERABILIDAD;

CREATE VIEW dbo.VW_PERFIL_MATERNO_VULNERABILIDAD
AS
SELECT 
    m.nivel_instruccion AS [Nivel de Instrucción],
    m.estado_civil AS [Estado Civil],
    m.ocupacion AS [Ocupación Principal],
    m.pais_origen AS [País Origen],
    COUNT(f.id_nacimiento) AS [Total Partos],
    CAST(AVG(CAST(f.edad_madre AS DECIMAL(4,1))) AS DECIMAL(4,1)) AS [Edad Promedio],
    SUM(CAST(f.es_madre_adolescente AS INT)) AS [Madres Adolescentes],
    SUM(CAST(f.es_bajo_peso AS INT)) AS [Nacidos con Bajo Peso],
    CAST((SUM(CAST(f.es_bajo_peso AS DECIMAL(10,2))) / COUNT(f.id_nacimiento)) * 100.0 AS DECIMAL(5,2)) AS [Prevalencia Bajo Peso (%)]
FROM dbo.FACT_NACIMIENTO f
INNER JOIN dbo.DIM_MADRE_PERFIL m ON f.id_madre_perfil = m.id_madre_perfil
GROUP BY m.nivel_instruccion, m.estado_civil, m.ocupacion, m.pais_origen;
