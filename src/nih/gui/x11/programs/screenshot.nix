{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      let
        nushell = "${pkgs.nushell}/bin/nu";
        shotgun = "${pkgs.shotgun}/bin/shotgun";
        slop = "${pkgs.slop}/bin/slop";
        xclip = "${pkgs.xclip}/bin/xclip";
        package = pkgs.writeTextFile {
          name = "x11-screenshot";
          text = ''
            #!${nushell}

            # A screenshot tool
            def main [] {
                let selection = ((run-external "${slop}" "-f" "-i %i -g %g") | split row (char space))
                let name = (date now | into int)
                let screenshots_root = $"($env.XDG_DATA_HOME)/screenshot"
                mkdir $screenshots_root
                let file_path = $"($screenshots_root)/($name).png"
                ${shotgun} ...$selection $file_path
                ${xclip} -t image/png -selection clipboard -i $file_path
            }
          '';
          executable = true;
          destination = "/bin/screenshot";
        };
      in
      [ package ];
  };
}
