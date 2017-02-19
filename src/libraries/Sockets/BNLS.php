<?php

namespace Kaleidoscope\Libraries\Sockets;

use \Kaleidoscope\Libraries\Term;

class BNLS extends TCPSocket {

  public function connect() {
    Term::stdout(
      'BNLS: Connecting to ' . $this->address . ':' . $this->port . '...'
      . PHP_EOL
    );
    $connected = parent::connect();
    if ($connected) {
      Term::stdout(
        'BNLS: Connected to ' . $this->address . ':' . $this->port . '...'
        . PHP_EOL
      );
    } else {
      Term::stdout(
        'BNLS: Error connecting to ' . $this->address . ':' . $this->port . '.'
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
