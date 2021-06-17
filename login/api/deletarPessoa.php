<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST"){
    # code ...
    $response = array();
    $idPessoa = $_POST['idPessoa'];

        $insert = "DELETE FROM tbl_pessoas WHERE id='$idPessoa'";
        if (mysqli_query($con, $insert)){
            #code
            $response['value']=1;
            $response['message']="Pessoa removido com successo";
            echo json_encode($response);
            
        }else {
            #code
            $response['value']=0;
            $response['message']="Falha ao remover produto";
            echo json_encode($response);
        }
    

}

?>
