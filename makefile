# Define targets
all:
	mkdir -p build
	ghc -i./src -i./latte -o latc -hidir build/ -odir build/ src/Main.hs && chmod +x latc

# Main build rule

# Clean rule
clean:
	rm -r build

.PHONY: all clean clean_test
