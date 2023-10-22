DROP PROCEDURE IF EXISTS bdp2.habilitarCurso;

DELIMITER $$
$$
CREATE PROCEDURE bdp2.habilitarCurso(
	IN codigoE INT,
	IN cicloE VARCHAR(2),
	IN docenteE BIGINT,
	IN cupoE INT,
	IN seccionE VARCHAR(1)
)
BEGIN
	-- Declaracion de variables
	DECLARE cicloValido BOOLEAN;
	DECLARE idCursoCiclo INT;
	DECLARE idCursoDocente INT;
	DECLARE anioActual INT; 
	SET anioActual = YEAR(CURRENT_DATE);
	
	-- Comprobacion de parametros
	IF codigoE IS NULL OR codigoE <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Codigo" es invalido.';
	END IF;

	IF cicloE IS NULL OR LENGTH(cicloE) = 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Ciclo" es invalido.';
	END IF;

	IF docenteE IS NULL OR docenteE <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Docente" es invalido.';
	END IF;

	IF cupoE IS NULL OR cupoE <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Cupo" es invalido.';
	END IF;

	IF seccionE IS NULL OR LENGTH(seccionE) = 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Seccion" es invalido.';
	END IF;

	-- Validar que el ciclo sea valido
	SET cicloValido = validarCiclo(cicloE);
	IF cicloValido = FALSE THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El ciclo solo puede recibir estos valores: 1S, 2S, VJ, VD.';
	END IF;
	
	-- Validar que el curso exista
	IF NOT EXISTS (SELECT 1 FROM curso WHERE codigo = codigoE) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El curso ingresado no existe.';
	END IF;
	
	-- Validar que el docente exista
	IF NOT EXISTS (SELECT 1 FROM docente WHERE siif = docenteE) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El docente ingresado no existe.';
	END IF;
	
	-- Validar si existe el curso-ciclo
	-- Si no, crearlo
	IF EXISTS (SELECT 1 FROM curso_ciclo WHERE ciclo = cicloE AND curso = codigoE AND seccion = seccionE) THEN 
		SELECT id INTO idCursoCiclo FROM curso_ciclo WHERE ciclo = cicloE AND curso = codigoE AND seccion = seccionE;
	ELSE 
		INSERT INTO curso_ciclo(ciclo, seccion, curso) VALUES (cicloE, UPPER(seccionE), codigoE);
		SET idCursoCiclo = LAST_INSERT_ID();
	END IF;

	-- Validar si existe el curso-docente
	-- Si no, crearlo
	IF EXISTS (SELECT 1 FROM curso_catedratico WHERE curso_ciclo = idCursoCiclo AND docente = docenteE) THEN 
		SELECT id INTO idCursoDocente FROM curso_catedratico WHERE curso_ciclo = idCursoCiclo AND docente = docenteE;
	ELSE
		INSERT INTO curso_catedratico(docente, curso_ciclo) VALUES (docenteE, idCursoCiclo);
		SET idCursoDocente = LAST_INSERT_ID();
	END IF;

	-- Validar si en el año actual no esta repetido el curso-ciclo
	IF EXISTS (
		SELECT 1 FROM curso_habilitado 
		INNER JOIN curso_catedratico
		ON curso_habilitado.curso_catedratico = curso_catedratico.id
		INNER JOIN curso_ciclo
		ON curso_ciclo.id = curso_catedratico.curso_ciclo
		WHERE curso_ciclo.id = idCursoCiclo AND anio = anioActual) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: La sección del curso ya fue habilitado para este año.';
	END IF; 
	
	-- Habilitar curso
	INSERT INTO curso_habilitado(cupo, anio, curso_catedratico) 
	VALUES (cupoE, anioActual, idCursoDocente);

	SELECT "Mensaje: Curso habilitado exitosamente" AS Salida;

END$$
DELIMITER ;
