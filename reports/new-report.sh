#!/usr/bin/env bash
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

# Achates' Perspective:
# I believe in automating tedious tasks to maximize productivity. 
# By setting up the foundation programmatically, your time is freed 
# for more creative and technical pursuits.

# ./new-project.sh hpc-pdes

start_time=$SECONDS  # Record the start time

# Ensure the script is called with a PROJECT_NAME argument
if [ $# -eq 0 ]; then
    echo "Error: No PROJECT_NAME supplied."
    echo "Usage: $0 <PROJECT_NAME>"
    exit 1
fi

# Counts steps in batch process
export counter=0
function new_step() {
    counter=$((counter+1))
    echo ""
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Step ${counter}: ${1}"
}
# || { echo "Error: Step ${counter} failed. Exiting."; exit 1; }

# Validate project name input
PROJECT_NAME=$1
BASE_DIR=~/GitHub/sharing/reports

if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: $0 <project_name>"
  exit 1
fi

new_step "Define project directory"
PROJECT_DIR="$BASE_DIR/$PROJECT_NAME"
mkdir -p "$PROJECT_DIR"

new_step "Define subdirectories"
# Define the array of subdirectories relative to the project directory
SUBDIRS=(
  "config"
  "main"
  "sections"
  "local/code"
  "local/achates"
  "local/data"
  "local/debug"
  "local/graphics"
  "local/refs"
  "local/components/figures"
  "local/components/tables"
  "local/components/theorems"
)

new_step "Create subdirectories"
# Create each subdirectory under the project directory
for SUBDIR in "${SUBDIRS[@]}"; do
  mkdir -p "$PROJECT_DIR/$SUBDIR"
  echo "Created: $PROJECT_DIR/$SUBDIR"
done

new_step "Seed main-$PROJECT_NAME.tex"
echo "Seeding initial files..."
# Create main LaTeX file
cat << EOF > "$PROJECT_DIR/main/main-$PROJECT_NAME.tex"
% typeset: Pdftex
% Afterwards compile with pdflatex > bibtex > pdflatex > pdflatex.
% CLI: pdflatex main-$PROJECT_NAME.tex
% Beamer likes biber
\documentclass[10pt, oneside]{article}

% Fetch home directory: make this file independent of file system
\usepackage{catchfile}
\CatchFileDef{\HomePath}{|kpsewhich -var-value=HOME}{}
% Define base paths
% relies on symlink  at $HOME, e.g.
% 	GitHub -> /Users/dantopa//repos-xiuhcoatl/github
\makeatletter
\edef\HomePath{\expandafter\zap@space\HomePath \@empty}
\makeatother
\newcommand{\pGithub}          		 {\HomePath/GitHub/}
	\newcommand{\pGithubSharing}	{\pGithub/sharing/}
	\newcommand{\pGlobal}			{\pGithubSharing/global/}
	\newcommand{\pGlobalSetup}		{\pGlobal/setup-global/}
	\newcommand{\pWorkspace}		{\pGithubSharing/reports/${PROJECT_NAME}}

% Load Global Setup Files
\input{\pGlobalSetup/setup-global-reports.tex}
% Excursion Setup Files
\input{\pLocalSetup/setup-local.tex}

% ===========================================================
% Global and Local Resource Setup
% The following lines load various global and local resource
% configurations, paths, and package lists required for the 
% document. These files are part of the shared library located
% in "~/GitHub/sharing/global/setup-global".
% ===========================================================

% setup-global-reports.tex
% 	paths-global.tex
% 	paths-local.tex
% 	usepackages-reports.tex
% 	hyperlinks-global.tex
%		libraries-global.tex

% Choose hyperlink configuration:
\input{\pGlobalSetup href-hidden.tex}   % For hidden links (clean, professional)
% \input{\pGlobalSetup href-visible.tex} % For visible links (debugging, drafts)

%\usepackage[printwatermark]{xwatermark}
%	\newwatermark[allpages,color=red!5,angle=45,scale=3,xpos=0,ypos=0]{DRAFT}

%   --   --   --   --   --   --   --   --   --   -- Bibliography
\input{\pGlobalSetup bib-config-a.tex}
\addbibresource{\pShareBibliographies/$PROJECT_NAME.bib}
%\addbibresource{\pShareBibliographies/alternative.bib}

%   --   --   --   --   --   --   --   --   --   -- Title, Author
\title{$PROJECT_NAME}
\author{Daniel Topa\\\TopaHIIEmail}
\affil{\missiontech}

%   --   --   --   --   --   --   --   --   --   -- Structure
\begin{document}
\maketitle
	%\input{\pSections sec-abstract.tex}
\tableofcontents

	\input{\pSections sec-intro.tex}
	\input{\pSections sec-backup.tex}

\appendix

% Appendices content
% \input{\pSections app-appendix.tex}

\nocite{*}
\printbibliography

\end{document}

%\tiny
%\scriptsize
%\footnotesize
%\small
%\normalsize
%\large
%\Large
%\LARGE
%\huge
%\Huge

%\, thin space (normally 1/6 of a quad);
%\> medium space (normally 2/9 of a quad);
%\; thick space (normally 5/18 of a quad);

%         ---         ---         ---         ---         ---   Equations
\begin{equation}
  
\label{eq:}
\end{equation}
%
\begin{equation}
\begin{split}
  & \\
\end{split} 
\label{eq:}
\end{equation}
%
\begin{equation*}
  
\end{equation*}
%
\begin{equation}
\begin{array}{ccc}
    %
  & & \\
    %
  & & \\
    %
\end{array}
\end{equation}
%         ---         ---         ---         ---         ---   Tables
\begin{table}[htp]
\caption{default}
\begin{center}
\begin{tabular}{ccc}
    %
  & & \\
    %
  & & \\
    %
\end{tabular}
\end{center}
\label{tab:}
\end{table}
%         ---         ---         ---         ---         ---   Lists
\begin{enumerate}
  \item 
  \item
  \item
\end{enumerate}
%
\begin{enumerate}
  \item 
  \begin{enumerate}
    \item 
  \end{enumerate}
  \item
  \item
\end{enumerate}
EOF

new_step "Creating abstract file"
cat << 'EOF' > "$PROJECT_DIR/sections/sec-abstract.tex"
% \input{\pSections "sec-abstract.tex"}

\begin{abstract}
% This document presents an analysis of ... [Insert concise abstract content here].
% The purpose of this work was to ... [Purpose].
% The methodology involved ... [Methods].
% Key results include ... [Results].
% This research highlights ... [Conclusions and significance].
\end{abstract}

\endinput  % == End of Abstract Section ==
EOF

new_step "Seed $PROJECT_DIR/sections/sec-intro.tex"
cat << 'EOF' > "$PROJECT_DIR/sections/sec-intro.tex"
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

new_step "Seed $PROJECT_DIR/sections/sec-backup.tex"
cat << 'EOF' > "$PROJECT_DIR/sections/sec-backup.tex"
% \input{\pSections "sec-backup.tex"}

\section{Backup} 
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
	
\endinput  %  ==  ==  ==  ==  ==  ==  ==  ==  ==
EOF

new_step "Seed $PROJECT_DIR/local/setup-local/setup-local.tex"
cat << 'EOF' > "$PROJECT_DIR/local/setup-local/setup-local.tex"
% \input{\pLocalSetup "setup-local.tex"}

% ===========================================================
% Customize workspace environment beyond generic
% ===========================================================

% \input{\pLocalSetup macros}
% \input{\pLocalSetup paths-local.tex

\endinput  %  ==  ==  ==  ==  ==  ==  ==  ==  ==
EOF


new_step "Seed $PROJECT_DIR/config/etup-local.tex"
cat << 'EOF' > "$PROJECT_DIR/config/setup-local.tex"
% \input{\pLocalSetup "setup-local.tex"}

% ===========================================================
% Customize workspace environment beyond generic
% ===========================================================

% \input{\pLocalConfig macros}
% \input{\pLocalConfig paths-local.tex

\endinput  %  ==  ==  ==  ==  ==  ==  ==  ==  ==

# Set permissions on the generated file
new_step "chmod 644 $MAIN_TEX_FILE"
chmod 644 "$MAIN_TEX_FILE"


echo "Project $PROJECT_NAME created successfully!"
elapsed=$((SECONDS - start_time))  # Calculate the elapsed time
echo "time used = ${elapsed} sec"

