#!/usr/bin/env bash
printf "%s\n" "$(tput bold)$(date) ${BASH_SOURCE[0]}$(tput sgr0)"

# ===========================================================
# Script: new-beamer.sh
# Author: ChatGPT (Achates), with guidance from Daniel Topa
# Sun Dec 22 14:00:00 MST 2024
#
# Task:
# Automates the creation of LaTeX-based Beamer presentation directories.
# This script ensures that every new Beamer project has a consistent structure,
# seeded with essential files (e.g., main Beamer file, section templates, setup).
#
# Advantages:
# - Ensures uniformity across Beamer projects.
# - Saves time and reduces setup errors.
# - Provides a ready-to-compile Beamer presentation.
# ===========================================================

start_time=$SECONDS  # Record the start time

# Counts steps in batch process
export counter=0
function new_step() {
    counter=$((counter+1))
    echo ""
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Step ${counter}: ${1}"
}

# Validate project name input
PROJECT_NAME=$1
BASE_DIR=~/GitHub/sharing/beamer

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
  "local"
  "local/code"
  "local/achates"
  "local/data"
  "local/debug"
  "local/demos"
  "local/refs"
  "local/figures-local"
  "local/graphics-local"
  "local/setup-local"
  "local/tables-local"
  "local/theorems-local"
  "main"
  "sections"
)

new_step "Create subdirectories"
# Create each subdirectory under the project directory
for SUBDIR in "${SUBDIRS[@]}"; do
  mkdir -p "$PROJECT_DIR/$SUBDIR"
  echo "Created: $PROJECT_DIR/$SUBDIR"
done

new_step "Seed main Beamer file"
# Create the main Beamer file
cat << EOF > "$PROJECT_DIR/main/main-${PROJECT_NAME}.tex"
% typeset: Pdftex
% Afterwards compile with pdflatex > bibtex > pdflatex > pdflatex
% TeXShop Settings... > Engine > BibTex Engine > biber
% beamer likes biber
% latex likes bibtex

% https://tex.stackexchange.com/questions/270633/beamer-and-the-pause-command
% https://tex.stackexchange.com/questions/1423/is-there-a-nice-way-to-compile-a-beamer-presentation-without-the-pauses
% Beamer presentation template for $PROJECT_NAME
% \documentclass[ handout ]{beamer} % for printing
\documentclass[ ]{beamer}

% Fetch home directory: make this file independent of file system
\usepackage{catchfile}
\CatchFileDef{\HomePath}{|kpsewhich -var-value=HOME}{}
% Define base paths
% relies on symlink  at /Users/dantopa/, e.g.
% 	GitHub -> /Users/dantopa//repos-xiuhcoatl/github
\makeatletter
\edef\HomePath{\expandafter\zap@space\HomePath \@empty}
\makeatother
\newcommand{\pGithub}          			{\HomePath/GitHub/}
	\newcommand{\pGithubSharing}	{\pGithub/sharing/}
	\newcommand{\pGlobal}			{\pGithubSharing/global/}
	\newcommand{\pGlobalSetup}		{\pGlobal/setup-global/}
	\newcommand{\pWorkspace}		{\pGithubSharing/beamer/${PROJECT_NAME}}

% ===========================================================
% Global and Local Resource Setup
% The following lines load various global and local resource
% configurations, paths, and package lists required for the 
% document. These files are part of the shared library located
% in "~/GitHub/sharing/global/setup-global".
% ===========================================================

% Load Global Setup Files
\input{\pGlobalSetup/setup-global-beamer.tex}
% Excursion Setup Files
\input{\pLocalSetup/setup-local.tex}

% setup-global-beamer.tex
%	aesthetics.tex
%	paths-global.tex
%	packages-global-beamer.tex
%	math-global-beamer.tex
%	hyperlinks-global.tex
%	paths-bitbucket.tex
%	libraries-global.tex
%	macros-global.tex

% Choose hyperlink configuration:
\input{\pGlobalSetup href-hidden.tex}   % For hidden links (clean, professional)
% \input{\pGlobalSetup href-visible.tex} % For visible links (debugging, drafts)

