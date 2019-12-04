#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>

int fd; char buf[512] ;

int readb()
{ 
   register int r;
   r=read(fd,buf,sizeof(buf));
   return((r<=0)?0:r);
}

int   checkFileSum(char *name)
{
struct stat STATBUF[1] ;
register p ,e ; char *c;
register unsigned short sum ;
sum = 0;
 while (e=readb())
 {
    for(p=0;p<e;p++)
    {   
      if  (sum & 01) sum =(sum>>1)0x8000 ; else  sum>>=1  ;  
      sum^=buf[p] ;
     }
 }

 fstat(fd,STATBUF); 
c=ctime(&STATBUF->st_mtime);

printf("\nФайл =%s \nКонтрольная Сумма =%o \nВремя последнего изменения =%s \n",name,sum,c);

return 0 ;
}

int main(int argc, char *argv)
{
   int i ;
   for(i=1;i<argc;i++)
  { close(fd) ; 
     if ((fd=open(argv[i],0))<0) printf(" %s cannot open \n ",argv[i]);
       else checkFileSum(argv[i]);  
   }
return 0 ;
}
 