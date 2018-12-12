-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 12-12-2018 a las 06:58:07
-- Versión del servidor: 10.1.24-MariaDB
-- Versión de PHP: 7.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `dbtiendacomercial`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `almacen`
--

CREATE TABLE `almacen` (
  `idalmacen` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `almacen`
--

INSERT INTO `almacen` (`idalmacen`, `nombre`, `estado`) VALUES
(1, 'Almacen General', 1),
(2, 'Punto Venta', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `idcategoria` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(256) DEFAULT NULL,
  `condicion` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`idcategoria`, `nombre`, `descripcion`, `condicion`) VALUES
(1, '-', '-', 1),
(2, 'Pantoles Nacionales', 'De origen Nacional', 1),
(3, 'Camisas', 'Prenda para ocasiones o compromisos formales', 1),
(4, 'POLOS', 'Polos de verano para dama y caballeros', 1),
(5, 'BLUSAS', 'Para damas', 1),
(6, 'CASACAS', 'Abrigos para invierno', 1),
(7, 'PANTALONES IMPORTADOS', 'De origen Internacional', 1),
(8, 'RAMERAS', 'Para la temporada del verano', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_ingreso`
--

CREATE TABLE `detalle_ingreso` (
  `iddetalle_ingreso` int(11) NOT NULL,
  `idingreso` int(11) NOT NULL,
  `idproducto` int(11) NOT NULL,
  `idalmacen` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `importe` decimal(11,2) NOT NULL,
  `precio_compra` decimal(11,2) NOT NULL,
  `precio_venta` decimal(11,2) NOT NULL,
  `gananciaporcentaje` int(11) NOT NULL,
  `ganancianeta` decimal(11,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `detalle_ingreso`
--

INSERT INTO `detalle_ingreso` (`iddetalle_ingreso`, `idingreso`, `idproducto`, `idalmacen`, `cantidad`, `importe`, `precio_compra`, `precio_venta`, `gananciaporcentaje`, `ganancianeta`) VALUES
(1, 1, 1, 1, 5, '100.00', '20.00', '40.00', 100, '20.00'),
(2, 1, 2, 1, 10, '500.00', '50.00', '100.00', 100, '50.00'),
(3, 1, 3, 1, 11, '770.00', '70.00', '140.00', 100, '70.00'),
(4, 1, 4, 1, 8, '800.00', '100.00', '200.00', 100, '100.00'),
(5, 2, 2, 2, 5, '100.00', '20.00', '40.00', 100, '20.00'),
(6, 2, 3, 2, 7, '105.00', '15.00', '30.00', 100, '15.00'),
(7, 2, 4, 2, 11, '220.00', '20.00', '40.00', 100, '20.00'),
(8, 2, 6, 2, 13, '195.00', '15.00', '30.00', 100, '15.00'),
(9, 3, 1, 1, 5, '100.00', '20.00', '40.00', 100, '20.00');

--
-- Disparadores `detalle_ingreso`
--
DELIMITER $$
CREATE TRIGGER `tr_updStockIngreso` AFTER INSERT ON `detalle_ingreso` FOR EACH ROW UPDATE producto_ubicacion SET stock = stock + NEW.cantidad
    WHERE producto_ubicacion.idproducto = NEW.idproducto 
    AND producto_ubicacion.idalmacen = NEW.idalmacen
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_transferencia`
--

CREATE TABLE `detalle_transferencia` (
  `iddetalle_transferencia` int(11) NOT NULL,
  `idtransferencia` int(11) NOT NULL,
  `codigo` varchar(25) NOT NULL,
  `idproducto` int(11) NOT NULL,
  `idalmacen` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `detalle_transferencia`
--

INSERT INTO `detalle_transferencia` (`iddetalle_transferencia`, `idtransferencia`, `codigo`, `idproducto`, `idalmacen`, `cantidad`) VALUES
(1, 1, 'PR-002', 2, 1, 2),
(2, 2, 'PR-002', 2, 1, 3),
(3, 3, 'PR-003', 3, 1, 5),
(4, 4, 'PR-001', 1, 1, 2);

--
-- Disparadores `detalle_transferencia`
--
DELIMITER $$
CREATE TRIGGER `tr_updTraspasoProducto` BEFORE INSERT ON `detalle_transferencia` FOR EACH ROW UPDATE producto_ubicacion SET stock = stock - NEW.cantidad
    WHERE producto_ubicacion.idproducto = NEW.idproducto 
    AND producto_ubicacion.idalmacen = NEW.idalmacen
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_updTraspasoProductoMas` AFTER INSERT ON `detalle_transferencia` FOR EACH ROW UPDATE producto_ubicacion 
INNER JOIN transferencia tr
ON tr.idtransferencia = NEW.idtransferencia
SET stock = stock + NEW.cantidad
WHERE producto_ubicacion.idproducto = NEW.idproducto 
AND producto_ubicacion.idalmacen = tr.almacen_destino
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_venta`
--

CREATE TABLE `detalle_venta` (
  `iddetalle_venta` int(11) NOT NULL,
  `idventa` int(11) NOT NULL,
  `idproducto` int(11) NOT NULL,
  `idalmacen` int(11) NOT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `precio_venta` decimal(11,2) DEFAULT NULL,
  `descuento` decimal(11,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Disparadores `detalle_venta`
--
DELIMITER $$
CREATE TRIGGER `tr_updStockVenta` BEFORE INSERT ON `detalle_venta` FOR EACH ROW UPDATE producto_ubicacion SET stock = stock - NEW.cantidad
    WHERE producto_ubicacion.idproducto = NEW.idproducto 
    AND producto_ubicacion.idalmacen = NEW.idalmacen
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ingreso`
--

CREATE TABLE `ingreso` (
  `idingreso` int(11) NOT NULL,
  `idproveedor` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `tipo_comprobante` varchar(20) NOT NULL,
  `serie_comprobante` varchar(7) DEFAULT NULL,
  `num_comprobante` varchar(10) NOT NULL,
  `fecha_hora` datetime NOT NULL,
  `impuesto` decimal(4,2) NOT NULL,
  `total_compra` decimal(11,2) NOT NULL,
  `estado` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `ingreso`
--

INSERT INTO `ingreso` (`idingreso`, `idproveedor`, `idusuario`, `tipo_comprobante`, `serie_comprobante`, `num_comprobante`, `fecha_hora`, `impuesto`, `total_compra`, `estado`) VALUES
(1, 6, 12, 'Otros', '', '', '2018-12-11 00:00:00', '0.00', '2170.00', 'Aceptado'),
(2, 6, 12, 'Otros', '', '', '2018-12-11 00:00:00', '0.00', '620.00', 'Aceptado'),
(3, 6, 12, 'Otros', '', '', '2018-12-11 00:00:00', '0.00', '100.00', 'Aceptado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marca`
--

CREATE TABLE `marca` (
  `idmarca` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(250) NOT NULL,
  `condicion` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `marca`
--

INSERT INTO `marca` (`idmarca`, `nombre`, `descripcion`, `condicion`) VALUES
(1, '-', '-', 1),
(2, 'QUICKSILVER', 'Quiksilver, Inc. es una compañía estadounidense especializada en la elaboración de material y ropa de surf, skate y snowboard.', 1),
(3, 'NEWPORT', 'Marca de origen Nacional', 1),
(4, 'ADIDAS', 'Marca Americana de calidad', 1),
(5, 'JEANS', 'Marca Americana de calidad', 1),
(6, 'PIERS', 'Marca Americana de calidad', 1),
(7, 'BYLLABONG', 'Marca moderna y juvenil con nuevos estilos', 1),
(8, 'PIONIER', 'Marca clasica de alta textura y calidad', 1),
(9, 'DUNKENBOL', 'Marca internacional de calidad y textura moderna', 1),
(10, 'Sybila', 'Marca de ropa para mujer PERU', 1),
(14, 'Cordurois', 'Marca de privilegio en el peru', 1),
(15, 'perro', 'perro', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `nota_almacen`
--

CREATE TABLE `nota_almacen` (
  `idnota_almacen` int(11) NOT NULL,
  `idalmacen` int(11) NOT NULL,
  `idproducto` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `nota` text NOT NULL,
  `fecha_nota` date NOT NULL,
  `estado` varchar(25) NOT NULL,
  `fecha_interna` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `nota_almacen`
--

INSERT INTO `nota_almacen` (`idnota_almacen`, `idalmacen`, `idproducto`, `idusuario`, `nota`, `fecha_nota`, `estado`, `fecha_interna`) VALUES
(1, 1, 1, 12, 'Erro en el ingreso de este producto', '2018-12-11', 'Pendiente', '2018-12-11 23:50:55'),
(2, 2, 2, 12, 'MUY CAROS', '2018-12-12', 'Pendiente', '2018-12-12 00:08:55');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permiso`
--

CREATE TABLE `permiso` (
  `idpermiso` int(11) NOT NULL,
  `nombre` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `permiso`
--

INSERT INTO `permiso` (`idpermiso`, `nombre`) VALUES
(1, 'Inventarios'),
(2, 'Ventas'),
(3, 'Accesos'),
(4, 'Reportes'),
(5, 'Compras'),
(6, 'Escritorio');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `persona`
--

CREATE TABLE `persona` (
  `idpersona` int(11) NOT NULL,
  `tipo_persona` varchar(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `tipo_documento` varchar(20) DEFAULT NULL,
  `num_documento` varchar(20) DEFAULT NULL,
  `direccion` varchar(70) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `persona`
--

INSERT INTO `persona` (`idpersona`, `tipo_persona`, `nombre`, `tipo_documento`, `num_documento`, `direccion`, `telefono`, `email`) VALUES
(6, 'Proveedor', 'Proveedor Generico', NULL, NULL, 'Av Farmacos #154', '995478541', NULL),
(7, 'Cliente', 'Publico General', 'DNI', '47179801', '', '', ''),
(8, 'Proveedor', 'Proveedor ROPA GAMARRA', 'RUC', '', 'Av Gamarra', '991644777', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `idproducto` int(11) NOT NULL,
  `idcategoria` int(11) NOT NULL,
  `idmarca` int(11) NOT NULL,
  `idunidadmedida` int(11) NOT NULL,
  `idtipoproducto` int(11) NOT NULL,
  `codigo` varchar(50) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(256) DEFAULT NULL,
  `stock_max` int(11) DEFAULT NULL,
  `stock_min` int(11) DEFAULT NULL,
  `imagen` varchar(50) DEFAULT NULL,
  `condicion` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`idproducto`, `idcategoria`, `idmarca`, `idunidadmedida`, `idtipoproducto`, `codigo`, `nombre`, `descripcion`, `stock_max`, `stock_min`, `imagen`, `condicion`) VALUES
(1, 3, 3, 2, 2, 'PR-001', 'POLOS VERANEROS', 'POLOS PARA LA PLAYA', NULL, NULL, '1544057738.jpg', 1),
(2, 5, 3, 3, 2, 'PR-002', 'BLUSA DAMA', 'BLUSA DAMA NEW SILVER', NULL, NULL, '1544074330.jpg', 1),
(3, 3, 5, 4, 2, 'PR-003', 'Camisas Sport', 'Camisa para el verano', NULL, NULL, '1544203299.jpg', 1),
(4, 4, 6, 4, 2, 'PR-004', 'Polos de calle', 'Verano', NULL, NULL, '1544203514.jpg', 1),
(5, 4, 8, 4, 2, 'PR-005', 'Sudaderas', 'Mas ropa', NULL, NULL, '1544203598.png', 1),
(6, 4, 2, 6, 2, 'PR-006', 'RAMERAS DE VERANO', 'Ropa para verano', NULL, NULL, '1544203669.png', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto_ubicacion`
--

CREATE TABLE `producto_ubicacion` (
  `idproducto` int(11) DEFAULT NULL,
  `idalmacen` int(11) NOT NULL,
  `stock` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `producto_ubicacion`
--

INSERT INTO `producto_ubicacion` (`idproducto`, `idalmacen`, `stock`) VALUES
(1, 1, 8),
(2, 1, 5),
(3, 1, 6),
(4, 1, 8),
(2, 2, 10),
(3, 2, 12),
(4, 2, 11),
(6, 2, 13),
(1, 2, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipoproducto`
--

CREATE TABLE `tipoproducto` (
  `idtipoproducto` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(250) NOT NULL,
  `condicion` tinyint(4) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `tipoproducto`
--

INSERT INTO `tipoproducto` (`idtipoproducto`, `nombre`, `descripcion`, `condicion`) VALUES
(1, '-', '-', 1),
(2, 'Prendas', 'Toda clase de ropa entre marca y estilos, de lo ultimo a lo moderno', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `transferencia`
--

CREATE TABLE `transferencia` (
  `idtransferencia` int(11) NOT NULL,
  `almacen_origen` int(11) NOT NULL,
  `almacen_destino` int(11) NOT NULL,
  `fecha` datetime NOT NULL,
  `total_traspaso` int(11) NOT NULL,
  `observaciones` varchar(200) NOT NULL,
  `estado` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `transferencia`
--

INSERT INTO `transferencia` (`idtransferencia`, `almacen_origen`, `almacen_destino`, `fecha`, `total_traspaso`, `observaciones`, `estado`) VALUES
(1, 1, 2, '2018-12-11 00:00:00', 2, 'Observacion N1', 'Aceptado'),
(2, 1, 2, '2018-12-11 00:00:00', 3, 'Obser', 'Aceptado'),
(3, 1, 2, '2018-12-11 00:00:00', 5, 'Prioridad', 'Aceptado'),
(4, 1, 2, '2018-12-11 00:00:00', 2, 'Prioridad2', 'Aceptado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `unidadmedida`
--

CREATE TABLE `unidadmedida` (
  `idunidadmedida` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `tipo` varchar(50) NOT NULL,
  `abreviatura` varchar(20) NOT NULL,
  `descripcion` varchar(250) NOT NULL,
  `condicion` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `unidadmedida`
--

INSERT INTO `unidadmedida` (`idunidadmedida`, `nombre`, `tipo`, `abreviatura`, `descripcion`, `condicion`) VALUES
(1, '-', '-', '-', '-', 1),
(2, 'Extra XXL', 'Unidad Base', 'XXL', 'Talla extra grande para persona con fisionomia grande', 1),
(3, 'Largo', 'Unidad Base', 'L', 'Medida Larga, para persona de contextura delgada grande.', 1),
(4, 'Small', 'Unidad Base', 'S', 'Medida o Talla para personas pequeñas o de contextura delgada', 1),
(5, 'Extra Small', 'Unidad Base', 'XS', 'Extra o mas pequeño que Small', 1),
(6, 'Mediano', 'Unidad Base', 'M', 'Talla mediana para hombre y Mujer', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `idusuario` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `tipo_documento` varchar(20) NOT NULL,
  `num_documento` varchar(20) NOT NULL,
  `direccion` varchar(70) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `cargo` varchar(20) DEFAULT NULL,
  `login` varchar(20) NOT NULL,
  `clave` varchar(64) NOT NULL,
  `imagen` varchar(50) NOT NULL,
  `condicion` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`idusuario`, `nombre`, `tipo_documento`, `num_documento`, `direccion`, `telefono`, `email`, `cargo`, `login`, `clave`, `imagen`, `condicion`) VALUES
(12, 'Elite Administrador', 'DNI', '47179801', 'Av Alameda de Ñaña #1547', '991611444', 'Elitesystem@gmail.com', 'Administrador', 'admin', 'f4338838f175c3b4c0d4c59cf0083a3131407d03c64208b084c1e81e058cb4e0', '1541724180.png', 1),
(16, 'testeador', 'DNI', '48579857', 'Av La marina #154', '996874841', '', 'tester', 'tester', '9bba5c53a0545e0c80184b946153c9f58387e3bd1d4ee35740f29ac2e718b019', '1510256471.png', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_permiso`
--

CREATE TABLE `usuario_permiso` (
  `idusuario_permiso` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `idpermiso` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuario_permiso`
--

INSERT INTO `usuario_permiso` (`idusuario_permiso`, `idusuario`, `idpermiso`) VALUES
(231, 16, 1),
(232, 16, 2),
(233, 16, 4),
(234, 16, 5),
(235, 16, 6),
(248, 16, 3),
(249, 12, 1),
(250, 12, 2),
(251, 12, 3),
(252, 12, 4),
(253, 12, 5),
(254, 12, 6);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `venta`
--

CREATE TABLE `venta` (
  `idventa` int(11) NOT NULL,
  `idcliente` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `tipo_comprobante` varchar(20) NOT NULL,
  `serie_comprobante` varchar(7) DEFAULT NULL,
  `num_comprobante` varchar(10) NOT NULL,
  `fecha_hora` datetime NOT NULL,
  `impuesto` decimal(4,2) NOT NULL,
  `total_venta` decimal(11,2) NOT NULL,
  `estado` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `almacen`
--
ALTER TABLE `almacen`
  ADD PRIMARY KEY (`idalmacen`);

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`idcategoria`),
  ADD UNIQUE KEY `nombre_UNIQUE` (`nombre`);

--
-- Indices de la tabla `detalle_ingreso`
--
ALTER TABLE `detalle_ingreso`
  ADD PRIMARY KEY (`iddetalle_ingreso`),
  ADD KEY `fk_detalle_ingreso_ingreso1_idx` (`idingreso`),
  ADD KEY `fk_detalle_ingreso_producto1_idx` (`idproducto`),
  ADD KEY `fk_almacen_detalle_ingreso` (`idalmacen`);

--
-- Indices de la tabla `detalle_transferencia`
--
ALTER TABLE `detalle_transferencia`
  ADD PRIMARY KEY (`iddetalle_transferencia`),
  ADD KEY `fk_detalle_transf_idproducto` (`idproducto`),
  ADD KEY `fk_detalle_transf_idalmacen` (`idalmacen`),
  ADD KEY `fk_detalle_transf_idtrasferencia` (`idtransferencia`);

--
-- Indices de la tabla `detalle_venta`
--
ALTER TABLE `detalle_venta`
  ADD PRIMARY KEY (`iddetalle_venta`),
  ADD KEY `fk_detalle_venta_venta1_idx` (`idventa`),
  ADD KEY `fk_detalle_venta_producto1_idx` (`idproducto`),
  ADD KEY `fk_almacen_detalle_venta` (`idalmacen`);

--
-- Indices de la tabla `ingreso`
--
ALTER TABLE `ingreso`
  ADD PRIMARY KEY (`idingreso`),
  ADD KEY `fk_ingreso_persona1_idx` (`idproveedor`),
  ADD KEY `fk_ingreso_usuario1_idx` (`idusuario`);

--
-- Indices de la tabla `marca`
--
ALTER TABLE `marca`
  ADD PRIMARY KEY (`idmarca`);

--
-- Indices de la tabla `nota_almacen`
--
ALTER TABLE `nota_almacen`
  ADD PRIMARY KEY (`idnota_almacen`),
  ADD KEY `fk_idalmacen_notas` (`idalmacen`),
  ADD KEY `fk_idproductos_notas` (`idproducto`),
  ADD KEY `fk_usuario_notas` (`idusuario`);

--
-- Indices de la tabla `permiso`
--
ALTER TABLE `permiso`
  ADD PRIMARY KEY (`idpermiso`);

--
-- Indices de la tabla `persona`
--
ALTER TABLE `persona`
  ADD PRIMARY KEY (`idpersona`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`idproducto`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD KEY `fk_idcategoria` (`idcategoria`),
  ADD KEY `fk_idmarca` (`idmarca`),
  ADD KEY `fk_idunidadmedida` (`idunidadmedida`),
  ADD KEY `fk_idtipoproducto` (`idtipoproducto`);

--
-- Indices de la tabla `producto_ubicacion`
--
ALTER TABLE `producto_ubicacion`
  ADD KEY `fk_idalmacen` (`idalmacen`),
  ADD KEY `fk_idproducto` (`idproducto`);

--
-- Indices de la tabla `tipoproducto`
--
ALTER TABLE `tipoproducto`
  ADD PRIMARY KEY (`idtipoproducto`);

--
-- Indices de la tabla `transferencia`
--
ALTER TABLE `transferencia`
  ADD PRIMARY KEY (`idtransferencia`),
  ADD KEY `fk_almacen_destino` (`almacen_destino`),
  ADD KEY `fk_almacen_origen` (`almacen_origen`);

--
-- Indices de la tabla `unidadmedida`
--
ALTER TABLE `unidadmedida`
  ADD PRIMARY KEY (`idunidadmedida`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`idusuario`),
  ADD UNIQUE KEY `login` (`login`);

--
-- Indices de la tabla `usuario_permiso`
--
ALTER TABLE `usuario_permiso`
  ADD PRIMARY KEY (`idusuario_permiso`),
  ADD KEY `fk_usuario_permiso_permiso` (`idpermiso`),
  ADD KEY `fk_usuario_permiso_usuario` (`idusuario`);

--
-- Indices de la tabla `venta`
--
ALTER TABLE `venta`
  ADD PRIMARY KEY (`idventa`),
  ADD KEY `fk_venta_persona` (`idcliente`),
  ADD KEY `fk_venta_usuario` (`idusuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `almacen`
--
ALTER TABLE `almacen`
  MODIFY `idalmacen` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `idcategoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT de la tabla `detalle_ingreso`
--
ALTER TABLE `detalle_ingreso`
  MODIFY `iddetalle_ingreso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT de la tabla `detalle_transferencia`
--
ALTER TABLE `detalle_transferencia`
  MODIFY `iddetalle_transferencia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT de la tabla `detalle_venta`
--
ALTER TABLE `detalle_venta`
  MODIFY `iddetalle_venta` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `ingreso`
--
ALTER TABLE `ingreso`
  MODIFY `idingreso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT de la tabla `marca`
--
ALTER TABLE `marca`
  MODIFY `idmarca` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT de la tabla `nota_almacen`
--
ALTER TABLE `nota_almacen`
  MODIFY `idnota_almacen` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `permiso`
--
ALTER TABLE `permiso`
  MODIFY `idpermiso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT de la tabla `persona`
--
ALTER TABLE `persona`
  MODIFY `idpersona` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `idproducto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT de la tabla `tipoproducto`
--
ALTER TABLE `tipoproducto`
  MODIFY `idtipoproducto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `transferencia`
--
ALTER TABLE `transferencia`
  MODIFY `idtransferencia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT de la tabla `unidadmedida`
--
ALTER TABLE `unidadmedida`
  MODIFY `idunidadmedida` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idusuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT de la tabla `usuario_permiso`
--
ALTER TABLE `usuario_permiso`
  MODIFY `idusuario_permiso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=255;
--
-- AUTO_INCREMENT de la tabla `venta`
--
ALTER TABLE `venta`
  MODIFY `idventa` int(11) NOT NULL AUTO_INCREMENT;
--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalle_ingreso`
--
ALTER TABLE `detalle_ingreso`
  ADD CONSTRAINT `fk_almacen_detalle_ingreso` FOREIGN KEY (`idalmacen`) REFERENCES `almacen` (`idalmacen`),
  ADD CONSTRAINT `fk_detalle_ingreso_ingreso` FOREIGN KEY (`idingreso`) REFERENCES `ingreso` (`idingreso`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_ingreso_producto` FOREIGN KEY (`idproducto`) REFERENCES `producto` (`idproducto`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detalle_transferencia`
--
ALTER TABLE `detalle_transferencia`
  ADD CONSTRAINT `fk_detalle_transf_idalmacen` FOREIGN KEY (`idalmacen`) REFERENCES `producto_ubicacion` (`idalmacen`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_transf_idproducto` FOREIGN KEY (`idproducto`) REFERENCES `producto_ubicacion` (`idproducto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_transf_idtrasferencia` FOREIGN KEY (`idtransferencia`) REFERENCES `transferencia` (`idtransferencia`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detalle_venta`
--
ALTER TABLE `detalle_venta`
  ADD CONSTRAINT `fk_almacen_detalle_venta` FOREIGN KEY (`idalmacen`) REFERENCES `almacen` (`idalmacen`),
  ADD CONSTRAINT `fk_detalle_venta_producto` FOREIGN KEY (`idproducto`) REFERENCES `producto` (`idproducto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_venta_venta` FOREIGN KEY (`idventa`) REFERENCES `venta` (`idventa`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `ingreso`
--
ALTER TABLE `ingreso`
  ADD CONSTRAINT `fk_ingreso_persona` FOREIGN KEY (`idproveedor`) REFERENCES `persona` (`idpersona`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_ingreso_usuario` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `nota_almacen`
--
ALTER TABLE `nota_almacen`
  ADD CONSTRAINT `fk_idalmacen_notas` FOREIGN KEY (`idalmacen`) REFERENCES `almacen` (`idalmacen`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_idproductos_notas` FOREIGN KEY (`idproducto`) REFERENCES `producto` (`idproducto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_usuario_notas` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `producto`
--
ALTER TABLE `producto`
  ADD CONSTRAINT `fk_idcategoria` FOREIGN KEY (`idcategoria`) REFERENCES `categoria` (`idcategoria`),
  ADD CONSTRAINT `fk_idmarca` FOREIGN KEY (`idmarca`) REFERENCES `marca` (`idmarca`),
  ADD CONSTRAINT `fk_idtipoproducto` FOREIGN KEY (`idtipoproducto`) REFERENCES `tipoproducto` (`idtipoproducto`),
  ADD CONSTRAINT `fk_idunidadmedida` FOREIGN KEY (`idunidadmedida`) REFERENCES `unidadmedida` (`idunidadmedida`);

--
-- Filtros para la tabla `producto_ubicacion`
--
ALTER TABLE `producto_ubicacion`
  ADD CONSTRAINT `fk_idalmacen` FOREIGN KEY (`idalmacen`) REFERENCES `almacen` (`idalmacen`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_idproducto` FOREIGN KEY (`idproducto`) REFERENCES `producto` (`idproducto`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `transferencia`
--
ALTER TABLE `transferencia`
  ADD CONSTRAINT `fk_almacen_destino` FOREIGN KEY (`almacen_destino`) REFERENCES `producto_ubicacion` (`idalmacen`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_almacen_origen` FOREIGN KEY (`almacen_origen`) REFERENCES `producto_ubicacion` (`idalmacen`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `usuario_permiso`
--
ALTER TABLE `usuario_permiso`
  ADD CONSTRAINT `fk_usuario_permiso_permiso` FOREIGN KEY (`idpermiso`) REFERENCES `permiso` (`idpermiso`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_usuario_permiso_usuario` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `venta`
--
ALTER TABLE `venta`
  ADD CONSTRAINT `fk_venta_persona` FOREIGN KEY (`idcliente`) REFERENCES `persona` (`idpersona`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_venta_usuario` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
