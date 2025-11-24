# Secure Sharing Guide
*How to securely share Claude Code setup and API keys*

## Two-Step Sharing Strategy

### Step 1: Share Setup Guide (Safe for Git)
✅ **SAFE TO SHARE PUBLICLY**

The file `CLAUDE_CODE_SETUP_GUIDE.md` contains NO sensitive information and can be:
- Committed to git
- Shared via email
- Posted on GitHub
- Sent via any messaging platform

```bash
# Add to git and share
git add CLAUDE_CODE_SETUP_GUIDE.md
git commit -m "docs: Add Claude Code setup guide for family"
git push

# Then send the repo link or the file directly
```

### Step 2: Share API Keys (Secure Channel Only)
🔒 **MUST USE SECURE METHOD**

The file `API_KEYS_TEMPLATE.env` will contain sensitive API keys and MUST be shared via secure channel.

---

## Recommended Secure Sharing Methods

### Option 1: Password Manager (BEST) ⭐
**Use if you both have the same password manager**

- **1Password**: Create shared vault → Add secure note
- **Bitwarden**: Create shared collection → Add secure note
- **LastPass**: Create shared folder → Add secure note

```
How to:
1. Fill in API_KEYS_TEMPLATE.env with actual keys
2. Copy contents into password manager as secure note
3. Share the note/vault with your son
4. He copies to ~/.config/claude-code/api-keys.env
```

### Option 2: End-to-End Encrypted Messaging
**Use Signal, WhatsApp, or iMessage**

- Signal (most secure)
- WhatsApp (E2E encrypted)
- iMessage (E2E encrypted)

```
How to:
1. Fill in API_KEYS_TEMPLATE.env with actual keys
2. Send file via encrypted messaging app
3. Have him confirm receipt
4. Delete message after he saves it
```

### Option 3: Secure File Sharing
**Use encrypted file sharing service**

- **Firefox Send** (if still available): https://send.vis.ee/
- **Tresorit Send**: https://send.tresorit.com/
- **ProtonDrive**: https://proton.me/drive
- **Cryptomator** + any cloud storage

```
How to:
1. Fill in API_KEYS_TEMPLATE.env
2. Upload to secure sharing service
3. Share link + password separately (password via different channel)
4. Set link to expire after 1 download or 24 hours
```

### Option 4: GPG Encryption (Most Technical)
**For maximum security with some complexity**

```bash
# Your son generates GPG key and sends you public key
gpg --gen-key
gpg --export --armor your-son@email.com > son-public-key.asc

# You encrypt the file with his public key
gpg --import son-public-key.asc
gpg --encrypt --recipient your-son@email.com API_KEYS_TEMPLATE.env

# Send API_KEYS_TEMPLATE.env.gpg via any method (email, Dropbox, etc.)

# He decrypts with his private key
gpg --decrypt API_KEYS_TEMPLATE.env.gpg > ~/.config/claude-code/api-keys.env
```

---

## Complete Sharing Workflow

### For You (Sender)

1. **Prepare the setup guide** (already done):
   ```bash
   # This is safe to commit to git
   git add CLAUDE_CODE_SETUP_GUIDE.md
   git commit -m "docs: Add Claude Code setup guide"
   git push
   ```

2. **Fill in API keys**:
   ```bash
   # Edit the template with your actual keys
   # DO NOT commit this file!
   cp API_KEYS_TEMPLATE.env API_KEYS_FILLED.env
   # Edit API_KEYS_FILLED.env with real values
   ```

3. **Choose secure sharing method** (see options above)

4. **Send setup instructions**:
   ```
   Hey! I've set up Claude Code and want to share my setup with you.

   Step 1: Clone the repo and read the setup guide:
   git clone [REPO_URL]
   cd [REPO]
   open CLAUDE_CODE_SETUP_GUIDE.md

   Step 2: I'll send you the API keys via [1Password/Signal/etc.]

   Step 3: Follow the installation instructions in the guide
   ```

### For Your Son (Receiver)

1. **Get the setup guide**:
   ```bash
   # From git (if pushed)
   git pull

   # Or download directly if sent via file
   ```

2. **Receive API keys via secure channel**:
   - Check 1Password shared vault
   - Or check Signal messages
   - Or download from secure sharing service

3. **Install keys securely**:
   ```bash
   # Create config directory
   mkdir -p ~/.config/claude-code

   # Save keys file
   nano ~/.config/claude-code/api-keys.env
   # Paste the keys

   # Secure the file (important!)
   chmod 600 ~/.config/claude-code/api-keys.env

   # Verify it's not readable by others
   ls -la ~/.config/claude-code/api-keys.env
   # Should show: -rw------- (only you can read/write)
   ```

