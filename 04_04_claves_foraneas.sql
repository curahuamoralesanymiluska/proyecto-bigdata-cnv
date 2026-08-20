-- ==========================================================================================
-- PROYECTO ACADÉMICO: Big Data con Datos Abiertos Reales (MINSA / RENIEC - CNV Perú)
-- CURSO: Gestión de Base de Datos | Big Data
-- INSTITUCIÓN: Escuela de Educación Superior Tecnológica La Pontificia
-- DOCENTE: Ing. Erick Jhonatan Palomino Ayala
-- ARCHIVO: 04_04_claves_foraneas.sql
-- DESCRIPCIÓN: Definición explícita de Restricciones de Claves Foráneas (Sin sentencias GO)
-- ==========================================================================================

USE BD_CNV_BIGDATA_PERU;

-- 1. Relación: FACT_NACIMIENTO -> DIM_TIEMPO (1:N)
ALTER TABLE dbo.FACT_NACIMIENTO
ADD CONSTRAINT FK_FACT_TIEMPO
FOREIGN KEY (id_tiempo)
REFERENCES dbo.DIM_TIEMPO (id_tiempo);

-- 2. Relación: FACT_NACIMIENTO -> DIM_UBIGEO (1:N)
ALTER TABLE dbo.FACT_NACIMIENTO
ADD CONSTRAINT FK_FACT_UBIGEO
FOREIGN KEY (ubigeo_cod)
REFERENCES dbo.DIM_UBIGEO (ubigeo_cod);

-- 3. Relación: FACT_NACIMIENTO -> DIM_MADRE_PERFIL (1:N)
ALTER TABLE dbo.FACT_NACIMIENTO
ADD CONSTRAINT FK_FACT_MADRE_PERFIL
FOREIGN KEY (id_madre_perfil)
REFERENCES dbo.DIM_MADRE_PERFIL (id_madre_perfil);

-- 4. Relación: FACT_NACIMIENTO -> DIM_CONDICION_PARTO (1:N)
ALTER TABLE dbo.FACT_NACIMIENTO
ADD CONSTRAINT FK_FACT_CONDICION_PARTO
FOREIGN KEY (id_condicion_parto)
REFERENCES dbo.DIM_CONDICION_PARTO (id_condicion_parto);

-- 5. Relación: FACT_NACIMIENTO -> DIM_ATENCION_SALUD (1:N)
ALTER TABLE dbo.FACT_NACIMIENTO
ADD CONSTRAINT FK_FACT_ATENCION_SALUD
FOREIGN KEY (id_atencion_salud)
REFERENCES dbo.DIM_ATENCION_SALUD (id_atencion_salud);

-- 6. Relación: FACT_NACIMIENTO -> DIM_IPRESS (1:N)
ALTER TABLE dbo.FACT_NACIMIENTO
ADD CONSTRAINT FK_FACT_IPRESS
FOREIGN KEY (codigo_ipress)
REFERENCES dbo.DIM_IPRESS (codigo_ipress);
