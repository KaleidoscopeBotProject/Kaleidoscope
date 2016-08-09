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
    require_once($path);
  }, true);

  Common::$exitCode = 0;

  Common::parseArgs($argv);
  Common::parseConfig();

  while (Common::$exitCode === 0) {
    usleep(1000);
  }

}

exit(main($argc, $argv));
