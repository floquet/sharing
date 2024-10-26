#! /usr/bin/env bash
printf "%s\n" "$(date), $(tput bold)${BASH_SOURCE[0]}$(tput sgr0)"

# Wed Dec 29 18:20:31 MST 2021

# source ../shared/common-header.sh

# timestamp results
export  ymdt=$(date +%Y-%m-%d\ %H:%M) # timestamp results
export ymdtf=$(date +%Y-%m-%d~%H,%M,%d) # timestamp for filename

export step_counter=0
export sub_step_counter=0
export sub_sub_step_counter=0

function pause(){
    echo ""
    echo "press RETURN to continue; ctrl+c to stop"
    read -p "$*"
}

# enumerate steps
function new_step(){
    step_counter=$((step_counter+1))
    echo ""
    echo "Step ${step_counter}: ${1}"
}

# enumerate subsubsteps
function sub_step(){
    sub_step_counter=$((sub_step_counter+1))
    echo ""
    echo "  ${step_counter}.${sub_step_counter}: ${1}"
}

# enumerate substeps
function sub_sub_step(){
    sub_sub_step_counter=$((sub_sub_step_counter+1))
    echo ""
    echo "  ${step_counter}.${sub_step_counter}.${sub_sub_step_counter}: ${1}"
}

# enumerate subsubsteps
# https://unix.stackexchange.com/questions/65932/how-to-get-the-first-word-of-a-string
function spack_sub_step(){
    sub_step_counter=$((sub_step_counter+1))
    echo ""
    echo "  ${step_counter}.${sub_step_counter}: ${1}"
}
