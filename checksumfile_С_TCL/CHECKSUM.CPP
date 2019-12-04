#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <conio.h>
#include <dos.h>
#include <io.h>
#include <fcntl.h>
#include <process.h>

struct stat STATBUF[1];
int fd ; char buf[512];

int readb()
{ register int r;
 r=read(fd,buf,sizeof(buf));
 return((r<=0)?0:r);
}
int chksum()
{ register int p,e; char *c; register unsigned short sum=0;
int l ;
  l=0;
  while(e=readb())
  { l+=e;
   for(p=0;p<e;p++)
   {  if (sum & 01) sum=(sum>>1)|0x8000; else sum>>=1;
      sum^=buf[p];
    }
  }
 c=ctime(&STATBUF->st_mtime);
// if ((STATBUF->st_mtime&S_IFMT)==S_IFREG)
   printf(" %o \t %s \t %d",sum,c,l);
}

int main()
{
 time_t t; time(&t);
clrscr();
fd=open("1ctr.up",0); //"test_tb.txt" //test.cls //testfile.txt
if (fd<0) { puts("Can't open file");   return(-1); }
 fstat(fd,STATBUF);
 chksum();
close(fd);
 return 0;
}