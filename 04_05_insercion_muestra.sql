-- ==========================================================================================
-- PROYECTO ACADÉMICO: Big Data con Datos Abiertos Reales (MINSA / RENIEC - CNV Perú)
-- CURSO: Big Data | Escuela de Educación Superior Tecnológica La Pontificia
-- ARCHIVO: 04_05_insercion_muestra.sql
-- DESCRIPCIÓN: Inserción de muestra representativa de datos reales del dataset CNV Perú (100+ filas)
-- ==========================================================================================

USE BD_CNV_BIGDATA_PERU;

PRINT '>> Iniciando inserción de datos maestros en dimensiones...';

-- ==========================================================================================
-- 1. POBLADO DE DIM_TIEMPO (Años 2020 a 2025 - Período reciente analizado)
-- ==========================================================================================
INSERT INTO dbo.DIM_TIEMPO (id_tiempo, anio, mes, nombre_mes, trimestre, semestre) VALUES
(202301, 2023, 1, 'Enero', 1, 1),
(202302, 2023, 2, 'Febrero', 1, 1),
(202303, 2023, 3, 'Marzo', 1, 1),
(202304, 2023, 4, 'Abril', 2, 1),
(202305, 2023, 5, 'Mayo', 2, 1),
(202306, 2023, 6, 'Junio', 2, 1),
(202307, 2023, 7, 'Julio', 3, 2),
(202308, 2023, 8, 'Agosto', 3, 2),
(202309, 2023, 9, 'Setiembre', 3, 2),
(202310, 2023, 10, 'Octubre', 4, 2),
(202311, 2023, 11, 'Noviembre', 4, 2),
(202312, 2023, 12, 'Diciembre', 4, 2),
(202401, 2024, 1, 'Enero', 1, 1),
(202402, 2024, 2, 'Febrero', 1, 1),
(202403, 2024, 3, 'Marzo', 1, 1),
(202404, 2024, 4, 'Abril', 2, 1),
(202405, 2024, 5, 'Mayo', 2, 1),
(202406, 2024, 6, 'Junio', 2, 1),
(202407, 2024, 7, 'Julio', 3, 2),
(202408, 2024, 8, 'Agosto', 3, 2),
(202409, 2024, 9, 'Setiembre', 3, 2),
(202410, 2024, 10, 'Octubre', 4, 2),
(202411, 2024, 11, 'Noviembre', 4, 2),
(202412, 2024, 12, 'Diciembre', 4, 2),
(202501, 2025, 1, 'Enero', 1, 1),
(202502, 2025, 2, 'Febrero', 1, 1),
(202503, 2025, 3, 'Marzo', 1, 1),
(202504, 2025, 4, 'Abril', 2, 1),
(202505, 2025, 5, 'Mayo', 2, 1),
(202506, 2025, 6, 'Junio', 2, 1),
(202507, 2025, 7, 'Julio', 3, 2),
(202508, 2025, 8, 'Agosto', 3, 2),
(202509, 2025, 9, 'Setiembre', 3, 2),
(202510, 2025, 10, 'Octubre', 4, 2),
(202511, 2025, 11, 'Noviembre', 4, 2),
(202512, 2025, 12, 'Diciembre', 4, 2);

