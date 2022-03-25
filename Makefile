.PHONY: mypy flake8 jsonschema codegen docgen-man docgen-texi check install

all:

mypy:
	MYPYPATH=. mypy cli-codegen.py cli-docgen.py

flake8:
	flake8 cli-*.py cligen/*.py cligen/doc/*.py

jsonschema:
	@for json in fixtures/input/*-options.json; do \
		echo "Validating $$json"; \
		jsonschema \
		--error-format "ERROR: {error.path} {error.message}" \
		--instance $$json \
		cligen.schema.json; \
	done

codegen:
	@PYTHONPATH=.; \
	for json in fixtures/input/*-options.json; do \
		tool=`expr $$json : '.*/\(.*\)-options.json'`; \
		echo "Generating code for $$tool"; \
		./cli-codegen.py \
		--package GnuTLS --version 3.7.4 \
		$$json \
		fixtures/output/$$tool-args.c fixtures/output/$$tool-args.h; \
	done

docgen-man:
	@PYTHONPATH=.; \
	for json in fixtures/input/*-options.json; do \
		tool=`expr $$json : '.*/\(.*\)-options.json'`; \
		includes=''; \
		for section in description files examples see-also; do \
			test -e fixtures/input/$$tool-$$section.texi && \
			includes="$$includes --include $$section=fixtures/input/$$tool-$$section.texi"; \
		done; \
		echo "Generating man documentation for $$tool"; \
		./cli-docgen.py --format man \
		--package GnuTLS --version 3.7.4 $$includes \
		$$json fixtures/output/$$tool.1; \
	done

docgen-texi:
	@PYTHONPATH=.; \
	for json in fixtures/input/*-options.json; do \
		tool=`expr $$json : '.*/\(.*\)-options.json'`; \
		echo "Generating texi documentation for $$tool"; \
		includes=''; \
		for section in description files examples see-also; do \
			test -e fixtures/input/$$tool-$$section.texi && \
			includes="$$includes --include $$section=fixtures/input/$$tool-$$section.texi"; \
		done; \
		./cli-docgen.py --format texi \
		--package GnuTLS --version 3.7.4 $$includes \
		$$json fixtures/output/$$tool.texi; \
	done

check: mypy flake8 jsonschema codegen docgen-man docgen-texi

INSTALL ?= install

install:
	$(INSTALL) -D -t ${DESTDIR} cli-codegen.py
	$(INSTALL) -D -t ${DESTDIR} cli-docgen.py
	$(INSTALL) -d ${DESTDIR}/cligen
	$(INSTALL) -D -t ${DESTDIR}/cligen cligen/*.py
	$(INSTALL) -d ${DESTDIR}/cligen/doc
	$(INSTALL) -D -t ${DESTDIR}/cligen/doc cligen/doc/*.py
