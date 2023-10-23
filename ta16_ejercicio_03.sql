/***********************************
******** TA16 - EJERCICIO 3 ********
***********************************/

USE actividades;


-- 3.1. Obtener todos los almacenes.

SELECT 
    *
FROM
    almacenes;


-- 3.2. Obtener todas las cajas cuyo contenido tenga un valor superior a 150 €.

SELECT 
    *
FROM
    cajas
WHERE
    VALOR > 150;


-- 3.3. Obtener los tipos de contenidos de las cajas.

SELECT DISTINCT
    CONTENIDO
FROM
    cajas;


-- 3.4. Obtener el valor medio de todas las cajas.

SELECT 
    AVG(VALOR) AS 'Valor medio total'
FROM
    cajas;


-- 3.5. Obtener el valor medio de las cajas de cada almacen.

SELECT 
    ALMACEN, AVG(VALOR) AS 'Valor medio'
FROM
    cajas
GROUP BY ALMACEN;


-- 3.6. Obtener los códigos de los almacenes en los cuales el valor medio de las cajas sea superior a 150€.

SELECT 
    ALMACEN, AVG(VALOR) AS 'Valor medio'
FROM
    cajas
GROUP BY ALMACEN
HAVING AVG(VALOR) > 150;


-- 3.7. Obtener el numero de referencia de cada caja junto con el nombre de la ciudad en el que se encuentra.

SELECT 
    NUMREFERENCIA, LUGAR AS 'Nombre ciudad'
FROM
    almacenes AS a
        JOIN
    cajas AS c ON a.CODIGO = c.ALMACEN
WHERE
    a.CODIGO = c.ALMACEN;


-- 3.8. Obtener el numero de cajas que hay en cada almacén.
SELECT 
    ALMACEN, COUNT(*) AS 'Total cajas'
FROM
    cajas
GROUP BY ALMACEN;


-- 3.9. Obtener los codigos de los almacenes que estan saturados (los almacenes donde el numero de cajas es superior a la capacidad).

SELECT 
    CODIGO
FROM
    almacenes
WHERE
    CAPACIDAD < (SELECT 
            COUNT(*)
        FROM
            cajas
        WHERE
            ALMACEN = CODIGO);


-- 3.10. Obtener los numeras de referencia de las cajas que estan en Bilbao.

SELECT 
    NUMREFERENCIA
FROM
    cajas
WHERE
    ALMACEN IN (SELECT 
            CODIGO
        FROM
            almacenes
        WHERE
            LUGAR = 'Bilbao');


-- 3.11. Insertar un nuevo almacén en Barcelona con capacidad para 3 cajas.

SET @newCodigo = (SELECT DISTINCT MAX(CODIGO) FROM almacenes) + 1;
INSERT INTO almacenes(CODIGO, LUGAR, CAPACIDAD) VALUES(@newCodigo, 'Barcelona', 3);


-- 3.12. Insertar una nueva caja, con número de referencia 'HS5RT', con contenido 'Papel', valor 200, y situada en el almacén 2.

INSERT INTO cajas VALUES('H5RT', 'Papel', 200, 2);


-- 3.13. Rebajar el valor de todas las cajas un 15 %.

CREATE TEMPORARY TABLE tempo_cajas AS
SELECT NUMREFERENCIA FROM cajas;

UPDATE cajas 
SET 
    VALOR = VALOR * 0.85
WHERE
    NUMREFERENCIA IN (SELECT 
            NUMREFERENCIA
        FROM
            tempo_cajas);


-- 3.14. Rebajar un 20% el valor de todas las cajas cuyo valor sea superior al valor medio de todas las cajas.

SET @valor_medio = (SELECT AVG(VALOR) FROM cajas);

UPDATE cajas
        JOIN
    (SELECT 
        NUMREFERENCIA
    FROM
        cajas
    WHERE
        VALOR > @valor_medio) AS c2 ON cajas.NUMREFERENCIA = c2.NUMREFERENCIA 
SET 
    VALOR = VALOR * 0.8;


-- 3.15. Eliminar todas las cajas cuyo valor sea inferior a 100 €.

CREATE TEMPORARY TABLE tempo_deleteCajas AS
SELECT NUMREFERENCIA FROM cajas where VALOR < 100;

DELETE FROM cajas 
WHERE
    NUMREFERENCIA IN (SELECT 
        NUMREFERENCIA
    FROM
        tempo_deleteCajas);


-- 3.16. Vaciar el contenido de los almacenes que estén saturados.

DROP TABLE IF EXISTS tempo_deleteCajas;

CREATE TEMPORARY TABLE tempo_deleteCajas AS
SELECT NUMREFERENCIA FROM cajas where ALMACEN IN (SELECT 
    CODIGO
FROM
    almacenes
WHERE
    CAPACIDAD < (SELECT 
            COUNT(*)
        FROM
            cajas
        WHERE
            ALMACEN = CODIGO));

DELETE FROM cajas 
WHERE
    NUMREFERENCIA IN (SELECT 
        NUMREFERENCIA
    FROM
        tempo_deleteCajas);