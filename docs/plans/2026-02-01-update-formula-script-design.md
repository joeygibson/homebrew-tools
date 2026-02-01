# Update Formula Script Design

## Overview

A generic bash script to automate updating Homebrew formulas to their latest GitHub releases.

**Usage:** `./scripts/update_formula <formula-name>`

**Example:** `./scripts/update_formula jsonquill`

## Requirements

- Takes formula name as single argument
- Extracts GitHub repo from existing formula file
- Fetches latest release from GitHub API
- Updates formula with new version and SHA256
- Shows git diff of changes
- Auto-commits with descriptive message
- Prints message and exits if already at latest version

## Approach

Pure bash script using existing tools: `gh`, `curl`, `shasum`, `sed`, `git`

## Design

### 1. Script Structure and Input Validation

**Location:** `scripts/update_formula`

**Input validation:**
- Verify exactly one argument provided
- Check formula file exists at `Formula/<name>.rb`
- Exit with clear error if not found

**Dependency checks:**
- Verify `gh` CLI available
- Verify `curl` and `shasum` available
- Exit early with helpful message if missing

**Variables to extract:**
- Current version number (from `url` line)
- GitHub repository owner/name (from `url` field)

Uses regex extraction to avoid Ruby parsing complexity.

### 2. Version Discovery and Comparison

**Extract current version:**
- `grep` the `url` line in formula
- Regex extract: `tags/v([0-9.]+).tar.gz`
- Store as `current_version`

**Extract repository:**
- Parse `url` line: `github.com/([^/]+)/([^/]+)/`
- Capture owner/repo (e.g., `joeygibson/jsonquill`)

**Fetch latest release:**
- `gh api repos/{owner}/{repo}/releases/latest`
- Extract `tag_name` with `jq`
- Strip leading 'v' for comparison
- Store as `latest_version`

**Version comparison:**
- If `current_version == latest_version`: print message and exit 0
- If different: proceed with update

**Error handling:**
- `gh api` failure: print error and exit 1
- No releases found: suggest manual update

### 3. Computing SHA256 and Updating Formula

**Compute new SHA256:**
- URL: `https://github.com/{owner}/{repo}/archive/refs/tags/v{latest_version}.tar.gz`
- Command: `curl -sL {url} | shasum -a 256`
- Extract hash (first field)
- Store as `new_sha256`

**Update formula file with sed:**

1. Update URL line:
   ```bash
   sed -i '' 's|tags/v[0-9.]\+|tags/v'${latest_version}'|' Formula/{name}.rb
   ```

2. Update SHA256 line:
   ```bash
   sed -i '' 's|sha256 ".*"|sha256 "'${new_sha256}'"|' Formula/{name}.rb
   ```

**Note:** `-i ''` is macOS syntax for in-place editing without backup.

### 4. Git Operations and Completion

**Show changes:**
- `git diff Formula/{name}.rb`
- Displays URL and SHA256 updates

**Create commit:**
- Stage: `git add Formula/{name}.rb`
- Commit message format:
  ```
  Update {name} to v{latest_version}

  - Updated from v{current_version} to v{latest_version}
  - Updated SHA256 checksum
  ```

**Final output:**
- Success message with version numbers
- Show commit SHA

**Error handling:**
- Git failures: print error and exit 1
- Leave file updated even if commit fails

**Exit codes:**
- 0: Success (updated or already current)
- 1: Error (dependencies, API, file, git)

## Dependencies

- `gh` (GitHub CLI)
- `curl`
- `shasum`
- `sed`
- `git`
- `jq`

## Testing Considerations

- Test with formula already at latest version
- Test with formula needing update
- Test with non-existent formula
- Test with invalid GitHub repo
- Test network failure scenarios
