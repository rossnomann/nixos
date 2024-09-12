{
  nushellExecutable,
  writeTextFile,
  shotgun,
  slop,
  xclip,
}:
let
  shotgunExecutable = "${shotgun}/bin/shotgun";
  slopExecutable = "${slop}/bin/slop";
  xclipExecutable = "${xclip}/bin/xclip";
in
writeTextFile {
  name = "x11-screenshot";
  text = ''
    #!${nushellExecutable}

    # A screenshot tool
    def main [] {
        let selection = ((run-external "${slopExecutable}" "-f" "-i %i -g %g") | split row (char space))
        let name = (date now | into int)
        let screenshots_root = $"($env.XDG_DATA_HOME)/screenshot"
        mkdir $screenshots_root
        let file_path = $"($screenshots_root)/($name).png"
        ${shotgunExecutable} ...$selection $file_path
        ${xclipExecutable} -t image/png -selection clipboard -i $file_path
    }
  '';
  executable = true;
  destination = "/bin/screenshot";
}
