<?php

// Standard php script start
$settings_path = $_SERVER['HOME'] . '/.settings.cfg';

if (!file_exists($settings_path)) {
    die("Please copy 'settings.cfg' to '{$settings_path}\r\n\r\n");
}

$settings = parse_ini_file($settings_path);

/* Branch and repo configs here */
$config = [
    'url'         => $settings['url'],
    'email'       => $settings['email'],
    'username'    => $settings['email'],
    'password'    => $settings['password'],
    'branch_name' => $settings['branch_name'],
];

$started = true;