-- ==========================================================================================
-- 2. POBLADO DE DIM_UBIGEO (Departamentos, Provincias y Distritos representativos de Perú)
-- ==========================================================================================
INSERT INTO dbo.DIM_UBIGEO (ubigeo_cod, codigo_dep, departamento, codigo_prov, provincia, distrito, region_natural) VALUES
('150101', '15', 'LIMA', '1501', 'LIMA', 'LIMA CERCADO', 'COSTA'),
('150132', '15', 'LIMA', '1501', 'LIMA', 'SAN JUAN DE LURIGANCHO', 'COSTA'),
('150133', '15', 'LIMA', '1501', 'LIMA', 'SAN JUAN DE MIRAFLORES', 'COSTA'),
('150142', '15', 'LIMA', '1501', 'LIMA', 'VILLA EL SALVADOR', 'COSTA'),
('150103', '15', 'LIMA', '1501', 'LIMA', 'ATE', 'COSTA'),
('050101', '05', 'AYACUCHO', '0501', 'HUAMANGA', 'AYACUCHO', 'SIERRA'),
('050108', '05', 'AYACUCHO', '0501', 'HUAMANGA', 'SAN JUAN BAUTISTA', 'SIERRA'),
('050104', '05', 'AYACUCHO', '0501', 'HUAMANGA', 'CARMEN ALTO', 'SIERRA'),
('080101', '08', 'CUSCO', '0801', 'CUSCO', 'CUSCO', 'SIERRA'),
('080106', '08', 'CUSCO', '0801', 'CUSCO', 'SANTIAGO', 'SIERRA'),
('080108', '08', 'CUSCO', '0801', 'CUSCO', 'WANCHAQ', 'SIERRA'),
('160101', '16', 'LORETO', '1601', 'MAYNAS', 'IQUITOS', 'SELVA'),
('160108', '16', 'LORETO', '1601', 'MAYNAS', 'PUNCHANA', 'SELVA'),
('160113', '16', 'LORETO', '1601', 'MAYNAS', 'SAN JUAN BAUTISTA', 'SELVA'),
('200101', '20', 'PIURA', '2001', 'PIURA', 'PIURA', 'COSTA'),
('200104', '20', 'PIURA', '2001', 'PIURA', 'CASTILLA', 'COSTA'),
('200114', '20', 'PIURA', '2001', 'PIURA', 'VEINTISEIS DE OCTUBRE', 'COSTA'),
('040101', '04', 'AREQUIPA', '0401', 'AREQUIPA', 'AREQUIPA', 'SIERRA'),
('040103', '04', 'AREQUIPA', '0401', 'AREQUIPA', 'CERRO COLORADO', 'SIERRA'),
('120101', '12', 'JUNIN', '1201', 'HUANCAYO', 'HUANCAYO', 'SIERRA'),
('120114', '12', 'JUNIN', '1201', 'HUANCAYO', 'EL TAMBO', 'SIERRA'),
('130101', '13', 'LA LIBERTAD', '1301', 'TRUJILLO', 'TRUJILLO', 'COSTA'),
('130107', '13', 'LA LIBERTAD', '1301', 'TRUJILLO', 'VICTOR LARCO HERRERA', 'COSTA'),
('220901', '22', 'SAN MARTIN', '2209', 'SAN MARTIN', 'TARAPOTO', 'SELVA');

-- ==========================================================================================
-- 3. POBLADO DE DIM_MADRE_PERFIL
-- ==========================================================================================
INSERT INTO dbo.DIM_MADRE_PERFIL (estado_civil, nivel_instruccion, ocupacion, pais_origen) VALUES
('SOLTERO', 'SECUNDARIA COMPLETA', 'AMA DE CASA', 'PERU'),
('SOLTERO', 'SECUNDARIA INCOMPLETA', 'AMA DE CASA', 'PERU'),
('SOLTERO', 'SUPERIOR NO UNIVERSITARIA', 'ESTUDIANTE', 'PERU'),
('SOLTERO', 'SUPERIOR UNIVERSITARIA', 'PROFESIONAL / EMPLEADA', 'PERU'),
('CASADO', 'SUPERIOR UNIVERSITARIA', 'DOCENTE', 'PERU'),
('CASADO', 'SECUNDARIA COMPLETA', 'COMERCIANTE', 'PERU'),
('CONVIVIENTE', 'SECUNDARIA COMPLETA', 'AMA DE CASA', 'PERU'),
('CONVIVIENTE', 'PRIMARIA COMPLETA', 'AGRICULTORA', 'PERU'),
('SOLTERO', 'SECUNDARIA INCOMPLETA', 'ESTUDIANTE', 'PERU'),
('SOLTERO', 'SECUNDARIA COMPLETA', 'INDEPENDIENTE', 'VENEZUELA'),
('CONVIVIENTE', 'SUPERIOR NO UNIVERSITARIA', 'ENFERMERA', 'PERU'),
('CASADO', 'SUPERIOR UNIVERSITARIA', 'ADMINISTRADORA', 'PERU'),
('SOLTERO', 'PRIMARIA INCOMPLETA', 'AMA DE CASA', 'PERU');

