-- ==========================================================================================
-- PROYECTO ACADÉMICO: Big Data con Datos Abiertos Reales (MINSA / RENIEC - CNV Perú)
-- CURSO: Gestión de Base de Datos | Big Data
-- INSTITUCIÓN: Escuela de Educación Superior Tecnológica La Pontificia
-- DOCENTE: Ing. Erick Jhonatan Palomino Ayala
-- ARCHIVO: 06_consultas_analiticas.sql
-- DESCRIPCIÓN: Consultas Analíticas Avanzadas de Big Data (Sin sentencias GO)
-- ==========================================================================================

USE BD_CNV_BIGDATA_PERU;

-- ==========================================================================================
-- CONSULTA 1: EVOLUCIÓN HISTÓRICA Y TASA DE VARIACIÓN INTERANUAL (LAG / LEAD)
-- ==========================================================================================
WITH ResumenAnual AS (
    SELECT 
        T.anio,
        COUNT(F.id_nacimiento) AS total_nacimientos,
        SUM(CASE WHEN F.es_cesarea = 1 THEN 1 ELSE 0 END) AS total_cesareas,
        SUM(CASE WHEN F.es_bajo_peso = 1 THEN 1 ELSE 0 END) AS total_bajo_peso,
        ROUND(AVG(CAST(F.peso_gramos AS FLOAT)), 2) AS promedio_peso_gramos
    FROM dbo.FACT_NACIMIENTO F
    INNER JOIN dbo.DIM_TIEMPO T ON F.id_tiempo = T.id_tiempo
    GROUP BY T.anio
)
SELECT 
    anio,
    total_nacimientos,
    LAG(total_nacimientos, 1, NULL) OVER (ORDER BY anio) AS nacimientos_anio_anterior,
    total_nacimientos - LAG(total_nacimientos, 1, total_nacimientos) OVER (ORDER BY anio) AS variacion_absoluta,
    ROUND(
        (CAST(total_nacimientos - LAG(total_nacimientos, 1, total_nacimientos) OVER (ORDER BY anio) AS FLOAT) / 
        NULLIF(LAG(total_nacimientos, 1, total_nacimientos) OVER (ORDER BY anio), 0)) * 100.0, 
        2
    ) AS tasa_crecimiento_pct,
    ROUND((CAST(total_cesareas AS FLOAT) / NULLIF(total_nacimientos, 0)) * 100.0, 2) AS tasa_cesarea_pct,
    ROUND((CAST(total_bajo_peso AS FLOAT) / NULLIF(total_nacimientos, 0)) * 100.0, 2) AS tasa_bajo_peso_pct,
    promedio_peso_gramos
FROM ResumenAnual
ORDER BY anio ASC;


-- ==========================================================================================
-- CONSULTA 2: TASA DE CESÁREAS POR DEPARTAMENTO VS ESTÁNDAR OMS (15%)
-- ==========================================================================================
SELECT 
    U.departamento,
    U.region_natural,
    COUNT(F.id_nacimiento) AS total_partos,
    SUM(CASE WHEN F.es_cesarea = 1 THEN 1 ELSE 0 END) AS partos_cesarea,
    SUM(CASE WHEN F.es_cesarea = 0 THEN 1 ELSE 0 END) AS partos_eutocicos,
    ROUND((CAST(SUM(CASE WHEN F.es_cesarea = 1 THEN 1 ELSE 0 END) AS FLOAT) / NULLIF(COUNT(F.id_nacimiento), 0)) * 100.0, 2) AS pct_cesareas,
    CASE 
        WHEN (CAST(SUM(CASE WHEN F.es_cesarea = 1 THEN 1 ELSE 0 END) AS FLOAT) / NULLIF(COUNT(F.id_nacimiento), 0)) * 100.0 <= 15.0 THEN 'DENTRO DE ESTÁNDAR OMS (<=15%)'
        WHEN (CAST(SUM(CASE WHEN F.es_cesarea = 1 THEN 1 ELSE 0 END) AS FLOAT) / NULLIF(COUNT(F.id_nacimiento), 0)) * 100.0 BETWEEN 15.01 AND 30.0 THEN 'ALERTA MODERADA (15% - 30%)'
        ELSE 'ALERTA CRÍTICA: SOBREUTILIZACIÓN (>30%)'
    END AS clasificacion_alerta_oms
FROM dbo.FACT_NACIMIENTO F
INNER JOIN dbo.DIM_UBIGEO U ON F.ubigeo_cod = U.ubigeo_cod
GROUP BY U.departamento, U.region_natural
ORDER BY pct_cesareas DESC;


-- ==========================================================================================
-- CONSULTA 3: MATRIZ DE RIESGO DE BAJO PESO AL NACER SEGÚN NIVEL EDUCATIVO Y EDAD MATERNA
-- ==========================================================================================
WITH SegmentacionMadre AS (
    SELECT 
        F.id_nacimiento,
        F.peso_gramos,
        F.es_bajo_peso,
        F.es_prematuro,
        M.nivel_instruccion,
        CASE 
            WHEN F.edad_madre < 15 THEN '1. Menor de 15 años (Extremo)'
            WHEN F.edad_madre BETWEEN 15 AND 19 THEN '2. Adolescente (15-19 años)'
            WHEN F.edad_madre BETWEEN 20 AND 34 THEN '3. Edad Óptima (20-34 años)'
            ELSE '4. Edad Avanzada (35+ años)'
        END AS grupo_etario_madre
    FROM dbo.FACT_NACIMIENTO F
    INNER JOIN dbo.DIM_MADRE_PERFIL M ON F.id_madre_perfil = M.id_madre_perfil
)
SELECT 
    nivel_instruccion,
    grupo_etario_madre,
    COUNT(id_nacimiento) AS total_nacimientos,
    SUM(CASE WHEN es_bajo_peso = 1 THEN 1 ELSE 0 END) AS casos_bajo_peso,
    ROUND((CAST(SUM(CASE WHEN es_bajo_peso = 1 THEN 1 ELSE 0 END) AS FLOAT) / NULLIF(COUNT(id_nacimiento), 0)) * 100.0, 2) AS tasa_bajo_peso_pct,
    SUM(CASE WHEN es_prematuro = 1 THEN 1 ELSE 0 END) AS casos_prematuros,
    ROUND((CAST(SUM(CASE WHEN es_prematuro = 1 THEN 1 ELSE 0 END) AS FLOAT) / NULLIF(COUNT(id_nacimiento), 0)) * 100.0, 2) AS tasa_prematuros_pct,
    ROUND(AVG(CAST(peso_gramos AS FLOAT)), 1) AS peso_promedio_g
