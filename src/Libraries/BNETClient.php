<?php

namespace Kaleidoscope\Libraries;

use \Kaleidoscope\Libraries\BNETSocket;
use \Kaleidoscope\Libraries\BNLSSocket;
use \Kaleidoscope\Libraries\ChatParseThread;
use \Kaleidoscope\Libraries\Configuration;
use \Kaleidoscope\Libraries\PacketParseThread;

class BNETClient {

  public function __construct() {
    $this->chatParser   = new ChatParseThread();
    $this->config       = new Configuration();
    $this->packetParser = new PacketParseThread();
    $this->socBNET      = new BNETSocket();
    $this->socBNLS      = new BNLSSocket();
    $this->state        = null;

    $this->chatParser->client = $this;
    $this->packetParse->client = $this;

    $this->socBNET->client = $this;
    $this->socBNLS->client = $this;
  }

  public function connect() {
    // TODO
  }

}
