-- Definir la BD a utilizar
USE Ventas_Tech_DB;

-- Seleccionar la tabla de hechos
SELECT * FROM ventas;

-- CONSULTA 1: VISTA BASE DEL PROYECTO (Añandir las columnas indicadas con INNER JOIN)
SELECT
vta.fecha_venta,
vta.id_cliente,
cli.nombre AS Nombre_Cliente,
cli.ciudad AS Ciudad_Cliente,
pro.nombre_producto,
cat.nombre_categoria,
vta.cantidad,
vta.precio_unitario,
vta.cantidad * vta.precio_unitario AS Total_Venta
FROM ventas AS vta 
INNER JOIN clientes cli 
	ON vta.id_cliente = cli.id_cliente
INNER JOIN productos AS pro 
	ON vta.id_producto = pro.id_producto
INNER JOIN categorias AS cat 
	ON pro.id_categoria = cat.id_categoria;

-- CONSULTA 2: CLIENTES SIN VENTAS (uso del LEFT JOIN): 
-- Indentificar que clientes no tuvieron ventas

SELECT
cli.nombre,
cli.email,
cli.fecha_registro
FROM  clientes AS cli
LEFT JOIN ventas AS vta
	ON cli.id_cliente = vta.id_cliente
WHERE vta.id_cliente is NULL;

-- Consulta 3 — Productos sin ventas (LEFT JOIN)
-- Identificar de la lista de productos no se vendieron

SELECT 
pro.nombre_producto,
pro.precio,
cat.nombre_categoria
FROM productos as pro
INNER JOIN categorias AS cat
	ON pro.id_categoria = cat.id_categoria
LEFT JOIN ventas AS vta
	ON pro.id_producto = vta.id_producto
WHERE vta.id_producto IS NULL;

-- CONSULTA 4: CONSOLIDADO POR CANAL (UNION ALL)
-- Creacion de consolidado por CANAL, como no tenemos definido un tipo de canal, se establece como primicia que
-- la categoria Computacion canal = Online y el resto de las categorias canal = presencial

WITH Ventas_Canal AS(

SELECT 
vta.fecha_venta,
vta.cantidad * vta.precio_unitario AS total,
'Online' AS canal
FROM ventas as vta
INNER JOIN productos AS pro
	ON vta.id_producto = pro.id_producto
INNER JOIN categorias AS cat
	ON pro.id_categoria = cat.id_categoria
WHERE cat.nombre_categoria = 'Computación'

UNION ALL

SELECT 
vta.fecha_venta,
vta.cantidad * vta.precio_unitario AS total,
'Presencial' AS canal
FROM ventas AS vta
INNER JOIN productos AS pro
	ON vta.id_producto = pro.id_producto
INNER JOIN categorias AS cat
	ON pro.id_categoria = cat.id_categoria
WHERE cat.nombre_categoria <> 'Computación'
)
SELECT 
	canal,
	SUM(total) AS Total_Facturado
	FROM Ventas_Canal
	GROUP BY canal;

