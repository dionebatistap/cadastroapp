<?php

require "../../../config/connect.php";

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
    $telefonePessoa = $_POST['telefonePessoa'];
     //atualização 25-09
     $pessoanascimento = $_POST['pessoanascimento'];
     $pessoasexo = $_POST['pessoasexo'];
     $estadocidade = $_POST['estadocidade'];
     $pessoaemail = $_POST['pessoaemail'];
     $pessoaprofissao = $_POST['pessoaprofissao'];
     $pessoauniversal = $_POST['pessoauniversal'];
     //fim
     //atualização 16-10
     $isRgRegularizado = $_POST['isRgRegularizado'];
     $isTituloRegularizado = $_POST['isTituloRegularizado'];
     $primeiraDose = $_POST['primeiraDose'];
     $segundaDose = $_POST['segundaDose'];
     $pesquisaArimateia = $_POST['pesquisaArimateia'];
     //fim
    $membroObreiro = $_POST['membroObreiro'];
    $prBatizou = $_POST['prBatizou'];
    $estadoCivil = $_POST['estadoCivil'];
    $grupo = $_POST['grupo'];
    $isBatizada = $_POST['isBatizada'];
    $dataSelecionada = $_POST['dataSelecionada'];
    $idUsuario = $_POST['idUsuario'];
    $idGrupo = $_POST['idGrupo'];
    $image = "placeholder.jpeg";

        $insert = "INSERT INTO tbl_pessoas VALUE(NULL,'$nomePessoa','$enderecoPessoa','$numeroPessoa','$bairroPessoa','$cepPessoa','$cidadePessoa','$celularPessoa','$telefonePessoa','$pessoanascimento','$pessoasexo','$estadocidade','$pessoaemail','$pessoaprofissao','$pessoauniversal',
        '$isRgRegularizado',
        '$isTituloRegularizado',
        '$primeiraDose',
        '$segundaDose',
        '$pesquisaArimateia',
        '$membroObreiro','$prBatizou','$estadoCivil','$grupo','$isBatizada','$image','$dataSelecionada',NOW(),'$idUsuario','$idGrupo')";
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
