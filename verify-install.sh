#!/bin/bash
# Claude Code Installation Verification Script
# Run this after installation to verify everything works

set -e

echo "🔍 Claude Code Setup Verification"
echo "=================================="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

# Check 1: API Keys File Exists
echo "📁 Checking API keys file..."
if [ -f ~/.config/claude-code/api-keys.env ]; then
    echo -e "${GREEN}✅ API keys file exists${NC}"
else
    echo -e "${RED}❌ API keys file NOT found at ~/.config/claude-code/api-keys.env${NC}"
    echo "   Run: mkdir -p ~/.config/claude-code"
    echo "   Then save your API keys to that location"
    ((ERRORS++))
fi

# Check 2: File Permissions
echo ""
echo "🔒 Checking file permissions..."
if [ -f ~/.config/claude-code/api-keys.env ]; then
    PERMS=$(stat -f "%OLp" ~/.config/claude-code/api-keys.env 2>/dev/null || stat -c "%a" ~/.config/claude-code/api-keys.env 2>/dev/null)
    if [ "$PERMS" = "600" ]; then
        echo -e "${GREEN}✅ File permissions correct (600)${NC}"
    else
        echo -e "${YELLOW}⚠️  File permissions: $PERMS (should be 600)${NC}"
        echo "   Run: chmod 600 ~/.config/claude-code/api-keys.env"
        ((WARNINGS++))
    fi
fi

# Check 3: Environment Variables Loaded
echo ""
echo "🔑 Checking environment variables..."

if [ -n "$GOOGLE_API_KEY" ]; then
    echo -e "${GREEN}✅ GOOGLE_API_KEY loaded${NC}"
else
    echo -e "${RED}❌ GOOGLE_API_KEY not found${NC}"
    echo "   Add to ~/.bashrc or ~/.zshrc:"
    echo '   if [ -f ~/.config/claude-code/api-keys.env ]; then'
    echo '       export $(grep -v "^#" ~/.config/claude-code/api-keys.env | xargs)'
    echo '   fi'
    echo "   Then run: source ~/.bashrc (or source ~/.zshrc)"
    ((ERRORS++))
fi

if [ -n "$OPENAI_API_KEY" ]; then
    echo -e "${GREEN}✅ OPENAI_API_KEY loaded${NC}"
else
    echo -e "${YELLOW}⚠️  OPENAI_API_KEY not found${NC}"
    ((WARNINGS++))
fi

if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo -e "${GREEN}✅ ANTHROPIC_API_KEY loaded${NC}"
else
    echo -e "${YELLOW}⚠️  ANTHROPIC_API_KEY not found${NC}"
    ((WARNINGS++))
fi

# Check 4: Claude Code Installation
echo ""
echo "🤖 Checking Claude Code installation..."
if command -v claude-code &> /dev/null; then
    echo -e "${GREEN}✅ Claude Code CLI installed${NC}"
    claude-code --version 2>/dev/null || echo "   Version check not available"
else
    echo -e "${RED}❌ Claude Code CLI not found${NC}"
    echo "   Install from: https://docs.anthropic.com/claude-code"
    ((ERRORS++))
fi

# Check 5: Test API Connection (optional - only if keys loaded)
if [ -n "$GOOGLE_API_KEY" ] && command -v curl &> /dev/null; then
    echo ""
    echo "🌐 Testing Gemini API connection..."
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        "https://generativelanguage.googleapis.com/v1beta/models?key=$GOOGLE_API_KEY" 2>/dev/null)

    if [ "$RESPONSE" = "200" ]; then
        echo -e "${GREEN}✅ Gemini API connection successful${NC}"
    else
        echo -e "${RED}❌ Gemini API connection failed (HTTP $RESPONSE)${NC}"
        echo "   Check your API key or network connection"
        ((ERRORS++))
    fi
fi

# Summary
echo ""
echo "=================================="
echo "📊 Verification Summary"
echo "=================================="

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}🎉 Perfect! Everything is set up correctly.${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Read QUICK_START.md for your first commands"
    echo "2. Try: claude-code --tool mcp__zen__chat --model gemini-2.0-flash-exp --prompt 'Hello!'"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Setup complete with $WARNINGS warning(s).${NC}"
    echo "   Review warnings above and fix if needed."
    exit 0
else
    echo -e "${RED}❌ Found $ERRORS error(s) and $WARNINGS warning(s).${NC}"
    echo "   Fix the errors above before proceeding."
    exit 1
fi
