## Makefile for those who prefer to knit from command line
## not needed if you knit from RStudio.
## 
SOURCES = $(wildcard *.rmd)
HTML = $(patsubst %.rmd, %.html, $(SOURCES))
PDF = $(patsubst %.rmd, %.pdf, $(SOURCES))
# tex versions of the files, just to clean up

%.md: %.rmd civic-info.R propublica.R
	Rscript -e "knitr::knit('$<', quiet=FALSE)"

%.html: %.md
	Rscript -e "rmarkdown::render('$<', output_format='html_document')"

%.pdf: %.md
	Rscript -e "rmarkdown::render('$<', output_format='pdf_document')"

all: $(HTML)

pdf: $(PDF)

clean:
	rm -vf $(TEX) *.rmd~
# -v : verbose
# -f: ignore non-existent files
