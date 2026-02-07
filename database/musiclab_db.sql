-- Configuración de compatibilidad y entorno
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- Desactivar restricciones de llaves foráneas para permitir limpieza profunda
SET FOREIGN_KEY_CHECKS = 0;

-- 1. LIMPIEZA TOTAL (Evita errores de "Table already exists")
DROP TABLE IF EXISTS `shared_content`;
DROP TABLE IF EXISTS `followers`;
DROP TABLE IF EXISTS `posts`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `site_config`;

-- 2. CREACIÓN DE ESTRUCTURA (Con cotejamiento estándar utf8mb4)

CREATE TABLE `site_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `site_name` varchar(100) NOT NULL,
  `maintenance_mode` tinyint(1) DEFAULT 0,
  `welcome_text` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` int(11) DEFAULT 0,
  `artist_type` varchar(100) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `profile_img_url` varchar(255) DEFAULT 'default_profile.png',
  `status` tinyint(4) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `file_url` varchar(255) NOT NULL,
  `file_type` enum('audio','lyrics','score') NOT NULL,
  `visibility` enum('public','followers','private') NOT NULL DEFAULT 'public',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `posts_user_fk` (`user_id`),
  CONSTRAINT `posts_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `followers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `follower_id` int(11) NOT NULL,
  `followed_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_follow` (`follower_id`,`followed_id`),
  KEY `fk_followed` (`followed_id`),
  CONSTRAINT `fk_followed` FOREIGN KEY (`followed_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_follower` FOREIGN KEY (`follower_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `shared_content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NOT NULL,
  `target_user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `post_id` (`post_id`),
  KEY `target_user_id` (`target_user_id`),
  CONSTRAINT `shared_content_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `shared_content_ibfk_2` FOREIGN KEY (`target_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 3. INSERCIÓN DE DATOS

INSERT INTO `site_config` (`id`, `site_name`, `maintenance_mode`, `welcome_text`) VALUES
(1, 'MusicLab', 0, 'Collaborate with musicians from all over the world');

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

-- Ajustar AUTO_INCREMENT para los siguientes registros
ALTER TABLE `users` AUTO_INCREMENT = 16;

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

-- Reactivar chequeos y finalizar transacción
SET FOREIGN_KEY_CHECKS = 1;
COMMIT;