FROM SegmentacionMadre
GROUP BY nivel_instruccion, grupo_etario_madre
ORDER BY nivel_instruccion, grupo_etario_madre;


-- ==========================================================================================
-- CONSULTA 4: BRECHA DE PARTO INSTITUCIONAL VS PARTO DOMICILIARIO POR REGIÓN
-- ==========================================================================================
SELECT 
    U.region_natural,
    U.departamento,
    A.profesional_atiende,
    COUNT(F.id_nacimiento) AS total_partos,
    ROUND((CAST(COUNT(F.id_nacimiento) AS FLOAT) * 100.0) / 
          SUM(COUNT(F.id_nacimiento)) OVER (PARTITION BY U.departamento), 2) AS porcentaje_del_departamento
FROM dbo.FACT_NACIMIENTO F
INNER JOIN dbo.DIM_UBIGEO U ON F.ubigeo_cod = U.ubigeo_cod
INNER JOIN dbo.DIM_ATENCION_SALUD A ON F.id_atencion_salud = A.id_atencion_salud
GROUP BY U.region_natural, U.departamento, A.profesional_atiende
ORDER BY U.region_natural, U.departamento, total_partos DESC;


-- ==========================================================================================
-- CONSULTA 5: TOP ESTABLECIMIENTOS DE SALUD (IPRESS) CON RANKING ANALÍTICO
-- ==========================================================================================
WITH MetricasIPRESS AS (
    SELECT 
        I.codigo_ipress,
        I.nombre_establecimiento,
        I.categoria_establecimiento,
        COUNT(F.id_nacimiento) AS total_atenciones,
        SUM(CASE WHEN F.es_cesarea = 1 THEN 1 ELSE 0 END) AS total_cesareas,
        ROUND((CAST(SUM(CASE WHEN F.es_cesarea = 1 THEN 1 ELSE 0 END) AS FLOAT) / NULLIF(COUNT(F.id_nacimiento), 0)) * 100.0, 2) AS tasa_cesareas_pct,
        ROUND(AVG(CAST(F.peso_gramos AS FLOAT)), 2) AS peso_promedio_neonato
    FROM dbo.FACT_NACIMIENTO F
    INNER JOIN dbo.DIM_IPRESS I ON F.codigo_ipress = I.codigo_ipress
    GROUP BY I.codigo_ipress, I.nombre_establecimiento, I.categoria_establecimiento
)
SELECT 
    DENSE_RANK() OVER (ORDER BY total_atenciones DESC) AS ranking_volumen,
    codigo_ipress,
    nombre_establecimiento,
    categoria_establecimiento,
    total_atenciones,
    total_cesareas,
    tasa_cesareas_pct,
    peso_promedio_neonato
FROM MetricasIPRESS
ORDER BY ranking_volumen ASC;


-- ==========================================================================================
-- CONSULTA 6: DISPARIDADES POR FUENTE DE FINANCIAMIENTO (SIS VS ESSALUD VS PRIVADO)
-- ==========================================================================================
SELECT 
    A.financiador,
    COUNT(F.id_nacimiento) AS total_nacimientos,
    ROUND((CAST(COUNT(F.id_nacimiento) AS FLOAT) * 100.0) / (SELECT COUNT(*) FROM dbo.FACT_NACIMIENTO), 2) AS cuota_mercado_pct,
    ROUND((CAST(SUM(CASE WHEN F.es_cesarea = 1 THEN 1 ELSE 0 END) AS FLOAT) / NULLIF(COUNT(F.id_nacimiento), 0)) * 100.0, 2) AS tasa_cesareas_pct,
    ROUND((CAST(SUM(CASE WHEN F.es_madre_adolescente = 1 THEN 1 ELSE 0 END) AS FLOAT) / NULLIF(COUNT(F.id_nacimiento), 0)) * 100.0, 2) AS tasa_madre_adolescente_pct,
    ROUND((CAST(SUM(CASE WHEN F.es_bajo_peso = 1 THEN 1 ELSE 0 END) AS FLOAT) / NULLIF(COUNT(F.id_nacimiento), 0)) * 100.0, 2) AS tasa_bajo_peso_pct,
    ROUND(AVG(CAST(F.peso_gramos AS FLOAT)), 1) AS peso_promedio_g,
    ROUND(AVG(CAST(F.edad_madre AS FLOAT)), 1) AS edad_promedio_madre
FROM dbo.FACT_NACIMIENTO F
INNER JOIN dbo.DIM_ATENCION_SALUD A ON F.id_atencion_salud = A.id_atencion_salud
GROUP BY A.financiador
ORDER BY total_nacimientos DESC;
