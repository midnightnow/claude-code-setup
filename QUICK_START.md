# 🚀 Quick Start - Your First 15 Minutes

Get up and running with Claude Code + Zen MCP in 15 minutes.

## ✅ Step 1: Installation (5 minutes)

### 1.1 Clone the Repository
```bash
git clone https://github.com/midnightnow/claude-code-setup.git
cd claude-code-setup
```

### 1.2 Install API Keys
```bash
# Create config directory
mkdir -p ~/.config/claude-code

# Download API keys from the secure gist link your father sent you
# Save to: ~/.config/claude-code/api-keys.env

# Set secure permissions
chmod 600 ~/.config/claude-code/api-keys.env
```

### 1.3 Load Keys Automatically
Add to your `~/.bashrc` or `~/.zshrc`:
```bash
# Claude Code API Keys
if [ -f ~/.config/claude-code/api-keys.env ]; then
    export $(grep -v '^#' ~/.config/claude-code/api-keys.env | xargs)
fi
```

Reload your shell:
```bash
source ~/.bashrc  # or source ~/.zshrc
```

### 1.4 Verify Installation
```bash
./verify-install.sh
```

You should see all green checkmarks! ✅

---

## 🎯 Step 2: First Win (5 minutes)

### Your First AI Command

Let's test Gemini 2.0 Flash (latest model):

```bash
claude-code --tool mcp__zen__chat \
  --model gemini-2.0-flash-exp \
  --prompt "Explain what Claude Code is in one sentence." \
  --working-directory $(pwd)
```

**Expected output:** A concise explanation from Gemini about Claude Code.

### Your First Multi-Model Consensus

Now let's ask 3 different AI models the same question:

```bash
claude-code --tool mcp__zen__consensus \
  --models '[
    {"model": "gemini-2.0-flash-exp", "stance": "neutral"},
    {"model": "gpt-4-turbo", "stance": "neutral"},
    {"model": "claude-sonnet-4-5", "stance": "neutral"}
  ]' \
  --step "What is the best programming language to learn in 2025?" \
  --step_number 1 \
  --total_steps 1 \
  --next_step_required false \
  --findings "Starting consensus analysis"
```

**What happens:** All 3 models analyze the question and reach a consensus. You'll see different perspectives and a unified recommendation.

---

## 🔥 Step 3: Your First Real Task (5 minutes)

### Security Scan with Red Zen Gauntlet

Create a sample file with a common vulnerability:

```bash
# Create test file
cat > /tmp/test-security.js << 'EOF'
// Simple Express server with SQL injection vulnerability
const express = require('express');
const app = express();

app.get('/user', (req, res) => {
  const userId = req.query.id;
  const query = `SELECT * FROM users WHERE id = ${userId}`;
  // SQL injection vulnerability!
  db.query(query, (err, results) => {
    res.json(results);
  });
});
EOF
```

Now scan it:

```bash
claude-code --tool mcp__zen__codereview \
  --model gemini-2.0-flash-exp \
  --review_type security \
  --relevant_files '["/tmp/test-security.js"]' \
  --step "Security review of test file" \
  --step_number 1 \
  --total_steps 1 \
  --next_step_required false \
  --findings "Analyzing for security vulnerabilities"
```

**What you'll see:** Gemini identifies the SQL injection vulnerability and suggests fixes!

---

## 🎓 What You Just Learned

1. ✅ **Single Model Chat** - Ask any AI a question
2. ✅ **Multi-Model Consensus** - Get multiple perspectives
3. ✅ **Security Scanning** - Find vulnerabilities automatically

---

## 🚀 Next Steps

### Level Up Your Skills

1. **Read the full guide**: `CLAUDE_CODE_SETUP_GUIDE.md`
2. **Try deep thinking**: Use `mcp__zen__thinkdeep` for complex problems
3. **Debug code**: Use `mcp__zen__debug` to solve bugs systematically
4. **Visual testing**: Set up Playwright for UI testing

### Real-World Tasks to Try

1. **Review your own code**
   ```bash
   claude-code --tool mcp__zen__codereview \
     --model gemini-2.0-flash-exp \
     --review_type full \
     --relevant_files '["src/**/*.ts"]'
   ```

2. **Get help with a bug**
   ```bash
   claude-code --tool mcp__zen__debug \
     --model gemini-2.0-flash-exp \
     --hypothesis "Race condition in async code" \
     --relevant_files '["src/async-handler.ts"]'
   ```

3. **Architecture decision**
   ```bash
   claude-code --tool mcp__zen__consensus \
     --models '[{"model":"gemini-2.0-flash-exp"},{"model":"gpt-4-turbo"}]' \
     --step "Should we use REST or GraphQL for our API?"
   ```

---

## 🆘 Troubleshooting

### "Model not available"
- Verify keys loaded: `echo $GOOGLE_API_KEY`
- Re-run: `source ~/.bashrc`

### "Connection timeout"
- Check network/VPN
- Try different model

### "Permission denied"
- Check file permissions: `ls -la ~/.config/claude-code/api-keys.env`
- Should be: `-rw------- (600)`

---

## 💬 Questions?

1. Read `SECURE_SHARING_GUIDE.md` for security best practices
2. Check `CLAUDE_CODE_SETUP_GUIDE.md` for complete documentation
3. Contact your father if stuck!

---

**Congratulations! You're now set up with cutting-edge AI development tools.** 🎉

Ready to build something amazing together!
