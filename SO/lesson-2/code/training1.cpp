#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

#include "delays.h"
#include "process.h"

int main(void)
{

  pid_t ret = pfork();
  if (ret == 0)
  {

    for (int i = 0; i < 10; i++) {
      printf("%d\n", i + 1);
    }
    
  }
  else
  {
    
    pwait(NULL);
    
    for (int i = 10; i < 20; i++) {
      printf("%d\n", i + 1);
    }

    
  }

  return EXIT_SUCCESS;
}

