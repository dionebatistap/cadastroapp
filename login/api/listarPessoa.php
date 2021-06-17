<?php

require "../config/connect.php";



    $response = array();

    $sql = mysqli_query($con, "SELECT a.*, b.nome FROM tbl_pessoas a
    left join tbl_usuarios b on a.idUsuario = b.id");
    while ($a = mysqli_fetch_array($sql)) {
        # code...
        $b['id'] = $a['id'];
        $b['nomePessoa'] = $a['nomePessoa'];
        $b['quantidade'] = $a['quantidade'];
        $b['preco'] = $a['preco'];
        $b['createdDate'] = $a['createdDate'];
        $b['idUsuario'] = $a['idUsuario'];
        $b['image'] = $a['image'];
        $b['DataSelecionada'] = $a['DataSelecionada'];
        $b['nome'] = $a['nome'];

        array_push($response, $b);

    }

    echo json_encode($response);


?>
