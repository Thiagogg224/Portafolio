-- 1. MOSTRAR NOMBRE TODOS LOS POKEMON --
SELECT nombre FROM pokemon;


-- 2. MOSTRAR LOS POKEMON QUE PESEN MENOS DE 10K --
SELECT nombre, peso FROM pokemon WHERE peso <= 10;

--  3. MOSTRAR LOS POKEMON DE TIPO AGUA --
SELECT p.nombre
FROM pokemon p
JOIN pokemon_tipo pt ON p.numero_pokedex = pt.numero_pokedex 
JOIN tipo t ON  pt.id_tipo = t.id_tipo
WHERE t.nombre = 'agua';

-- 3. MOSTRAR LOS POKEMON DE TIPO AGUA COMO SUBCONSULTA --
SELECT p.nombre
FROM pokemon p
WHERE p.numero_pokedex IN (
    SELECT pt.numero_pokedex
    FROM pokemon_tipo pt
    JOIN tipo t ON pt.id_tipo = t.id_tipo
    WHERE t.nombre = 'agua'
);


-- 4. MOSTRAR LOS POKEMON QUE SON TIPO FUEGO Y VOLADORES -- 
SELECT p.nombre 
FROM pokemon p 
JOIN pokemon_tipo  pt ON p.numero_pokedex = pt.numero_pokedex 
JOIN tipo t ON pt.id_tipo = t.id_tipo
WHERE t.nombre IN ('volador', 'fuego');



-- MOSTRAR LOS POKEMON QUE SON TANTO DE TIPO FUEGO COMO VOLADOR COMO SUBCONSULTA --
SELECT p.nombre
FROM pokemon p
WHERE p.numero_pokedex IN (
    SELECT pt1.numero_pokedex
    FROM pokemon_tipo pt1
    JOIN tipo t1 ON pt1.id_tipo = t1.id_tipo 
	WHERE t1.nombre = 'fuego'
    )
    AND p.numero_pokedex IN (
        SELECT pt2.numero_pokedex
        FROM pokemon_tipo pt2
        JOIN tipo t2 ON  pt2.id_tipo = t2.id_tipo
		WHERE t2.nombre = 'volador'
);



-- 5. POKEMON CON ESTADISTICA BASE DE PS MAYOR QUE 200 

SELECT p.nombre, eb.ps
FROM pokemon p 
JOIN estadisticas_base eb ON p.numero_pokedex = eb.numero_pokedex 
WHERE eb.ps >= 200;


-- 6. MOSTRAR NOMBRE, PESO, ALTURA  DE LA PREVOLUCION DE ARBOK -- 
SELECT p.nombre, p.peso, p.altura 
FROM pokemon p
JOIN evoluciona_de ev ON p.numero_pokedex = ev.pokemon_origen 
WHERE ev.pokemon_evolucionado = (SELECT numero_pokedex
								 FROM pokemon 
                                 WHERE nombre = 'arbok'
                                 );
                                 

-- 7. POKEMONS QUE EVOLUCIONAN  POR INTERCAMBIO --
SELECT p.nombre, te.tipo_evolucion 
FROM pokemon p 
JOIN pokemon_forma_evolucion pf ON p.numero_pokedex = pf.numero_pokedex 
JOIN forma_evolucion fe ON pf.id_forma_evolucion = fe.id_forma_evolucion 
JOIN tipo_evolucion te ON fe.tipo_evolucion = te.id_tipo_evolucion 
WHERE te.tipo_evolucion = 'intercambio'; 


-- 8. MOVIMIENTO CON MAS PRIORIDAD -- 
SELECT nombre, descripcion, prioridad
FROM movimiento 
WHERE prioridad = (SELECT MAX(prioridad)
				  FROM movimiento);
				  

-- 9. POKEMON MAS PESADO --

SELECT nombre, peso
FROM pokemon 
WHERE peso = (SELECT MAX(peso)
				  FROM pokemon);

-- 10. NOMBRE Y TIPO DE ATAQUE CON MAS POTENCIA -- 
SELECT m.nombre AS movimiento,  t.nombre AS tipo, m.potencia
FROM movimiento m
JOIN tipo t ON m.id_tipo = t.id_tipo
WHERE m.potencia = (SELECT MAX(potencia) FROM movimiento);


-- 11. NUMERO DE MOVIMIENTOS DE CADA TIPO -- 
SELECT t.nombre AS tipo, COUNT(*) AS num_movimiento
FROM tipo t 
JOIN movimiento m ON t.id_tipo = m.id_tipo 
GROUP BY t.nombre;