%\usepackage[printwatermark]{xwatermark}
%	\newwatermark[allpages,color=red!5,angle=45,scale=3,xpos=0,ypos=0]{DRAFT}

% Debugging with visible slide boundaries
% \setbeamertemplate{background canvas}[grid][ step = 1cm ]

%   --   --   --   --   --   --   --   --   --   -- Bibliography
\input{\pGlobalSetup bib-config-a.tex}
\addbibresource{\pShareBibliographies/$PROJECT_NAME.bib}
%\addbibresource{\pShareBibliographies/additional.bib}

%   --   --   --   --   --   --   --   --   --   -- Title, Author
\title[$PROJECT_NAME]{Beamer Presentation for $PROJECT_NAME}
\author[Daniel Topa]{\TopaHII \\\ \TopaHIIEmail}
\institute{\missiontech} 
\date{\today}

%   --   --   --   --   --   --   --   --   --   -- Structure
\begin{document}

\begin{frame}
    \titlepage
\end{frame}

\begin{frame}[ allowframebreaks ]\frametitle{Outline}
	\tableofcontents[ hideallsubsections ]
\end{frame}


% Main content
	\input{\pSections/sec-intro.tex}
	\input{\pSections/sec-backup.tex}

% Bibliography
\begin{frame}[allowframebreaks]
    \frametitle{Bibliography}
    \printbibliography
\end{frame}

\begin{frame}
    \titlepage
\end{frame}

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

\begin{frame}\frametitle{Frame Title}
\begin{enumerate}
	\item 
	\item 
	\item 
\end{enumerate}
\end{frame}

\begin{frame}\frametitle{Frame Title}
\begin{equation}
	\begin{array}{ccc} 
			%
			%
			%
	\end{array}
%\label{eq:}
\end{equation}
\end{frame}

\begin{frame}\frametitle{ }
\center
	\href{url}{
	\begin{overpic}[ scale = 1.0 ]
	{\pLocalGraphics graphic-file}
		%\put(-7,-10){Auxiliary text.}
	\end{overpic}}
\end{frame}

\begin{frame}\frametitle{Frame Title}
\begin{table}[htp]
%\caption{default}
\begin{center}
	\begin{tabular}{cc}
		%
		%
		%
	\end{tabular}
\end{center}
%\label{tab:label}
\end{table}
\end{frame}
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
\endinput  %  ==  ==  ==  ==  ==  ==  ==  ==  ==
EOF

new_step "Seed introduction section files"
cat << 'EOF' > "$PROJECT_DIR/sections/sec-intro.tex"
% \input{\pSections/"sec-intro.tex"}

\section{Introduction}
\begin{frame}\frametitle{Introduction}
    This is the introduction frame.
\end{frame}

%%% Subsection A: 
% -----------------------------------------------------------
\subsection{A}

%%% Subsection B: 
% -----------------------------------------------------------
\subsection{B}
%
\endinput  %  ==  ==  ==  ==  ==  ==  ==  ==  ==
EOF

new_step "Seed backup section"
cat << 'EOF' > "$PROJECT_DIR/sections/sec-backup.tex"
% \input{\pSections/"sec-backup.tex"}

\section{Backup Slides}
\begin{frame}\frametitle{Backup Slides}
    Extensions
\end{frame}

%%% Subsection A: 
% -----------------------------------------------------------
\subsection{A}

%%% Subsection B: 
% -----------------------------------------------------------
\subsection{B}
%
\endinput  %  ==  ==  ==  ==  ==  ==  ==  ==  ==
EOF

new_step "Seed $PROJECT_DIR/local/setup-local/setup-local.tex"
cat << 'EOF' > "$PROJECT_DIR/local/setup-local/setup-local.tex"
% \input{\pLocalSetup "setup-local.tex"}

% ===========================================================
% Customize workspace environment beyond generic
% ===========================================================

% \input{\pLocalSetup macros}

%
\endinput  %  ==  ==  ==  ==  ==  ==  ==  ==  ==
EOF


echo "Beamer project $PROJECT_NAME created successfully!"
elapsed=$((SECONDS - start_time))  # Calculate the elapsed time
echo "Time used = ${elapsed} sec"
