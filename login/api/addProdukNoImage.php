<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST"){
    # code ...
    $response = array();
    $namaProduk = $_POST['namaProduk'];
    $qty = $_POST['qty'];
    $harga = $_POST['harga'];
    $expDate = $_POST['expDate'];
    $idUsers = $_POST['idUsers'];
    $image = "placeholder.jpeg";

        $insert = "INSERT INTO produk VALUE(NULL,'$namaProduk','$qty','$harga','$image','$expDate',NOW(),'$idUsers')";
        if (mysqli_query($con, $insert)){
            #code
            $response['value']=1;
            $response['message']="Produto cadastrado com successo";
            echo json_encode($response);
            
        }else {
            #code
            $response['value']=0;
            $response['message']="Falha ao cadastrar produto";
            echo json_encode($response);
        }
    

}

?>