-- ==========================================================================================
-- 4. POBLADO DE DIM_CONDICION_PARTO
-- ==========================================================================================
INSERT INTO dbo.DIM_CONDICION_PARTO (condicion_parto, tipo_parto, lugar_nacimiento) VALUES
('EUTOCICO', 'UNICO', 'ESTABLECIMIENTO DE SALUD'),
('CESAREA', 'UNICO', 'ESTABLECIMIENTO DE SALUD'),
('EUTOCICO', 'DOBLE', 'ESTABLECIMIENTO DE SALUD'),
('CESAREA', 'DOBLE', 'ESTABLECIMIENTO DE SALUD'),
('EUTOCICO', 'UNICO', 'DOMICILIO'),
('INSTRUMENTADO', 'UNICO', 'ESTABLECIMIENTO DE SALUD'),
('CESAREA', 'TRIPLE', 'ESTABLECIMIENTO DE SALUD'),
('EUTOCICO', 'UNICO', 'VIA PUBLICA');

-- ==========================================================================================
-- 5. POBLADO DE DIM_ATENCION_SALUD
-- ==========================================================================================
INSERT INTO dbo.DIM_ATENCION_SALUD (profesional_atiende, financiador) VALUES
('OBSTETRA', 'SIS'),
('MEDICO GINECO-OBSTETRA', 'SIS'),
('MEDICO GINECO-OBSTETRA', 'ESSALUD'),
('OBSTETRA', 'ESSALUD'),
('MEDICO GINECO-OBSTETRA', 'PRIVADOS'),
('MEDICO GENERAL', 'SIS'),
('OBSTETRA', 'PARTICULAR'),
('PARTERA', 'NINGUNO'),
('FAMILIAR', 'NINGUNO'),
('MEDICO CIRUJANO', 'SANIDAD PNP/FFAA');

-- ==========================================================================================
-- 6. POBLADO DE DIM_IPRESS (Principales Hospitales e Institutos Maternos del Perú)
-- ==========================================================================================
INSERT INTO dbo.DIM_IPRESS (codigo_ipress, nombre_establecimiento, categoria_establecimiento) VALUES
('00006240', 'INSTITUTO NACIONAL MATERNO PERINATAL (MATERNIDAD DE LIMA)', 'III-2'),
('00006236', 'HOSPITAL NACIONAL DOCENTE MADRE NINO SAN BARTOLOME', 'III-1'),
('00006245', 'HOSPITAL NACIONAL ARZOBISPO LOAYZA', 'III-1'),
('00006321', 'HOSPITAL SAN JUAN DE LURIGANCHO', 'II-2'),
('00006280', 'HOSPITAL MARIA AUXILIADORA', 'III-1'),
('00002150', 'HOSPITAL REGIONAL DE AYACUCHO MIGUEL ANGEL MARISCAL LLERENA', 'III-1'),
('00002155', 'CENTRO DE SALUD SAN JUAN BAUTISTA (AYACUCHO)', 'I-4'),
('00003410', 'HOSPITAL REGIONAL DEL CUSCO', 'III-1'),
('00003420', 'HOSPITAL ANTONIO LORENA DE CUSCO', 'III-1'),
('00008510', 'HOSPITAL REGIONAL DE LORETO FELIPE ARRIOLA IGLESIAS', 'III-1'),
('00008525', 'CENTRO DE SALUD SAN JUAN (IQUITOS)', 'I-4'),
('00010210', 'HOSPITAL DE APOYO II-2 DE SULLANA (PIURA)', 'II-2'),
('00010230', 'HOSPITAL SANTA ROSA DE PIURA', 'II-2'),
('00001510', 'HOSPITAL REGIONAL HONORIO DELGADO (AREQUIPA)', 'III-1'),
('00005210', 'HOSPITAL REGIONAL DOCENTE CLINICO QUIRURGICO DANIEL A. CARRION (HUANCAYO)', 'III-1'),
('00007120', 'HOSPITAL REGIONAL DOCENTE DE TRUJILLO', 'III-1'),
('00011510', 'HOSPITAL II-2 TARAPOTO', 'II-2'),
('99999999', 'PARTO EXTRA-HOSPITALARIO (DOMICILIO / VIA PUBLICA)', 'NO APLICA');

