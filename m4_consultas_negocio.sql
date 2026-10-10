USE Ventas_Tech_DB;

-- Consulta 1 — Resumen ejecutivo mensual 

SELECT
fecha_venta,
MONTH(fecha_venta) AS Mes,
SUM(precio_unitario*cantidad) AS Total_Facturado,
COUNT(*) AS Cantidad_Pedidos,
AVG(precio_unitario * cantidad) AS Ticket_Promedio
FROM ventas
GROUP BY(fecha_venta)
ORDER BY Mes;

-- Consulta 2 — Ranking de productos

SELECT TOP 5
id_producto,
SUM(cantidad) AS Unidades_Vendidas,
SUM(cantidad*precio_unitario) Total_Facturado
From ventas
GROUP BY id_producto
ORDER BY Total_Facturado DESC;

-- Consulta 3 — Clientes recurrentes
SELECT
id_cliente,
COUNT(*) AS Cantidad_Pedidos,
SUM(cantidad*precio_unitario) Total_Gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*)>1;

-- Consulta 4 — Meses por encima/por debajo del promedio
SELECT
MONTH(fecha_venta) as Mes,
SUM(cantidad*precio_unitario) AS Total_Facturado,
CASE
	WHEN SUM(cantidad*precio_unitario)>(
	SELECT AVG (Total_Facturado)
	FROM(
		SELECT 
		MONTH(fecha_venta) AS Mes,
		SUM (cantidad*precio_unitario) AS Total_Facturado
		FROM ventas
		GROUP BY MONTH(fecha_venta)
		) AS Resumen
	)
	THEN 'Por encima'
	ELSE 'Por debajo'
END AS Comparacion
FROM ventas
GROUP BY MONTH (fecha_venta)
ORDER BY Mes;


-- Comentarios:
-- 1) El producto 1 concentra la mayor facturacion con un ticket promedio de 2400, siendo el producto con mayor impacto en las ventas.
-- 2) El cliente 1 genera la mayor facturacion, con $2640.
-- 3) Los 5 clientes que mas realizaron pedidos lo hicieron con 2 pedidos cada uno, por lo que todos presentan un comportamiento recurrente.
