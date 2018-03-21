#!/usr/bin/env bash

laravel new $1

cd "$1"

mysql -e"create database $2"

echo "Running composer update"
composer update;

echo "Gathering frontend resources"
php artisan preset vue;
npm install --save browser-sync toastr sweetalert
npm install
npm run dev

echo "Collecting common vendor resources"
composer require silber/bouncer v1.0.0-rc.1 igaster/laravel-theme barryvdh/laravel-ide-helper barryvdh/laravel-debugbar


echo "Publish configs and vendor resources"
php artisan vendor:publish --all

echo "Make a base auth scaffolding"
php artisan make:auth

# webpack.mix.js
# mix.browserSync('http://localhost:8000/');

# composer.json
#   "post-update-cmd": [
#        "Illuminate\\Foundation\\ComposerScripts::postUpdate",
#        "php artisan ide-helper:generate",
#        "php artisan ide-helper:meta"
#    ]
