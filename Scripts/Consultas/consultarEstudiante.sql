DROP PROCEDURE IF EXISTS bdp2.consultarEstudiante;

DELIMITER $$
$$
CREATE PROCEDURE bdp2.consultarEstudiante(
	IN carnetE BIGINT
)
BEGIN
	-- Comprobacion de parametros
	IF carnetE IS NULL OR carnetE <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Carnet" es invalido.';
	END IF;
	
	-- Verificar si existe el estudiante
	IF NOT EXISTS (SELECT 1 FROM estudiante WHERE carnet = carnetE) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El estudiante no existe';
	END IF;

	-- Realizar el reporte
	SELECT 
		estudiante.carnet AS 'Carnet',
		CONCAT(estudiante.nombres, " ", estudiante.apellidos) AS 'Nombre del Estudiante',
		estudiante.fecha_nacimiento AS 'Fecha de Nacimiento',
		estudiante.correo AS 'Correo Electronico',
		estudiante.telefono AS 'Telefono',
		estudiante.direccion AS 'Direccion',
		estudiante.dpi AS 'DPI',
		carrera.nombre AS 'Carrera',
		estudiante.creditos AS 'Creditos'
	FROM estudiante 
	JOIN carrera ON carrera.id = estudiante.carrera
	WHERE estudiante.carnet = carnetE;

END$$
DELIMITER ;
