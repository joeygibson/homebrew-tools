# Update Formula Script Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a generic bash script that automates updating Homebrew formulas to their latest GitHub releases.

**Architecture:** Pure bash script that extracts repo info from existing formula, fetches latest release via GitHub API, computes SHA256, updates formula file with sed, and auto-commits changes.

**Tech Stack:** Bash, gh CLI, curl, shasum, sed, git, jq

---

## Task 1: Create Script Skeleton with Input Validation

**Files:**
- Create: `scripts/update_formula`

**Step 1: Create executable script with shebang and strict mode**

```bash
#!/usr/bin/env bash
set -euo pipefail

# Usage: update_formula <formula-name>
# Example: update_formula jsonquill
```

**Step 2: Add usage validation**

```bash
#!/usr/bin/env bash
set -euo pipefail

# Usage: update_formula <formula-name>
# Example: update_formula jsonquill

if [[ $# -ne 1 ]]; then
    echo "Usage: update_formula <formula-name>" >&2
    echo "Example: update_formula jsonquill" >&2
    exit 1
fi

formula_name="$1"
formula_file="Formula/${formula_name}.rb"
```

**Step 3: Verify formula file exists**

```bash
#!/usr/bin/env bash
set -euo pipefail

# Usage: update_formula <formula-name>
# Example: update_formula jsonquill

if [[ $# -ne 1 ]]; then
    echo "Usage: update_formula <formula-name>" >&2
    echo "Example: update_formula jsonquill" >&2
    exit 1
fi

formula_name="$1"
formula_file="Formula/${formula_name}.rb"

if [[ ! -f "$formula_file" ]]; then
    echo "Error: Formula file not found: $formula_file" >&2
    exit 1
fi
```

**Step 4: Make script executable**

Run: `chmod +x scripts/update_formula`

**Step 5: Test with valid formula**

Run: `./scripts/update_formula jsonquill`
Expected: No error (script proceeds past validation)

**Step 6: Test with invalid formula**

Run: `./scripts/update_formula nonexistent`
Expected: "Error: Formula file not found: Formula/nonexistent.rb"

**Step 7: Test with no arguments**

Run: `./scripts/update_formula`
Expected: Usage message displayed

**Step 8: Commit**

```bash
git add scripts/update_formula
git commit -m "feat: add update_formula script skeleton with input validation

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Task 2: Add Dependency Checks

**Files:**
- Modify: `scripts/update_formula:17-35`

**Step 1: Add dependency check function after validation code**

```bash
# Check required dependencies
for cmd in gh curl shasum sed git jq; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: Required command '$cmd' not found" >&2
        echo "Please install $cmd and try again" >&2
        exit 1
    fi
done
```

**Step 2: Test with dependencies present**

Run: `./scripts/update_formula jsonquill`
Expected: No error about missing dependencies

**Step 3: Test dependency check (simulate missing command)**

Run: `PATH="" ./scripts/update_formula jsonquill`
Expected: Error message about missing required commands

**Step 4: Commit**

```bash
git add scripts/update_formula
git commit -m "feat: add dependency checks for required commands

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Task 3: Extract Current Version and Repository

**Files:**
- Modify: `scripts/update_formula:28-50`

**Step 1: Add version extraction after dependency checks**

```bash
# Extract current version from formula URL line
url_line=$(grep '^\s*url "' "$formula_file")
if [[ ! "$url_line" =~ tags/v([0-9.]+)\.tar\.gz ]]; then
    echo "Error: Could not extract version from formula URL" >&2
    exit 1
fi
current_version="${BASH_REMATCH[1]}"
```

**Step 2: Add repository extraction**

```bash
# Extract GitHub repository (owner/repo)
if [[ ! "$url_line" =~ github\.com/([^/]+)/([^/]+)/archive ]]; then
    echo "Error: Could not extract GitHub repository from formula URL" >&2
    exit 1
fi
repo_owner="${BASH_REMATCH[1]}"
repo_name="${BASH_REMATCH[2]}"
repo="$repo_owner/$repo_name"
```

**Step 3: Add debug output to verify extraction**

```bash
echo "Current version: v$current_version"
echo "Repository: $repo"
```

**Step 4: Test extraction with jsonquill**

