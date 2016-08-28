<?php

namespace Kaleidoscope\Libraries\Clients;

use \Kaleidoscope\Libraries\Configuration;
use \Kaleidoscope\Libraries\Sockets\BNETSocket;
use \Kaleidoscope\Libraries\Sockets\BNLSSocket;
use \Kaleidoscope\Libraries\Threads\ChatParseThread;
use \Kaleidoscope\Libraries\Threads\PacketParseThread;

class BNET {

  public function __construct() {
    $this->chatParser   = new ChatParseThread();
    $this->config       = new Configuration();
    $this->packetParser = new PacketParseThread();
    $this->socBNET      = new BNETSocket();
    $this->socBNLS      = new BNLSSocket();
    $this->state        = null;

    $this->chatParser->client = &$this;
    $this->packetParse->client = &$this;

    $this->socBNET->client = &$this;
    $this->socBNLS->client = &$this;
  }

  public function connect() {
    // TODO
  }

}
