# Requires openclaw: https://github.com/openclaw/nix-openclaw
{
  programs.openclaw = {
    enable = true;
    config = {
      gateway = {
        mode = "local";
        auth = {
          token = "<gatewayToken>"; # or set OPENCLAW_GATEWAY_TOKEN
        };
      };

      channels.telegram = {
        tokenFile = "/run/agenix/telegram-bot-token"; # any file path works
        allowFrom = [ 12345678 ];  # your Telegram user ID
      };
    };

    # Built-ins (tools + skills) shipped via nix-steipete-tools.
    plugins = [
      { source = "github:openclaw/nix-steipete-tools?dir=tools/summarize"; }
    ];
  };
}