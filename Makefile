# The main (final) document name
main_pdf = final.pdf

# The directory of your bib files
bib_dir = bib

LATEXMK := latexmk -lualatex -bibtex -synctex=1

# Split a pdf
# gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dFirstPage=1 -dLastPage=15 -sOUTPUTFILE=desc_no_refs.pdf desc.pdf

# The list of pdfs that we need to generate separately in the order of
# appearance in the main pdf
desc = desc
pdfs = $(desc).pdf akh-budget.pdf akh-facilities.pdf data.pdf personnel.pdf summary.pdf mentoring.pdf akh-synergistic.pdf
pdfsb = akh-budget.pdf akh-facilities.pdf data.pdf personnel.pdf summary.pdf mentoring.pdf akh-synergistic.pdf

# look for files
find = $(foreach dir,$(1),$(wildcard $(dir)/*.$(2)))
common_tex_files = header.tex
tex_files := $(shell find . -name "*.tex")

junk +=	*.aux *.log *.lof *.lot *.toc *.blg *.bbl *~ *.synctex.gz *.fdb_latexmk *.fls

$(main_pdf): $(pdfsb) desc.pdf
	pdfjam $(pdfs) --outfile $(main_pdf)

all: all references.pdf desc_no_refs.pdf $(pdfs)

desc_no_refs.pdf: desc.pdf
	gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dFirstPage=1 -dLastPage=15 -sOUTPUTFILE=$(desc)_no_refs.pdf $(desc).pdf

references.pdf: desc.pdf
	gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dFirstPage=16 -sOUTPUTFILE=references.pdf $(desc).pdf

$(pdfsb): %.pdf: %.tex $(bib_dir)/*.bib $(common_tex_files)
	$(LATEXMK) $<

desc.pdf: desc.tex $(tex_files) $(common_tex_files)
	$(LATEXMK) $<
clean:
	@find . \( -name '*.aux'\
		-o -name '*~'\
		-o -name '*.synctex.gz'\
		-o -name '*.blg'\
		-o -name '*.toc'\
		-o -name '*.lot'\
		-o -name '*.fls'\
		-o -name '*.fdb_latexmk'\
		-o -name '*.xcp'\
		-o -name '*.xoj'\
		-o -name '*.lof'\
		-o -name '*.log'\
		-o -name '*.out'\
		\) -type f -not -path "./.git/*" -not -path "./src/*"\
		-exec sh -c 'echo "REMOVING {}"; rm {}' ';'

cleanall:
	@find . \( -name '*.aux'\
	 	-o -name '*~'\
		-o -name '*.synctex.gz'\
		-o -name '*.blg'\
		-o -name '*.bbl'\
		-o -name '*.toc'\
		-o -name '*.lot'\
		-o -name '*.fls'\
		-o -name '*.fdb_latexmk'\
		-o -name '*.xcp'\
		-o -name '*.xoj'\
		-o -name '*.lof'\
		-o -name '*.log'\
		-o -name '*.out'\
		-o -name '*.pdf'\
		-o -name '*.dvi'\
		\) -type f -not -path "./.git/*" -not -path "./src/*" -not -name 'akhirsch_biosketch.pdf' -not -name 'akh-cv.pdf' -not -name 'akh-cpos.pdf'\
		-exec sh -c 'echo "REMOVING {}"; rm {}' ';';
	@find . \( -name 'auto'\
		-o -name '_minted*'\
	        \) -type d -not -path "./.git/*" -not -path "./src/*" -prune\
		-exec sh -c 'echo "REMOVING {}"; rm -r {}' ';'

