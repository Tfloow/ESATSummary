# go over each folder and compile the markdown into pdf with pandoc

compile : all_NEW

# Exclude PDF directory from subdirectories
SUBDIRS := $(patsubst %/,%,$(wildcard */))
SUBDIRS := $(filter-out PDF,$(SUBDIRS))
LAST_COMMIT_MESSAGE = $(git log -1 --pretty=%B)
pandoc_run = $(docker run --rm --volume "$(pwd):/data" pandoc/extra)
PWD = $(shell pwd)

SOURCES = $(wildcard */*/summary.md)

# Define the pandoc command template for reusability
# Note: We use $$@ inside this variable to escape the $ for when 'make' expands it later in the rule.
PANDOC_CMD = docker run --rm --volume "$(PWD)/$@:/data" pandoc/extra \
	summary.md LICENSE.md \
	-o $@.pdf \
	--template eisvogel \
	--syntax-highlighting=idiomatic \
	--number-sections


YELLOW   = \033[1;33m
BLUE     = \033[0;34m
GREEN    = \033[0;32m
NC       = \033[0m 

% : %/summary.md %/LICENSE.md
	@printf "$(YELLOW)--> Compiling course: $(BLUE)%s$(NC)\n" "$@"
	@cd $@; $(PANDOC_CMD)
	@cp $@/$@.pdf PDF/
	@rm -f $@/$@.pdf
	@chmod 664 PDF/$@.pdf
	@printf "$(GREEN) ✔ Successfully created $(BLUE)%s.pdf$(NC)\n\n" "$@"

%.pdf: %

all_NEW : $(SUBDIRS)
	@printf "$(GREEN) ✔ All Summaries Compiled Successfully!$(NC)\n"


create_summary :
# takes course name and author name as arguments
	@echo "Creating summary files..."
	@if [ -z "$(TITLE)" ] || [ -z "$(AUTHOR)" ] || [ -z "$(DIR)" ] || [ -z "$(SEMESTER)" ]; then \
		echo "Error: Please provide TITLE, AUTHOR, DIR, and SEMESTER variables."; \
		echo "Usage: make create_summary TITLE='Course Title' AUTHOR='Author Name' DIR='course_dir' SEMESTER='M2Q1'"; \
		exit 1; \
	fi
	@echo "Creating directory $(SEMESTER)_$(DIR)..."
	mkdir $(SEMESTER)_$(DIR)
	cp template/* $(SEMESTER)_$(DIR)
	sed -i "s/TITLE NAME/$(TITLE)/g" $(SEMESTER)_$(DIR)/summary.md
	sed -i "s/AUTHOR/$(AUTHOR)/g" $(SEMESTER)_$(DIR)/summary.md

clean :
	rm  -rf PDF/
	rm  -f *.pdf
	mkdir PDF

.PHONY: rebuild
rebuild: clean compile