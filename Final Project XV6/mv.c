#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

char* 
strcat(char* s1, const char* s2)
{
  char* b = s1;

  while (*s1) ++s1;
  while (*s2) *s1++ = *s2++;
  *s1 = 0;

  return b;
}

int main (int argc, char *argv[]){
  if (argc != 3){
    printf(2, "mv: need 3 arguments\n");
    exit();
  }
  if(argv[1][strlen(argv[1])-1]=='*'){
        char buf[512], *p="",*path="";
        int fd;
        struct dirent de;
        struct stat st;

        memmove(path,argv[1],strlen(argv[1])-2);

        if((fd = open(path, 0)) < 0){
            printf(2, "mv: cannot open %s\n", path);
            exit();
        }

        if(fstat(fd, &st) < 0){
            printf(2, "mv: cannot stat %s\n", path);
            close(fd);
            exit();
        }
        strcpy(buf,path);
        while(read(fd,&de,sizeof(de)) == sizeof(de)){
            strcpy(path,buf);
            if(de.inum == 0){
                continue;
            }
            memmove(p, de.name, strlen(de.name));
            strcat(path,"/");
            strcat(path,p);
            
            if ((link(path, argv[2]) < 0) || (unlink(path) < 0))
                printf(2, "mv %s to %s failed\n", path, argv[2]);
        }
        close(fd);
  }
  else{
      if ((link(argv[1], argv[2]) < 0) || (unlink(argv[1]) < 0))
        printf(2, "mv %s to %s failed\n", argv[1], argv[2]);
        exit();
  }
  exit();
}