Run: `./scripts/update_formula jsonquill`
Expected: Output shows "Current version: v0.7.0" and "Repository: joeygibson/jsonquill"

**Step 5: Commit**

```bash
git add scripts/update_formula
git commit -m "feat: extract current version and repository from formula

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Task 4: Fetch Latest Release from GitHub

**Files:**
- Modify: `scripts/update_formula:53-70`

**Step 1: Add GitHub API call to fetch latest release**

```bash
# Fetch latest release from GitHub
echo "Fetching latest release for $repo..."
if ! release_json=$(gh api "repos/$repo/releases/latest" 2>&1); then
    echo "Error: Failed to fetch latest release from GitHub" >&2
    echo "$release_json" >&2
    exit 1
fi

# Extract tag name and strip leading 'v'
tag_name=$(echo "$release_json" | jq -r '.tag_name')
latest_version="${tag_name#v}"
```

**Step 2: Add version comparison**

```bash
# Compare versions
if [[ "$current_version" == "$latest_version" ]]; then
    echo "Formula $formula_name is already at latest version v$latest_version"
    exit 0
fi

echo "Update available: v$current_version -> v$latest_version"
```

**Step 3: Test with formula at current version**

Run: `./scripts/update_formula jsonquill` (assuming jsonquill is at v0.12.0)
Expected: "Formula jsonquill is already at latest version v0.12.0" and exit 0

**Step 4: Test by temporarily changing version in formula**

Run: `sed -i '' 's/v0.12.0/v0.11.0/' Formula/jsonquill.rb && ./scripts/update_formula jsonquill`
Expected: "Update available: 0.11.0 -> 0.12.0"

Run: `git checkout Formula/jsonquill.rb` (restore formula)

**Step 5: Commit**

```bash
git add scripts/update_formula
git commit -m "feat: fetch latest release and compare versions

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Task 5: Compute SHA256 for New Version

**Files:**
- Modify: `scripts/update_formula:73-85`

**Step 1: Add SHA256 computation**

```bash
# Compute SHA256 for new version
tarball_url="https://github.com/$repo/archive/refs/tags/v${latest_version}.tar.gz"
echo "Computing SHA256 for $tarball_url..."
if ! sha_output=$(curl -sL "$tarball_url" | shasum -a 256 2>&1); then
    echo "Error: Failed to download tarball or compute SHA256" >&2
    echo "$sha_output" >&2
    exit 1
fi

# Extract just the hash (first field)
new_sha256=$(echo "$sha_output" | awk '{print $1}')
echo "New SHA256: $new_sha256"
```

**Step 2: Test SHA256 computation**

Run: Edit formula to set version to 0.11.0, then run `./scripts/update_formula jsonquill`
Expected: Downloads tarball and displays SHA256 hash

**Step 3: Restore formula**

Run: `git checkout Formula/jsonquill.rb`

**Step 4: Commit**

```bash
git add scripts/update_formula
git commit -m "feat: compute SHA256 for new version tarball

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Task 6: Update Formula File

**Files:**
- Modify: `scripts/update_formula:88-105`

**Step 1: Add sed commands to update formula**

```bash
# Update formula file
echo "Updating $formula_file..."

# Update version in URL line
sed -i '' "s|tags/v[0-9.]\+\.tar\.gz|tags/v${latest_version}.tar.gz|" "$formula_file"

# Update SHA256 line
sed -i '' "s|sha256 \".*\"|sha256 \"$new_sha256\"|" "$formula_file"
```

**Step 2: Add git diff to show changes**

```bash
# Show what changed
echo ""
echo "Changes made:"
git diff "$formula_file"
```

**Step 3: Test formula update**

Run: Edit formula to v0.11.0, run `./scripts/update_formula jsonquill`
Expected: Formula file updated, git diff shows URL and SHA256 changes

**Step 4: Verify formula syntax**

Run: `cat Formula/jsonquill.rb | grep -E '(url|sha256)'`
Expected: Updated version and SHA256 visible

**Step 5: Restore formula**

Run: `git checkout Formula/jsonquill.rb`

**Step 6: Commit**

```bash
git add scripts/update_formula
git commit -m "feat: update formula file with sed commands

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Task 7: Create Git Commit

