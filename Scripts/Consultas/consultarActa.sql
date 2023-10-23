DROP PROCEDURE IF EXISTS bdp2.consultarActas;

DELIMITER $$
$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bdp2`.`consultarActas`(
	IN codigoE INT
)
BEGIN
	-- Comprobacion de parametros
	IF codigoE IS NULL OR codigoE <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Codigo" es invalido.';
	END IF;
	
	-- Comprobar que exista el curso
	IF NOT EXISTS (SELECT 1 FROM curso WHERE codigo = codigoE) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El curso no existe.';
	END IF;

	-- Realizar reporte
	SELECT 
	 	curso_ciclo.curso AS 'Codigo del Curso',
	 	curso_ciclo.seccion AS 'Seccion',
	 	CASE 	
	 		WHEN curso_ciclo.ciclo = '1S' THEN 'PRIMER SEMESTRE'
	 		WHEN curso_ciclo.ciclo = '2S' THEN 'SEGUNDO SEMESTRE'
	 		WHEN curso_ciclo.ciclo = 'VJ' THEN 'VACACIONES DE JUNIO'
	 		WHEN curso_ciclo.ciclo = 'VD' THEN 'VACACIONES DE DICIEMBRE'
		 	END AS 'Ciclo',
	 	acta.anio AS 'Año',
	 	acta.noNotas AS 'Estudiantes Asignados',
	 	acta.fecha AS 'Fecha'
	 FROM acta 
	 JOIN curso_ciclo ON curso_ciclo.id = acta.curso_ciclo
	 WHERE curso_ciclo.curso = codigoE;
			
END$$
DELIMITER ;
