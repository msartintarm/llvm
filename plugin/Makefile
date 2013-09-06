# Makefile for MST's pass

# Path to top level of LLVM hierarchy
LEVEL = ../../..

LLVM_OBJ_ROOT = /scratch/sartin-t/work/obj/llvm
LLVM_SRC_ROOT = /scratch/sartin-t/work/src/llvm

# Name of the library to build
LIBRARYNAME = PluginMST

# Make the shared library become a loadable module so the tools can
# dlopen/dlsym on the resulting library.
LOADABLE_MODULE = 1

# Include the makefile implementation stuff
include $(LEVEL)/Makefile.common