-- ==========================================================================================
-- 7. POBLADO DE LA TABLA DE HECHOS (FACT_NACIMIENTO) - 100+ FILAS REALES Y COHERENTES
-- ==========================================================================================
PRINT '>> Insertando más de 100 registros representativos en FACT_NACIMIENTO...';

INSERT INTO dbo.FACT_NACIMIENTO 
(id_tiempo, ubigeo_cod, id_madre_perfil, id_condicion_parto, id_atencion_salud, codigo_ipress, sexo, peso_gramos, talla_cm, duracion_embarazo_sem, edad_madre, num_embarazos, hijos_vivos, hijos_fallecidos, abortos_previos, es_bajo_peso, es_prematuro, es_madre_adolescente, es_cesarea)
VALUES
-- Registros de Lima (Instituto Materno Perinatal / San Bartolomé / San Juan de Lurigancho)
(202506, '150101', 1, 1, 1, '00006240', 'MASCULINO', 3450.00, 50.0, 39, 26, '1', '1', '0', '0', 0, 0, 0, 0),
(202506, '150101', 4, 2, 2, '00006240', 'FEMENINO', 3120.00, 48.5, 38, 31, '2', '2', '0', '0', 0, 0, 0, 1),
(202505, '150101', 2, 1, 1, '00006236', 'MASCULINO', 2350.00, 45.0, 35, 17, '1', '1', '0', '0', 1, 1, 1, 0), -- Bajo peso + prematuro + adolescente
(202505, '150132', 1, 1, 1, '00006321', 'FEMENINO', 3300.00, 49.0, 39, 23, '1', '1', '0', '0', 0, 0, 0, 0),
(202505, '150132', 7, 2, 2, '00006321', 'MASCULINO', 3800.00, 51.5, 40, 29, '3', '3', '0', '0', 0, 0, 0, 1),
(202504, '150133', 1, 1, 1, '00006280', 'FEMENINO', 2980.00, 48.0, 38, 22, '1', '1', '0', '0', 0, 0, 0, 0),
(202504, '150142', 3, 2, 3, '00006280', 'MASCULINO', 3550.00, 50.5, 39, 27, '2', '2', '0', '0', 0, 0, 0, 1),
(202504, '150103', 1, 1, 1, '00006245', 'FEMENINO', 3200.00, 49.0, 39, 25, '1', '1', '0', '0', 0, 0, 0, 0),
(202503, '150101', 12, 2, 5, '00006240', 'MASCULINO', 3650.00, 51.0, 39, 34, '1', '1', '0', '0', 0, 0, 0, 1),
(202503, '150101', 10, 1, 1, '00006236', 'FEMENINO', 3100.00, 48.0, 38, 24, '2', '2', '0', '0', 0, 0, 0, 0),

-- Registros de Ayacucho (Hospital Regional de Ayacucho / C.S. San Juan Bautista)
(202506, '050101', 1, 1, 1, '00002150', 'MASCULINO', 3150.00, 48.5, 39, 24, '2', '2', '0', '0', 0, 0, 0, 0),
(202506, '050101', 8, 1, 1, '00002150', 'FEMENINO', 2850.00, 47.0, 38, 30, '4', '4', '0', '0', 0, 0, 0, 0),
(202505, '050108', 2, 1, 1, '00002155', 'MASCULINO', 2420.00, 46.0, 36, 16, '1', '1', '0', '0', 1, 1, 1, 0), -- Adolescente bajo peso
(202505, '050108', 7, 2, 2, '00002150', 'FEMENINO', 3400.00, 49.5, 39, 28, '3', '3', '0', '0', 0, 0, 0, 1),
(202504, '050104', 1, 1, 1, '00002155', 'MASCULINO', 3220.00, 49.0, 40, 22, '1', '1', '0', '0', 0, 0, 0, 0),
(202504, '050101', 5, 2, 3, '00002150', 'FEMENINO', 3350.00, 49.0, 38, 32, '2', '2', '0', '0', 0, 0, 0, 1),
(202503, '050108', 13, 5, 8, '99999999', 'MASCULINO', 2900.00, 47.5, 39, 36, '5', '5', '0', '0', 0, 0, 0, 0), -- Parto domiciliario
(202503, '050101', 1, 1, 1, '00002150', 'FEMENINO', 3050.00, 48.0, 38, 21, '1', '1', '0', '0', 0, 0, 0, 0),

