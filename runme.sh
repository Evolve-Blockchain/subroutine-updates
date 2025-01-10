#!/bin/bash

# Define constants
CORE_BLOCKCHAIN_PATH="/root/Core-Blockchain"
NODE_BIN_PATH="$CORE_BLOCKCHAIN_PATH/node_src/build/bin"
PLUGIN_PATH="$CORE_BLOCKCHAIN_PATH/plugins/sync-helper"

# Helper function for pretty UI
echo_info() {
  echo -e "\e[34m[INFO]\e[0m $1"
}

echo_success() {
  echo -e "\e[32m[SUCCESS]\e[0m $1"
}

echo_error() {
  echo -e "\e[31m[ERROR]\e[0m $1"
}

# Check if a parameter is provided
if [[ -z $1 ]]; then
  echo_error "No parameter provided. Use --update or --rollback."
  exit 1
fi

# Handle the update operation
if [[ "$1" == "--update" ]]; then
  echo_info "Starting update process..."

  # Rename the files to .bak
  if [[ -f "$NODE_BIN_PATH/geth" ]]; then
    mv "$NODE_BIN_PATH/geth" "$NODE_BIN_PATH/geth.bak"
    echo_success "Renamed geth to geth.bak"
  else
    echo_error "geth not found in $NODE_BIN_PATH"
  fi

  if [[ -f "$PLUGIN_PATH/index.js" ]]; then
    mv "$PLUGIN_PATH/index.js" "$PLUGIN_PATH/index.js.bak"
    echo_success "Renamed index.js to index.js.bak"
  else
    echo_error "index.js not found in $PLUGIN_PATH"
  fi

  # Copy the new files
  if [[ -f "./geth" ]]; then
    cp "./geth" "$NODE_BIN_PATH/geth"
    echo_success "Copied new geth to $NODE_BIN_PATH"
  else
    echo_error "New geth file not found in the current directory."
  fi

  if [[ -f "./index.js" ]]; then
    cp "./index.js" "$PLUGIN_PATH/index.js"
    echo_success "Copied new index.js to $PLUGIN_PATH"
  else
    echo_error "New index.js file not found in the current directory."
  fi

  echo_success "Update process completed."

# Handle the rollback operation
elif [[ "$1" == "--rollback" ]]; then
  echo_info "Starting rollback process..."

  # Remove the new files and restore the .bak files
  if [[ -f "$NODE_BIN_PATH/geth" ]]; then
    rm "$NODE_BIN_PATH/geth"
    echo_success "Removed current geth file"
  fi

  if [[ -f "$NODE_BIN_PATH/geth.bak" ]]; then
    mv "$NODE_BIN_PATH/geth.bak" "$NODE_BIN_PATH/geth"
    echo_success "Restored geth.bak to geth"
  else
    echo_error "geth.bak not found in $NODE_BIN_PATH"
  fi

  if [[ -f "$PLUGIN_PATH/index.js" ]]; then
    rm "$PLUGIN_PATH/index.js"
    echo_success "Removed current index.js file"
  fi

  if [[ -f "$PLUGIN_PATH/index.js.bak" ]]; then
    mv "$PLUGIN_PATH/index.js.bak" "$PLUGIN_PATH/index.js"
    echo_success "Restored index.js.bak to index.js"
  else
    echo_error "index.js.bak not found in $PLUGIN_PATH"
  fi

  echo_success "Rollback process completed."

# Handle invalid parameters
else
  echo_error "Invalid parameter. Use --update or --rollback."
  exit 1
fi
