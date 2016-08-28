<?php

namespace Kaleidoscope\Exceptions;

class ConfigParseException extends KaleidoscopeException {

  public function __construct($message, $previous = null) {
    if (empty($message)) {
      parent::__construct("Unable to parse config", 0, $previous);
    } else {
      parent::__construct($message, 0, $previous);
    }
  }

}
