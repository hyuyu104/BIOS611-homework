build: dog_count_all.pdf dog_count_nontrivial.pdf \
	max_name.pdf

clean:
	rm *.pdf
	rm distinct_data.csv
	rm unique.csv

distinct_data.csv: preprocess.r
	Rscript preprocess.r

unique.csv: distinct_data.csv unique.r
	Rscript unique.r

dog_count_all.pdf dog_count_nontrivial.pdf: distinct_data.csv plot1.r
	Rscript plot1.r

max_name.pdf: unique.csv plot2.r
	Rscript plot2.r