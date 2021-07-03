-- phpMyAdmin SQL Dump
-- version 4.4.15.1
-- http://www.phpmyadmin.net
--
-- Host: mysql742.umbler.com
-- Generation Time: 02-Jul-2021 às 17:00
-- Versão do servidor: 5.6.50
-- PHP Version: 5.4.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `apitestedione`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `tbl_grupo`
--

CREATE TABLE IF NOT EXISTS `tbl_grupo` (
  `id` int(11) NOT NULL,
  `nomeGrupo` varchar(45) CHARACTER SET latin1 DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `tbl_grupo`
--

INSERT INTO `tbl_grupo` (`id`, `nomeGrupo`) VALUES
(1, 'FJU'),
(6, 'UFP'),
(7, 'UNISOCIAL'),
(8, 'SEM GRUPO'),
(11, 'TESTE');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tbl_pessoas`
--

CREATE TABLE IF NOT EXISTS `tbl_pessoas` (
  `id` int(11) NOT NULL,
  `nomePessoa` text,
  `enderecoPessoa` varchar(255) DEFAULT NULL,
  `numeroPessoa` varchar(45) DEFAULT NULL,
  `bairroPessoa` varchar(45) DEFAULT NULL,
  `cepPessoa` varchar(45) DEFAULT NULL,
  `cidadePessoa` varchar(45) DEFAULT NULL,
  `celularPessoa` varchar(25) DEFAULT NULL,
  `membroObreiro` varchar(15) DEFAULT NULL,
  `prBatizou` varchar(30) DEFAULT NULL,
  `estadoCivil` text,
  `grupo` text,
  `isBatizada` varchar(10) DEFAULT NULL,
  `image` text,
  `DataSelecionada` date DEFAULT NULL,
  `createdDate` datetime DEFAULT NULL,
  `idUsuario` int(11) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=222 DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `tbl_pessoas`
--

INSERT INTO `tbl_pessoas` (`id`, `nomePessoa`, `enderecoPessoa`, `numeroPessoa`, `bairroPessoa`, `cepPessoa`, `cidadePessoa`, `celularPessoa`, `membroObreiro`, `prBatizou`, `estadoCivil`, `grupo`, `isBatizada`, `image`, `DataSelecionada`, `createdDate`, `idUsuario`) VALUES
(198, 'FJU-MEMBRO2', 'Rua Clark', '1200', 'Macuco', '13279-400', 'Valinhos', '(19)98397-5315', 'Membro', 'Juca', 'Solteiro', 'FJU', 'Sim', 'placeholder.jpeg', '2021-07-01', '2021-06-28 22:49:03', 7),
(211, 'FJU-MEMBRO', 'Gghh', '55558', 'Fcfggg', '56666-666', 'Fgggggg', '(55)55555-5588', 'Membro', 'Ggggggg', 'Solteiro', 'FJU', 'NÃ£o', 'placeholder.jpeg', '2021-06-30', '2021-06-29 14:03:02', 7),
(212, 'UFP-OBREIRO', 'Gghh', '55558', 'Fcfggg', '56666-666', 'Fgggggg', '(55)55555-5588', 'Obreiro', 'Ggggggg', 'Solteiro', 'UFP', 'NÃ£o', 'placeholder.jpeg', '2021-06-30', '2021-06-29 14:03:02', 7),
(213, 'UFP-Test', 'Gghh', '55558', 'Fcfggg', '56666-666', 'Fgggggg', '(55)55555-5588', 'Obreiro', 'Ggggggg', 'Solteiro', 'SEM GRUPO', 'NÃ£o', 'placeholder.jpeg', '2021-07-01', '2021-06-29 14:03:02', 7),
(214, 'UFP-MEMBRO', 'Gghh', '55558', 'Fcfggg', '56666-666', 'Fgggggg', '(55)55555-5588', 'Membro', 'Ggggggg', 'Solteiro', 'UFP', 'NÃ£o', 'placeholder.jpeg', '2021-06-30', '2021-06-29 14:03:02', 7),
(215, 'SEMGRUPO-OBREIRO', 'Gghh', '55558', 'Fcfggg', '56666-666', 'Fgggggg', '(55)55555-5588', 'Obreiro', 'Ggggggg', 'Solteiro', 'SEM GRUPO', 'NÃ£o', 'placeholder.jpeg', '2021-06-30', '2021-06-29 14:03:02', 7),
(216, 'UNISOCIAL-OBREIRO', 'Gghh', '55558', 'Fcfggg', '56666-666', 'Fgggggg', '(55)55555-5588', 'Obreiro', 'Ggggggg', 'Solteiro', 'UNISOCIAL', 'NÃ£o', 'placeholder.jpeg', '2021-06-30', '2021-06-29 14:03:02', 7),
(217, 'FJU-OBREIRO', 'Gghh', '55558', 'Fcfggg', '56666-666', 'Fgggggg', '(55)55555-5588', 'Obreiro', 'Ggggggg', 'Solteiro', 'FJU', 'NÃ£o', 'placeholder.jpeg', '2021-06-30', '2021-06-29 14:03:02', 7),
(218, 'Dfghhh', 'Xfggghhhj', '5555666', 'Cfgggh', '12335-580', 'Ddffg', '(45)55668-8888', 'Membro', 'Dfgggghhjj', 'Solteiro', 'UFP', 'Sim', 'yhggg_1625195762408.jpg', '2021-07-02', '2021-07-02 00:10:04', 7),
(219, 'Yhjjj', 'Cghhh', '85558556', 'Ccgghhhh', '85566-666', 'Ccgghhhhhh', '(88)55555-5555', 'Membro', 'Ggggggg', 'Solteiro', 'UNISOCIAL', 'NÃ£o', 'yhggg_1625195762408.jpg', '2021-07-02', '2021-07-02 00:13:28', 7),
(220, 'Yhggg', 'Cvvvggg', '5588', 'Fhhc', '56688-888', 'Fgvvv', '(56)68888-8855', 'Membro', 'Fvvcc', 'Solteiro', 'UNISOCIAL', 'NÃ£o', 'yhggg_1625195762408.jpg', '2021-07-02', '2021-07-02 00:16:30', 7),
(221, 'Fghbv', 'Cggg', '8566', 'Cgg', '88888-888', 'Fggv', '(88)88888-888', 'Membro', 'Ccfcvv', 'Solteiro', 'UNISOCIAL', 'NÃ£o', 'placeholder.jpeg', '2021-07-02', '2021-07-02 00:18:25', 7);

-- --------------------------------------------------------

--
-- Estrutura da tabela `tbl_usuarios`
--

CREATE TABLE IF NOT EXISTS `tbl_usuarios` (
  `id` int(11) NOT NULL,
  `usuario` varchar(50) DEFAULT NULL,
  `senha` varchar(50) DEFAULT NULL,
  `levelUser` varchar(10) DEFAULT NULL,
  `nome` varchar(80) DEFAULT NULL,
  `statusUser` varchar(10) DEFAULT NULL,
  `createdDate` datetime DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `tbl_usuarios`
--

INSERT INTO `tbl_usuarios` (`id`, `usuario`, `senha`, `levelUser`, `nome`, `statusUser`, `createdDate`) VALUES
(7, 'dionebatistap@gmail.com', '202cb962ac59075b964b07152d234b70', '1', 'Dione Batista', 'ativo', '2021-06-15 00:02:01'),
(26, 'teste@gmail.com', '8e7a13ec3c215a03de353f5806fcdd89', '3', 'NÃ­vel 3', 'ativo', '2021-06-26 23:46:13'),
(27, 'admin@admin.com', 'e10adc3949ba59abbe56e057f20f883e', '2', 'Jyca', 'ativo', '2021-06-30 12:02:41');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_grupo`
--
ALTER TABLE `tbl_grupo`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_pessoas`
--
ALTER TABLE `tbl_pessoas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idUsers` (`idUsuario`);

--
-- Indexes for table `tbl_usuarios`
--
ALTER TABLE `tbl_usuarios`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_grupo`
--
ALTER TABLE `tbl_grupo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT for table `tbl_pessoas`
--
ALTER TABLE `tbl_pessoas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=222;
--
-- AUTO_INCREMENT for table `tbl_usuarios`
--
ALTER TABLE `tbl_usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=28;
--
-- Constraints for dumped tables
--

--
-- Limitadores para a tabela `tbl_pessoas`
--
ALTER TABLE `tbl_pessoas`
  ADD CONSTRAINT `tbl_pessoas_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `tbl_usuarios` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
