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
    $idPessoa = $_POST['idPessoa'];
    $dataSelecionada = $_POST['dataSelecionada'];

    $insert = "UPDATE tbl_pessoas SET nomePessoa='$nomePessoa', enderecoPessoa='$enderecoPessoa', numeroPessoa='$numeroPessoa', bairroPessoa='$bairroPessoa', cepPessoa='$cepPessoa', cidadePessoa='$cidadePessoa', celularPessoa='$celularPessoa',membroObreiro='$membroObreiro',prBatizou='$prBatizou', estadoCivil='$estadoCivil', grupo='$grupo', DataSelecionada='$dataSelecionada' WHERE id='$idPessoa'";
        if (mysqli_query($con, $insert)){
            #code
            $response['value']=1;
            $response['message']="sucesso";
            echo json_encode($response);
            
        }else {
            #code
            $response['value']=0;
            $response['message']="Falha ao atualizar cadastro";
            echo json_encode($response);
        }
    

}

?>
