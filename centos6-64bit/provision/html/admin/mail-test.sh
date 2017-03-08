# Mail test
echo "---------- Mail test ----------"
PATH_WWW=$1
DIR_HTML=$2
ADMIN=$3
echo "Args PATH_WWW:$PATH_WWW"
echo "Args DIR_HTML:$DIR_HTML"
echo "Args ADMIN:$ADMIN"
echo "================================================================================"
PATH_ADMIN=$PATH_WWW/$DIR_HTML/$ADMIN

cat << EOT > $PATH_ADMIN/mail_test.php
<?php

mb_language("ja");
mb_internal_encoding("UTF-8");

\$to = "webmaster-to@example.com";
\$from = "webmaster-from@example.com";

\$subject = "テストのサブジェクト";
\$body = "テスト\nテストテスト\nテストテストテスト\nテストテスト\nテスト";

mb_send_mail(\$to,\$subject,\$body,"From:".\$from);


\$subject = "TEST SUBJECT";
\$body = "TEST BODY";

echo "Send mail: ";
\$result =  mail(\$to,\$subject,\$body,"From:".\$from);

if(\$result){
 echo "Success";
}else{
 echo "failed";
}

EOT
# mail-test.php
cat << EOT > $PATH_ADMIN/mail-test.php
<?php

	/*
	DONT FORGET TO DELETE THIS SCRIPT WHEN FINISHED!
	*/

	ini_set( 'display_errors', 1 );
	error_reporting( E_ALL );
	
	\$from = 'webmaster@example.com';
	
	/*
	ini_set( 'SMTP', 'smtp.example.com' );
	ini_set( 'SMTP_PORT', 25 );
	ini_set( 'sendmail_from', \$from );
	*/
	
	\$server = array( 
		'HTTP_HOST', 'SERVER_NAME', 'SERVER_ADDR', 'SERVER_PORT',
 		'SERVER_ADMIN', 'SERVER_SIGNATURE', 'SERVER_SOFTWARE', 
		'REMOTE_ADDR', 'DOCUMENT_ROOT', 'REQUEST_URI', 
		'SCRIPT_NAME', 'SCRIPT_FILENAME',
	);
	
	\$to      = ( isset( \$_GET['email'] ) ? \$_GET['email'] : FALSE );
	\$subject = 'Mail Test Successful for ' . \$_SERVER['HTTP_HOST'];
	\$message = '';
	
	if ( ! \$to )
	{
		echo '<strong>Set \$_GET[\'email\'].</strong>';
		exit;
	};
	
	foreach ( \$server as \$s )
	{
		\$message .= sprintf( '%s: %s', \$s, \$_SERVER[\$s] ) . PHP_EOL;
	};
	
	\$headers = 'From: ' . \$from . PHP_EOL 
		 . 'Reply-To: ' . \$from . PHP_EOL 
		 . 'X-Mailer: PHP/' . phpversion(); 
	
	if ( isset( \$_GET['send'] ) && \$_GET['send'] === 'true' )
	{					
		\$success = mail( \$to, \$subject, \$message, \$headers );
	}
	else
	{
		echo '<strong>Set &quot;<a href="./?email=' . \$to . '&send=true">'
		 . './?email=' . \$to . '&send=true</a>&quot; to send a test e-mail.</strong>';
	};
	
	if ( isset( \$success ) )
	{	
		echo 'E-mail sent to: ' . \$to;
		echo '<br />';
		echo 'Successful mail?: <strong ' . ( \$success ? 'style="color:green;">YES' : 'style="color:red;">NO' ) . '</strong>';
	}
	else
	{
		echo '<br />';
		echo 'E-mail set as: '.\$to;
	};
	
	echo '<hr />';	
	echo '<style>	* { font-family: Helvetica, Arial, sans-serif;  } th { text-align: left; } td { padding: 3px 5px; }	</style>';
	echo '<table>';	
	
	foreach ( \$server as \$s )
	{
		echo '<tr><th>\$_SERVER[\'' . \$s . '\']</th><td>' . \$_SERVER[\$s] . '</td></tr>';
	};
	
	echo '</table>';
	
	if ( isset( \$success ) )
	{
		echo '<!--'; 
		var_dump( \$success );		
		echo '-->';
	};
?>

EOT