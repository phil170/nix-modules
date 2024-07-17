{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.jrnl;
  yamlFormat = pkgs.formats.yaml { };

in {
  options.programs.jrnl = {
    enable = mkEnableOption
      "jrnl is a simple journal application for the command line.";

    package = mkOption {
      type = types.package;
      default = pkgs.jrnl;
      defaultText = literalExpression "pkgs.jrnl";
      description = "The jrnl package to install.";
    };

    settings = mkOption {
      type = yamlFormat.type;
      default = { };
      example = literalExpression ''
        colors = {
          body = "none";
          date = "none";
          tags = "yellow";
          title = "cyan";
        };
        default_hour = 23;
        default_minute = 59;
        editor = nvim;
        journals = {
          default = {
            journal = /path/to/journal.txt;
          };
        };
      '';
      description = ''
        Configuration written to {file}`$XDG_CONFIG_HOME/jrnl/jrnl.yaml`.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions =
      [ (hm.assertions.assertPlatform "programs.jrnl" pkgs platforms.linux) ];

    home.packages = [ cfg.package ];

    xdg.configFile."jrnl/jrnl.yaml" = mkIf (cfg.settings != { }) {
      source = yamlFormat.generate "jrnl.yaml" cfg.settings;
    };
  };
}
