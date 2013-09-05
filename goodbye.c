#include <stdio.h>

int main() {

  int total = 0;
  int i, j, k;
  for (i = 0; i < 200; ++i) {
    for (j = i; j < 201; ++j) {
      for (k = i + j; k > 0; --k) {
        ++total;
      }
    }
  }

  if (total > 100) {
    printf("Hellso world1!");
    printf("Hello world 2!");
    printf("Hello world 3!s /\n");
  }
}
