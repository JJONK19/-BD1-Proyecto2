DROP PROCEDURE IF EXISTS bdp2.consultarAprobacion;

DELIMITER $$
$$
CREATE PROCEDURE bdp2.consultarAprobacion(
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
		curso_ciclo.curso AS 'Codigo del Curso',
		nota.estudiante AS 'Carnet',
		CONCAT(estudiante.nombres, " ", estudiante.apellidos) AS 'Nombre Completo',
		CASE 
			WHEN nota.nota >= 61 THEN 'Aprobado'
			ELSE 'Reprobado'
		END AS 'Resultado'
	FROM nota
	JOIN estudiante ON estudiante.carnet = nota.estudiante
	JOIN curso_ciclo ON curso_ciclo.id = nota.curso_ciclo
	WHERE curso_ciclo.curso = codigoE AND nota.anio = anioE 
		AND curso_ciclo.ciclo = UPPER(cicloE) AND curso_ciclo.seccion = UPPER(seccionE);
END$$
DELIMITER ;
