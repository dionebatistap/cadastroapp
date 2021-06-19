-- phpMyAdmin SQL Dump
-- version 4.4.15.1
-- http://www.phpmyadmin.net
--
-- Host: mysql742.umbler.com
-- Generation Time: 17-Jun-2021 às 17:41
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
-- Estrutura da tabela `tbl_pessoas`
--

CREATE TABLE IF NOT EXISTS `tbl_pessoas` (
  `id` int(11) NOT NULL,
  `nomePessoa` text,
  `quantidade` int(11) DEFAULT NULL,
  `preco` int(11) DEFAULT NULL,
  `estadoCivil` text NOT NULL,
  `grupo` text NOT NULL,
  `image` text NOT NULL,
  `DataSelecionada` date NOT NULL,
  `createdDate` datetime DEFAULT NULL,
  `idUsuario` int(11) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tbl_usuarios`
--

CREATE TABLE IF NOT EXISTS `tbl_usuarios` (
  `id` int(11) NOT NULL,
  `usuario` text,
  `senha` text,
  `level` int(11) DEFAULT NULL,
  `nome` text,
  `status` int(11) DEFAULT NULL,
  `createdDate` datetime DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `tbl_usuarios`
--

INSERT INTO `tbl_usuarios` (`id`, `usuario`, `senha`, `level`, `nome`, `status`, `createdDate`) VALUES
(7, 'dionebatistap@gmail.com', '202cb962ac59075b964b07152d234b70', 2, 'Dione', 1, '2021-06-15 00:02:01'),
(10, 'admin@admin.com', '202cb962ac59075b964b07152d234b70', 1, 'Admin', 1, '2021-06-16 08:25:38');

--
-- Indexes for dumped tables
--

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
-- AUTO_INCREMENT for table `tbl_pessoas`
--
ALTER TABLE `tbl_pessoas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=94;
--
-- AUTO_INCREMENT for table `tbl_usuarios`
--
ALTER TABLE `tbl_usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=12;
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
