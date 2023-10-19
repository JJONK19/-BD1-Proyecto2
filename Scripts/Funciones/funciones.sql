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

