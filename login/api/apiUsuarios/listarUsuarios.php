<?php

require "../../../config/connect.php";



    $response = array();

    $sql = mysqli_query($con, "SELECT * FROM tbl_usuarios ORDER BY nome");
    while ($a = mysqli_fetch_array($sql)) {
        # code...
        $b['id'] = $a['id'];
        $b['usuario'] = $a['usuario'];
        $b['senha'] = $a['senha'];
        $b['levelUser'] = $a['levelUser'];
        $b['nome'] = $a['nome'];
        $b['statusUser'] = $a['statusUser'];
        $b['bandeira'] = $a['bandeira'];
        $b['createdDate'] = $a['createdDate'];

        array_push($response, $b);

    }

    echo json_encode($response);


?>
