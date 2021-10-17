<?php

    define('HOST', 'mysql742.umbler.com');
    define('USER', 'dione');
    define('PASS','ak910627');
    define('DB','apitestedione');

    $con = mysqli_connect(HOST,USER,PASS,DB) or die('Falha ao conectar');
    mysqli_set_charset($con,'utf8');
?>
