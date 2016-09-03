<?php

namespace Kaleidoscope\Libraries;

use \Kaleidoscope\Exceptions\BattlenetException;

class Battlenet {

  const PLATFORM_IX86 = 0x49583836;
  const PLATFORM_PMAC = 0x504D4143;
  const PLATFORM_XMAC = 0x584D4143;

  const PRODUCT_CHAT = 0x43484154;
  const PRODUCT_D2DV = 0x44324456;
  const PRODUCT_D2XP = 0x44325850;
  const PRODUCT_DRTL = 0x4452544C;
  const PRODUCT_DSHR = 0x44534852;
  const PRODUCT_JSTR = 0x4A535452;
  const PRODUCT_SEXP = 0x53455850;
  const PRODUCT_SSHR = 0x53534852;
  const PRODUCT_STAR = 0x53544152;
  const PRODUCT_W2BN = 0x5732424E;
  const PRODUCT_W3DM = 0x5733444D;
  const PRODUCT_W3XP = 0x57335850;
  const PRODUCT_WAR3 = 0x57415233;

  public static function strToGameKey($value) {
    // Filter 'value' through A-Za-z0-9 pattern forming 'key'.
    // This removes spaces, dashes, and other anomalies.
    return preg_replace("/[^a-zA-Z0-9]+/", "", $value);
  }

  public static function strToPlatform($value) {
    switch (strtolower($value)) {
      case "ix86": case "68xi":
      case "windows": case "win32": case "win64": case "win":
      case "linux": case "unix":
        return self::PLATFORM_IX86;
      case "pmac": case "camp":
      case "powerpc": case "classicmac": case "macclassic":
        return self::PLATFORM_PMAC;
      case "xmac": case "camx":
      case "macintosh": case "mac": case "osx": case "macosx": case "macos":
        return self::PLATFORM_XMAC;
      default:
        throw new BattlenetException(
          "Unable to translate value '" . $value . "' to platform id"
        );
    }
  }

  public static function strToProduct($value) {
    switch (strtolower($value)) {
      case "chat": case "tahc":
      case "telnet": case "plaintext": case "text":
        return self::PRODUCT_CHAT;
      case "d2dv": case "vd2d":
      case "d2": case "diablo2": case "diabloii":
        return self::PRODUCT_D2DV;
      case "d2xp": case "px2d":
      case "lod": case "lordofdestruction": case "diablo2lod":
      case "diabloiilod": case "d2exp":
        return self::PRODUCT_D2XP;
      case "drtl": case "ltrd":
      case "d1": case "diablo1": case "diabloi":
        return self::PRODUCT_DRTL;
      case "dshr": case "rhsd":
      case "ds": case "diabloshareware": case "diablo1shareware":
      case "diabloishareware": case "dshw": case "dsw":
        return self::PRODUCT_DSHR;
      case "jstr": case "rtsj":
      case "scj": case "starcraftjapan": case "starcraftjapanese":
      case "scjapan": case "scjapanese":
        return self::PRODUCT_JSTR;
      case "sexp": case "pxes":
      case "bw": case "starcraftbroodwar": case "scbroodwar": case "scbw":
      case "scexp":
        return self::PRODUCT_SEXP;
      case "sshr": case "rhss":
      case "ss": case "starcraftshareware": case "scshareware": case "scsw":
      case "scsh":
        return self::PRODUCT_SSHR;
      case "star": case "rats":
      case "sc": case "starcraft": case "starcraftoriginal":
      case "starcraftorig":
        return self::PRODUCT_STAR;
      case "w2bn": case "nb2w":
      case "w2": case "warcraftii": case "warcraft2": case "warcraftiibne":
      case "warcraft2bne": case "wc2":
        return self::PRODUCT_W2BN;
      case "w3dm": case "md3w":
      case "w3d": case "warcraftiiidemo": case "warcraft3demo": case "wc3demo":
        return self::PRODUCT_W3DM;
      case "w3xp": case "px3w":
      case "tft": case "warcraftiiitft": case "warcraft3tft": case "w3exp":
      case "wc3exp": case "wc3tft": case "w3tft":
        return self::PRODUCT_W3XP;
      case "war3": case "3raw":
      case "w3": case "warcraftiii": case "warcraftiiiroc": case "wc3":
        return self::PRODUCT_WAR3;
      default:
        throw new BattlenetException(
          "Unable to translate value '" . $value . "' to product id"
        );
    }
  }

}
