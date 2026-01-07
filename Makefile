# go over each folder and compile the markdown into pdf with pandoc

compile : all_NEW 

PANDOC_IMAGE = pandoc/extra@sha256:7e9724ee58edfa9b01af8ff4e99738f5f19a1d421e21247a23439898506d86d5
# IDK why github actions crash here
EXCLUDED_DIRS = PDF

# Exclude PDF directory from subdirectories
SUBDIRS := $(patsubst %/,%,$(wildcard */))
SUBDIRS := $(filter-out $(EXCLUDED_DIRS),$(SUBDIRS))
LAST_COMMIT_MESSAGE = $(git log -1 --pretty=%B)
# Remove possible ENV injection GITHUB_TOKEN from commit message
LAST_COMMIT_MESSAGE := $(filter-out %GITHUB_TOKEN%, $(LAST_COMMIT_MESSAGE))
pandoc_run = $(docker run --rm --volume "$(pwd):/data" $(PANDOC_IMAGE))
PWD = $(shell pwd)

SOURCES = $(wildcard */summary.md)

# Define the pandoc command template for reusability
# Note: We use $$@ inside this variable to escape the $ for when 'make' expands it later in the rule.
PANDOC_CMD = docker run --rm --volume "$(PWD)/$@:/data" $(PANDOC_IMAGE) \
	summary.md LICENSE.md \
	-o $@.pdf \
	--template eisvogel \
	--syntax-highlighting=idiomatic \
	--number-sections

# Take name and keep everyting before first underscore as year folder
FOLDER_YEAR = $(firstword $(subst _, ,$@))


YELLOW   = \033[1;33m
BLUE     = \033[0;34m
GREEN    = \033[0;32m
NC       = \033[0m 

% : %/summary.md %/LICENSE.md
	@printf "$(YELLOW)--> Compiling course: $(BLUE)%s$(NC)\n" "$@"
	@cd $@; $(PANDOC_CMD)
	@mkdir -p PDF 
	@mkdir -p PDF/$(FOLDER_YEAR)
	@cp $@/$@.pdf PDF/$(FOLDER_YEAR)/$@.pdf
	@cp $@/$@.pdf PDF/
	@rm -f $@/$@.pdf
	@chmod 664 PDF/$@.pdf
	@printf "$(GREEN)✔ Successfully created $(BLUE)%s.pdf$(NC)\n" "$@"

%.pdf: %

all_NEW : $(SUBDIRS)
	@printf "$(BLUE)INFO:$(NC)Excluded: $(EXCLUDED_DIRS)\n"
	@printf "$(GREEN)✔ All Summaries Compiled Successfully!$(NC)\n"

zip:
# zip PDF
	@printf "$(YELLOW)--> Zipping all PDFs into PDF.zip$(NC)\n"
	@zip PDF.zip PDF/*.pdf > /dev/null
	@printf "$(GREEN)✔ Successfully created PDF.zip$(NC)\n"



create_summary :
# takes course name and author name as arguments
	@echo "Creating summary files..."
	@if [ -z "$(TITLE)" ] || [ -z "$(AUTHOR)" ] || [ -z "$(DIR)" ] || [ -z "$(SEMESTER)" ]; then \
		echo "Error: Please provide TITLE, AUTHOR, DIR, and SEMESTER variables."; \
		echo "Usage: make create_summary TITLE='Course Title' AUTHOR='Author Name' DIR='course_dir' SEMESTER='M2S1'"; \
		exit 1; \
	fi
	@echo "Creating directory $(SEMESTER)_$(DIR)..."
	@mkdir $(SEMESTER)_$(DIR)
	@cp template/* $(SEMESTER)_$(DIR)
	@sed -i "s/TITLE NAME/$(TITLE)/g" $(SEMESTER)_$(DIR)/summary.md
	@sed -i "s/AUTHOR/$(AUTHOR)/g" $(SEMESTER)_$(DIR)/summary.md
	@printf "$(GREEN)✔ Successfully created summary directory $(BLUE)$(SEMESTER)_$(DIR)$(NC)\n"

clean :
	rm  -rf PDF/
	rm  -f *.pdf
	mkdir PDF

help:
	@printf "$(BLUE)Makefile for Course Summary Compilation\n\n$(NC)"
	@printf "$(YELLOW)Usage:$(NC)\n"
	@printf "  make $(GREEN)<target>$(NC)\n\n"
	@printf "$(YELLOW)Available targets:$(NC)\n"
	@printf "  $(GREEN)%-20s$(NC) %s\n" "compile" "Compile all summaries into PDF/ and create a zip archive."
	@printf "  $(GREEN)%-20s$(NC) %s\n" "create_summary [ARG]" "Create a new summary directory from a template."
	@printf "  $(GREEN)%-20s$(NC) %s\n" "zip" "Create a zip archive from existing PDFs in the PDF/ directory."
	@printf "  $(GREEN)%-20s$(NC) %s\n" "clean" "Remove all generated files (PDF/ directory, zip archive)."
	@printf "  $(GREEN)%-20s$(NC) %s\n" "rebuild" "Perform a full clean and compile."
	@printf "  $(GREEN)%-20s$(NC) %s\n" "help" "Show this help message."
	@printf "\n$(YELLOW)Example for 'create_summary':$(NC)\n"
	@printf "  make create_summary DIR='OS' SEMESTER='M1S2' TITLE='Operating Systems' AUTHOR='Your Name'\n\n"

# touch all summary.md files to force recompilation
touch:
	@touch $(SOURCES)
	@printf "$(GREEN)✔ Successfully touched all summary.md files.$(NC)Ready to be recompiled\n"

.PHONY: rebuild
rebuild: clean compile