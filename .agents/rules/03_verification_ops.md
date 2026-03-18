# 🧪 VERIFICATION & SENIOR OPS

## 🛠️ Tooling & MCP Priority
- **Always use MCP tools** (`analyze_files`, `run_tests`, `hot_reload`) over raw shell commands.
- Use `get_widget_tree` to debug UI before making changes.
- **Strict Dependencies:** Packages must be latest stable. Use `pub_dev_search` or `read_url_content` to verify latest versions.

## 🧪 Testing Best Practices
- **Conventional Pattern:** Arrange-Act-Assert.
- **Unit Tests:** Mandatory for Use Cases, Cubits, and Repo logic.
- **Widget Tests:** Required for critical shared components.
- **Mocks:** Prefer fakes/stubs. Use `mocktail` for null-safe mocking.

## 🚫 AI Anti-Patterns
- **No Unsolicited Refactoring:** Never touch code outside the scope.
- **No Over-Explaining:** Match response depth to task complexity.
- **No Hallucinating APIs:** If unsure, check documentation via `read_url_content`.
- **No Full File Regeneration:** Show only changed code + minimal context.

## ✅ Mandatory Self-Review
Run this check mentally before every response:
1. Root cause addressed?
2. Smallest safe change?
3. Layer boundaries respected?
4. No security/perf regressions?
5. No silent failures?

## 📬 PR Output
Generate a PR summary only on demand when using "Generate PR":
- Branch, Commit, PR Title, Detailed Summary, Changes list, and Testing verification.
