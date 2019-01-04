BUILD = build
DOCS = docs
OUTPUT_FILENAME = book
DOCS_FILENAME = index
METADATA = metadata.yml
CHAPTERS = chapters/**/*.md
TOC = --toc --toc-depth=2
IMAGES_FOLDER = images
COVER_IMAGE = images/cover.png
LATEX_CLASS = report
MATH_FORMULAS = --webtex
CSS_FILE = style.css
CSS_ARG = --css=$(CSS_FILE)
ARGS = $(TOC) $(MATH_FORMULAS) $(CSS_ARG)

all: book

book: epub html pdf docs

clean:
	rm -r $(BUILD)
	rm -r $(DOCS)

epub: $(BUILD)/epub/$(OUTPUT_FILENAME).epub

html: $(BUILD)/html/$(OUTPUT_FILENAME).html

pdf: $(BUILD)/pdf/$(OUTPUT_FILENAME).pdf

docs: $(DOCS)/$(DOCS_FILENAME).html

$(BUILD)/epub/$(OUTPUT_FILENAME).epub: $(METADATA) $(CHAPTERS)
	mkdir -p $(BUILD)/epub
	pandoc $(ARGS) --epub-metadata=$(METADATA) --epub-cover-image=$(COVER_IMAGE) -o $@ $^

$(BUILD)/html/$(OUTPUT_FILENAME).html: $(CHAPTERS)
	mkdir -p $(BUILD)/html
	pandoc $(ARGS) --standalone --to=html5 -o $@ $^
	cp -R $(IMAGES_FOLDER)/ $(BUILD)/html/$(IMAGES_FOLDER)/
	cp $(CSS_FILE) $(BUILD)/html/$(CSS_FILE)

$(BUILD)/pdf/$(OUTPUT_FILENAME).pdf: $(METADATA) $(CHAPTERS)
	mkdir -p $(BUILD)/pdf
	pandoc $(ARGS) -V documentclass=$(LATEX_CLASS) -o $@ $^


$(DOCS)/$(DOCS_FILENAME).html: $(CHAPTERS)
	mkdir -p $(DOCS)
	pandoc $(ARGS) --standalone --to=html5 -o $@ $^
	cp -R $(IMAGES_FOLDER)/ $(DOCS)/$(IMAGES_FOLDER)/
	cp $(CSS_FILE) $(DOCS)/$(CSS_FILE)
