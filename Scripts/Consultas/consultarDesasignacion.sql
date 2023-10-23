DROP PROCEDURE IF EXISTS bdp2.consultarDeasignacion;

DELIMITER $$
$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bdp2`.`consultarDeasignacion`(
	IN codigoE INT,
	IN cicloE VARCHAR(2),
	IN anioE INT,
	IN seccionE VARCHAR(1)
)
BEGIN
	-- Declaracion de variables
	DECLARE cicloValido BOOLEAN;
	DECLARE alumnosAsignados INT;
	DECLARE alumnosDesasignados INT;
	DECLARE porcentaje DECIMAL(5,2);

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
	
	-- Calcular la cantidad de asignados
	SELECT COUNT(*) INTO alumnosAsignados FROM asignacion 
	JOIN curso_ciclo ON curso_ciclo.id = asignacion.curso_ciclo
	WHERE curso_ciclo.curso = codigoE AND curso_ciclo.seccion = UPPER(seccionE)
		AND curso_ciclo.ciclo = UPPER(cicloE) AND asignacion.anio = anioE;
	
	-- Calcular la cantidad de desasignados
	SELECT COUNT(*) INTO alumnosDesasignados FROM desasignacion 
	JOIN curso_ciclo ON curso_ciclo.id = desasignacion.curso_ciclo
	WHERE curso_ciclo.curso = codigoE AND curso_ciclo.seccion = UPPER(seccionE)
		AND curso_ciclo.ciclo = UPPER(cicloE) AND desasignacion.anio = anioE;
	
	-- Calcular el procentaje de desasignacion
	IF alumnosAsignados = 0 OR alumnosDesasignados = 0 THEN 
		SET porcentaje = 0;
	ELSE
		SET porcentaje = (alumnosDesasignados / alumnosAsignados) * 100;
	END IF;

	-- Realizar el reporte
	SELECT 
	 	curso_ciclo.curso AS 'Codigo del Curso',
	 	curso_ciclo.seccion AS 'Seccion',
	 	CASE 	
	 		WHEN curso_ciclo.ciclo = '1S' THEN 'PRIMER SEMESTRE'
	 		WHEN curso_ciclo.ciclo = '2S' THEN 'SEGUNDO SEMESTRE'
	 		WHEN curso_ciclo.ciclo = 'VJ' THEN 'VACACIONES DE JUNIO'
	 		WHEN curso_ciclo.ciclo = 'VD' THEN 'VACACIONES DE DICIEMBRE'
		 	END AS 'Ciclo',
	 	anioE AS 'Año',
	 	CONCAT(alumnosDesasignados, " / ", alumnosAsignados) AS 'Desasignados / Asignados',
	 	CONCAT(porcentaje, "%") AS 'Porcentaje de Desasignacion'
	 FROM curso_ciclo 
	 WHERE curso_ciclo.curso = codigoE AND curso_ciclo.seccion = UPPER(seccionE)
		AND curso_ciclo.ciclo = UPPER(cicloE);
END$$
DELIMITER ;
