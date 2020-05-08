
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  close(fd);
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	bb 01 00 00 00       	mov    $0x1,%ebx
  16:	83 ec 08             	sub    $0x8,%esp
  19:	8b 31                	mov    (%ecx),%esi
  1b:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
  1e:	83 fe 01             	cmp    $0x1,%esi
  21:	7e 1f                	jle    42 <main+0x42>
  23:	90                   	nop
  24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	ff 34 9f             	pushl  (%edi,%ebx,4)

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
  2e:	83 c3 01             	add    $0x1,%ebx
    ls(argv[i]);
  31:	e8 ca 00 00 00       	call   100 <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
  36:	83 c4 10             	add    $0x10,%esp
  39:	39 de                	cmp    %ebx,%esi
  3b:	75 eb                	jne    28 <main+0x28>
    ls(argv[i]);
  exit();
  3d:	e8 80 05 00 00       	call   5c2 <exit>
main(int argc, char *argv[])
{
  int i;

  if(argc < 2){
    ls(".");
  42:	83 ec 0c             	sub    $0xc,%esp
  45:	68 8c 0a 00 00       	push   $0xa8c
  4a:	e8 b1 00 00 00       	call   100 <ls>
    exit();
  4f:	e8 6e 05 00 00       	call   5c2 <exit>
  54:	66 90                	xchg   %ax,%ax
  56:	66 90                	xchg   %ax,%ax
  58:	66 90                	xchg   %ax,%ax
  5a:	66 90                	xchg   %ax,%ax
  5c:	66 90                	xchg   %ax,%ax
  5e:	66 90                	xchg   %ax,%ax

00000060 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	56                   	push   %esi
  64:	53                   	push   %ebx
  65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  68:	83 ec 0c             	sub    $0xc,%esp
  6b:	53                   	push   %ebx
  6c:	e8 8f 03 00 00       	call   400 <strlen>
  71:	83 c4 10             	add    $0x10,%esp
  74:	01 d8                	add    %ebx,%eax
  76:	73 0f                	jae    87 <fmtname+0x27>
  78:	eb 12                	jmp    8c <fmtname+0x2c>
  7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  80:	83 e8 01             	sub    $0x1,%eax
  83:	39 c3                	cmp    %eax,%ebx
  85:	77 05                	ja     8c <fmtname+0x2c>
  87:	80 38 2f             	cmpb   $0x2f,(%eax)
  8a:	75 f4                	jne    80 <fmtname+0x20>
    ;
  p++;
  8c:	8d 58 01             	lea    0x1(%eax),%ebx

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  8f:	83 ec 0c             	sub    $0xc,%esp
  92:	53                   	push   %ebx
  93:	e8 68 03 00 00       	call   400 <strlen>
  98:	83 c4 10             	add    $0x10,%esp
  9b:	83 f8 0d             	cmp    $0xd,%eax
  9e:	77 4a                	ja     ea <fmtname+0x8a>
    return p;
  memmove(buf, p, strlen(p));
  a0:	83 ec 0c             	sub    $0xc,%esp
  a3:	53                   	push   %ebx
  a4:	e8 57 03 00 00       	call   400 <strlen>
  a9:	83 c4 0c             	add    $0xc,%esp
  ac:	50                   	push   %eax
  ad:	53                   	push   %ebx
  ae:	68 a4 0d 00 00       	push   $0xda4
  b3:	e8 d8 04 00 00       	call   590 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  b8:	89 1c 24             	mov    %ebx,(%esp)
  bb:	e8 40 03 00 00       	call   400 <strlen>
  c0:	89 1c 24             	mov    %ebx,(%esp)
  c3:	89 c6                	mov    %eax,%esi
  return buf;
  c5:	bb a4 0d 00 00       	mov    $0xda4,%ebx

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  ca:	e8 31 03 00 00       	call   400 <strlen>
  cf:	ba 0e 00 00 00       	mov    $0xe,%edx
  d4:	83 c4 0c             	add    $0xc,%esp
  d7:	05 a4 0d 00 00       	add    $0xda4,%eax
  dc:	29 f2                	sub    %esi,%edx
  de:	52                   	push   %edx
  df:	6a 20                	push   $0x20
  e1:	50                   	push   %eax
  e2:	e8 49 03 00 00       	call   430 <memset>
  return buf;
  e7:	83 c4 10             	add    $0x10,%esp
}
  ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  ed:	89 d8                	mov    %ebx,%eax
  ef:	5b                   	pop    %ebx
  f0:	5e                   	pop    %esi
  f1:	5d                   	pop    %ebp
  f2:	c3                   	ret    
  f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000100 <ls>:

void
ls(char *path)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
 104:	56                   	push   %esi
 105:	53                   	push   %ebx
 106:	81 ec 64 02 00 00    	sub    $0x264,%esp
 10c:	8b 7d 08             	mov    0x8(%ebp),%edi
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
 10f:	6a 00                	push   $0x0
 111:	57                   	push   %edi
 112:	e8 eb 04 00 00       	call   602 <open>
 117:	83 c4 10             	add    $0x10,%esp
 11a:	85 c0                	test   %eax,%eax
 11c:	0f 88 e6 01 00 00    	js     308 <ls+0x208>
    printf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
 122:	8d b5 bc fd ff ff    	lea    -0x244(%ebp),%esi
 128:	83 ec 08             	sub    $0x8,%esp
 12b:	89 c3                	mov    %eax,%ebx
 12d:	56                   	push   %esi
 12e:	50                   	push   %eax
 12f:	e8 e6 04 00 00       	call   61a <fstat>
 134:	83 c4 10             	add    $0x10,%esp
 137:	85 c0                	test   %eax,%eax
 139:	0f 88 01 02 00 00    	js     340 <ls+0x240>
    printf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
 13f:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 146:	66 83 f8 01          	cmp    $0x1,%ax
 14a:	0f 84 88 00 00 00    	je     1d8 <ls+0xd8>
 150:	66 83 f8 02          	cmp    $0x2,%ax
 154:	75 6a                	jne    1c0 <ls+0xc0>
  case T_FILE:
    printf(1, "%s %d %d %d", fmtname(path), st.type, st.ino, st.size);
 156:	83 ec 0c             	sub    $0xc,%esp
 159:	8b 95 cc fd ff ff    	mov    -0x234(%ebp),%edx
 15f:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 165:	57                   	push   %edi
 166:	89 95 a4 fd ff ff    	mov    %edx,-0x25c(%ebp)
 16c:	e8 ef fe ff ff       	call   60 <fmtname>
 171:	8b 95 a4 fd ff ff    	mov    -0x25c(%ebp),%edx
 177:	59                   	pop    %ecx
 178:	5f                   	pop    %edi
 179:	52                   	push   %edx
 17a:	56                   	push   %esi
 17b:	6a 02                	push   $0x2
 17d:	50                   	push   %eax
 17e:	68 58 0a 00 00       	push   $0xa58
 183:	6a 01                	push   $0x1
 185:	e8 86 05 00 00       	call   710 <printf>
    printf(1, "\t\t%d:%d:%d %d/%d/%d\n",st.hour,st.minute,st.second,st.day,st.month,st.year);
 18a:	83 c4 20             	add    $0x20,%esp
 18d:	ff b5 e4 fd ff ff    	pushl  -0x21c(%ebp)
 193:	ff b5 e0 fd ff ff    	pushl  -0x220(%ebp)
 199:	ff b5 dc fd ff ff    	pushl  -0x224(%ebp)
 19f:	ff b5 d0 fd ff ff    	pushl  -0x230(%ebp)
 1a5:	ff b5 d4 fd ff ff    	pushl  -0x22c(%ebp)
 1ab:	ff b5 d8 fd ff ff    	pushl  -0x228(%ebp)
 1b1:	68 64 0a 00 00       	push   $0xa64
 1b6:	6a 01                	push   $0x1
 1b8:	e8 53 05 00 00       	call   710 <printf>
    break;
 1bd:	83 c4 20             	add    $0x20,%esp
      printf(1, "%s %d %d %d", buf, st.type, st.ino, st.size);
      printf(1, "\t\t%d:%d:%d %d/%d/%d\n",st.hour,st.minute,st.second,st.day,st.month,st.year);
    }
    break;
  }
  close(fd);
 1c0:	83 ec 0c             	sub    $0xc,%esp
 1c3:	53                   	push   %ebx
 1c4:	e8 21 04 00 00       	call   5ea <close>
 1c9:	83 c4 10             	add    $0x10,%esp
}
 1cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1cf:	5b                   	pop    %ebx
 1d0:	5e                   	pop    %esi
 1d1:	5f                   	pop    %edi
 1d2:	5d                   	pop    %ebp
 1d3:	c3                   	ret    
 1d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "%s %d %d %d", fmtname(path), st.type, st.ino, st.size);
    printf(1, "\t\t%d:%d:%d %d/%d/%d\n",st.hour,st.minute,st.second,st.day,st.month,st.year);
    break;

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1d8:	83 ec 0c             	sub    $0xc,%esp
 1db:	57                   	push   %edi
 1dc:	e8 1f 02 00 00       	call   400 <strlen>
 1e1:	83 c0 10             	add    $0x10,%eax
 1e4:	83 c4 10             	add    $0x10,%esp
 1e7:	3d 00 02 00 00       	cmp    $0x200,%eax
 1ec:	0f 87 36 01 00 00    	ja     328 <ls+0x228>
      printf(1, "ls: path too long\n");
      break;
    }
    strcpy(buf, path);
 1f2:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1f8:	83 ec 08             	sub    $0x8,%esp
 1fb:	57                   	push   %edi
 1fc:	8d bd ac fd ff ff    	lea    -0x254(%ebp),%edi
 202:	50                   	push   %eax
 203:	e8 78 01 00 00       	call   380 <strcpy>
    p = buf+strlen(buf);
 208:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 20e:	89 04 24             	mov    %eax,(%esp)
 211:	e8 ea 01 00 00       	call   400 <strlen>
 216:	8d 8d e8 fd ff ff    	lea    -0x218(%ebp),%ecx
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 21c:	83 c4 10             	add    $0x10,%esp
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf(1, "ls: path too long\n");
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
 21f:	01 c1                	add    %eax,%ecx
    *p++ = '/';
 221:	8d 84 05 e9 fd ff ff 	lea    -0x217(%ebp,%eax,1),%eax
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf(1, "ls: path too long\n");
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
 228:	89 8d a4 fd ff ff    	mov    %ecx,-0x25c(%ebp)
    *p++ = '/';
 22e:	c6 01 2f             	movb   $0x2f,(%ecx)
 231:	89 85 a0 fd ff ff    	mov    %eax,-0x260(%ebp)
 237:	89 f6                	mov    %esi,%esi
 239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 240:	83 ec 04             	sub    $0x4,%esp
 243:	6a 10                	push   $0x10
 245:	57                   	push   %edi
 246:	53                   	push   %ebx
 247:	e8 8e 03 00 00       	call   5da <read>
 24c:	83 c4 10             	add    $0x10,%esp
 24f:	83 f8 10             	cmp    $0x10,%eax
 252:	0f 85 68 ff ff ff    	jne    1c0 <ls+0xc0>
      if(de.inum == 0)
 258:	66 83 bd ac fd ff ff 	cmpw   $0x0,-0x254(%ebp)
 25f:	00 
 260:	74 de                	je     240 <ls+0x140>
        continue;
      // printf(1,"%s\n",p);
      memmove(p, de.name, DIRSIZ);
 262:	8d 85 ae fd ff ff    	lea    -0x252(%ebp),%eax
 268:	83 ec 04             	sub    $0x4,%esp
 26b:	6a 0e                	push   $0xe
 26d:	50                   	push   %eax
 26e:	ff b5 a0 fd ff ff    	pushl  -0x260(%ebp)
 274:	e8 17 03 00 00       	call   590 <memmove>
      // printf(1,"%s\n",p);
      p[DIRSIZ] = 0;
 279:	8b 85 a4 fd ff ff    	mov    -0x25c(%ebp),%eax
 27f:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
      if(stat(buf, &st) < 0){
 283:	58                   	pop    %eax
 284:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 28a:	5a                   	pop    %edx
 28b:	56                   	push   %esi
 28c:	50                   	push   %eax
 28d:	e8 6e 02 00 00       	call   500 <stat>
 292:	83 c4 10             	add    $0x10,%esp
 295:	85 c0                	test   %eax,%eax
 297:	0f 88 c3 00 00 00    	js     360 <ls+0x260>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d", buf, st.type, st.ino, st.size);
 29d:	0f bf 85 bc fd ff ff 	movswl -0x244(%ebp),%eax
 2a4:	83 ec 08             	sub    $0x8,%esp
 2a7:	ff b5 cc fd ff ff    	pushl  -0x234(%ebp)
 2ad:	ff b5 c4 fd ff ff    	pushl  -0x23c(%ebp)
 2b3:	50                   	push   %eax
 2b4:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 2ba:	50                   	push   %eax
 2bb:	68 58 0a 00 00       	push   $0xa58
 2c0:	6a 01                	push   $0x1
 2c2:	e8 49 04 00 00       	call   710 <printf>
      printf(1, "\t\t%d:%d:%d %d/%d/%d\n",st.hour,st.minute,st.second,st.day,st.month,st.year);
 2c7:	83 c4 20             	add    $0x20,%esp
 2ca:	ff b5 e4 fd ff ff    	pushl  -0x21c(%ebp)
 2d0:	ff b5 e0 fd ff ff    	pushl  -0x220(%ebp)
 2d6:	ff b5 dc fd ff ff    	pushl  -0x224(%ebp)
 2dc:	ff b5 d0 fd ff ff    	pushl  -0x230(%ebp)
 2e2:	ff b5 d4 fd ff ff    	pushl  -0x22c(%ebp)
 2e8:	ff b5 d8 fd ff ff    	pushl  -0x228(%ebp)
 2ee:	68 64 0a 00 00       	push   $0xa64
 2f3:	6a 01                	push   $0x1
 2f5:	e8 16 04 00 00       	call   710 <printf>
 2fa:	83 c4 20             	add    $0x20,%esp
 2fd:	e9 3e ff ff ff       	jmp    240 <ls+0x140>
 302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
    printf(2, "ls: cannot open %s\n", path);
 308:	83 ec 04             	sub    $0x4,%esp
 30b:	57                   	push   %edi
 30c:	68 30 0a 00 00       	push   $0xa30
 311:	6a 02                	push   $0x2
 313:	e8 f8 03 00 00       	call   710 <printf>
    return;
 318:	83 c4 10             	add    $0x10,%esp
      printf(1, "\t\t%d:%d:%d %d/%d/%d\n",st.hour,st.minute,st.second,st.day,st.month,st.year);
    }
    break;
  }
  close(fd);
}
 31b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 31e:	5b                   	pop    %ebx
 31f:	5e                   	pop    %esi
 320:	5f                   	pop    %edi
 321:	5d                   	pop    %ebp
 322:	c3                   	ret    
 323:	90                   	nop
 324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "\t\t%d:%d:%d %d/%d/%d\n",st.hour,st.minute,st.second,st.day,st.month,st.year);
    break;

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf(1, "ls: path too long\n");
 328:	83 ec 08             	sub    $0x8,%esp
 32b:	68 79 0a 00 00       	push   $0xa79
 330:	6a 01                	push   $0x1
 332:	e8 d9 03 00 00       	call   710 <printf>
      break;
 337:	83 c4 10             	add    $0x10,%esp
 33a:	e9 81 fe ff ff       	jmp    1c0 <ls+0xc0>
 33f:	90                   	nop
    printf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
    printf(2, "ls: cannot stat %s\n", path);
 340:	83 ec 04             	sub    $0x4,%esp
 343:	57                   	push   %edi
 344:	68 44 0a 00 00       	push   $0xa44
 349:	6a 02                	push   $0x2
 34b:	e8 c0 03 00 00       	call   710 <printf>
    close(fd);
 350:	89 1c 24             	mov    %ebx,(%esp)
 353:	e8 92 02 00 00       	call   5ea <close>
    return;
 358:	83 c4 10             	add    $0x10,%esp
 35b:	e9 6c fe ff ff       	jmp    1cc <ls+0xcc>
      // printf(1,"%s\n",p);
      memmove(p, de.name, DIRSIZ);
      // printf(1,"%s\n",p);
      p[DIRSIZ] = 0;
      if(stat(buf, &st) < 0){
        printf(1, "ls: cannot stat %s\n", buf);
 360:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 366:	83 ec 04             	sub    $0x4,%esp
 369:	50                   	push   %eax
 36a:	68 44 0a 00 00       	push   $0xa44
 36f:	6a 01                	push   $0x1
 371:	e8 9a 03 00 00       	call   710 <printf>
        continue;
 376:	83 c4 10             	add    $0x10,%esp
 379:	e9 c2 fe ff ff       	jmp    240 <ls+0x140>
 37e:	66 90                	xchg   %ax,%ax

00000380 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	53                   	push   %ebx
 384:	8b 45 08             	mov    0x8(%ebp),%eax
 387:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 38a:	89 c2                	mov    %eax,%edx
 38c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 390:	83 c1 01             	add    $0x1,%ecx
 393:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 397:	83 c2 01             	add    $0x1,%edx
 39a:	84 db                	test   %bl,%bl
 39c:	88 5a ff             	mov    %bl,-0x1(%edx)
 39f:	75 ef                	jne    390 <strcpy+0x10>
    ;
  return os;
}
 3a1:	5b                   	pop    %ebx
 3a2:	5d                   	pop    %ebp
 3a3:	c3                   	ret    
 3a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	56                   	push   %esi
 3b4:	53                   	push   %ebx
 3b5:	8b 55 08             	mov    0x8(%ebp),%edx
 3b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 3bb:	0f b6 02             	movzbl (%edx),%eax
 3be:	0f b6 19             	movzbl (%ecx),%ebx
 3c1:	84 c0                	test   %al,%al
 3c3:	75 1e                	jne    3e3 <strcmp+0x33>
 3c5:	eb 29                	jmp    3f0 <strcmp+0x40>
 3c7:	89 f6                	mov    %esi,%esi
 3c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 3d0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3d3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 3d6:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3d9:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 3dd:	84 c0                	test   %al,%al
 3df:	74 0f                	je     3f0 <strcmp+0x40>
 3e1:	89 f1                	mov    %esi,%ecx
 3e3:	38 d8                	cmp    %bl,%al
 3e5:	74 e9                	je     3d0 <strcmp+0x20>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3e7:	29 d8                	sub    %ebx,%eax
}
 3e9:	5b                   	pop    %ebx
 3ea:	5e                   	pop    %esi
 3eb:	5d                   	pop    %ebp
 3ec:	c3                   	ret    
 3ed:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3f0:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3f2:	29 d8                	sub    %ebx,%eax
}
 3f4:	5b                   	pop    %ebx
 3f5:	5e                   	pop    %esi
 3f6:	5d                   	pop    %ebp
 3f7:	c3                   	ret    
 3f8:	90                   	nop
 3f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000400 <strlen>:

