filename=rivasmcpr

pdf: ps
		xelatex ${filename}
		rm -f ${filename}.{log,aux,out,bbl,blg}

ps:	dvi
		dvips -t a4 ${filename}.dvi

dvi:
		latex ${filename}.tex
			bibtex ${filename}||true
				latex ${filename}.tex
					latex ${filename}.tex
