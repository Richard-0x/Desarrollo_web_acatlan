-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3307
-- Tiempo de generación: 24-04-2025 a las 02:59:07
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `ptar_acatlan`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `calidad_agua`
--

CREATE TABLE `calidad_agua` (
  `id` int(11) NOT NULL,
  `fecha_muestreo` datetime DEFAULT current_timestamp(),
  `punto_muestreo` varchar(50) NOT NULL COMMENT 'Ej: Entrada PTAR, Salida Reactor',
  `ph` decimal(3,1) NOT NULL CHECK (`ph` between 0 and 14),
  `turbidez` decimal(5,2) DEFAULT NULL COMMENT 'NTU',
  `oxigeno_disuelto` decimal(5,2) DEFAULT NULL COMMENT 'mg/L',
  `conductividad` decimal(6,2) DEFAULT NULL COMMENT 'µS/cm',
  `temperatura` decimal(4,1) DEFAULT NULL COMMENT '°C',
  `dbo5` decimal(6,2) DEFAULT NULL COMMENT 'Demanda Bioquímica de Oxígeno (mg/L)',
  `solidos_suspendidos` decimal(6,2) DEFAULT NULL COMMENT 'mg/L',
  `usuario_id` int(11) DEFAULT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `calidad_agua`
--

INSERT INTO `calidad_agua` (`id`, `fecha_muestreo`, `punto_muestreo`, `ph`, `turbidez`, `oxigeno_disuelto`, `conductividad`, `temperatura`, `dbo5`, `solidos_suspendidos`, `usuario_id`, `observaciones`) VALUES
(1, '2025-04-16 20:31:45', 'Entrada PTAR', 1.0, 1.00, 1.00, 2.00, 6.0, 5.30, 2.10, 1, 'favorable\r\n'),
(2, '2025-04-16 23:57:44', 'Entrada PTAR', 7.0, 1.00, 0.30, 0.00, 5.0, 0.33, 0.10, 1, 'echen agua ');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `flujos`
--

CREATE TABLE `flujos` (
  `id` int(11) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `nivel_inicial` decimal(10,2) NOT NULL COMMENT 'Nivel inicial (m)',
  `nivel_final` decimal(10,2) NOT NULL COMMENT 'Nivel final (m)',
  `diferencia_nivel` decimal(10,2) DEFAULT NULL COMMENT 'Diferencia (m)',
  `volumen_generado` decimal(10,2) DEFAULT NULL COMMENT 'Volumen (m³)',
  `tiempo_inicio` time NOT NULL,
  `tiempo_fin` time NOT NULL,
  `diferencia_tiempo_min` decimal(10,2) DEFAULT NULL COMMENT 'Diferencia (minutos)',
  `caudal_m3s` decimal(10,4) DEFAULT NULL COMMENT 'Caudal (m³/s)',
  `observaciones` text DEFAULT NULL,
  `usuario_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `flujos`
--

INSERT INTO `flujos` (`id`, `fecha`, `nivel_inicial`, `nivel_final`, `diferencia_nivel`, `volumen_generado`, `tiempo_inicio`, `tiempo_fin`, `diferencia_tiempo_min`, `caudal_m3s`, `observaciones`, `usuario_id`) VALUES
(1, '2025-04-16 19:47:41', 5.00, 2.00, 3.00, 54.00, '19:47:00', '08:48:00', -659.00, -0.0014, 'bien\r\n', 1),
(2, '2025-04-16 19:52:33', 12.00, 10.00, 2.00, 36.00, '19:52:00', '08:53:00', -659.00, -0.0009, 'niveles con condiciones favorables\r\n', 1),
(3, '2025-04-16 23:53:29', 0.02, 0.02, 0.00, 0.00, '23:52:00', '00:53:00', -1379.00, 0.0000, 'bien', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `incidentes`
--

CREATE TABLE `incidentes` (
  `id` int(11) NOT NULL,
  `titulo` varchar(100) NOT NULL COMMENT 'Ej: Fuga en reactor principal',
  `tipo` enum('Fuga','Falla eléctrica','Alerta de calidad','Equipo dañado','Seguridad','Otro') NOT NULL,
  `fecha_reporte` datetime DEFAULT current_timestamp(),
  `fecha_cierre` datetime DEFAULT NULL,
  `ubicacion` varchar(100) NOT NULL COMMENT 'Ej: Reactor 2, Sala de bombas',
  `descripcion` text NOT NULL,
  `severidad` enum('Baja','Media','Alta','Crítica') NOT NULL,
  `usuario_reporta_id` int(11) NOT NULL,
  `usuario_asignado_id` int(11) DEFAULT NULL,
  `estado` enum('Reportado','En revisión','En reparación','Resuelto','Cancelado') DEFAULT 'Reportado',
  `solucion` text DEFAULT NULL COMMENT 'Descripción de la solución aplicada',
  `evidencias` varchar(255) DEFAULT NULL COMMENT 'Ruta a fotos/PDFs'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `incidentes`
--

INSERT INTO `incidentes` (`id`, `titulo`, `tipo`, `fecha_reporte`, `fecha_cierre`, `ubicacion`, `descripcion`, `severidad`, `usuario_reporta_id`, `usuario_asignado_id`, `estado`, `solucion`, `evidencias`) VALUES
(1, 'Corto circuito', 'Falla eléctrica', '2025-04-16 22:18:14', '2025-04-17 06:12:28', 'Reactor', 'Le echaron agua xd', 'Alta', 1, 1, 'Resuelto', 'listo\r\n', ''),
(2, 'Corto circuito', 'Falla eléctrica', '2025-04-16 22:30:01', '2025-04-17 06:12:00', 'Reactor', 'Le echaron agua xd', 'Alta', 1, 5, 'Resuelto', 'kanye west\r\n', ''),
(3, 'Corto circuito', 'Falla eléctrica', '2025-04-17 00:07:18', '2025-04-24 02:39:16', 'Reactor', 'le volvieron a echar agua xd', 'Crítica', 1, 5, 'Resuelto', 'todo bien', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `insumos`
--

CREATE TABLE `insumos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL COMMENT 'Ej: Cloro, Sulfato de aluminio',
  `cantidad` decimal(10,2) NOT NULL,
  `unidad` varchar(20) NOT NULL COMMENT 'kg, L, mg, etc.',
  `fecha_registro` datetime DEFAULT current_timestamp(),
  `fecha_caducidad` date DEFAULT NULL COMMENT 'Opcional para perecederos',
  `proveedor` varchar(100) DEFAULT NULL,
  `lote` varchar(50) DEFAULT NULL COMMENT 'Número de lote',
  `ubicacion` varchar(50) DEFAULT NULL COMMENT 'Ej: Almacén A, Estante 3B',
  `usuario_id` int(11) NOT NULL COMMENT 'Quién registró',
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `insumos`
--

INSERT INTO `insumos` (`id`, `nombre`, `cantidad`, `unidad`, `fecha_registro`, `fecha_caducidad`, `proveedor`, `lote`, `ubicacion`, `usuario_id`, `observaciones`) VALUES
(1, 'Cloro', 20.00, 'kg', '2025-04-16 21:28:17', '2026-02-20', 'Mercado Libre', '3', 'Gustavo A. Madero', 1, 'calidad excelente\r\n'),
(2, 'cloro', 50.00, 'L', '2025-04-17 00:03:21', '2028-02-01', 'Mercado Libre', '3', 'Gustavo A. Madero', 1, 'le falta cloro');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mantenimientos`
--

CREATE TABLE `mantenimientos` (
  `id` int(11) NOT NULL,
  `equipo` varchar(100) NOT NULL COMMENT 'Ej: Bomba BCM-03A, Reactor Biológico',
  `tipo` enum('Preventivo','Correctivo','Calibración','Limpieza') NOT NULL,
  `fecha_programada` date NOT NULL,
  `fecha_realizacion` datetime DEFAULT NULL COMMENT 'Fecha real de ejecución',
  `descripcion` text NOT NULL,
  `usuario_id` int(11) NOT NULL COMMENT 'Quién registra',
  `tecnico_asignado` varchar(100) DEFAULT NULL COMMENT 'Nombre del técnico externo (opcional)',
  `estado` enum('Pendiente','En progreso','Completado','Cancelado') DEFAULT 'Pendiente',
  `evidencia` varchar(255) DEFAULT NULL COMMENT 'Ruta de foto/informe PDF'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `mantenimientos`
--

INSERT INTO `mantenimientos` (`id`, `equipo`, `tipo`, `fecha_programada`, `fecha_realizacion`, `descripcion`, `usuario_id`, `tecnico_asignado`, `estado`, `evidencia`) VALUES
(1, 'Sistema de Cloración', 'Correctivo', '2025-04-17', '2025-04-17 04:58:46', 'Limpieza', 1, 'yo', 'Completado', ''),
(2, 'Reactor Biológico', 'Correctivo', '2025-05-08', '2025-04-17 07:01:26', 'limpieza', 1, 'yo', 'Completado', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `muestreos`
--

CREATE TABLE `muestreos` (
  `id` int(11) NOT NULL,
  `normativa` varchar(100) NOT NULL COMMENT 'Ej: NOM-001-SEMARNAT-2021',
  `parametro` varchar(50) NOT NULL COMMENT 'Ej: DBO5, Coliformes',
  `punto_muestreo` varchar(50) NOT NULL COMMENT 'Ej: Salida PTAR',
  `frecuencia` enum('Diario','Semanal','Quincenal','Mensual','Trimestral') NOT NULL,
  `proxima_fecha` date NOT NULL,
  `responsable_id` int(11) NOT NULL,
  `metodo_analisis` varchar(100) DEFAULT NULL COMMENT 'Ej: SM 4500-NH3 D',
  `limite_maximo` decimal(10,2) DEFAULT NULL COMMENT 'Valor según normativa',
  `observaciones` text DEFAULT NULL,
  `estado` enum('Pendiente','Realizado','Atrasado') DEFAULT 'Pendiente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `muestreos`
--

INSERT INTO `muestreos` (`id`, `normativa`, `parametro`, `punto_muestreo`, `frecuencia`, `proxima_fecha`, `responsable_id`, `metodo_analisis`, `limite_maximo`, `observaciones`, `estado`) VALUES
(1, 'NOM-001-SEMARNAT-2021', 'coliformes', 'Descarga Final', 'Quincenal', '2025-04-18', 2, '1000-2455', 0.20, 'muestreo', 'Pendiente');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reset_tokens`
--

CREATE TABLE `reset_tokens` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `token` varchar(64) NOT NULL,
  `expira` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `reset_tokens`
--

INSERT INTO `reset_tokens` (`id`, `email`, `token`, `expira`) VALUES
(2, 'admin@unam.mx', '962745c9bc4ce326012cf324fee25181d49b8d031e7b21ed00442f56d5e1ce66', '2025-04-17 07:43:36');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `riegos`
--

CREATE TABLE `riegos` (
  `id` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_termino` time NOT NULL,
  `zona_regada` enum('Estadio','Polvorín','Prácticas','Otra') NOT NULL,
  `bomba_utilizada` enum('BCM-03A','BCM-03B','BCM-03R') NOT NULL,
  `nivel_tac_inicio` decimal(5,2) DEFAULT NULL COMMENT 'Metros',
  `nivel_tac_termino` decimal(5,2) DEFAULT NULL,
  `volumen_total_m3` decimal(10,2) NOT NULL,
  `volumen_estadio_m3` decimal(10,2) DEFAULT 0.00,
  `volumen_polvorin_m3` decimal(10,2) DEFAULT 0.00,
  `volumen_practicas_m3` decimal(10,2) DEFAULT 0.00,
  `observaciones` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `riegos`
--

INSERT INTO `riegos` (`id`, `fecha`, `hora_inicio`, `hora_termino`, `zona_regada`, `bomba_utilizada`, `nivel_tac_inicio`, `nivel_tac_termino`, `volumen_total_m3`, `volumen_estadio_m3`, `volumen_polvorin_m3`, `volumen_practicas_m3`, `observaciones`, `created_at`) VALUES
(1, '2025-04-16', '17:03:00', '06:04:00', 'Estadio', 'BCM-03A', 2.00, 3.00, 1.00, 1.00, 2.00, 2.00, 'bien\r\n', '2025-04-16 22:11:31'),
(2, '2025-04-16', '17:12:00', '06:13:00', 'Estadio', 'BCM-03A', 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 'bien\r\n', '2025-04-16 22:12:14'),
(3, '2025-04-16', '06:23:00', '19:24:00', 'Polvorín', 'BCM-03B', 2.60, 0.11, 1.00, 0.10, 2.00, 2.00, 'bien\r\n', '2025-04-16 22:23:28'),
(4, '2025-04-16', '00:50:00', '01:51:00', 'Estadio', 'BCM-03B', 1.00, 1.00, 1.00, 2.00, 2.00, 4.00, 'Excelente', '2025-04-17 04:50:20');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` enum('admin','ingeniero','visitante') DEFAULT 'visitante',
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `email`, `password`, `rol`, `fecha_registro`) VALUES
(1, 'Administrador PTAR', 'admin@unam.mx', '$2y$10$fQ4N4m5q4XtvFHXSOp5C/OusQJ7gIsBiX8GM26jlKBftLYbgPWUZy', 'admin', '2025-04-16 01:37:59'),
(2, 'Admin', 'adminptar@unam.mx', '$2y$10$ia8Sbc48KwS1YQSd4HTLDeskp15JueyxsbYrLgmQRmQ.0/HgRWyM6', 'admin', '2025-04-16 01:50:53'),
(3, 'Emiliano', '423122@unam.mx', '$2y$10$dEPDa5/LQoUIgp06lZevxe1xJiwAXdHKDtonUSm13Yq0u6C2VwAEa', 'visitante', '2025-04-16 02:47:40'),
(4, 'AdminPTAR2', 'adminptar2@unam.mx', '$2y$10$IDbtMumTOjzK5lEPKXTQpumfE7HRoswjzj7pptLqKlLrj2nVhHOE6', 'visitante', '2025-04-16 02:52:50'),
(5, 'Kanye West', 'kanye@unam.mx', '$2y$10$rGLgCcykHyojQGOhHmiI2.REucSOhhTaa3ugo4gdk3h6diEPdxpau', 'admin', '2025-04-16 22:41:58'),
(6, 'Jorge', 'jorge@unam.mx', '$2y$10$k3/9pUe6yV1vhOsTUb.7TepkPGthxuQ/J3izg9YKrYLbMtWpsa3ke', 'visitante', '2025-04-17 04:17:50');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `calidad_agua`
--
ALTER TABLE `calidad_agua`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `flujos`
--
ALTER TABLE `flujos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `incidentes`
--
ALTER TABLE `incidentes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_reporta_id` (`usuario_reporta_id`),
  ADD KEY `usuario_asignado_id` (`usuario_asignado_id`);

--
-- Indices de la tabla `insumos`
--
ALTER TABLE `insumos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `mantenimientos`
--
ALTER TABLE `mantenimientos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `muestreos`
--
ALTER TABLE `muestreos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `responsable_id` (`responsable_id`);

--
-- Indices de la tabla `reset_tokens`
--
ALTER TABLE `reset_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token` (`token`),
  ADD KEY `email` (`email`);

--
-- Indices de la tabla `riegos`
--
ALTER TABLE `riegos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `calidad_agua`
--
ALTER TABLE `calidad_agua`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `flujos`
--
ALTER TABLE `flujos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `incidentes`
--
ALTER TABLE `incidentes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `insumos`
--
ALTER TABLE `insumos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `mantenimientos`
--
ALTER TABLE `mantenimientos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `muestreos`
--
ALTER TABLE `muestreos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `reset_tokens`
--
ALTER TABLE `reset_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `riegos`
--
ALTER TABLE `riegos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `calidad_agua`
--
ALTER TABLE `calidad_agua`
  ADD CONSTRAINT `calidad_agua_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `flujos`
--
ALTER TABLE `flujos`
  ADD CONSTRAINT `flujos_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `incidentes`
--
ALTER TABLE `incidentes`
  ADD CONSTRAINT `incidentes_ibfk_1` FOREIGN KEY (`usuario_reporta_id`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `incidentes_ibfk_2` FOREIGN KEY (`usuario_asignado_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `insumos`
--
ALTER TABLE `insumos`
  ADD CONSTRAINT `insumos_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `mantenimientos`
--
ALTER TABLE `mantenimientos`
  ADD CONSTRAINT `mantenimientos_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `muestreos`
--
ALTER TABLE `muestreos`
  ADD CONSTRAINT `muestreos_ibfk_1` FOREIGN KEY (`responsable_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `reset_tokens`
--
ALTER TABLE `reset_tokens`
  ADD CONSTRAINT `reset_tokens_ibfk_1` FOREIGN KEY (`email`) REFERENCES `usuarios` (`email`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
