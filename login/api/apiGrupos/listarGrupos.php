<?php

require "../config/connect.php";



    $response = array();

    $sql = mysqli_query($con, "SELECT * FROM tbl_grupo");
    while ($a = mysqli_fetch_array($sql)) {
        # code...
        $b['id'] = $a['id'];
        $b['nomeGrupo'] = $a['nomeGrupo'];

        array_push($response, $b);

    }

    echo json_encode($response);


?>
