# Claude Code Preferences

This file documents user preferences for how Claude Code should interact and guide through tasks.

**User**: Ankit Jain
**Last Updated**: January 13, 2026

---

## 🎯 Interaction Style Preferences

### Multi-Step Task Guidance: **Interactive CLI Approach**

**Preference**: Use step-by-step interactive prompts with the `AskUserQuestion` tool instead of providing long instruction lists.

#### ❌ Don't Do This:
```
Here are 10 steps to set up Xcode:
1. Open Xcode
2. Click File > New > Project
3. Select iOS > App template
4. Fill in these values...
5. Navigate to this folder...
6. Click Create
7. Delete these files...
8. Add these files...
9. Configure capabilities...
10. Build and run
```

#### ✅ Do This Instead:
```
Step 1: Have you opened Xcode?
  [Yes, Xcode is open]
  [No, I'll open it now]

→ User responds

Step 2: Click File > New > Project. Do you see the template selector?
  [Yes, I see it]
  [Need help finding it]

→ User responds

Step 3: Select iOS > App. Ready for next step?
  [Yes, template selected]
  [Can't find App template]

→ Continue step-by-step...
```

### Why This Approach?

**Benefits**:
- ✅ User can check understanding after each step
- ✅ Catch errors early before proceeding
- ✅ User feels in control of the pace
- ✅ Easier to pause and resume
- ✅ No overwhelming wall of instructions
- ✅ Provides checkpoints for troubleshooting

**Inspired By**: Tools like `gum`, `inquirer`, and interactive CLI wizards that guide users through configuration step-by-step.

---

## 📋 When to Use Interactive Approach

### Always Use For:
- **GUI-based workflows** (Xcode, settings, IDE configuration)
- **Multi-step processes** (>3 steps that depend on each other)
- **Tasks with potential errors** (where each step could fail)
- **First-time setup** (user learning new tools/processes)
- **Complex configurations** (multiple settings to verify)

### Examples:
- Setting up Xcode projects
- Configuring IDE settings
- Walking through deployment processes
- Initial project scaffolding with GUI tools
- Hardware setup (connecting devices, etc.)

### Can Skip Interactive For:
- **Single commands** (just run the command)
- **Quick file edits** (2-3 file changes)
- **Automated scripts** (running CLI tools that don't need input)
- **Documentation reading** (just provide the info)

---

## 🛠️ Implementation Guidelines

### Structure Each Interactive Step:

1. **Clear Action**: Tell user exactly what to do
2. **Verification**: Ask if they completed it or what they see
3. **Options**: Provide 2-4 relevant response options
4. **Handle Issues**: Include troubleshooting options
5. **Checkpoint**: Confirm before moving to next step

### Example Template:
```markdown
## Step N: [Brief Title]

[Clear instruction: "Click X, then do Y"]

AskUserQuestion:
- Question: "What happened?"
- Options:
  - "Success case"
  - "Common issue A"
  - "Common issue B"
  - "Something else / need help"
```

### After Each Response:
- Acknowledge user's response
- Provide relevant feedback
- Either fix issues or proceed to next step
- Never skip ahead without confirmation

---

## 🎨 Communication Style Preferences

### Tone
- **Clear and direct** - no unnecessary fluff
- **Encouraging** when things work
- **Problem-solving** when issues arise
- **Patient** with repeated questions

### Format
- Use **emoji sparingly** for visual markers (✅ ❌ 🔄)
- Use **headers** to chunk information
- Use **code blocks** for commands/code
- Use **lists** for options and steps

### Technical Level
- Explain concepts when introducing new tools
- Don't assume deep knowledge of tools
- Provide context for "why" when relevant
- Skip obvious explanations for experienced areas

---

## 💾 Session Management

### Progress Tracking
- Create checkpoint files like `SETUP_STATUS.md` for complex tasks
- Commit progress to git regularly
- Document current state, completed steps, and next steps
- Make it easy to resume in future sessions

### When Pausing
- Always offer to create an update file
- Include: what's done, current state, next steps
- Provide quick resume command for next session

---

## 🔧 Tool-Specific Preferences

### Git Commits
- Detailed commit messages
- Include Co-Authored-By: Claude Sonnet 4.5
- Commit at logical checkpoints, not just at the end

### File Organization
- Prefer clear folder structure
- Documentation files in root or `/docs`
- Status/checkpoint files in root with clear names

### Code Style
- Follow language conventions (Swift, Python, etc.)
- Include comments for complex logic
- Prefer clarity over cleverness

---

## 📝 Example Session Flow

```
User: "Help me set up [complex thing]"

Claude: [Asks clarifying questions using AskUserQuestion]
      ↓
User: [Provides answers]
      ↓
Claude: "Let's do this step-by-step. Step 1: [instruction]"
      ↓
[Uses AskUserQuestion for checkpoint]
      ↓
User: [Confirms or reports issue]
      ↓
Claude: [Handles response, then next step]
      ↓
[Repeat until complete]
      ↓
Claude: [Offers to create status file if pausing]
```

---

## 🆕 Future Enhancements

Ideas for improving the interactive experience:

1. **Progress Bars**: Show overall progress (Step 3/10)
2. **Undo Option**: Allow going back a step if user made mistake
3. **Summary**: Provide recap of what was accomplished
4. **Estimated Time**: "This should take ~5 more steps"

---

## 📚 References

This preference is inspired by:
- **gum** - Charmbracelet's CLI interaction tool
- **inquirer** - Node.js interactive CLI prompts
- **ClawdBot onboarding** - The experience that inspired this preference
- Interactive terminal UIs that guide users with arrow keys and selections

---

## 🔄 Updates Log

- **2026-01-13**: Initial creation based on Xcode setup session feedback
- Document established during HealthDataExport project setup
- Preference identified when discussing difference between automated vs. interactive approaches

---

**Note to Future Claude Sessions**: Read this file when starting work with this user to understand their preferred interaction style. Prioritize interactive step-by-step guidance over long instruction lists for multi-step tasks.
