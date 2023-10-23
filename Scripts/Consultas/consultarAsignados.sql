DROP PROCEDURE IF EXISTS bdp2.consultarAsignados;

DELIMITER $$
$$
CREATE PROCEDURE bdp2.consultarAsignados(
	IN codigoE INT,
	IN cicloE VARCHAR(2),
	IN anioE INT,
	IN seccionE VARCHAR(1)
)
BEGIN
	-- Declaracion de variables
	DECLARE cicloValido BOOLEAN;
	
	-- Comprobacion de parametros
	IF codigoE IS NULL OR codigoE <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Codigo" es invalido.';
	END IF;

	IF cicloE IS NULL OR LENGTH(cicloE) = 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRPR: El parametro "Ciclo" es invalido.';
	END IF;
	
	IF anioE IS NULL OR anioE <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Año" es invalido.';
	END IF;

	IF seccionE IS NULL OR LENGTH(seccionE) = 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRPR: El parametro "Seccion" es invalido.';
	END IF;
	
	-- Comprobar el ciclo
	SET cicloValido = validarCiclo(cicloE);
	IF cicloValido = FALSE THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El ciclo es invalido';
	END IF;
	
	-- Comprobar que exista el curso
	IF NOT EXISTS (SELECT 1 FROM curso WHERE codigo = codigoE) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El curso no existe.';
	END IF;
	
	-- Realizar el reporte
	SELECT 
		estudiante.carnet AS 'Carnet del estudiante',
		CONCAT(estudiante.nombres, " ", estudiante.apellidos) AS 'Nombre del Estudiante',
		estudiante.creditos AS 'Creditos'
	FROM asignacion 
	JOIN estudiante ON estudiante.carnet = asignacion.estudiante
	JOIN curso_ciclo ON asignacion.curso_ciclo = curso_ciclo.id
	WHERE curso_ciclo.curso = codigoE AND curso_ciclo.seccion = UPPER(seccionE) 
		AND curso_ciclo.ciclo = UPPER(cicloE) AND asignacion.anio = anioE;
	
END$$
DELIMITER ;