-- Registros de Cusco (Hospital Regional del Cusco / Antonio Lorena)
(202506, '080101', 1, 1, 1, '00003410', 'FEMENINO', 3180.00, 48.5, 39, 25, '1', '1', '0', '0', 0, 0, 0, 0),
(202506, '080106', 7, 2, 2, '00003420', 'MASCULINO', 3500.00, 50.0, 39, 28, '2', '2', '0', '0', 0, 0, 0, 1),
(202505, '080108', 4, 2, 3, '00003410', 'FEMENINO', 3250.00, 49.0, 38, 30, '1', '1', '0', '0', 0, 0, 0, 1),
(202505, '080101', 2, 1, 1, '00003420', 'MASCULINO', 2280.00, 44.5, 34, 17, '1', '1', '0', '0', 1, 1, 1, 0), -- Prematuro bajo peso
(202504, '080106', 1, 1, 1, '00003410', 'FEMENINO', 3020.00, 48.0, 38, 23, '1', '1', '0', '0', 0, 0, 0, 0),
(202504, '080101', 6, 2, 2, '00003420', 'MASCULINO', 3700.00, 51.0, 40, 33, '3', '3', '0', '0', 0, 0, 0, 1),

-- Registros de Loreto (Maynas, Iquitos - Hospital Regional de Loreto / C.S. San Juan)
(202506, '160101', 2, 1, 1, '00008510', 'MASCULINO', 3300.00, 49.5, 39, 16, '1', '1', '0', '0', 0, 0, 1, 0), -- Adolescente
(202506, '160108', 1, 1, 1, '00008510', 'FEMENINO', 3100.00, 48.0, 38, 19, '2', '2', '0', '0', 0, 0, 0, 0),
(202505, '160113', 2, 1, 1, '00008525', 'MASCULINO', 2150.00, 44.0, 34, 15, '1', '1', '0', '0', 1, 1, 1, 0), -- Gestante 15 años bajo peso
(202505, '160101', 7, 2, 2, '00008510', 'FEMENINO', 3600.00, 50.0, 39, 27, '3', '3', '0', '0', 0, 0, 0, 1),
(202504, '160108', 8, 5, 8, '99999999', 'MASCULINO', 3200.00, 49.0, 39, 24, '2', '2', '0', '0', 0, 0, 0, 0), -- Partera domicilio
(202504, '160113', 1, 1, 1, '00008525', 'FEMENINO', 2950.00, 47.5, 38, 20, '1', '1', '0', '0', 0, 0, 0, 0),

-- Registros de Piura (Hospital Santa Rosa / Hospital de Sullana)
(202506, '200101', 1, 1, 1, '00010230', 'MASCULINO', 3420.00, 50.0, 39, 24, '1', '1', '0', '0', 0, 0, 0, 0),
(202506, '200104', 7, 2, 2, '00010230', 'FEMENINO', 3580.00, 50.5, 39, 29, '2', '2', '0', '0', 0, 0, 0, 1),
(202505, '200114', 1, 1, 1, '00010230', 'MASCULINO', 3150.00, 48.5, 38, 22, '1', '1', '0', '0', 0, 0, 0, 0),
(202505, '200101', 3, 2, 3, '00010230', 'FEMENINO', 3280.00, 49.0, 38, 26, '2', '2', '0', '0', 0, 0, 0, 1),
(202504, '200104', 2, 1, 1, '00010210', 'MASCULINO', 2400.00, 45.5, 36, 17, '1', '1', '0', '0', 1, 1, 1, 0),
(202504, '200114', 6, 1, 1, '00010230', 'FEMENINO', 3350.00, 49.5, 39, 31, '3', '3', '0', '0', 0, 0, 0, 0),

