<?php

namespace Kaleidoscope\Libraries\Buffers;

use \OutOfBoundsException;

class Buffer {

  private $carray;
  private $cursor;
  private $insert;
  private $trim;

  public function __construct($insert = true, $trim = true) {
    $this->carray = "";      // Character array
    $this->cursor = 0;       // Cursor in character array
    $this->insert = $insert; // Overwrite bytes, don't append
    $this->trim   = $trim;   // Auto trim buffer after read
  }

  public function getLength() {
    return strlen($this->carray);
  }

  public function getPosition() {
    return $this->cursor;
  }

  public function readByte() {
    return $this->readUInt8();
  }

  public function readCString() {
    $null = chr(0); $buf = "";
    do {
      $buf .= $this->readRaw(1);
    } while (substr($buf, -1) !== $null);
    return substr($buf, 0, -1);
  }

  public function readUInt8() {
    return ord($this->readRaw(1));
  }

  public function readUInt16() {
    $buf = $this->readRaw(2);
    return (
      (ord($buf[1]) << 8) |
      (ord($buf[0])     )
    );
  }

  public function readUInt32() {
    $buf = $this->readRaw(4);
    return (
      (ord($buf[3]) << 24) |
      (ord($buf[2]) << 16) |
      (ord($buf[1]) << 8 ) |
      (ord($buf[0])      )
    );
  }

  public function readUInt64() {
    $buf = $this->readRaw(8);
    return (
      (ord($buf[7]) << 56) |
      (ord($buf[6]) << 48) |
      (ord($buf[5]) << 40) |
      (ord($buf[4]) << 32) |
      (ord($buf[3]) << 24) |
      (ord($buf[2]) << 16) |
      (ord($buf[1]) << 8 ) |
      (ord($buf[0])      )
    );
  }

  public function &readRaw($length) {
    if ($this->cursor + $length > strlen($this->carray))
      throw new OutOfBoundsException();
    $ret_carray = substr($this->carray, $this->cursor, $length);
    if ($this->trim) {
      $this->carray = substr($this->carray, $this->cursor + $length);
    } else {
      $this->cursor += $length;
    }
    return $ret_carray;
  }

  public function setPosition($new_cursor) {
    $this->cursor = $new_cursor;
  }

  public function trim() {
    $this->carray = substr($this->carray, $this->cursor);
    $this->cursor = 0;
  }

  public function writeByte($val) {
    return $this->writeUInt8($val);
  }

  public function writeCString($val) {
    $buf = $val . chr(0);
    return $this->writeRaw($buf);
  }

  public function writeUInt8($val) {
    return $this->writeRaw(chr($val & 0xFF));
  }

  public function writeUInt16($val) {
    $buf =
      chr( $val       & 0xFF).
      chr(($val >> 8) & 0xFF);
    return $this->writeRaw($buf);
  }

  public function writeUInt32($val) {
    $buf =
      chr( $val        & 0xFF).
      chr(($val >> 8 ) & 0xFF).
      chr(($val >> 16) & 0xFF).
      chr(($val >> 24) & 0xFF);
    return $this->writeRaw($buf);
  }

  public function writeUInt64($val) {
    $buf =
      chr( $val        & 0xFF).
      chr(($val >> 8 ) & 0xFF).
      chr(($val >> 16) & 0xFF).
      chr(($val >> 24) & 0xFF).
      chr(($val >> 32) & 0xFF).
      chr(($val >> 40) & 0xFF).
      chr(($val >> 48) & 0xFF).
      chr(($val >> 56) & 0xFF);
    return $this->writeRaw($buf);
  }

  public function writeRaw(&$raw) {
    $xlen = ($this->insert ? strlen($raw) : 0);
    $this->carray
      = substr($this->carray, 0, $this->cursor)
      . $raw
      . substr($this->carray, $this->cursor + $xlen);
    $this->cursor += strlen($raw);
  }

}
