{
  writeShellScriptBin,
  coreutils,
  xdg-utils,
}:
writeShellScriptBin "nohup-xdg-open" ''
  ${coreutils}/bin/nohup ${xdg-utils}/bin/xdg-open "$@" >/dev/null 2>&1 &
''