uint
strlen(const char *s)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 406:	80 39 00             	cmpb   $0x0,(%ecx)
 409:	74 12                	je     41d <strlen+0x1d>
 40b:	31 d2                	xor    %edx,%edx
 40d:	8d 76 00             	lea    0x0(%esi),%esi
 410:	83 c2 01             	add    $0x1,%edx
 413:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 417:	89 d0                	mov    %edx,%eax
 419:	75 f5                	jne    410 <strlen+0x10>
    ;
  return n;
}
 41b:	5d                   	pop    %ebp
 41c:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 41d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 41f:	5d                   	pop    %ebp
 420:	c3                   	ret    
 421:	eb 0d                	jmp    430 <memset>
 423:	90                   	nop
 424:	90                   	nop
 425:	90                   	nop
 426:	90                   	nop
 427:	90                   	nop
 428:	90                   	nop
 429:	90                   	nop
 42a:	90                   	nop
 42b:	90                   	nop
 42c:	90                   	nop
 42d:	90                   	nop
 42e:	90                   	nop
 42f:	90                   	nop

00000430 <memset>:

void*
memset(void *dst, int c, uint n)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 437:	8b 4d 10             	mov    0x10(%ebp),%ecx
 43a:	8b 45 0c             	mov    0xc(%ebp),%eax
 43d:	89 d7                	mov    %edx,%edi
 43f:	fc                   	cld    
 440:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 442:	89 d0                	mov    %edx,%eax
 444:	5f                   	pop    %edi
 445:	5d                   	pop    %ebp
 446:	c3                   	ret    
 447:	89 f6                	mov    %esi,%esi
 449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000450 <strchr>:

char*
strchr(const char *s, char c)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	53                   	push   %ebx
 454:	8b 45 08             	mov    0x8(%ebp),%eax
 457:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 45a:	0f b6 10             	movzbl (%eax),%edx
 45d:	84 d2                	test   %dl,%dl
 45f:	74 1d                	je     47e <strchr+0x2e>
    if(*s == c)
 461:	38 d3                	cmp    %dl,%bl
 463:	89 d9                	mov    %ebx,%ecx
 465:	75 0d                	jne    474 <strchr+0x24>
 467:	eb 17                	jmp    480 <strchr+0x30>
 469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 470:	38 ca                	cmp    %cl,%dl
 472:	74 0c                	je     480 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 474:	83 c0 01             	add    $0x1,%eax
 477:	0f b6 10             	movzbl (%eax),%edx
 47a:	84 d2                	test   %dl,%dl
 47c:	75 f2                	jne    470 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 47e:	31 c0                	xor    %eax,%eax
}
 480:	5b                   	pop    %ebx
 481:	5d                   	pop    %ebp
 482:	c3                   	ret    
 483:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000490 <gets>:

char*
gets(char *buf, int max)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	57                   	push   %edi
 494:	56                   	push   %esi
 495:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 496:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 498:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 49b:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 49e:	eb 29                	jmp    4c9 <gets+0x39>
    cc = read(0, &c, 1);
 4a0:	83 ec 04             	sub    $0x4,%esp
 4a3:	6a 01                	push   $0x1
 4a5:	57                   	push   %edi
 4a6:	6a 00                	push   $0x0
 4a8:	e8 2d 01 00 00       	call   5da <read>
    if(cc < 1)
 4ad:	83 c4 10             	add    $0x10,%esp
 4b0:	85 c0                	test   %eax,%eax
 4b2:	7e 1d                	jle    4d1 <gets+0x41>
      break;
    buf[i++] = c;
 4b4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4b8:	8b 55 08             	mov    0x8(%ebp),%edx
 4bb:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 4bd:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 4bf:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 4c3:	74 1b                	je     4e0 <gets+0x50>
 4c5:	3c 0d                	cmp    $0xd,%al
 4c7:	74 17                	je     4e0 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4c9:	8d 5e 01             	lea    0x1(%esi),%ebx
 4cc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4cf:	7c cf                	jl     4a0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4d1:	8b 45 08             	mov    0x8(%ebp),%eax
 4d4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 4d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4db:	5b                   	pop    %ebx
 4dc:	5e                   	pop    %esi
 4dd:	5f                   	pop    %edi
 4de:	5d                   	pop    %ebp
 4df:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4e0:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4e3:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4e5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 4e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ec:	5b                   	pop    %ebx
 4ed:	5e                   	pop    %esi
 4ee:	5f                   	pop    %edi
 4ef:	5d                   	pop    %ebp
 4f0:	c3                   	ret    
 4f1:	eb 0d                	jmp    500 <stat>
 4f3:	90                   	nop
 4f4:	90                   	nop
 4f5:	90                   	nop
 4f6:	90                   	nop
 4f7:	90                   	nop
 4f8:	90                   	nop
 4f9:	90                   	nop
 4fa:	90                   	nop
 4fb:	90                   	nop
 4fc:	90                   	nop
 4fd:	90                   	nop
 4fe:	90                   	nop
 4ff:	90                   	nop

