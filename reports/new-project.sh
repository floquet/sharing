#!/bin/bash
printf "%s\n" "$(tput bold)$(date) ${BASH_SOURCE[0]}$(tput sgr0)"

# ===========================================================
# Script: new_project.sh
# Author: ChatGPT (Achates), with guidance from Daniel Topa
# Fri Dec 20 14:29:59 MST 2024
#
# Task:
# Automates the creation of LaTeX-based project directories for Daniel's work.
# This script ensures that every new project has a consistent structure, seeded
# with essential files (e.g., main LaTeX file, section templates, local setup).
#
# Perspective:
# When starting a new project, manually setting up directory structures and
# copying templates can be tedious and error-prone. By automating this process,
# we free up cognitive load and focus more on actual content creation rather
# than boilerplate tasks.
#
# Advantages:
# - Ensures uniformity across projects.
# - Saves time and reduces setup errors.
# - Provides a ready-to-compile LaTeX file, streamlining the workflow.
# ===========================================================

# Perspective:
# I believe in automating tedious tasks to maximize productivity. 
# By setting up the foundation programmatically, your time is freed 
# for more creative and technical pursuits.

# ./new-project.sh hpc-pdes

export SECONDS=0

# Define base path
BASE_DIR=~/GitHub/sharing/reports
PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: $0 <project_name>"
  exit 1
fi

# Define project path
PROJECT_DIR="$BASE_DIR/$PROJECT_NAME"

# Define subdirectories
SUBDIRS=("local" "main" "sections")

# Create directory structure
echo "Creating project directory: $PROJECT_DIR"
mkdir -p "$PROJECT_DIR"

for SUBDIR in "${SUBDIRS[@]}"; do
  mkdir -p "$PROJECT_DIR/$SUBDIR"
done

# Seed initial files
echo "Seeding initial files..."
# Create main LaTeX file
cat << EOF > "$PROJECT_DIR/main/main-$PROJECT_NAME.tex"
% typeset: Pdftex
% Afterwards compile with pdflatex > bibtex > pdflatex > pdflatex.
% CLI: pdflatex main-$PROJECT_NAME.tex
% Beamer likes biber
\documentclass[10pt, oneside]{article}
\usepackage{enumitem} % List formatting
\usepackage{pdfpages}
\usepackage{catchfile}

% Fetch home directory
\CatchFileDef{\HomePath}{|kpsewhich -var-value=HOME}{}
% Define base paths
\makeatletter
\edef\HomePath{\expandafter\zap@space\HomePath \@empty}
\makeatother
\newcommand{\pGithub}          {\HomePath/GitHub/}
\newcommand{\pGithubSharing}   {\pGithub/sharing/}
\newcommand{\pLocalSetup}      {\pGithubSharing/reports/$PROJECT_NAME/local/}
\newcommand{\pSections}        {\pGithubSharing/reports/$PROJECT_NAME/sections/}
% Load Additional Setup Files
\input{\pLocalSetup/setup-local.tex}

\title{$PROJECT_NAME}
\author{Daniel Topa}
\begin{document}
	%\input{\pSections sec-abstract.tex}
\maketitle
\tableofcontents

	\input{\pSections sec-intro.tex}
	\input{\pSections sec-backup.tex}

\end{document}
EOF

# Seed sections with templates
cat << 'EOF' > "$PROJECT_DIR/sections/sec-intro.tex"
% ===========================================================
% Introduction Section for $PROJECT_NAME
% This file contains the main introduction and its subsections.
% ===========================================================

% \input{\pSections "sec-intro.tex"}

\section{Introduction}  % == Main Section: Introduction ==
%%% Main introduction section to set up the context of the project.

%%% Subsection A: Overview of the Problem
% -----------------------------------------------------------
\subsection{Overview of the Problem}
This subsection provides a detailed description of the problem or challenge being addressed in this project.

%%% Subsection B: Objectives
% -----------------------------------------------------------
\subsection{Objectives}
This subsection outlines the main objectives of the project, including key research goals or development targets.

%%% Subsection C: Methodology
% -----------------------------------------------------------
\subsection{Methodology}
This subsection describes the methodology or approach taken to address the problem and achieve the objectives.

\endinput  % == End of Introduction Section ==
EOF

cat << 'EOF' > "$PROJECT_DIR/sections/sec-backup.tex"
% ===========================================================
% Introduction Section for $PROJECT_NAME
% This file contains the main introduction and its subsections.
% ===========================================================

% \input{\pSections "sec-backup.tex"}

\section{Introduction}  % == Main Section: Introduction ==
%%% Main introduction section to set up the context of the project.

%%% Subsection A: 
% -----------------------------------------------------------
\subsection{A}
First subsection.

%%% Subsection B:
% -----------------------------------------------------------
\subsection{B}
Second subsection.

%%% Subsection C
% -----------------------------------------------------------
\subsection{C}
Third subsection.

\endinput  % == End of Introduction Section ==
EOF

# Seed local setup file
cat << 'EOF' > "$PROJECT_DIR/local/setup-local.tex"
% Local LaTeX setup for $PROJECT_NAME

\usepackage{graphicx}
% Add any project-specific setup here
EOF

echo "Project $PROJECT_NAME created successfully!"
echo "time used = ${SECONDS} s"

