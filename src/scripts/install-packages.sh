#!/bin/bash

# Bash "strict mode", to help catch problems and bugs in the shell
# script. Every bash script you write should include this. See
# http://redsymbol.net/articles/unofficial-bash-strict-mode/ for
# details.
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

Install() {
  # Tell apt-get we're never going to be able to give manual
  # feedback:

  TERRAFORM_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
  TERRAGRUNT_URL="https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64"

  # Update the package listing, so we know what package exist:
  sudo apt-get update

  # Install security updates:
  # sudo apt-get -y upgrade

  # Install a new package, without unnecessary recommended packages:
  sudo apt-get -y install --no-install-recommends curl unzip
  pip install pre-commit=="${PRECOMMIT_VERSION}"

  curl -sL "${TERRAFORM_URL}" -o /tmp/terraform.zip \
    && sudo unzip /tmp/terraform.zip -d /usr/local/bin/ \
    && sudo chmod +x /usr/local/bin/terraform \
    && rm -rf /tmp/terraform.zip

  sudo curl -sL "${TERRAGRUNT_URL}" \
    -o /usr/local/bin/terragrunt \
    && sudo chmod +x /usr/local/bin/terragrunt

  # Delete cached files we don't need anymore:
  sudo apt-get purge curl unzip
  sudo apt autoremove
  sudo apt-get clean
  sudo rm -rf /var/lib/apt/lists/*
}

ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Install
fi
