<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST"){
    #CODE
    $response = array();
    $usuario = $_POST['usuario'];
    $senha = md5($_POST['senha']);
    
    $cek = "SELECT * FROM tbl_usuarios WHERE usuario='$usuario' and senha='$senha'";
    $result = mysqli_fetch_array(mysqli_query($con, $cek));

    if (isset($result)) {
        # code...
        $response['value']=1;
        $response['message']="Login bem sucedido";
        $response['usuario']=$result['usuario'];
        $response['nome']=$result['nome'];
        $response['id']=$result['id'];
        $response['level']=$result['level'];
        echo json_encode($response);

    } else {
        # code...
        $response['value']=0;
        $response['message']="Falha no login";
        echo json_encode($response);
    }
    

    

}

?>
