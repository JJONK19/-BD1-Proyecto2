DROP PROCEDURE IF EXISTS bdp2.crearCurso;

DELIMITER $$
$$
CREATE PROCEDURE bdp2.crearCurso(
	IN codigoE INT,
	IN nombreE VARCHAR(60),
	IN creditosNecesarios INT,
	IN creditosOtorgados INT,
	IN obligatorioE TINYINT(1),
	IN carreraE INT
)
BEGIN
	-- Comprobar Parametros
	IF codigoE IS NULL OR codigoE < 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Codigo" es invalido.';
	END IF;

	IF nombreE IS NULL OR LENGTH(nombreE) = 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Nombres" es invalido.';
	END IF;

	IF creditosNecesarios IS NULL OR creditosNecesarios < 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Creditos Necesarios" es invalido o menor que cero.';
	END IF; 

	IF creditosOtorgados IS NULL OR creditosOtorgados < 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Creditos Otorgados" es invalido o menor que cero.';
	END IF;

	IF obligatorioE IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Obligatorio" es invalido.';
	END IF;

	IF carreraE IS NULL OR carreraE < 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Carrera" es invalido.';
	END IF; 
	
	-- Comprobar que el codigo del curso no exista
	IF EXISTS (SELECT 1 FROM curso WHERE codigo = codigoE) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El codigo del curso ya existe.';
	END IF;
	
	-- Comprobar que el nombre del curso no exista
	IF EXISTS (SELECT 1 FROM curso WHERE UPPER(nombre) = UPPER(nombreE)) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: EL curso ya existe.';
	END IF;
	
	-- Verificar que la carrera existe
	IF NOT EXISTS (SELECT 1 FROM carrera WHERE id = carreraE) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El codigo de la carrera es erroneo.';
	END IF;
	
	-- Insertar el curso
	INSERT INTO curso(codigo, nombre, creditos_necesarios, creditos_otorgados, obligatorio, carrera)
	VALUES (codigoE, UPPER(nombreE), creditosNecesarios, creditosOtorgados, obligatorioE, carreraE);

	SELECT "Mensaje: Curso añadido correctamente." AS Salida;

END$$
DELIMITER ;
