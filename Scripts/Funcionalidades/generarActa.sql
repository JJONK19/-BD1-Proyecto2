DROP PROCEDURE IF EXISTS bdp2.generarActa;

DELIMITER $$
$$
CREATE PROCEDURE bdp2.generarActa(
	IN codigoE INT,
	IN cicloE VARCHAR(2),
	IN seccionE VARCHAR(1)
)
BEGIN
	-- Declaracion de variables
	DECLARE cicloValido BOOLEAN;
	DECLARE idCursoCiclo INT;
	DECLARE alumnosAsignados INT;
	DECLARE notasRegistradas INT;
	DECLARE anioActual INT;
	SET anioActual = YEAR(CURRENT_DATE);
	
	-- Comprobacion de parametros
	IF codigoE IS NULL OR codigoE <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El curso no existe.';
	END IF;
	
	IF cicloE IS NULL OR LENGTH(cicloE) = 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Ciclo" es invalido.';
	END IF;

	IF seccionE IS NULL OR LENGTH(seccionE) = 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT ='ERROR: El parametro "Seccion" es invalido.';
	END IF;
	
	-- Verificar que exista el curso
	IF NOT EXISTS (SELECT 1 FROM curso WHERE codigo = codigoE) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: EL curso no existe.';
	END IF;
	
	-- Verificar el ciclo
	SET cicloValido = validarCiclo(cicloE);
	IF cicloValido = FALSE THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: No se reconoce el ciclo.';
	END IF;
	
	-- Corroborar que este habilitado el curso. Guardar el id del curso-ciclo y el numero de asignados.
	IF EXISTS (
		SELECT 1 FROM curso_habilitado 
		JOIN curso_catedratico ON curso_catedratico.id = curso_habilitado.curso_catedratico
		JOIN curso_ciclo ON curso_ciclo.id = curso_catedratico.curso_ciclo
		WHERE curso_ciclo.curso = codigoE AND curso_ciclo.seccion = UPPER(seccionE)
			AND curso_ciclo.ciclo = UPPER(cicloE) AND curso_habilitado.anio = anioActual
	)THEN 
		SELECT curso_ciclo.id, curso_habilitado.asignados INTO idCursoCiclo, alumnosAsignados FROM curso_habilitado 
		JOIN curso_catedratico ON curso_catedratico.id = curso_habilitado.curso_catedratico
		JOIN curso_ciclo ON curso_ciclo.id = curso_catedratico.curso_ciclo
		WHERE curso_ciclo.curso = codigoE AND curso_ciclo.seccion = UPPER(seccionE)
			AND curso_ciclo.ciclo = UPPER(cicloE) AND curso_habilitado.anio = anioActual;
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: La sección no esta habilitada para este periodo.';
	END IF;
	
	-- Verificar que no se haya generado ya el acta
	IF EXISTS (SELECT 1 FROM acta WHERE anio = anioActual AND curso_ciclo = idCursoCiclo) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El acta ya fue generada.';
	END IF;

	-- Comprobar que haya el mismo numero de notas que de alumnos asignados. 
	SELECT COUNT(*) INTO notasRegistradas FROM nota
	WHERE curso_ciclo = idCursoCiclo AND anio = anioActual; 

	IF notasRegistradas != alumnosAsignados THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El numero de notas y alumnos registrados no concuerdan.';
	END IF;
	
	-- Generar el acta.
	INSERT INTO acta(anio, curso_ciclo, fecha)
	VALUES (anioActual, idCursoCiclo, CURRENT_TIMESTAMP);
 
	SELECT 'Mensaje: Acta generada correctamente.' AS Salida;
	
END$$
DELIMITER ;

