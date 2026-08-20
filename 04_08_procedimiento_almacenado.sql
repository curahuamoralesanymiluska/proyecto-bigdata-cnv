-- ==========================================================================================
-- PROYECTO ACADÉMICO: Big Data con Datos Abiertos Reales (MINSA / RENIEC - CNV Perú)
-- CURSO: Gestión de Base de Datos | Big Data
-- INSTITUCIÓN: Escuela de Educación Superior Tecnológica La Pontificia
-- DOCENTE: Ing. Erick Jhonatan Palomino Ayala
-- ARCHIVO: 04_08_procedimiento_almacenado.sql
-- DESCRIPCIÓN: Colección completa de Procedimientos Almacenados en T-SQL (Sin sentencias GO)
-- ==========================================================================================

USE BD_CNV_BIGDATA_PERU;

-- ==========================================================================================
-- 0.1. Procedimientos Almacenados
-- ==========================================================================================

-- ------------------------------------------------------------------------------------------
-- 0.1.1. Mostrar todos los nacimientos
-- Procedimiento que selecciona los registros de la tabla FACT_NACIMIENTO sin ningún filtro.
-- ------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_MostrarTodosNacimientos
AS BEGIN
    SELECT TOP 100 * FROM FACT_NACIMIENTO;
END;

EXEC sp_MostrarTodosNacimientos;


-- ------------------------------------------------------------------------------------------
-- 0.1.2. Nacimientos por región
-- Recibe un Departamento y devuelve los nacimientos registrados en dicha ubicación.
-- ------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_NacimientosPorRegion
    @Departamento VARCHAR(60)
AS BEGIN
    SELECT F.* 
    FROM FACT_NACIMIENTO F
    INNER JOIN DIM_UBIGEO U ON F.ubigeo_cod = U.ubigeo_cod
    WHERE U.departamento = @Departamento;
END;

EXEC sp_NacimientosPorRegion @Departamento = 'AYACUCHO';


-- ------------------------------------------------------------------------------------------
-- 0.1.3. Nacimiento por ID
-- Recibe un ID_NACIMIENTO y devuelve únicamente el registro del nacimiento correspondiente.
-- ------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_NacimientoPorId
    @IdNacimiento BIGINT
AS BEGIN
    SELECT * FROM FACT_NACIMIENTO WHERE id_nacimiento = @IdNacimiento;
END;

EXEC sp_NacimientoPorId @IdNacimiento = 1;


-- ------------------------------------------------------------------------------------------
-- 0.1.4. Verificar alertas neonatales
-- Recibe un Departamento y muestra un mensaje indicando si existen casos de bajo peso al nacer.
-- ------------------------------------------------------------------------------------------
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

EXEC sp_VerificarAlertasNeonatales @Departamento = 'AYACUCHO';


-- ------------------------------------------------------------------------------------------
-- 0.1.5. Nacimientos por rango de años
-- Recibe un año de inicio y uno de fin, y devuelve los nacimientos ocurridos dentro de ese rango.
-- ------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_NacimientosPorRangoAnios
    @AnioInicio INT,
    @AnioFin INT
AS BEGIN
    SELECT F.*
    FROM FACT_NACIMIENTO F
    INNER JOIN DIM_TIEMPO T ON F.id_tiempo = T.id_tiempo
    WHERE T.anio BETWEEN @AnioInicio AND @AnioFin;
END;

EXEC sp_NacimientosPorRangoAnios @AnioInicio = 2023, @AnioFin = 2025;


-- ------------------------------------------------------------------------------------------
-- 0.1.6. Insertar perfil de madre
-- Inserta un nuevo registro en la tabla DIM_MADRE_PERFIL con estado civil, instrucción, ocupación y país.
-- ------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_InsertarMadrePerfil
    @EstadoCivil VARCHAR(40),
    @NivelInstruccion VARCHAR(60),
    @Ocupacion VARCHAR(100),
    @PaisOrigen VARCHAR(60)
AS BEGIN
    INSERT INTO DIM_MADRE_PERFIL (estado_civil, nivel_instruccion, ocupacion, pais_origen)
    VALUES (@EstadoCivil, @NivelInstruccion, @Ocupacion, @PaisOrigen);
END;

EXEC sp_InsertarMadrePerfil @EstadoCivil = 'SOLTERO', @NivelInstruccion = 'SUPERIOR UNIV. COMPLETA', @Ocupacion = 'INGENIERA DE SISTEMAS', @PaisOrigen = 'PERU';


