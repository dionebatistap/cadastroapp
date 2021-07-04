CREATE TABLE IF NOT EXISTS `tbl_grupo` (
  `id` int(11) AUTO_INCREMENT PRIMARY KEY,
  `nomeGrupo` varchar(45) DEFAULT NULL
);

INSERT INTO `tbl_grupo` (`id`, `nomeGrupo`) VALUES
(1, 'SEM GRUPO');

CREATE TABLE IF NOT EXISTS `tbl_usuarios` (
  `id` int(11) AUTO_INCREMENT PRIMARY KEY,
  `usuario` varchar(50) DEFAULT NULL,
  `senha` varchar(50) DEFAULT NULL,
  `levelUser` varchar(10) DEFAULT NULL,
  `nome` varchar(80) DEFAULT NULL,
  `statusUser` varchar(10) DEFAULT NULL,
  `createdDate` datetime DEFAULT NULL
);

INSERT INTO `tbl_usuarios` (`id`, `usuario`, `senha`, `levelUser`, `nome`, `statusUser`, `createdDate`) VALUES
(1, 'admin@admin', '202cb962ac59075b964b07152d234b70', '1', 'Admin', 'ativo', '2021-06-15 00:02:01');

CREATE TABLE IF NOT EXISTS `tbl_pessoas` (
  `id` int(11) AUTO_INCREMENT PRIMARY KEY,
  `nomePessoa` varchar(255) DEFAULT NULL,
  `enderecoPessoa` varchar(255) DEFAULT NULL,
  `numeroPessoa` varchar(45) DEFAULT NULL,
  `bairroPessoa` varchar(45) DEFAULT NULL,
  `cepPessoa` varchar(45) DEFAULT NULL,
  `cidadePessoa` varchar(45) DEFAULT NULL,
  `celularPessoa` varchar(25) DEFAULT NULL,
  `membroObreiro` varchar(15) DEFAULT NULL,
  `prBatizou` varchar(30) DEFAULT NULL,
  `estadoCivil` varchar(30) DEFAULT NULL,
  `grupo` varchar(30) DEFAULT NULL,
  `isBatizada` varchar(10) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `DataSelecionada` date DEFAULT NULL,
  `createdDate` datetime DEFAULT NULL,
  `idUsuario` int(11) DEFAULT NULL,
  `idGrupo` int(11) DEFAULT NULL,
  FOREIGN KEY (idGrupo) REFERENCES tbl_grupo(id),
   FOREIGN KEY (idUsuario) REFERENCES tbl_usuarios(id) 
);


-- INSERT INTO `tbl_pessoas` (`id`, `nomePessoa`, `enderecoPessoa`, `numeroPessoa`, `bairroPessoa`, `cepPessoa`, `cidadePessoa`, `celularPessoa`, `membroObreiro`, `prBatizou`, `estadoCivil`, `grupo`, `isBatizada`, `image`, `DataSelecionada`, `createdDate`, `idUsuario`,`idGrupo`) VALUES
-- (198, 'Usuario para teste', 'Rua Clark', '1200', 'Macuco', '13279-400', 'Valinhos', '(19)98397-5315', 'Membro', 'Pr. Teste', 'Solteiro', 'FJU', 'Sim', 'placeholder.jpeg', '2021-07-01', '2021-06-28 22:49:03', 1,1);