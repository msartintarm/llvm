INSTALL = /scratch/sartin-t/work/install
DRAGONEGG = -fplugin=$(INSTALL)/dg/x86/dragonegg.so
LLVM-OPT = $(INSTALL)/llvm/bin/opt
LLVM-OPT-ANALYZE = $(LLVM-OPT) -analyze
LLVM-LLC = $(INSTALL)/llvm/bin/llc
GCC = $(INSTALL)/gcc/bin/gcc
FILE = hello.c
OPTFILES = $(FILE:.c=.opt-ll) $(FILE:.c=.1.opt-ll) $(FILE:.c=.2.opt-ll) $(FILE:.c=.3.opt-ll)
OUTFILES = $(OPTFILES:.opt-ll=.out)

.PHONY: all opt ayz
all: $(OUTFILES) opt
opt: $(OPTFILES)
ayz: hello.ayz-ll hello.1.ayz-ll hello.2.ayz-ll hello.3.ayz-ll

# Turns optimized file into executable
%.out : %.s; $(GCC) $< -o $@

# Compiles LLVM optimized IR code into assembly
%.s : %.opt-ll; $(LLVM-LLC) $< -o $@

# Optimizes LLVM IR code
%.opt-ll : %.ll; $(LLVM-OPT) $< -o $@ -S
%.1.opt-ll : %.ll; $(LLVM-OPT) $< -o $@ -S -O1
%.2.opt-ll : %.ll; $(LLVM-OPT) $< -o $@ -S -O2
%.3.opt-ll : %.ll; $(LLVM-OPT) $< -o $@ -S -O3

# Analyzes LLVM IR code
%.ayz-ll : %.ll; $(LLVM-OPT-ANALYZE) $< -o $@
%.1.ayz-ll : %.ll; $(LLVM-OPT-ANALYZE) $< -o $@ -O1
%.2.ayz-ll : %.ll; $(LLVM-OPT-ANALYZE) $< -o $@ -O2
%.3.ayz-ll : %.ll; $(LLVM-OPT-ANALYZE) $< -o $@ -O3

# Turns C file into LLVM representation
%.ll: %.c; $(GCC) $(DRAGONEGG) $< -o $@ -S -flto

clean: ; rm -f *.ll *.opt-ll *.s *.out
