-- phpMyAdmin SQL Dump
-- version 4.4.15.1
-- http://www.phpmyadmin.net
--
-- Host: mysql742.umbler.com
-- Generation Time: 03-Jul-2021 às 21:55
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
  `nomeGrupo` varchar(45) DEFAULT NULL
);

--
-- Extraindo dados da tabela `tbl_grupo`
--

INSERT INTO `tbl_grupo` (`id`, `nomeGrupo`) VALUES
(1, 'SEM GRUPO');


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
  `estadoCivil` varchar(30) DEFAULT NULL,
  `grupo` varchar(30) DEFAULT NULL,
  `isBatizada` varchar(10) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `DataSelecionada` date DEFAULT NULL,
  `createdDate` datetime DEFAULT NULL,
  `idUsuario` int(11) DEFAULT NULL,
  `idGrupo` int(11) DEFAULT NULL
);

--
-- Extraindo dados da tabela `tbl_pessoas`
--

INSERT INTO `tbl_pessoas` (`id`, `nomePessoa`, `enderecoPessoa`, `numeroPessoa`, `bairroPessoa`, `cepPessoa`, `cidadePessoa`, `celularPessoa`, `membroObreiro`, `prBatizou`, `estadoCivil`, `grupo`, `isBatizada`, `image`, `DataSelecionada`, `createdDate`, `idUsuario`, `idGrupo`) VALUES
(201, 'UFP', 'Rua Teste', '123456', 'Jd Teste', '13276-280', 'Valinhos', '19983975315', 'Obreiro', 'NÃ£o informado', 'Solteiro', 'FJU', 'NÃ£o', 'romeuejulieta_1625325495971.jpg', '2021-07-03', '2021-07-03 12:18:29', 1, 2),
(214, 'Romeu e Julieta', 'Rua Teste', '123456', 'Jd Teste', '13276-280', 'Valinhos', '19983975315', 'Membro', 'NÃ£o informado', 'Solteiro', 'EVG', 'NÃ£o', 'placeholder.jpeg', '2021-07-03', '2021-07-03 14:47:47', 1, 2),
(215, 'Romeu e Julieta', 'Rua Teste', '123456', 'Jd Teste', '13276-280', 'Valinhos', '19983975315', 'Membro', 'NÃ£o informado', 'Solteiro', 'SEM GRUPO', 'NÃ£o', 'placeholder.jpeg', '2021-07-03', '2021-07-03 21:38:19', 1, 1);

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
);

--
-- Extraindo dados da tabela `tbl_usuarios`
--

INSERT INTO `tbl_usuarios` (`id`, `usuario`, `senha`, `levelUser`, `nome`, `statusUser`, `createdDate`) VALUES
(1, 'dionebatistap@gmail.com', '202cb962ac59075b964b07152d234b70', '1', 'Dione Batista', 'ativo', '2021-06-15 00:02:01');

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
  ADD KEY `idGrupo` (`idGrupo`),
  ADD KEY `idUsuario` (`idUsuario`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `tbl_pessoas`
--
ALTER TABLE `tbl_pessoas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=216;
--
-- AUTO_INCREMENT for table `tbl_usuarios`
--
ALTER TABLE `tbl_usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- Constraints for dumped tables
--

--
-- Limitadores para a tabela `tbl_pessoas`
--
ALTER TABLE `tbl_pessoas`
  ADD CONSTRAINT `tbl_pessoas_ibfk_1` FOREIGN KEY (`idGrupo`) REFERENCES `tbl_grupo` (`id`),
  ADD CONSTRAINT `tbl_pessoas_ibfk_2` FOREIGN KEY (`idUsuario`) REFERENCES `tbl_usuarios` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
