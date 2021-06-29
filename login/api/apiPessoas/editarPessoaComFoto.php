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
    $isBatizada = $_POST['isBatizada'];
    $idPessoa = $_POST['idPessoa'];
    $dataSelecionada = $_POST['dataSelecionada'];
    
    $image = date('dmYis').str_replace(" ","", basename($_FILES['image']['name']));
    $imagePath = "../upload/".$image;
    move_uploaded_file($_FILES['image']['tmp_name'],$imagePath);

        $insert = "UPDATE tbl_pessoas SET nomePessoa='$nomePessoa', enderecoPessoa='$enderecoPessoa', numeroPessoa='$numeroPessoa', bairroPessoa='$bairroPessoa', cepPessoa='$cepPessoa', cidadePessoa='$cidadePessoa',celularPessoa='$celularPessoa',membroObreiro='$membroObreiro',prBatizou='$prBatizou', estadoCivil='$estadoCivil', grupo='$grupo', isBatizada='$isBatizada', DataSelecionada='$dataSelecionada', image='$image' WHERE id='$idPessoa'";
        if (mysqli_query($con, $insert)){
            #code
            $response['value']=1;
            $response['message']="sucesso";
            echo json_encode($response);
            
        }else {
            #code
            $response['value']=0;
            $response['message']="Falha ao atualizar produto";
            echo json_encode($response);
        }
    

}

?>
