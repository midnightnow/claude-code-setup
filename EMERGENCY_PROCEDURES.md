# 🚨 Emergency Procedures

What to do when things go wrong.

## 🔐 Security Emergencies

### API Keys Accidentally Committed to Git

**If you accidentally commit API keys to a public repository:**

1. **IMMEDIATE - Revoke ALL keys** (do this FIRST, within 5 minutes):
   ```bash
   # Gemini/Google
   # Go to: https://aistudio.google.com/app/apikey
   # Delete the compromised key

   # OpenAI
   # Go to: https://platform.openai.com/api-keys
   # Revoke the compromised key

   # Anthropic
   # Go to: https://console.anthropic.com/settings/keys
   # Delete the compromised key
   ```

2. **Remove from Git History**:
   ```bash
   # Install BFG Repo Cleaner
   brew install bfg  # macOS

   # Remove the file from all commits
   bfg --delete-files api-keys.env

   # Force push (WARNING: Coordinate with collaborators!)
   git push --force
   ```

3. **Generate New Keys**:
   - Gemini: https://aistudio.google.com/app/apikey
   - OpenAI: https://platform.openai.com/api-keys
   - Anthropic: https://console.anthropic.com/settings/keys

4. **Update Local Config**:
   ```bash
   nano ~/.config/claude-code/api-keys.env
   # Replace with new keys

   source ~/.bashrc  # Reload
   ```

5. **Contact Father**:
   - Notify immediately
   - Share new keys via secure channel
   - Review what went wrong to prevent recurrence

---

### Suspicious API Usage Detected

**If you notice unusual charges or API activity:**

1. **Check Usage Dashboards**:
   - Gemini: https://console.cloud.google.com/apis/dashboard
   - OpenAI: https://platform.openai.com/usage
   - Anthropic: https://console.anthropic.com/usage

2. **Revoke Keys Immediately** (see above)

3. **Review Recent Commands**:
   ```bash
   # Check shell history
   history | grep claude-code

   # Check for background processes
   ps aux | grep claude
   ```

4. **Secure Your System**:
   ```bash
   # Check file permissions
   ls -la ~/.config/claude-code/api-keys.env

   # Should be: -rw------- (600)
   # If not: chmod 600 ~/.config/claude-code/api-keys.env
   ```

---

## 🔧 Technical Emergencies

### Claude Code Not Working

**Symptom**: Commands hang or fail

1. **Check API Keys Loaded**:
   ```bash
   echo $GOOGLE_API_KEY
   echo $OPENAI_API_KEY
   echo $ANTHROPIC_API_KEY
   ```

   If empty:
   ```bash
   source ~/.bashrc  # or source ~/.zshrc
   ```

2. **Test API Connectivity**:
   ```bash
   # Test Gemini
   curl -s "https://generativelanguage.googleapis.com/v1beta/models?key=$GOOGLE_API_KEY"

   # Test OpenAI
   curl -s https://api.openai.com/v1/models \
     -H "Authorization: Bearer $OPENAI_API_KEY"
   ```

3. **Check Network**:
   - Disable VPN temporarily
   - Check firewall settings
   - Try from different network

4. **Restart Zen MCP Server**:
   ```bash
   # Find process
   ps aux | grep zen-mcp

   # Kill and restart
   pkill -f zen-mcp
   # Then try command again
   ```

---

### Lost Configuration Files

**If you lose ~/.config/claude-code/api-keys.env**:

1. **Contact Father for Keys**:
   - Ask for new secret gist link
   - Do NOT ask him to send keys via regular email/text

2. **Recreate Directory Structure**:
   ```bash
   mkdir -p ~/.config/claude-code
   chmod 700 ~/.config/claude-code
   ```

3. **Restore from Backup** (if you made one):
   ```bash
   cp ~/backups/api-keys.env.backup ~/.config/claude-code/api-keys.env
   chmod 600 ~/.config/claude-code/api-keys.env
   ```

---

### Model Returns Errors

**Symptom**: "Model not available" or "Rate limit exceeded"

1. **Check Model Name**:
   - Gemini latest: `gemini-2.0-flash-exp`
   - OpenAI: `gpt-4-turbo`
   - Claude: `claude-sonnet-4-5`

2. **Try Alternative Model**:
   ```bash
   # If Gemini fails, try OpenAI
   claude-code --tool mcp__zen__chat \
     --model gpt-4-turbo \
     --prompt "Test message"
   ```

3. **Check Rate Limits**:
   - Gemini: 60 requests/minute (free tier)
   - OpenAI: Varies by account
   - Wait 60 seconds and retry

4. **Verify Account Status**:
   - Check billing/quota on provider dashboard
   - Ensure payment method is valid

---

## 💰 Cost Emergencies

### Unexpected High Bill

**If API costs are higher than expected:**

1. **Check Usage Immediately**:
   ```bash
   # Review recent commands
   history | grep claude-code | tail -50

   # Look for:
   # - Large file processing
   # - Long running commands
   # - Repeated calls in loops
   ```

2. **Set Usage Alerts**:
   - Gemini: Set budget alerts in Google Cloud Console
   - OpenAI: Set usage limits in account settings
   - Anthropic: Monitor usage dashboard daily

3. **Optimize Usage**:
   - Use cheaper models (flash vs pro)
   - Reduce context size
   - Cache repeated queries
   - Use smaller files in tests

4. **Temporary Measures**:
   ```bash
   # Remove expensive model from config
   # Use only gemini-2.0-flash-exp (cheapest)
   ```

---

## 📞 Contact Information

### Primary Contact
- **Father**: [Your contact method]
- **For**: API keys, security issues, general questions

### Provider Support
- **Gemini**: https://ai.google.dev/support
- **OpenAI**: https://help.openai.com
- **Anthropic**: https://support.anthropic.com

### Community Resources
- Claude Code Docs: https://docs.anthropic.com/claude-code
- Zen MCP GitHub: https://github.com/zen-mcp/zen-mcp

---

## 🔄 Recovery Checklist

After any emergency:

- [ ] All compromised keys revoked
- [ ] New keys generated and tested
- [ ] Configuration files restored
- [ ] Security review completed
- [ ] Father notified
- [ ] Documentation updated
- [ ] Preventive measures implemented

---

## 🛡️ Prevention

**To avoid emergencies:**

1. **Daily Checks**:
   ```bash
   # Verify file permissions
   ls -la ~/.config/claude-code/api-keys.env

   # Check for accidental commits
   git status | grep api-keys
   ```

2. **Weekly Backups**:
   ```bash
   # Backup config (encrypted)
   cp ~/.config/claude-code/api-keys.env ~/backups/api-keys.$(date +%Y%m%d).env.bak
   ```

3. **Monthly Reviews**:
   - Review API usage and costs
   - Rotate keys if suspicious activity
   - Update documentation

---

**Remember: When in doubt, contact your father IMMEDIATELY. Better to over-communicate than let a small issue become a big problem.** 🚨