-- 12 TODOS LOS MOVIMIENTOS QUE PUEDAN ENVENENAR -- 
SELECT m.nombre, me.probabilidad, ef.efecto_secundario
FROM movimiento m
JOIN movimiento_efecto_secundario me ON m.id_movimiento = me.id_movimiento
JOIN efecto_secundario ef ON me.id_efecto_secundario = ef.id_efecto_secundario
WHERE ef.efecto_secundario = 'envenenamiento leve';


-- 13. TODOS LOS MOVIMIENTOS QUE APRENDE PIKACHU --
SELECT DISTINCT p.nombre , m.nombre AS nombre_movimiento 
FROM pokemon p 
JOIN pokemon_movimiento_forma pmf ON p.numero_pokedex = pmf.numero_pokedex
JOIN movimiento m ON pmf.id_movimiento = m.id_movimiento
WHERE p.nombre = 'pikachu';

-- 14. TODOS LOS MOVIMIENTOS QUE APRENDE PIKACHU POR MT --
SELECT DISTINCT m.nombre
FROM pokemon p 
JOIN pokemon_movimiento_forma pmf ON p.numero_pokedex = pmf.numero_pokedex
JOIN movimiento m ON pmf.id_movimiento = m.id_movimiento
JOIN forma_aprendizaje fa ON pmf.id_forma_aprendizaje = fa.id_forma_aprendizaje
JOIN tipo_forma_aprendizaje tfa ON fa.id_tipo_aprendizaje = tfa.id_tipo_aprendizaje
WHERE p.nombre = 'pikachu' AND tfa.tipo_aprendizaje = 'mt';


-- 15. MOVIMINETOS DE TIPO NORMAL QUE APRENDE PIKACHU POR NIVEL --
SELECT DISTINCT m.nombre, t.nombre AS tipo_ataque
FROM pokemon p 
JOIN pokemon_movimiento_forma pmf ON p.numero_pokedex = pmf.numero_pokedex
JOIN movimiento m ON pmf.id_movimiento = m.id_movimiento
JOIN forma_aprendizaje fa ON pmf.id_forma_aprendizaje = fa.id_forma_aprendizaje
JOIN tipo_forma_aprendizaje tfa ON fa.id_tipo_aprendizaje = tfa.id_tipo_aprendizaje
JOIN tipo t ON m.id_tipo = t.id_tipo
WHERE p.nombre = 'pikachu' AND tfa.tipo_aprendizaje = 'nivel' AND t.nombre = 'normal';
USE pokemondb;

-- 16. LOS POKEMON QUE EVOLUCIONAN POR PIEDRA, CREAR VISTA --
CREATE VIEW evo_piedra AS
SELECT p.nombre, te.tipo_evolucion 
FROM pokemon p 
JOIN pokemon_forma_evolucion pf ON p.numero_pokedex = pf.numero_pokedex 
JOIN forma_evolucion fe ON pf.id_forma_evolucion = fe.id_forma_evolucion 
JOIN tipo_evolucion te ON fe.tipo_evolucion = te.id_tipo_evolucion 
WHERE te.tipo_evolucion = 'piedra';

SELECT * FROM evo_piedra;


-- 17. LOS POKEMON QUE NO TIENEN EVOLUCIONAR, CREAR VISTA -- 
CREATE VIEW pokemon_no_evolucion AS
SELECT p.numero_pokedex, p.nombre 
FROM pokemon p 
JOIN evoluciona_de ev ON p.numero_pokedex = ev.pokemon_evolucionado
WHERE NOT EXISTS (SELECT pokemon_origen FROM evoluciona_de WHERE pokemon_origen = p.numero_pokedex)
UNION 
SELECT p.numero_pokedex, p.nombre 
FROM pokemon p 
WHERE NOT EXISTS (SELECT * FROM evoluciona_de WHERE pokemon_origen = p.numero_pokedex OR pokemon_evolucionado = p.numero_pokedex);


SELECT * FROM pokemon_no_evolucion;


-- 18. LOS POKEMON DE CADA TIPO, CREAR VISTA --
CREATE VIEW cantidad_tipo_pokemon AS 
 SELECT t.nombre AS tipo, COUNT(*) AS cantidad
 FROM pokemon p 
 JOIN pokemon_tipo pt ON p.numero_pokedex = pt.numero_pokedex 
 JOIN tipo t ON pt.id_tipo = t.id_tipo 
 GROUP BY t.nombre;
 
 SELECT * FROM cantidad_tipo_pokemon;
 






