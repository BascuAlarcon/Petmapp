-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 19, 2021 at 03:38 PM
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
  `foto` varchar(255) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `direccion` varchar(50) DEFAULT NULL,
  `habilitado` int DEFAULT NULL,
  `ultima_actividad` timestamp NULL DEFAULT NULL,
  `usuario_rut` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `tipo_alerta_id` int NOT NULL,
  `localizacion` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `alertas`
--

INSERT INTO `alertas` (`id`, `foto`, `descripcion`, `direccion`, `habilitado`, `ultima_actividad`, `usuario_rut`, `created_at`, `updated_at`, `deleted_at`, `tipo_alerta_id`, `localizacion`) VALUES
(1, 'test', 'test', 'test', 1, '2020-02-02 14:12:12', 123123123, '2021-06-17 14:46:16', '2021-06-17 14:55:03', '2021-06-17 14:55:03', 2, 'test'),
(2, 'asd', 'add', 'asf', 1, '2020-09-09 15:12:12', 123123123, '2021-06-17 22:34:15', '2021-06-17 22:34:15', NULL, 1, 'adf'),
(3, 'foto', 'desc', 'dir', 1, '2021-12-12 06:03:03', 123123123, '2021-06-17 22:42:26', '2021-06-17 22:42:26', NULL, 1, 'loc');

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
(1, 'Ayer vi un perro parecido en la calle x', '2020-02-02 15:12:12', 'foto', 2, 123123123, NULL, NULL, NULL),
(2, 'Hoy me conto un familiar que vio al animal en la calle x', '2020-02-02 15:12:12', 'foto', 2, 196656359, NULL, NULL, NULL),
(3, 'Perro visto a las 12:10', '2020-02-02 15:12:12', 'foto', 3, 123123123, '2021-06-17 22:50:01', '2021-06-17 22:50:01', NULL),
(4, 'ayer', '2021-04-04 08:04:04', 'foto', 1, 123123123, '2021-06-17 22:55:29', '2021-06-17 22:55:29', NULL),
(5, 'asd', '2020-02-02 15:12:12', 'fotovich', 2, 123123123, '2021-06-17 22:56:37', '2021-06-17 22:56:37', NULL),
(6, 'asf', '2020-02-02 15:12:12', 'fotooo', 2, 123123123, '2021-06-17 22:59:29', '2021-06-17 23:12:11', '2021-06-17 23:12:11'),
(7, 'aad', '2021-07-08 16:12:12', 'foto', 3, 123123123, '2021-06-17 23:00:50', '2021-06-17 23:00:50', NULL),
(8, 'Perro visto a las 12:10', '2020-02-02 15:12:12', 'foto', 2, 196656359, '2021-06-17 23:13:17', '2021-06-17 23:13:17', NULL);

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
(1, 'Muy buen local, precios baratos y accequibles', '2020-02-02 15:12:12', 'foto', 123123123, 2, NULL, NULL, NULL),
(2, 'descrp', '2020-02-02 15:12:12', 'foto', 123123123, 2, '2021-06-18 15:58:25', '2021-06-18 15:59:01', '2021-06-18 15:59:01');

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
(1, 'Gran plaza, por dios que recuerdos', '2020-02-02 15:12:12', 'foto', 3, 123123123, NULL, NULL, NULL),
(2, 'linda plaza, hartos animales', '2020-02-02 15:12:12', 'foto', 3, 196656359, '2021-06-18 16:04:08', '2021-06-18 16:04:24', '2021-06-18 16:04:24');

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
(1, 'Perro', 'Especie del can', NULL, NULL, NULL),
(2, 'Gato', 'Especie felina domestica', NULL, NULL, NULL);

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
  `updated_at` timestamp NULL DEFAULT NULL,
  `localizacion` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `hogares`
--

INSERT INTO `hogares` (`id`, `tipo_hogar`, `disponibilidad_patio`, `direccion`, `descripcion`, `foto`, `usuario_rut`, `deleted_at`, `created_at`, `updated_at`, `localizacion`) VALUES
(1, 1, 1, 'asd611', 'asj', 'foto', 123123123, NULL, '2021-06-16 21:37:57', '2021-06-16 21:37:57', '1927eyh2');

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
(1, 'ponki', 0, 7, 123123123, NULL, '2021-06-16 21:19:52', '2021-06-16 21:19:52', 0, '2020-02-02 15:12:12', '0', NULL, 'come de todo', 'tranquilo', NULL);

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
  `deleted_at` timestamp NULL DEFAULT NULL,
  `localizacion` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `negocios`
--

