#!/bin/sh
cd "$(dirname "$0")"
ansible-playbook check_updates.yml
./scripts/makehtml.sh
