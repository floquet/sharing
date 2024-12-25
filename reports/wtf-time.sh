#!/usr/bin/env bash
printf "%s\n" "$(tput bold)$(date) ${BASH_SOURCE[0]}$(tput sgr0)"

start_time=$SECONDS
sleep 2
elapsed=$((SECONDS - start_time))

# Both work fine:
echo "$SECONDS"
echo "${SECONDS}"

# Preferred for clarity in strings:
echo "Elapsed time: ${elapsed} seconds"
		