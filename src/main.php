<?php
/**
 *  Kaleidoscope, a cross-platform classic Battle.net client daemon
 *  Copyright (C) 2016  Carl Bennett
 *  This file is part of Kaleidoscope.
 *
 *  Kaleidoscope is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  Kaleidoscope is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Kaleidoscope.  If not, see <http://www.gnu.org/licenses/>.
 */

namespace Kaleidoscope;

use \Kaleidoscope\Libraries\Common;
use \Kaleidoscope\Libraries\Term;

function main($argc, $argv) {

  if (php_sapi_name() !== "cli") {
    http_response_code(500);
    exit(
      "This application is only designed for the php-cli package." . PHP_EOL
    );
  }

  if (!file_exists(__DIR__ . "/../lib/autoload.php")) {
    exit(
      "Application misconfigured. Please run `composer install`." . PHP_EOL
    );
  }
  require(__DIR__ . "/../lib/autoload.php");

  Common::$exitCode = 0;

  Common::parseArgs($argv);
  Common::parseConfig();

  Term::stdout(strtolower(Common::getProjectName()) . "-"
    . Common::getVersionString() . PHP_EOL . PHP_EOL);

  foreach (Common::$clients as $client) {
    $client->connect();
  }

  while (Common::$exitCode === 0) {
    usleep(1000);
  }

}

exit(main($argc, $argv));
