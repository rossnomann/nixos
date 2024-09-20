{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  extraPolicies = {
    AppAutoUpdate = false;
    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;
    BackgroundAppUpdate = false;
    Containers = {
      Default = [
        {
          name = "RS";
          icon = "circle";
          color = "green";
        }
        {
          name = "Ross";
          icon = "circle";
          color = "blue";
        }
        {
          name = "Work";
          icon = "circle";
          color = "orange";
        }
        {
          name = "Trash";
          icon = "fence";
          color = "purple";
        }
      ];
    };
    DefaultDownloadDirectory = "\${home}/workspace/downloads";
    DisableAppUpdate = true;
    DisableFirefoxScreenshots = true;
    DisableFirefoxStudies = true;
    DisableMasterPasswordCreation = true;
    DisablePocket = true;
    DisableSetDesktopBackground = true;
    DisableTelemetry = true;
    DisplayBookmarksToolbar = "never";
    DisplayMenuBar = "default-off";
    DownloadDirectory = "\${home}/workspace/downloads";
    DontCheckDefaultBrowser = true;
    NoDefaultBookmarks = true;
    OfferToSaveLogins = false;
    PasswordManagerEnabled = false;
    Preferences = {
      browser.aboutConfig.showWarning = {
        Status = "default";
        Value = false;
      };
      browser.download.autohideButton = {
        Status = "default";
        Value = false;
      };
      browser.newtabpage.enabled = {
        Status = "default";
        Value = false;
      };
      browser.startup.homepage = {
        Status = "default";
        Value = "about:blank";
      };
      browser.tabs.closeWindowWithLastTab = {
        Status = "default";
        Value = false;
      };
      browser.tabs.inTitleBar = {
        Status = "default";
        Type = "number";
        Value = 1;
      };
      browser.tools.bookmarks.visibility = {
        Status = "user";
        Value = "never";
      };
      browser.urlbar.shortcuts.bookmarks = {
        Status = "user";
        Value = false;
      };
      browser.urlbar.shortcuts.history = {
        Status = "user";
        Value = false;
      };
      browser.urlbar.shortcuts.tabs = {
        Status = "user";
        Value = false;
      };
      browser.urlbar.trimURLs = {
        Status = "user";
        Value = false;
      };
      browser.warnOnQuitShortcut = {
        Status = "user";
        Value = false;
      };
      general.autoScroll = {
        Status = "user";
        Value = true;
      };
      intl.accept_languages = {
        Status = "user";
        Value = "ru,en-us,en";
      };
      pref.privacy.disable_button.view_passwords = {
        Status = "user";
        Value = false;
      };
    };
    UserMessaging = {
      FeatureRecommendations = false;
      ExtensionRecommendations = false;
      MoreFromMozilla = false;
      SkipOnboarding = true;
      WhatsNew = false;
    };
  };
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ (pkgs.firefox.override { inherit extraPolicies; }) ];
    environment.variables = {
      MOZ_USE_XINPUT2 = "1";
    };
    nih.windowRules = [
      {
        x11Class = "firefox";
        waylandAppId = "firefox";
        useWorkspace = "main";
      }
    ];
  };
}
