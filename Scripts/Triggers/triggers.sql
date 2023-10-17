USE bdp2;

-- TABLA ACTA
DELIMITER $$
$$
CREATE TRIGGER actaInsert
AFTER INSERT
ON acta FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Nueva fila en tabla acta', 'INSERT');
END
$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER actaDelete
AFTER DELETE 
ON acta FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila eliminada en tabla acta', 'DELETE');
END
$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER actaUpdate
AFTER UPDATE
ON acta FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila actualizada en tabla acta', 'UPDATE');
END$$
DELIMITER ;

-- TABLA ASIGNACION
DELIMITER $$
$$
CREATE TRIGGER asignacionInsert
AFTER INSERT
ON asignacion FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Nueva fila en tabla asignacion', 'INSERT');
END
$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER asignacionDelete
AFTER DELETE
ON asignacion FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila eliminada en tabla asignacion', 'DELETE');
END$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER asignacionUpdate
AFTER UPDATE
ON asignacion FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila actualizada en tabla asignacion', 'UPDATE');
END$$
DELIMITER ;

-- TABLA CARRERA

DELIMITER $$
$$
CREATE TRIGGER carreraInsert
AFTER INSERT
ON carrera FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Nueva fila en tabla carrera', 'INSERT');
END$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER carreraDelete
AFTER DELETE
ON carrera FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila eliminada en tabla carrera', 'DELETE');
END$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER carreraUpdate
AFTER UPDATE
ON carrera FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila actualizada en tabla carrera', 'UPDATE');
END$$
DELIMITER ;

-- Tabla Curso

DELIMITER $$
$$
CREATE TRIGGER cursoInsert
AFTER INSERT
ON curso FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Nueva fila en tabla curso', 'INSERT');
END$$
DELIMITER ;


DELIMITER $$
$$
CREATE TRIGGER cursoDelete
AFTER DELETE
ON curso FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila eliminada en tabla curso', 'DELETE');
END
$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER cursoUpdate
AFTER UPDATE
ON curso FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila actualizada en tabla curso', 'UPDATE');
END
$$
DELIMITER ;

-- TABLA CURSO-CATEDRATICO

DELIMITER $$
$$
CREATE TRIGGER ccInsert
AFTER INSERT
ON curso_catedratico FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Nueva fila en tabla curso-catedratico', 'INSERT');
END$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER ccDelete
AFTER DELETE
ON curso_catedratico FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila eliminada en tabla curso-catedratico', 'DELETE');
END$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER ccUpdate
AFTER UPDATE
ON curso_catedratico FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila actualizada en tabla curso-catedratico', 'UPDATE');
END
$$
DELIMITER ;

-- TABLA CURSO-CATEDRATICO

DELIMITER $$
$$
CREATE TRIGGER cuciInsert
AFTER INSERT
ON curso_ciclo FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Nueva fila en tabla curso-ciclo', 'INSERT');
END$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER cuciDelete
AFTER DELETE
ON curso_ciclo FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila eliminada en tabla curso-ciclo', 'DELETE');
END
$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER cuciUpdate
AFTER UPDATE
ON curso_ciclo FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila actualizada en tabla curso-ciclo', 'UPDATE');
END$$
DELIMITER ;

-- TABLA CURSO-HABILITADO

DELIMITER $$
$$
CREATE TRIGGER chInsertar
AFTER INSERT
ON curso_habilitado FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Nueva fila en tabla curso-habilitado', 'INSERT');
END$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER chDelete
AFTER DELETE
ON curso_habilitado FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila eliminada en tabla curso-habilitado', 'DELETE');
END
$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER chUpdate
AFTER UPDATE
ON curso_habilitado FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila actualizada en tabla curso-habilitado', 'UPDATE');
END
$$
DELIMITER ;

-- TABLA DEASIGNACION

DELIMITER $$
$$
CREATE TRIGGER deasignacionInsert
AFTER INSERT
ON desasignacion FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Nueva fila en tabla desasignacion', 'INSERT');
END$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER deasignacionDelete
AFTER DELETE
ON desasignacion FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila eliminada en tabla desasignacion', 'DELETE');
END
$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER desasignacionUpdate
AFTER UPDATE
ON desasignacion FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila actualizada en tabla desasignacion', 'UPDATE');
END

$$
DELIMITER ;

-- TABLA DOCENTE

DELIMITER $$
$$
CREATE TRIGGER docenteInsert
AFTER INSERT
ON docente FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Nueva fila en tabla docente', 'INSERT');
END$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER docenteDelete
AFTER DELETE
ON docente FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila eliminada en tabla docente', 'DELETE');
END
$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER docenteUpdate
AFTER UPDATE
ON docente FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila actualizada en tabla docente', 'UPDATE');
END
$$
DELIMITER ;

-- TABLA ESTUDIANTE

DELIMITER $$
$$
CREATE TRIGGER estudianteInsert
AFTER INSERT
ON estudiante FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Nueva fila en tabla estudiante', 'INSERT');
END$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER estudianteDelete
AFTER DELETE
ON estudiante FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila eliminada en tabla estudiante', 'DELETE');
END
$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER estudianteUpdate
AFTER UPDATE
ON estudiante FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila actualizada en tabla estudiante', 'UPDATE');
END
$$
DELIMITER ;

-- TABLA HORARIO
DELIMITER $$
$$
CREATE TRIGGER horarioInsert
AFTER INSERT
ON horario FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Nueva fila en tabla horario', 'INSERT');
END$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER horarioDelete
AFTER DELETE
ON horario FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila eliminada en tabla horario', 'DELETE');
END
$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER horarioUpdate
AFTER UPDATE
ON horario FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila actualizada en tabla horario', 'UPDATE');
END
$$
DELIMITER ;

-- TABLA NOTA

DELIMITER $$
$$
CREATE TRIGGER notaInsertar
AFTER INSERT
ON nota FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Nueva fila en tabla nota', 'INSERT');
END$$
DELIMITER ;


DELIMITER $$
$$
CREATE TRIGGER notaDelete
AFTER DELETE
ON nota FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila eliminada en tabla nota', 'DELETE');
END
$$
DELIMITER ;

DELIMITER $$
$$
CREATE TRIGGER notaUpdate
AFTER UPDATE
ON nota FOR EACH ROW
BEGIN 
	INSERT INTO transaccion (descripcion , tipo)
    VALUES ('Fila actualizada en tabla nota', 'UPDATE');
END
$$
DELIMITER ;