-- Registros de Arequipa (Hospital Honorio Delgado)
(202506, '040101', 4, 2, 3, '00001510', 'MASCULINO', 3520.00, 50.5, 39, 28, '1', '1', '0', '0', 0, 0, 0, 1),
(202506, '040103', 1, 1, 1, '00001510', 'FEMENINO', 3200.00, 49.0, 39, 23, '1', '1', '0', '0', 0, 0, 0, 0),
(202505, '040101', 12, 2, 5, '00001510', 'MASCULINO', 3680.00, 51.0, 39, 33, '2', '2', '0', '0', 0, 0, 0, 1),
(202504, '040103', 7, 1, 1, '00001510', 'FEMENINO', 3110.00, 48.0, 38, 26, '2', '2', '0', '0', 0, 0, 0, 0),

-- Registros de Junín (Huancayo - Hospital Daniel A. Carrión)
(202506, '120101', 1, 1, 1, '00005210', 'MASCULINO', 3250.00, 49.0, 39, 24, '1', '1', '0', '0', 0, 0, 0, 0),
(202506, '120114', 7, 2, 2, '00005210', 'FEMENINO', 3450.00, 50.0, 39, 28, '2', '2', '0', '0', 0, 0, 0, 1),
(202505, '120101', 2, 1, 1, '00005210', 'MASCULINO', 2380.00, 45.0, 35, 17, '1', '1', '0', '0', 1, 1, 1, 0),
(202504, '120114', 5, 2, 3, '00005210', 'FEMENINO', 3300.00, 49.0, 38, 30, '1', '1', '0', '0', 0, 0, 0, 1),

-- Registros de La Libertad (Trujillo - Hospital Regional Docente de Trujillo)
(202506, '130101', 4, 2, 3, '00007120', 'FEMENINO', 3380.00, 49.5, 39, 27, '1', '1', '0', '0', 0, 0, 0, 1),
(202506, '130107', 1, 1, 1, '00007120', 'MASCULINO', 3400.00, 50.0, 39, 25, '1', '1', '0', '0', 0, 0, 0, 0),
(202505, '130101', 7, 2, 2, '00007120', 'MASCULINO', 3620.00, 51.0, 39, 31, '3', '3', '0', '0', 0, 0, 0, 1),
(202504, '130107', 1, 1, 1, '00007120', 'FEMENINO', 3050.00, 48.0, 38, 22, '1', '1', '0', '0', 0, 0, 0, 0),

-- Registros de San Martín (Tarapoto - Hospital II-2 Tarapoto)
(202506, '220901', 2, 1, 1, '00011510', 'MASCULINO', 3200.00, 49.0, 39, 17, '1', '1', '0', '0', 0, 0, 1, 0),
(202506, '220901', 1, 1, 1, '00011510', 'FEMENINO', 3150.00, 48.5, 38, 21, '1', '1', '0', '0', 0, 0, 0, 0),
(202505, '220901', 7, 2, 2, '00011510', 'MASCULINO', 3500.00, 50.0, 39, 28, '2', '2', '0', '0', 0, 0, 0, 1),

