CREATE DATABASE act_02;
USE act_02;

-- 1. Esquema

CREATE TABLE desarrolladora (
idDes char(3) PRIMARY KEY NOT NULL,
nombreDes varchar(50) NOT NULL,
pais varchar(50) NOT NULL,
CHECK (char_length(idDes)=3)
);

CREATE TABLE juego (
idJue char(3) PRIMARY KEY NOT NULL,
nombreJue varchar(50) UNIQUE NOT NULL,
pegi int NOT NULL,
idDes char(3) NOT NULL,
CHECK (pegi in (3,7,12,16,18)),
FOREIGN KEY (idDes) REFERENCES desarrolladora(idDes),
CHECK (char_length(idJue)=3)
);

CREATE TABLE cp (
idcp char(5) PRIMARY KEY NOT NULL,
ciudad varchar(50) NOT NULL,
provincia varchar(50) NOT NULL,
CHECK (char_length(idcp)=5)
);

CREATE TABLE jugador (
idJug char(3) PRIMARY KEY NOT NULL,
nombreJug varchar(50) NOT NULL,
direccionJug varchar(50) NOT NULL,
cp char(5) NOT NULL,
FOREIGN KEY (cp) REFERENCES cp(idcp),
tlfJug char(9) NOT NULL,
CHECK (char_length(tlfJug)=9 AND char_length(idJug)=3)
);

CREATE TABLE tipoCompeticion (
idTipo char(3) PRIMARY KEY NOT NULL,
nombreTipo varchar(9) NOT NULL,
CHECK (idTipo in ('LOC','REG','NAC','MUN'))
);

CREATE TABLE juez (
idJuez char(4) PRIMARY KEY NOT NULL,
nombreJuez varchar(30) NOT NULL,
CHECK (char_length(idJuez)=4)
);

CREATE TABLE competicion (
idCom char(3) PRIMARY KEY NOT NULL,
nombreCom varchar(50) NOT NULL,
idTipo char(3) NOT NULL,
cp char(5) NOT NULL,
FOREIGN KEY (idTipo) REFERENCES tipoCompeticion(idTipo),
FOREIGN KEY (cp) REFERENCES cp(idcp),
fecha char(10) NOT NULL,
importeIns float NOT NULL DEFAULT 0,
CHECK (importeIns >= 0 AND char_length(idCom)=3 AND char_length(fecha)=10),
idJuez char(4) NOT NULL,
FOREIGN KEY (idJuez) REFERENCES juez(idJuez)
);

CREATE TABLE inscripcion (
idCom char(3) NOT NULL,
idJug char(3) NOT NULL,
FOREIGN KEY (idJug) REFERENCES jugador(idJug),
FOREIGN KEY (idCom) REFERENCES competicion(idCom),
fechaInsc char(10) NOT NULL,
CHECK (char_length(fechaInsc)=10)
);

-- 2. Inserción de valores

INSERT INTO desarrolladora(idDes,nombreDes,pais)
VALUES
('NIN','Nintendo','Japón'),
('MOJ','Mojang Studios','Japón'),
('ROB','Roblox CO','Estados Unidos'),
('WOL','Wolvesville CO','Alemania'),
('DIS','Disney','Canadá');

INSERT INTO juego(idJue,nombreJue,pegi,idDes)
VALUES
('J01','Mario Bross',3,'NIN'),
('J02','Minecraft',7,'MOJ'),
('J03','Roblox',7,'ROB'),
('J04','Wolvesville',12,'WOL'),
('J05','Club Penguin',16,'DIS');

INSERT INTO cp(idcp,ciudad,provincia)
VALUES
('41110','Bollullos de la Mitación','Sevilla'),
('33150','Cudillero','Asturias'),
('29400','Ronda','Málaga'),
('23470','Cazorla','Jaén'),
('10480','Valverde de la Vera','Cáceres');

INSERT INTO jugador(idJug,nombreJug,direccionJug,cp,tlfJug)
VALUES
('001','Sandro Salas','Calle Carámbola 20','41110','657893222'),
('002','Carmen Witsman','Calle Angelsoni 3','29400','695432878'),
('003','Marta Franca','Calle Pisalobos 15','23470','722454398'),
('004','Armando Casas','Calle Coquito 6','33150','656894209'),
('005','Taché García','Calle Don Limpio 11','10480','627554213'),
('006','Odie Lita','Calle Soleado 9','23470','698775632'),
('007','Millie Bobby','Calle Strangers 44','41110','655983421');

INSERT INTO tipoCompeticion(idTipo,nombreTipo)
VALUES
('LOC','Local'),
('REG','Regional'),
('NAC','Nacional'),
('MUN','Municipal');

