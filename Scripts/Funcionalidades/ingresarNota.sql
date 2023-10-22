DROP PROCEDURE IF EXISTS bdp2.ingresarNota;

DELIMITER $$
$$
CREATE PROCEDURE bdp2.ingresarNota(
	IN codigoE INT,
	IN cicloE VARCHAR(2),
	IN seccionE VARCHAR(1),
	IN carnetE BIGINT,
	IN notaE DECIMAL(5,2)
)
BEGIN
	-- Delclaracion de Variables
	DECLARE creditosOtorgados INT;
	DECLARE cicloValido BOOLEAN;
	DECLARE anioActual INT;
	DECLARE idCursoCiclo INT;
	DECLARE notaFinal INT;
	SET anioActual = YEAR(CURRENT_DATE);

	-- Comprobacion de Parametros
	IF codigoE IS NULL OR codigoE <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Curso" es invalido.';
	END IF;

	IF cicloE IS NULL OR LENGTH(cicloE) = 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Ciclo" es invalido.';
	END IF;

	IF seccionE IS NULL OR LENGTH(seccionE) = 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Seccion" es invalido.';
	END IF;

	IF carnetE IS NULL OR carnetE <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT ='ERROR: El parametro "Carnet" es invalido.';
	END IF;

	IF notaE IS NULL OR notaE > 100 OR notaE < 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Nota" es invalido.';
	END IF;
	
	-- Verificar que el curso exista y obtener la cantidad de creditos
	IF EXISTS (SELECT 1 FROM curso WHERE codigo = codigoE) THEN 
		SELECT creditos_otorgados INTO creditosOtorgados FROM curso 
		WHERE codigo = codigoE;
	ELSE 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El curso no existe.';
	END IF;
	
	-- Verificar que el ciclo sea valido
	SET cicloValido = validarCiclo(cicloE);
	IF cicloValido = FALSE THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El ciclo es invalido.';
	END IF;
	
	-- Verificar que el curso este habilitado. Guardar el id del curso_ciclo
	IF EXISTS (
		SELECT 1 FROM curso_habilitado 
		JOIN curso_catedratico ON curso_catedratico.id = curso_habilitado.curso_catedratico
		JOIN curso_ciclo ON curso_ciclo.id = curso_catedratico.curso_ciclo
		WHERE curso_ciclo.curso = codigoE AND curso_ciclo.seccion = UPPER(seccionE)
			AND curso_ciclo.curso = codigoE AND curso_habilitado.anio = anioActual
	)THEN 
		SELECT curso_ciclo.id INTO idCursoCiclo FROM curso_habilitado 
		JOIN curso_catedratico ON curso_catedratico.id = curso_habilitado.curso_catedratico
		JOIN curso_ciclo ON curso_ciclo.id = curso_catedratico.curso_ciclo
		WHERE curso_ciclo.curso = codigoE AND curso_ciclo.seccion = UPPER(seccionE)
			AND curso_ciclo.curso = codigoE AND curso_habilitado.anio = anioActual;
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: La sección no esta habilitada para este periodo.';
	END IF;
	
	-- Verificar que exista el estudiante
	IF NOT EXISTS (SELECT 1 FROM estudiante WHERE carnet = carnetE) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: EL estudiante no existe.';
	END IF;

	-- Verificar que nota no este subida ya
	IF EXISTS (
		SELECT 1 FROM nota 
		WHERE anio = anioActual AND curso_ciclo = idCursoCiclo AND estudiante = carnetE
	)THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El estudiante ya tiene una nota registrada para este periodo.';
	END IF;
	
	-- Redondear la nota
	SET notaFinal = CAST(ROUND(notaE) AS SIGNED);
	
	-- Insertar la nota 
	INSERT INTO nota(nota, anio, curso_ciclo, estudiante)
	VALUES (notaFinal, anioActual, idCursoCiclo, carnetE);
	
	-- Sumar los creditos del curso aprobado
	IF notaFinal >= 61 THEN
		UPDATE estudiante SET creditos = creditos + creditosOtorgados 
		WHERE carnet = carnetE;
	END IF;
	
	SELECT 'Mensaje: Nota subida correctamente.' AS Salida;
END$$
DELIMITER ;

