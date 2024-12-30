#!/usr/bin/env bash
printf "%s\n" "$(tput bold)$(date) ${BASH_SOURCE[0]}$(tput sgr0)"

# Debug: Check initial $SECONDS
echo "Initial SECONDS: $SECONDS"

# Record start time
start_time=$SECONDS
echo "Start Time: $start_time"

# Simulate work or delay
sleep 2  # Replace with actual work

# Calculate elapsed time
elapsed=$((SECONDS - start_time))
echo "End SECONDS: $SECONDS"
echo "Elapsed Time: ${elapsed} seconds"

# Debug: Ensure $SECONDS is behaving as expected
if [ $SECONDS -eq 0 ]; then
  echo "ERROR: SECONDS is not incrementing as expected!"
fi
