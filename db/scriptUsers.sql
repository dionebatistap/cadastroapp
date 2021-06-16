CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL,
  `username` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `password` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `level` int(11) DEFAULT NULL,
  `nama` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `status` int(11) DEFAULT NULL,
  `createdDate` datetime DEFAULT NULL
)