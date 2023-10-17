-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 17-10-2023 a las 05:58:54
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `almacen2`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertar_inventario` (IN `p_producto` VARCHAR(255), IN `p_cantidad` INT)   BEGIN
    INSERT INTO inventario (producto, cantidad)
    VALUES (p_producto, p_cantidad);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `entrada`
--

CREATE TABLE `entrada` (
  `id` int(11) NOT NULL,
  `producto_id` int(11) DEFAULT NULL,
  `cantidad` int(11) NOT NULL,
  `proveedor` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `entrada`
--

INSERT INTO `entrada` (`id`, `producto_id`, `cantidad`, `proveedor`) VALUES
(1, 1, 50, 'Proveedor 1'),
(2, 2, 10, 'Proveedor 2'),
(3, 3, 50, 'Proveedor 3'),
(4, 4, 60, 'Proveedor 4'),
(5, 5, 20, 'Proveedor 5'),
(6, 1, 20, NULL),
(7, 1, 20, NULL),
(8, 1, 20, NULL);

--
-- Disparadores `entrada`
--
DELIMITER $$
CREATE TRIGGER `tr_incrementar_inventario` AFTER INSERT ON `entrada` FOR EACH ROW BEGIN
    UPDATE inventario
    SET cantidad = cantidad + NEW.cantidad
    WHERE id = NEW.producto_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventario`
--

CREATE TABLE `inventario` (
  `id` int(11) NOT NULL,
  `producto` varchar(255) NOT NULL,
  `cantidad` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `inventario`
--

INSERT INTO `inventario` (`id`, `producto`, `cantidad`) VALUES
(1, 'Camisetas', 260),
(2, 'Zapatos deportivos', 90),
(3, 'Pantalones vaqueros', 170),
(4, 'Gorras', 260),
(5, 'Relojes', 70),
(6, 'Nuevo Producto', 50);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `productos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `productos` (
`producto_id` int(11)
,`nombre_producto` varchar(255)
,`cantidad_en_inventario` int(11)
,`cantidad_entrada` int(11)
,`proveedor` varchar(255)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `salida`
--

CREATE TABLE `salida` (
  `id` int(11) NOT NULL,
  `producto_id` int(11) DEFAULT NULL,
  `cantidad` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `salida`
--

INSERT INTO `salida` (`id`, `producto_id`, `cantidad`) VALUES
(1, 1, 20),
(2, 2, 15),
(3, 3, 10),
(4, 4, 30),
(5, 5, 5);

-- --------------------------------------------------------

--
-- Estructura para la vista `productos`
--
DROP TABLE IF EXISTS `productos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `productos`  AS SELECT `i`.`id` AS `producto_id`, `i`.`producto` AS `nombre_producto`, `i`.`cantidad` AS `cantidad_en_inventario`, `e`.`cantidad` AS `cantidad_entrada`, `e`.`proveedor` AS `proveedor` FROM (`inventario` `i` left join `entrada` `e` on(`i`.`id` = `e`.`producto_id`)) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `entrada`
--
ALTER TABLE `entrada`
  ADD PRIMARY KEY (`id`),
  ADD KEY `producto_id` (`producto_id`);

--
-- Indices de la tabla `inventario`
--
ALTER TABLE `inventario`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `salida`
--
ALTER TABLE `salida`
  ADD PRIMARY KEY (`id`),
  ADD KEY `producto_id` (`producto_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `entrada`
--
ALTER TABLE `entrada`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `inventario`
--
ALTER TABLE `inventario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `salida`
--
ALTER TABLE `salida`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `entrada`
--
ALTER TABLE `entrada`
  ADD CONSTRAINT `entrada_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `inventario` (`id`);

--
-- Filtros para la tabla `salida`
--
ALTER TABLE `salida`
  ADD CONSTRAINT `salida_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `inventario` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
