{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    escapeTime = 1;
    mouse = true;
    prefix = "C-q";
    terminal = "tmux-256color";
    shell = "${pkgs.fish}/bin/fish";
    extraConfig = builtins.readFile ./tmux.conf;
  };
}