#!/usr/bin/php
<?php

namespace Kaleidoscope;

use \Kaleidoscope\Libraries\Common;

function main($argc, $argv) {

  spl_autoload_register(function($class){
    if (substr($class, 0, 13) == "Kaleidoscope\\") {
      $path = "./" . substr($class, 13) . ".php";
    }
    $path = str_replace("\\", DIRECTORY_SEPARATOR, $path);
    if (!file_exists($path)) {
      trigger_error("Cannot find " . $class . " at " . $path, E_USER_ERROR);
    }
    require_once($path);
  }, true);

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
