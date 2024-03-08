#!/bin/bash

# Navigate to the main repository root if not already there
# cd /path/to/main/repo  # Uncomment this line and set the correct path

# Backup the .gitmodules file before deleting
if [ -f ".gitmodules" ]; then
  cp .gitmodules .gitmodules.backup
fi

# Deinitialize and remove each submodule
while read submodule; do
  # Extract the submodule path
  path=$(echo $submodule | sed 's/.*path = //')
  
  # Deinitialize the submodule
  git submodule deinit -f "$path"
  
  # Remove the submodule entry from Git's index
  git rm --cached "$path"
  
  # Delete the .git directory in the submodule
  rm -rf "$path/.git"
done < <(grep 'path = ' .gitmodules)

# Remove the .gitmodules file after processing submodules
rm .gitmodules

# Stage the removal of the .gitmodules file and any .git directories
git add .gitmodules
git add .

# Commit the changes
git commit -m "Removed all submodules and their .git directories"

# Optional: Push the changes to the remote repository
# git push origin main  # Uncomment this line if you're sure about auto-pushing
