<?php

namespace Kaleidoscope\Libraries;

use \DateTimeZone;
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

  public static function getClientToken() {
    return gmp_random_bits(32);
  }

  public static function getTimezone() {
    $er = error_reporting(); error_reporting($er & ~E_WARNING);
    $tz = date_default_timezone_get();
    error_reporting($er);

    return new DateTimeZone($tz);
  }

  public static function getTimezoneBias() {
    $tz_local = self::getTimezone();
    $tz_utc   = new DateTimeZone("UTC");

    $dt_local = new DateTime("now", $tz_local);
    $dt_utc   = new DateTime("now", $tz_utc);

    return $dt_utc->getOffset($dt_local);
  }

  public static function isDlablo2($product) {
    switch ($product) {
      case self::PRODUCT_D2DV:
      case self::PRODUCT_D2XP:
        return true;
      default:
        return false;
    }
  }

  public static function isWarcraft3($product) {
    switch ($product) {
      case self::PRODUCT_W3DM:
      case self::PRODUCT_W3XP:
      case self::PRODUCT_WAR3:
        return true;
      default:
        return false;
    }
  }

  public static function needsGameKey1($product) {
    switch ($product) {
      case self::PRODUCT_D2DV:
      case self::PRODUCT_D2XP:
      case self::PRODUCT_JSTR:
      case self::PRODUCT_SEXP:
      case self::PRODUCT_STAR:
      case self::PRODUCT_W2BN:
      case self::PRODUCT_W3XP:
      case self::PRODUCT_WAR3:
        return true;
      default:
        return false;
    }
  }

  public static function needsGameKey2($product) {
    switch ($product) {
      case self::PRODUCT_D2XP:
      case self::PRODUCT_W3XP:
        return true;
      default:
        return false;
    }
  }

  public static function onlineNameToAccountName(
    $onlineName, $ourProduct, $ignoreRealm, $supplementalRealms
  ) {

    $accountName = $onlineName;

    if (self::isDiablo2($ourProduct)) {
      $accountName = substr($accountName, strpos($accountName, "*") + 1);
    }

    if (!$ignoreRealm) {

      $realms      = [];
      $extraRealms = [];
      $cursor      = 0;

      if (self::isWarcraft3($ourProduct)) {
        $realms[] = "@USWest";
        $realms[] = "@USEast";
        $realms[] = "@Asia";
        $realms[] = "@Europe";
      } else {
        $realms[] = "@Lordaeron";
        $realms[] = "@Azeroth";
        $realms[] = "@Kalimdor";
        $realms[] = "@Northrend";
      }

      $extraRealms = explode(",", $supplementalRealms);

      foreach ($extraRealms as $realm) {
        if (substr($realm, 0, 1) != "@") {
          $realms[] = "@" . $realm;
        } else {
          $realms[] = $realm;
        }
      }

      while (count($realms) > 0) {

        $cursor = strpos($accountName, array_pop($realms));
        if ($cursor !== false) {
          $accountName = strpos($accountName, 0, $cursor - 1);
          break;
        }

      }

    }

    return $accountName;

  }

  public static function productToBNET($value) {
    switch ($value) {
      case 1:  return self::PRODUCT_STAR;
      case 2:  return self::PRODUCT_SEXP;
      case 3:  return self::PRODUCT_W2BN;
      case 4:  return self::PRODUCT_D2DV;
      case 5:  return self::PRODUCT_D2XP;
      case 6:  return self::PRODUCT_JSTR;
      case 7:  return self::PRODUCT_WAR3;
      case 8:  return self::PRODUCT_W3XP;
      case 9:  return self::PRODUCT_DRTL;
      case 10: return self::PRODUCT_DSHR;
      case 11: return self::PRODUCT_SSHR;
      case 12: return self::PRODUCT_W3DM;
      default: throw new BattlenetException(
        "Unable to translate value '" . (int) $value . "' to BNET product id"
      );
    }
  }

  public static function productToBNLS($value) {
    switch ($value) {
      case self::PRODUCT_STAR: return 1;
      case self::PRODUCT_SEXP: return 2;
      case self::PRODUCT_W2BN: return 3;
      case self::PRODUCT_D2DV: return 4;
      case self::PRODUCT_D2XP: return 5;
      case self::PRODUCT_JSTR: return 6;
      case self::PRODUCT_WAR3: return 7;
      case self::PRODUCT_W3XP: return 8;
      case self::PRODUCT_DRTL: return 9;
      case self::PRODUCT_DSHR: return 10;
      case self::PRODUCT_SSHR: return 11;
      case self::PRODUCT_W3DM: return 12;
      default: throw new BattlenetException(
        "Unable to translate value '" . (int) $value . "' to BNLS product id"
      );
    }
  }

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
