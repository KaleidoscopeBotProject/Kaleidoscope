<?php

namespace Kaleidoscope\Libraries;

use \Kaleidoscope\Libraries\Battlenet;

class Configuration {

  public $bnetHost;
  public $bnetPort;
  public $bnlsHost;
  public $bnlsPort;
  public $email;
  public $gameKey1;
  public $gameKey2;
  public $gameKeyOwner;
  public $greetAclExclusive;
  public $greetEnabled;
  public $greetMessage;
  public $homeChannel;
  public $password;
  public $passwordNew;
  public $platform;
  public $product;
  public $trigger;
  public $username;

  public function __construct() {

    $this->bnetHost          = 'useast.battle.net';
    $this->bnetPort          = 6112;
    $this->bnlsHost          = 'bnls.bnetdocs.org';
    $this->bnlsPort          = 9367;
    $this->email             = '';
    $this->gameKey1          = '';
    $this->gameKey2          = '';
    $this->gameKeyOwner      = 'Kaleidoscope';
    $this->greetAclExclusive = false;
    $this->greetEnabled      = false;
    $this->greetMessage      = '';
    $this->homeChannel       = '';
    $this->password          = '';
    $this->passwordNew       = '';
    $this->platform          = Battlenet::PLATFORM_IX86;
    $this->product           = 0;
    $this->trigger           = '';
    $this->username          = '';

  }

}
