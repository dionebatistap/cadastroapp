<?php

require "../../../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST"){
    # code ...
    $response = array();
    $idUsuario = $_POST['idUsuario'];

        $insert = "DELETE FROM tbl_usuarios WHERE id='$idUsuario'";
        if (mysqli_query($con, $insert)){
            #code
            $response['value']=1;
            $response['message']="Usuario removido com successo";
            echo json_encode($response);
            
        }else {
            #code
            $response['value']=0;
            $response['message']="Falha ao remover usuario";
            echo json_encode($response);
        }
    

}

?>
