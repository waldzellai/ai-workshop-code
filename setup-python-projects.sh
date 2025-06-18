#!/bin/bash

# Collective Intelligence Telemetry Integration
# Auto-generated on 2025-06-18 01:11:12 UTC

# Source the enhanced telemetry collector
TELEMETRY_COLLECTOR_PATH="$(dirname "${BASH_SOURCE[0]}")/collective-intelligence/enhanced-telemetry-collector.sh"
if [[ -f "$TELEMETRY_COLLECTOR_PATH" ]]; then
    source "$TELEMETRY_COLLECTOR_PATH"
else
    # Fallback to find collector in parent directories
    for i in {1..5}; do
        TELEMETRY_COLLECTOR_PATH="$(dirname "${BASH_SOURCE[0]}")$(printf '/..'%.0s {1..$i})/collective-intelligence/enhanced-telemetry-collector.sh"
        if [[ -f "$TELEMETRY_COLLECTOR_PATH" ]]; then
            source "$TELEMETRY_COLLECTOR_PATH"
            break
        fi
    done
fi

# Set script name for telemetry
export COLLECTIVE_SCRIPT_NAME="setup-python-projects.sh"

# Original script content below
# ============================================


# Script to set up VS Code project-specific settings for each Python project

# Find all directories directly under projects/ that contain a .venv folder
for project_dir in $(find projects -maxdepth 1 -mindepth 1 -type d); do
  project_name=$(basename "$project_dir")
  echo "Processing project: $project_name"

  # Check if the directory has a .venv inside it
  if [ -d "$project_dir/.venv" ]; then
    echo "Found .venv in $project_name"
    
    # Create .vscode directory if it doesn't exist
    mkdir -p "$project_dir/.vscode"
    
    # Find Python version
    if [ -f "$project_dir/.python-version" ]; then
      python_version=$(cat "$project_dir/.python-version" | tr -d '\n')
    else
      python_version="3.12"  # Default to 3.12 if not specified
    fi
    
    # Create settings.json
    cat > "$project_dir/.vscode/settings.json" << EOL
{
  "python.defaultInterpreterPath": "\${workspaceFolder}/.venv/bin/python",
  "python.analysis.extraPaths": [
    "\${workspaceFolder}/.venv/lib/python$python_version/site-packages"
  ],
  "python.linting.enabled": true,
  "python.analysis.autoSearchPaths": true,
  "python.analysis.diagnosticMode": "workspace",
  "python.analysis.useLibraryCodeForTypes": true,
  "python.analysis.typeCheckingMode": "basic",
  "python.analysis.inlayHints.functionReturnTypes": true,
  "python.analysis.inlayHints.variableTypes": true,
  "python.analysis.importFormat": "absolute"
}
EOL
    echo "Created .vscode/settings.json for $project_name"
  else
    echo "No .venv found in $project_name, skipping"
  fi
done

echo "Setup complete!" 