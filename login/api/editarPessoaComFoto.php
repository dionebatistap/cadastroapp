<?php

require "../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST"){
    # code ...
    $response = array();
    $nomePessoa = $_POST['nomePessoa'];
    $quantidade = $_POST['quantidade'];
    $preco = $_POST['preco'];
    $idPessoa = $_POST['idPessoa'];
    $dataSelecionada = $_POST['dataSelecionada'];
    
    $image = date('dmYis').str_replace(" ","", basename($_FILES['image']['name']));
    $imagePath = "../upload/".$image;
    move_uploaded_file($_FILES['image']['tmp_name'],$imagePath);

        $insert = "UPDATE tbl_pessoas SET nomePessoa='$nomePessoa', quantidade='$quantidade', preco='$preco', DataSelecionada='$dataSelecionada', image='$image' WHERE id='$idPessoa'";
        if (mysqli_query($con, $insert)){
            #code
            $response['value']=1;
            $response['message']="Pessoa atualizado com successo";
            echo json_encode($response);
            
        }else {
            #code
            $response['value']=0;
            $response['message']="Falha ao atualizar produto";
            echo json_encode($response);
        }
    

}

?>
