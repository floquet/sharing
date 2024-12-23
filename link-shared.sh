#!/usr/bin/env bash
# Script to create symlinks to shared resources

SHARED_DIR=~/GitHub/shared
PROJECT_DIR=$1

if [ -z "$PROJECT_DIR" ]; then
    echo "Usage: $0 <project-directory>"
    exit 1
fi

ln -sf $SHARED_DIR/bibliographies/bib-config-a.tex $PROJECT_DIR
ln -sf $SHARED_DIR/setups/aesthetics.tex $PROJECT_DIR
ln -sf $SHARED_DIR/setups/macros-global.tex $PROJECT_DIR
ln -sf $SHARED_DIR/graphics/logos $PROJECT_DIR/logos
ln -sf $SHARED_DIR/bibliographies/example-references.bib $PROJECT_DIR

echo "Symlinks created for $PROJECT_DIR"
