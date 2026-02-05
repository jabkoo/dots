#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. "$DIR/../utils.sh"

SSH_KEY_PATH="$HOME/.ssh/id_ed25519"

generate_ssh_key() {
    title "Generating SSH key"

    # Check if key already exists
    if [[ -f "$SSH_KEY_PATH" ]]; then
        err "SSH key already exists at $SSH_KEY_PATH"
        info "If you want to regenerate it, delete the existing key first:
          rm $SSH_KEY_PATH $SSH_KEY_PATH.pub"
        return 1
    fi

    # Get email from git config
    local email
    email=$(git config user.email)

    if [[ -z "$email" ]]; then
        err "Could not read user.email from git config"
        info "Make sure .gitconfig is stowed and contains user.email"
        return 1
    fi

    # Generate key
    if ! ssh-keygen -t ed25519 -C "$email" -f "$SSH_KEY_PATH"; then
        err "ssh-keygen failed"
        return 1
    fi

    # Start ssh-agent and add key
    eval "$(ssh-agent -s)"
    if ! ssh-add --apple-use-keychain "$SSH_KEY_PATH"; then
        err "Failed to add key to keychain"
        return 1
    fi

    # Copy public key to clipboard
    pbcopy < "$SSH_KEY_PATH.pub"
    info "Public key copied to clipboard"

    return 0
}

if generate_ssh_key; then
    ok "SSH key generated successfully!"
else
    err_exit "SSH key generation failed."
fi
