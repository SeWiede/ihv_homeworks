all: $(wildcard *.tex)
	for i in $^; do TEXINPUTS=../../lectures/template:./:$$TEXINPUTS pdflatex $$i; done
