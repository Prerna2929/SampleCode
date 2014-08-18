<?php

// Put your device token here (without spaces):
$deviceToken = '07e78c21103ec0f9486e24a82189df697a135a1fb914b55e84afa08b065ba91b';

// Put your private key's passphrase here:
$passphrase = 'password';

// Put your alert message here:
$message = 'My first push notification!';

////////////////////////////////////////////////////////////////////////////////

$ctx = stream_context_create();
stream_context_set_option($ctx, 'ssl', 'local_cert', '/Volumes/MobileApp/SVN_Projects/RatingVoting_App/RatingVotingApp/Project/RatingVoting/RatingVoting/ck.pem');
stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);

// Open a connection to the APNS server
$fp = stream_socket_client(
	'ssl://gateway.sandbox.push.apple.com:2195', $err,
	$errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);

if (!$fp)
	exit("Failed to connect: $err $errstr" . PHP_EOL);

echo 'Connected to APNS' . PHP_EOL;

// Create the payload body
    //Simple PUSH
$body['aps'] = array(
    'alert' => 'Sample test buddy',
    'sound' => 'default'
    );
   
    //Silent PUSH
//$body['aps'] = array(
//      'content-available' => 1
//      'fbId' => '100006596614381',
//      'postType' => '1'
//                     );

    
// Encode the payload as JSON
$payload = json_encode($body);

// Build the binary notification
$msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) . $payload;

// Send it to the server
$result = fwrite($fp, $msg, strlen($msg));

if (!$result)
	echo 'Message not delivered' . PHP_EOL;
else
	echo 'Message successfully delivered' . PHP_EOL;

// Close the connection to the server
fclose($fp);

?>