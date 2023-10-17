-- LLENADO DE TABLAS 

-- Carrera
INSERT INTO carrera (id, nombre)
VALUES (0, 'Area Comun');

ALTER TABLE carrera AUTO_INCREMENT = 1;

LOAD DATA INFILE 'tu_archivo.csv' INTO TABLE tu_tabla
FIELDS TERMINATED BY ',' (columna1, columna2, ...);
