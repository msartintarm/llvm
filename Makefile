INSTALL = /scratch/sartin-t/work/install
DRAGONEGG = -fplugin=$(INSTALL)/dg/x86/dragonegg.so
LLVM-OPT = $(INSTALL)/llvm/bin/opt
LLVM-OPT-ANALYZE = $(LLVM-OPT) -analyze
LLVM-LLC = $(INSTALL)/llvm/bin/llc
GCC = $(INSTALL)/gcc/bin/gcc
FILE = hello.c
OPTFILES = $(FILE:.c=.0.opt-ll) $(FILE:.c=.1.opt-ll) $(FILE:.c=.2.opt-ll) $(FILE:.c=.3.opt-ll) $(FILE:.c=.mst.opt-ll)
AYZFILES = $(OPTFILES:.opt-ll=.ayz-ll)
OUTFILES = $(OPTFILES:.opt-ll=.out)
PLUGINDIR = /scratch/sartin-t/work/src/llvm/lib/Transforms/PluginMST
PLUGINFILE = plugin/plugin-mst.cpp

.PHONY: all opt ayz plugin
all: $(OUTFILES) opt ayz
opt: $(OPTFILES)
ayz: $(AYZFILES)

# Turns optimized file into executable
%.out : %.s; $(GCC) $< -o $@

# Compiles LLVM optimized IR code into assembly
%.s : %.opt-ll; $(LLVM-LLC) $< -o $@

# Optimizes LLVM IR code
%.0.opt-ll : %.ll; $(LLVM-OPT) $< -o $@ -S
%.1.opt-ll : %.ll; $(LLVM-OPT) $< -o $@ -S -O1
%.2.opt-ll : %.ll; $(LLVM-OPT) $< -o $@ -S -O2
%.3.opt-ll : %.ll; $(LLVM-OPT) $< -o $@ -S -O3
%.mst.opt-ll : %.ll create-plugin; $(LLVM-OPT) -load $(PLUGINDIR)/../../../Release+Asserts/lib/PluginMST.so -mst $< -o $@ -S

# Analyzes LLVM IR code
%.0.ayz-ll : %.ll; $(LLVM-OPT-ANALYZE) $< -o $@
%.1.ayz-ll : %.ll; $(LLVM-OPT-ANALYZE) $< -o $@ -O1
%.2.ayz-ll : %.ll; $(LLVM-OPT-ANALYZE) $< -o $@ -O2
%.3.ayz-ll : %.ll; $(LLVM-OPT-ANALYZE) $< -o $@ -O3
%.mst.ayz-ll : %.ll create-plugin; $(LLVM-OPT-ANALYZE) -load $(PLUGINDIR)/../../../Release+Asserts/lib/PluginMST.so -mst $< -o $@

# Turns C file into LLVM representation
%.ll: %.c; $(GCC) $(DRAGONEGG) $< -o $@ -S -flto

# Integrates C++ plugin file into LLVM build path and runs it
create-plugin: $(PLUGINFILE)
	rm -rf $(PLUGINDIR)
	cp -r plugin $(PLUGINDIR)
	cd $(PLUGINDIR); gmake

clean: ; rm -f *.ll *.opt-ll *.ayz-ll *.s *.out
