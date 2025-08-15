#!/bin/bash

set -e

# Function to display usage
usage() {
    echo "Usage: $0 [-h] [-b base_branch] [-m max_lines]"
    echo "  -h: Show this help message"
    echo "  -b: Base branch to compare against (default: main)"
    exit 1
}

# Default values
BASE_BRANCH="main"


# Parse command line options
while getopts "hb:" opt; do
    case $opt in
        h) usage ;;
        b) BASE_BRANCH="$OPTARG" ;;
        \?) echo "Invalid option -$OPTARG" >&2; usage ;;
    esac
done

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Check if base branch exists
if ! git show-ref --verify --quiet "refs/heads/$BASE_BRANCH"; then
    echo "Error: '$BASE_BRANCH' branch not found"
    exit 1
fi

# Get the current branch name
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Check if we're on base branch
if [ "$CURRENT_BRANCH" = "$BASE_BRANCH" ]; then
    echo "Error: Currently on $BASE_BRANCH branch. Please switch to your feature branch."
    exit 1
fi


# Get the diff with context
DIFF_OUTPUT=$(git diff "$BASE_BRANCH..")

# Check if there are any changes
if [ -z "$DIFF_OUTPUT" ]; then
    echo "No changes found between $BASE_BRANCH and $CURRENT_BRANCH"
    exit 1
fi


# Create a prompt for the LLM
PROMPT="Generate a small pull request description based on the following git changes.

Branch: $CURRENT_BRANCH -> $BASE_BRANCH

<DIFF>
$DIFF_OUTPUT
</Diff>

1. **Summary**: One-line description of the changes.
2. **Description**: Detailed explanation of what was changed and why.
3. **Checklist**: Any important considerations or impacts.


Format the response in GitHub-flavored markdown.
"

echo "Generated prompt:"
echo "********************************************"
echo "$PROMPT"
echo "********************************************"

read -p "Continue? [Y/n]" choice

if [ "$choice" = "Y" ] || [ "$choice" = "y" ] || [ "$choice" = "" ]; then
    echo ""
else
    echo "exiting"
    exit 0
fi

# Generate PR description using llm command
echo "Analyzing changes and generating PR description..."
PR_DESCRIPTION=$(echo "$PROMPT" | llm)


# Display the generated description
echo ""
echo "==================== Generated PR Description ===================="
echo "$PR_DESCRIPTION"
echo "=====================END=========================================="
echo ""

# Save options
echo "Options:"
echo "1) Save to file"
echo "2) Copy to clipboard"
echo "3) Exit without saving"
read -p "Choose an option (1-4): " -n 1 -r
echo ""

if [ $REPLY = "1" ]; then
        FILENAME="pr-description-$(date +%Y%m%d-%H%M%S).md"
        echo "$PR_DESCRIPTION" > "$FILENAME"
        echo "PR description saved to: $FILENAME"
elif [ $REPLY = "2" ]; then

    if command -v xclip > /dev/null 2>&1; then
        echo "$PR_DESCRIPTION" | xclip -selection clipboard
        echo "✓ PR description copied to clipboard!"
    elif command -v clip.exe > /dev/null 2>&1; then
        echo "$FULL_DESCRIPTION" | clip.exe
        echo "✓ PR description copied to clipboard!"
    else
        echo "⚠ Clipboard command not found. Please copy manually from the file."
    fi
else
    echo "no choice made"
    exit 0
fi
