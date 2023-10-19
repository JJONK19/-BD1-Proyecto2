DROP PROCEDURE IF EXISTS bdp2.crearCarrera;

DELIMITER $$
$$
CREATE PROCEDURE bdp2.crearCarrera(
	IN nombreCarrera VARCHAR(40)
)
BEGIN
	-- Declaración de Variables
	DECLARE esTexto BOOLEAN;
	DECLARE existe BOOLEAN;
	SET existe = FALSE;

	-- Comprobación de parametros
	IF nombreCarrera IS NULL OR LENGTH(nombreCarrera) = 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Nombre" es invalido';
	END IF;
	
	-- Verificar que solo venga texto
	SET esTexto = soloTexto(nombreCarrera);
	IF esTexto = FALSE THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El nombre de la cadena debe de contener solo texto.';
	END IF;
	
	-- Verificar que no exista una carrera con el mismo nombre
	IF EXISTS (SELECT 1 FROM carrera WHERE LOWER(nombre) = LOWER(nombreCarrera)) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Ya existe una carrera con ese nombre.';
	END IF;
	
	-- Crear la carrera
	INSERT INTO carrera(nombre)
	VALUES (UPPER(nombreCarrera)); 

	SELECT 'Mensaje: Carrera creada correctamente.' AS Salida;
END$$
DELIMITER ;

