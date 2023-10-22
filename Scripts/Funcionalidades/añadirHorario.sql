DROP PROCEDURE IF EXISTS bdp2.agregarHorario;

DELIMITER $$
$$
CREATE PROCEDURE bdp2.agregarHorario(
	IN cursoHabilitado INT,
	IN horarioE VARCHAR(20),
	IN diaE INT
)
BEGIN
	-- Declaracion de variables
	DECLARE horaValida BOOLEAN;
	DECLARE horaV VARCHAR(20);
	
	-- Comprobacion de parametros
	IF cursoHabilitado IS NULL OR cursoHabilitado <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Curso Habilitado" es invalido.';
	END IF;

	IF horarioE IS NULL OR LENGTH(horarioE) = 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Horario" es invalido.';
	END IF;

	IF diaE IS NULL OR diaE <= 0 OR diaE > 7 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El parametro "Dia" es invalido. Debe de ser un numero entre 1 y 7.';
	END IF;
	
	-- Verificar que exista el curso habilitado
	IF NOT EXISTS (SELECT 1 FROM curso_habilitado WHERE id = cursoHabilitado) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El curso habilitado no existe.';
	END IF;

	-- Verificar que la hora cumpla el formato
	SET horav = REPLACE(horarioE, ' ', '');
	SET horaValida = validarHorario(horaV);
	IF horaValida = FALSE THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El formato de la hora es invalido.';
	END IF;
	
	-- Verificar que el horario y el dia no esten repetidos
	IF EXISTS (
		SELECT 1 FROM horario 
		WHERE curso_habilitado = cursoHabilitado AND horario = horaV AND dia = diaE ) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: EL curso ya tiene una hora programada para ese día.';
	END IF; 

	-- Añadir el nuevo horario
	INSERT INTO horario(dia, horario, curso_habilitado)
	VALUES (diaE, horaV, cursoHabilitado);

	SELECT 'Mensaje: Horario asignado correctamente.' AS Salida;

END$$
DELIMITER ;

