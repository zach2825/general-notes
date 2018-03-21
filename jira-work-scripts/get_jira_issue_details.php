<?php

if (!$started) {
    die('please include start.php');
}

//  Initiate curl
$ch = curl_init();
// Disable SSL verification
//curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); //should be a valid ssl. this option should not be needed

// Will return the response, if false it print the response
echo "\r\n\r\n"; //create space
echo "Calling the jira api to collect issue information.\r\n";

curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_USERNAME, "{$config['username']}");
curl_setopt($ch, CURLOPT_PASSWORD, "{$config['password']}");
// Set the url
curl_setopt($ch, CURLOPT_URL, $config['url']);
// Execute
$result = curl_exec($ch);
// Closing
curl_close($ch);

$response = json_decode($result, true);

if (!isset($response['fields']['summary'])) {
    echo("invalid response from jira");
    exit(1);
}

return $response;
