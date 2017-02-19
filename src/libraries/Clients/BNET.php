<?php

namespace Kaleidoscope\Libraries\Clients;

use \Kaleidoscope\Libraries\Configuration;
use \Kaleidoscope\Libraries\Sockets\BNET as BNETSocket;
use \Kaleidoscope\Libraries\Sockets\BNLS as BNLSSocket;
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

    $this->chatParser->client   = $this;
    $this->packetParser->client = $this;

    $this->socBNET->client = $this;
    $this->socBNLS->client = $this;
  }

  function __destruct() {
    //$this->chatParser->kill();
    $this->chatParser = null;

    $this->config = null;

    //$this->packetParser->kill();
    $this->packetParser = null;

    $this->socBNET->disconnect();
    $this->socBNET = null;

    $this->socBNLS->disconnect();
    $this->socBNLS = null;

    $this->state = null;
  }

  public function connect() {
    $this->socBNET->disconnect();
    $this->socBNLS->disconnect();

    $this->socBNLS->address = $this->config->bnlsHost;
    $this->socBNLS->port    = $this->config->bnlsPort;

    $this->socBNET->address = $this->config->bnetHost;
    $this->socBNET->port    = $this->config->bnetPort;

    $this->socBNLS->connect();
    $this->socBNET->connect();
  }

}
