<?php

namespace Kaleidoscope\Libraries\Sockets;

use \Kaleidoscope\Libraries\Term;

class BNET extends TCPSocket {

  public function connect() {
    Term::stdout(
      'BNET: Connecting to ' . $this->address . ':' . $this->port . '...'
      . PHP_EOL
    );
    $connected = parent::connect();
    if ($connected) {
      Term::stdout(
        'BNET: Connected to ' . $this->address . ':' . $this->port . '...'
        . PHP_EOL
      );
    } else {
      Term::stdout(
        'BNET: Error connecting to ' . $this->address . ':' . $this->port . '.'
        . PHP_EOL
      );
    }
    return $connected;
  }

  public function disconnect() {
    $return = parent::disconnect();
    if ($return) {
      Term::stdout('BNLS: Disconnected' . PHP_EOL);
    }
    return $return;
  }

}
