#! /usr/bin/env bash
printf "%s\n" "$(date), $(tput bold)${BASH_SOURCE[0]}$(tput sgr0)"

# generated on 2022-01-10 16:58:49

export elapsed=${SECONDS}

echo "begin: $(date)"
echo ""

echo "Step 1 of 2: dnf update -y"
echo ""

date > results-update.txt
echo "dnf update -y 2>&1 | tee -a results-update.txt" >> results-update.txt
      dnf update -y 2>&1 | tee -a results-update.txt
echo ""

echo "Step 2 of 2: dnf upgrade -y"
echo ""

date > results-upgrade.txt
echo "dnf upgrade -y 2>&1 | tee -a results-upgrade.txt" >> results-upgrade.txt
      dnf upgrade -y 2>&1 | tee -a results-upgrade.txt
echo ""

echo "results posted to results-update.txt and results-upgrade.txt"
echo ""

echo "end: $(date)"

echo ""

export elapsed=$((${SECONDS}-${elapsed}))

printf "time to refresh dnf distribution: %dh:%dm:%ds\n" $(($elapsed/3600)) $(($elapsed%3600/60)) $(($elapsed%60))