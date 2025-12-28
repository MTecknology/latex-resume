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
	$(RM) $@
	pdflatex -halt-on-error -file-line-error -output-directory=$(dir $@) $*.tex
	# Second run for linking
	pdflatex -halt-on-error -file-line-error -output-directory=$(dir $@) $*.tex
	sync; $(RM) $(dir $@)*.log $(dir $@)*.out $(dir $@)*.aux

# Create a release tarball
release-%.tgz: all
	$(RM) -r release
	mkdir -p release/examples
	cp Makefile assets/*.pdf assets/*.tex release/examples
	sed 's/: UNRELEASED/: $*/' mteck.sty >release/mteck.sty
	cd release; tar -czf ../release-$*.tgz *

# Remove non-source files
clean:
	$(RM) *.pdf */*.pdf
	$(RM) *.log *.out *.aux release-*.tgz

.PHONY: all clean
