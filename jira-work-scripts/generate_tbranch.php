<?php

include('start.php');

if (!$started) {
    die('please include start.php');
}

$args = getopt('i:u:e:');
if (!isset($args['i']) || empty($args['i'])) {
    echo "\r\n\r\nMissing the ticket number for example '-i 600'\r\n";
    exit(1);
}
$issue_id = $args['i'];


$config['url'] = "{$config['url']}/rest/api/latest/issue/ST-{$issue_id}";

$response = include('get_jira_issue_details.php');

//format the branch name
$name = $response['key'] . '-' . $response['fields']['summary'];

// Add log entry
$date = date('Y-m-d H:i:s');
file_put_contents(__DIR__ . '/create_log.log', $date . ' - ' . $name . "\r\n", FILE_APPEND);

// Remove non alpha numeric and space characters
$name = str_replace(' ', '-', $name);
$name = preg_replace('/[^a-zA-Z0-9\-]+/', '', $name);

// Remove duplicate -
$name = str_replace('--', '-', $name);
$name = str_replace('--', '-', $name); // This needs to be duplicated to catch remaining instances of -- as a result of the last one

// Remove the trailing -
// Lowercase the string
// Trim the string to make sure its only 30 characters long
$name = preg_replace('/-$/', '', strtolower(substr($name, 0, 30)));

echo "Creating and switching to the new task branch {$name}\r\n";

// Create the new branch and checkout into it.
$new_branch_name = "{$config['branch_name']}/{$name}";
shell_exec(__DIR__ . "/new_branch.sh {$new_branch_name}");

// Create space
echo "\r\n\r\n";

if ($response['fields']['status']['id'] == 1) {
    shell_exec(__DIR__ . "/mark_development.sh {$issue_id}");
    shell_exec(__DIR__ . "/assign-me.sh {$issue_id}");
    echo "\r\n\r\n"; //create space
}

exit(0); //exit code success
