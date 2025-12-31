---
description: Review and update project documentation (excludes CLAUDE.md)
---

You are tasked with reviewing and updating project documentation to ensure it reflects the current state of the codebase.

**CRITICAL CONSTRAINT:**
- ❌ **DO NOT modify CLAUDE.md** - This file is absolutely off-limits
- ✅ Only update other documentation files

**Your task:**

1. **Find all documentation files:**
   ```bash
   find docs -name "*.md"
   ls *.md | grep -v CLAUDE.md
   ```

2. **Review recent changes** to understand what might be outdated:
   ```bash
   git log --oneline -10
   git diff HEAD~5 --stat
   ```

3. **Check for common outdated references:**
   - Module paths that have been moved or renamed
   - Directory structure changes
   - New patterns or conventions introduced
   - Removed features or modules
   - Updated examples or code snippets

4. **Review each documentation file systematically:**
   - `README.md` - Project overview and structure
   - `CLAUDE.md` - AI agent workflow and guidelines
   - `TODO.md` - Project task tracking
   - Any shortcut/cheatsheet docs in the `docs/` directory

5. **Update documentation as needed:**
   - Fix outdated paths and references
   - Update code examples to match current structure
   - Add new sections for recently introduced patterns
   - Remove or update deprecated information

6. **Verify CLAUDE.md is NOT modified:**
   ```bash
   git status
   # Ensure CLAUDE.md is NOT in the changed files list
   ```

7. **Run quality checks:**
   ```bash
   alejandra --check docs/
   ```

8. **Stage and commit documentation changes:**
   ```bash
   git add docs/ README.md *.md
   # Explicitly exclude CLAUDE.md just to be safe
   git reset HEAD CLAUDE.md 2>/dev/null || true
   git commit -m "docs: update documentation for recent changes

   <List key updates made>

   🤖 Generated with [Claude Code](https://claude.com/claude-code)

   Co-Authored-By: Claude <noreply@anthropic.com>"
   ```

9. **Report back:**
   - List of files reviewed
   - What changes were made to each file
   - Confirmation that CLAUDE.md was NOT modified
   - Commit hash (if changes were made)
   - Note if no changes were needed

**Important:**
- Be thorough but only change what's actually outdated
- Preserve the tone and style of existing documentation
- If unsure whether something should be changed, mention it in your report
- Always double-check that CLAUDE.md remains untouched
