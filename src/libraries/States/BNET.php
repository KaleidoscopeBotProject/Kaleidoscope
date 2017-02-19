<?php

namespace Kaleidoscope\Libraries\States;

use \Kaleidoscope\Libraries\Battlenet;
use \Kaleidoscope\Libraries\Clients\BNET as BNETClient;

class BNET {

  public $accountName;
  public $bnetReadBuffer;
  public $bnlsReadBuffer;
  public $channel;
  public $channelList;
  public $channelUsers;
  public $client;
  public $clientToken;
  public $connectedTime;
  public $email;
  public $gameKey1;
  public $gameKey2;
  public $gameKeyOwner;
  public $joinCommandState;
  public $lastCommand;
  public $localIP;
  public $logonType;
  public $nullTimer;
  public $password;
  public $passwordNew;
  public $platform;
  public $product;
  public $reconnecting;
  public $serverSignature;
  public $serverToken;
  public $statstring;
  public $timezoneBias;
  public $udpToken;
  public $uniqueName;
  public $username;
  public $versionAndKeyPassed;
  public $versionByte;
  public $versionCheckFileName;
  public $versionCheckFileTime;
  public $versionCheckSignature;
  public $versionChecksum;
  public $versionNumber;
  public $versionSignature;

  public function __construct(BNETClient $client) {

    $this->accountName           = '';
    $this->bnetReadBuffer        = null;
    $this->bnlsReadBuffer        = null;
    $this->channel               = null;
    $this->channelList           = [];
    $this->channelUsers          = [];
    $this->client                = $client;
    $this->clientToken           = Battlenet::getClientToken();
    $this->connectedTime         = 0;
    $this->email                 = $client->config->email;
    $this->gameKey1              = $client->config->gameKey1;
    $this->gameKey2              = $client->config->gameKey2;
    $this->gameKeyOwner          = $client->config->gameKeyOwner;
    $this->joinCommandState      = null;
    $this->lastCommand           = null;
    $this->localIP               = Battlenet::getLocalIP();
    $this->logonType             = 0;
    $this->nullTimer             = null;
    $this->password              = $client->config->password;
    $this->passwordNew           = $client->config->passwordNew;
    $this->platform              = $client->config->platform;
    $this->product               = $client->config->product;
    $this->reconnecting          = false;
    $this->serverSignature       = '';
    $this->serverToken           = 0;
    $this->statstring            = '';
    $this->timezoneBias          = Battlenet::getTimezoneBias();
    $this->udpToken              = 0;
    $this->uniqueName            = '';
    $this->username              = $client->config->username;
    $this->versionAndKeyPassed   = false;
    $this->versionByte           = 0;
    $this->versionCheckFileName  = '';
    $this->versionCheckFileTime  = 0;
    $this->versionCheckSignature = '';
    $this->versionChecksum       = 0;
    $this->versionNumber         = 0;
    $this->versionSignature      = '';

  }

  function __destruct() {

    $this->bnetReadBuffer = null;
    $this->bnlsReadBuffer = null;

    $this->channelUsers = null;

    $this->nullTimer = null;

  }

}
