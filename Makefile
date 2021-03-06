DRAFT_NAME:=draft-pot-json-link

.PHONY:all
all: $(DRAFT_NAME).xml $(DRAFT_NAME).txt

.PHONY:clean
clean:
	rm $(DRAFT_NAME).xml $(DRAFT_NAME).txt

$(DRAFT_NAME).xml: $(DRAFT_NAME).md
	kramdown-rfc2629 $(DRAFT_NAME).md > $(DRAFT_NAME).xml

$(DRAFT_NAME).txt: $(DRAFT_NAME).xml
	xml2rfc ${DRAFT_NAME}.xml

.PHONY:deps
deps:
	sudo apt install xml2rfc
	gem install kramdown-rfc2629
