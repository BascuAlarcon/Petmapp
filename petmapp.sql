-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 10, 2021 at 12:30 AM
-- Server version: 8.0.22
-- PHP Version: 7.4.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `petmapp`
--

-- --------------------------------------------------------

--
-- Table structure for table `alertas`
--

CREATE TABLE `alertas` (
  `id` int NOT NULL,
  `tipo_alerta` int DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `direccion` varchar(50) DEFAULT NULL,
  `habilitado` int DEFAULT NULL,
  `ultima_actividad` timestamp NULL DEFAULT NULL,
  `usuario_rut` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `comentarios_alertas`
--

CREATE TABLE `comentarios_alertas` (
  `id` int NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `fecha_emision` timestamp NULL DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `alerta_id` int NOT NULL,
  `usuario_rut` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `comentarios_negocios`
--

CREATE TABLE `comentarios_negocios` (
  `id` int NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `fecha_emision` timestamp NULL DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `usuario_rut` int NOT NULL,
  `negocio_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `comentarios_ubicaciones`
--

CREATE TABLE `comentarios_ubicaciones` (
  `id` int NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `fecha_emision` timestamp NULL DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `ubicacion_id` int NOT NULL,
  `usuario_rut` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `especies`
--

CREATE TABLE `especies` (
  `id` int NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `especies`
--

INSERT INTO `especies` (`id`, `nombre`, `descripcion`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Perro', 'Perro es una especie del can', '2021-05-31 18:41:38', '2021-05-31 18:41:38', NULL),
(2, 'Gato', 'Gato es una especie felina domestica', '2021-05-31 18:41:57', '2021-05-31 18:41:57', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `evaluaciones`
--

CREATE TABLE `evaluaciones` (
  `id` int NOT NULL,
  `nota` int DEFAULT NULL,
  `comentario` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `peticion_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `hogares`
--

CREATE TABLE `hogares` (
  `id` int NOT NULL,
  `tipo_hogar` int DEFAULT NULL,
  `disponibilidad_patio` int DEFAULT NULL,
  `direccion` varchar(50) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `usuario_rut` int NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `hogares`
--

INSERT INTO `hogares` (`id`, `tipo_hogar`, `disponibilidad_patio`, `direccion`, `descripcion`, `foto`, `usuario_rut`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 'Berlin 411', 'Casa de dos pisos, cuento con patio grande', 'foto', 123123123, NULL, NULL, '2021-06-03 14:09:53'),
(2, 2, 2, 'Los carreras 342', 'Departamento donde vivo solo', 'foto', 123123123, '2021-06-03 14:04:42', NULL, '2021-06-03 14:04:42'),
(3, 1, 1, '15 norte', 'asd', 'foto', 196656359, NULL, '2021-06-03 13:55:04', '2021-06-03 13:55:04'),
(4, 1, 1, 'Avenida Vespucio 231', 'Casa grande, cuento con patio amplio', NULL, 123123123, NULL, '2021-06-03 14:08:33', '2021-06-03 14:08:33');

-- --------------------------------------------------------

--
-- Table structure for table `mascotas`
--

CREATE TABLE `mascotas` (
  `id` int NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `sexo` int DEFAULT NULL,
  `raza_id` int NOT NULL,
  `usuario_rut` int NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `estirilizacion` int DEFAULT NULL,
  `fecha_nacimiento` timestamp NULL DEFAULT NULL,
  `condicion_medica` varchar(255) DEFAULT NULL,
  `microchip` int DEFAULT NULL,
  `alimentos` varchar(255) DEFAULT NULL,
  `personalidad` varchar(255) DEFAULT NULL,
  `foto` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mascotas`
--

INSERT INTO `mascotas` (`id`, `nombre`, `sexo`, `raza_id`, `usuario_rut`, `deleted_at`, `created_at`, `updated_at`, `estirilizacion`, `fecha_nacimiento`, `condicion_medica`, `microchip`, `alimentos`, `personalidad`, `foto`) VALUES
(1, 'popo', 1, 5, 196656359, NULL, '2021-06-03 01:49:30', '2021-06-03 01:49:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `negocios`
--

CREATE TABLE `negocios` (
  `id` int NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `horario` timestamp NULL DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `tipo_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `perfiles`
--

CREATE TABLE `perfiles` (
  `id` int NOT NULL,
  `cod_perfil` int DEFAULT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `perfiles`
--

INSERT INTO `perfiles` (`id`, `cod_perfil`, `nombre`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 1, 'Usuario', NULL, NULL, NULL),
(2, 2, 'Administrador', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `peticiones`
--

CREATE TABLE `peticiones` (
  `id` int NOT NULL,
  `fecha_inicio` timestamp NULL DEFAULT NULL,
  `fecha_fin` timestamp NULL DEFAULT NULL,
  `precio_total` int DEFAULT NULL,
  `estado` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `usuario_rut` int NOT NULL,
  `publicacion_id` int NOT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `boleta` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `peticiones`
--

INSERT INTO `peticiones` (`id`, `fecha_inicio`, `fecha_fin`, `precio_total`, `estado`, `created_at`, `usuario_rut`, `publicacion_id`, `updated_at`, `deleted_at`, `boleta`) VALUES
(1, '2021-05-12 17:07:35', '2021-05-13 17:07:35', 15000, 1, NULL, 196656359, 1, NULL, NULL, 15000),
(2, '2021-05-11 17:15:25', '2021-05-13 17:15:25', 15000, 1, NULL, 196656359, 1, NULL, NULL, 20000),
(3, '2021-05-28 16:53:37', '2021-05-28 16:53:37', 22000, 1, '2021-06-01 13:24:49', 196656359, 1, '2021-06-01 13:26:11', '2021-06-01 13:26:11', NULL),
(6, '2021-05-28 16:53:37', '2021-05-28 16:53:37', 22000, 1, '2021-06-01 16:13:33', 196656359, 1, '2021-06-01 16:13:33', NULL, NULL),
(7, '2021-05-28 16:53:37', '2021-05-29 16:53:39', 19000, 19000, '2021-06-01 16:16:11', 123123123, 1, '2021-06-01 16:16:11', NULL, NULL),
(8, '2021-05-12 17:07:35', '2021-05-13 17:07:35', 15000, 3, NULL, 123123123, 2, '2021-06-03 00:14:05', NULL, NULL),
(9, '2021-06-08 14:20:18', '2021-06-08 14:20:18', 15000, 15000, '2021-06-08 14:26:44', 123123123, 4, '2021-06-08 14:26:44', NULL, 1),
(10, '2021-07-07 16:12:12', '2021-02-02 12:09:09', NULL, NULL, '2021-06-09 17:47:35', 123123123, 4, '2021-06-09 17:47:35', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `peticion_mascota`
--

CREATE TABLE `peticion_mascota` (
  `peticion_id` int NOT NULL,
  `mascota_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `publicaciones`
--

CREATE TABLE `publicaciones` (
  `id` int NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `tarifa` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `usuario_rut` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `publicaciones`
--

INSERT INTO `publicaciones` (`id`, `descripcion`, `tarifa`, `created_at`, `updated_at`, `deleted_at`, `usuario_rut`) VALUES
(1, 'Necesito que cuiden a mi perro por el fin de semana', 7500, NULL, '2021-06-08 14:20:28', '2021-06-08 14:20:28', 196656359),
(2, 'Necesito que cuiden a mi gato por 3 dias', 7500, NULL, '2021-06-08 14:25:18', '2021-06-08 14:25:18', 123123123),
(3, 'Necesito que cuiden a mi perro solo el sabado', 12000, NULL, '2021-06-08 14:25:15', '2021-06-08 14:25:15', 123123123),
(4, 'Cuidador profesional', 6500, '2021-06-08 14:23:55', '2021-06-08 14:23:55', NULL, 196656359),
(5, 'Buen cuidador casa grande como mi', 2500, '2021-06-09 17:56:38', '2021-06-09 17:56:38', NULL, 123123123);

-- --------------------------------------------------------

--
-- Table structure for table `razas`
--

CREATE TABLE `razas` (
  `id` int NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `especie_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `razas`
--

INSERT INTO `razas` (`id`, `nombre`, `descripcion`, `deleted_at`, `especie_id`, `created_at`, `updated_at`) VALUES
(4, 'Salchicha', 'Perro chico y largo', '2021-06-09 15:39:20', 1, NULL, '2021-06-09 15:39:20'),
(5, 'Bulldog', 'Bulldog', NULL, 1, NULL, NULL),
(9, 'Gato egipsio', 'Gato proveniente de egipto', NULL, 2, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `servicios`
--

CREATE TABLE `servicios` (
  `id` int NOT NULL,
  `comentario` varchar(255) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `monto` int DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `peticion_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tipos`
--

CREATE TABLE `tipos` (
  `id` int NOT NULL,
  `tipo_negocio` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `ubicaciones`
--

CREATE TABLE `ubicaciones` (
  `id` int NOT NULL,
  `tipo_ubicacion` int DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `direccion` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `usuarios`
--

CREATE TABLE `usuarios` (
  `rut` int NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `perfil_id` int NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `fecha_nacimiento` timestamp NULL DEFAULT NULL,
  `sexo` int DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `numero_telefonico` int DEFAULT NULL,
  `promedio_evaluaciones` int DEFAULT NULL,
  `calendario` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `usuarios`
--

INSERT INTO `usuarios` (`rut`, `name`, `email`, `password`, `created_at`, `updated_at`, `perfil_id`, `deleted_at`, `fecha_nacimiento`, `sexo`, `foto`, `numero_telefonico`, `promedio_evaluaciones`, `calendario`) VALUES
(111111111, 'camilo', 'camilo@gmail.com', '$2y$10$cnVFRbFlaYHARCQqCbESUO0Y/kCLwR5DouL2Io5ZmcKzLf17nnBtK', '2021-06-09 19:17:35', '2021-06-09 19:24:46', 2, NULL, '2020-02-02 13:10:10', 1, 'foto', 9817381, NULL, NULL),
(123123123, 'Admin', 'admin@gmail.com', '$2y$10$lFdvFkYmUj/F1rZ1JkkUvevR0nT3K8vh5OYYeLP1fHs1mRNatN2g6', '2021-06-01 16:02:36', '2021-06-09 14:56:04', 1, NULL, '2021-06-08 16:03:23', 1, 'foto', 81179172, NULL, NULL),
(196656359, 'Ale', 'ale@gmail.com', '$2y$10$mAJbQ5Z9xmBaKdnZdBWUjOZNG4KmdwmuV5QDIWPFrJnlrsWo07zu.', NULL, '2021-06-09 14:18:40', 2, NULL, '2021-06-01 16:02:36', 1, 'foto fachera', 58626642, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alertas`
--
ALTER TABLE `alertas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_alertas_usuarios1_idx` (`usuario_rut`);

--
-- Indexes for table `comentarios_alertas`
--
ALTER TABLE `comentarios_alertas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_comentarios_alertas_alertas1_idx` (`alerta_id`),
  ADD KEY `fk_comentarios_alertas_usuarios1_idx` (`usuario_rut`);

--
-- Indexes for table `comentarios_negocios`
--
ALTER TABLE `comentarios_negocios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_comentarios_negocios_usuarios1_idx` (`usuario_rut`),
  ADD KEY `fk_comentarios_negocios_negocios1_idx` (`negocio_id`);

--
-- Indexes for table `comentarios_ubicaciones`
--
ALTER TABLE `comentarios_ubicaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_comentarios_ubicaciones_ubicaciones1_idx` (`ubicacion_id`),
  ADD KEY `fk_comentarios_ubicaciones_usuarios1_idx` (`usuario_rut`);

--
-- Indexes for table `especies`
--
ALTER TABLE `especies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `evaluaciones`
--
ALTER TABLE `evaluaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_evaluaciones_peticiones1_idx` (`peticion_id`);

--
-- Indexes for table `hogares`
--
ALTER TABLE `hogares`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_hogares_usuarios1_idx` (`usuario_rut`);

--
-- Indexes for table `mascotas`
--
ALTER TABLE `mascotas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_mascotas_razas_idx` (`raza_id`),
  ADD KEY `fk_mascotas_usuarios1_idx` (`usuario_rut`);

--
-- Indexes for table `negocios`
--
ALTER TABLE `negocios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_negocios_tipos1_idx` (`tipo_id`);

--
-- Indexes for table `perfiles`
--
ALTER TABLE `perfiles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `peticiones`
--
ALTER TABLE `peticiones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_peticion_cuidado_usuarios1_idx` (`usuario_rut`),
  ADD KEY `fk_peticion_cuidado_publicaciones1_idx` (`publicacion_id`);

--
-- Indexes for table `peticion_mascota`
--
ALTER TABLE `peticion_mascota`
  ADD PRIMARY KEY (`peticion_id`,`mascota_id`),
  ADD KEY `fk_peticiones_has_mascotas_mascotas1_idx` (`mascota_id`),
  ADD KEY `fk_peticiones_has_mascotas_peticiones1_idx` (`peticion_id`);

--
-- Indexes for table `publicaciones`
--
ALTER TABLE `publicaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_publicaciones_usuarios1_idx` (`usuario_rut`);

--
-- Indexes for table `razas`
--
ALTER TABLE `razas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_razas_especies1_idx` (`especie_id`);

--
-- Indexes for table `servicios`
--
ALTER TABLE `servicios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_servicios_peticiones1_idx` (`peticion_id`);

--
-- Indexes for table `tipos`
--
ALTER TABLE `tipos`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ubicaciones`
--
ALTER TABLE `ubicaciones`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`rut`),
  ADD KEY `fk_users_perfiles1_idx` (`perfil_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `alertas`
--
ALTER TABLE `alertas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `comentarios_alertas`
--
ALTER TABLE `comentarios_alertas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `comentarios_negocios`
--
ALTER TABLE `comentarios_negocios`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `comentarios_ubicaciones`
--
ALTER TABLE `comentarios_ubicaciones`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `especies`
--
ALTER TABLE `especies`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `evaluaciones`
--
ALTER TABLE `evaluaciones`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hogares`
--
ALTER TABLE `hogares`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `mascotas`
--
ALTER TABLE `mascotas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `negocios`
--
ALTER TABLE `negocios`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `perfiles`
--
ALTER TABLE `perfiles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `peticiones`
--
ALTER TABLE `peticiones`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `publicaciones`
--
ALTER TABLE `publicaciones`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `razas`
--
ALTER TABLE `razas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `servicios`
--
ALTER TABLE `servicios`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tipos`
--
ALTER TABLE `tipos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ubicaciones`
--
ALTER TABLE `ubicaciones`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `alertas`
--
ALTER TABLE `alertas`
  ADD CONSTRAINT `fk_alertas_usuarios1` FOREIGN KEY (`usuario_rut`) REFERENCES `usuarios` (`rut`);

--
-- Constraints for table `comentarios_alertas`
--
ALTER TABLE `comentarios_alertas`
  ADD CONSTRAINT `fk_comentarios_alertas_alertas1` FOREIGN KEY (`alerta_id`) REFERENCES `alertas` (`id`),
  ADD CONSTRAINT `fk_comentarios_alertas_usuarios1` FOREIGN KEY (`usuario_rut`) REFERENCES `usuarios` (`rut`);

--
-- Constraints for table `comentarios_negocios`
--
ALTER TABLE `comentarios_negocios`
  ADD CONSTRAINT `fk_comentarios_negocios_negocios1` FOREIGN KEY (`negocio_id`) REFERENCES `negocios` (`id`),
  ADD CONSTRAINT `fk_comentarios_negocios_usuarios1` FOREIGN KEY (`usuario_rut`) REFERENCES `usuarios` (`rut`);

--
-- Constraints for table `comentarios_ubicaciones`
--
ALTER TABLE `comentarios_ubicaciones`
  ADD CONSTRAINT `fk_comentarios_ubicaciones_ubicaciones1` FOREIGN KEY (`ubicacion_id`) REFERENCES `ubicaciones` (`id`),
  ADD CONSTRAINT `fk_comentarios_ubicaciones_usuarios1` FOREIGN KEY (`usuario_rut`) REFERENCES `usuarios` (`rut`);

--
-- Constraints for table `evaluaciones`
--
ALTER TABLE `evaluaciones`
  ADD CONSTRAINT `fk_evaluaciones_peticiones1` FOREIGN KEY (`peticion_id`) REFERENCES `peticiones` (`id`);

--
-- Constraints for table `hogares`
--
ALTER TABLE `hogares`
  ADD CONSTRAINT `fk_hogares_usuarios1` FOREIGN KEY (`usuario_rut`) REFERENCES `usuarios` (`rut`);

--
-- Constraints for table `mascotas`
--
ALTER TABLE `mascotas`
  ADD CONSTRAINT `fk_mascotas_razas` FOREIGN KEY (`raza_id`) REFERENCES `razas` (`id`),
  ADD CONSTRAINT `fk_mascotas_usuarios1` FOREIGN KEY (`usuario_rut`) REFERENCES `usuarios` (`rut`);

--
-- Constraints for table `negocios`
--
ALTER TABLE `negocios`
  ADD CONSTRAINT `fk_negocios_tipos1` FOREIGN KEY (`tipo_id`) REFERENCES `tipos` (`id`);

--
-- Constraints for table `peticiones`
--
ALTER TABLE `peticiones`
  ADD CONSTRAINT `fk_peticion_cuidado_publicaciones1` FOREIGN KEY (`publicacion_id`) REFERENCES `publicaciones` (`id`),
  ADD CONSTRAINT `fk_peticion_cuidado_usuarios1` FOREIGN KEY (`usuario_rut`) REFERENCES `usuarios` (`rut`);

--
-- Constraints for table `peticion_mascota`
--
ALTER TABLE `peticion_mascota`
  ADD CONSTRAINT `fk_peticiones_has_mascotas_mascotas1` FOREIGN KEY (`mascota_id`) REFERENCES `mascotas` (`id`),
  ADD CONSTRAINT `fk_peticiones_has_mascotas_peticiones1` FOREIGN KEY (`peticion_id`) REFERENCES `peticiones` (`id`);

--
-- Constraints for table `publicaciones`
--
ALTER TABLE `publicaciones`
  ADD CONSTRAINT `fk_publicaciones_usuarios1` FOREIGN KEY (`usuario_rut`) REFERENCES `usuarios` (`rut`);

--
-- Constraints for table `razas`
--
ALTER TABLE `razas`
  ADD CONSTRAINT `fk_razas_especies1` FOREIGN KEY (`especie_id`) REFERENCES `especies` (`id`);

--
-- Constraints for table `servicios`
--
ALTER TABLE `servicios`
  ADD CONSTRAINT `fk_servicios_peticiones1` FOREIGN KEY (`peticion_id`) REFERENCES `peticiones` (`id`);

--
-- Constraints for table `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_users_perfiles1` FOREIGN KEY (`perfil_id`) REFERENCES `perfiles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
