presentation.pdf: presentation.md.lhs
	pandoc -f markdown+lhs -t beamer -s presentation.md.lhs -i -o presentation.pdf
