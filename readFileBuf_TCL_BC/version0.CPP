
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
rf=fopen("test.cls","r"); //"test_tb.txt" //test.cls
if (rf==NULL) { puts("Can't open file");   return(-1); }
ff=fopen("testfile.txt","w");
if (ff==NULL) { puts("Can't write file");   return(-2); }

 i=0;flagBuffer=0; j=0; Num=-1; fl=0;
 jp=fgets(sp1,80,rf);
 while(fl==0)
 {
       strcpy(Buffer[i],sp1);
       p=i;
	clrscr();printf("Analiz for  %d string (%d)  NULL=%s \n",p,j,jp);
	Analiz(p);
	getch();
   if(jp==NULL)
   { fl=1;
/**/     printf("\n|||Out file \n"); getch();
/**/     for(l=0;l<p;l++) { j++; fprintf(ff,"%d| %s",j,Buffer[l]); }
    } else {
       if (p==2) {  Num=0;strcpy(sp2,"Elena\n");  }
       if (p==5) {  Num=3;strcpy(sp2,"dfksf\n");  }
       if (p==11) {  Num=9;strcpy(sp2,"EndofLine\n");  }
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

/*  This function code the feed value for N33 numeric control */
void feed_convert(int f,int mode,char  *new_feed)
{ int k;
  if(f>0)
  {
  k=log10((double)f);
  if(k==1) f=f;
  else if(k==0) f=f*10;
  else if(k>=1 && k<=2) f=f/10;
  else if(k>2 && k<=3) f=f/100;
  sprintf(new_feed,"%1d%1d%2.2d",mode, k+4, f);
  k=0;
  }
  else strcpy(new_feed,"0000");
}

/* This function read the numeric string after key letter
	in success it return 1, otherwice 0
*/
int read_word(char *s,char w,char *sw)

{  char *word,sym; int  nt;
   if(s==NULL) return(0);
   if ((word=strchr(s,w))==NULL) return(0);
   nt=0;
   do
   {  sym=*(word+(nt+1));
      if (isdigit(sym)||sym==' '||sym=='+'||sym=='-'||sym=='.') nt++; else break;
   } while (1);
   if (nt>0){ strncpy(sw,word+1,nt); sw[nt]='\0'; return(nt); }
     else return(0);
}

/* This function replace the numeric string after key letter
	if there isn't a key letter in a string funktion adds it
	at the end of a string */
void replace_word(char *s,char w,char *sw)
{  int nt;  char old_sw[20],save[100],*p;

  if ((nt=read_word(s,w,old_sw))!=0)
  {
	 /* replace word */
	 p=strchr(s,w);
	 *(p+1)='\0'; strcpy(save,p+nt+1);
	 strcat(strcat(s,sw),save);
  }
  else
  {
	 /* add word at the end of string */
       if((nt=read_word(s,'L',old_sw))==0)
	{
			p=strchr(s,'<') ; /* string have <CR> or <LF> as text */
	 if (p==NULL)   p=strchr(s,'\r'); /* string have \r\n */
	 if (p==NULL)   p=strchr(s,'\n'); /* string have \n   */
	 if (p!=NULL)
	 { strcpy(save,p); *p=w; *(p+1)='\0'; strcat(strcat(s,sw),save); }
	 else
	 {
		save[0]=w; save[1]='\n'; save[2]='\0'; strcat(strcat(s,save),sw); }
	}
       else
	{
	p=strchr(s,'L'); *p=w;
	*(p+1)='\0'; strcpy(save,p+nt+1);
	strcat(strcat(s,sw),save);
	strcat(strcat(s,"L"),strcat(old_sw,"\n"));
	}

  }
}
