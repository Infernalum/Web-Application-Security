<?php
require "./vendor/autoload.php";

use Spatie\Browsershot\Browsershot;

Browsershot::html("<iframe src='file:///etc/passwd' width='800' height='900'></iframe>")->save('example.pdf');

?>