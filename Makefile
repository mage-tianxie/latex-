MAIN = example
NAME = cjc
CLSFILES = $(NAME).cls
BSTFILES = $(NAME).bst

LATEXMK = latexmk -xelatex

.PHONY : main cls doc test save clean all install distclean zip FORCE_MAKE

main : $(MAIN).pdf

all : main doc

cls : $(CLSFILES) $(BSTFILES)

doc : $(NAME).pdf

$(MAIN).pdf : $(MAIN).tex $(CLSFILES) $(BSTFILES) FORCE_MAKE
	$(LATEXMK) $<

clean :
	$(LATEXMK) -c $(MAIN).tex

cleanall :
	$(LATEXMK) -C $(MAIN).tex
