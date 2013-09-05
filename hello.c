#include <stdio.h>

int main() {

  int i;
  int total = 0;
  for (i = 0; i < 200; ++i) {
    int j;
    for (j = i; j < 201; ++j) {
      int k;
      for (k = i + j; k > 0; --k) {
        ++total;
      }
    }
  }

  if (total > 101) {
    printf("Hellso world1!");
    printf("Hello world 2!");
    printf("Hello world 3!s /\n");
  }
}
