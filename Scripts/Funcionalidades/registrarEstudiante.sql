DROP PROCEDURE IF EXISTS bdp2.registrarEstudiante;

DELIMITER $$
$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bdp2`.`registrarEstudiante`(
	IN Carne BIGINT, 
	IN Nombres VARCHAR(40),
	IN Apellidos VARCHAR(40),
	IN Fecha_nacimiento VARCHAR(10),
	IN Correo VARCHAR(40),
	IN Telefono INT,
	IN Direccion VARCHAR(40),
	IN Dpi BIGINT,
	IN Carrera INT
)
BEGIN
	-- Inicializar variables
	DECLARE fecha DATE;
	DECLARE correoValido BOOLEAN;
	
	-- Comprobacion de Variables
	IF Carne IS NULL OR Carne = 0 OR Carne <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parámetro "Carnet" es nulo.';
    END IF;
   
  	IF Nombres IS NULL OR LENGTH(Nombres) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parámetro "Nombres" es invalido.';
  	END IF;
   
   	IF Apellidos IS NULL OR LENGTH(Apellidos) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parámetro "Apellidos" es invalido.';
    END IF;
   
   	IF Fecha_nacimiento IS NULL OR LENGTH(Fecha_nacimiento) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parámetro "Fecha_nacimiento" es invalido.';
    END IF;
   
   	IF Correo IS NULL OR LENGTH(Correo) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parámetro "Correo" es invalido.';
    END IF;
   
   	IF Telefono IS NULL OR Telefono <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parámetro "Telefono" es invalido.';
    END IF;
   
   	IF Direccion IS NULL OR LENGTH(Direccion) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parámetro "Direccion" es invalido.';
    END IF;
   
   	IF Dpi IS NULL OR Dpi = 0 OR Carrera <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parámetro "Dpi" es invalido.';
    END IF;
   
   	IF Carrera IS NULL OR Carrera = 0 OR Carrera <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parámetro "Carrera" es invalido.';
    END IF;
   
   	-- Comprobar que no exista el carnet
   	IF EXISTS (SELECT 1 FROM estudiante WHERE carnet = Carne) THEN 
   		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Ya existe un usuario con ese numero de carnet.';
   	END IF;
   
   	-- Comporbar que exista el id de la carrera
   	IF NOT EXISTS (SELECT 1 FROM carrera WHERE id = Carrera) THEN 
   		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: La carrera ingresada no existe';
   	END IF;
  
  	-- Comprobar correo
  	SET correoValido = validarCorreo(Correo);
  	IF correoValido = FALSE THEN 
  		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "ERROR: El correo ingresado es invalido";
  	END IF;
  
  	-- Insertar el Usuario
  	SET fecha = convertirFecha(Fecha_nacimiento);
 	INSERT INTO estudiante(carnet, nombres, apellidos, fecha_nacimiento, correo, telefono, direccion, dpi, carrera, fecha_registro)
 	VALUES (Carne, UPPER(Nombres), UPPER(Apellidos), fecha, Correo, Telefono, Direccion, Dpi, Carrera, CURRENT_DATE);
	
	SELECT 'Mensaje: Estudiante insertado correctamente.' AS Salida;
   	
END$$
DELIMITER ;
