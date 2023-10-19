DROP PROCEDURE IF EXISTS bdp2.registrarDocente;

DELIMITER $$
$$
CREATE PROCEDURE bdp2.registrarDocente(
	IN nombresE VARCHAR(40),
	IN apellidosE VARCHAR(40),
	IN fechaNacimiento VARCHAR(10),
	IN correoE VARCHAR(40),
	IN telefonoE INT,
	IN direccionE VARCHAR(40),
	IN dpiE BIGINT,
	IN siifE BIGINT
)
BEGIN
	-- Declaracion de Variables
	DECLARE fecha DATE;
	DECLARE correoValido BOOLEAN;
	
	-- Comprobacion de Parametros
	IF nombresE IS NULL OR LENGTH(nombresE) = 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Nombres" es invalido.';
	END IF;
	
	IF apellidosE IS NULL OR LENGTH(apellidosE) = 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Apellidos" es invalido.';
	END IF;

	IF fechaNacimiento IS NULL OR LENGTH(fechaNacimiento) = 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Fecha Nacimiento" es invalido.';
	END IF;

	IF correoE IS NULL OR LENGTH(correoE) = 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Correo" es invalido.';
	END IF;

	IF telefonoE IS NULL OR telefonoE <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Telefono" es invalido.';
	END IF;

	IF direccionE IS NULL OR LENGTH(direccionE) = 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Direccion" es invalida.';
	END IF;

	IF dpiE IS NULL OR dpiE <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "DPI" es invalido.';
	END IF;

	IF siifE IS NULL OR siifE <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "SIIF" es invalido.';
	END IF;
	
	-- Comprobar que no exista el siif
	IF EXISTS (SELECT 1 FROM docente WHERE siif = siifE) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El docente ya está registrado.';
	END IF;
	
	-- Comprobar el correo
	SET correoValido = validarCorreo(correoE);
	IF correoValido = FALSE THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El formato del correo es invalido.';
	END IF;
	
	-- Insertar el docente
	SET fecha = convertirFecha(fechaNacimiento);
	INSERT docente(siif, dpi, nombres, apellidos, fecha_nacimiento, correo, telefono, direccion, fecha_registro)
	VALUES (siifE, dpiE, UPPER(nombresE), UPPER(apellidosE), fecha, correoE, telefonoE, direccionE, CURRENT_DATE);

	SELECT 'Mensaje: Docente añadido correctamente' AS Salida;

END$$
DELIMITER ;
