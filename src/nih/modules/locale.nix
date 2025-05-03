{ config, lib, ... }:
let
  cfg = config.nih;
  cfgLocale = cfg.locale;
in
{
  options.nih.locale = {
    default = lib.mkOption { type = lib.types.str; };
    extra = lib.mkOption { type = lib.types.str; };
    timeZone = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    i18n.defaultLocale = cfgLocale.default;
    i18n.extraLocaleSettings = {
      LC_ADDRESS = cfgLocale.extra;
      LC_IDENTIFICATION = cfgLocale.extra;
      LC_MEASUREMENT = cfgLocale.extra;
      LC_MONETARY = cfgLocale.extra;
      LC_NAME = cfgLocale.extra;
      LC_NUMERIC = cfgLocale.extra;
      LC_PAPER = cfgLocale.extra;
      LC_TELEPHONE = cfgLocale.extra;
      LC_TIME = cfgLocale.extra;
    };
    i18n.extraLocales = [ "en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8" ];
    time.timeZone = cfgLocale.timeZone;
  };
}