00000500 <stat>:

int
stat(const char *n, struct stat *st)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	56                   	push   %esi
 504:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 505:	83 ec 08             	sub    $0x8,%esp
 508:	6a 00                	push   $0x0
 50a:	ff 75 08             	pushl  0x8(%ebp)
 50d:	e8 f0 00 00 00       	call   602 <open>
  if(fd < 0)
 512:	83 c4 10             	add    $0x10,%esp
 515:	85 c0                	test   %eax,%eax
 517:	78 27                	js     540 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 519:	83 ec 08             	sub    $0x8,%esp
 51c:	ff 75 0c             	pushl  0xc(%ebp)
 51f:	89 c3                	mov    %eax,%ebx
 521:	50                   	push   %eax
 522:	e8 f3 00 00 00       	call   61a <fstat>
 527:	89 c6                	mov    %eax,%esi
  close(fd);
 529:	89 1c 24             	mov    %ebx,(%esp)
 52c:	e8 b9 00 00 00       	call   5ea <close>
  return r;
 531:	83 c4 10             	add    $0x10,%esp
 534:	89 f0                	mov    %esi,%eax
}
 536:	8d 65 f8             	lea    -0x8(%ebp),%esp
 539:	5b                   	pop    %ebx
 53a:	5e                   	pop    %esi
 53b:	5d                   	pop    %ebp
 53c:	c3                   	ret    
 53d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 540:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 545:	eb ef                	jmp    536 <stat+0x36>
 547:	89 f6                	mov    %esi,%esi
 549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000550 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	53                   	push   %ebx
 554:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 557:	0f be 11             	movsbl (%ecx),%edx
 55a:	8d 42 d0             	lea    -0x30(%edx),%eax
 55d:	3c 09                	cmp    $0x9,%al
 55f:	b8 00 00 00 00       	mov    $0x0,%eax
 564:	77 1f                	ja     585 <atoi+0x35>
 566:	8d 76 00             	lea    0x0(%esi),%esi
 569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 570:	8d 04 80             	lea    (%eax,%eax,4),%eax
 573:	83 c1 01             	add    $0x1,%ecx
 576:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 57a:	0f be 11             	movsbl (%ecx),%edx
 57d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 580:	80 fb 09             	cmp    $0x9,%bl
 583:	76 eb                	jbe    570 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 585:	5b                   	pop    %ebx
 586:	5d                   	pop    %ebp
 587:	c3                   	ret    
 588:	90                   	nop
 589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000590 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	56                   	push   %esi
 594:	53                   	push   %ebx
 595:	8b 5d 10             	mov    0x10(%ebp),%ebx
 598:	8b 45 08             	mov    0x8(%ebp),%eax
 59b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 59e:	85 db                	test   %ebx,%ebx
 5a0:	7e 14                	jle    5b6 <memmove+0x26>
 5a2:	31 d2                	xor    %edx,%edx
 5a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 5a8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 5ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 5af:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5b2:	39 da                	cmp    %ebx,%edx
 5b4:	75 f2                	jne    5a8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 5b6:	5b                   	pop    %ebx
 5b7:	5e                   	pop    %esi
 5b8:	5d                   	pop    %ebp
 5b9:	c3                   	ret    

