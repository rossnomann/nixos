{ config, ... }:
{
  home-manager.users.${config.workspace.user.name}.programs.firefox = {
    enable = true;

    profiles = {
      default = {
        extensions = with config.nur.repos.rycee.firefox-addons; [
          enhancer-for-youtube
          firefox-color
          multi-account-containers
          react-devtools
          stylus
          ublock-origin
        ];
        settings = {
          browser.aboutConfig.showWarning = false;
          browser.download.autohideButton = false;
          browser.newtabpage.enabled = false;
          browser.startup.homepage = "about:blank";
          browser.tabs.closeWindowWithLastTab = false;
          browser.tabs.inTitleBar = 1;
          browser.tools.bookmarks.visibility = "never";
          browser.urlbar.shortcuts.bookmarks = false;
          browser.urlbar.shortcuts.history = false;
          browser.urlbar.shortcuts.tabs = false;
          browser.urlbar.trimURLs = false;
          browser.warnOnQuitShortcut = false;
          general.autoScroll = true;
          intl.accept_languages = "ru,en-us,en";
          pref.privacy.disable_button.view_passwords = false;
        };
      };
    };
  };
}
