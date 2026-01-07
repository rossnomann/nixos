{
  config,
  lib,
  ...
}:
let
  cfg = config.nih;
in
{
  config = lib.mkIf cfg.enable {
    nih.user.home.file = {
      ".config/xkb/symbols/fsk".text = ''
        default partial alphanumeric_keys
        xkb_symbols "basic" {
            include "latin"
            name[Group1] = "Slovak";

            key <TLDE>  { [       grave,   asciitilde,    semicolon,  dead_abovering ] };
            key <AE01>  { [            1,      exclam,     NoSymbol,        NoSymbol ] };
            key <AE02>  { [            2,          at,     NoSymbol,        NoSymbol ] };
            key <AE03>  { [            3,  numbersign,     NoSymbol,        NoSymbol ] };
            key <AE04>  { [            4,      dollar,     NoSymbol,        NoSymbol ] };
            key <AE05>  { [            5,     percent,     NoSymbol,        NoSymbol ] };
            key <AE06>  { [            6, asciicircum,     NoSymbol,        NoSymbol ] };
            key <AE07>  { [            7,   ampersand,     NoSymbol,        NoSymbol ] };
            key <AE08>  { [            8,    asterisk,     NoSymbol,        NoSymbol ] };
            key <AE09>  { [            9,   parenleft,     NoSymbol,        NoSymbol ] };
            key <AE10>  { [            0,  parenright,     NoSymbol,        NoSymbol ] };
            key <AE11>  { [        minus,  underscore,       emdash,          hyphen ] };
            key <AE12>  { [        equal,        plus,   dead_acute,      dead_caron ] };

            key <AD01>  { [            q,           Q,     NoSymbol,        NoSymbol ] };
            key <AD02>  { [            w,           W,     NoSymbol,        NoSymbol ] };
            key <AD03>  { [            e,           E,       eacute,          Eacute ] };
            key <AD04>  { [            r,           R,       rcaron,          Rcaron ] };
            key <AD05>  { [            t,           T,       tcaron,          Tcaron ] };
            key <AD06>  { [            y,           Y,       yacute,          Yacute ] };
            key <AD07>  { [            u,           U,       uacute,          Uacute ] };
            key <AD08>  { [            i,           I,       iacute,          Iacute ] };
            key <AD09>  { [            o,           O,  ocircumflex,     Ocircumflex ] };
            key <AD10>  { [            p,           P,     NoSymbol,        NoSymbol ] };
            key <AD11>  { [  bracketleft,   braceleft,     NoSymbol,        NoSymbol ] };
            key <AD12>  { [ bracketright,  braceright,     NoSymbol,        NoSymbol ] };

            key <AC01>  { [            a,           A,       aacute,          Aacute ] };
            key <AC02>  { [            s,           S,       scaron,          Scaron ] };
            key <AC03>  { [            d,           D,       dcaron,          Dcaron ] };
            key <AC04>  { [            f,           F,     NoSymbol,        NoSymbol ] };
            key <AC05>  { [            g,           G,     NoSymbol,        NoSymbol ] };
            key <AC06>  { [            h,           H,     NoSymbol,        NoSymbol ] };
            key <AC07>  { [            j,           J,     NoSymbol,        NoSymbol ] };
            key <AC08>  { [            k,           K,     NoSymbol,        NoSymbol ] };
            key <AC09>  { [            l,           L,       lcaron,          Lcaron ] };

            key <AC10>  { [    semicolon,       colon,     NoSymbol,        NoSymbol ] };
            key <AC11>  { [   apostrophe,    quotedbl, guillemetleft, guillemetright ] };
            key <BKSL>  { [    backslash,         bar,     NoSymbol,        NoSymbol ] };

            key <AB01>  { [            z,           Z,       zcaron,          Zcaron ] };
            key <AB02>  { [            x,           X,     NoSymbol,        NoSymbol ] };
            key <AB03>  { [            c,           C,       ccaron,          Ccaron ] };
            key <AB04>  { [            v,           V,     NoSymbol,        NoSymbol ] };
            key <AB05>  { [            b,           B,     NoSymbol,        NoSymbol ] };
            key <AB06>  { [            n,           N,       ncaron,          Ncaron ] };
            key <AB07>  { [            m,           M,     NoSymbol,        NoSymbol ] };
            key <AB08>  { [        comma,        less,     NoSymbol,        NoSymbol ] };
            key <AB09>  { [       period,     greater,     NoSymbol,        NoSymbol ] };
            key <AB10>  { [        slash,    question,     NoSymbol,        NoSymbol ] };

            key <SPCE>  { [        space,       space, nobreakspace,    nobreakspace ] };

            include "level3(ralt_switch)"
        };
      '';
    };
  };
}
