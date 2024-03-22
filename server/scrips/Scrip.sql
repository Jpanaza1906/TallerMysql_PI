//Crear Modelo
CREATE TABLE pais (id_pais INT PRIMARY KEY, nombre  VARCHAR(20) NOT NULL);
CREATE TABLE categoria (id_categoria INT PRIMARY KEY, nombre  VARCHAR(20) NOT NULL);
CREATE TABLE cliente (id_cliente INT PRIMARY KEY, nombre  VARCHAR(20) NOT NULL, apellido  VARCHAR(20) NOT NULL, id_pais INT, FOREIGN KEY (id_pais) REFERENCES pais(id_pais));
CREATE TABLE vendedor (id_vendedor INT PRIMARY KEY, nombre  VARCHAR(20) NOT NULL, id_pais INT, FOREIGN KEY (id_pais) REFERENCES pais(id_pais));
CREATE TABLE producto (id_producto INT PRIMARY KEY, nombre  VARCHAR(20) NOT NULL, precio DECIMAL(10,2) NOT NULL, id_categoria INT, FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria));
CREATE TABLE orden (id_orden INT PRIMARY KEY, fecha_orden DATE NOT NULL, id_cliente INT, FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente));
CREATE TABLE detalle_orden (id_orden INT NOT NULL,linea_orden INT NOT NULL,id_vendedor INT NOT NULL,id_producto INT NOT NULL,cantidad INT NOT NULL,PRIMARY KEY(id_orden,linea_orden),FOREIGN KEY (id_orden) REFERENCES orden(id_orden),FOREIGN KEY (id_vendedor) REFERENCES vendedor(id_vendedor),FOREIGN KEY (id_producto) REFERENCES producto(id_producto));

//Consulta 1
SELECT c.nombre, c.apellido, p.nombre,ROUND(SUM(pr.precio*d.cantidad),2) AS Monto, COUNT(c.id_cliente) as numeroveces 
FROM cliente c 
INNER JOIN pais p 
ON c.id_pais=p.id_pais 
INNER JOIN orden o
ON c.id_cliente=o.id_cliente
INNER JOIN detalle_orden d
ON o.id_orden = d.id_orden
INNER JOIN producto pr
ON d.id_producto = pr.id_producto
GROUP BY c.id_cliente
ORDER BY numeroveces DESC
LIMIT 1

//Consulta 2
(SELECT p.id_producto,p.nombre, c.nombre AS nombre_categoria, SUM(d.cantidad) AS cantidad_total, ROUND(SUM(p.precio*d.cantidad),2) AS monto
FROM detalle_orden d 
INNER JOIN producto p
ON d.id_producto = p.id_producto
INNER JOIN categoria c
ON p.id_categoria = c.id_categoria
GROUP BY p.id_producto
ORDER BY cantidad_total DESC
LIMIT 1)
UNION
(SELECT p.id_producto,p.nombre, c.nombre AS nombre_categoria, SUM(d.cantidad) AS cantidad_total, ROUND(SUM(p.precio*d.cantidad),2) AS monto
FROM detalle_orden d 
INNER JOIN producto p
ON d.id_producto = p.id_producto
INNER JOIN categoria c
ON p.id_categoria = c.id_categoria
GROUP BY p.id_producto
ORDER BY cantidad_total ASC
LIMIT 1)

//Consulta 3
SELECT v.id_vendedor,v.nombre, ROUND(SUM(p.precio*d.cantidad),2) AS monto, COUNT(d.id_vendedor) as numeroveces
FROM detalle_orden d 
INNER JOIN vendedor v
ON d.id_vendedor = v.id_vendedor 
INNER JOIN producto p
ON d.id_producto = p.id_producto
GROUP BY d.id_vendedor
ORDER BY monto DESC
LIMIT 1

//Consulta 4
(SELECT pa.id_pais, pa.nombre, ROUND(SUM(d.cantidad * p.precio),2) as Monto
FROM pais pa
INNER JOIN vendedor v
ON pa.id_pais = v.id_pais
INNER JOIN detalle_orden d
ON v.id_vendedor = d.id_vendedor
INNER JOIN producto p
ON d.id_producto = p.id_producto
GROUP BY pa.id_pais
ORDER BY SUM(d.cantidad) DESC
LIMIT 1)
UNION
(SELECT pa.id_pais, pa.nombre, ROUND(SUM(d.cantidad * p.precio),2) as Monto
FROM pais pa
INNER JOIN vendedor v
ON pa.id_pais = v.id_pais
INNER JOIN detalle_orden d
ON v.id_vendedor = d.id_vendedor
INNER JOIN producto p
ON d.id_producto = p.id_producto
GROUP BY pa.id_pais
ORDER BY SUM(d.cantidad) ASC
LIMIT 1);

