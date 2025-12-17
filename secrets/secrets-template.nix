# secrets-template.nix
# Copy this to secrets.nix and add your actual values
# Make sure to chmod 600 secrets.nix and add it to .gitignore
# TODO: Change to use SOPS-Nix. (or lpass)

{
  # API keys and tokens
  apiKeys = {
    openai = "sk-your_openai_key";
    anthropic = "your_anthropic_key";
    # Add other API keys as needed
  };
}
# TODO: learn how to manage ssh keys in nix
