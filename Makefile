#!/usr/bin/make -f
##
# Basic wrapper to convert .tex files to .pdf using pdflatex
#
# Usage:
# - Create PDF from FILE.tex:
#   make FILE.pdf
# - Create and Compress PDF from FILE.tex:
#   make FILE_compressed.pdf
# - Create Resume.pdf from Resume.tex:
#   make Resume.pdf
#
# Depends: texlive-latex-base texlive-latex-recommended texlive-latex-extra texlive-fonts-extra
##

# Build "all" PDF documents
all: assets/Resume.pdf assets/CV.pdf

# Compress a PDF file after build is complete
%_compressed.pdf: %.pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 \
		-dPDFSETTINGS=/screen \
		-dNOPAUSE -dQUIET -dBATCH \
		-sOutputFile=$*_compressed.pdf $*.pdf

# Build a PDF document
%.pdf: mteck.sty %.tex
	$(RM) $*.pdf
	pdflatex -halt-on-error -file-line-error $*.tex
	# Requires second run for proper linking
	pdflatex -halt-on-error -file-line-error $*.tex
	sync; $(RM) $*.log $*.out $*.aux

# Remove non-source files
clean:
	$(RM) *.pdf
	$(RM) *.log *.out *.aux

.PHONY: all clean
