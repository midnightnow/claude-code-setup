# Claude Code Setup Guide
*Setup guide for getting started with Claude Code + Zen MCP + Multi-Model Integration*

## Table of Contents
1. [Initial Setup](#initial-setup)
2. [API Keys Configuration](#api-keys-configuration)
3. [Zen MCP Server Setup](#zen-mcp-server-setup)
4. [Red Zen Gemini Gauntlet](#red-zen-gemini-gauntlet)
5. [Playwright MCP Integration](#playwright-mcp-integration)
6. [Useful Workflows](#useful-workflows)

---

## Initial Setup

### 1. Install Claude Code
```bash
# Install Claude Code CLI
npm install -g @anthropic-ai/claude-code

# Or use Homebrew (macOS)
brew install claude-code
```

### 2. Configure Claude Code
```bash
# Initialize Claude Code in your project
claude-code init

# Set your Anthropic API key
export ANTHROPIC_API_KEY="your-anthropic-api-key-here"
```

---

## API Keys Configuration

### Required API Keys

Create a file `~/.config/claude-code/api-keys.env` (DO NOT commit this to git):

```bash
# Anthropic (Claude)
ANTHROPIC_API_KEY="sk-ant-xxxxx"

# Google Gemini
GOOGLE_API_KEY="AIzaSyXXXXX"
GEMINI_API_KEY="AIzaSyXXXXX"

# Qwen (Alibaba Cloud)
QWEN_API_KEY="sk-xxxxx"
DASHSCOPE_API_KEY="sk-xxxxx"

# OpenAI (ChatGPT)
OPENAI_API_KEY="sk-xxxxx"

# Optional: Other providers
TOGETHER_API_KEY="xxxxx"
GROQ_API_KEY="gsk_xxxxx"
```

### Actual Keys to Use
**REPLACE THESE BEFORE SHARING:**

```
GOOGLE_API_KEY="[I'll add your key here]"
QWEN_API_KEY="[I'll add your key here]"
OPENAI_API_KEY="[I'll add your key here]"
```

### Load Keys Automatically
Add to your `~/.bashrc` or `~/.zshrc`:

```bash
# Load Claude Code API keys
if [ -f ~/.config/claude-code/api-keys.env ]; then
    export $(grep -v '^#' ~/.config/claude-code/api-keys.env | xargs)
fi
```

---

## Zen MCP Server Setup

### What is Zen MCP?
Zen MCP is a Model Context Protocol server that provides:
- Multi-model consensus (chat with multiple AIs simultaneously)
- Deep thinking workflows (thinkdeep, debug, codereview)
- Code review automation
- Pre-commit validation
- Security gauntlets (Red Zen)

### Installation

```bash
# Install Zen MCP
pip install zen-mcp

# Or install from source
git clone https://github.com/zen-mcp/zen-mcp.git
cd zen-mcp
pip install -e .
```

### Configuration

Create `~/.config/claude-code/mcp.json`:

```json
{
  "mcpServers": {
    "zen": {
      "command": "python",
      "args": ["-m", "zen_mcp"],
      "env": {
        "GOOGLE_API_KEY": "${GOOGLE_API_KEY}",
        "OPENAI_API_KEY": "${OPENAI_API_KEY}",
        "QWEN_API_KEY": "${QWEN_API_KEY}"
      }
    },
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp-server"]
    },
    "voice-mode": {
      "command": "npx",
      "args": ["@voice-mode/mcp-server"]
    }
  }
}
```

### Available Zen Tools

Once configured, you'll have access to:

- `mcp__zen__chat` - Multi-model chat
- `mcp__zen__consensus` - Get consensus from multiple models
- `mcp__zen__thinkdeep` - Deep investigation and reasoning
- `mcp__zen__debug` - Systematic debugging
- `mcp__zen__codereview` - Automated code review
- `mcp__zen__precommit` - Pre-commit validation
- `mcp__zen__planner` - Task planning with multiple models
- `mcp__zen__challenge` - Critical analysis (prevents reflexive agreement)

---

## Red Zen Gemini Gauntlet

### What is the Red Zen Gauntlet?
A comprehensive security and quality testing framework that runs multiple validation passes:

1. **Security Analysis** (XSS, CSRF, injection attacks)
2. **Code Quality** (complexity, maintainability)
3. **Performance** (bottlenecks, optimization opportunities)
4. **Accessibility** (WCAG compliance)
5. **Visual Regression** (UI changes)

### How to Use

#### Basic Security Scan
```bash
# Run Red Zen gauntlet on current changes
claude-code --tool mcp__zen__codereview \
  --review-type security \
  --relevant-files "$(git diff --name-only)"
```

#### Pre-Commit Hook
Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash

echo "Running Red Zen Gauntlet..."

# Get list of changed files
CHANGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(ts|tsx|js|jsx|py)$')

if [ -z "$CHANGED_FILES" ]; then
    echo "No code files changed, skipping gauntlet"
    exit 0
fi

# Run security review
claude-code --non-interactive --tool mcp__zen__precommit \
  --path "$(pwd)" \
  --include-staged true \
  --precommit-type external \
  --focus-on "security,performance"

if [ $? -ne 0 ]; then
    echo "❌ Red Zen Gauntlet found issues - commit blocked"
    exit 1
fi

echo "✅ Red Zen Gauntlet passed"
exit 0
```

#### Deep Analysis with Latest Gemini
```bash
# Use latest Gemini 2.0 Flash Experimental for deep security analysis
# This is the recommended model for Red Zen Gauntlet (Dec 2024 release)
claude-code --tool mcp__zen__thinkdeep \
  --model "gemini-2.0-flash-exp" \
  --focus-areas "security,architecture" \
  --relevant-files "src/auth/**/*.ts"
```

### Gauntlet Configuration

Create `.claude/gauntlet-config.json`:

```json
{
  "security": {
    "enabled": true,
    "severity_threshold": "medium",
    "checks": [
      "xss",
      "csrf",
      "sql_injection",
      "command_injection",
      "path_traversal",
      "sensitive_data_exposure"
    ]
  },
  "models": {
    "primary": "claude-sonnet-4-5",
    "validators": [
      "gemini-2.0-flash-exp",
      "gpt-4-turbo"
    ]
  },
  "thresholds": {
    "code_quality_min": 80,
    "security_score_min": 95,
    "performance_score_min": 70
  }
}
```

**Note**: Uses latest Gemini 2.0 Flash Experimental (Dec 2024) for best performance.

---

## Playwright MCP Integration

### Setup Playwright
```bash
# Install Playwright
npm install -D @playwright/test
npx playwright install

# Install Playwright MCP server
npm install -g @playwright/mcp-server
```

### Visual Testing Workflow

```javascript
// playwright.config.ts
import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  use: {
    screenshot: 'on',
    video: 'retain-on-failure',
  },
  reporter: [
    ['html'],
    ['json', { outputFile: 'test-results.json' }]
  ]
});
```

### Integration with Claude Code

```bash
# Take screenshot of current state
claude-code --tool mcp__playwright__browser_snapshot

# Run visual regression test
claude-code --tool mcp__playwright__browser_take_screenshot \
  --filename "baseline/homepage.png"

# Navigate and test
claude-code --tool mcp__playwright__browser_navigate \
  --url "http://localhost:3000"
```

---

## Useful Workflows

### 1. Multi-Model Code Review

```bash
# Get consensus from 3 different models on a code change
# Uses latest Gemini 2.0 Flash Experimental (Dec 2024 - recommended)
claude-code --tool mcp__zen__consensus \
  --models '[
    {"model": "gemini-2.0-flash-exp", "stance": "for"},
    {"model": "gpt-4-turbo", "stance": "against"},
    {"model": "claude-sonnet-4-5", "stance": "neutral"}
  ]' \
  --step "Evaluate the following authentication implementation for security and usability" \
  --relevant-files "src/auth/login.ts"
```

### 2. Deep Bug Investigation

```bash
# Use latest Gemini 2.0 Flash Experimental for deep reasoning
# This is the current stable release (Dec 2024)
claude-code --tool mcp__zen__debug \
  --model "gemini-2.0-flash-exp" \
  --thinking-mode "max" \
  --hypothesis "Race condition in async auth flow" \
  --relevant-files "src/auth/**/*.ts"
```

### 3. Automated Pre-Commit Check (with Latest Gemini)

```bash
# Comprehensive pre-commit validation
claude-code --tool mcp__zen__precommit \
  --path "$(pwd)" \
  --include-staged true \
  --include-unstaged false \
  --focus-on "security,performance,accessibility" \
  --severity-filter "medium"
```

### 4. Visual + Security Review

```bash
# Combined visual and security review
claude-code --tool mcp__playwright__browser_navigate --url "http://localhost:3000" && \
claude-code --tool mcp__playwright__browser_snapshot && \
claude-code --tool mcp__zen__codereview \
  --review-type "full" \
  --relevant-files "src/components/**/*.tsx"
```

---

## Quick Reference Commands

### Check MCP Server Status
```bash
claude-code mcp status
```

### List Available Models
```bash
claude-code --tool mcp__zen__listmodels
```

### Test API Keys
```bash
# Test Gemini
curl -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=$GOOGLE_API_KEY" \
  -H 'Content-Type: application/json' \
  -d '{"contents":[{"parts":[{"text":"Hello"}]}]}'

# Test OpenAI
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer $OPENAI_API_KEY"

# Test Qwen
curl -X POST https://dashscope.aliyuncs.com/api/v1/services/aigc/text-generation/generation \
  -H "Authorization: Bearer $QWEN_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"qwen-max","input":{"prompt":"Hello"}}'
```

---

## Troubleshooting

### MCP Server Not Connecting
```bash
# Check server logs
tail -f ~/.claude/mcp-server.log

# Restart MCP servers
claude-code mcp restart zen
```

### API Key Issues
```bash
# Verify keys are loaded
echo $GOOGLE_API_KEY
echo $OPENAI_API_KEY
echo $QWEN_API_KEY

# Reload environment
source ~/.bashrc  # or ~/.zshrc
```

### Playwright Issues
```bash
# Reinstall browsers
npx playwright install --force

# Check browser status
npx playwright install --dry-run
```

---

## Best Practices

1. **Always use Red Zen Gauntlet before committing** - Catches security issues early
2. **Run visual tests on UI changes** - Prevents regression
3. **Use multi-model consensus for important decisions** - Gets diverse perspectives
4. **Keep API keys in environment files** - Never commit to git
5. **Set up pre-commit hooks** - Automates quality checks

---

## Resources

- Claude Code Docs: https://docs.anthropic.com/claude-code
- Zen MCP GitHub: https://github.com/zen-mcp/zen-mcp
- Playwright MCP: https://playwright.dev/docs/mcp
- Gemini API: https://ai.google.dev/docs
- OpenAI API: https://platform.openai.com/docs
- Qwen API: https://help.aliyun.com/zh/dashscope

---

## Support

If you run into issues:
1. Check the troubleshooting section above
2. Review MCP server logs: `~/.claude/mcp-server.log`
3. Ask in Claude Code community
4. Contact me!

---

**Last Updated**: 2025-11-24
**Version**: 1.0

Happy coding! 🚀