-- ------------------------------------------------------------------------------------------
-- 0.1.7. Actualizar categoría de establecimiento IPRESS
-- Actualiza la categoría MINSA de un establecimiento existente, identificado por su CODIGO_IPRESS.
-- ------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_ActualizarCategoriaIpress
    @CodigoIpress VARCHAR(10),
    @NuevaCategoria VARCHAR(30)
AS BEGIN
    UPDATE DIM_IPRESS 
    SET categoria_establecimiento = @NuevaCategoria 
    WHERE codigo_ipress = @CodigoIpress;
END;

EXEC sp_ActualizarCategoriaIpress @CodigoIpress = '00002155', @NuevaCategoria = 'I-4 (CON INTERNAMIENTO)';


-- ------------------------------------------------------------------------------------------
-- 0.1.8. Eliminar nacimiento
-- Elimina un registro de la tabla FACT_NACIMIENTO según su ID_NACIMIENTO.
-- ------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_EliminarNacimiento
    @IdNacimiento BIGINT
AS BEGIN
    DELETE FROM FACT_NACIMIENTO WHERE id_nacimiento = @IdNacimiento;
END;

EXEC sp_EliminarNacimiento @IdNacimiento = 99999;


-- ------------------------------------------------------------------------------------------
-- 0.1.9. Eliminar perfil de madre
-- Intenta eliminar un perfil de la tabla DIM_MADRE_PERFIL según su ID_MADRE_PERFIL.
-- ------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_EliminarPerfilMadre
    @IdMadrePerfil INT
AS BEGIN
    DELETE FROM DIM_MADRE_PERFIL WHERE id_madre_perfil = @IdMadrePerfil;
END;

EXEC sp_EliminarPerfilMadre @IdMadrePerfil = 9999;


-- ------------------------------------------------------------------------------------------
-- 0.1.10. Nacimientos con detalle completo
-- Devuelve los nacimientos junto con el nombre del departamento, hospital, perfil materno y vía de parto usando INNER JOIN.
-- ------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_NacimientosConDetalleCompleto
AS BEGIN
    SELECT 
        F.id_nacimiento,
        T.anio AS Anio,
        T.nombre_mes AS Mes,
        U.departamento AS Departamento,
        U.distrito AS Distrito,
        I.nombre_establecimiento AS Hospital,
        M.nivel_instruccion AS NivelInstruccionMadre,
        M.ocupacion AS OcupacionMadre,
        C.condicion_parto AS CondicionParto,
        A.financiador AS FinanciadorSalud,
        F.peso_gramos AS PesoGramos,
        F.talla_cm AS TallaCm,
        F.edad_madre AS EdadMadre
    FROM FACT_NACIMIENTO F
    INNER JOIN DIM_TIEMPO T ON F.id_tiempo = T.id_tiempo
    INNER JOIN DIM_UBIGEO U ON F.ubigeo_cod = U.ubigeo_cod
    INNER JOIN DIM_IPRESS I ON F.codigo_ipress = I.codigo_ipress
    INNER JOIN DIM_MADRE_PERFIL M ON F.id_madre_perfil = M.id_madre_perfil
    INNER JOIN DIM_CONDICION_PARTO C ON F.id_condicion_parto = C.id_condicion_parto
    INNER JOIN DIM_ATENCION_SALUD A ON F.id_atencion_salud = A.id_atencion_salud;
END;

EXEC sp_NacimientosConDetalleCompleto;


-- ------------------------------------------------------------------------------------------
-- 0.1.11. Buscar establecimiento por nombre
-- Busca establecimientos de salud cuyo nombre contenga una palabra clave, usando el operador LIKE.
-- ------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_BuscarEstablecimientoPorNombre
    @PalabraClave VARCHAR(100)
AS BEGIN
    SELECT * FROM DIM_IPRESS WHERE nombre_establecimiento LIKE '%' + @PalabraClave + '%';
END;

EXEC sp_BuscarEstablecimientoPorNombre @PalabraClave = 'AYACUCHO';
EXEC sp_BuscarEstablecimientoPorNombre @PalabraClave = 'MATERNO';