000005ba <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5ba:	b8 01 00 00 00       	mov    $0x1,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <exit>:
SYSCALL(exit)
 5c2:	b8 02 00 00 00       	mov    $0x2,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <wait>:
SYSCALL(wait)
 5ca:	b8 03 00 00 00       	mov    $0x3,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <pipe>:
SYSCALL(pipe)
 5d2:	b8 04 00 00 00       	mov    $0x4,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <read>:
SYSCALL(read)
 5da:	b8 05 00 00 00       	mov    $0x5,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <write>:
SYSCALL(write)
 5e2:	b8 10 00 00 00       	mov    $0x10,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <close>:
SYSCALL(close)
 5ea:	b8 15 00 00 00       	mov    $0x15,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <kill>:
SYSCALL(kill)
 5f2:	b8 06 00 00 00       	mov    $0x6,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <exec>:
SYSCALL(exec)
 5fa:	b8 07 00 00 00       	mov    $0x7,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <open>:
SYSCALL(open)
 602:	b8 0f 00 00 00       	mov    $0xf,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <mknod>:
SYSCALL(mknod)
 60a:	b8 11 00 00 00       	mov    $0x11,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <unlink>:
SYSCALL(unlink)
 612:	b8 12 00 00 00       	mov    $0x12,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <fstat>:
