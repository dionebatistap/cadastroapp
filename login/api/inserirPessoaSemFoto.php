<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST"){
    # code ...
    $response = array();
    $nomePessoa = $_POST['nomePessoa'];
    $quantidade = $_POST['quantidade'];
    $preco = $_POST['preco'];
    $dataSelecionada = $_POST['dataSelecionada'];
    $idUsuario = $_POST['idUsuario'];
    $image = "placeholder.jpeg";

        $insert = "INSERT INTO tbl_pessoas VALUE(NULL,'$nomePessoa','$quantidade','$preco','$image','$dataSelecionada',NOW(),'$idUsuario')";
        if (mysqli_query($con, $insert)){
            #code
            $response['value']=1;
            $response['message']="Pessoa cadastrado com successo";
            echo json_encode($response);
            
        }else {
            #code
            $response['value']=0;
            $response['message']="Falha ao cadastrar produto";
            echo json_encode($response);
        }
    

}

?>
