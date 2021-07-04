<?php

require "../../../config/connect.php";

    $caracteres_sem_acento = array(
    'Š'=>'S', 'š'=>'s', 'Ð'=>'Dj',''=>'Z', ''=>'z', 'À'=>'A', 'Á'=>'A', 'Â'=>'A', 'Ã'=>'A', 'Ä'=>'A',
    'Å'=>'A', 'Æ'=>'A', 'Ç'=>'C', 'È'=>'E', 'É'=>'E', 'Ê'=>'E', 'Ë'=>'E', 'Ì'=>'I', 'Í'=>'I', 'Î'=>'I',
    'Ï'=>'I', 'Ñ'=>'N', 'Ń'=>'N', 'Ò'=>'O', 'Ó'=>'O', 'Ô'=>'O', 'Õ'=>'O', 'Ö'=>'O', 'Ø'=>'O', 'Ù'=>'U', 'Ú'=>'U',
    'Û'=>'U', 'Ü'=>'U', 'Ý'=>'Y', 'Þ'=>'B', 'ß'=>'Ss','à'=>'a', 'á'=>'a', 'â'=>'a', 'ã'=>'a', 'ä'=>'a',
    'å'=>'a', 'æ'=>'a', 'ç'=>'c', 'è'=>'e', 'é'=>'e', 'ê'=>'e', 'ë'=>'e', 'ì'=>'i', 'í'=>'i', 'î'=>'i',
    'ï'=>'i', 'ð'=>'o', 'ñ'=>'n', 'ń'=>'n', 'ò'=>'o', 'ó'=>'o', 'ô'=>'o', 'õ'=>'o', 'ö'=>'o', 'ø'=>'o', 'ù'=>'u',
    'ú'=>'u', 'û'=>'u', 'ü'=>'u', 'ý'=>'y', 'ý'=>'y', 'þ'=>'b', 'ÿ'=>'y', 'ƒ'=>'f',
    'ă'=>'a', 'î'=>'i', 'â'=>'a', 'ș'=>'s', 'ț'=>'t', 'Ă'=>'A', 'Î'=>'I', 'Â'=>'A', 'Ș'=>'S', 'Ț'=>'T',
    );

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
    $dataSelecionada = $_POST['dataSelecionada'];
    $idUsuario = $_POST['idUsuario'];
    $idGrupo = $_POST['idGrupo'];

    //REMOVER ACENTOS E RENOMEAR A IMAGEM DE ACORDO COM O NOME DO MEMBRO
    $nome_imagem = preg_replace("/[^a-zA-Z0-9]/", "", strtr($_POST['nomePessoa'], $caracteres_sem_acento));
    $nome_imagem = strtolower($nome_imagem);
    $imageNome = basename($_FILES['image']['name']);
    $image =  $nome_imagem.str_replace("image_cropper","", $imageNome);
    $imagePath = "../../upload/".$image;

    move_uploaded_file($_FILES['image']['tmp_name'],$imagePath);

        $insert = "INSERT INTO tbl_pessoas VALUE(NULL,'$nomePessoa','$enderecoPessoa','$numeroPessoa','$bairroPessoa','$cepPessoa','$cidadePessoa','$celularPessoa','$membroObreiro','$prBatizou','$estadoCivil','$grupo','$isBatizada','$image','$dataSelecionada',NOW(),'$idUsuario','$idGrupo')";
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

        $string = "São Paulo (1982)";
        
   
    

}

?>
