<?php

require "../../../config/connect.php";
//require "../public/config/connect.php";

    $response = array();

    $sql = mysqli_query($con, "SELECT a.*, b.nome FROM tbl_pessoas a
    left join tbl_usuarios b on a.idUsuario = b.id ORDER BY nomePessoa");
    while ($a = mysqli_fetch_array($sql)) {
        # code...
        $b['id'] = $a['id'];
        $b['nomePessoa'] = $a['nomePessoa'];
        $b['enderecoPessoa'] = $a['enderecoPessoa'];
        $b['numeroPessoa'] = $a['numeroPessoa'];
        $b['bairroPessoa'] = $a['bairroPessoa'];
        $b['cepPessoa'] = $a['cepPessoa'];
        $b['cidadePessoa'] = $a['cidadePessoa'];
        $b['celularPessoa'] = $a['celularPessoa'];
        $b['telefonePessoa'] = $a['telefonePessoa'];
        //atualização 25-09
        $b['pessoanascimento'] = $a['pessoanascimento'];
        $b['pessoasexo'] = $a['pessoasexo'];
        $b['estadocidade'] = $a['estadocidade'];
        $b['pessoaemail'] = $a['pessoaemail'];
        $b['pessoaprofissao'] = $a['pessoaprofissao'];
        $b['pessoauniversal'] = $a['pessoauniversal'];
        //fim
        //atualização 16-10
        $b['isRgRegularizado'] = $a['isRgRegularizado'];
        $b['isTituloRegularizado'] = $a['isTituloRegularizado'];
        $b['primeiraDose'] = $a['primeiraDose'];
        $b['segundaDose'] = $a['segundaDose'];
        $b['pesquisaArimateia'] = $a['pesquisaArimateia'];
        //fim
        $b['membroObreiro'] = $a['membroObreiro'];
        $b['prBatizou'] = $a['prBatizou'];
        $b['estadoCivil'] = $a['estadoCivil'];
        $b['grupo'] = $a['grupo'];
        $b['isBatizada'] = $a['isBatizada'];
        $b['createdDate'] = $a['createdDate'];
        $b['idUsuario'] = $a['idUsuario'];
        $b['idGrupo'] = $a['idGrupo'];
        $b['image'] = $a['image'];
        $b['DataSelecionada'] = $a['DataSelecionada'];
        $b['nome'] = $a['nome'];
        array_push($response, $b);
    }
    echo json_encode($response);
?>
