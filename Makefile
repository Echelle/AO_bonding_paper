all: AO_bondedSi.pdf

%.pdf: %.tex
	pdflatex $<
	bash -c " ( grep Rerun $*.log && pdflatex $< ) || echo noRerun "
	bash -c " ( grep Rerun $*.log && pdflatex $< ) || echo noRerun "
	pdflatex $<
	bibtex AO_bondedSi
	pdflatex AO_bondedSi
	pdflatex AO_bondedSi
	rm -rf *Notes.bib
	rm -rf *.bbl
	rm -rf *.aux
	rm -rf *.log
	rm -rf *.blg
	rm -rf *.dvi
