{
  config,
  lib,
  npins,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  nohupXdgOpen = pkgs.writeShellScriptBin "nohup-xdg-open" ''
    ${pkgs.coreutils}/bin/nohup ${pkgs.xdg-utils}/bin/xdg-open "$@" >/dev/null 2>&1 &
  '';
  mcConfig = {
    ini = pkgs.writeText "mc.ini" ''
      [Midnight-Commander]
      verbose=true
      shell_patterns=true
      auto_save_setup=false
      preallocate_space=false
      auto_menu=false
      use_internal_view=true
      use_internal_edit=true
      clear_before_exec=true
      confirm_delete=true
      confirm_overwrite=true
      confirm_execute=false
      confirm_history_cleanup=true
      confirm_exit=false
      confirm_directory_hotlist_delete=false
      confirm_view_dir=false
      safe_delete=true
      safe_overwrite=true
      use_8th_bit_as_meta=false
      mouse_move_pages_viewer=true
      mouse_close_dialog=false
      fast_refresh=false
      drop_menus=false
      wrap_mode=true
      old_esc_mode=true
      cd_symlinks=true
      show_all_if_ambiguous=false
      use_file_to_guess_type=true
      alternate_plus_minus=false
      only_leading_plus_minus=true
      show_output_starts_shell=false
      xtree_mode=false
      file_op_compute_totals=true
      classic_progressbar=true
      use_netrc=false
      ftpfs_always_use_proxy=false
      ftpfs_use_passive_connections=true
      ftpfs_use_passive_connections_over_proxy=false
      ftpfs_use_unix_list_options=true
      ftpfs_first_cd_then_ls=true
      ignore_ftp_chattr_errors=true
      editor_fill_tabs_with_spaces=false
      editor_return_does_auto_indent=true
      editor_backspace_through_tabs=false
      editor_fake_half_tabs=true
      editor_option_save_position=true
      editor_option_auto_para_formatting=false
      editor_option_typewriter_wrap=false
      editor_edit_confirm_save=true
      editor_syntax_highlighting=true
      editor_persistent_selections=true
      editor_drop_selection_on_copy=true
      editor_cursor_beyond_eol=false
      editor_cursor_after_inserted_block=false
      editor_visible_tabs=true
      editor_visible_spaces=true
      editor_line_state=false
      editor_simple_statusbar=false
      editor_check_new_line=false
      editor_show_right_margin=false
      editor_group_undo=false
      editor_state_full_filename=false
      editor_ask_filename_before_edit=false
      nice_rotating_dash=true
      shadows=true
      mcview_remember_file_position=false
      auto_fill_mkdir_name=true
      copymove_persistent_attr=true
      pause_after_run=1
      mouse_repeat_rate=100
      double_click_speed=250
      old_esc_mode_timeout=1000000
      max_dirt_limit=10
      num_history_items_recorded=60
      vfs_timeout=60
      ftpfs_directory_timeout=900
      ftpfs_retry_seconds=30
      shell_directory_timeout=900
      editor_tab_spacing=4
      editor_word_wrap_line_length=100
      editor_option_save_mode=0
      editor_backup_extension=~
      editor_filesize_threshold=64M
      editor_stop_format_chars=-+*\\,.;:&>
      mcview_eof=
      skin=catppuccin

      [Layout]
      output_lines=0
      left_panel_size=102
      top_panel_size=0
      message_visible=true
      keybar_visible=true
      xterm_title=true
      command_prompt=true
      menubar_visible=true
      free_space=true
      horizontal_split=false
      vertical_equal=true
      horizontal_equal=true

      [Misc]
      timeformat_recent=%b %d %H:%M
      timeformat_old=%b %d  %Y
      ftp_proxy_host=gate
      ftpfs_password=anonymous@
      display_codepage=UTF-8
      source_codepage=Other_8_bit
      autodetect_codeset=
      clipboard_store=
      clipboard_paste=

      [Colors]
      base_color=
      alacritty=
      color_terminals=

      [Panels]
      show_mini_info=true
      kilobyte_si=false
      mix_all_files=false
      show_backups=true
      show_dot_files=true
      fast_reload=false
      fast_reload_msg_shown=false
      mark_moves_down=true
      reverse_files_only=true
      auto_save_setup_panels=false
      navigate_with_arrows=false
      panel_scroll_pages=true
      panel_scroll_center=false
      mouse_move_pages=true
      filetype_mode=true
      permission_mode=false
      torben_fj_mode=false
      quick_search_mode=2
      select_flags=6
    '';
    ext = pkgs.writeText "mc.ext.ini" ''
      [mc.ext.ini]
      Version=4.0

      [xcf]
      Shell=.xcf
      Include=image

      [xbm]
      Shell=.xbm
      Include=image

      [xpm]
      Shell=.xpm
      Include=image

      [ico]
      Shell=.ico
      Include=image

      [svg]
      Shell=.svg
      ShellIgnoreCase=true
      Include=image

      [webp]
      Shell=.webp
      Include=image

      [djvu]
      Regex=\\.djvu?$
      RegexIgnoreCase=true
      Open=nohup-xdg-open %d/%p
      View=nohup-xdg-open %d/%p

      [ebook]
      Regex=\\.(epub|mobi|fb2)$
      RegexIgnoreCase=true
      Open=nohup-xdg-open %d/%p
      View=nohup-xdg-open %d/%p

      [pdf]
      Regex=\\.pdf?$
      RegexIgnoreCase=true
      Open=nohup-xdg-open %d/%p
      View=nohup-xdg-open %d/%p

      [Include/image]
      Open=nohup-xdg-open %d/%p
      Edit=gimp %d/%p
      View=nohup-xdg-open %d/%p

      # Default target for anything not described above
      [Default]
      Open=nohup-xdg-open %d/%p
      View=nohup-xdg-open %d/%p
    '';
  };
  mcSkin = "${npins.catppuccin-mc}/catppuccin.ini";
  mcDesktopEntry = pkgs.writeText "mc.desktop" ''
    [Desktop Entry]
    Type=Application
    Name=Midnight Commander
    Exec=alacritty --command mc %U
  '';
  mc = pkgs.mc.overrideAttrs (old: {
    postInstall =
      (old.postInstall or "")
      + ''
        install -Dm444 ${mcConfig.ini} $out/etc/mc/mc.ini
        install -Dm444 ${mcConfig.ext} $out/etc/mc/mc.ext.ini
        install -Dm444 ${mcSkin} $out/share/mc/skins/catppuccin.ini
        install -Dm444 ${mcDesktopEntry} $out/share/applications/mc.desktop
      '';
  });
in
{
  config = lib.mkIf cfg.enable {
    environment = {
      pathsToLink = [ "/share/mc" ];
      systemPackages = [
        nohupXdgOpen
        mc
      ];
    };
    nih.xdg.mime.directories = "mc.desktop";
  };
}
