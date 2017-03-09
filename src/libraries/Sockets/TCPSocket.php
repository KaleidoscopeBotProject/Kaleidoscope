<?php

namespace Kaleidoscope\Libraries\Sockets;

abstract class TCPSocket {

  const READ_CHUNK_SIZE = 4096;

  public $address;
  public $port;

  protected $socket;

  public function connect() {
    if ($this->isConnected()) { return false; }

    if (strpos($this->address, ':') !== false) {
      $this->socket = socket_create(
        AF_INET6, SOCK_STREAM, SOL_TCP
      );
    } else {
      $this->socket = socket_create(
        AF_INET, SOCK_STREAM, SOL_TCP
      );
    }

    if (substr($this->address, 0, 1) == '['
      && substr($this->address, -1) == ']') {
      $address = substr($this->address, 1, -1);
    } else {
      $address = $this->address;
    }

    $success = socket_connect(
      $this->socket, $address, $this->port
    );

    return $success;
  }

  public function disconnect() {
    if (!$this->socket) return false;

    socket_close($this->socket);

    return true;
  }

  public static function errorMessage($errno) {
    return socket_strerror($errno);
  }

  public function isConnected() {
    if (!$this->socket) return false;

    $bytes = @socket_read($this->socket, 0, PHP_BINARY_READ);

    return ($bytes === '');
  }

  public function lastError() {
    return socket_last_error($this->socket);
  }

  public function read($length) {
    return socket_read($this->socket, $length, PHP_BINARY_READ);
  }

  public function readAll() {
    $buffer = '';
    while (
      $op = socket_read(
        $this->socket, self::READ_CHUNK_SIZE, PHP_BINARY_READ
      )
    ) $buffer .= $op;
    return $buffer;
  }

  public function write($data) {
    return socket_write($this->socket, $data);
  }

}