//Consulta 5
SELECT pa.id_pais,pa.nombre, ROUND(SUM(p.precio*d.cantidad),2) AS monto
FROM detalle_orden d
INNER JOIN orden o
ON d.id_orden = o.id_orden 
INNER JOIN cliente c
ON o.id_cliente = c.id_cliente 
INNER JOIN pais pa
ON c.id_pais = pa.id_pais
INNER JOIN producto p
ON d.id_producto = p.id_producto
GROUP BY c.id_pais
ORDER BY monto
LIMIT 5;

//Consulta 6
(SELECT c.nombre, SUM(d.cantidad) as Cantidad
FROM categoria c
INNER JOIN producto p
ON c.id_categoria = p.id_categoria
INNER JOIN detalle_orden d
ON p.id_producto = d.id_producto
GROUP BY c.id_categoria
ORDER BY Cantidad DESC
LIMIT 1)
UNION
(SELECT c.nombre, SUM(d.cantidad) as Cantidad
FROM categoria c
INNER JOIN producto p
ON c.id_categoria = p.id_categoria
INNER JOIN detalle_orden d
ON p.id_producto = d.id_producto
GROUP BY c.id_categoria
ORDER BY Cantidad ASC
LIMIT 1);

//Consulta 7
SELECT Nombre_Pais, Nombre_Categoria, Cantidad
FROM (
    SELECT 
        Nombre_Pais, 
        Nombre_Categoria, 
        Cantidad,
        CASE WHEN @prev_pais = Nombre_Pais THEN @row_number := @row_number + 1 ELSE @row_number := 1 END AS rn,
        @prev_pais := Nombre_Pais AS dummy
    FROM (
        SELECT 
        pa.nombre AS Nombre_Pais, 
        c.nombre AS Nombre_Categoria, 
        SUM(d.cantidad) AS Cantidad
        FROM 
            pais pa
            INNER JOIN 
            cliente cl ON pa.id_pais = cl.id_pais
            INNER JOIN 
            orden o ON cl.id_cliente = o.id_cliente
            INNER JOIN 
            detalle_orden d ON o.id_orden = d.id_orden
            INNER JOIN 
            producto pr ON d.id_producto = pr.id_producto
            INNER JOIN 
            categoria c ON pr.id_categoria = c.id_categoria
            GROUP BY 
            pa.id_pais, c.id_categoria
            ORDER BY 
            pa.nombre, SUM(d.cantidad) DESC
            ) AS subquery,
            (SELECT @row_number := 0, @prev_pais := '') AS vars
            ) AS ranked
            WHERE rn = 1;

//Consulta 8
SELECT MONTH(o.fecha_orden) as Mes, ROUND(SUM(p.precio*d.cantidad),2) AS Monto
FROM orden o
INNER JOIN detalle_orden d
ON o.id_orden = d.id_orden
INNER JOIN producto p
ON d.id_producto = p.id_producto
INNER JOIN vendedor v
ON d.id_vendedor = v.id_vendedor
INNER JOIN pais pa
ON v.id_pais = pa.id_pais
WHERE pa.id_pais = 10
GROUP BY Mes;

//Consulta 9
(SELECT MONTH(o.fecha_orden) as Mes, ROUND(SUM(p.precio*d.cantidad),2) AS Monto
FROM orden o
INNER JOIN detalle_orden d
ON o.id_orden = d.id_orden
INNER JOIN producto p
ON d.id_producto = p.id_producto
INNER JOIN vendedor v
ON d.id_vendedor = v.id_vendedor
INNER JOIN pais pa
ON v.id_pais = pa.id_pais
GROUP BY Mes
ORDER BY Monto DESC
LIMIT 1)
UNION
(SELECT MONTH(o.fecha_orden) as Mes, ROUND(SUM(p.precio*d.cantidad),2) AS Monto
FROM orden o
INNER JOIN detalle_orden d
ON o.id_orden = d.id_orden
INNER JOIN producto p
ON d.id_producto = p.id_producto
INNER JOIN vendedor v
ON d.id_vendedor = v.id_vendedor
INNER JOIN pais pa
ON v.id_pais = pa.id_pais
GROUP BY Mes
ORDER BY Monto ASC
LIMIT 1);

//Consulta 10
SELECT p.id_producto, p.nombre, ROUND(SUM(p.precio*d.cantidad),2) AS monto
FROM producto p
INNER JOIN detalle_orden d
ON p.id_producto = d.id_producto
WHERE p.id_categoria = 15
GROUP BY p.id_producto