INSERT INTO `negocios` (`id`, `nombre`, `descripcion`, `horario`, `direccion`, `foto`, `tipo_id`, `created_at`, `updated_at`, `deleted_at`, `localizacion`) VALUES
(1, 'tesy', 'test', '2020-02-02 15:12:12', 'tsest', 'test', 2, '2021-06-17 15:22:30', '2021-06-17 15:25:12', '2021-06-17 15:25:12', 'test'),
(2, 'Don Pepe', 'Don Pepe', '2020-02-02 15:12:12', 'Jose acuña 123', 'foto', 1, '2021-06-17 23:25:21', '2021-06-17 23:25:21', NULL, '123123e 31231a');

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
(1, 1, 'admin', NULL, '2021-06-16 21:01:09', '2021-06-16 21:01:09'),
(2, 2, 'usuario', NULL, '2021-06-16 21:01:14', '2021-06-16 21:01:14'),
(3, 3, 'disabled', NULL, '2021-06-16 21:01:22', '2021-06-16 21:01:22');

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
(1, '2021-05-12 17:07:35', '2021-05-13 17:07:35', 15000, 1, NULL, 123123123, 1, NULL, NULL, 15000);

-- --------------------------------------------------------

--
-- Table structure for table `peticion_mascota`
--

CREATE TABLE `peticion_mascota` (
  `peticion_id` int NOT NULL,
  `mascota_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `peticion_mascota`
--

INSERT INTO `peticion_mascota` (`peticion_id`, `mascota_id`) VALUES
(1, 1);

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
  `usuario_rut` int NOT NULL,
  `hogar_id` int NOT NULL,
  `nota` int DEFAULT NULL,
  `comentario` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `publicaciones`
--

INSERT INTO `publicaciones` (`id`, `descripcion`, `tarifa`, `created_at`, `updated_at`, `deleted_at`, `usuario_rut`, `hogar_id`, `nota`, `comentario`) VALUES
(1, 'Test', 7500, NULL, NULL, NULL, 123123123, 1, NULL, NULL);

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
(5, 'Bulldog', 'Bulldog', NULL, 1, '2021-06-16 21:15:16', '2021-06-16 21:15:16'),
(6, 'Pastor Aleman', 'Pastor Aleman', NULL, 1, '2021-06-16 21:16:03', '2021-06-16 21:16:03'),
(7, 'Labrador', 'Labrador', NULL, 1, '2021-06-16 21:16:18', '2021-06-16 21:16:18'),
(8, 'Poodle', 'Poodle', NULL, 1, '2021-06-16 21:16:31', '2021-06-16 21:16:31'),
(9, 'Persa', 'Persa', '2021-06-16 21:17:35', 1, '2021-06-16 21:16:45', '2021-06-16 21:17:35'),
(10, 'Persa', 'Persa', NULL, 2, '2021-06-16 21:17:56', '2021-06-16 21:17:56'),
(11, 'Siames', 'Siames', NULL, 2, '2021-06-16 21:18:18', '2021-06-16 21:18:18'),
(12, 'Bengala', 'Bengala', NULL, 2, '2021-06-16 21:18:31', '2021-06-16 21:18:31'),
(13, 'Esfinge', 'Esfinge', NULL, 2, '2021-06-16 21:18:41', '2021-06-16 21:18:41');

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

--
-- Dumping data for table `tipos`
--

INSERT INTO `tipos` (`id`, `tipo_negocio`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, '2021-06-17 14:27:31', '2021-06-17 14:27:31', NULL),
(2, 2, '2021-06-17 14:28:10', '2021-06-17 14:28:10', NULL),
(3, 3, '2021-06-17 14:28:17', '2021-06-17 14:28:17', NULL),
(4, 5, '2021-06-17 14:28:22', '2021-06-17 14:28:31', '2021-06-17 14:28:31');

-- --------------------------------------------------------

--
-- Table structure for table `tipos_alertas`
--

CREATE TABLE `tipos_alertas` (
  `id` int NOT NULL,
  `tipo_alerta` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tipos_alertas`
--

INSERT INTO `tipos_alertas` (`id`, `tipo_alerta`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, '2021-06-16 20:54:13', '2021-06-16 20:54:13', NULL),
(2, 2, '2021-06-16 20:54:18', '2021-06-16 20:54:18', NULL),
(3, 4, '2021-06-16 20:54:22', '2021-06-16 20:54:49', '2021-06-16 20:54:49'),
(4, 4, '2021-06-17 14:32:20', '2021-06-17 14:32:31', '2021-06-17 14:32:31');

-- --------------------------------------------------------

--
-- Table structure for table `tipos_ubicaciones`
--

CREATE TABLE `tipos_ubicaciones` (
  `id` int NOT NULL,
  `tipo_ubicacion` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tipos_ubicaciones`
--

INSERT INTO `tipos_ubicaciones` (`id`, `tipo_ubicacion`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, '2021-06-16 20:56:44', '2021-06-16 20:56:44', NULL),
(2, 2, '2021-06-16 20:56:48', '2021-06-16 20:56:48', NULL),
(3, 4, '2021-06-16 20:56:50', '2021-06-16 20:57:05', '2021-06-16 20:57:05'),
(4, 4, '2021-06-17 14:33:13', '2021-06-17 14:33:23', '2021-06-17 14:33:23');

-- --------------------------------------------------------

--
-- Table structure for table `ubicaciones`
--

CREATE TABLE `ubicaciones` (
  `id` int NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `direccion` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `tipo_ubicacion_id` int NOT NULL,
  `localizacion` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ubicaciones`
--

INSERT INTO `ubicaciones` (`id`, `descripcion`, `foto`, `direccion`, `created_at`, `updated_at`, `deleted_at`, `tipo_ubicacion_id`, `localizacion`) VALUES
(1, 'test', 'test', 'test', '2021-06-17 15:06:23', '2021-06-17 15:07:42', '2021-06-17 15:07:42', 2, NULL),
(2, 'test', 'test', 'test', '2021-06-17 15:08:31', '2021-06-17 15:08:45', NULL, 2, 'test'),
(3, 'Plaza soto mayor', 'foto', 'Jose acuña 123', '2021-06-17 23:27:38', '2021-06-17 23:27:38', NULL, 1, '123123e 31231a');

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
(123123123, 'admin', 'admin@gmail.com', '$2y$10$jOr1PYtVl32MghOM5Lpg4OCD/3pDOtNNAONsFKJjL.9vRDyZWvXmy', '2021-06-16 21:01:29', '2021-06-16 21:20:44', 1, NULL, '2020-02-02 15:12:12', 1, 'foto', 85276822, NULL, NULL),
(196656359, 'ale', 'ale@gmail.com', '$2y$10$ivQlIWeeJ.zCDNGDtHQHEeAcSvwmRRz/p3OgfPo8z8gOMqzRa1zaS', '2021-06-16 21:02:00', '2021-06-16 21:02:00', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alertas`
--
ALTER TABLE `alertas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_alertas_usuarios1_idx` (`usuario_rut`),
  ADD KEY `fk_alertas_tipos_alertas1_idx` (`tipo_alerta_id`);

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
  ADD KEY `fk_publicaciones_usuarios1_idx` (`usuario_rut`),
  ADD KEY `fk_publicaciones_hogares1_idx` (`hogar_id`);

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
-- Indexes for table `tipos_alertas`
--
ALTER TABLE `tipos_alertas`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tipos_ubicaciones`
--
ALTER TABLE `tipos_ubicaciones`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ubicaciones`
--
ALTER TABLE `ubicaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_ubicaciones_tipos_ubicaciones1_idx` (`tipo_ubicacion_id`);

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
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `comentarios_alertas`
--
ALTER TABLE `comentarios_alertas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `comentarios_negocios`
--
ALTER TABLE `comentarios_negocios`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `comentarios_ubicaciones`
--
ALTER TABLE `comentarios_ubicaciones`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `especies`
--
ALTER TABLE `especies`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `hogares`
--
ALTER TABLE `hogares`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `mascotas`
--
ALTER TABLE `mascotas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `negocios`
--
ALTER TABLE `negocios`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `perfiles`
--
ALTER TABLE `perfiles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `peticiones`
--
ALTER TABLE `peticiones`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `publicaciones`
--
ALTER TABLE `publicaciones`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `razas`
--
ALTER TABLE `razas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `servicios`
--
ALTER TABLE `servicios`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tipos`
--
ALTER TABLE `tipos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tipos_alertas`
--
ALTER TABLE `tipos_alertas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tipos_ubicaciones`
--
ALTER TABLE `tipos_ubicaciones`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `ubicaciones`
--
ALTER TABLE `ubicaciones`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `alertas`
--
ALTER TABLE `alertas`
  ADD CONSTRAINT `fk_alertas_tipos_alertas1` FOREIGN KEY (`tipo_alerta_id`) REFERENCES `tipos_alertas` (`id`),
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
  ADD CONSTRAINT `fk_publicaciones_hogares1` FOREIGN KEY (`hogar_id`) REFERENCES `hogares` (`id`),
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
-- Constraints for table `ubicaciones`
--
ALTER TABLE `ubicaciones`
  ADD CONSTRAINT `fk_ubicaciones_tipos_ubicaciones1` FOREIGN KEY (`tipo_ubicacion_id`) REFERENCES `tipos_ubicaciones` (`id`);

--
-- Constraints for table `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_users_perfiles1` FOREIGN KEY (`perfil_id`) REFERENCES `perfiles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
