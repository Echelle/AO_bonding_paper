all: AO_bondedSi.pdf

%.pdf: %.tex
	pdflatex $<
	bash -c " ( grep Rerun $*.log && pdflatex $< ) || echo noRerun "
	bash -c " ( grep Rerun $*.log && pdflatex $< ) || echo noRerun "
	pdflatex $<
	bibtex AO_bondedSi
	pdflatex AO_bondedSi
	pdflatex AO_bondedSi
	mv AO_bondedSi.pdf final/
	mv AO_bondedSi.tex final/
	rm -rf *Notes.bib
	rm -rf *.bbl
	rm -rf *.log
	rm -rf *.blg
	rm -rf *.dvi
	latexdiff old/AO_bondedSi_20140421.tex final/AO_bondedSi.tex > AO_bondedSi.tex
	pdflatex AO_bondedSi
	pdflatex AO_bondedSi
	bibtex AO_bondedSi
	pdflatex AO_bondedSi
	pdflatex AO_bondedSi
	rm -rf *Notes.bib
	rm -rf *.bbl
	rm -rf *.aux
	rm -rf *.log
	rm -rf *.blg
	rm -rf *.dvi
	mv AO_bondedSi.pdf diff.pdf
	cp final/AO_bondedSi.tex .
	mv diff.pdf final/diff.pdf
