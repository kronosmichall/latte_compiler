# Define targets
all:
	cabal build && cabal install --installdir=. --overwrite-policy=always

# Main build rule

# Clean rule
clean:
	rm -r build
	rm checker

.PHONY: all clean clean_test
