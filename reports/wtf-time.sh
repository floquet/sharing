#!/bin/bash

start_time=$SECONDS
sleep 2
elapsed=$((SECONDS - start_time))

# Both work fine:
echo "$SECONDS"
echo "${SECONDS}"

# Preferred for clarity in strings:
echo "Elapsed time: ${elapsed} seconds"
		