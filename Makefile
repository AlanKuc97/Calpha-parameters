# --- Makefile ---

# This Makefile tests programs in the current directory by running all
# test cases and comparing their outputs with the reference files
# '.ref'.

TEST_DIR = tests
TEST_CASE_DIR = ${TEST_DIR}/cases
TEST_OUTPUT_DIR = ${TEST_DIR}/outputs

TEST_CASES = $(wildcard ${TEST_CASE_DIR}/*.sh)
TEST_DIFFS = ${TEST_CASES:${TEST_CASE_DIR}/%.sh=${TEST_OUTPUT_DIR}/%.diff}
TEST_REFS  = ${TEST_CASES:${TEST_CASE_DIR}/%.sh=${TEST_OUTPUT_DIR}/%.ref}

.PHONY: all test

all: test ref out outputs

test: ${TEST_DIFFS}

ref out outputs: ${TEST_REFS}

#------------------------------------------------------------------------------

.PHONY: display

VARIABLE=PATH

display:
	true ${VARIABLE}=${${VARIABLE}}

#------------------------------------------------------------------------------

${TEST_OUTPUT_DIR}/%.diff: ${TEST_CASE_DIR}/%.sh ${TEST_OUTPUT_DIR}/%.ref
	@printf "%-30s: " $*
	@./$< 2>&1 | diff -I '^# Id' $(word 2,$^) - > $@; \
	if [ $$? -eq 0 ]; then \
		echo OK; \
	else \
	echo FAILED:; \
	cat $@; \
	fi

${TEST_OUTPUT_DIR}/%.ref: ${TEST_CASE_DIR}/%.sh
	@printf "%-30s: " $*
	test -f $@ || ./$< > $@ 2>&1; true
	test -f $@ && touch $@
	cat $@

#------------------------------------------------------------------------------

.PHONY: listdiff failed

listdiff failed:
	find ${TEST_OUTPUT_DIR} -name *.diff -size +0 | sort

#------------------------------------------------------------------------------

.PHONY: clean distclean

clean:
	rm -f ${TEST_DIFFS}

distclean: clean
