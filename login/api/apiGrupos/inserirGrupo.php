<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST"){
    # code ...
    $response = array();
    $nomeGrupo = $_POST['nomeGrupo'];

        $insert = "INSERT INTO tbl_grupo VALUE(NULL,'$nomeGrupo')";
        if (mysqli_query($con, $insert)){
            #code
            $response['value']=1;
            $response['message']="Grupo cadastrado com successo";
            echo json_encode($response);
            
        }else {
            #code
            $response['value']=0;
            $response['message']="Falha ao cadastrar grupo";
            echo json_encode($response);
        }
    

}

?>