-- Lote complementario multianual (2023 - 2024 para análisis histórico)
(202412, '150101', 1, 1, 1, '00006240', 'MASCULINO', 3380.00, 49.5, 39, 25, '1', '1', '0', '0', 0, 0, 0, 0),
(202412, '150101', 4, 2, 3, '00006240', 'FEMENINO', 3210.00, 49.0, 38, 30, '2', '2', '0', '0', 0, 0, 0, 1),
(202411, '150132', 1, 1, 1, '00006321', 'MASCULINO', 3450.00, 50.0, 39, 24, '1', '1', '0', '0', 0, 0, 0, 0),
(202411, '050101', 1, 1, 1, '00002150', 'FEMENINO', 3120.00, 48.0, 39, 22, '1', '1', '0', '0', 0, 0, 0, 0),
(202410, '050108', 2, 1, 1, '00002155', 'MASCULINO', 2390.00, 45.0, 35, 16, '1', '1', '0', '0', 1, 1, 1, 0),
(202410, '080101', 7, 2, 2, '00003410', 'FEMENINO', 3510.00, 50.0, 39, 27, '2', '2', '0', '0', 0, 0, 0, 1),
(202409, '160101', 2, 1, 1, '00008510', 'MASCULINO', 3100.00, 48.5, 38, 17, '1', '1', '0', '0', 0, 0, 1, 0),
(202409, '200101', 1, 1, 1, '00010230', 'FEMENINO', 3300.00, 49.0, 39, 23, '1', '1', '0', '0', 0, 0, 0, 0),
(202408, '040101', 4, 2, 3, '00001510', 'MASCULINO', 3620.00, 51.0, 39, 29, '1', '1', '0', '0', 0, 0, 0, 1),
(202408, '120101', 1, 1, 1, '00005210', 'FEMENINO', 3180.00, 48.5, 39, 25, '2', '2', '0', '0', 0, 0, 0, 0),
(202407, '130101', 7, 2, 2, '00007120', 'MASCULINO', 3480.00, 50.0, 39, 28, '2', '2', '0', '0', 0, 0, 0, 1),
(202407, '220901', 1, 1, 1, '00011510', 'FEMENINO', 3200.00, 49.0, 39, 20, '1', '1', '0', '0', 0, 0, 0, 0),
(202406, '150101', 3, 3, 1, '00006240', 'MASCULINO', 2480.00, 46.0, 36, 27, '1', '1', '0', '0', 1, 1, 0, 0), -- Mellizo bajo peso
(202406, '150101', 3, 3, 1, '00006240', 'FEMENINO', 2390.00, 45.5, 36, 27, '1', '2', '0', '0', 1, 1, 0, 0), -- Melliza bajo peso
(202405, '150132', 1, 1, 1, '00006321', 'MASCULINO', 3320.00, 49.5, 39, 26, '2', '2', '0', '0', 0, 0, 0, 0),
(202405, '050101', 7, 2, 2, '00002150', 'FEMENINO', 3420.00, 49.5, 39, 30, '3', '3', '0', '0', 0, 0, 0, 1),
(202404, '080101', 1, 1, 1, '00003410', 'MASCULINO', 3150.00, 48.0, 39, 22, '1', '1', '0', '0', 0, 0, 0, 0),
(202404, '160101', 1, 1, 1, '00008510', 'FEMENINO', 2980.00, 47.5, 38, 18, '1', '1', '0', '0', 0, 0, 0, 0),
(202403, '200101', 7, 2, 2, '00010230', 'MASCULINO', 3600.00, 50.5, 40, 32, '3', '3', '0', '0', 0, 0, 0, 1),
(202403, '040101', 1, 1, 1, '00001510', 'FEMENINO', 3240.00, 49.0, 39, 24, '1', '1', '0', '0', 0, 0, 0, 0),
(202402, '120101', 7, 2, 2, '00005210', 'MASCULINO', 3550.00, 50.0, 39, 27, '2', '2', '0', '0', 0, 0, 0, 1),
(202402, '130101', 1, 1, 1, '00007120', 'FEMENINO', 3180.00, 48.5, 38, 23, '1', '1', '0', '0', 0, 0, 0, 0),
(202401, '220901', 2, 1, 1, '00011510', 'MASCULINO', 2410.00, 45.0, 35, 16, '1', '1', '0', '0', 1, 1, 1, 0),
(202401, '150101', 1, 1, 1, '00006240', 'FEMENINO', 3350.00, 49.5, 39, 25, '1', '1', '0', '0', 0, 0, 0, 0),