-- ------------------------------------------------------------------------------------------
-- 0.1.12. Total de nacimientos y cesáreas
-- Calcula el número total de nacimientos y partos por cesárea registrados en la tabla FACT_NACIMIENTO.
-- ------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_TotalNacimientosYCesareas
AS BEGIN
    SELECT 
        COUNT(*) AS TotalNacimientos,
        SUM(CAST(es_cesarea AS INT)) AS TotalCesareas,
        ROUND((CAST(SUM(CAST(es_cesarea AS INT)) AS FLOAT) / COUNT(*)) * 100.0, 2) AS TasaCesareasPct
    FROM FACT_NACIMIENTO;
END;

EXEC sp_TotalNacimientosYCesareas;


-- ------------------------------------------------------------------------------------------
-- 0.1.13. Insertar establecimiento IPRESS
-- Inserta un nuevo centro de salud en la tabla DIM_IPRESS con sus datos institucionales.
-- ------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_InsertarEstablecimientoIpress
    @CodigoIpress VARCHAR(10),
    @NombreEstablecimiento VARCHAR(150),
    @Categoria VARCHAR(30)
AS BEGIN
    INSERT INTO DIM_IPRESS (codigo_ipress, nombre_establecimiento, categoria_establecimiento)
    VALUES (@CodigoIpress, @NombreEstablecimiento, @Categoria);
END;

EXEC sp_InsertarEstablecimientoIpress @CodigoIpress = '00009991', @NombreEstablecimiento = 'CENTRO MATERNO INFANTIL LA PONTIFICIA', @Categoria = 'I-4';


-- ------------------------------------------------------------------------------------------
-- 0.1.14. Actualizar flag de cesárea masivo
-- Actualiza el campo es_cesarea de todos los nacimientos en función de la condición de parto.
-- ------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_ActualizarFlagCesareaMasivo
AS BEGIN
    UPDATE F
    SET F.es_cesarea = 1
    FROM FACT_NACIMIENTO F
    INNER JOIN DIM_CONDICION_PARTO C ON F.id_condicion_parto = C.id_condicion_parto
    WHERE C.condicion_parto = 'CESAREA';
END;

EXEC sp_ActualizarFlagCesareaMasivo;


-- ------------------------------------------------------------------------------------------
-- 0.1.15. Recorrer departamentos con cursor
-- Utiliza un cursor de T-SQL para recorrer fila por fila los departamentos e imprimir las métricas.
-- ------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_RecorrerDepartamentosCursor
AS BEGIN
    DECLARE @CodDep VARCHAR(2), @Dep VARCHAR(60), @Region VARCHAR(30);
    
    DECLARE mi_cursor CURSOR FOR
    SELECT DISTINCT codigo_dep, departamento, region_natural FROM DIM_UBIGEO;
    
    OPEN mi_cursor;
    FETCH NEXT FROM mi_cursor INTO @CodDep, @Dep, @Region;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'Departamento [' + @CodDep + ']: ' + @Dep + ' (Region: ' + @Region + ')';
        FETCH NEXT FROM mi_cursor INTO @CodDep, @Dep, @Region;
    END;
    
    CLOSE mi_cursor;
    DEALLOCATE mi_cursor;
END;

EXEC sp_RecorrerDepartamentosCursor;


-- ------------------------------------------------------------------------------------------
-- 0.1.16. Nacimientos de un financiador
-- Obtiene todos los nacimientos cubiertos por un financiador específico (SIS, EsSalud, etc.).
-- ------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_NacimientosPorFinanciador
    @Financiador VARCHAR(50)
AS BEGIN
    SELECT F.* 
    FROM FACT_NACIMIENTO F
    INNER JOIN DIM_ATENCION_SALUD A ON F.id_atencion_salud = A.id_atencion_salud
    WHERE A.financiador = @Financiador;
END;

EXEC sp_NacimientosPorFinanciador @Financiador = 'SIS';


