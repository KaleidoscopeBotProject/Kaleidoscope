<?php

namespace Kaleidoscope\Libraries;

class Term {

    /**
     * <http://pueblo.sourceforge.net/doc/manual/ansi_color_codes.html>
     */

    const RESET      = "\033[0m";

    const BOLD       = "\033[1m";
    const ITALIC     = "\033[3m";
    const UNDERLINE  = "\033[4m";
    const INVERSE    = "\033[7m";
    const STRIKE     = "\033[9m";

    const FG_BLACK   = "\033[30m";
    const FG_RED     = "\033[31m";
    const FG_GREEN   = "\033[32m";
    const FG_YELLOW  = "\033[33m";
    const FG_BLUE    = "\033[34m";
    const FG_MAGENTA = "\033[35m";
    const FG_CYAN    = "\033[36m";
    const FG_WHITE   = "\033[37m";
    const FG_DEFAULT = "\033[39m";

    const BG_BLACK   = "\033[40m";
    const BG_RED     = "\033[41m";
    const BG_GREEN   = "\033[42m";
    const BG_YELLOW  = "\033[43m";
    const BG_BLUE    = "\033[44m";
    const BG_MAGENTA = "\033[45m";
    const BG_CYAN    = "\033[46m";
    const BG_WHITE   = "\033[47m";
    const BG_DEFAULT = "\033[49m";

    public static $strip_color = false;

    public static function filter_color($text) {
        $text = str_replace(self::RESET     , "", $text);

        $text = str_replace(self::BOLD      , "", $text);
        $text = str_replace(self::ITALIC    , "", $text);
        $text = str_replace(self::UNDERLINE , "", $text);
        $text = str_replace(self::INVERSE   , "", $text);
        $text = str_replace(self::STRIKE    , "", $text);

        $text = str_replace(self::FG_BLACK  , "", $text);
        $text = str_replace(self::FG_RED    , "", $text);
        $text = str_replace(self::FG_GREEN  , "", $text);
        $text = str_replace(self::FG_YELLOW , "", $text);
        $text = str_replace(self::FG_BLUE   , "", $text);
        $text = str_replace(self::FG_MAGENTA, "", $text);
        $text = str_replace(self::FG_CYAN   , "", $text);
        $text = str_replace(self::FG_WHITE  , "", $text);
        $text = str_replace(self::FG_DEFAULT, "", $text);

        $text = str_replace(self::BG_BLACK  , "", $text);
        $text = str_replace(self::BG_RED    , "", $text);
        $text = str_replace(self::BG_GREEN  , "", $text);
        $text = str_replace(self::BG_YELLOW , "", $text);
        $text = str_replace(self::BG_BLUE   , "", $text);
        $text = str_replace(self::BG_MAGENTA, "", $text);
        $text = str_replace(self::BG_CYAN   , "", $text);
        $text = str_replace(self::BG_WHITE  , "", $text);
        $text = str_replace(self::BG_DEFAULT, "", $text);

        return $text;
    }

    public static function stderr($text) {
        if (self::$strip_color) {
            $text = self::filter_color($text);
        }
        return fwrite(STDERR, $text);
    }

    public static function stdout($text) {
        if (self::$strip_color) {
            $text = self::filter_color($text);
        }
        return fwrite(STDOUT, $text);
    }

}
