<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST"){
    # code ...
    $response = array();
    $username = $_POST['username'];
    $password = md5($_POST['password']);
    $nama = $_POST['nama'];

    $cek = "SELECT * FROM users WHERE username='$username'";
    $result = mysqli_fetch_array(mysqli_query($con, $cek));

    if (isset($result)) {
        # code...
        $response['value']=2;
        $response['message']="Username telah digunakan";
        echo json_encode($response);

    } else {
        # code...

        $insert = "INSERT INTO users VALUE(NULL,'$username', '$password', '1', '$nama','1', NOW())";
        if (mysqli_query($con, $insert)){
            #code
            $response['value']=1;
            $response['message']="Registrado com sucesso";
            echo json_encode($response);
            
        }else {
            #code
            $response['value']=0;
            $response['message']="Falha ao registrar";
            echo json_encode($response);
        }
    }
    

    

}

?>