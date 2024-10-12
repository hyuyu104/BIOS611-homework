.PHONY report
.PHONY clean

report: report.Rmd
	R -e "rmarkdown::render(inut='report.Rmd', \
	output_file='report.pdf', output_format='pdf_document')"

clean: 
	rm output/*