SYSCALL(fstat)
 61a:	b8 08 00 00 00       	mov    $0x8,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <link>:
SYSCALL(link)
 622:	b8 13 00 00 00       	mov    $0x13,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <mkdir>:
SYSCALL(mkdir)
 62a:	b8 14 00 00 00       	mov    $0x14,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <chdir>:
SYSCALL(chdir)
 632:	b8 09 00 00 00       	mov    $0x9,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <dup>:
SYSCALL(dup)
 63a:	b8 0a 00 00 00       	mov    $0xa,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <getpid>:
SYSCALL(getpid)
 642:	b8 0b 00 00 00       	mov    $0xb,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <sbrk>:
SYSCALL(sbrk)
 64a:	b8 0c 00 00 00       	mov    $0xc,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <sleep>:
SYSCALL(sleep)
 652:	b8 0d 00 00 00       	mov    $0xd,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <uptime>:
SYSCALL(uptime)
 65a:	b8 0e 00 00 00       	mov    $0xe,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <date>:
SYSCALL(date)
 662:	b8 16 00 00 00       	mov    $0x16,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    
 66a:	66 90                	xchg   %ax,%ax
 66c:	66 90                	xchg   %ax,%ax
 66e:	66 90                	xchg   %ax,%ax

00000670 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
 676:	89 c6                	mov    %eax,%esi
 678:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 67b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 67e:	85 db                	test   %ebx,%ebx
 680:	74 7e                	je     700 <printint+0x90>
 682:	89 d0                	mov    %edx,%eax
 684:	c1 e8 1f             	shr    $0x1f,%eax
 687:	84 c0                	test   %al,%al
 689:	74 75                	je     700 <printint+0x90>
    neg = 1;
    x = -xx;
 68b:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 68d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 694:	f7 d8                	neg    %eax
 696:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 699:	31 ff                	xor    %edi,%edi
 69b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 69e:	89 ce                	mov    %ecx,%esi
 6a0:	eb 08                	jmp    6aa <printint+0x3a>
 6a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 6a8:	89 cf                	mov    %ecx,%edi
 6aa:	31 d2                	xor    %edx,%edx
 6ac:	8d 4f 01             	lea    0x1(%edi),%ecx
 6af:	f7 f6                	div    %esi
 6b1:	0f b6 92 98 0a 00 00 	movzbl 0xa98(%edx),%edx
  }while((x /= base) != 0);
 6b8:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 6ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 6bd:	75 e9                	jne    6a8 <printint+0x38>
  if(neg)
 6bf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 6c2:	8b 75 c0             	mov    -0x40(%ebp),%esi
 6c5:	85 c0                	test   %eax,%eax
 6c7:	74 08                	je     6d1 <printint+0x61>
    buf[i++] = '-';
 6c9:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 6ce:	8d 4f 02             	lea    0x2(%edi),%ecx
 6d1:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 6d5:	8d 76 00             	lea    0x0(%esi),%esi
 6d8:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6db:	83 ec 04             	sub    $0x4,%esp
 6de:	83 ef 01             	sub    $0x1,%edi
 6e1:	6a 01                	push   $0x1
 6e3:	53                   	push   %ebx
 6e4:	56                   	push   %esi
 6e5:	88 45 d7             	mov    %al,-0x29(%ebp)
 6e8:	e8 f5 fe ff ff       	call   5e2 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6ed:	83 c4 10             	add    $0x10,%esp
 6f0:	39 df                	cmp    %ebx,%edi
 6f2:	75 e4                	jne    6d8 <printint+0x68>
    putc(fd, buf[i]);
}
 6f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6f7:	5b                   	pop    %ebx
 6f8:	5e                   	pop    %esi
 6f9:	5f                   	pop    %edi
 6fa:	5d                   	pop    %ebp
 6fb:	c3                   	ret    
 6fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 700:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 702:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 709:	eb 8b                	jmp    696 <printint+0x26>
 70b:	90                   	nop
 70c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000710 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	57                   	push   %edi
 714:	56                   	push   %esi
 715:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 716:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 719:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 71c:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 71f:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 722:	89 45 d0             	mov    %eax,-0x30(%ebp)
 725:	0f b6 1e             	movzbl (%esi),%ebx
 728:	83 c6 01             	add    $0x1,%esi
 72b:	84 db                	test   %bl,%bl
 72d:	0f 84 b0 00 00 00    	je     7e3 <printf+0xd3>
 733:	31 d2                	xor    %edx,%edx
 735:	eb 39                	jmp    770 <printf+0x60>
 737:	89 f6                	mov    %esi,%esi
 739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 740:	83 f8 25             	cmp    $0x25,%eax
 743:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 746:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 74b:	74 18                	je     765 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 74d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 750:	83 ec 04             	sub    $0x4,%esp
 753:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 756:	6a 01                	push   $0x1
 758:	50                   	push   %eax
 759:	57                   	push   %edi
 75a:	e8 83 fe ff ff       	call   5e2 <write>
 75f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 762:	83 c4 10             	add    $0x10,%esp
 765:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 768:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 76c:	84 db                	test   %bl,%bl
 76e:	74 73                	je     7e3 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 770:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 772:	0f be cb             	movsbl %bl,%ecx
 775:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 778:	74 c6                	je     740 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 77a:	83 fa 25             	cmp    $0x25,%edx
 77d:	75 e6                	jne    765 <printf+0x55>
      if(c == 'd'){
 77f:	83 f8 64             	cmp    $0x64,%eax
 782:	0f 84 f8 00 00 00    	je     880 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 788:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 78e:	83 f9 70             	cmp    $0x70,%ecx
 791:	74 5d                	je     7f0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 793:	83 f8 73             	cmp    $0x73,%eax
 796:	0f 84 84 00 00 00    	je     820 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 79c:	83 f8 63             	cmp    $0x63,%eax
 79f:	0f 84 ea 00 00 00    	je     88f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 7a5:	83 f8 25             	cmp    $0x25,%eax
 7a8:	0f 84 c2 00 00 00    	je     870 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7ae:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7b1:	83 ec 04             	sub    $0x4,%esp
 7b4:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7b8:	6a 01                	push   $0x1
 7ba:	50                   	push   %eax
 7bb:	57                   	push   %edi
 7bc:	e8 21 fe ff ff       	call   5e2 <write>
 7c1:	83 c4 0c             	add    $0xc,%esp
 7c4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 7c7:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 7ca:	6a 01                	push   $0x1
 7cc:	50                   	push   %eax
 7cd:	57                   	push   %edi
 7ce:	83 c6 01             	add    $0x1,%esi
 7d1:	e8 0c fe ff ff       	call   5e2 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7d6:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7da:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7dd:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7df:	84 db                	test   %bl,%bl
 7e1:	75 8d                	jne    770 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7e6:	5b                   	pop    %ebx
 7e7:	5e                   	pop    %esi
 7e8:	5f                   	pop    %edi
 7e9:	5d                   	pop    %ebp
 7ea:	c3                   	ret    
 7eb:	90                   	nop
 7ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 7f0:	83 ec 0c             	sub    $0xc,%esp
 7f3:	b9 10 00 00 00       	mov    $0x10,%ecx
 7f8:	6a 00                	push   $0x0
 7fa:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 7fd:	89 f8                	mov    %edi,%eax
 7ff:	8b 13                	mov    (%ebx),%edx
 801:	e8 6a fe ff ff       	call   670 <printint>
        ap++;
 806:	89 d8                	mov    %ebx,%eax
 808:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 80b:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 80d:	83 c0 04             	add    $0x4,%eax
 810:	89 45 d0             	mov    %eax,-0x30(%ebp)
 813:	e9 4d ff ff ff       	jmp    765 <printf+0x55>
 818:	90                   	nop
 819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 820:	8b 45 d0             	mov    -0x30(%ebp),%eax
 823:	8b 18                	mov    (%eax),%ebx
        ap++;
 825:	83 c0 04             	add    $0x4,%eax
 828:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 82b:	b8 8e 0a 00 00       	mov    $0xa8e,%eax
 830:	85 db                	test   %ebx,%ebx
 832:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 835:	0f b6 03             	movzbl (%ebx),%eax
 838:	84 c0                	test   %al,%al
 83a:	74 23                	je     85f <printf+0x14f>
 83c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 840:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 843:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 846:	83 ec 04             	sub    $0x4,%esp
 849:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 84b:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 84e:	50                   	push   %eax
 84f:	57                   	push   %edi
 850:	e8 8d fd ff ff       	call   5e2 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 855:	0f b6 03             	movzbl (%ebx),%eax
 858:	83 c4 10             	add    $0x10,%esp
 85b:	84 c0                	test   %al,%al
 85d:	75 e1                	jne    840 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 85f:	31 d2                	xor    %edx,%edx
 861:	e9 ff fe ff ff       	jmp    765 <printf+0x55>
 866:	8d 76 00             	lea    0x0(%esi),%esi
 869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 870:	83 ec 04             	sub    $0x4,%esp
 873:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 876:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 879:	6a 01                	push   $0x1
 87b:	e9 4c ff ff ff       	jmp    7cc <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 880:	83 ec 0c             	sub    $0xc,%esp
 883:	b9 0a 00 00 00       	mov    $0xa,%ecx
 888:	6a 01                	push   $0x1
 88a:	e9 6b ff ff ff       	jmp    7fa <printf+0xea>
 88f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 892:	83 ec 04             	sub    $0x4,%esp
 895:	8b 03                	mov    (%ebx),%eax
 897:	6a 01                	push   $0x1
 899:	88 45 e4             	mov    %al,-0x1c(%ebp)
 89c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 89f:	50                   	push   %eax
 8a0:	57                   	push   %edi
 8a1:	e8 3c fd ff ff       	call   5e2 <write>
 8a6:	e9 5b ff ff ff       	jmp    806 <printf+0xf6>
 8ab:	66 90                	xchg   %ax,%ax
 8ad:	66 90                	xchg   %ax,%ax
 8af:	90                   	nop

000008b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b1:	a1 b4 0d 00 00       	mov    0xdb4,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b6:	89 e5                	mov    %esp,%ebp
 8b8:	57                   	push   %edi
 8b9:	56                   	push   %esi
 8ba:	53                   	push   %ebx
 8bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8be:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8c0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c3:	39 c8                	cmp    %ecx,%eax
 8c5:	73 19                	jae    8e0 <free+0x30>
 8c7:	89 f6                	mov    %esi,%esi
 8c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 8d0:	39 d1                	cmp    %edx,%ecx
 8d2:	72 1c                	jb     8f0 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d4:	39 d0                	cmp    %edx,%eax
 8d6:	73 18                	jae    8f0 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 8d8:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8da:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8dc:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8de:	72 f0                	jb     8d0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e0:	39 d0                	cmp    %edx,%eax
 8e2:	72 f4                	jb     8d8 <free+0x28>
 8e4:	39 d1                	cmp    %edx,%ecx
 8e6:	73 f0                	jae    8d8 <free+0x28>
 8e8:	90                   	nop
 8e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 8f0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8f3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8f6:	39 d7                	cmp    %edx,%edi
 8f8:	74 19                	je     913 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 8fa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8fd:	8b 50 04             	mov    0x4(%eax),%edx
 900:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 903:	39 f1                	cmp    %esi,%ecx
 905:	74 23                	je     92a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 907:	89 08                	mov    %ecx,(%eax)
  freep = p;
 909:	a3 b4 0d 00 00       	mov    %eax,0xdb4
}
 90e:	5b                   	pop    %ebx
 90f:	5e                   	pop    %esi
 910:	5f                   	pop    %edi
 911:	5d                   	pop    %ebp
 912:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 913:	03 72 04             	add    0x4(%edx),%esi
 916:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 919:	8b 10                	mov    (%eax),%edx
 91b:	8b 12                	mov    (%edx),%edx
 91d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 920:	8b 50 04             	mov    0x4(%eax),%edx
 923:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 926:	39 f1                	cmp    %esi,%ecx
 928:	75 dd                	jne    907 <free+0x57>
    p->s.size += bp->s.size;
 92a:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 92d:	a3 b4 0d 00 00       	mov    %eax,0xdb4
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 932:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 935:	8b 53 f8             	mov    -0x8(%ebx),%edx
 938:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 93a:	5b                   	pop    %ebx
 93b:	5e                   	pop    %esi
 93c:	5f                   	pop    %edi
 93d:	5d                   	pop    %ebp
 93e:	c3                   	ret    
 93f:	90                   	nop

