#!/bin/bash

# Define what constitutes an "old" branch (e.g., not updated in 3 months)
CUTOFF_DATE=$(date -v -14d +%s)

echo "Cutoff date: ${CUTOFF_DATE}"

# Get a list of all local branches
BRANCHES=$(git branch | cut -c 3-)

for branch in $BRANCHES; do
  # Skip the current branch
  if [ "$branch" = "$(git rev-parse --abbrev-ref HEAD)" ]; then
    continue
  fi
  
  # Skip branches that already start with "old-"
  if [[ "$branch" == old-* ]]; then
    continue
  fi
  
  # Get the timestamp of the last commit on the branch
  LAST_COMMIT_DATE=$(git log -1 --format=%ct "$branch")

  echo $LAST_COMMIT_DATE
  
  if [ "$LAST_COMMIT_DATE" -lt "$CUTOFF_DATE" ]; then
    # Branch is old, rename it with a prefix
    NEW_NAME="old-$branch"
    echo "Renaming $branch to $NEW_NAME"
    git branch -m "$branch" "$NEW_NAME"
  fi
done
