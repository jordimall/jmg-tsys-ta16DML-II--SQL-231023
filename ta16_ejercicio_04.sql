/***********************************
******** TA16 - EJERCICIO 3 ********
***********************************/

USE actividades;


-- 4.1. Mostrar el nombre de todas las peliculas.

SELECT 
    NOMBRE
FROM
    peliculas;


-- 4.2. Mostrar las distintas calificaciones de edad que existen.

SELECT DISTINCT
    CALIFICACIONEDAD AS 'Calificaciones de edad'
FROM
    peliculas
WHERE
    CALIFICACIONEDAD IS NOT NULL;


-- 4.3. Mostrar todas las peliculas que no han sido calificadas.

SELECT 
    *
FROM
    peliculas
WHERE
    CALIFICACIONEDAD IS NULL;


-- 4.4. Mostrar todas las salas que no proyectan ninguna pelicula.
SELECT 
    NOMBRE
FROM
    salas
WHERE
    PELICULA IS NULL;


-- 4.5. Mostrar la informacion de todas las salas y, si se proyecta alguna pelicula en la sala, mostrar también a informacion de la pelicula.

SELECT 
    *
FROM
    salas AS s
        LEFT JOIN
    peliculas AS p ON s.PELICULA = p.CODIGO;


-- 4.6. Mostrar la información de todas las películas y, si se proyecta en alguna sala, mostrar también la información de la sala.

SELECT 
    *
FROM
    salas AS s
        RIGHT JOIN
    peliculas AS p ON s.PELICULA = p.CODIGO;


-- 4.7. Mostrar los nombres de las peliculas que no se proyectan en ninguna sala.

SELECT 
    NOMBRE
FROM
    peliculas
WHERE
    CODIGO NOT IN (SELECT 
            PELICULA
        FROM
            salas
        WHERE
            PELICULA IS NOT NULL);


-- 4.8. Añadir una nueva pelicula 'Uno, Dos, Tres', para mayores de 7 años.

SET @newCodigo = (SELECT DISTINCT MAX(CODIGO) FROM peliculas) + 1;
INSERT INTO peliculas(CODIGO, NOMBRE,CALIFICACIONEDAD) VALUES(@newCodigo, 'Uno, Dos, Tres', 'NC-7');


-- 4.9. Hacer constar que todas las películas no calificadas han sido calificadas 'no recomendables para menores de 13 años'.

UPDATE peliculas AS p
        JOIN
    (SELECT 
        CODIGO
    FROM
        peliculas
    WHERE
        CALIFICACIONEDAD IS NULL) AS p2 ON p.CODIGO = p2.CODIGO 
SET 
    CALIFICACIONEDAD = 13;


-- 4.10. Eliminar todas las salas que proyectan peliculas recomendadas para todos los públicos.

DELETE FROM salas 
WHERE
    PELICULA IN (SELECT 
        CODIGO
    FROM
        peliculas
    
    WHERE
        CALIFICACIONEDAD = 'PG');