**Files:**
- Modify: `scripts/update_formula:108-125`

**Step 1: Add git commit logic**

```bash
# Create git commit
echo ""
echo "Creating commit..."
git add "$formula_file"

commit_message="Update $formula_name to v$latest_version

- Updated from v$current_version to v$latest_version
- Updated SHA256 checksum

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

if ! git commit -m "$commit_message" 2>&1; then
    echo "Error: Failed to create git commit" >&2
    echo "Formula file has been updated but not committed" >&2
    exit 1
fi

commit_sha=$(git rev-parse --short HEAD)
echo "Successfully updated $formula_name from v$current_version to v$latest_version"
echo "Commit: $commit_sha"
```

**Step 2: Test full workflow**

Run: Edit formula to v0.11.0, run `./scripts/update_formula jsonquill`
Expected:
- Formula updated
- Git diff displayed
- Commit created
- Success message with commit SHA

**Step 3: Verify commit**

Run: `git log -1 --oneline`
Expected: Shows commit for updating jsonquill to v0.12.0

**Step 4: Verify commit message**

Run: `git log -1`
Expected: Multi-line commit message with version info and co-author

**Step 5: Reset commit for clean state**

Run: `git reset --hard HEAD~1`

**Step 6: Commit**

```bash
git add scripts/update_formula
git commit -m "feat: create git commit with descriptive message

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Task 8: Integration Testing

**Files:**
- Test: `scripts/update_formula`

**Step 1: Test with formula at latest version**

Run: `./scripts/update_formula jsonquill`
Expected: "Formula jsonquill is already at latest version v0.12.0"

**Step 2: Test with formula needing update**

Setup:
```bash
sed -i '' 's/v0.12.0/v0.11.0/' Formula/jsonquill.rb
sed -i '' 's/sha256 ".*"/sha256 "oldsha256here"/' Formula/jsonquill.rb
```

Run: `./scripts/update_formula jsonquill`
Expected:
- Shows current v0.11.0 -> v0.12.0
- Downloads and computes SHA256
- Updates formula
- Shows git diff
- Creates commit
- Success message

**Step 3: Verify updated formula**

Run: `cat Formula/jsonquill.rb | grep -E '(url|sha256)'`
Expected: v0.12.0 and correct SHA256

**Step 4: Verify commit**

Run: `git log -1`
Expected: Proper commit message with version details

**Step 5: Test with non-existent formula**

Run: `./scripts/update_formula nosuchformula`
Expected: "Error: Formula file not found: Formula/nosuchformula.rb"

**Step 6: Test with no arguments**

Run: `./scripts/update_formula`
Expected: Usage message

**Step 7: Commit test results documentation**

Create file documenting successful tests, then:
```bash
git add docs/
git commit -m "docs: add integration test results

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Task 9: Add yamlquill Formula Support

**Files:**
- Test: `Formula/yamlquill.rb`
- Test: `scripts/update_formula`

**Step 1: Check yamlquill formula**

Run: `cat Formula/yamlquill.rb`
Expected: View current yamlquill formula structure

**Step 2: Test update_formula with yamlquill**

Run: `./scripts/update_formula yamlquill`
Expected: Script works with yamlquill formula (either updates or reports already current)

**Step 3: Verify script handles multiple formulas**

Run: `./scripts/update_formula jsonquill && ./scripts/update_formula yamlquill`
Expected: Both formulas processed correctly

**Step 4: Commit any updates**

If yamlquill was updated:
```bash
git add Formula/yamlquill.rb
git commit -m "chore: update yamlquill to latest version

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Completion Criteria

- ✅ Script validates input and checks dependencies
- ✅ Extracts current version and repository from formula
- ✅ Fetches latest release from GitHub API
- ✅ Handles "already at latest version" case gracefully
- ✅ Computes SHA256 for new version
- ✅ Updates formula file with sed
- ✅ Shows git diff of changes
- ✅ Creates descriptive git commit
- ✅ Works with multiple formulas (jsonquill, yamlquill)
- ✅ Proper error handling throughout
- ✅ All tests pass

## Follow-up

After implementation, use @superpowers:finishing-a-development-branch to integrate work back to main branch.
