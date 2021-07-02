<?php

require "../../../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST"){
    # code ...
    $response = array();
    $usuario = $_POST['usuario'];
    $senha = md5($_POST['senha']);
    $levelUser = $_POST['levelUser'];
    $nome = $_POST['nome'];
    $statusUser = $_POST['statusUser'];
    $idUsuario = $_POST['idUsuario'];


    $insert = "UPDATE tbl_usuarios SET usuario='$usuario', senha='$senha', levelUser='$levelUser', nome='$nome', statusUser='$statusUser' WHERE id='$idUsuario'";
        if (mysqli_query($con, $insert)){
            #code
            $response['value']=1;
            $response['message']="sucesso editar";
            echo json_encode($response);
            
        }else {
            #code
            $response['value']=0;
            $response['message']="Falha ao atualizar cadastro";
            echo json_encode($response);
        }

    

}

?>
