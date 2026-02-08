-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 08-02-2026 a las 03:20:47
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
-- Base de datos: `musiclab_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `followers`
--

CREATE TABLE `followers` (
  `id` int(11) NOT NULL,
  `follower_id` int(11) NOT NULL,
  `followed_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `followers`
--

INSERT INTO `followers` (`id`, `follower_id`, `followed_id`) VALUES
(1, 1, 2),
(2, 1, 3),
(3, 4, 1),
(5, 5, 4),
(6, 6, 1),
(7, 7, 6),
(8, 8, 7),
(9, 9, 8),
(10, 10, 9);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `posts`
--

CREATE TABLE `posts` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `file_url` varchar(255) NOT NULL,
  `file_type` enum('audio','lyrics','score') NOT NULL,
  `visibility` enum('public','followers','private') NOT NULL DEFAULT 'public',
  `destination_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `posts`
--
DELIMITER $$
CREATE TRIGGER `check_follower_destination` BEFORE INSERT ON `posts` FOR EACH ROW BEGIN
    IF NEW.visibility = 'followers' AND NEW.destination_id IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: destination_id es obligatorio cuando la visibilidad es followers';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `site_config`
--

CREATE TABLE `site_config` (
  `id` int(11) NOT NULL,
  `site_name` varchar(100) NOT NULL,
  `maintenance_mode` tinyint(1) DEFAULT 0,
  `welcome_text` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `site_config`
--

INSERT INTO `site_config` (`id`, `site_name`, `maintenance_mode`, `welcome_text`) VALUES
(1, 'MusicLab', 0, 'Collaborate with musicians from all over the world');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` int(11) DEFAULT 0,
  `artist_type` varchar(100) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `profile_img_url` varchar(255) DEFAULT 'default_profile.png',
  `status` tinyint(4) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `artist_type`, `bio`, `profile_img_url`, `status`, `created_at`) VALUES
