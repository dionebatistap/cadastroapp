create table pessoa(
id int AUTO_INCREMENT PRIMARY KEY,
    nomePessoa text,
    quantidade int,
    preco int,
    createdDate datetime,
    idUsuario int,
    FOREIGN KEY (idUsuario) REFERENCES users(id)
);
