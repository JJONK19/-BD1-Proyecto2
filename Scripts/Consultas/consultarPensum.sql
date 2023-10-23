DROP PROCEDURE IF EXISTS bdp2.consultarPensum;

DELIMITER $$
$$
CREATE PROCEDURE bdp2.consultarPensum(
	IN carreraE INT
)
BEGIN
	-- Comprobacion de parametros
	IF carreraE IS NULL OR carreraE = 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Carrera" es invalido.';
	END IF;
	
	-- Comprobar que existe la carrera
	IF NOT EXISTS (SELECT 1 FROM carrera WHERE id = carreraE) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: La carrera no existe';
	END IF;

	-- Relizar el reporte
	SELECT 
		codigo AS 'Codigo del Curso', 
		nombre AS 'Nombre del Curso', 
		CASE 
			WHEN obligatorio = TRUE THEN 'Sí'
			ELSE 'No'
		END AS '¿Obligatorio?',
		creditos_necesarios AS 'Creditos Necesarios'
	FROM curso
	WHERE carrera = carreraE OR carrera = 0;
		
END$$
DELIMITER ;
