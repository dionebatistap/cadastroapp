<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST"){
    # code ...
    $response = array();
    $nomePessoa = $_POST['nomePessoa'];
    $enderecoPessoa = $_POST['enderecoPessoa'];
    $numeroPessoa = $_POST['numeroPessoa'];
    $bairroPessoa = $_POST['bairroPessoa'];
    $cepPessoa = $_POST['cepPessoa'];
    $cidadePessoa = $_POST['cidadePessoa'];
    $celularPessoa = $_POST['celularPessoa'];
    $membroObreiro = $_POST['membroObreiro'];
    $prBatizou = $_POST['prBatizou'];
    $estadoCivil = $_POST['estadoCivil'];
    $grupo = $_POST['grupo'];
    $idUsuario = $_POST['idUsuario'];
    $dataSelecionada = $_POST['dataSelecionada'];

    $imageNome = basename($_FILES['image']['name']);
    $image = $_POST['nomePessoa'].str_replace("scaled_image_picker","_", $imageNome);
    
    $imagePath = "../upload/".$image;

    move_uploaded_file($_FILES['image']['tmp_name'],$imagePath);

        $insert = "INSERT INTO tbl_pessoas VALUE(NULL,'$nomePessoa','$enderecoPessoa','$numeroPessoa','$bairroPessoa','$cepPessoa','$cidadePessoa','$celularPessoa','$membroObreiro','$prBatizou','$estadoCivil','$grupo','$image','$dataSelecionada',NOW(),'$idUsuario')";
        if (mysqli_query($con, $insert)){
            #code
            $response['value']=1;
            $response['message']="Cadastro realizado com successo";
            echo json_encode($response);
            
        }else {
            #code
            $response['value']=0;
            $response['message']="Falha ao atualizar cadastro";
            echo json_encode($response);
        }
    

}

?>
