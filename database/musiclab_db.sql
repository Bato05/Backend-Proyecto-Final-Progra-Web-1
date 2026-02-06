-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 06-02-2026 a las 15:38:10
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
-- Estructura de tabla para la tabla `posts`
--

CREATE TABLE `posts` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `file_url` varchar(255) NOT NULL,
  `file_type` enum('audio','score','lyrics') NOT NULL,
  `visibility` enum('public','private','followers') DEFAULT 'public',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `posts`
--

INSERT INTO `posts` (`id`, `user_id`, `title`, `description`, `file_url`, `file_type`, `visibility`, `created_at`) VALUES
(1, 1, 'Bienvenida a MusicLab', 'Presentación oficial del proyecto.', 'welcome.txt', 'lyrics', 'public', '2026-02-06 13:35:48'),
(2, 1, 'Roadmap 2026', 'Objetivos y mejoras planeadas.', 'roadmap_2026.txt', 'lyrics', 'public', '2026-02-06 13:35:48'),
(3, 1, 'Demo plataforma', 'Audio de prueba interno.', 'demo_owner.mp3', 'audio', 'public', '2026-02-06 13:35:48'),
(4, 2, 'Reglas del foro', 'Lectura obligatoria para todos.', 'rules_v1.pdf', 'score', 'public', '2026-02-06 13:35:48'),
(5, 2, 'Criterios de moderación', 'Guía interna del staff.', 'moderation.txt', 'lyrics', 'private', '2026-02-06 13:35:48'),
(6, 3, 'Guía de soporte', 'Cómo reportar problemas.', 'support_guide.pdf', 'score', 'public', '2026-02-06 13:35:48'),
(7, 3, 'Gestión de contenido', 'Buenas prácticas editoriales.', 'content_guidelines.txt', 'lyrics', 'public', '2026-02-06 13:35:48'),
(8, 4, 'Riff de guitarra', 'Probando un riff nuevo.', 'riff_lucas.mp3', 'audio', 'public', '2026-02-06 13:35:48'),
(9, 4, 'Letra en progreso', 'Borrador de canción.', 'letra_lucas.txt', 'lyrics', 'public', '2026-02-06 13:35:48'),
(10, 5, 'Ensayo vocal', 'Práctica de la tarde.', 'ensayo_sofia.mp3', 'audio', 'public', '2026-02-06 13:35:48'),
(11, 5, 'Letra soul', 'Nueva letra estilo soul.', 'soul_lyrics.txt', 'lyrics', 'public', '2026-02-06 13:35:48'),
(12, 6, 'Bass line jazz', 'Línea de bajo para proyecto jazz.', 'bass_jazz.mp3', 'audio', 'public', '2026-02-06 13:35:48'),
(13, 6, 'Notas de ensayo', 'Ideas para mejorar groove.', 'bass_notes.txt', 'lyrics', 'public', '2026-02-06 13:35:48'),
(14, 7, 'Partitura clásica', 'Obra para violín solo.', 'violin_score.pdf', 'score', 'public', '2026-02-06 13:35:48'),
(15, 7, 'Fusión electrónica', 'Ideas clásicas + electrónica.', 'fusion_lucia.txt', 'lyrics', 'public', '2026-02-06 13:35:48'),
(16, 8, 'Set techno', 'Set progresivo nocturno.', 'techno_set.mp3', 'audio', 'public', '2026-02-06 13:35:48'),
(17, 8, 'Notas de producción', 'Estructura del próximo track.', 'prod_notes.txt', 'lyrics', 'public', '2026-02-06 13:35:48'),
(18, 9, 'Demo R&B', 'Voz y armonías suaves.', 'demo_rnb.mp3', 'audio', 'public', '2026-02-06 13:35:48'),
(19, 9, 'Letra emocional', 'Inspirada en experiencias personales.', 'letra_valentina.txt', 'lyrics', 'public', '2026-02-06 13:35:48'),
(20, 10, 'Groove funk', 'Patrón rítmico funk.', 'funk_groove.mp3', 'audio', 'public', '2026-02-06 13:35:48'),
(21, 10, 'Rudimentos', 'Ejercicios diarios.', 'rudimentos.txt', 'lyrics', 'public', '2026-02-06 13:35:48'),
(22, 11, 'Tema instrumental', 'Composición para piano.', 'piano_theme.mp3', 'audio', 'public', '2026-02-06 13:35:48'),
(23, 11, 'Idea soundtrack', 'Boceto para cine.', 'soundtrack_idea.txt', 'lyrics', 'public', '2026-02-06 13:35:48'),
(24, 12, 'Pedales DIY', 'Probando cadena de efectos.', 'pedales_diy.mp3', 'audio', 'public', '2026-02-06 13:35:48'),
(25, 12, 'Setup actual', 'Configuración de equipo.', 'setup_nico.txt', 'lyrics', 'public', '2026-02-06 13:35:48'),
(26, 13, 'Blues moderno', 'Improvisación en sax.', 'blues_sax.mp3', 'audio', 'public', '2026-02-06 13:35:48'),
(27, 13, 'Escalas favoritas', 'Ejercicios diarios.', 'escalas_sax.txt', 'lyrics', 'public', '2026-02-06 13:35:48'),
(28, 14, 'Mezcla rock', 'Antes y después de la mezcla.', 'mix_rock.mp3', 'audio', 'public', '2026-02-06 13:35:48'),
(29, 14, 'Tips de mastering', 'Consejos básicos.', 'mastering_tips.txt', 'lyrics', 'public', '2026-02-06 13:35:48'),
(30, 15, 'Cover rock nacional', 'Versión acústica.', 'cover_rock.mp3', 'audio', 'public', '2026-02-06 13:35:48'),
(31, 15, 'Letra propia', 'Canción inspirada en los 90.', 'letra_paula.txt', 'lyrics', 'public', '2026-02-06 13:35:48');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
