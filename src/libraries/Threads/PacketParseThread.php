<?php

namespace Kaleidoscope\Libraries\Threads;

use \Thread;

class PacketParseThread extends Thread {

  public $client;

  public function run() {

    if (is_null($this->client)) return;
    if (is_null($this->client->packetParser)) return;
    if (is_null($this->client->state)) return;

    $pktLen = 0;

    if (!is_null($this->client->state->bnlsReadBuffer)) {
      #while ($this->client->state->bnlsReadBuffer->size >= 3) {

      #}
    }

  }

}
