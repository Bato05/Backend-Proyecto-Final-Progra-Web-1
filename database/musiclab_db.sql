SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `shared_content`;
DROP TABLE IF EXISTS `messages`;
DROP TABLE IF EXISTS `posts`;
DROP TABLE IF EXISTS `followers`;
DROP TABLE IF EXISTS `site_config`;
DROP TABLE IF EXISTS `users`;
SET FOREIGN_KEY_CHECKS = 1;

-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 22-01-2026 a las 17:55:19
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
  `followed_id` int(11) NOT NULL,
  `status` enum('pending','accepted') DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `followers`
--

INSERT INTO `followers` (`id`, `follower_id`, `followed_id`, `status`) VALUES
(1, 4, 1, 'accepted'),
(2, 5, 4, 'accepted');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `messages`
--

INSERT INTO `messages` (`id`, `sender_id`, `receiver_id`, `content`, `is_read`, `created_at`) VALUES
(1, 1, 4, 'Bienvenido a MusicLab, Julian.', 0, '2026-01-22 16:25:49'),
(2, 4, 1, 'Gracias por la invitación.', 0, '2026-01-22 16:25:49');

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
  `file_type` enum('audio','lyric','score') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `posts`
--

INSERT INTO `posts` (`id`, `user_id`, `title`, `description`, `file_url`, `file_type`, `created_at`) VALUES
(1, 4, 'Nueva Demo Rock', 'Un adelanto de mi próximo EP.', 'audio_demo_1.mp3', 'audio', '2026-01-22 16:25:49'),
(2, 5, 'Partitura Nocturno', 'Mi arreglo para piano.', 'nocturno_Chopin.pdf', 'score', '2026-01-22 16:25:49');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `shared_content`
--

CREATE TABLE `shared_content` (
  `id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `target_user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `site_config`
--

CREATE TABLE `site_config` (
  `id` int(11) NOT NULL CHECK (`id` = 1),
  `site_name` varchar(100) NOT NULL,
  `active_css_theme` varchar(50) NOT NULL,
  `accent_color` varchar(7) DEFAULT '#007bff',
  `maintenance_mode` tinyint(1) DEFAULT 0,
  `logo_url` varchar(255) DEFAULT NULL,
  `welcome_text` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `site_config`
--

INSERT INTO `site_config` (`id`, `site_name`, `active_css_theme`, `accent_color`, `maintenance_mode`, `logo_url`, `welcome_text`) VALUES
(1, 'MusicLab', 'dark_theme', '#007bff', 0, NULL, 'Bienvenido a la red de artistas.');

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
  `role` tinyint(4) NOT NULL DEFAULT 0,
  `artist_type` varchar(50) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `profile_img_url` varchar(255) DEFAULT 'default_profile.png',
  `status` enum('active','suspended') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `artist_type`, `bio`, `profile_img_url`, `status`, `created_at`) VALUES
(1, 'Bautista', 'Rodriguez', 'owner@gmail.com', '$2y$10$caqokU3g7s9R1nCzomrIs.DHlv4z8ruZDxUwHPFsndgFjYpVa7sm.', 2, 'Developer', 'Creador de MusicLab.', 'default_profile.png', 'active', '2026-01-22 16:25:49'),
(2, 'Carlos', 'Admin', 'carlos@admin.com', '$2y$10$.of5E0Gdgnui8vdsc/hlzuP2POUm3P/DwW6CwQHSlIKc1qTmsvYmy', 1, 'Moderator', 'Gestión de comunidad.', 'default_profile.png', 'active', '2026-01-22 16:25:49'),
(3, 'Elena', 'Gomez', 'elena@admin.com', '$2y$10$28Ncf5w6eUClpAVhZz9XbOt2oS87r9SnkChrni1QmE6PL7QMJoIuG', 1, 'Producer', 'Revisión de contenido.', 'default_profile.png', 'active', '2026-01-22 16:25:49'),
(4, 'Julian', 'Casablancas', 'julian@user.com', '$2y$10$8oZbF7nMslZ8W/2PfxxDAO90v.JH0ezJBrNefEksB8aZe2fiWit0q', 0, 'Singer', 'Vocalista.', 'default_profile.png', 'active', '2026-01-22 16:25:49'),
(5, 'Mariana', 'Sosa', 'mariana@user.com', '$2y$10$fY21LW2wLEGgxduSVpCcIulsrTcuw9HOJawvJ/Xzos90DPXyOnkKm', 0, 'Pianist', 'Pianista clásica.', 'default_profile.png', 'active', '2026-01-22 16:25:49'),
(6, 'Kevin', 'Parker', 'kevin@user.com', '$2y$10$G285tBKLpivx02c6qjoIMe.mTH1iDBEnrYvBkVtZMDeLIFr7lOM4W', 0, 'Multi-instrumentalist', 'Tame Impala vibes.', 'default_profile.png', 'active', '2026-01-22 16:25:49');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `followers`
--
ALTER TABLE `followers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `follower_id` (`follower_id`),
  ADD KEY `followed_id` (`followed_id`);

--
-- Indices de la tabla `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `receiver_id` (`receiver_id`);

--
-- Indices de la tabla `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `shared_content`
--
ALTER TABLE `shared_content`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_id` (`post_id`),
  ADD KEY `target_user_id` (`target_user_id`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `shared_content`
--
ALTER TABLE `shared_content`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `followers`
--
ALTER TABLE `followers`
  ADD CONSTRAINT `followers_ibfk_1` FOREIGN KEY (`follower_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `followers_ibfk_2` FOREIGN KEY (`followed_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `shared_content`
--
ALTER TABLE `shared_content`
  ADD CONSTRAINT `shared_content_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `shared_content_ibfk_2` FOREIGN KEY (`target_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


/******credenciales*******/

/*

Rol	Usuario	Email	Contraseña (Texto Plano)

owner bautista owner@gmail.com admin123
Admin	Carlos Admin	carlos@admin.com	password
Admin	Elena Gomez	elena@admin.com	elena2026
Artista	Julian Casablancas	julian@user.com	strokes123
Artista	Mariana Sosa	mariana@user.com	piano456
Artista	Kevin Parker	kevin@user.com	psych123

*/