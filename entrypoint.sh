#!/bin/bash

setup_path=./run_setup.sh

if [[ ! -f "$setup_path" ]]; then
	echo "Missing $setup_path" && exit 1
fi

if [[ -z "$PIA_PASS" ]]; then
	echo 'Please set the PIA_PASS environment variable' && exit 1
fi

# shellcheck disable=SC1090
source "$setup_path"
