#!/bin/bash
# Clean auxiliary files
rm *.aux *.log *.toc *.out *.bbl *.blg

# Compile LaTeX
pdflatex fortran-notes-achates.tex
biber fortran-notes-achates
pdflatex fortran-notes-achates.tex
pdflatex fortran-notes-achates.tex

# Open the PDF (adjust for macOS/Linux/Windows)
open fortran-notes-achates.pdf

# chmod +x build.sh
# ./build.sh