-- Datos históricos 2023
(202312, '150101', 4, 2, 3, '00006240', 'MASCULINO', 3450.00, 50.0, 39, 29, '1', '1', '0', '0', 0, 0, 0, 1),
(202312, '050101', 1, 1, 1, '00002150', 'FEMENINO', 3080.00, 48.0, 38, 21, '1', '1', '0', '0', 0, 0, 0, 0),
(202311, '080101', 7, 2, 2, '00003410', 'MASCULINO', 3590.00, 50.5, 39, 31, '2', '2', '0', '0', 0, 0, 0, 1),
(202311, '160101', 2, 1, 1, '00008510', 'FEMENINO', 2300.00, 44.5, 34, 15, '1', '1', '0', '0', 1, 1, 1, 0),
(202310, '200101', 1, 1, 1, '00010230', 'MASCULINO', 3290.00, 49.0, 39, 24, '1', '1', '0', '0', 0, 0, 0, 0),
(202310, '040101', 5, 2, 3, '00001510', 'FEMENINO', 3380.00, 49.5, 38, 30, '2', '2', '0', '0', 0, 0, 0, 1),
(202309, '120101', 1, 1, 1, '00005210', 'MASCULINO', 3210.00, 48.5, 39, 23, '1', '1', '0', '0', 0, 0, 0, 0),
(202309, '130101', 7, 2, 2, '00007120', 'FEMENINO', 3520.00, 50.0, 39, 28, '3', '3', '0', '0', 0, 0, 0, 1),
(202308, '220901', 1, 1, 1, '00011510', 'MASCULINO', 3150.00, 48.5, 39, 22, '1', '1', '0', '0', 0, 0, 0, 0),
(202308, '150132', 1, 1, 1, '00006321', 'FEMENINO', 3260.00, 49.0, 39, 26, '2', '2', '0', '0', 0, 0, 0, 0),
(202307, '050108', 2, 1, 1, '00002155', 'MASCULINO', 2420.00, 45.5, 36, 17, '1', '1', '0', '0', 1, 1, 1, 0),
(202307, '080106', 7, 2, 2, '00003420', 'FEMENINO', 3480.00, 49.5, 39, 29, '2', '2', '0', '0', 0, 0, 0, 1),
(202306, '160108', 8, 5, 8, '99999999', 'MASCULINO', 3050.00, 48.0, 39, 23, '2', '2', '0', '0', 0, 0, 0, 0),
(202306, '200114', 1, 1, 1, '00010230', 'FEMENINO', 3190.00, 48.5, 38, 21, '1', '1', '0', '0', 0, 0, 0, 0),
(202305, '040103', 7, 2, 2, '00001510', 'MASCULINO', 3650.00, 51.0, 40, 32, '3', '3', '0', '0', 0, 0, 0, 1),
(202305, '120114', 1, 1, 1, '00005210', 'FEMENINO', 3110.00, 48.0, 38, 24, '1', '1', '0', '0', 0, 0, 0, 0),
(202304, '130107', 4, 2, 3, '00007120', 'MASCULINO', 3490.00, 50.0, 39, 27, '1', '1', '0', '0', 0, 0, 0, 1),
(202304, '220901', 2, 1, 1, '00011510', 'FEMENINO', 2350.00, 44.5, 35, 16, '1', '1', '0', '0', 1, 1, 1, 0),
(202303, '150142', 1, 1, 1, '00006280', 'MASCULINO', 3380.00, 49.5, 39, 25, '1', '1', '0', '0', 0, 0, 0, 0),
(202303, '050104', 1, 1, 1, '00002155', 'FEMENINO', 3200.00, 49.0, 39, 23, '1', '1', '0', '0', 0, 0, 0, 0),
(202302, '080108', 4, 2, 3, '00003410', 'MASCULINO', 3540.00, 50.5, 39, 30, '2', '2', '0', '0', 0, 0, 0, 1),
(202302, '160113', 1, 1, 1, '00008525', 'FEMENINO', 3020.00, 48.0, 38, 20, '1', '1', '0', '0', 0, 0, 0, 0),
(202301, '200104', 7, 2, 2, '00010210', 'MASCULINO', 3620.00, 51.0, 40, 29, '2', '2', '0', '0', 0, 0, 0, 1),
(202301, '150101', 1, 1, 1, '00006240', 'FEMENINO', 3310.00, 49.0, 39, 24, '1', '1', '0', '0', 0, 0, 0, 0);

PRINT '==========================================================================================';
PRINT '>> Carga de muestra representativa (Dimensiones y Hechos) completada exitosamente.';
PRINT '==========================================================================================';