(1, 'Bautista', 'Rodriguez', 'bautista.owner@gmail.com', '$2y$10$suO72wgsmAXFCuUF/jk47eXepUINbCZmam/zFmSyFYAXyGo5yaYqa', 2, 'Another', 'Dueño y creador de MusicLab.', 'owner.png', 0, '2026-02-06 22:38:11'),
(2, 'Lucas', 'Admin', 'lucas.admin@gmail.com', '$2y$10$suO72wgsmAXFCuUF/jk47eXepUINbCZmam/zFmSyFYAXyGo5yaYqa', 1, 'Pianist', 'Administrador del sistema.', 'default_profile.png', 0, '2026-02-06 22:38:11'),
(3, 'Sofia', 'Admin', 'sofia.admin@gmail.com', '$2y$10$suO72wgsmAXFCuUF/jk47eXepUINbCZmam/zFmSyFYAXyGo5yaYqa', 1, 'Guitarist', 'Soporte y moderación.', 'default_profile.png', 0, '2026-02-06 22:38:11'),
(4, 'Marcos', 'User', 'marcos.user@gmail.com', '$2y$10$suO72wgsmAXFCuUF/jk47eXepUINbCZmam/zFmSyFYAXyGo5yaYqa', 0, 'Vocalist', 'Cantante buscando banda.', 'default_profile.png', 0, '2026-02-06 22:38:11'),
(5, 'Julieta', 'User', 'julieta.user@gmail.com', '$2y$10$suO72wgsmAXFCuUF/jk47eXepUINbCZmam/zFmSyFYAXyGo5yaYqa', 0, 'Drummer', 'Baterista de sesión.', 'default_profile.png', 0, '2026-02-06 22:38:11'),
(6, 'Valentina', 'Lopez', 'valentina.user@gmail.com', '$2y$10$suO72wgsmAXFCuUF/jk47eXepUINbCZmam/zFmSyFYAXyGo5yaYqa', 0, 'Violinist', 'Amante de la música clásica y fusiones.', 'default_profile.png', 0, '2026-02-07 15:36:11'),
(7, 'Mateo', 'Goncalvez', 'mateo.user@gmail.com', '$2y$10$suO72wgsmAXFCuUF/jk47eXepUINbCZmam/zFmSyFYAXyGo5yaYqa', 0, 'Bassist', 'Bajista de funk y jazz.', 'default_profile.png', 0, '2026-02-07 15:36:11'),
(8, 'Camila', 'Fernandez', 'camila.user@gmail.com', '$2y$10$suO72wgsmAXFCuUF/jk47eXepUINbCZmam/zFmSyFYAXyGo5yaYqa', 0, 'DJ', 'Produciendo beats desde mi habitación.', 'default_profile.png', 0, '2026-02-07 15:36:11'),
(9, 'Santiago', 'Ruiz', 'santiago.user@gmail.com', '$2y$10$suO72wgsmAXFCuUF/jk47eXepUINbCZmam/zFmSyFYAXyGo5yaYqa', 0, 'DJ', 'Mezclando house y techno.', 'default_profile.png', 0, '2026-02-07 15:36:11'),
(10, 'Lucia', 'Martinez', 'lucia.user@gmail.com', '$2y$10$suO72wgsmAXFCuUF/jk47eXepUINbCZmam/zFmSyFYAXyGo5yaYqa', 0, 'Saxophonist', 'Jazz vibes only.', 'default_profile.png', 0, '2026-02-07 15:36:11'),
(11, 'Nicolas', 'Alvarez', 'nicolas.user@gmail.com', '$2y$10$suO72wgsmAXFCuUF/jk47eXepUINbCZmam/zFmSyFYAXyGo5yaYqa', 0, 'Pianist', 'Freestyle y letras con sentido.', 'default_profile.png', 0, '2026-02-07 15:36:11'),
(12, 'Elena', 'Gomez', 'elena.user@gmail.com', '$2y$10$suO72wgsmAXFCuUF/jk47eXepUINbCZmam/zFmSyFYAXyGo5yaYqa', 0, 'Pianist', 'Compositora de melodías tristes.', 'default_profile.png', 0, '2026-02-07 15:36:11'),
(13, 'Joaquin', 'Perez', 'joaquin.user@gmail.com', '$2y$10$suO72wgsmAXFCuUF/jk47eXepUINbCZmam/zFmSyFYAXyGo5yaYqa', 0, 'Guitarist', 'Rock and Roll forever.', 'default_profile.png', 0, '2026-02-07 15:36:11'),
(14, 'Mariana', 'Silva', 'mariana.user@gmail.com', '$2y$10$suO72wgsmAXFCuUF/jk47eXepUINbCZmam/zFmSyFYAXyGo5yaYqa', 0, 'Vocalist', 'Soprano en entrenamiento.', 'default_profile.png', 0, '2026-02-07 15:36:11'),
(15, 'Federico', 'Torres', 'federico.user@gmail.com', '$2y$10$suO72wgsmAXFCuUF/jk47eXepUINbCZmam/zFmSyFYAXyGo5yaYqa', 0, 'Drummer', 'Ritmos complejos y percusión latina.', 'default_profile.png', 0, '2026-02-07 15:36:11');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `followers`
--
ALTER TABLE `followers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_follow` (`follower_id`,`followed_id`),
  ADD KEY `fk_followed` (`followed_id`);

--
-- Indices de la tabla `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `posts_user_fk` (`user_id`),
  ADD KEY `fk_post_destination_user` (`destination_id`);

--
-- Indices de la tabla `site_config`
--
ALTER TABLE `site_config`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `followers`
--
ALTER TABLE `followers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `site_config`
--
ALTER TABLE `site_config`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `followers`
--
ALTER TABLE `followers`
  ADD CONSTRAINT `fk_followed` FOREIGN KEY (`followed_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_follower` FOREIGN KEY (`follower_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `fk_post_destination_user` FOREIGN KEY (`destination_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `posts_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
