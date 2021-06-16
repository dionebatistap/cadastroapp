create table produk(
id int AUTO_INCREMENT PRIMARY KEY,
    namaProduk text,
    qty int,
    harga int,
    createdDate datetime,
    idUsers int,
    FOREIGN KEY (idUsers) REFERENCES users(id)
);