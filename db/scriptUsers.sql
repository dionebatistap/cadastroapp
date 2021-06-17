CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL,
  `usuario` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `senha` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `level` int(11) DEFAULT NULL,
  `nome` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `status` int(11) DEFAULT NULL,
  `createdDate` datetime DEFAULT NULL
)
