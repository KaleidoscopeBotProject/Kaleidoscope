#!/usr/bin/php
<?php

namespace Kaleidoscope;

use \Kaleidoscope\Libraries\Common;

function main($argc, $argv) {

  if (php_sapi_name() !== "cli") {
    http_response_code(500);
    exit(
      "This application is only designed for the php-cli package." . PHP_EOL
    );
  }

  if (!file_exists(__DIR__ . "/../lib/autoload.php")) {
    exit(
      "Server misconfigured. Please run `composer install`." . PHP_EOL
    );
  }
  require(__DIR__ . "/../lib/autoload.php");

  Common::$exitCode = 0;

  Common::parseArgs($argv);
  Common::parseConfig();

  echo strtolower(Common::getProjectName()) . "-"
    . Common::getVersionString() . PHP_EOL . PHP_EOL;

  foreach (Common::$clients as $client) {
    $client->connect();
  }

  while (Common::$exitCode === 0) {
    echo "Tick";
    usleep(1000);
  }

}

exit(main($argc, $argv));
