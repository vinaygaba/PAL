#include <stdio.h>
 
int main () {

   /* an array with 5 rows and 2 columns*/
   int a[2][3] = { {0,0,0}, {1,2,4} };
   int i, j;
 
   /* output each array element's value */
   for ( i = 0; i < 2; i++ ) {

      for ( j = 0; j < 3; j++ ) {
         printf("a[%d][%d] = %d\n", i,j, a[i][j] );
      }
   }
   
   return 0;
}