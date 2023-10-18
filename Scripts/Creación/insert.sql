-- LLENADO DE TABLAS 

-- Carrera
INSERT INTO carrera (nombre)
VALUES ('Area Comun');

UPDATE carrera
SET id = 0
WHERE nombre = 'Area Comun';

ALTER TABLE carrera AUTO_INCREMENT = 1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/carreras.csv' 
INTO TABLE carrera
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES
(nombre);

-- Curso
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cursos.csv'
INTO TABLE curso
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES
(codigo, nombre, creditos_necesarios, creditos_otorgados, obligatorio, carrera);

-- Docente
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/docentes.csv'
INTO TABLE docente
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(siif, dpi, nombres, apellidos, fecha_nacimiento, correo, telefono, direccion)
SET fecha_registro = CURRENT_DATE;

-- Estudiante
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/estudiantes.csv'
INTO TABLE estudiante
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(carnet, nombres, apellidos, fecha_nacimiento, correo, telefono, direccion, dpi, carrera)
SET fecha_registro = CURRENT_DATE;
