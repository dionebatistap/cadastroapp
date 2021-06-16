<?php

require "../config/connect.php";



    $response = array();

    $sql = mysqli_query($con, "SELECT a.*, b.nama FROM produk a
    left join users b on a.idUsers = b.id");
    while ($a = mysqli_fetch_array($sql)) {
        # code...
        $b['id'] = $a['id'];
        $b['namaProduk'] = $a['namaProduk'];
        $b['qty'] = $a['qty'];
        $b['harga'] = $a['harga'];
        $b['createdDate'] = $a['createdDate'];
        $b['idUsers'] = $a['idUsers'];
        $b['image'] = $a['image'];
        $b['ExpDate'] = $a['ExpDate'];
        $b['nama'] = $a['nama'];

        array_push($response, $b);

    }

    echo json_encode($response);


?>