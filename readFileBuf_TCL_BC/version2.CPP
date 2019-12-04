
#include <stdio.h>
#include <string.h>
#include <conio.h>
#include <time.h>
#include <math.h>
#include <CTYPE.H>

#define n 25

char Buffer[n][81];

int Analiz(int pl)
{
for(int i=0;i<pl;i++) printf("%s",Buffer[i]);

return 0;
}



int main(void)
{
FILE *rf,*ff;    time_t t; time(&t);
char sp1[80],sp2[80]; int p,l,k,j,i,flagBuffer,Num,fl; char *jp;
clrscr();
rf=fopen("3test.cls","r"); //"test_tb.txt" //test.cls
if (rf==NULL) { puts("Can't open file");   return(-1); }
ff=fopen("testfile.txt","w");
if (ff==NULL) { puts("Can't write file");   return(-2); }

 i=0;flagBuffer=0; j=0; Num=-1; fl=0;
 jp=fgets(sp1,80,rf);
 while(fl==0)
 {
       strcpy(Buffer[i],sp1);
       p=i;
	if ((p==(n-1))||(jp==NULL))
	{
// Num=0;strcpy(sp2,"Elena\n");
// Num=3;strcpy(sp2,"dfksf\n");
// Num=9;strcpy(sp2,"EndofLine\n");
	clrscr();printf("Analiz for  %d string (%d)  NULL=%s \n",p,j,jp);
	Analiz(p);
	getch();
	}
   if(jp==NULL)
   { fl=1;
/**/     printf("\n|||Out file \n"); getch();
/**/     for(l=0;l<p;l++) { j++; fprintf(ff,"%d| %s",j,Buffer[l]); }
    } else {
       if (i!=(n-1)) i++; else { flagBuffer=1; i=n-1; }
       if (flagBuffer==1||Num!=-1) { //->
	 j++;
	 fprintf(ff,"%d| %s",j,Buffer[0]);
	 if (Num==-1) {
	  for(k=0;k<(n-1);k++) strcpy(Buffer[k],Buffer[k+1]);
	  } else {
	  if (Num==0) { strcpy(Buffer[0],sp2); }
	   else { for(k=0;k<(Num);k++) strcpy(Buffer[k],Buffer[k+1]);
		  strcpy(Buffer[Num],"\0");
		  strcpy(Buffer[Num],sp2);  }
	     Num=-1;
	    }

	}
      //////////////////
      jp= fgets(sp1,80,rf);
      }

 }

fclose(rf);fclose(ff);
printf("\nToday's date and time: %s\n", ctime(&t));
printf("Ready///// Press esc\n"); while(27!=getch()) { ; }
return 0;
}