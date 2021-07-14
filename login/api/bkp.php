// aqui esta o script para tal função funcionando perfeitamente e testado
// exaustivamente em meu servidor; não inventei nada somente fiz a junção de
// uma parte de código que peguei aqui e uma outra parte de um outro lugar e // efetuei pequenas correções; Não necessita de mais nada além do código
// na tarefa CRON inclua php -q /home/usuariodosite/pasta aonde esta o script

<?php
// Backup do banco de dados do site

$dbhost = 'localhost';          //local aonde se encontra o banco de dados
$dbuser = 'dione';    // usuário do banco de dados
$dbpass = 'ak910627';         // senha do usuário do banco de dados
$dbname = 'apitestedione';   // nome do banco de dados

// rotina que faz o backup não mexer

$backupfile = 'Autobackup_' . date("Ymd") . '.sql';
$backupzip = $backupfile . '.tar.gz';
system("mysqldump -h $dbhost -u $dbuser -p$dbpass --lock-tables $dbname > $backupfile");
system("tar -czvf $backupzip $backupfile");

// ROTINA DE ENVIO DO EMAIL COM O ANEXO 

$to = "---";         //Quem vai receber o email
$from = "---";  //Quem está enviando (Endereço a ser apresentado como da pessoa que está enviando)
$subject = 'Backup do Banco de Dados Sql ';          //Assunto do email
$messagem = 'cópia do backup do banco de dados Sql'; //Mensagem a ser enviada
$path = "---";                  //Diretório onde o arquivo a ser enviado está salvo
$filename = "$backupzip";                        //Nome do arquivo anexo a ser enviado - não mexer aqui

// ---------- Não altere nada deste ponto em diante ----------

$headers = 'From: ' .     "$from\r\n" . 'Reply-To: ' . "$from\r\n";

$file = $path . "/" . $filename;
$file_size = filesize($file);
$handle = fopen($file, "r");
$content = fread($handle, $file_size);
fclose($handle);
$content = chunk_split(base64_encode($content));

$separator = md5(time());   // a random hash será necessário para separar conteúdos diversos a serem enviados
$eol = PHP_EOL;   // Define o retorno de carro a ser utilizado

// main header (multipart mandatory)
$headers = "From: < $from >" . $eol;
$headers .= "MIME-Version: 1.0" . $eol;
$headers .= "Content-Type: multipart/mixed; boundary=\"" . $separator . "\"" . $eol . $eol;
$headers .= "Content-Transfer-Encoding: 7bit" . $eol;
$headers .= "This is a MIME encoded message." . $eol . $eol;

// messagem
$headers .= "--" . $separator . $eol;
$headers .= "Content-Type: text/plain; charset=\"utf-8\"" . $eol;
$headers .= "Content-Transfer-Encoding: 8bit" . $eol . $eol;
$headers .= $messagem . $eol . $eol;

// attachment
$headers .= "--" . $separator . $eol;
$headers .= "Content-Type: application/octet-stream; name=\"" . $filename . "\"" . $eol;
$headers .= "Content-Transfer-Encoding: base64" . $eol;
$headers .= "Content-Disposition: attachment" . $eol . $eol;
$headers .= $content . $eol . $eol;
$headers .= "--" . $separator . "--";

//SEND Mail

if (mail($to, $subject, "", $headers)) {
   echo "Sucesso no envio do Email";
} else {
   echo "Erro! Não foi possível enviar o email solicitado";
}

// Remover o arquivo do servidor (opcional)
unlink($backupzip);
unlink($backupfile);
?>