INSERT INTO juez(idJuez,nombreJuez)
VALUES
('JZ01','Tini Stoessel'),
('JZ02','Enrique Iglesias'),
('JZ03','Domingo Bueno'),
('JZ04','Eren Yeager'),
('JZ05','Francisca Salas'),
('JZ06','Ester Ackerman'),
('JZ07','Tomás Reiner'),
('JZ08','Paula Campos');

INSERT INTO competicion(idCom,nombreCom,idTipo,cp,fecha,importeIns,idJuez)
VALUES
('C01','Picar diamantes','LOC','23470','10-12-2024',40,'JZ01'),
('C02','Parkour extremo','REG','10480','30-07-2025',7,'JZ07'),
('C03','Decoración de iglús','MUN','41110','01-01-2025',10,'JZ02'),
('C04','La aldea duerme','MUN','10480','09-09-2025',3,'JZ05'),
('C05','Wii','NAC','33150','06-02-2025',0,'JZ03'),
('C06','Ping Pong','REG','23470','07-03-2025',3,'JZ07'),
('C07','Juego de Sillas','NAC','41110','28-07-2025',0,'JZ02'),
('C08','Batalla de gallos','LOC','10480','04-08-2025',5,'JZ04');

INSERT INTO inscripcion(idCom,idJug,fechaInsc)
VALUES
('C01','002','23-10-2024'),
('C02','006','04-12-2024'),
('C05','002','23-10-2024'),
('C03','001','22-09-2024'),
('C03','005','01-12-2024'),
('C04','006','01-08-2025'),
('C02','003','02-02-2025'),
('C08','001','04-12-2025'),
('C07','002','01-07-2025');

-- 1. Mostramos inscripciones de jugadores, jueces arbitrando y competiciones

SELECT * FROM inscripcion;
SELECT * FROM competicion;

-- 3. Actualizar precio de inscripción +5% en todas las competiciones

UPDATE competicion
SET importeIns = 1.05 * importeIns;
SELECT * FROM competicion;

-- 4. Consultas

-- 4.1. Jugador competidor, competicion, tipo, por tipo descendente

SELECT jugador.nombreJug, competicion.nombreCom, tipocompeticion.nombreTipo
FROM inscripcion, competicion, jugador, tipocompeticion
WHERE inscripcion.idCom = competicion.idCom 
	AND inscripcion.idJug = jugador.idJug 
	AND competicion.idTipo = tipocompeticion.idTipo
ORDER BY tipocompeticion.idTipo DESC;

-- 4.2. Precio inscripción + alto en cada tipo de competición, importe medio

SELECT idTipo, max(importeIns) AS precioMásAlto, avg(importeIns) AS precioMedio
FROM competicion
GROUP BY idTipo
ORDER BY precioMásAlto DESC;

-- 4.3. Ciudades y provincias con competiciones nacionales o municipales

SELECT ciudad, provincia
FROM
(SELECT cp.ciudad AS ciudad, cp.provincia AS provincia, tipocompeticion.nombreTipo AS tipo
FROM cp, competicion, tipocompeticion
WHERE cp.idcp = competicion.cp
	AND tipocompeticion.idTipo = competicion.idTipo) AS tabla1
WHERE tipo = 'Nacional' OR tipo = 'Municipal'
GROUP BY ciudad, provincia;

-- 4.4. Ciudades y provincias con competiciones nacionales y municipales

SELECT ciudad, provincia
FROM
(SELECT cp.ciudad AS ciudad, cp.provincia AS provincia, tipocompeticion.nombreTipo AS tipo
FROM cp, competicion, tipocompeticion
WHERE cp.idcp = competicion.cp
	AND tipocompeticion.idTipo = competicion.idTipo) AS tabla1
GROUP BY ciudad, provincia
HAVING count(tipo) > 1
	AND sum(tipo = 'Nacional') > 0
    AND sum(tipo = 'Municipal') > 0;

-- 4.5. Ciudades y provincias con competiciones nacionales (no municipales)

SELECT ciudad, provincia
FROM
(SELECT cp.ciudad AS ciudad, cp.provincia AS provincia, tipocompeticion.nombreTipo AS tipo
FROM cp, competicion, tipocompeticion
WHERE cp.idcp = competicion.cp
	AND tipocompeticion.idTipo = competicion.idTipo) AS tabla1
GROUP BY ciudad, provincia
HAVING sum(tipo = 'Nacional') > 0
    AND sum(tipo = 'Municipal') = 0;
    
-- 4.6 Ciudades y provincias con competiciones municipales (no nacionales)

SELECT ciudad, provincia
FROM
(SELECT cp.ciudad AS ciudad, cp.provincia AS provincia, tipocompeticion.nombreTipo AS tipo
FROM cp, competicion, tipocompeticion
WHERE cp.idcp = competicion.cp
	AND tipocompeticion.idTipo = competicion.idTipo) AS tabla1
