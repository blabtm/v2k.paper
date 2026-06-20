thesis.pdf: extra/thesis-task.pdf extra/thesis-title.pdf main.pdf ap.pdf
	pdfunite extra/thesis-task.pdf extra/thesis-title.pdf main.pdf thesis.pdf

main.pdf:
	typst compile main.typ