00000940 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 940:	55                   	push   %ebp
 941:	89 e5                	mov    %esp,%ebp
 943:	57                   	push   %edi
 944:	56                   	push   %esi
 945:	53                   	push   %ebx
 946:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 949:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 94c:	8b 15 b4 0d 00 00    	mov    0xdb4,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 952:	8d 78 07             	lea    0x7(%eax),%edi
 955:	c1 ef 03             	shr    $0x3,%edi
 958:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 95b:	85 d2                	test   %edx,%edx
 95d:	0f 84 a3 00 00 00    	je     a06 <malloc+0xc6>
 963:	8b 02                	mov    (%edx),%eax
 965:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 968:	39 cf                	cmp    %ecx,%edi
 96a:	76 74                	jbe    9e0 <malloc+0xa0>
 96c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 972:	be 00 10 00 00       	mov    $0x1000,%esi
 977:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 97e:	0f 43 f7             	cmovae %edi,%esi
 981:	ba 00 80 00 00       	mov    $0x8000,%edx
 986:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 98c:	0f 46 da             	cmovbe %edx,%ebx
 98f:	eb 10                	jmp    9a1 <malloc+0x61>
 991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 998:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 99a:	8b 48 04             	mov    0x4(%eax),%ecx
 99d:	39 cf                	cmp    %ecx,%edi
 99f:	76 3f                	jbe    9e0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9a1:	39 05 b4 0d 00 00    	cmp    %eax,0xdb4
 9a7:	89 c2                	mov    %eax,%edx
 9a9:	75 ed                	jne    998 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 9ab:	83 ec 0c             	sub    $0xc,%esp
 9ae:	53                   	push   %ebx
 9af:	e8 96 fc ff ff       	call   64a <sbrk>
  if(p == (char*)-1)
 9b4:	83 c4 10             	add    $0x10,%esp
 9b7:	83 f8 ff             	cmp    $0xffffffff,%eax
 9ba:	74 1c                	je     9d8 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 9bc:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 9bf:	83 ec 0c             	sub    $0xc,%esp
 9c2:	83 c0 08             	add    $0x8,%eax
 9c5:	50                   	push   %eax
 9c6:	e8 e5 fe ff ff       	call   8b0 <free>
  return freep;
 9cb:	8b 15 b4 0d 00 00    	mov    0xdb4,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 9d1:	83 c4 10             	add    $0x10,%esp
 9d4:	85 d2                	test   %edx,%edx
 9d6:	75 c0                	jne    998 <malloc+0x58>
        return 0;
 9d8:	31 c0                	xor    %eax,%eax
 9da:	eb 1c                	jmp    9f8 <malloc+0xb8>
 9dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 9e0:	39 cf                	cmp    %ecx,%edi
 9e2:	74 1c                	je     a00 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 9e4:	29 f9                	sub    %edi,%ecx
 9e6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 9e9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 9ec:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 9ef:	89 15 b4 0d 00 00    	mov    %edx,0xdb4
      return (void*)(p + 1);
 9f5:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 9fb:	5b                   	pop    %ebx
 9fc:	5e                   	pop    %esi
 9fd:	5f                   	pop    %edi
 9fe:	5d                   	pop    %ebp
 9ff:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 a00:	8b 08                	mov    (%eax),%ecx
 a02:	89 0a                	mov    %ecx,(%edx)
 a04:	eb e9                	jmp    9ef <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 a06:	c7 05 b4 0d 00 00 b8 	movl   $0xdb8,0xdb4
 a0d:	0d 00 00 
 a10:	c7 05 b8 0d 00 00 b8 	movl   $0xdb8,0xdb8
 a17:	0d 00 00 
    base.s.size = 0;
 a1a:	b8 b8 0d 00 00       	mov    $0xdb8,%eax
 a1f:	c7 05 bc 0d 00 00 00 	movl   $0x0,0xdbc
 a26:	00 00 00 
 a29:	e9 3e ff ff ff       	jmp    96c <malloc+0x2c>