GROUP BY ciudad, provincia
HAVING sum(tipo = 'Nacional') = 0
    AND sum(tipo = 'Municipal') > 0;
    
-- 4.7. Importe de inscripción medio (>20) por tipo de competición

SELECT idTipo, avg(importeIns) AS precioMedio
FROM competicion
GROUP BY idTipo
HAVING precioMedio > 20;

-- 4.8. Suma de importes de jugadores competidores múltiples

SELECT idJug, count(idJug) AS numeroInscripciones, sum(importeIns) AS sumaImportes
FROM 
(SELECT inscripcion.idJug, competicion.importeIns
FROM inscripcion, competicion
WHERE inscripcion.idCom = competicion.idCom) AS tabla1
GROUP BY idJug
HAVING count(idJug) > 1;


-- 5. Vista con join, función de agregación y having

SELECT * FROM pago_clientes;

CREATE VIEW pago_clientes AS(
SELECT j.idJug AS id,
		j.nombreJug AS nombre,
		j.direccionJug AS direccion,
        j.tlfJug AS telefono,
        sum(c.importeIns) AS total_pagar
FROM jugador j, competicion c, inscripcion i
WHERE j.idJug = i.idJug AND
		i.idCom = c.idCom
GROUP BY j.idJug
HAVING sum(c.importeIns > 0)
);

SELECT * FROM pago_clientes;

-- 6. Procedimiento para hacer una inscripción en una competición

DELIMITER $$

CREATE PROCEDURE inscribir(IN v_nombreJug varchar(60),
							IN v_idJug char(3),
							IN v_direccion varchar(60),
                            IN v_cp char(5),
							IN v_tlfJug char(9),
							IN v_nombreCom varchar(60),
                            IN v_fechaIns char(10))
BEGIN
	DROP TEMPORARY TABLE IF EXISTS compe;
	CREATE TEMPORARY TABLE compe (
    idcompeticion char(3));
    
    INSERT INTO compe
    SELECT idCom
    FROM competicion
    WHERE v_nombreCom = nombreCom;
    
	-- La competición no existe
    IF NOT EXISTS (SELECT 1 FROM competicion WHERE v_nombreCom = competicion.nombreCom)
    THEN SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'La competición no existe';
    
    END IF;
    
    -- El jugador ya estaba inscrito
    IF EXISTS (SELECT  1 FROM compe c, inscripcion i
							WHERE v_idJug = i.idJug
                            AND i.idCom = c.idcompeticion)
	THEN SIGNAL SQLSTATE '45001'
    SET MESSAGE_TEXT = 'El jugador ya está inscrito en la competición';
    
    END IF;
    
    -- El jugador ya constaba en la base de datos
    
    IF EXISTS (SELECT 1 FROM jugador WHERE v_nombreJug = nombreJug
					AND v_idJug = idJug)
	THEN
	INSERT INTO inscripcion (idJug, idCom, fechaInsc)
	SELECT v_idjug, idcompeticion, v_fechaIns
	FROM compe;
    
	ELSE
    -- El jugador se inserta en la base de datos
	INSERT INTO jugador (idJug, nombreJug, direccionJug, cp, tlfJug)
	VALUES (v_idJug, v_nombreJug, v_direccion, v_cp, v_tlfJug);

	INSERT INTO inscripcion (idJug, idCom, fechaIns)
	SELECT v_idJug, idcompeticion, v_fechaIns
	FROM compe;

    END IF;
    
END $$
DELIMITER ;

SELECT * FROM inscripcion;
CALL inscribir(
	'Carmen Witsman',
    '002',
    'Calle Angelsoni 3',
    '29400',
    '695432878',
    'Picar Diamantes',
    '10-11-2024');
    
    SELECT * FROM inscripcion;
    CALL inscribir(
	'Sandro Salas',
    '001',
    'Calle Carámbola 20',
    '41110',
    '657893222',
    'Wii',
    '11-11-2024');
    SELECT * FROM inscripcion;
    
    CALL inscribir(
	'Garbanzo Loco',
    '009',
    'Calle Guam 34',
    '41110',
    '698666547',
    'Parkour extremo',
    '22-10-2024');
    SELECT * FROM inscripcion;
    
-- 7. Función de importe recaudado por competición
DROP FUNCTION recaudado;
DELIMITER //
CREATE FUNCTION recaudado (v_competicion varchar(60)) RETURNS float
DETERMINISTIC
BEGIN
    RETURN (SELECT sum(importeIns) 
			FROM competicion
            WHERE v_competicion = competicion.nombreCom);
END //
DELIMITER ;

