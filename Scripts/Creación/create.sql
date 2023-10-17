-- REINICIAR BASE DE DATOS
DROP DATABASE IF EXISTS bdp2;

-- CREACION DE LA BASE DE DATOS
CREATE DATABASE IF NOT EXISTS bdp2;

USE	bdp2;

-- CREACION DE LAS TABLAS
CREATE TABLE IF NOT EXISTS carrera (
	id INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(40) NOT NULL
) AUTO_INCREMENT = 0;

CREATE TABLE IF NOT EXISTS transaccion(
	id INT AUTO_INCREMENT PRIMARY KEY,
	fecha DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	descripcion VARCHAR(50) NOT NULL,
	tipo VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS docente(
	siif BIGINT PRIMARY KEY,
	dpi BIGINT NOT NULL UNIQUE,
	nombres VARCHAR(40) NOT NULL,
	apellidos VARCHAR(40) NOT NULL,
	fecha_nacimiento DATE NOT NULL,
	correo VARCHAR(40) NOT NULL UNIQUE,
	telefono INT NOT NULL,
	direccion VARCHAR(40) NOT NULL,
	fecha_registro DATE NOT NULL 
);

CREATE TABLE IF NOT EXISTS estudiante(
	carnet BIGINT PRIMARY KEY,
	nombres VARCHAR(40) NOT NULL,
	apellidos VARCHAR(40) NOT NULL,
	fecha_nacimiento DATE NOT NULL,
	correo VARCHAR(40) NOT NULL UNIQUE,
	telefono INT NOT NULL,
	direccion VARCHAR(40) NOT NULL,
	dpi BIGINT NOT NULL UNIQUE,
	creditos INT NOT NULL DEFAULT 0,
	fecha_registro DATE NOT NULL,
	carrera INT NOT NULL,
	FOREIGN KEY (carrera) REFERENCES carrera(id)
);

CREATE TABLE IF NOT EXISTS curso(
	codigo INT PRIMARY KEY,
	nombre VARCHAR(30) NOT NULL,
	creditos_necesarios INT NOT NULL DEFAULT 0,
	creditos_otorgados INT NOT NULL,
	obligatorio TINYINT(1),
	carrera INT NOT NULL,
	FOREIGN KEY (carrera) REFERENCES carrera(id)
);

CREATE TABLE IF NOT EXISTS curso_ciclo(
	id INT AUTO_INCREMENT PRIMARY KEY,
	ciclo VARCHAR(2) NOT NULL,
	seccion VARCHAR(1) NOT NULL,
	curso INT NOT NULL,
	FOREIGN KEY (curso) REFERENCES curso(codigo)
);

CREATE TABLE IF NOT EXISTS curso_catedratico(
	id INT PRIMARY KEY AUTO_INCREMENT,
	docente BIGINT NOT NULL,
	curso_ciclo INT NOT NULL,
	FOREIGN KEY (docente) REFERENCES docente(siif),
	FOREIGN KEY (curso_ciclo) REFERENCES curso_ciclo(id)
);

CREATE TABLE IF NOT EXISTS curso_habilitado(
	id INT AUTO_INCREMENT PRIMARY KEY,
	cupo INT NOT NULL,
	anio INT NOT NULL,
	asignados INT NOT NULL DEFAULT 0,
	curso_catedratico INT NOT NULL,
	FOREIGN KEY (curso_catedratico) REFERENCES curso_catedratico(id)
);

CREATE TABLE IF NOT EXISTS horario(
	id INT AUTO_INCREMENT PRIMARY KEY,
	dia INT NOT NULL,
	horario VARCHAR(20) NOT NULL, 
	curso_habilitado INT NOT NULL,
	FOREIGN KEY (curso_habilitado) REFERENCES curso_habilitado(id)
);

CREATE TABLE IF NOT EXISTS asignacion(
	id INT AUTO_INCREMENT PRIMARY KEY,
	anio INT NOT NULL,
	curso_ciclo INT NOT NULL, 
	estudiante BIGINT NOT NULL,
	FOREIGN KEY (curso_ciclo) REFERENCES curso_ciclo(id),
	FOREIGN KEY (estudiante) REFERENCES estudiante(carnet)
);

CREATE TABLE IF NOT EXISTS desasignacion(
	id INT AUTO_INCREMENT PRIMARY KEY,
	anio INT NOT NULL,
	curso_ciclo INT NOT NULL, 
	estudiante BIGINT NOT NULL,
	FOREIGN KEY (curso_ciclo) REFERENCES curso_ciclo(id),
	FOREIGN KEY (estudiante) REFERENCES estudiante(carnet)
);

CREATE TABLE IF NOT EXISTS nota(
	id INT AUTO_INCREMENT PRIMARY KEY,
	nota INT NOT NULL, 
	anio INT NOT NULL,
	curso_ciclo INT NOT NULL,
	estudiante BIGINT NOT NULL,
	FOREIGN KEY (curso_ciclo) REFERENCES curso_ciclo(id),
	FOREIGN KEY (estudiante) REFERENCES estudiante(carnet)
);

CREATE TABLE IF NOT EXISTS acta(
	id INT AUTO_INCREMENT PRIMARY KEY,
	anio INT NOT NULL,
	curso_ciclo INT NOT NULL,
	FOREIGN KEY (curso_ciclo) REFERENCES curso_ciclo(id)
);