4. **Load keys automatically**:
   ```bash
   # Add to ~/.bashrc or ~/.zshrc
   echo '
   # Load Claude Code API keys
   if [ -f ~/.config/claude-code/api-keys.env ]; then
       export $(grep -v "^#" ~/.config/claude-code/api-keys.env | xargs)
   fi
   ' >> ~/.bashrc

   # Reload
   source ~/.bashrc
   ```

5. **Test the keys**:
   ```bash
   # Verify keys are loaded
   echo $GOOGLE_API_KEY
   echo $OPENAI_API_KEY

   # Test with Claude Code
   claude-code --tool mcp__zen__listmodels
   ```

---

## Security Checklist

### Before Sharing
- [ ] Fill in real API keys in `API_KEYS_TEMPLATE.env`
- [ ] Save as separate file (e.g., `API_KEYS_FILLED.env`)
- [ ] DO NOT commit filled file to git
- [ ] Choose secure sharing method
- [ ] Prepare instructions for recipient

### After Sharing
- [ ] Confirm recipient received the keys
- [ ] Have them test one API call
- [ ] Delete the filled file from your system
- [ ] Remove from sent messages if possible
- [ ] Add `*API_KEYS*.env` to `.gitignore`

### For Recipient
- [ ] Save keys to `~/.config/claude-code/api-keys.env`
- [ ] Set file permissions: `chmod 600`
- [ ] Verify not tracked by git: `git status`
- [ ] Add to shell config for auto-loading
- [ ] Test each API key
- [ ] Delete original message/file after saving

---

## What to Put in Git vs. Secure Share

### ✅ SAFE FOR GIT (Public)
- `CLAUDE_CODE_SETUP_GUIDE.md` - Complete setup instructions
- `API_KEYS_TEMPLATE.env` - Template with placeholders
- `.gitignore` - Should include `*API_KEYS*.env`
- Any documentation files
- Configuration examples (with placeholders)

### 🔒 SECURE SHARE ONLY (Private)
- `API_KEYS_FILLED.env` - Actual API keys
- Any files with real credentials
- Personal access tokens
- OAuth secrets
- Service account keys

---

## Update .gitignore

Make sure your `.gitignore` includes:

```gitignore
# API Keys and Secrets
*API_KEYS*.env
api-keys.env
.env.local
.env.*.local

# Claude Code
.claude/api-keys.env
.config/claude-code/api-keys.env

# Password manager exports
*.csv
*.kdbx
```

---

## Example Message to Your Son

```
Hey! I've got Claude Code set up and wanted to share my configuration with you.

Here's what I'm sending:

1. Setup Guide (via Git):
   - I've pushed CLAUDE_CODE_SETUP_GUIDE.md to the repo
   - Pull the latest changes to get it
   - Read through it - has everything you need

2. API Keys (via 1Password):
   - I've shared a secure note in our family vault called "Claude Code API Keys"
   - Copy those into ~/.config/claude-code/api-keys.env
   - Follow the security steps in the guide (chmod 600, etc.)

3. What you'll get access to:
   - Claude Code with Sonnet 4.5
   - Gemini 2.0 Flash (for Red Zen Gauntlet)
   - ChatGPT-4 (for multi-model consensus)
   - Qwen (alternative reasoning)
   - Full Zen MCP tools
   - Playwright visual testing

Let me know when you have it set up and I'll walk you through running your first Red Zen security gauntlet!
```

---

## Emergency: Key Compromise

If API keys are accidentally exposed:

### Immediate Actions
1. **Revoke all keys immediately**:
   - Gemini: https://aistudio.google.com/app/apikey
   - OpenAI: https://platform.openai.com/api-keys
   - Qwen: DashScope console

2. **Generate new keys**
3. **Update shared password vault**
4. **Notify recipient of new keys**
5. **Review API usage logs for unauthorized access**

### Prevention
- Use git-secrets: `brew install git-secrets`
- Add pre-commit hooks to detect secrets
- Use environment variables, never hardcode
- Rotate keys periodically (quarterly)

---

## Questions?

If either of you run into issues:
1. Check the troubleshooting section in the setup guide
2. Verify file permissions on api-keys.env
3. Test keys individually with curl commands
4. Check shell config is loading the env file

Happy coding together! 🚀👨‍👦