-- ------------------------------------------------------------------------------------------
-- 0.1.17. Tabla temporal de estadísticas regionales
-- Crea una tabla temporal (#EstadisticasRegionales) con el consolidado por región y la retorna.
-- ------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_TablaTemporalEstadisticas
    @Anio INT
AS BEGIN
    SELECT 
        U.departamento,
        COUNT(F.id_nacimiento) AS TotalPartos,
        SUM(CAST(F.es_cesarea AS INT)) AS TotalCesareas,
        ROUND(AVG(CAST(F.peso_gramos AS FLOAT)), 2) AS PesoPromedio
    INTO #EstadisticasRegionales
    FROM FACT_NACIMIENTO F
    INNER JOIN DIM_TIEMPO T ON F.id_tiempo = T.id_tiempo
    INNER JOIN DIM_UBIGEO U ON F.ubigeo_cod = U.ubigeo_cod
    WHERE T.anio = @Anio
    GROUP BY U.departamento;
    
    SELECT * FROM #EstadisticasRegionales ORDER BY TotalPartos DESC;
END;

EXEC sp_TablaTemporalEstadisticas @Anio = 2025;


-- ------------------------------------------------------------------------------------------
-- 0.1.18. Insertar nacimiento rápido
-- Inserta un nacimiento utilizando los parámetros esenciales biométricos.
-- ------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_InsertarNacimientoRapido
    @IdTiempo INT,
    @UbigeoCod VARCHAR(6),
    @IdMadrePerfil INT,
    @IdCondicionParto INT,
    @IdAtencionSalud INT,
    @CodigoIpress VARCHAR(10),
    @Sexo VARCHAR(15),
    @Peso DECIMAL(6,2),
    @Talla DECIMAL(4,1),
    @GestacionSem INT,
    @EdadMadre INT
AS BEGIN
    INSERT INTO FACT_NACIMIENTO (
        id_tiempo, ubigeo_cod, id_madre_perfil, id_condicion_parto, id_atencion_salud, codigo_ipress,
        sexo, peso_gramos, talla_cm, duracion_embarazo_sem, edad_madre,
        es_bajo_peso, es_prematuro, es_madre_adolescente, es_cesarea
    ) VALUES (
        @IdTiempo, @UbigeoCod, @IdMadrePerfil, @IdCondicionParto, @IdAtencionSalud, @CodigoIpress,
        @Sexo, @Peso, @Talla, @GestacionSem, @EdadMadre,
        CASE WHEN @Peso < 2500.0 THEN 1 ELSE 0 END,
        CASE WHEN @GestacionSem < 37 THEN 1 ELSE 0 END,
        CASE WHEN @EdadMadre < 18 THEN 1 ELSE 0 END,
        0
    );
END;

EXEC sp_InsertarNacimientoRapido @IdTiempo = 202506, @UbigeoCod = '050101', @IdMadrePerfil = 1, @IdCondicionParto = 1, @IdAtencionSalud = 1, @CodigoIpress = '00002150', @Sexo = 'FEMENINO', @Peso = 3200.0, @Talla = 49.0, @GestacionSem = 39, @EdadMadre = 25;


-- ------------------------------------------------------------------------------------------
-- 0.1.19. Devolver ubicación por Ubigeo
-- Recibe un UBIGEO_COD y devuelve el departamento, provincia y distrito correspondiente.
-- ------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_DevolverUbicacionPorUbigeo
    @UbigeoCod VARCHAR(6)
AS BEGIN
    SELECT departamento, provincia, distrito, region_natural
    FROM DIM_UBIGEO
    WHERE ubigeo_cod = @UbigeoCod;
END;

EXEC sp_DevolverUbicacionPorUbigeo @UbigeoCod = '050101';


-- ------------------------------------------------------------------------------------------
-- 0.1.20. Buscar por región y año
-- Busca estadísticas que coincidan simultáneamente con un Departamento y un Año específico.
-- ------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_BuscarPorRegionYAnio
    @Departamento VARCHAR(60),
    @Anio INT
AS BEGIN
    SELECT 
        U.departamento,
        T.anio,
        COUNT(F.id_nacimiento) AS TotalNacimientos,
        SUM(CAST(F.es_cesarea AS INT)) AS TotalCesareas,
        SUM(CAST(F.es_bajo_peso AS INT)) AS TotalBajoPeso,
        ROUND(AVG(CAST(F.peso_gramos AS FLOAT)), 2) AS PesoPromedio
    FROM FACT_NACIMIENTO F
    INNER JOIN DIM_TIEMPO T ON F.id_tiempo = T.id_tiempo
    INNER JOIN DIM_UBIGEO U ON F.ubigeo_cod = U.ubigeo_cod
    WHERE U.departamento = @Departamento AND T.anio = @Anio
    GROUP BY U.departamento, T.anio;
END;

EXEC sp_BuscarPorRegionYAnio @Departamento = 'AYACUCHO', @Anio = 2025;
