{
  # A syntax-highlighting pager for git, diff, grep, and blame output
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    enableJujutsuIntegration = true;
    options = {
      navigate = true;
      diff-so-fancy = true;
      line-numbers = true;
      true-colors = "always";
      side-by-side = true;
      file-style = "yellow";
      ov-diff = {
        pager = "ov -F --section-delimiter '^(commit|added:|removed:|renamed:|Δ)' --section-header --pattern '•'";
      };
      ov-log = {
        pager = "ov -F --section-delimiter '^commit' --section-header-num 3";
      };
    };
  };
}
