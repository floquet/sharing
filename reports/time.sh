#!/usr/bin/env bash
printf "%s\n" "$(tput bold)$(date) ${BASH_SOURCE[0]}$(tput sgr0)"

start_time=$SECONDS  # Record the start time
elapsed=$((SECONDS - start_time))  # Calculate the elapsed time
echo "${SECONDS}"
echo $elapsed
echo "time used = ${elapsed} sec"
