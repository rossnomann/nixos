{
  arguments,
  shellPath,
  writeTextFile,
  rlaunch,
}:
let
  rlaunchExecutable = "${rlaunch}/bin/rlaunch";
in
writeTextFile {
  name = "rlaunchx";
  text = ''
    #!${shellPath}
    ${rlaunchExecutable} ${arguments}
  '';
  executable = true;
  destination = "/bin/rlaunchx";
}
