<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST"){
    #CODE
    $response = array();
    $username = $_POST['username'];
    $password = md5($_POST['password']);
    
    $cek = "SELECT * FROM users WHERE username='$username' and password='$password'";
    $result = mysqli_fetch_array(mysqli_query($con, $cek));

    if (isset($result)) {
        # code...
        $response['value']=1;
        $response['message']="Login bem sucedido";
        $response['username']=$result['username'];
        $response['nama']=$result['nama'];
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