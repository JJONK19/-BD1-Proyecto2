DROP PROCEDURE IF EXISTS bdp2.desasignarCurso;

DELIMITER $$
$$
CREATE PROCEDURE bdp2.desasignarCurso(
	IN codigoE INT,
	IN cicloE VARCHAR(2),
	IN seccionE VARCHAR(1),
	IN carnetE BIGINT
)
BEGIN
	-- Declaracion de variables
	DECLARE cicloValido BOOLEAN;
	DECLARE anioActual INT;
	DECLARE idCurso INT;
	DECLARE idCursoCiclo INT;
	DECLARE idAsignacion INT;
	DECLARE carreraEstudiante INT;
	DECLARE creditosEstudiante INT;
	SET anioActual = YEAR(CURRENT_DATE);

	-- Comprobacion de parametros
	IF codigoE IS NULL OR codigoE <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Codigo" es invalido.'; 
	END IF;

	IF cicloE IS NULL OR LENGTH(cicloE) = 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Ciclo" es invalido.';
	END IF;

	IF seccionE IS NULL OR LENGTH(seccionE) = 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Seccion" es invalido.';
	END IF;

	IF carnetE IS NULL OR carnetE <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR El parametro "Carnet" es invalido.';
	END IF;
	
	-- Validar que el curso existe
	IF NOT EXISTS (SELECT 1 FROM curso WHERE codigo = codigoE) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El curso no existe.';
	END IF;
	
	-- Validar que el ciclo sea valido
	SET cicloValido = validarCiclo(cicloE);
	IF cicloValido = FALSE THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El ciclo ingresado es invalido.';
	END IF;
	
	-- Validar que el curso esta habilitado. Guardar el id del curso habilitado y curso ciclo.
	IF EXISTS (
		SELECT 1 FROM curso_habilitado
		JOIN curso_catedratico ON curso_habilitado.curso_catedratico = curso_catedratico.id
		JOIN curso_ciclo ON curso_catedratico.curso_ciclo = curso_ciclo.id
		WHERE curso_ciclo.curso = codigoE AND curso_ciclo.seccion = seccionE 
			AND curso_ciclo.ciclo = UPPER(cicloE) AND curso_habilitado.anio = anioActual
	) THEN 
		SELECT curso_habilitado.id, curso_ciclo.id INTO idCurso, idCursoCiclo FROM curso_habilitado
		JOIN curso_catedratico ON curso_habilitado.curso_catedratico = curso_catedratico.id
		JOIN curso_ciclo ON curso_catedratico.curso_ciclo = curso_ciclo.id
		WHERE curso_ciclo.curso = codigoE AND curso_ciclo.seccion = seccionE 
			AND curso_ciclo.ciclo = UPPER(cicloE) AND curso_habilitado.anio = anioActual;
	ELSE 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: La sección que busca no está habilitada para este periodo.';
	END IF;
	
	-- Validar que el estudiante existe. Almacenar sus creditos y carrera.
	IF NOT EXISTS (SELECT 1 FROM estudiante WHERE carnet = carnetE ) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El estudiante no existe.';
	ELSE
		SELECT carrera, creditos INTO carreraEstudiante, creditosEstudiante 
		FROM estudiante WHERE carnet = carnetE;
	END IF;
	
	-- Validar que este asignado 
	IF NOT EXISTS (
		SELECT 1 FROM asignacion
		JOIN curso_ciclo ON asignacion.curso_ciclo = curso_ciclo.id
		WHERE asignacion.anio = anioActual AND curso_ciclo.curso = codigoE
			AND asignacion.estudiante = carnetE AND curso_ciclo.ciclo = cicloE 
	) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El estudiante no encuentra asignado a este curso.';
	ELSE
		SELECT asignacion.id INTO idAsignacion FROM asignacion
		JOIN curso_ciclo ON asignacion.curso_ciclo = curso_ciclo.id
		WHERE asignacion.anio = anioActual AND curso_ciclo.curso = codigoE
			AND asignacion.estudiante = carnetE AND curso_ciclo.ciclo = cicloE;
	END IF;

	-- Validar que no se haya deasignado ya
	IF EXISTS (
		SELECT 1 FROM desasignacion
		JOIN curso_ciclo ON desasignacion.curso_ciclo = curso_ciclo.id
		WHERE desasignacion.anio = anioActual AND curso_ciclo.curso = codigoE
			AND desasignacion.estudiante = carnetE AND curso_ciclo.ciclo = cicloE
	) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El alumno ya se encuentra desasignado del curso.';
	END IF;
	
	-- Deasignar al estudiante
	INSERT INTO desasignacion (anio, curso_ciclo, estudiante) 
	VALUES (anioActual, idCursoCiclo, carnetE); 
	
	-- Aumentar el cupo y reducir los asignados
	UPDATE curso_habilitado SET cupo = cupo + 1, asignados = asignados - 1 WHERE id = idCurso;

	SELECT 'Mensaje: Asignación finalizada con exito.' AS Salida;
END$$
DELIMITER ;

