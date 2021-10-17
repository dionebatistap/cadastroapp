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

    

    $cek = "SELECT * FROM tbl_usuarios WHERE usuario='$usuario'";
    $result = mysqli_fetch_array(mysqli_query($con, $cek));


    if (isset($result)) {
        # code...
        $response['value']=2;
        $response['message']="Usuario já cadastrado";
        echo json_encode($response);

    } else {
        # code...

        $insert = "INSERT INTO tbl_usuarios VALUE(NULL,'$usuario','$senha','$levelUser','$nome','$statusUser',NOW())";
        if (mysqli_query($con, $insert)){
            #code
            $response['value']=1;
            $response['message']="Registrado com sucesso API";
            echo json_encode($response);
            
        }else {
            #code
            $response['value']=0;
            $response['message']="Falha ao registrar API";
            echo json_encode($response);
        }
    }
    

    

}

?>
