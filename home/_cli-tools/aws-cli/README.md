# AWS CLI Configuration with SOPS

This directory contains AWS CLI configuration using sops-encrypted INI files.

## Initial Setup

1. **Edit the template files** with your AWS credentials:
   - `aws-credentials.ini` - Your AWS access key ID and secret access key
   - `aws-config.ini` - Your AWS region and output preferences

2. **Run the setup script** to encrypt and move files to the secrets directory:
   ```bash
   ./setup-aws-sops.sh
   ```

3. **Rebuild your system** to apply the configuration:
   ```bash
   rebuild
   ```

## Editing AWS Credentials

The AWS files are encrypted with sops. To edit them:

```bash
# Edit credentials
sops ~/.config/nix-config/secrets/aws-credentials.ini

# Edit config
sops ~/.config/nix-config/secrets/aws-config.ini
```

sops will decrypt the file in your editor, and re-encrypt it when you save and exit.

After editing, rebuild to apply changes:
```bash
rebuild
```

## How It Works

- **Template files** (`aws-credentials.ini`, `aws-config.ini`) exist in this directory for reference
- **Encrypted files** are stored in `secrets/` directory (gitignored, safe to commit)
- **sops-nix** automatically decrypts files at system activation
- **Decrypted files** are placed directly at `~/.aws/credentials` and `~/.aws/config`
- The decrypted files are **read/write** (mode 0600) and can be edited by you or AWS CLI tools
- **To update the encrypted source**: Edit with `sops secrets/aws-credentials.ini`, then rebuild
- **Runtime edits**: Changes made to `~/.aws/credentials` won't persist across rebuilds (they'll be overwritten by the decrypted sops version)

## File Locations

- **Templates**: `~/.config/nix-config/home/_cli-tools/aws-cli/*.ini`
- **Encrypted**: `~/.config/nix-config/secrets/aws-*.ini`
- **Decrypted runtime**: Managed by sops-nix
- **Used by AWS CLI**: `~/.aws/credentials`, `~/.aws/config` (symlinks)
