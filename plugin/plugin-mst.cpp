#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {

  struct OptMST : public FunctionPass {

    static char ID;

    // Declaring pass ID here allows LLVM to avoid using C++ runtime info
    OptMST() : FunctionPass(ID) {}

    /*
     * The runOnFunction method must be implemented by your subclass to
     *  do the transformation or analysis work of your pass. As usual,
     *  a true value should be returned if the function is modified.
     */
    virtual bool runOnFunction(Function &F) {
      errs() << "Hello: ";
      errs().write_escaped(F.getName()) << "\n";
      return false;
    }
  }; // end of struct Hello
}  // end of anonymous namespace

char OptMST::ID = 0;

// Command-line arg; name;
// does the pass leave CFG untouched?; is it an analysis pass?
static RegisterPass<OptMST> X("mst", "Michael Sartin-Tarm's Pass", false, false);
