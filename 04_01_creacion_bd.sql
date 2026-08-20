-- ==========================================================================================
-- PROYECTO ACADÉMICO: Big Data con Datos Abiertos Reales (MINSA / RENIEC - CNV Perú)
-- CURSO: Gestión de Base de Datos | Big Data
-- INSTITUCIÓN: Escuela de Educación Superior Tecnológica La Pontificia
-- DOCENTE: Ing. Erick Jhonatan Palomino Ayala
-- ARCHIVO: 04_01_creacion_bd.sql
-- DESCRIPCIÓN: Creación y configuración de la Base de Datos analítica (Sin sentencias GO)
-- ==========================================================================================

USE master;

-- 1. Verificar si la base de datos ya existe y cerrarle conexiones activas si se requiere recrear
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'BD_CNV_BIGDATA_PERU')
BEGIN
    ALTER DATABASE BD_CNV_BIGDATA_PERU SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BD_CNV_BIGDATA_PERU;
END;

-- 2. Creación formal de la Base de Datos con Collation adaptado a Español
CREATE DATABASE BD_CNV_BIGDATA_PERU
COLLATE Modern_Spanish_CI_AS;

-- 3. Configuración de parámetros de alto rendimiento para cargas masivas (Big Data)
USE BD_CNV_BIGDATA_PERU;

-- Modelo de recuperación SIMPLE para optimizar el archivo de transacciones
ALTER DATABASE BD_CNV_BIGDATA_PERU SET RECOVERY SIMPLE;

-- Habilitar lectura no bloqueante para consultas analíticas concurrentes
ALTER DATABASE BD_CNV_BIGDATA_PERU SET READ_COMMITTED_SNAPSHOT ON;