SELECT recaudado('Decoración de iglús');

-- 8. Triggers

-- 8.1. Trigger cada vez que inscriban (fecha, competicion, jugador, usuario)

-- Creamos la tabla inscripciones_log
CREATE TABLE inscripciones_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha_operacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_competicion CHAR(3),
    id_jugador CHAR(3),
    usuario_operacion VARCHAR(255)
);

-- Trigger
DELIMITER //
CREATE TRIGGER after_inscripcion_insert
AFTER INSERT ON inscripcion
FOR EACH ROW
BEGIN
    INSERT INTO inscripciones_log (id_competicion, id_jugador, usuario_operacion)
    VALUES (NEW.idCom, NEW.idJug, CURRENT_USER());
END //
DELIMITER ;

SELECT * FROM inscripciones_log;
CALL inscribir(
	'Carmen Witsman',
    '002',
    'Calle Angelsoni 3',
    '29400',
    '695432878',
    'Ping Pong',
    '10-11-2024');
SELECT * FROM inscripciones_log;

-- 8.2. Trigger que impide rebajar precio inscripciones

DELIMITER //
CREATE TRIGGER no_rebajar
BEFORE UPDATE ON competicion
FOR EACH ROW
BEGIN
	IF NEW.importeIns < OLD.importeIns
    THEN SIGNAL SQLSTATE '45009'
    SET MESSAGE_TEXT = 'No se puede rebajar el importe de la inscripción';
    END IF;
END //
DELIMITER ;

UPDATE competicion 
SET importeIns = 0.95 * importeIns;
SELECT * FROM competicion;

-- 9. Procedimiento con cursor, operaciones que combinen dos o más tablas y actualización de una tabla. 

CREATE TABLE resumenProvincia (
    provincia VARCHAR(50) PRIMARY KEY,
    totalCompeticiones INT,
    totalJugadores INT,
    precioMedio FLOAT
);

DELIMITER //
CREATE PROCEDURE informacion_competicion_provincia(IN nombreProvincia VARCHAR(50))
BEGIN
    DECLARE v_idcp CHAR(5);
    DECLARE v_idCom CHAR(3);
    DECLARE v_numComp INT DEFAULT 0;
    DECLARE v_totalRecaudado FLOAT DEFAULT 0.0;
    DECLARE v_totalImporte FLOAT DEFAULT 0.0;
    DECLARE v_totalInscripciones INT DEFAULT 0;
    DECLARE done INT DEFAULT 0;
    
    -- Cursor para obtener los idcp de la provincia
    DECLARE cur1 CURSOR FOR 
        SELECT idcp 
        FROM cp 
        WHERE provincia = nombreProvincia;
    
    -- Cursor para recorrer las competiciones en la provincia
    DECLARE cur2 CURSOR FOR 
        SELECT idCom, importeIns
        FROM competicion
        WHERE cp = v_idcp;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Recorrer los códigos postales de la provincia
    OPEN cur1;
    
    read_cps: LOOP
        FETCH cur1 INTO v_idcp;
        IF done THEN
            LEAVE read_cps;
        END IF;
        
        -- Recorrer las competiciones en cada código postal
        OPEN cur2;
        read_comps: LOOP
            FETCH cur2 INTO v_idCom, v_totalImporte;
            IF done THEN
                LEAVE read_comps;
            END IF;
            
            -- Contar competiciones
            SET v_numComp = v_numComp + 1;
            
            -- Calcular el total recaudado
            SET v_totalRecaudado = v_totalRecaudado + v_totalImporte;
            
            -- Contar las inscripciones
            SET v_totalInscripciones = v_totalInscripciones + 
                                       (SELECT COUNT(*) 
                                        FROM inscripcion
                                        WHERE idCom = v_idCom);
        END LOOP;
        CLOSE cur2;
    END LOOP;
    CLOSE cur1;
    
    -- Calcular el precio medio si hay competiciones
    IF v_numComp > 0 THEN
        SET v_totalImporte = v_totalRecaudado / v_numComp;
    ELSE
        SET v_totalImporte = 0.0;
    END IF;

    -- Insertar o actualizar la tabla resumenProvincia
    INSERT INTO resumenProvincia (provincia, totalCompeticiones, totalJugadores, precioMedio)
    VALUES (nombreProvincia, v_numComp, v_totalInscripciones, v_totalImporte)
    ON DUPLICATE KEY UPDATE
        totalCompeticiones = v_numComp,
        totalJugadores = v_totalInscripciones,
        precioMedio = v_totalImporte;
	-- Devolver los resultados finales 
	SELECT * FROM resumenProvincia WHERE provincia = nombreProvincia;
END //

DELIMITER ;

CALL informacion_competicion_provincia('Sevilla');