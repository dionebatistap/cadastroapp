<?php

require "../../../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST"){
    # code ...
    $response = array();
    $nomeGrupo = $_POST['nomeGrupo'];
    $idGrupo = $_POST['idGrupo'];
    // $nomeGrupo = 'juca';
    // $idGrupo = 3;


    $insert = "UPDATE tbl_grupo SET nomeGrupo='$nomeGrupo' WHERE id='$idGrupo'";
        if (mysqli_query($con, $insert)){
            #code
            $response['value']=1;
            $response['message']="Atualizado com sucesso";
            echo json_encode($response);
            
        }else {
            #code
            $response['value']=0;
            $response['message']="Falha ao atualizar registro";
            echo json_encode($response);
        }

    

}

?>
