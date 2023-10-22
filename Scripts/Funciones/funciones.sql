DROP FUNCTION IF EXISTS bdp2.validarCorreo;

DELIMITER $$
$$
CREATE FUNCTION bdp2.validarCorreo(
	correo VARCHAR(100)
)
RETURNS BOOLEAN DETERMINISTIC
BEGIN
	DECLARE resultado BOOLEAN;
	
	IF correo REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$' THEN
		SET resultado = TRUE;
	ELSE 
		SET resultado = FALSE;
	END IF;

	RETURN resultado;
END$$
DELIMITER ;


DROP FUNCTION IF EXISTS bdp2.convertirFecha;

DELIMITER $$
$$
CREATE FUNCTION bdp2.convertirFecha(fecha VARCHAR(15))
RETURNS DATE DETERMINISTIC
BEGIN
	DECLARE resultado DATE;
	SET resultado = STR_TO_DATE(fecha, '%Y-%m-%d');
	RETURN resultado; 
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS bdp2.soloTexto;

DELIMITER $$
$$
CREATE FUNCTION bdp2.soloTexto(
	texto VARCHAR(40)
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
	DECLARE resultado BOOLEAN;

	IF texto REGEXP '^[a-zA-Zaáéíóú ]+$' THEN 
		SET resultado = TRUE;
	ELSE
		SET resultado = FALSE;
	END IF;

	RETURN resultado;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS bdp2.validarCiclo;

DELIMITER $$
$$
CREATE FUNCTION bdp2.validarCiclo(
	ciclo VARCHAR(2)
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
	DECLARE resultado BOOLEAN;
	
	IF ciclo = '1S' OR ciclo = '2S' OR ciclo = 'VJ' OR ciclo = 'VD' THEN 
		SET resultado = TRUE;
	ELSE 
		SET resultado = FALSE;
	END IF;
	
	RETURN resultado;
END$$
DELIMITER ;


DROP FUNCTION IF EXISTS bdp2.validarHorario;

DELIMITER $$
$$
CREATE FUNCTION bdp2.validarHorario(
	entrada VARCHAR(20)
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
	DECLARE resultado BOOLEAN;
	
	-- Eliminar espacios
	SET entrada = REPLACE(entrada, ' ', '');

	-- Verificar 
	IF entrada REGEXP '^([01]\d|2[0-3]):([0-5]\d)-([01]\d|2[0-3]):([0-5]\d)$' THEN
		SET resultado = TRUE;
	ELSE 
		SET resultado = FALSE;
	END IF;

	RETURN resultado;
END$$
DELIMITER ;

