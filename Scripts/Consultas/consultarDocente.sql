DROP PROCEDURE IF EXISTS bdp2.consultarDocente;

DELIMITER $$
$$
CREATE PROCEDURE bdp2.consultarDocente(
	IN siifE BIGINT
)
BEGIN
	-- Comprobacion de parametros
	IF siifE IS NULL OR siifE <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "SIIF" es invalido.';
	END IF;

	-- Comprobar que existe el docente
	IF NOT EXISTS (SELECT 1 FROM docente WHERE siif = siifE) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El docente no existe.';
	END IF;
	
	-- Realizar el reporte
	SELECT 
		siif AS 'Registro SIIF',
		CONCAT(nombres, " ", apellidos) AS 'Nombre del Docente',
		fecha_nacimiento AS 'Fecha de Nacimiento',
		correo AS 'Correo Electronico',
		telefono AS 'Telefono',
		direccion AS 'Direccion', 
		dpi AS 'DPI'
	FROM docente 
	WHERE siif = siifE;
END$$
DELIMITER ;
