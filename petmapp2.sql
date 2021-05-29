-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: May 29, 2021 at 04:56 PM
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
-- Database: `petmapp2`
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

--
-- Dumping data for table `alertas`
--

INSERT INTO `alertas` (`id`, `tipo_alerta`, `foto`, `descripcion`, `direccion`, `habilitado`, `ultima_actividad`, `usuario_rut`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'Photo', 'Description Two', 'Testing Direction', 1, '2021-05-28 16:53:37', 116214377, '2021-05-29 16:27:35', '2021-05-29 16:28:52', '2021-05-29 16:28:52');

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

--
-- Dumping data for table `comentarios_alertas`
--

INSERT INTO `comentarios_alertas` (`id`, `descripcion`, `fecha_emision`, `foto`, `alerta_id`, `usuario_rut`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Se ha encontrado un animal', '2021-05-28 16:53:37', 'foto', 1, 116214377, '2021-05-29 16:37:57', '2021-05-29 16:38:34', '2021-05-29 16:38:34');

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

--
-- Dumping data for table `comentarios_negocios`
--

INSERT INTO `comentarios_negocios` (`id`, `descripcion`, `fecha_emision`, `foto`, `usuario_rut`, `negocio_id`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Muy buen local, me atendieron bien', '2021-05-28 16:53:37', 'foto', 116214377, 1, '2021-05-29 16:42:38', '2021-05-29 16:43:16', '2021-05-29 16:43:16');

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

--
-- Dumping data for table `comentarios_ubicaciones`
--

INSERT INTO `comentarios_ubicaciones` (`id`, `descripcion`, `fecha_emision`, `foto`, `ubicacion_id`, `usuario_rut`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Excelente plaza, con muchas mascotas', '2021-05-28 16:53:37', 'foto', 1, 116214377, '2021-05-29 16:44:30', '2021-05-29 16:44:59', '2021-05-29 16:44:59');

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
(3, 'Perro', 'El perro, ​​​ llamado perro doméstico o can, ​ y en algunos lugares coloquialmente llamado chucho, ​ tuso, ​ choco, ​ entre otros; es un mamífero carnívoro de la familia de los cánidos, que constituye una especie del género Canis.', NULL, NULL, NULL),
(4, 'Gato', 'El gato doméstico​​, llamado popularmente gato, y de forma coloquial minino, ​ michino, ​ michi, ​ micho, ​ mizo, ​ miz, ​ morroño​ o morrongo, ​ entre otros nombres, es un mamífero carnívoro de la familia Felidae. ', NULL, NULL, NULL),
(5, 'Pescado', 'Animal que puede nadar', '2021-05-08 15:10:29', '2021-05-08 15:20:01', '2021-05-08 15:20:01'),
(6, NULL, 'Casa grande', '2021-05-21 16:13:29', '2021-05-21 16:13:29', NULL),
(7, 'Testing Update', 'Put method', '2021-05-28 15:05:42', '2021-05-28 15:06:31', '2021-05-28 15:06:31');

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
  `peticion_cuidado_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `evaluaciones`
--

INSERT INTO `evaluaciones` (`id`, `nota`, `comentario`, `created_at`, `updated_at`, `deleted_at`, `peticion_cuidado_id`) VALUES
(1, 8, 'Excelente cuidado, mi mascota llego feliz', '2021-05-28 17:52:43', '2021-05-28 17:53:27', '2021-05-28 17:53:27', 0);

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
(1, 1, 1, 'Berlin 411', 'Casa grande, afuera hay una plaza', 'Foto', 116214377, '2021-05-08 15:19:37', '2021-05-08 15:17:13', '2021-05-08 15:19:37'),
(2, 1, 1, 'Berlin 411', 'Casa grande', 'Foto', 116214377, NULL, '2021-05-13 15:43:49', '2021-05-13 15:43:49'),
(3, 1, 1, 'Berlin 411', 'Casa grande', 'Foto', 116214377, NULL, '2021-05-21 16:12:50', '2021-05-21 16:12:50'),
(4, 1, 1, 'Testing Two', 'Testing Two', 'Foto', 116214377, '2021-05-28 15:31:19', '2021-05-28 15:29:50', '2021-05-28 15:31:19');

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
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mascotas`
--

INSERT INTO `mascotas` (`id`, `nombre`, `sexo`, `raza_id`, `usuario_rut`, `deleted_at`, `created_at`, `updated_at`) VALUES
(5, 'dogO', 1, 3, 1, NULL, '2021-05-05 21:50:44', '2021-05-05 21:50:44'),
(6, 'Kimmy', 2, 3, 1, NULL, NULL, NULL),
(7, 'h3', 1, 3, 1, NULL, '2021-05-06 16:05:56', '2021-05-06 16:05:56'),
(8, 'kiki', 1, 3, 1, NULL, '2021-05-06 16:18:14', '2021-05-06 16:18:14'),
(9, 'rucio', 1, 3, 116214377, NULL, '2021-05-06 16:25:34', '2021-05-06 16:25:34'),
(10, 'negro', 1, 3, 116214377, NULL, '2021-05-06 16:25:58', '2021-05-06 16:25:58'),
(11, 'yoyo', 1, 3, 116214377, NULL, '2021-05-06 16:33:05', '2021-05-06 16:33:05'),
(12, 'miki', 1, 8, 116214377, NULL, '2021-05-06 16:36:16', '2021-05-06 16:36:16'),
(13, 'beno', 1, 7, 116214377, NULL, '2021-05-06 16:47:43', '2021-05-06 16:47:43'),
(14, 'PetTesting', 1, 3, 116214377, '2021-05-28 15:16:54', '2021-05-28 15:15:00', '2021-05-28 15:16:54');

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

--
-- Dumping data for table `negocios`
--

INSERT INTO `negocios` (`id`, `nombre`, `descripcion`, `horario`, `direccion`, `foto`, `tipo_id`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Doña Maria', 'MiniMarket', '2021-05-28 16:53:37', NULL, 'foto', 2, '2021-05-29 16:33:17', '2021-05-29 16:34:06', '2021-05-29 16:34:06');

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
(1, 1, 'Usuario', NULL, '0000-00-00 00:00:00', NULL),
(2, 2, 'Administrador', NULL, '0000-00-00 00:00:00', NULL),
(3, 3, 'Banned', '2021-05-28 15:54:05', '2021-05-28 15:52:45', '2021-05-28 15:54:05');

-- --------------------------------------------------------

--
-- Table structure for table `peticion_cuidado`
--

CREATE TABLE `peticion_cuidado` (
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
-- Dumping data for table `peticion_cuidado`
--

INSERT INTO `peticion_cuidado` (`id`, `fecha_inicio`, `fecha_fin`, `precio_total`, `estado`, `created_at`, `usuario_rut`, `publicacion_id`, `updated_at`, `deleted_at`, `boleta`) VALUES
(1, '2021-05-05 21:50:44', '2021-05-05 21:50:44', 20000, 1, '2021-05-28 16:53:37', 0, 0, '2021-05-28 16:53:37', NULL, NULL),
(2, '2021-05-05 21:50:44', '2021-05-05 21:50:44', 15000, 2, '2021-05-28 16:58:58', 0, 0, '2021-05-28 16:58:58', NULL, NULL),
(3, '2021-05-28 16:53:37', '2021-05-28 16:53:37', 15000, 1, '2021-05-28 18:30:13', 116214377, 1, '2021-05-28 18:30:13', NULL, NULL);

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
(1, 'Solicito cuidado para mis perros por 2 dias', 7500, '2021-05-28 15:59:28', '2021-05-28 16:05:51', '2021-05-28 16:05:51', 116214377);

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
(3, 'Pastor alemán', 'El pastor alemán u ovejero es una raza canina que proviene de Alemania.​La raza es relativamente nueva, ya que su origen se remonta a 1899.​', NULL, 3, NULL, NULL),
(4, 'Bulldog', 'El bulldog o bulldog inglés —en inglés: English Bulldog— es una raza canina originaria del Reino Unido. Su ancestro, conocido como el Antiguo Bulldog Inglés, fue utilizado en peleas de perros con toros hasta mediados del siglo XVII ', NULL, 3, NULL, NULL),
(7, 'puddle', 'Perro pudle', NULL, 3, '2021-05-06 16:13:29', '2021-05-06 16:13:29'),
(8, 'Chihuahua', 'perro ql insoportable', NULL, 3, '2021-05-06 16:14:13', '2021-05-06 16:14:13'),
(10, 'Testing Update', 'Put method', '2021-05-28 15:02:19', 3, '2021-05-28 14:59:15', '2021-05-28 15:02:19'),
(11, 'Testing', 'Testing', NULL, 3, '2021-05-28 15:04:03', '2021-05-28 15:04:03'),
(12, 'Testing', 'Testing', NULL, 3, '2021-05-28 15:05:09', '2021-05-28 15:05:09');

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
  `peticion_cuidado_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `servicios`
--

INSERT INTO `servicios` (`id`, `comentario`, `foto`, `monto`, `fecha`, `created_at`, `updated_at`, `deleted_at`, `peticion_cuidado_id`) VALUES
(1, 'Servicio de peluqueria', 'foto', 17000, '2021-05-05 21:50:44', '2021-05-28 17:49:24', '2021-05-28 17:50:19', '2021-05-28 17:50:19', 0);

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

--
-- Dumping data for table `tipos`
--

INSERT INTO `tipos` (`id`, `tipo_negocio`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, '2021-05-29 16:30:43', '2021-05-29 16:31:40', '2021-05-29 16:31:40'),
(2, 2, '2021-05-29 16:30:47', '2021-05-29 16:30:47', NULL),
(3, 4, '2021-05-29 16:30:50', '2021-05-29 16:31:34', NULL);

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

--
-- Dumping data for table `ubicaciones`
--

INSERT INTO `ubicaciones` (`id`, `tipo_ubicacion`, `descripcion`, `foto`, `direccion`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'Plaza principal', 'foto', 'Avenida San Pedro con General xD', '2021-05-29 16:35:35', '2021-05-29 16:36:17', '2021-05-29 16:36:17');

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
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `usuarios`
--

INSERT INTO `usuarios` (`rut`, `name`, `email`, `password`, `created_at`, `updated_at`, `perfil_id`, `deleted_at`) VALUES
(1, 'alex', 'user1@gmail.com', '$2y$10$hsSYudkZmgYfpPvlqWtJVOJKZDZ0fZMvU7J.UiA.QcOK535O6LUvq', '2021-05-05 21:44:20', '2021-05-05 21:44:20', 1, NULL),
(123, 'isa', 'isac@gmail.com', '$2y$10$5h.ntJI5/zsBbnYeVYI5suZcgQJskm964iU2U98Rdi6aZmGJSkNlq', '2021-05-21 16:32:53', '2021-05-21 16:32:53', 1, NULL),
(321, 'dsa', 'dsa@gmail.com', '$2y$10$geGAkMcl7bkS5x7ZyBqMAegPAPIHWKuAz6i6vHW0Nnw3Pqga0bQOu', '2021-05-21 16:59:15', '2021-05-21 16:59:15', 1, NULL),
(12345678, 'Testing', 'Testing', '$2y$10$WWkVaNQSzOpSKIB0gljuROB5aYZyFzxrvNsaX9kKmm.hU/2wJM9WK', '2021-05-28 15:26:52', '2021-05-28 15:26:52', 1, NULL),
(116214377, 'Claudio', 'claudio@gmail.com', '$2y$10$pUiBdipLnae/o0C7ydPKOOQnbXgwGchdkFV20iIjiPN8JZ7MsAvy6', '2021-05-05 21:54:06', '2021-05-05 21:54:06', 1, NULL),
(123456789, 'alf', 'alf@gmail.com', '$2y$10$nxGJBdlx6nPET9mz0vW.l.0u2sx2ZiIkWZPXm55MO.H1kkvE6pPaW', '2021-05-21 16:29:48', '2021-05-21 16:29:48', 1, NULL);

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
  ADD KEY `fk_evaluaciones_peticion_cuidado1_idx` (`peticion_cuidado_id`);

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
-- Indexes for table `peticion_cuidado`
--
ALTER TABLE `peticion_cuidado`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_peticion_cuidado_usuarios1_idx` (`usuario_rut`),
  ADD KEY `fk_peticion_cuidado_publicaciones1_idx` (`publicacion_id`);

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
  ADD KEY `fk_servicios_peticion_cuidado1_idx` (`peticion_cuidado_id`);

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
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `comentarios_alertas`
--
ALTER TABLE `comentarios_alertas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `comentarios_negocios`
--
ALTER TABLE `comentarios_negocios`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `comentarios_ubicaciones`
--
ALTER TABLE `comentarios_ubicaciones`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `especies`
--
ALTER TABLE `especies`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `evaluaciones`
--
ALTER TABLE `evaluaciones`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `hogares`
--
ALTER TABLE `hogares`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `mascotas`
--
ALTER TABLE `mascotas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `negocios`
--
ALTER TABLE `negocios`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `perfiles`
--
ALTER TABLE `perfiles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `peticion_cuidado`
--
ALTER TABLE `peticion_cuidado`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `publicaciones`
--
ALTER TABLE `publicaciones`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `razas`
--
ALTER TABLE `razas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `servicios`
--
ALTER TABLE `servicios`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tipos`
--
ALTER TABLE `tipos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `ubicaciones`
--
ALTER TABLE `ubicaciones`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
  ADD CONSTRAINT `fk_evaluaciones_peticion_cuidado1` FOREIGN KEY (`peticion_cuidado_id`) REFERENCES `peticion_cuidado` (`id`);

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
-- Constraints for table `peticion_cuidado`
--
ALTER TABLE `peticion_cuidado`
  ADD CONSTRAINT `fk_peticion_cuidado_publicaciones1` FOREIGN KEY (`publicacion_id`) REFERENCES `publicaciones` (`id`),
  ADD CONSTRAINT `fk_peticion_cuidado_usuarios1` FOREIGN KEY (`usuario_rut`) REFERENCES `usuarios` (`rut`);

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
  ADD CONSTRAINT `fk_servicios_peticion_cuidado1` FOREIGN KEY (`peticion_cuidado_id`) REFERENCES `peticion_cuidado` (`id`);

--
-- Constraints for table `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_users_perfiles1` FOREIGN KEY (`perfil_id`) REFERENCES `perfiles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
