
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c0 2e 10 80       	mov    $0x80102ec0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 6f 10 80       	push   $0x80106fc0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 c5 41 00 00       	call   80104220 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 6f 10 80       	push   $0x80106fc7
80100097:	50                   	push   %eax
80100098:	e8 53 40 00 00       	call   801040f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 97 42 00 00       	call   80104380 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 c9 42 00 00       	call   80104430 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 3f 00 00       	call   80104130 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 cd 1f 00 00       	call   80102150 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ce 6f 10 80       	push   $0x80106fce
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 1d 40 00 00       	call   801041d0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 87 1f 00 00       	jmp    80102150 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 6f 10 80       	push   $0x80106fdf
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 dc 3f 00 00       	call   801041d0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 8c 3f 00 00       	call   80104190 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 70 41 00 00       	call   80104380 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 cf 41 00 00       	jmp    80104430 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 6f 10 80       	push   $0x80106fe6
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 eb 14 00 00       	call   80101770 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 ef 40 00 00       	call   80104380 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002a6:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 a5 10 80       	push   $0x8010a520
801002b8:	68 a0 ff 10 80       	push   $0x8010ffa0
801002bd:	e8 ce 3a 00 00       	call   80103d90 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 09 35 00 00       	call   801037e0 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 a5 10 80       	push   $0x8010a520
801002e6:	e8 45 41 00 00       	call   80104430 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 9d 13 00 00       	call   80101690 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 a5 10 80       	push   $0x8010a520
80100346:	e8 e5 40 00 00       	call   80104430 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 3d 13 00 00       	call   80101690 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 c2 23 00 00       	call   80102750 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 ed 6f 10 80       	push   $0x80106fed
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 3b 79 10 80 	movl   $0x8010793b,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 83 3e 00 00       	call   80104240 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 01 70 10 80       	push   $0x80107001
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 51 57 00 00       	call   80105b70 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 98 56 00 00       	call   80105b70 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 8c 56 00 00       	call   80105b70 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 80 56 00 00       	call   80105b70 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 17 40 00 00       	call   80104530 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 52 3f 00 00       	call   80104480 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 05 70 10 80       	push   $0x80107005
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 30 70 10 80 	movzbl -0x7fef8fd0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 5c 11 00 00       	call   80101770 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 60 3d 00 00       	call   80104380 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 e4 3d 00 00       	call   80104430 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 3b 10 00 00       	call   80101690 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 a5 10 80       	push   $0x8010a520
8010070d:	e8 1e 3d 00 00       	call   80104430 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 18 70 10 80       	mov    $0x80107018,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 a5 10 80       	push   $0x8010a520
801007c8:	e8 b3 3b 00 00       	call   80104380 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 1f 70 10 80       	push   $0x8010701f
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 a5 10 80       	push   $0x8010a520
80100803:	e8 78 3b 00 00       	call   80104380 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100836:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 a5 10 80       	push   $0x8010a520
80100868:	e8 c3 3b 00 00       	call   80104430 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008f1:	68 a0 ff 10 80       	push   $0x8010ffa0
801008f6:	e8 45 36 00 00       	call   80103f40 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010090d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100934:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 b4 36 00 00       	jmp    80104030 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 28 70 10 80       	push   $0x80107028
801009ab:	68 20 a5 10 80       	push   $0x8010a520
801009b0:	e8 6b 38 00 00       	call   80104220 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 22 19 00 00       	call   80102300 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009fc:	e8 df 2d 00 00       	call   801037e0 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a07:	e8 a4 21 00 00       	call   80102bb0 <begin_op>

  if((ip = namei(path)) == 0){
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 09 15 00 00       	call   80101f20 <namei>
80100a17:	83 c4 10             	add    $0x10,%esp
80100a1a:	85 c0                	test   %eax,%eax
80100a1c:	0f 84 9c 01 00 00    	je     80100bbe <exec+0x1ce>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a22:	83 ec 0c             	sub    $0xc,%esp
80100a25:	89 c3                	mov    %eax,%ebx
80100a27:	50                   	push   %eax
80100a28:	e8 63 0c 00 00       	call   80101690 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 72 0f 00 00       	call   801019b0 <readi>
80100a3e:	83 c4 20             	add    $0x20,%esp
80100a41:	83 f8 34             	cmp    $0x34,%eax
80100a44:	74 22                	je     80100a68 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	53                   	push   %ebx
80100a4a:	e8 d1 0e 00 00       	call   80101920 <iunlockput>
    end_op();
80100a4f:	e8 cc 21 00 00       	call   80102c20 <end_op>
80100a54:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a5f:	5b                   	pop    %ebx
80100a60:	5e                   	pop    %esi
80100a61:	5f                   	pop    %edi
80100a62:	5d                   	pop    %ebp
80100a63:	c3                   	ret    
80100a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a68:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a6f:	45 4c 46 
80100a72:	75 d2                	jne    80100a46 <exec+0x56>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a74:	e8 87 62 00 00       	call   80106d00 <setupkvm>
80100a79:	85 c0                	test   %eax,%eax
80100a7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a81:	74 c3                	je     80100a46 <exec+0x56>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a83:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a8a:	00 
80100a8b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a91:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a98:	00 00 00 
80100a9b:	0f 84 c5 00 00 00    	je     80100b66 <exec+0x176>
80100aa1:	31 ff                	xor    %edi,%edi
80100aa3:	eb 18                	jmp    80100abd <exec+0xcd>
80100aa5:	8d 76 00             	lea    0x0(%esi),%esi
80100aa8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100aaf:	83 c7 01             	add    $0x1,%edi
80100ab2:	83 c6 20             	add    $0x20,%esi
80100ab5:	39 f8                	cmp    %edi,%eax
80100ab7:	0f 8e a9 00 00 00    	jle    80100b66 <exec+0x176>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100abd:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ac3:	6a 20                	push   $0x20
80100ac5:	56                   	push   %esi
80100ac6:	50                   	push   %eax
80100ac7:	53                   	push   %ebx
80100ac8:	e8 e3 0e 00 00       	call   801019b0 <readi>
80100acd:	83 c4 10             	add    $0x10,%esp
80100ad0:	83 f8 20             	cmp    $0x20,%eax
80100ad3:	75 7b                	jne    80100b50 <exec+0x160>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ad5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100adc:	75 ca                	jne    80100aa8 <exec+0xb8>
      continue;
    if(ph.memsz < ph.filesz)
80100ade:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ae4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100aea:	72 64                	jb     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100aec:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100af2:	72 5c                	jb     80100b50 <exec+0x160>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100af4:	83 ec 04             	sub    $0x4,%esp
80100af7:	50                   	push   %eax
80100af8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100afe:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b04:	e8 47 60 00 00       	call   80106b50 <allocuvm>
80100b09:	83 c4 10             	add    $0x10,%esp
80100b0c:	85 c0                	test   %eax,%eax
80100b0e:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b14:	74 3a                	je     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b16:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b1c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b21:	75 2d                	jne    80100b50 <exec+0x160>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b23:	83 ec 0c             	sub    $0xc,%esp
80100b26:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b2c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b32:	53                   	push   %ebx
80100b33:	50                   	push   %eax
80100b34:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b3a:	e8 51 5f 00 00       	call   80106a90 <loaduvm>
80100b3f:	83 c4 20             	add    $0x20,%esp
80100b42:	85 c0                	test   %eax,%eax
80100b44:	0f 89 5e ff ff ff    	jns    80100aa8 <exec+0xb8>
80100b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b59:	e8 22 61 00 00       	call   80106c80 <freevm>
80100b5e:	83 c4 10             	add    $0x10,%esp
80100b61:	e9 e0 fe ff ff       	jmp    80100a46 <exec+0x56>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	53                   	push   %ebx
80100b6a:	e8 b1 0d 00 00       	call   80101920 <iunlockput>
  end_op();
80100b6f:	e8 ac 20 00 00       	call   80102c20 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b74:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b7a:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b7d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b87:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b8d:	52                   	push   %edx
80100b8e:	50                   	push   %eax
80100b8f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b95:	e8 b6 5f 00 00       	call   80106b50 <allocuvm>
80100b9a:	83 c4 10             	add    $0x10,%esp
80100b9d:	85 c0                	test   %eax,%eax
80100b9f:	89 c6                	mov    %eax,%esi
80100ba1:	75 3a                	jne    80100bdd <exec+0x1ed>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100ba3:	83 ec 0c             	sub    $0xc,%esp
80100ba6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bac:	e8 cf 60 00 00       	call   80106c80 <freevm>
80100bb1:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb9:	e9 9e fe ff ff       	jmp    80100a5c <exec+0x6c>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bbe:	e8 5d 20 00 00       	call   80102c20 <end_op>
    cprintf("exec: fail\n");
80100bc3:	83 ec 0c             	sub    $0xc,%esp
80100bc6:	68 41 70 10 80       	push   $0x80107041
80100bcb:	e8 90 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bd0:	83 c4 10             	add    $0x10,%esp
80100bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd8:	e9 7f fe ff ff       	jmp    80100a5c <exec+0x6c>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bdd:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100be3:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100be6:	31 ff                	xor    %edi,%edi
80100be8:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bea:	50                   	push   %eax
80100beb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bf1:	e8 aa 61 00 00       	call   80106da0 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bf9:	83 c4 10             	add    $0x10,%esp
80100bfc:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c02:	8b 00                	mov    (%eax),%eax
80100c04:	85 c0                	test   %eax,%eax
80100c06:	74 79                	je     80100c81 <exec+0x291>
80100c08:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c0e:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c14:	eb 13                	jmp    80100c29 <exec+0x239>
80100c16:	8d 76 00             	lea    0x0(%esi),%esi
80100c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(argc >= MAXARG)
80100c20:	83 ff 20             	cmp    $0x20,%edi
80100c23:	0f 84 7a ff ff ff    	je     80100ba3 <exec+0x1b3>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c29:	83 ec 0c             	sub    $0xc,%esp
80100c2c:	50                   	push   %eax
80100c2d:	e8 8e 3a 00 00       	call   801046c0 <strlen>
80100c32:	f7 d0                	not    %eax
80100c34:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c36:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c39:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c3a:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c3d:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c40:	e8 7b 3a 00 00       	call   801046c0 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 ba 62 00 00       	call   80106f10 <copyout>
80100c56:	83 c4 20             	add    $0x20,%esp
80100c59:	85 c0                	test   %eax,%eax
80100c5b:	0f 88 42 ff ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c61:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c64:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c6b:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c6e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c74:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c77:	85 c0                	test   %eax,%eax
80100c79:	75 a5                	jne    80100c20 <exec+0x230>
80100c7b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c81:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c88:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c8a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c91:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c95:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c9c:	ff ff ff 
  ustack[1] = argc;
80100c9f:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca5:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100ca7:	83 c0 0c             	add    $0xc,%eax
80100caa:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cac:	50                   	push   %eax
80100cad:	52                   	push   %edx
80100cae:	53                   	push   %ebx
80100caf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb5:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cbb:	e8 50 62 00 00       	call   80106f10 <copyout>
80100cc0:	83 c4 10             	add    $0x10,%esp
80100cc3:	85 c0                	test   %eax,%eax
80100cc5:	0f 88 d8 fe ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80100cce:	0f b6 10             	movzbl (%eax),%edx
80100cd1:	84 d2                	test   %dl,%dl
80100cd3:	74 19                	je     80100cee <exec+0x2fe>
80100cd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cd8:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cdb:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cde:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100ce1:	0f 44 c8             	cmove  %eax,%ecx
80100ce4:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ce7:	84 d2                	test   %dl,%dl
80100ce9:	75 f0                	jne    80100cdb <exec+0x2eb>
80100ceb:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cee:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cf4:	50                   	push   %eax
80100cf5:	6a 10                	push   $0x10
80100cf7:	ff 75 08             	pushl  0x8(%ebp)
80100cfa:	89 f8                	mov    %edi,%eax
80100cfc:	83 c0 6c             	add    $0x6c,%eax
80100cff:	50                   	push   %eax
80100d00:	e8 7b 39 00 00       	call   80104680 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d05:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100d0b:	89 f8                	mov    %edi,%eax
80100d0d:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
80100d10:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d12:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100d15:	89 c1                	mov    %eax,%ecx
80100d17:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d1d:	8b 40 18             	mov    0x18(%eax),%eax
80100d20:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d23:	8b 41 18             	mov    0x18(%ecx),%eax
80100d26:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d29:	89 0c 24             	mov    %ecx,(%esp)
80100d2c:	e8 cf 5b 00 00       	call   80106900 <switchuvm>
  freevm(oldpgdir);
80100d31:	89 3c 24             	mov    %edi,(%esp)
80100d34:	e8 47 5f 00 00       	call   80106c80 <freevm>
  return 0;
80100d39:	83 c4 10             	add    $0x10,%esp
80100d3c:	31 c0                	xor    %eax,%eax
80100d3e:	e9 19 fd ff ff       	jmp    80100a5c <exec+0x6c>
80100d43:	66 90                	xchg   %ax,%ax
80100d45:	66 90                	xchg   %ax,%ax
80100d47:	66 90                	xchg   %ax,%ax
80100d49:	66 90                	xchg   %ax,%ax
80100d4b:	66 90                	xchg   %ax,%ax
80100d4d:	66 90                	xchg   %ax,%ax
80100d4f:	90                   	nop

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	68 4d 70 10 80       	push   $0x8010704d
80100d5b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d60:	e8 bb 34 00 00       	call   80104220 <initlock>
}
80100d65:	83 c4 10             	add    $0x10,%esp
80100d68:	c9                   	leave  
80100d69:	c3                   	ret    
80100d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d79:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d7c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d81:	e8 fa 35 00 00       	call   80104380 <acquire>
80100d86:	83 c4 10             	add    $0x10,%esp
80100d89:	eb 10                	jmp    80100d9b <filealloc+0x2b>
80100d8b:	90                   	nop
80100d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100da5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dac:	68 c0 ff 10 80       	push   $0x8010ffc0
80100db1:	e8 7a 36 00 00       	call   80104430 <release>
      return f;
80100db6:	89 d8                	mov    %ebx,%eax
80100db8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dbe:	c9                   	leave  
80100dbf:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dc0:	83 ec 0c             	sub    $0xc,%esp
80100dc3:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dc8:	e8 63 36 00 00       	call   80104430 <release>
  return 0;
80100dcd:	83 c4 10             	add    $0x10,%esp
80100dd0:	31 c0                	xor    %eax,%eax
}
80100dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dd5:	c9                   	leave  
80100dd6:	c3                   	ret    
80100dd7:	89 f6                	mov    %esi,%esi
80100dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 10             	sub    $0x10,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	68 c0 ff 10 80       	push   $0x8010ffc0
80100def:	e8 8c 35 00 00       	call   80104380 <acquire>
  if(f->ref < 1)
80100df4:	8b 43 04             	mov    0x4(%ebx),%eax
80100df7:	83 c4 10             	add    $0x10,%esp
80100dfa:	85 c0                	test   %eax,%eax
80100dfc:	7e 1a                	jle    80100e18 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dfe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e01:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100e04:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e07:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e0c:	e8 1f 36 00 00       	call   80104430 <release>
  return f;
}
80100e11:	89 d8                	mov    %ebx,%eax
80100e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e16:	c9                   	leave  
80100e17:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e18:	83 ec 0c             	sub    $0xc,%esp
80100e1b:	68 54 70 10 80       	push   $0x80107054
80100e20:	e8 4b f5 ff ff       	call   80100370 <panic>
80100e25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 28             	sub    $0x28,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e41:	e8 3a 35 00 00       	call   80104380 <acquire>
  if(f->ref < 1)
80100e46:	8b 47 04             	mov    0x4(%edi),%eax
80100e49:	83 c4 10             	add    $0x10,%esp
80100e4c:	85 c0                	test   %eax,%eax
80100e4e:	0f 8e 9b 00 00 00    	jle    80100eef <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e54:	83 e8 01             	sub    $0x1,%eax
80100e57:	85 c0                	test   %eax,%eax
80100e59:	89 47 04             	mov    %eax,0x4(%edi)
80100e5c:	74 1a                	je     80100e78 <fileclose+0x48>
    release(&ftable.lock);
80100e5e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e68:	5b                   	pop    %ebx
80100e69:	5e                   	pop    %esi
80100e6a:	5f                   	pop    %edi
80100e6b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e6c:	e9 bf 35 00 00       	jmp    80104430 <release>
80100e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e78:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e7c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e7e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e81:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e84:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e8d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e90:	68 c0 ff 10 80       	push   $0x8010ffc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e95:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e98:	e8 93 35 00 00       	call   80104430 <release>

  if(ff.type == FD_PIPE)
80100e9d:	83 c4 10             	add    $0x10,%esp
80100ea0:	83 fb 01             	cmp    $0x1,%ebx
80100ea3:	74 13                	je     80100eb8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ea5:	83 fb 02             	cmp    $0x2,%ebx
80100ea8:	74 26                	je     80100ed0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ead:	5b                   	pop    %ebx
80100eae:	5e                   	pop    %esi
80100eaf:	5f                   	pop    %edi
80100eb0:	5d                   	pop    %ebp
80100eb1:	c3                   	ret    
80100eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100eb8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ebc:	83 ec 08             	sub    $0x8,%esp
80100ebf:	53                   	push   %ebx
80100ec0:	56                   	push   %esi
80100ec1:	e8 8a 24 00 00       	call   80103350 <pipeclose>
80100ec6:	83 c4 10             	add    $0x10,%esp
80100ec9:	eb df                	jmp    80100eaa <fileclose+0x7a>
80100ecb:	90                   	nop
80100ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ed0:	e8 db 1c 00 00       	call   80102bb0 <begin_op>
    iput(ff.ip);
80100ed5:	83 ec 0c             	sub    $0xc,%esp
80100ed8:	ff 75 e0             	pushl  -0x20(%ebp)
80100edb:	e8 e0 08 00 00       	call   801017c0 <iput>
    end_op();
80100ee0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ee6:	5b                   	pop    %ebx
80100ee7:	5e                   	pop    %esi
80100ee8:	5f                   	pop    %edi
80100ee9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eea:	e9 31 1d 00 00       	jmp    80102c20 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100eef:	83 ec 0c             	sub    $0xc,%esp
80100ef2:	68 5c 70 10 80       	push   $0x8010705c
80100ef7:	e8 74 f4 ff ff       	call   80100370 <panic>
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 04             	sub    $0x4,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f0a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f0d:	75 31                	jne    80100f40 <filestat+0x40>
    ilock(f->ip);
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	ff 73 10             	pushl  0x10(%ebx)
80100f15:	e8 76 07 00 00       	call   80101690 <ilock>
    stati(f->ip, st);
80100f1a:	58                   	pop    %eax
80100f1b:	5a                   	pop    %edx
80100f1c:	ff 75 0c             	pushl  0xc(%ebp)
80100f1f:	ff 73 10             	pushl  0x10(%ebx)
80100f22:	e8 19 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f27:	59                   	pop    %ecx
80100f28:	ff 73 10             	pushl  0x10(%ebx)
80100f2b:	e8 40 08 00 00       	call   80101770 <iunlock>
    return 0;
80100f30:	83 c4 10             	add    $0x10,%esp
80100f33:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f38:	c9                   	leave  
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f50 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 0c             	sub    $0xc,%esp
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f62:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f66:	74 60                	je     80100fc8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f68:	8b 03                	mov    (%ebx),%eax
80100f6a:	83 f8 01             	cmp    $0x1,%eax
80100f6d:	74 41                	je     80100fb0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f6f:	83 f8 02             	cmp    $0x2,%eax
80100f72:	75 5b                	jne    80100fcf <fileread+0x7f>
    ilock(f->ip);
80100f74:	83 ec 0c             	sub    $0xc,%esp
80100f77:	ff 73 10             	pushl  0x10(%ebx)
80100f7a:	e8 11 07 00 00       	call   80101690 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7f:	57                   	push   %edi
80100f80:	ff 73 14             	pushl  0x14(%ebx)
80100f83:	56                   	push   %esi
80100f84:	ff 73 10             	pushl  0x10(%ebx)
80100f87:	e8 24 0a 00 00       	call   801019b0 <readi>
80100f8c:	83 c4 20             	add    $0x20,%esp
80100f8f:	85 c0                	test   %eax,%eax
80100f91:	89 c6                	mov    %eax,%esi
80100f93:	7e 03                	jle    80100f98 <fileread+0x48>
      f->off += r;
80100f95:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f98:	83 ec 0c             	sub    $0xc,%esp
80100f9b:	ff 73 10             	pushl  0x10(%ebx)
80100f9e:	e8 cd 07 00 00       	call   80101770 <iunlock>
    return r;
80100fa3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fa6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fab:	5b                   	pop    %ebx
80100fac:	5e                   	pop    %esi
80100fad:	5f                   	pop    %edi
80100fae:	5d                   	pop    %ebp
80100faf:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fb0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fb3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	5b                   	pop    %ebx
80100fba:	5e                   	pop    %esi
80100fbb:	5f                   	pop    %edi
80100fbc:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fbd:	e9 2e 25 00 00       	jmp    801034f0 <piperead>
80100fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fcd:	eb d9                	jmp    80100fa8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	68 66 70 10 80       	push   $0x80107066
80100fd7:	e8 94 f3 ff ff       	call   80100370 <panic>
80100fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 1c             	sub    $0x1c,%esp
80100fe9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fef:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff6:	8b 45 10             	mov    0x10(%ebp),%eax
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ffc:	0f 84 aa 00 00 00    	je     801010ac <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 06                	mov    (%esi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d8 00 00 00    	jne    801010ee <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 ff                	xor    %edi,%edi
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 34                	jg     80101053 <filewrite+0x73>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101028:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010102b:	83 ec 0c             	sub    $0xc,%esp
8010102e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101031:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101034:	e8 37 07 00 00       	call   80101770 <iunlock>
      end_op();
80101039:	e8 e2 1b 00 00       	call   80102c20 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101041:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101044:	39 d8                	cmp    %ebx,%eax
80101046:	0f 85 95 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010104c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010104e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101051:	7e 6d                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101053:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101056:	b8 00 06 00 00       	mov    $0x600,%eax
8010105b:	29 fb                	sub    %edi,%ebx
8010105d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101063:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101066:	e8 45 1b 00 00       	call   80102bb0 <begin_op>
      ilock(f->ip);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	ff 76 10             	pushl  0x10(%esi)
80101071:	e8 1a 06 00 00       	call   80101690 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101076:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101079:	53                   	push   %ebx
8010107a:	ff 76 14             	pushl  0x14(%esi)
8010107d:	01 f8                	add    %edi,%eax
8010107f:	50                   	push   %eax
80101080:	ff 76 10             	pushl  0x10(%esi)
80101083:	e8 28 0a 00 00       	call   80101ab0 <writei>
80101088:	83 c4 20             	add    $0x20,%esp
8010108b:	85 c0                	test   %eax,%eax
8010108d:	7f 99                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	ff 76 10             	pushl  0x10(%esi)
80101095:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101098:	e8 d3 06 00 00       	call   80101770 <iunlock>
      end_op();
8010109d:	e8 7e 1b 00 00       	call   80102c20 <end_op>

      if(r < 0)
801010a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010a5:	83 c4 10             	add    $0x10,%esp
801010a8:	85 c0                	test   %eax,%eax
801010aa:	74 98                	je     80101044 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801010b4:	5b                   	pop    %ebx
801010b5:	5e                   	pop    %esi
801010b6:	5f                   	pop    %edi
801010b7:	5d                   	pop    %ebp
801010b8:	c3                   	ret    
801010b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010c0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010c3:	75 e7                	jne    801010ac <filewrite+0xcc>
  }
  panic("filewrite");
}
801010c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c8:	89 f8                	mov    %edi,%eax
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 46 0c             	mov    0xc(%esi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 0f 23 00 00       	jmp    801033f0 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	83 ec 0c             	sub    $0xc,%esp
801010e4:	68 6f 70 10 80       	push   $0x8010706f
801010e9:	e8 82 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ee:	83 ec 0c             	sub    $0xc,%esp
801010f1:	68 75 70 10 80       	push   $0x80107075
801010f6:	e8 75 f2 ff ff       	call   80100370 <panic>
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	56                   	push   %esi
80101104:	53                   	push   %ebx
80101105:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101107:	c1 ea 0c             	shr    $0xc,%edx
8010110a:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101110:	83 ec 08             	sub    $0x8,%esp
80101113:	52                   	push   %edx
80101114:	50                   	push   %eax
80101115:	e8 b6 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010111a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010111c:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101122:	ba 01 00 00 00       	mov    $0x1,%edx
80101127:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010112a:	c1 fb 03             	sar    $0x3,%ebx
8010112d:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101130:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101132:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101137:	85 d1                	test   %edx,%ecx
80101139:	74 27                	je     80101162 <bfree+0x62>
8010113b:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010113d:	f7 d2                	not    %edx
8010113f:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101141:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101144:	21 d0                	and    %edx,%eax
80101146:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010114a:	56                   	push   %esi
8010114b:	e8 40 1c 00 00       	call   80102d90 <log_write>
  brelse(bp);
80101150:	89 34 24             	mov    %esi,(%esp)
80101153:	e8 88 f0 ff ff       	call   801001e0 <brelse>
}
80101158:	83 c4 10             	add    $0x10,%esp
8010115b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010115e:	5b                   	pop    %ebx
8010115f:	5e                   	pop    %esi
80101160:	5d                   	pop    %ebp
80101161:	c3                   	ret    

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101162:	83 ec 0c             	sub    $0xc,%esp
80101165:	68 7f 70 10 80       	push   $0x8010707f
8010116a:	e8 01 f2 ff ff       	call   80100370 <panic>
8010116f:	90                   	nop

80101170 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101170:	55                   	push   %ebp
80101171:	89 e5                	mov    %esp,%ebp
80101173:	57                   	push   %edi
80101174:	56                   	push   %esi
80101175:	53                   	push   %ebx
80101176:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101179:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010117f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101182:	85 c9                	test   %ecx,%ecx
80101184:	0f 84 85 00 00 00    	je     8010120f <balloc+0x9f>
8010118a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101191:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101194:	83 ec 08             	sub    $0x8,%esp
80101197:	89 f0                	mov    %esi,%eax
80101199:	c1 f8 0c             	sar    $0xc,%eax
8010119c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011a2:	50                   	push   %eax
801011a3:	ff 75 d8             	pushl  -0x28(%ebp)
801011a6:	e8 25 ef ff ff       	call   801000d0 <bread>
801011ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011ae:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011b3:	83 c4 10             	add    $0x10,%esp
801011b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011b9:	31 c0                	xor    %eax,%eax
801011bb:	eb 2d                	jmp    801011ea <balloc+0x7a>
801011bd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011c0:	89 c1                	mov    %eax,%ecx
801011c2:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011c7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801011ca:	83 e1 07             	and    $0x7,%ecx
801011cd:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011cf:	89 c1                	mov    %eax,%ecx
801011d1:	c1 f9 03             	sar    $0x3,%ecx
801011d4:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
801011d9:	85 d7                	test   %edx,%edi
801011db:	74 43                	je     80101220 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011dd:	83 c0 01             	add    $0x1,%eax
801011e0:	83 c6 01             	add    $0x1,%esi
801011e3:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011e8:	74 05                	je     801011ef <balloc+0x7f>
801011ea:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801011ed:	72 d1                	jb     801011c0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011ef:	83 ec 0c             	sub    $0xc,%esp
801011f2:	ff 75 e4             	pushl  -0x1c(%ebp)
801011f5:	e8 e6 ef ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011fa:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101201:	83 c4 10             	add    $0x10,%esp
80101204:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101207:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010120d:	77 82                	ja     80101191 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010120f:	83 ec 0c             	sub    $0xc,%esp
80101212:	68 92 70 10 80       	push   $0x80107092
80101217:	e8 54 f1 ff ff       	call   80100370 <panic>
8010121c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101220:	09 fa                	or     %edi,%edx
80101222:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101225:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101228:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010122c:	57                   	push   %edi
8010122d:	e8 5e 1b 00 00       	call   80102d90 <log_write>
        brelse(bp);
80101232:	89 3c 24             	mov    %edi,(%esp)
80101235:	e8 a6 ef ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
8010123a:	58                   	pop    %eax
8010123b:	5a                   	pop    %edx
8010123c:	56                   	push   %esi
8010123d:	ff 75 d8             	pushl  -0x28(%ebp)
80101240:	e8 8b ee ff ff       	call   801000d0 <bread>
80101245:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101247:	8d 40 5c             	lea    0x5c(%eax),%eax
8010124a:	83 c4 0c             	add    $0xc,%esp
8010124d:	68 00 02 00 00       	push   $0x200
80101252:	6a 00                	push   $0x0
80101254:	50                   	push   %eax
80101255:	e8 26 32 00 00       	call   80104480 <memset>
  log_write(bp);
8010125a:	89 1c 24             	mov    %ebx,(%esp)
8010125d:	e8 2e 1b 00 00       	call   80102d90 <log_write>
  brelse(bp);
80101262:	89 1c 24             	mov    %ebx,(%esp)
80101265:	e8 76 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010126a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010126d:	89 f0                	mov    %esi,%eax
8010126f:	5b                   	pop    %ebx
80101270:	5e                   	pop    %esi
80101271:	5f                   	pop    %edi
80101272:	5d                   	pop    %ebp
80101273:	c3                   	ret    
80101274:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010127a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101280 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101280:	55                   	push   %ebp
80101281:	89 e5                	mov    %esp,%ebp
80101283:	57                   	push   %edi
80101284:	56                   	push   %esi
80101285:	53                   	push   %ebx
80101286:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101288:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010128f:	83 ec 28             	sub    $0x28,%esp
80101292:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101295:	68 e0 09 11 80       	push   $0x801109e0
8010129a:	e8 e1 30 00 00       	call   80104380 <acquire>
8010129f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012a5:	eb 1b                	jmp    801012c2 <iget+0x42>
801012a7:	89 f6                	mov    %esi,%esi
801012a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012b0:	85 f6                	test   %esi,%esi
801012b2:	74 44                	je     801012f8 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b4:	81 c3 d0 00 00 00    	add    $0xd0,%ebx
801012ba:	81 fb b4 32 11 80    	cmp    $0x801132b4,%ebx
801012c0:	74 4e                	je     80101310 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012c2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012c5:	85 c9                	test   %ecx,%ecx
801012c7:	7e e7                	jle    801012b0 <iget+0x30>
801012c9:	39 3b                	cmp    %edi,(%ebx)
801012cb:	75 e3                	jne    801012b0 <iget+0x30>
801012cd:	39 53 04             	cmp    %edx,0x4(%ebx)
801012d0:	75 de                	jne    801012b0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
801012d2:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012d5:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
801012d8:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
801012da:	68 e0 09 11 80       	push   $0x801109e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012df:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012e2:	e8 49 31 00 00       	call   80104430 <release>
      return ip;
801012e7:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
801012ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ed:	89 f0                	mov    %esi,%eax
801012ef:	5b                   	pop    %ebx
801012f0:	5e                   	pop    %esi
801012f1:	5f                   	pop    %edi
801012f2:	5d                   	pop    %ebp
801012f3:	c3                   	ret    
801012f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012f8:	85 c9                	test   %ecx,%ecx
801012fa:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fd:	81 c3 d0 00 00 00    	add    $0xd0,%ebx
80101303:	81 fb b4 32 11 80    	cmp    $0x801132b4,%ebx
80101309:	75 b7                	jne    801012c2 <iget+0x42>
8010130b:	90                   	nop
8010130c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101310:	85 f6                	test   %esi,%esi
80101312:	74 2d                	je     80101341 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101314:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101317:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101319:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010131c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101323:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010132a:	68 e0 09 11 80       	push   $0x801109e0
8010132f:	e8 fc 30 00 00       	call   80104430 <release>

  return ip;
80101334:	83 c4 10             	add    $0x10,%esp
}
80101337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133a:	89 f0                	mov    %esi,%eax
8010133c:	5b                   	pop    %ebx
8010133d:	5e                   	pop    %esi
8010133e:	5f                   	pop    %edi
8010133f:	5d                   	pop    %ebp
80101340:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
80101341:	83 ec 0c             	sub    $0xc,%esp
80101344:	68 a8 70 10 80       	push   $0x801070a8
80101349:	e8 22 f0 ff ff       	call   80100370 <panic>
8010134e:	66 90                	xchg   %ax,%ax

80101350 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	56                   	push   %esi
80101355:	53                   	push   %ebx
80101356:	89 c6                	mov    %eax,%esi
80101358:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010135b:	83 fa 15             	cmp    $0x15,%edx
8010135e:	77 18                	ja     80101378 <bmap+0x28>
80101360:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
80101363:	8b 43 5c             	mov    0x5c(%ebx),%eax
80101366:	85 c0                	test   %eax,%eax
80101368:	74 76                	je     801013e0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010136a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010136d:	5b                   	pop    %ebx
8010136e:	5e                   	pop    %esi
8010136f:	5f                   	pop    %edi
80101370:	5d                   	pop    %ebp
80101371:	c3                   	ret    
80101372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101378:	8d 5a ea             	lea    -0x16(%edx),%ebx

  if(bn < NINDIRECT){
8010137b:	83 fb 7f             	cmp    $0x7f,%ebx
8010137e:	0f 87 83 00 00 00    	ja     80101407 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101384:	8b 80 b4 00 00 00    	mov    0xb4(%eax),%eax
8010138a:	85 c0                	test   %eax,%eax
8010138c:	74 6a                	je     801013f8 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010138e:	83 ec 08             	sub    $0x8,%esp
80101391:	50                   	push   %eax
80101392:	ff 36                	pushl  (%esi)
80101394:	e8 37 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101399:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010139d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013a0:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013a2:	8b 1a                	mov    (%edx),%ebx
801013a4:	85 db                	test   %ebx,%ebx
801013a6:	75 1d                	jne    801013c5 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
801013a8:	8b 06                	mov    (%esi),%eax
801013aa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013ad:	e8 be fd ff ff       	call   80101170 <balloc>
801013b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013b5:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
801013b8:	89 c3                	mov    %eax,%ebx
801013ba:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013bc:	57                   	push   %edi
801013bd:	e8 ce 19 00 00       	call   80102d90 <log_write>
801013c2:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
801013c5:	83 ec 0c             	sub    $0xc,%esp
801013c8:	57                   	push   %edi
801013c9:	e8 12 ee ff ff       	call   801001e0 <brelse>
801013ce:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801013d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013d4:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
801013d6:	5b                   	pop    %ebx
801013d7:	5e                   	pop    %esi
801013d8:	5f                   	pop    %edi
801013d9:	5d                   	pop    %ebp
801013da:	c3                   	ret    
801013db:	90                   	nop
801013dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
801013e0:	8b 06                	mov    (%esi),%eax
801013e2:	e8 89 fd ff ff       	call   80101170 <balloc>
801013e7:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ed:	5b                   	pop    %ebx
801013ee:	5e                   	pop    %esi
801013ef:	5f                   	pop    %edi
801013f0:	5d                   	pop    %ebp
801013f1:	c3                   	ret    
801013f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013f8:	8b 06                	mov    (%esi),%eax
801013fa:	e8 71 fd ff ff       	call   80101170 <balloc>
801013ff:	89 86 b4 00 00 00    	mov    %eax,0xb4(%esi)
80101405:	eb 87                	jmp    8010138e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101407:	83 ec 0c             	sub    $0xc,%esp
8010140a:	68 b8 70 10 80       	push   $0x801070b8
8010140f:	e8 5c ef ff ff       	call   80100370 <panic>
80101414:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010141a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101420 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	56                   	push   %esi
80101424:	53                   	push   %ebx
80101425:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101428:	83 ec 08             	sub    $0x8,%esp
8010142b:	6a 01                	push   $0x1
8010142d:	ff 75 08             	pushl  0x8(%ebp)
80101430:	e8 9b ec ff ff       	call   801000d0 <bread>
80101435:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101437:	8d 40 5c             	lea    0x5c(%eax),%eax
8010143a:	83 c4 0c             	add    $0xc,%esp
8010143d:	6a 1c                	push   $0x1c
8010143f:	50                   	push   %eax
80101440:	56                   	push   %esi
80101441:	e8 ea 30 00 00       	call   80104530 <memmove>
  brelse(bp);
80101446:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101449:	83 c4 10             	add    $0x10,%esp
}
8010144c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010144f:	5b                   	pop    %ebx
80101450:	5e                   	pop    %esi
80101451:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101452:	e9 89 ed ff ff       	jmp    801001e0 <brelse>
80101457:	89 f6                	mov    %esi,%esi
80101459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101460 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	53                   	push   %ebx
80101464:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101469:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010146c:	68 cb 70 10 80       	push   $0x801070cb
80101471:	68 e0 09 11 80       	push   $0x801109e0
80101476:	e8 a5 2d 00 00       	call   80104220 <initlock>
8010147b:	83 c4 10             	add    $0x10,%esp
8010147e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101480:	83 ec 08             	sub    $0x8,%esp
80101483:	68 d2 70 10 80       	push   $0x801070d2
80101488:	53                   	push   %ebx
80101489:	81 c3 d0 00 00 00    	add    $0xd0,%ebx
8010148f:	e8 5c 2c 00 00       	call   801040f0 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101494:	83 c4 10             	add    $0x10,%esp
80101497:	81 fb c0 32 11 80    	cmp    $0x801132c0,%ebx
8010149d:	75 e1                	jne    80101480 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010149f:	83 ec 08             	sub    $0x8,%esp
801014a2:	68 c0 09 11 80       	push   $0x801109c0
801014a7:	ff 75 08             	pushl  0x8(%ebp)
801014aa:	e8 71 ff ff ff       	call   80101420 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014af:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014b5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014bb:	ff 35 d0 09 11 80    	pushl  0x801109d0
801014c1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801014c7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801014cd:	ff 35 c4 09 11 80    	pushl  0x801109c4
801014d3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801014d9:	68 38 71 10 80       	push   $0x80107138
801014de:	e8 7d f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801014e3:	83 c4 30             	add    $0x30,%esp
801014e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014e9:	c9                   	leave  
801014ea:	c3                   	ret    
801014eb:	90                   	nop
801014ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014f0 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801014f0:	55                   	push   %ebp
801014f1:	89 e5                	mov    %esp,%ebp
801014f3:	57                   	push   %edi
801014f4:	56                   	push   %esi
801014f5:	53                   	push   %ebx
801014f6:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014f9:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101500:	8b 45 0c             	mov    0xc(%ebp),%eax
80101503:	8b 75 08             	mov    0x8(%ebp),%esi
80101506:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101509:	0f 86 94 00 00 00    	jbe    801015a3 <ialloc+0xb3>
8010150f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101514:	eb 21                	jmp    80101537 <ialloc+0x47>
80101516:	8d 76 00             	lea    0x0(%esi),%esi
80101519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101520:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101523:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101526:	57                   	push   %edi
80101527:	e8 b4 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010152c:	83 c4 10             	add    $0x10,%esp
8010152f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101535:	76 6c                	jbe    801015a3 <ialloc+0xb3>
    bp = bread(dev, IBLOCK(inum, sb));
80101537:	89 d8                	mov    %ebx,%eax
80101539:	83 ec 08             	sub    $0x8,%esp
8010153c:	c1 e8 02             	shr    $0x2,%eax
8010153f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101545:	50                   	push   %eax
80101546:	56                   	push   %esi
80101547:	e8 84 eb ff ff       	call   801000d0 <bread>
8010154c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010154e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101550:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101553:	83 e0 03             	and    $0x3,%eax
80101556:	c1 e0 07             	shl    $0x7,%eax
80101559:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010155d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101561:	75 bd                	jne    80101520 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101563:	83 ec 04             	sub    $0x4,%esp
80101566:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101569:	68 80 00 00 00       	push   $0x80
8010156e:	6a 00                	push   $0x0
80101570:	51                   	push   %ecx
80101571:	e8 0a 2f 00 00       	call   80104480 <memset>
      dip->type = type;
80101576:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
8010157a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010157d:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101580:	89 3c 24             	mov    %edi,(%esp)
80101583:	e8 08 18 00 00       	call   80102d90 <log_write>
      brelse(bp);
80101588:	89 3c 24             	mov    %edi,(%esp)
8010158b:	e8 50 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
80101590:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101593:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101596:	89 da                	mov    %ebx,%edx
80101598:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
8010159a:	5b                   	pop    %ebx
8010159b:	5e                   	pop    %esi
8010159c:	5f                   	pop    %edi
8010159d:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010159e:	e9 dd fc ff ff       	jmp    80101280 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015a3:	83 ec 0c             	sub    $0xc,%esp
801015a6:	68 d8 70 10 80       	push   $0x801070d8
801015ab:	e8 c0 ed ff ff       	call   80100370 <panic>

801015b0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	56                   	push   %esi
801015b4:	53                   	push   %ebx
801015b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015b8:	83 ec 08             	sub    $0x8,%esp
801015bb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->minute = ip->minute;
  dip->hour = ip->hour;
  dip->day = ip->day;
  dip->month = ip->month;
  dip->year = ip->year;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015be:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015c1:	c1 e8 02             	shr    $0x2,%eax
801015c4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015ca:	50                   	push   %eax
801015cb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ce:	e8 fd ea ff ff       	call   801000d0 <bread>
801015d3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015d5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015d8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->minute = ip->minute;
  dip->hour = ip->hour;
  dip->day = ip->day;
  dip->month = ip->month;
  dip->year = ip->year;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015dc:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015df:	83 e0 03             	and    $0x3,%eax
801015e2:	c1 e0 07             	shl    $0x7,%eax
801015e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015e9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015ec:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minute = ip->minute;
  dip->hour = ip->hour;
  dip->day = ip->day;
  dip->month = ip->month;
  dip->year = ip->year;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015f0:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
801015f3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801015f7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801015fb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801015ff:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101603:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101607:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010160a:	89 50 fc             	mov    %edx,-0x4(%eax)
  dip->second = ip->second;
8010160d:	8b 53 5c             	mov    0x5c(%ebx),%edx
80101610:	89 50 5c             	mov    %edx,0x5c(%eax)
  dip->minute = ip->minute;
80101613:	8b 53 60             	mov    0x60(%ebx),%edx
80101616:	89 50 60             	mov    %edx,0x60(%eax)
  dip->hour = ip->hour;
80101619:	8b 53 64             	mov    0x64(%ebx),%edx
8010161c:	89 50 64             	mov    %edx,0x64(%eax)
  dip->day = ip->day;
8010161f:	8b 53 68             	mov    0x68(%ebx),%edx
80101622:	89 50 68             	mov    %edx,0x68(%eax)
  dip->month = ip->month;
80101625:	8b 53 6c             	mov    0x6c(%ebx),%edx
80101628:	89 50 6c             	mov    %edx,0x6c(%eax)
  dip->year = ip->year;
8010162b:	8b 53 70             	mov    0x70(%ebx),%edx
8010162e:	89 50 70             	mov    %edx,0x70(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101631:	6a 5c                	push   $0x5c
80101633:	53                   	push   %ebx
80101634:	50                   	push   %eax
80101635:	e8 f6 2e 00 00       	call   80104530 <memmove>
  log_write(bp);
8010163a:	89 34 24             	mov    %esi,(%esp)
8010163d:	e8 4e 17 00 00       	call   80102d90 <log_write>
  brelse(bp);
80101642:	89 75 08             	mov    %esi,0x8(%ebp)
80101645:	83 c4 10             	add    $0x10,%esp
}
80101648:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010164b:	5b                   	pop    %ebx
8010164c:	5e                   	pop    %esi
8010164d:	5d                   	pop    %ebp
  dip->day = ip->day;
  dip->month = ip->month;
  dip->year = ip->year;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010164e:	e9 8d eb ff ff       	jmp    801001e0 <brelse>
80101653:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101660 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	53                   	push   %ebx
80101664:	83 ec 10             	sub    $0x10,%esp
80101667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010166a:	68 e0 09 11 80       	push   $0x801109e0
8010166f:	e8 0c 2d 00 00       	call   80104380 <acquire>
  ip->ref++;
80101674:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101678:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010167f:	e8 ac 2d 00 00       	call   80104430 <release>
  return ip;
}
80101684:	89 d8                	mov    %ebx,%eax
80101686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101689:	c9                   	leave  
8010168a:	c3                   	ret    
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101698:	85 db                	test   %ebx,%ebx
8010169a:	0f 84 b7 00 00 00    	je     80101757 <ilock+0xc7>
801016a0:	8b 53 08             	mov    0x8(%ebx),%edx
801016a3:	85 d2                	test   %edx,%edx
801016a5:	0f 8e ac 00 00 00    	jle    80101757 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
801016ab:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ae:	83 ec 0c             	sub    $0xc,%esp
801016b1:	50                   	push   %eax
801016b2:	e8 79 2a 00 00       	call   80104130 <acquiresleep>

  if(ip->valid == 0){
801016b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ba:	83 c4 10             	add    $0x10,%esp
801016bd:	85 c0                	test   %eax,%eax
801016bf:	74 0f                	je     801016d0 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c4:	5b                   	pop    %ebx
801016c5:	5e                   	pop    %esi
801016c6:	5d                   	pop    %ebp
801016c7:	c3                   	ret    
801016c8:	90                   	nop
801016c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d0:	8b 43 04             	mov    0x4(%ebx),%eax
801016d3:	83 ec 08             	sub    $0x8,%esp
801016d6:	c1 e8 02             	shr    $0x2,%eax
801016d9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016df:	50                   	push   %eax
801016e0:	ff 33                	pushl  (%ebx)
801016e2:	e8 e9 e9 ff ff       	call   801000d0 <bread>
801016e7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ef:	83 e0 03             	and    $0x3,%eax
801016f2:	c1 e0 07             	shl    $0x7,%eax
801016f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016f9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016fc:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801016ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101703:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101707:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010170b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010170f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101713:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101717:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010171b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010171e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101721:	6a 5c                	push   $0x5c
80101723:	50                   	push   %eax
80101724:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101727:	50                   	push   %eax
80101728:	e8 03 2e 00 00       	call   80104530 <memmove>
    brelse(bp);
8010172d:	89 34 24             	mov    %esi,(%esp)
80101730:	e8 ab ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101735:	83 c4 10             	add    $0x10,%esp
80101738:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010173d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101744:	0f 85 77 ff ff ff    	jne    801016c1 <ilock+0x31>
      panic("ilock: no type");
8010174a:	83 ec 0c             	sub    $0xc,%esp
8010174d:	68 f0 70 10 80       	push   $0x801070f0
80101752:	e8 19 ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 ea 70 10 80       	push   $0x801070ea
8010175f:	e8 0c ec ff ff       	call   80100370 <panic>
80101764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010176a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101770 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101778:	85 db                	test   %ebx,%ebx
8010177a:	74 28                	je     801017a4 <iunlock+0x34>
8010177c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	56                   	push   %esi
80101783:	e8 48 2a 00 00       	call   801041d0 <holdingsleep>
80101788:	83 c4 10             	add    $0x10,%esp
8010178b:	85 c0                	test   %eax,%eax
8010178d:	74 15                	je     801017a4 <iunlock+0x34>
8010178f:	8b 43 08             	mov    0x8(%ebx),%eax
80101792:	85 c0                	test   %eax,%eax
80101794:	7e 0e                	jle    801017a4 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101796:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101799:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010179c:	5b                   	pop    %ebx
8010179d:	5e                   	pop    %esi
8010179e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010179f:	e9 ec 29 00 00       	jmp    80104190 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017a4:	83 ec 0c             	sub    $0xc,%esp
801017a7:	68 ff 70 10 80       	push   $0x801070ff
801017ac:	e8 bf eb ff ff       	call   80100370 <panic>
801017b1:	eb 0d                	jmp    801017c0 <iput>
801017b3:	90                   	nop
801017b4:	90                   	nop
801017b5:	90                   	nop
801017b6:	90                   	nop
801017b7:	90                   	nop
801017b8:	90                   	nop
801017b9:	90                   	nop
801017ba:	90                   	nop
801017bb:	90                   	nop
801017bc:	90                   	nop
801017bd:	90                   	nop
801017be:	90                   	nop
801017bf:	90                   	nop

801017c0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 28             	sub    $0x28,%esp
801017c9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017cc:	8d 7e 0c             	lea    0xc(%esi),%edi
801017cf:	57                   	push   %edi
801017d0:	e8 5b 29 00 00       	call   80104130 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017d5:	8b 56 4c             	mov    0x4c(%esi),%edx
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	85 d2                	test   %edx,%edx
801017dd:	74 07                	je     801017e6 <iput+0x26>
801017df:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017e4:	74 32                	je     80101818 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801017e6:	83 ec 0c             	sub    $0xc,%esp
801017e9:	57                   	push   %edi
801017ea:	e8 a1 29 00 00       	call   80104190 <releasesleep>

  acquire(&icache.lock);
801017ef:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017f6:	e8 85 2b 00 00       	call   80104380 <acquire>
  ip->ref--;
801017fb:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017ff:	83 c4 10             	add    $0x10,%esp
80101802:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180c:	5b                   	pop    %ebx
8010180d:	5e                   	pop    %esi
8010180e:	5f                   	pop    %edi
8010180f:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
80101810:	e9 1b 2c 00 00       	jmp    80104430 <release>
80101815:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 e0 09 11 80       	push   $0x801109e0
80101820:	e8 5b 2b 00 00       	call   80104380 <acquire>
    int r = ip->ref;
80101825:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101828:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010182f:	e8 fc 2b 00 00       	call   80104430 <release>
    if(r == 1){
80101834:	83 c4 10             	add    $0x10,%esp
80101837:	83 fb 01             	cmp    $0x1,%ebx
8010183a:	75 aa                	jne    801017e6 <iput+0x26>
8010183c:	8d 8e b4 00 00 00    	lea    0xb4(%esi),%ecx
80101842:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101845:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x97>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101853:	39 fb                	cmp    %edi,%ebx
80101855:	74 19                	je     80101870 <iput+0xb0>
    if(ip->addrs[i]){
80101857:	8b 13                	mov    (%ebx),%edx
80101859:	85 d2                	test   %edx,%edx
8010185b:	74 f3                	je     80101850 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010185d:	8b 06                	mov    (%esi),%eax
8010185f:	e8 9c f8 ff ff       	call   80101100 <bfree>
      ip->addrs[i] = 0;
80101864:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010186a:	eb e4                	jmp    80101850 <iput+0x90>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101870:	8b 86 b4 00 00 00    	mov    0xb4(%esi),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 33                	jne    801018b0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010187d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101880:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101887:	56                   	push   %esi
80101888:	e8 23 fd ff ff       	call   801015b0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010188d:	31 c0                	xor    %eax,%eax
8010188f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101893:	89 34 24             	mov    %esi,(%esp)
80101896:	e8 15 fd ff ff       	call   801015b0 <iupdate>
      ip->valid = 0;
8010189b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	e9 3c ff ff ff       	jmp    801017e6 <iput+0x26>
801018aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	83 ec 08             	sub    $0x8,%esp
801018b3:	50                   	push   %eax
801018b4:	ff 36                	pushl  (%esi)
801018b6:	e8 15 e8 ff ff       	call   801000d0 <bread>
801018bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018c1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018c7:	8d 58 5c             	lea    0x5c(%eax),%ebx
801018ca:	83 c4 10             	add    $0x10,%esp
801018cd:	89 cf                	mov    %ecx,%edi
801018cf:	eb 0e                	jmp    801018df <iput+0x11f>
801018d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018d8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
801018db:	39 fb                	cmp    %edi,%ebx
801018dd:	74 0f                	je     801018ee <iput+0x12e>
      if(a[j])
801018df:	8b 13                	mov    (%ebx),%edx
801018e1:	85 d2                	test   %edx,%edx
801018e3:	74 f3                	je     801018d8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018e5:	8b 06                	mov    (%esi),%eax
801018e7:	e8 14 f8 ff ff       	call   80101100 <bfree>
801018ec:	eb ea                	jmp    801018d8 <iput+0x118>
    }
    brelse(bp);
801018ee:	83 ec 0c             	sub    $0xc,%esp
801018f1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018f7:	e8 e4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018fc:	8b 96 b4 00 00 00    	mov    0xb4(%esi),%edx
80101902:	8b 06                	mov    (%esi),%eax
80101904:	e8 f7 f7 ff ff       	call   80101100 <bfree>
    ip->addrs[NDIRECT] = 0;
80101909:	c7 86 b4 00 00 00 00 	movl   $0x0,0xb4(%esi)
80101910:	00 00 00 
80101913:	83 c4 10             	add    $0x10,%esp
80101916:	e9 62 ff ff ff       	jmp    8010187d <iput+0xbd>
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 10             	sub    $0x10,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	53                   	push   %ebx
8010192b:	e8 40 fe ff ff       	call   80101770 <iunlock>
  iput(ip);
80101930:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101933:	83 c4 10             	add    $0x10,%esp
}
80101936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101939:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010193a:	e9 81 fe ff ff       	jmp    801017c0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 4a 58             	mov    0x58(%edx),%ecx
80101966:	89 48 10             	mov    %ecx,0x10(%eax)
  st->second = ip->second;
80101969:	8b 8a b8 00 00 00    	mov    0xb8(%edx),%ecx
8010196f:	89 48 14             	mov    %ecx,0x14(%eax)
  st->minute = ip->minute;
80101972:	8b 8a bc 00 00 00    	mov    0xbc(%edx),%ecx
80101978:	89 48 18             	mov    %ecx,0x18(%eax)
  st->hour = ip->hour;
8010197b:	8b 8a c0 00 00 00    	mov    0xc0(%edx),%ecx
80101981:	89 48 1c             	mov    %ecx,0x1c(%eax)
  st->day = ip->day;
80101984:	8b 8a c4 00 00 00    	mov    0xc4(%edx),%ecx
8010198a:	89 48 20             	mov    %ecx,0x20(%eax)
  st->month = ip->month;
8010198d:	8b 8a c8 00 00 00    	mov    0xc8(%edx),%ecx
80101993:	89 48 24             	mov    %ecx,0x24(%eax)
  st->year = ip->year;
80101996:	8b 92 cc 00 00 00    	mov    0xcc(%edx),%edx
8010199c:	89 50 28             	mov    %edx,0x28(%eax)
}
8010199f:	5d                   	pop    %ebp
801019a0:	c3                   	ret    
801019a1:	eb 0d                	jmp    801019b0 <readi>
801019a3:	90                   	nop
801019a4:	90                   	nop
801019a5:	90                   	nop
801019a6:	90                   	nop
801019a7:	90                   	nop
801019a8:	90                   	nop
801019a9:	90                   	nop
801019aa:	90                   	nop
801019ab:	90                   	nop
801019ac:	90                   	nop
801019ad:	90                   	nop
801019ae:	90                   	nop
801019af:	90                   	nop

801019b0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	57                   	push   %edi
801019b4:	56                   	push   %esi
801019b5:	53                   	push   %ebx
801019b6:	83 ec 1c             	sub    $0x1c,%esp
801019b9:	8b 45 08             	mov    0x8(%ebp),%eax
801019bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801019bf:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019c2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019c7:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019ca:	8b 7d 14             	mov    0x14(%ebp),%edi
801019cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019d0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019d3:	0f 84 a7 00 00 00    	je     80101a80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019dc:	8b 40 58             	mov    0x58(%eax),%eax
801019df:	39 f0                	cmp    %esi,%eax
801019e1:	0f 82 c1 00 00 00    	jb     80101aa8 <readi+0xf8>
801019e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019ea:	89 fa                	mov    %edi,%edx
801019ec:	01 f2                	add    %esi,%edx
801019ee:	0f 82 b4 00 00 00    	jb     80101aa8 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019f4:	89 c1                	mov    %eax,%ecx
801019f6:	29 f1                	sub    %esi,%ecx
801019f8:	39 d0                	cmp    %edx,%eax
801019fa:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019fd:	31 ff                	xor    %edi,%edi
801019ff:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a01:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a04:	74 6d                	je     80101a73 <readi+0xc3>
80101a06:	8d 76 00             	lea    0x0(%esi),%esi
80101a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a10:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a13:	89 f2                	mov    %esi,%edx
80101a15:	c1 ea 09             	shr    $0x9,%edx
80101a18:	89 d8                	mov    %ebx,%eax
80101a1a:	e8 31 f9 ff ff       	call   80101350 <bmap>
80101a1f:	83 ec 08             	sub    $0x8,%esp
80101a22:	50                   	push   %eax
80101a23:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a25:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a2a:	e8 a1 e6 ff ff       	call   801000d0 <bread>
80101a2f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101a34:	89 f1                	mov    %esi,%ecx
80101a36:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101a3c:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
80101a3f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a42:	29 cb                	sub    %ecx,%ebx
80101a44:	29 f8                	sub    %edi,%eax
80101a46:	39 c3                	cmp    %eax,%ebx
80101a48:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a4b:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
80101a4f:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a50:	01 df                	add    %ebx,%edi
80101a52:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101a54:	50                   	push   %eax
80101a55:	ff 75 e0             	pushl  -0x20(%ebp)
80101a58:	e8 d3 2a 00 00       	call   80104530 <memmove>
    brelse(bp);
80101a5d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a60:	89 14 24             	mov    %edx,(%esp)
80101a63:	e8 78 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a68:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a6b:	83 c4 10             	add    $0x10,%esp
80101a6e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a71:	77 9d                	ja     80101a10 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a79:	5b                   	pop    %ebx
80101a7a:	5e                   	pop    %esi
80101a7b:	5f                   	pop    %edi
80101a7c:	5d                   	pop    %ebp
80101a7d:	c3                   	ret    
80101a7e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a84:	66 83 f8 09          	cmp    $0x9,%ax
80101a88:	77 1e                	ja     80101aa8 <readi+0xf8>
80101a8a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a91:	85 c0                	test   %eax,%eax
80101a93:	74 13                	je     80101aa8 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a95:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a9b:	5b                   	pop    %ebx
80101a9c:	5e                   	pop    %esi
80101a9d:	5f                   	pop    %edi
80101a9e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a9f:	ff e0                	jmp    *%eax
80101aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101aa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101aad:	eb c7                	jmp    80101a76 <readi+0xc6>
80101aaf:	90                   	nop

80101ab0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	57                   	push   %edi
80101ab4:	56                   	push   %esi
80101ab5:	53                   	push   %ebx
80101ab6:	83 ec 1c             	sub    $0x1c,%esp
80101ab9:	8b 45 08             	mov    0x8(%ebp),%eax
80101abc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101abf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ac2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ac7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aca:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101acd:	8b 75 10             	mov    0x10(%ebp),%esi
80101ad0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ad3:	0f 84 b7 00 00 00    	je     80101b90 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ad9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101adc:	39 70 58             	cmp    %esi,0x58(%eax)
80101adf:	0f 82 eb 00 00 00    	jb     80101bd0 <writei+0x120>
80101ae5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ae8:	89 f8                	mov    %edi,%eax
80101aea:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101aec:	3d 00 2c 01 00       	cmp    $0x12c00,%eax
80101af1:	0f 87 d9 00 00 00    	ja     80101bd0 <writei+0x120>
80101af7:	39 c6                	cmp    %eax,%esi
80101af9:	0f 87 d1 00 00 00    	ja     80101bd0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101aff:	85 ff                	test   %edi,%edi
80101b01:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b08:	74 78                	je     80101b82 <writei+0xd2>
80101b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b10:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b13:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b15:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b1a:	c1 ea 09             	shr    $0x9,%edx
80101b1d:	89 f8                	mov    %edi,%eax
80101b1f:	e8 2c f8 ff ff       	call   80101350 <bmap>
80101b24:	83 ec 08             	sub    $0x8,%esp
80101b27:	50                   	push   %eax
80101b28:	ff 37                	pushl  (%edi)
80101b2a:	e8 a1 e5 ff ff       	call   801000d0 <bread>
80101b2f:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b34:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101b37:	89 f1                	mov    %esi,%ecx
80101b39:	83 c4 0c             	add    $0xc,%esp
80101b3c:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101b42:	29 cb                	sub    %ecx,%ebx
80101b44:	39 c3                	cmp    %eax,%ebx
80101b46:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b49:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101b4d:	53                   	push   %ebx
80101b4e:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b51:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101b53:	50                   	push   %eax
80101b54:	e8 d7 29 00 00       	call   80104530 <memmove>
    log_write(bp);
80101b59:	89 3c 24             	mov    %edi,(%esp)
80101b5c:	e8 2f 12 00 00       	call   80102d90 <log_write>
    brelse(bp);
80101b61:	89 3c 24             	mov    %edi,(%esp)
80101b64:	e8 77 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b69:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b6c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b6f:	83 c4 10             	add    $0x10,%esp
80101b72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b75:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101b78:	77 96                	ja     80101b10 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b7a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b7d:	3b 70 58             	cmp    0x58(%eax),%esi
80101b80:	77 36                	ja     80101bb8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b82:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b88:	5b                   	pop    %ebx
80101b89:	5e                   	pop    %esi
80101b8a:	5f                   	pop    %edi
80101b8b:	5d                   	pop    %ebp
80101b8c:	c3                   	ret    
80101b8d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b94:	66 83 f8 09          	cmp    $0x9,%ax
80101b98:	77 36                	ja     80101bd0 <writei+0x120>
80101b9a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101ba1:	85 c0                	test   %eax,%eax
80101ba3:	74 2b                	je     80101bd0 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101ba5:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101ba8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bab:	5b                   	pop    %ebx
80101bac:	5e                   	pop    %esi
80101bad:	5f                   	pop    %edi
80101bae:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101baf:	ff e0                	jmp    *%eax
80101bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101bb8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101bbb:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101bbe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101bc1:	50                   	push   %eax
80101bc2:	e8 e9 f9 ff ff       	call   801015b0 <iupdate>
80101bc7:	83 c4 10             	add    $0x10,%esp
80101bca:	eb b6                	jmp    80101b82 <writei+0xd2>
80101bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bd5:	eb ae                	jmp    80101b85 <writei+0xd5>
80101bd7:	89 f6                	mov    %esi,%esi
80101bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101be0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101be6:	6a 0e                	push   $0xe
80101be8:	ff 75 0c             	pushl  0xc(%ebp)
80101beb:	ff 75 08             	pushl  0x8(%ebp)
80101bee:	e8 bd 29 00 00       	call   801045b0 <strncmp>
}
80101bf3:	c9                   	leave  
80101bf4:	c3                   	ret    
80101bf5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c00 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	57                   	push   %edi
80101c04:	56                   	push   %esi
80101c05:	53                   	push   %ebx
80101c06:	83 ec 1c             	sub    $0x1c,%esp
80101c09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c0c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c11:	0f 85 80 00 00 00    	jne    80101c97 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c17:	8b 53 58             	mov    0x58(%ebx),%edx
80101c1a:	31 ff                	xor    %edi,%edi
80101c1c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c1f:	85 d2                	test   %edx,%edx
80101c21:	75 0d                	jne    80101c30 <dirlookup+0x30>
80101c23:	eb 5b                	jmp    80101c80 <dirlookup+0x80>
80101c25:	8d 76 00             	lea    0x0(%esi),%esi
80101c28:	83 c7 10             	add    $0x10,%edi
80101c2b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101c2e:	76 50                	jbe    80101c80 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c30:	6a 10                	push   $0x10
80101c32:	57                   	push   %edi
80101c33:	56                   	push   %esi
80101c34:	53                   	push   %ebx
80101c35:	e8 76 fd ff ff       	call   801019b0 <readi>
80101c3a:	83 c4 10             	add    $0x10,%esp
80101c3d:	83 f8 10             	cmp    $0x10,%eax
80101c40:	75 48                	jne    80101c8a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101c42:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c47:	74 df                	je     80101c28 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c49:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c4c:	83 ec 04             	sub    $0x4,%esp
80101c4f:	6a 0e                	push   $0xe
80101c51:	50                   	push   %eax
80101c52:	ff 75 0c             	pushl  0xc(%ebp)
80101c55:	e8 56 29 00 00       	call   801045b0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c5a:	83 c4 10             	add    $0x10,%esp
80101c5d:	85 c0                	test   %eax,%eax
80101c5f:	75 c7                	jne    80101c28 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c61:	8b 45 10             	mov    0x10(%ebp),%eax
80101c64:	85 c0                	test   %eax,%eax
80101c66:	74 05                	je     80101c6d <dirlookup+0x6d>
        *poff = off;
80101c68:	8b 45 10             	mov    0x10(%ebp),%eax
80101c6b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101c6d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c71:	8b 03                	mov    (%ebx),%eax
80101c73:	e8 08 f6 ff ff       	call   80101280 <iget>
    }
  }

  return 0;
}
80101c78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c7b:	5b                   	pop    %ebx
80101c7c:	5e                   	pop    %esi
80101c7d:	5f                   	pop    %edi
80101c7e:	5d                   	pop    %ebp
80101c7f:	c3                   	ret    
80101c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c83:	31 c0                	xor    %eax,%eax
}
80101c85:	5b                   	pop    %ebx
80101c86:	5e                   	pop    %esi
80101c87:	5f                   	pop    %edi
80101c88:	5d                   	pop    %ebp
80101c89:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c8a:	83 ec 0c             	sub    $0xc,%esp
80101c8d:	68 19 71 10 80       	push   $0x80107119
80101c92:	e8 d9 e6 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c97:	83 ec 0c             	sub    $0xc,%esp
80101c9a:	68 07 71 10 80       	push   $0x80107107
80101c9f:	e8 cc e6 ff ff       	call   80100370 <panic>
80101ca4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101caa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101cb0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cb0:	55                   	push   %ebp
80101cb1:	89 e5                	mov    %esp,%ebp
80101cb3:	57                   	push   %edi
80101cb4:	56                   	push   %esi
80101cb5:	53                   	push   %ebx
80101cb6:	89 cf                	mov    %ecx,%edi
80101cb8:	89 c3                	mov    %eax,%ebx
80101cba:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cbd:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cc0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101cc3:	0f 84 53 01 00 00    	je     80101e1c <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101cc9:	e8 12 1b 00 00       	call   801037e0 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101cce:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101cd1:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101cd4:	68 e0 09 11 80       	push   $0x801109e0
80101cd9:	e8 a2 26 00 00       	call   80104380 <acquire>
  ip->ref++;
80101cde:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ce2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101ce9:	e8 42 27 00 00       	call   80104430 <release>
80101cee:	83 c4 10             	add    $0x10,%esp
80101cf1:	eb 08                	jmp    80101cfb <namex+0x4b>
80101cf3:	90                   	nop
80101cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101cf8:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101cfb:	0f b6 03             	movzbl (%ebx),%eax
80101cfe:	3c 2f                	cmp    $0x2f,%al
80101d00:	74 f6                	je     80101cf8 <namex+0x48>
    path++;
  if(*path == 0)
80101d02:	84 c0                	test   %al,%al
80101d04:	0f 84 e3 00 00 00    	je     80101ded <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d0a:	0f b6 03             	movzbl (%ebx),%eax
80101d0d:	89 da                	mov    %ebx,%edx
80101d0f:	84 c0                	test   %al,%al
80101d11:	0f 84 ac 00 00 00    	je     80101dc3 <namex+0x113>
80101d17:	3c 2f                	cmp    $0x2f,%al
80101d19:	75 09                	jne    80101d24 <namex+0x74>
80101d1b:	e9 a3 00 00 00       	jmp    80101dc3 <namex+0x113>
80101d20:	84 c0                	test   %al,%al
80101d22:	74 0a                	je     80101d2e <namex+0x7e>
    path++;
80101d24:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d27:	0f b6 02             	movzbl (%edx),%eax
80101d2a:	3c 2f                	cmp    $0x2f,%al
80101d2c:	75 f2                	jne    80101d20 <namex+0x70>
80101d2e:	89 d1                	mov    %edx,%ecx
80101d30:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101d32:	83 f9 0d             	cmp    $0xd,%ecx
80101d35:	0f 8e 8d 00 00 00    	jle    80101dc8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d3b:	83 ec 04             	sub    $0x4,%esp
80101d3e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d41:	6a 0e                	push   $0xe
80101d43:	53                   	push   %ebx
80101d44:	57                   	push   %edi
80101d45:	e8 e6 27 00 00       	call   80104530 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d4a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101d4d:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d50:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d52:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d55:	75 11                	jne    80101d68 <namex+0xb8>
80101d57:	89 f6                	mov    %esi,%esi
80101d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d60:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d63:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d66:	74 f8                	je     80101d60 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d68:	83 ec 0c             	sub    $0xc,%esp
80101d6b:	56                   	push   %esi
80101d6c:	e8 1f f9 ff ff       	call   80101690 <ilock>
    if(ip->type != T_DIR){
80101d71:	83 c4 10             	add    $0x10,%esp
80101d74:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d79:	0f 85 7f 00 00 00    	jne    80101dfe <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d7f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d82:	85 d2                	test   %edx,%edx
80101d84:	74 09                	je     80101d8f <namex+0xdf>
80101d86:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d89:	0f 84 a3 00 00 00    	je     80101e32 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d8f:	83 ec 04             	sub    $0x4,%esp
80101d92:	6a 00                	push   $0x0
80101d94:	57                   	push   %edi
80101d95:	56                   	push   %esi
80101d96:	e8 65 fe ff ff       	call   80101c00 <dirlookup>
80101d9b:	83 c4 10             	add    $0x10,%esp
80101d9e:	85 c0                	test   %eax,%eax
80101da0:	74 5c                	je     80101dfe <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101da2:	83 ec 0c             	sub    $0xc,%esp
80101da5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101da8:	56                   	push   %esi
80101da9:	e8 c2 f9 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101dae:	89 34 24             	mov    %esi,(%esp)
80101db1:	e8 0a fa ff ff       	call   801017c0 <iput>
80101db6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101db9:	83 c4 10             	add    $0x10,%esp
80101dbc:	89 c6                	mov    %eax,%esi
80101dbe:	e9 38 ff ff ff       	jmp    80101cfb <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101dc3:	31 c9                	xor    %ecx,%ecx
80101dc5:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101dc8:	83 ec 04             	sub    $0x4,%esp
80101dcb:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dce:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101dd1:	51                   	push   %ecx
80101dd2:	53                   	push   %ebx
80101dd3:	57                   	push   %edi
80101dd4:	e8 57 27 00 00       	call   80104530 <memmove>
    name[len] = 0;
80101dd9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ddc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101ddf:	83 c4 10             	add    $0x10,%esp
80101de2:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101de6:	89 d3                	mov    %edx,%ebx
80101de8:	e9 65 ff ff ff       	jmp    80101d52 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ded:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101df0:	85 c0                	test   %eax,%eax
80101df2:	75 54                	jne    80101e48 <namex+0x198>
80101df4:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101df6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101df9:	5b                   	pop    %ebx
80101dfa:	5e                   	pop    %esi
80101dfb:	5f                   	pop    %edi
80101dfc:	5d                   	pop    %ebp
80101dfd:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101dfe:	83 ec 0c             	sub    $0xc,%esp
80101e01:	56                   	push   %esi
80101e02:	e8 69 f9 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101e07:	89 34 24             	mov    %esi,(%esp)
80101e0a:	e8 b1 f9 ff ff       	call   801017c0 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101e0f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101e15:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e17:	5b                   	pop    %ebx
80101e18:	5e                   	pop    %esi
80101e19:	5f                   	pop    %edi
80101e1a:	5d                   	pop    %ebp
80101e1b:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101e1c:	ba 01 00 00 00       	mov    $0x1,%edx
80101e21:	b8 01 00 00 00       	mov    $0x1,%eax
80101e26:	e8 55 f4 ff ff       	call   80101280 <iget>
80101e2b:	89 c6                	mov    %eax,%esi
80101e2d:	e9 c9 fe ff ff       	jmp    80101cfb <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e32:	83 ec 0c             	sub    $0xc,%esp
80101e35:	56                   	push   %esi
80101e36:	e8 35 f9 ff ff       	call   80101770 <iunlock>
      return ip;
80101e3b:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101e41:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e43:	5b                   	pop    %ebx
80101e44:	5e                   	pop    %esi
80101e45:	5f                   	pop    %edi
80101e46:	5d                   	pop    %ebp
80101e47:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e48:	83 ec 0c             	sub    $0xc,%esp
80101e4b:	56                   	push   %esi
80101e4c:	e8 6f f9 ff ff       	call   801017c0 <iput>
    return 0;
80101e51:	83 c4 10             	add    $0x10,%esp
80101e54:	31 c0                	xor    %eax,%eax
80101e56:	eb 9e                	jmp    80101df6 <namex+0x146>
80101e58:	90                   	nop
80101e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e60 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e60:	55                   	push   %ebp
80101e61:	89 e5                	mov    %esp,%ebp
80101e63:	57                   	push   %edi
80101e64:	56                   	push   %esi
80101e65:	53                   	push   %ebx
80101e66:	83 ec 20             	sub    $0x20,%esp
80101e69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e6c:	6a 00                	push   $0x0
80101e6e:	ff 75 0c             	pushl  0xc(%ebp)
80101e71:	53                   	push   %ebx
80101e72:	e8 89 fd ff ff       	call   80101c00 <dirlookup>
80101e77:	83 c4 10             	add    $0x10,%esp
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	75 67                	jne    80101ee5 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e7e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e81:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e84:	85 ff                	test   %edi,%edi
80101e86:	74 29                	je     80101eb1 <dirlink+0x51>
80101e88:	31 ff                	xor    %edi,%edi
80101e8a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e8d:	eb 09                	jmp    80101e98 <dirlink+0x38>
80101e8f:	90                   	nop
80101e90:	83 c7 10             	add    $0x10,%edi
80101e93:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e96:	76 19                	jbe    80101eb1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e98:	6a 10                	push   $0x10
80101e9a:	57                   	push   %edi
80101e9b:	56                   	push   %esi
80101e9c:	53                   	push   %ebx
80101e9d:	e8 0e fb ff ff       	call   801019b0 <readi>
80101ea2:	83 c4 10             	add    $0x10,%esp
80101ea5:	83 f8 10             	cmp    $0x10,%eax
80101ea8:	75 4e                	jne    80101ef8 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101eaa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101eaf:	75 df                	jne    80101e90 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101eb1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101eb4:	83 ec 04             	sub    $0x4,%esp
80101eb7:	6a 0e                	push   $0xe
80101eb9:	ff 75 0c             	pushl  0xc(%ebp)
80101ebc:	50                   	push   %eax
80101ebd:	e8 5e 27 00 00       	call   80104620 <strncpy>
  de.inum = inum;
80101ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ec5:	6a 10                	push   $0x10
80101ec7:	57                   	push   %edi
80101ec8:	56                   	push   %esi
80101ec9:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101eca:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ece:	e8 dd fb ff ff       	call   80101ab0 <writei>
80101ed3:	83 c4 20             	add    $0x20,%esp
80101ed6:	83 f8 10             	cmp    $0x10,%eax
80101ed9:	75 2a                	jne    80101f05 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101edb:	31 c0                	xor    %eax,%eax
}
80101edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ee0:	5b                   	pop    %ebx
80101ee1:	5e                   	pop    %esi
80101ee2:	5f                   	pop    %edi
80101ee3:	5d                   	pop    %ebp
80101ee4:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101ee5:	83 ec 0c             	sub    $0xc,%esp
80101ee8:	50                   	push   %eax
80101ee9:	e8 d2 f8 ff ff       	call   801017c0 <iput>
    return -1;
80101eee:	83 c4 10             	add    $0x10,%esp
80101ef1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ef6:	eb e5                	jmp    80101edd <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	68 28 71 10 80       	push   $0x80107128
80101f00:	e8 6b e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101f05:	83 ec 0c             	sub    $0xc,%esp
80101f08:	68 22 77 10 80       	push   $0x80107722
80101f0d:	e8 5e e4 ff ff       	call   80100370 <panic>
80101f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f20 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101f20:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f21:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101f23:	89 e5                	mov    %esp,%ebp
80101f25:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f28:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f2e:	e8 7d fd ff ff       	call   80101cb0 <namex>
}
80101f33:	c9                   	leave  
80101f34:	c3                   	ret    
80101f35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f40 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f40:	55                   	push   %ebp
  return namex(path, 1, name);
80101f41:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f46:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f4e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f4f:	e9 5c fd ff ff       	jmp    80101cb0 <namex>
80101f54:	66 90                	xchg   %ax,%ax
80101f56:	66 90                	xchg   %ax,%ax
80101f58:	66 90                	xchg   %ax,%ax
80101f5a:	66 90                	xchg   %ax,%ax
80101f5c:	66 90                	xchg   %ax,%ax
80101f5e:	66 90                	xchg   %ax,%ax

80101f60 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f60:	55                   	push   %ebp
  if(b == 0)
80101f61:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f63:	89 e5                	mov    %esp,%ebp
80101f65:	56                   	push   %esi
80101f66:	53                   	push   %ebx
  if(b == 0)
80101f67:	0f 84 ad 00 00 00    	je     8010201a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f6d:	8b 58 08             	mov    0x8(%eax),%ebx
80101f70:	89 c1                	mov    %eax,%ecx
80101f72:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f78:	0f 87 8f 00 00 00    	ja     8010200d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f7e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f83:	90                   	nop
80101f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f88:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f89:	83 e0 c0             	and    $0xffffffc0,%eax
80101f8c:	3c 40                	cmp    $0x40,%al
80101f8e:	75 f8                	jne    80101f88 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f90:	31 f6                	xor    %esi,%esi
80101f92:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f97:	89 f0                	mov    %esi,%eax
80101f99:	ee                   	out    %al,(%dx)
80101f9a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f9f:	b8 01 00 00 00       	mov    $0x1,%eax
80101fa4:	ee                   	out    %al,(%dx)
80101fa5:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101faa:	89 d8                	mov    %ebx,%eax
80101fac:	ee                   	out    %al,(%dx)
80101fad:	89 d8                	mov    %ebx,%eax
80101faf:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101fb4:	c1 f8 08             	sar    $0x8,%eax
80101fb7:	ee                   	out    %al,(%dx)
80101fb8:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101fbd:	89 f0                	mov    %esi,%eax
80101fbf:	ee                   	out    %al,(%dx)
80101fc0:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101fc4:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fc9:	83 e0 01             	and    $0x1,%eax
80101fcc:	c1 e0 04             	shl    $0x4,%eax
80101fcf:	83 c8 e0             	or     $0xffffffe0,%eax
80101fd2:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101fd3:	f6 01 04             	testb  $0x4,(%ecx)
80101fd6:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fdb:	75 13                	jne    80101ff0 <idestart+0x90>
80101fdd:	b8 20 00 00 00       	mov    $0x20,%eax
80101fe2:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fe3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101fe6:	5b                   	pop    %ebx
80101fe7:	5e                   	pop    %esi
80101fe8:	5d                   	pop    %ebp
80101fe9:	c3                   	ret    
80101fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101ff0:	b8 30 00 00 00       	mov    $0x30,%eax
80101ff5:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101ff6:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101ffb:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101ffe:	b9 80 00 00 00       	mov    $0x80,%ecx
80102003:	fc                   	cld    
80102004:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102006:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102009:	5b                   	pop    %ebx
8010200a:	5e                   	pop    %esi
8010200b:	5d                   	pop    %ebp
8010200c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010200d:	83 ec 0c             	sub    $0xc,%esp
80102010:	68 94 71 10 80       	push   $0x80107194
80102015:	e8 56 e3 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010201a:	83 ec 0c             	sub    $0xc,%esp
8010201d:	68 8b 71 10 80       	push   $0x8010718b
80102022:	e8 49 e3 ff ff       	call   80100370 <panic>
80102027:	89 f6                	mov    %esi,%esi
80102029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102030 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80102036:	68 a6 71 10 80       	push   $0x801071a6
8010203b:	68 80 a5 10 80       	push   $0x8010a580
80102040:	e8 db 21 00 00       	call   80104220 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102045:	58                   	pop    %eax
80102046:	a1 80 39 11 80       	mov    0x80113980,%eax
8010204b:	5a                   	pop    %edx
8010204c:	83 e8 01             	sub    $0x1,%eax
8010204f:	50                   	push   %eax
80102050:	6a 0e                	push   $0xe
80102052:	e8 a9 02 00 00       	call   80102300 <ioapicenable>
80102057:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010205a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010205f:	90                   	nop
80102060:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102061:	83 e0 c0             	and    $0xffffffc0,%eax
80102064:	3c 40                	cmp    $0x40,%al
80102066:	75 f8                	jne    80102060 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102068:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010206d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102072:	ee                   	out    %al,(%dx)
80102073:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102078:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010207d:	eb 06                	jmp    80102085 <ideinit+0x55>
8010207f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102080:	83 e9 01             	sub    $0x1,%ecx
80102083:	74 0f                	je     80102094 <ideinit+0x64>
80102085:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102086:	84 c0                	test   %al,%al
80102088:	74 f6                	je     80102080 <ideinit+0x50>
      havedisk1 = 1;
8010208a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102091:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102094:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102099:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010209e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010209f:	c9                   	leave  
801020a0:	c3                   	ret    
801020a1:	eb 0d                	jmp    801020b0 <ideintr>
801020a3:	90                   	nop
801020a4:	90                   	nop
801020a5:	90                   	nop
801020a6:	90                   	nop
801020a7:	90                   	nop
801020a8:	90                   	nop
801020a9:	90                   	nop
801020aa:	90                   	nop
801020ab:	90                   	nop
801020ac:	90                   	nop
801020ad:	90                   	nop
801020ae:	90                   	nop
801020af:	90                   	nop

801020b0 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
801020b0:	55                   	push   %ebp
801020b1:	89 e5                	mov    %esp,%ebp
801020b3:	57                   	push   %edi
801020b4:	56                   	push   %esi
801020b5:	53                   	push   %ebx
801020b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020b9:	68 80 a5 10 80       	push   $0x8010a580
801020be:	e8 bd 22 00 00       	call   80104380 <acquire>

  if((b = idequeue) == 0){
801020c3:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020c9:	83 c4 10             	add    $0x10,%esp
801020cc:	85 db                	test   %ebx,%ebx
801020ce:	74 34                	je     80102104 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020d0:	8b 43 58             	mov    0x58(%ebx),%eax
801020d3:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020d8:	8b 33                	mov    (%ebx),%esi
801020da:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020e0:	74 3e                	je     80102120 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020e2:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801020e5:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020e8:	83 ce 02             	or     $0x2,%esi
801020eb:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020ed:	53                   	push   %ebx
801020ee:	e8 4d 1e 00 00       	call   80103f40 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020f3:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020f8:	83 c4 10             	add    $0x10,%esp
801020fb:	85 c0                	test   %eax,%eax
801020fd:	74 05                	je     80102104 <ideintr+0x54>
    idestart(idequeue);
801020ff:	e8 5c fe ff ff       	call   80101f60 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
80102104:	83 ec 0c             	sub    $0xc,%esp
80102107:	68 80 a5 10 80       	push   $0x8010a580
8010210c:	e8 1f 23 00 00       	call   80104430 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102111:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102114:	5b                   	pop    %ebx
80102115:	5e                   	pop    %esi
80102116:	5f                   	pop    %edi
80102117:	5d                   	pop    %ebp
80102118:	c3                   	ret    
80102119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102120:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102125:	8d 76 00             	lea    0x0(%esi),%esi
80102128:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102129:	89 c1                	mov    %eax,%ecx
8010212b:	83 e1 c0             	and    $0xffffffc0,%ecx
8010212e:	80 f9 40             	cmp    $0x40,%cl
80102131:	75 f5                	jne    80102128 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102133:	a8 21                	test   $0x21,%al
80102135:	75 ab                	jne    801020e2 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
80102137:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
8010213a:	b9 80 00 00 00       	mov    $0x80,%ecx
8010213f:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102144:	fc                   	cld    
80102145:	f3 6d                	rep insl (%dx),%es:(%edi)
80102147:	8b 33                	mov    (%ebx),%esi
80102149:	eb 97                	jmp    801020e2 <ideintr+0x32>
8010214b:	90                   	nop
8010214c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102150 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102150:	55                   	push   %ebp
80102151:	89 e5                	mov    %esp,%ebp
80102153:	53                   	push   %ebx
80102154:	83 ec 10             	sub    $0x10,%esp
80102157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010215a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010215d:	50                   	push   %eax
8010215e:	e8 6d 20 00 00       	call   801041d0 <holdingsleep>
80102163:	83 c4 10             	add    $0x10,%esp
80102166:	85 c0                	test   %eax,%eax
80102168:	0f 84 ad 00 00 00    	je     8010221b <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010216e:	8b 03                	mov    (%ebx),%eax
80102170:	83 e0 06             	and    $0x6,%eax
80102173:	83 f8 02             	cmp    $0x2,%eax
80102176:	0f 84 b9 00 00 00    	je     80102235 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010217c:	8b 53 04             	mov    0x4(%ebx),%edx
8010217f:	85 d2                	test   %edx,%edx
80102181:	74 0d                	je     80102190 <iderw+0x40>
80102183:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102188:	85 c0                	test   %eax,%eax
8010218a:	0f 84 98 00 00 00    	je     80102228 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102190:	83 ec 0c             	sub    $0xc,%esp
80102193:	68 80 a5 10 80       	push   $0x8010a580
80102198:	e8 e3 21 00 00       	call   80104380 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010219d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
801021a3:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
801021a6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ad:	85 d2                	test   %edx,%edx
801021af:	75 09                	jne    801021ba <iderw+0x6a>
801021b1:	eb 58                	jmp    8010220b <iderw+0xbb>
801021b3:	90                   	nop
801021b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021b8:	89 c2                	mov    %eax,%edx
801021ba:	8b 42 58             	mov    0x58(%edx),%eax
801021bd:	85 c0                	test   %eax,%eax
801021bf:	75 f7                	jne    801021b8 <iderw+0x68>
801021c1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801021c4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021c6:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
801021cc:	74 44                	je     80102212 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ce:	8b 03                	mov    (%ebx),%eax
801021d0:	83 e0 06             	and    $0x6,%eax
801021d3:	83 f8 02             	cmp    $0x2,%eax
801021d6:	74 23                	je     801021fb <iderw+0xab>
801021d8:	90                   	nop
801021d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021e0:	83 ec 08             	sub    $0x8,%esp
801021e3:	68 80 a5 10 80       	push   $0x8010a580
801021e8:	53                   	push   %ebx
801021e9:	e8 a2 1b 00 00       	call   80103d90 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ee:	8b 03                	mov    (%ebx),%eax
801021f0:	83 c4 10             	add    $0x10,%esp
801021f3:	83 e0 06             	and    $0x6,%eax
801021f6:	83 f8 02             	cmp    $0x2,%eax
801021f9:	75 e5                	jne    801021e0 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
801021fb:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102202:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102205:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102206:	e9 25 22 00 00       	jmp    80104430 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010220b:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102210:	eb b2                	jmp    801021c4 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102212:	89 d8                	mov    %ebx,%eax
80102214:	e8 47 fd ff ff       	call   80101f60 <idestart>
80102219:	eb b3                	jmp    801021ce <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010221b:	83 ec 0c             	sub    $0xc,%esp
8010221e:	68 aa 71 10 80       	push   $0x801071aa
80102223:	e8 48 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102228:	83 ec 0c             	sub    $0xc,%esp
8010222b:	68 d5 71 10 80       	push   $0x801071d5
80102230:	e8 3b e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102235:	83 ec 0c             	sub    $0xc,%esp
80102238:	68 c0 71 10 80       	push   $0x801071c0
8010223d:	e8 2e e1 ff ff       	call   80100370 <panic>
80102242:	66 90                	xchg   %ax,%ax
80102244:	66 90                	xchg   %ax,%ax
80102246:	66 90                	xchg   %ax,%ax
80102248:	66 90                	xchg   %ax,%ax
8010224a:	66 90                	xchg   %ax,%ax
8010224c:	66 90                	xchg   %ax,%ax
8010224e:	66 90                	xchg   %ax,%ax

80102250 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102250:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102251:	c7 05 b4 32 11 80 00 	movl   $0xfec00000,0x801132b4
80102258:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010225b:	89 e5                	mov    %esp,%ebp
8010225d:	56                   	push   %esi
8010225e:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010225f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102266:	00 00 00 
  return ioapic->data;
80102269:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
8010226f:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102272:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102278:	8b 0d b4 32 11 80    	mov    0x801132b4,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010227e:	0f b6 15 e0 33 11 80 	movzbl 0x801133e0,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102285:	89 f0                	mov    %esi,%eax
80102287:	c1 e8 10             	shr    $0x10,%eax
8010228a:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010228d:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102290:	c1 e8 18             	shr    $0x18,%eax
80102293:	39 d0                	cmp    %edx,%eax
80102295:	74 16                	je     801022ad <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102297:	83 ec 0c             	sub    $0xc,%esp
8010229a:	68 f4 71 10 80       	push   $0x801071f4
8010229f:	e8 bc e3 ff ff       	call   80100660 <cprintf>
801022a4:	8b 0d b4 32 11 80    	mov    0x801132b4,%ecx
801022aa:	83 c4 10             	add    $0x10,%esp
801022ad:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
801022b0:	ba 10 00 00 00       	mov    $0x10,%edx
801022b5:	b8 20 00 00 00       	mov    $0x20,%eax
801022ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022c0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801022c2:	8b 0d b4 32 11 80    	mov    0x801132b4,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022c8:	89 c3                	mov    %eax,%ebx
801022ca:	81 cb 00 00 01 00    	or     $0x10000,%ebx
801022d0:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022d3:	89 59 10             	mov    %ebx,0x10(%ecx)
801022d6:	8d 5a 01             	lea    0x1(%edx),%ebx
801022d9:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022dc:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022de:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801022e0:	8b 0d b4 32 11 80    	mov    0x801132b4,%ecx
801022e6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022ed:	75 d1                	jne    801022c0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022f2:	5b                   	pop    %ebx
801022f3:	5e                   	pop    %esi
801022f4:	5d                   	pop    %ebp
801022f5:	c3                   	ret    
801022f6:	8d 76 00             	lea    0x0(%esi),%esi
801022f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102300 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102300:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102301:	8b 0d b4 32 11 80    	mov    0x801132b4,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102307:	89 e5                	mov    %esp,%ebp
80102309:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010230c:	8d 50 20             	lea    0x20(%eax),%edx
8010230f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102313:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102315:	8b 0d b4 32 11 80    	mov    0x801132b4,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010231b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010231e:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102321:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102324:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102326:	a1 b4 32 11 80       	mov    0x801132b4,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010232b:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010232e:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102331:	5d                   	pop    %ebp
80102332:	c3                   	ret    
80102333:	66 90                	xchg   %ax,%ax
80102335:	66 90                	xchg   %ax,%ax
80102337:	66 90                	xchg   %ax,%ax
80102339:	66 90                	xchg   %ax,%ax
8010233b:	66 90                	xchg   %ax,%ax
8010233d:	66 90                	xchg   %ax,%ax
8010233f:	90                   	nop

80102340 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102340:	55                   	push   %ebp
80102341:	89 e5                	mov    %esp,%ebp
80102343:	53                   	push   %ebx
80102344:	83 ec 04             	sub    $0x4,%esp
80102347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010234a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102350:	75 70                	jne    801023c2 <kfree+0x82>
80102352:	81 fb 28 61 11 80    	cmp    $0x80116128,%ebx
80102358:	72 68                	jb     801023c2 <kfree+0x82>
8010235a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102360:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102365:	77 5b                	ja     801023c2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102367:	83 ec 04             	sub    $0x4,%esp
8010236a:	68 00 10 00 00       	push   $0x1000
8010236f:	6a 01                	push   $0x1
80102371:	53                   	push   %ebx
80102372:	e8 09 21 00 00       	call   80104480 <memset>

  if(kmem.use_lock)
80102377:	8b 15 f4 32 11 80    	mov    0x801132f4,%edx
8010237d:	83 c4 10             	add    $0x10,%esp
80102380:	85 d2                	test   %edx,%edx
80102382:	75 2c                	jne    801023b0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102384:	a1 f8 32 11 80       	mov    0x801132f8,%eax
80102389:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010238b:	a1 f4 32 11 80       	mov    0x801132f4,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102390:	89 1d f8 32 11 80    	mov    %ebx,0x801132f8
  if(kmem.use_lock)
80102396:	85 c0                	test   %eax,%eax
80102398:	75 06                	jne    801023a0 <kfree+0x60>
    release(&kmem.lock);
}
8010239a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010239d:	c9                   	leave  
8010239e:	c3                   	ret    
8010239f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801023a0:	c7 45 08 c0 32 11 80 	movl   $0x801132c0,0x8(%ebp)
}
801023a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023aa:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801023ab:	e9 80 20 00 00       	jmp    80104430 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
801023b0:	83 ec 0c             	sub    $0xc,%esp
801023b3:	68 c0 32 11 80       	push   $0x801132c0
801023b8:	e8 c3 1f 00 00       	call   80104380 <acquire>
801023bd:	83 c4 10             	add    $0x10,%esp
801023c0:	eb c2                	jmp    80102384 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
801023c2:	83 ec 0c             	sub    $0xc,%esp
801023c5:	68 26 72 10 80       	push   $0x80107226
801023ca:	e8 a1 df ff ff       	call   80100370 <panic>
801023cf:	90                   	nop

801023d0 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	56                   	push   %esi
801023d4:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801023d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023ed:	39 de                	cmp    %ebx,%esi
801023ef:	72 23                	jb     80102414 <freerange+0x44>
801023f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023f8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023fe:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102401:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102407:	50                   	push   %eax
80102408:	e8 33 ff ff ff       	call   80102340 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010240d:	83 c4 10             	add    $0x10,%esp
80102410:	39 f3                	cmp    %esi,%ebx
80102412:	76 e4                	jbe    801023f8 <freerange+0x28>
    kfree(p);
}
80102414:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102417:	5b                   	pop    %ebx
80102418:	5e                   	pop    %esi
80102419:	5d                   	pop    %ebp
8010241a:	c3                   	ret    
8010241b:	90                   	nop
8010241c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102420 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	56                   	push   %esi
80102424:	53                   	push   %ebx
80102425:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102428:	83 ec 08             	sub    $0x8,%esp
8010242b:	68 2c 72 10 80       	push   $0x8010722c
80102430:	68 c0 32 11 80       	push   $0x801132c0
80102435:	e8 e6 1d 00 00       	call   80104220 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010243a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010243d:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102440:	c7 05 f4 32 11 80 00 	movl   $0x0,0x801132f4
80102447:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010244a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102450:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102456:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010245c:	39 de                	cmp    %ebx,%esi
8010245e:	72 1c                	jb     8010247c <kinit1+0x5c>
    kfree(p);
80102460:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102466:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102469:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010246f:	50                   	push   %eax
80102470:	e8 cb fe ff ff       	call   80102340 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102475:	83 c4 10             	add    $0x10,%esp
80102478:	39 de                	cmp    %ebx,%esi
8010247a:	73 e4                	jae    80102460 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010247c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010247f:	5b                   	pop    %ebx
80102480:	5e                   	pop    %esi
80102481:	5d                   	pop    %ebp
80102482:	c3                   	ret    
80102483:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102490 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	56                   	push   %esi
80102494:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102495:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102498:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010249b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024ad:	39 de                	cmp    %ebx,%esi
801024af:	72 23                	jb     801024d4 <kinit2+0x44>
801024b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024b8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024be:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024c7:	50                   	push   %eax
801024c8:	e8 73 fe ff ff       	call   80102340 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024cd:	83 c4 10             	add    $0x10,%esp
801024d0:	39 de                	cmp    %ebx,%esi
801024d2:	73 e4                	jae    801024b8 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
801024d4:	c7 05 f4 32 11 80 01 	movl   $0x1,0x801132f4
801024db:	00 00 00 
}
801024de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024e1:	5b                   	pop    %ebx
801024e2:	5e                   	pop    %esi
801024e3:	5d                   	pop    %ebp
801024e4:	c3                   	ret    
801024e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024f0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024f0:	55                   	push   %ebp
801024f1:	89 e5                	mov    %esp,%ebp
801024f3:	53                   	push   %ebx
801024f4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801024f7:	a1 f4 32 11 80       	mov    0x801132f4,%eax
801024fc:	85 c0                	test   %eax,%eax
801024fe:	75 30                	jne    80102530 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102500:	8b 1d f8 32 11 80    	mov    0x801132f8,%ebx
  if(r)
80102506:	85 db                	test   %ebx,%ebx
80102508:	74 1c                	je     80102526 <kalloc+0x36>
    kmem.freelist = r->next;
8010250a:	8b 13                	mov    (%ebx),%edx
8010250c:	89 15 f8 32 11 80    	mov    %edx,0x801132f8
  if(kmem.use_lock)
80102512:	85 c0                	test   %eax,%eax
80102514:	74 10                	je     80102526 <kalloc+0x36>
    release(&kmem.lock);
80102516:	83 ec 0c             	sub    $0xc,%esp
80102519:	68 c0 32 11 80       	push   $0x801132c0
8010251e:	e8 0d 1f 00 00       	call   80104430 <release>
80102523:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
80102526:	89 d8                	mov    %ebx,%eax
80102528:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010252b:	c9                   	leave  
8010252c:	c3                   	ret    
8010252d:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102530:	83 ec 0c             	sub    $0xc,%esp
80102533:	68 c0 32 11 80       	push   $0x801132c0
80102538:	e8 43 1e 00 00       	call   80104380 <acquire>
  r = kmem.freelist;
8010253d:	8b 1d f8 32 11 80    	mov    0x801132f8,%ebx
  if(r)
80102543:	83 c4 10             	add    $0x10,%esp
80102546:	a1 f4 32 11 80       	mov    0x801132f4,%eax
8010254b:	85 db                	test   %ebx,%ebx
8010254d:	75 bb                	jne    8010250a <kalloc+0x1a>
8010254f:	eb c1                	jmp    80102512 <kalloc+0x22>
80102551:	66 90                	xchg   %ax,%ax
80102553:	66 90                	xchg   %ax,%ax
80102555:	66 90                	xchg   %ax,%ax
80102557:	66 90                	xchg   %ax,%ax
80102559:	66 90                	xchg   %ax,%ax
8010255b:	66 90                	xchg   %ax,%ax
8010255d:	66 90                	xchg   %ax,%ax
8010255f:	90                   	nop

80102560 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102560:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102561:	ba 64 00 00 00       	mov    $0x64,%edx
80102566:	89 e5                	mov    %esp,%ebp
80102568:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102569:	a8 01                	test   $0x1,%al
8010256b:	0f 84 af 00 00 00    	je     80102620 <kbdgetc+0xc0>
80102571:	ba 60 00 00 00       	mov    $0x60,%edx
80102576:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102577:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010257a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102580:	74 7e                	je     80102600 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102582:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102584:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010258a:	79 24                	jns    801025b0 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010258c:	f6 c1 40             	test   $0x40,%cl
8010258f:	75 05                	jne    80102596 <kbdgetc+0x36>
80102591:	89 c2                	mov    %eax,%edx
80102593:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102596:	0f b6 82 60 73 10 80 	movzbl -0x7fef8ca0(%edx),%eax
8010259d:	83 c8 40             	or     $0x40,%eax
801025a0:	0f b6 c0             	movzbl %al,%eax
801025a3:	f7 d0                	not    %eax
801025a5:	21 c8                	and    %ecx,%eax
801025a7:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
801025ac:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025ae:	5d                   	pop    %ebp
801025af:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801025b0:	f6 c1 40             	test   $0x40,%cl
801025b3:	74 09                	je     801025be <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025b5:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801025b8:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025bb:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801025be:	0f b6 82 60 73 10 80 	movzbl -0x7fef8ca0(%edx),%eax
801025c5:	09 c1                	or     %eax,%ecx
801025c7:	0f b6 82 60 72 10 80 	movzbl -0x7fef8da0(%edx),%eax
801025ce:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025d0:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801025d2:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801025d8:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025db:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
801025de:	8b 04 85 40 72 10 80 	mov    -0x7fef8dc0(,%eax,4),%eax
801025e5:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801025e9:	74 c3                	je     801025ae <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
801025eb:	8d 50 9f             	lea    -0x61(%eax),%edx
801025ee:	83 fa 19             	cmp    $0x19,%edx
801025f1:	77 1d                	ja     80102610 <kbdgetc+0xb0>
      c += 'A' - 'a';
801025f3:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025f6:	5d                   	pop    %ebp
801025f7:	c3                   	ret    
801025f8:	90                   	nop
801025f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102600:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102602:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102609:	5d                   	pop    %ebp
8010260a:	c3                   	ret    
8010260b:	90                   	nop
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102610:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102613:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102616:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102617:	83 f9 19             	cmp    $0x19,%ecx
8010261a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
8010261d:	c3                   	ret    
8010261e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102625:	5d                   	pop    %ebp
80102626:	c3                   	ret    
80102627:	89 f6                	mov    %esi,%esi
80102629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102630 <kbdintr>:

void
kbdintr(void)
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102636:	68 60 25 10 80       	push   $0x80102560
8010263b:	e8 b0 e1 ff ff       	call   801007f0 <consoleintr>
}
80102640:	83 c4 10             	add    $0x10,%esp
80102643:	c9                   	leave  
80102644:	c3                   	ret    
80102645:	66 90                	xchg   %ax,%ax
80102647:	66 90                	xchg   %ax,%ax
80102649:	66 90                	xchg   %ax,%ax
8010264b:	66 90                	xchg   %ax,%ax
8010264d:	66 90                	xchg   %ax,%ax
8010264f:	90                   	nop

80102650 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102650:	a1 fc 32 11 80       	mov    0x801132fc,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102655:	55                   	push   %ebp
80102656:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102658:	85 c0                	test   %eax,%eax
8010265a:	0f 84 c8 00 00 00    	je     80102728 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102660:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102667:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010266a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010266d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102674:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102677:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010267a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102681:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102684:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102687:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010268e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102691:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102694:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010269b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010269e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026a1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026a8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ab:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026ae:	8b 50 30             	mov    0x30(%eax),%edx
801026b1:	c1 ea 10             	shr    $0x10,%edx
801026b4:	80 fa 03             	cmp    $0x3,%dl
801026b7:	77 77                	ja     80102730 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026c0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c3:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026cd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d0:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026da:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026dd:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026e7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ea:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026ed:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026fa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102701:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102704:	8b 50 20             	mov    0x20(%eax),%edx
80102707:	89 f6                	mov    %esi,%esi
80102709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102710:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102716:	80 e6 10             	and    $0x10,%dh
80102719:	75 f5                	jne    80102710 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010271b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102722:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102725:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102728:	5d                   	pop    %ebp
80102729:	c3                   	ret    
8010272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102730:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102737:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010273a:	8b 50 20             	mov    0x20(%eax),%edx
8010273d:	e9 77 ff ff ff       	jmp    801026b9 <lapicinit+0x69>
80102742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102750:	a1 fc 32 11 80       	mov    0x801132fc,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102758:	85 c0                	test   %eax,%eax
8010275a:	74 0c                	je     80102768 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010275c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010275f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102760:	c1 e8 18             	shr    $0x18,%eax
}
80102763:	c3                   	ret    
80102764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102768:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
8010276a:	5d                   	pop    %ebp
8010276b:	c3                   	ret    
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102770:	a1 fc 32 11 80       	mov    0x801132fc,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102775:	55                   	push   %ebp
80102776:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102778:	85 c0                	test   %eax,%eax
8010277a:	74 0d                	je     80102789 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010277c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102783:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102786:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102789:	5d                   	pop    %ebp
8010278a:	c3                   	ret    
8010278b:	90                   	nop
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
}
80102793:	5d                   	pop    %ebp
80102794:	c3                   	ret    
80102795:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027a0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027a0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027a1:	ba 70 00 00 00       	mov    $0x70,%edx
801027a6:	b8 0f 00 00 00       	mov    $0xf,%eax
801027ab:	89 e5                	mov    %esp,%ebp
801027ad:	53                   	push   %ebx
801027ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027b4:	ee                   	out    %al,(%dx)
801027b5:	ba 71 00 00 00       	mov    $0x71,%edx
801027ba:	b8 0a 00 00 00       	mov    $0xa,%eax
801027bf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027c0:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027c2:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027c5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027cb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027cd:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801027d0:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027d3:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027d5:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801027d8:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027de:	a1 fc 32 11 80       	mov    0x801132fc,%eax
801027e3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027e9:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027ec:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027f3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f6:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027f9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102800:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102803:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102806:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010280c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010280f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102815:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102818:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010281e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102821:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010282a:	5b                   	pop    %ebx
8010282b:	5d                   	pop    %ebp
8010282c:	c3                   	ret    
8010282d:	8d 76 00             	lea    0x0(%esi),%esi

80102830 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102830:	55                   	push   %ebp
80102831:	ba 70 00 00 00       	mov    $0x70,%edx
80102836:	b8 0b 00 00 00       	mov    $0xb,%eax
8010283b:	89 e5                	mov    %esp,%ebp
8010283d:	57                   	push   %edi
8010283e:	56                   	push   %esi
8010283f:	53                   	push   %ebx
80102840:	83 ec 4c             	sub    $0x4c,%esp
80102843:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102844:	ba 71 00 00 00       	mov    $0x71,%edx
80102849:	ec                   	in     (%dx),%al
8010284a:	83 e0 04             	and    $0x4,%eax
8010284d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102850:	31 db                	xor    %ebx,%ebx
80102852:	88 45 b7             	mov    %al,-0x49(%ebp)
80102855:	bf 70 00 00 00       	mov    $0x70,%edi
8010285a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102860:	89 d8                	mov    %ebx,%eax
80102862:	89 fa                	mov    %edi,%edx
80102864:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102865:	b9 71 00 00 00       	mov    $0x71,%ecx
8010286a:	89 ca                	mov    %ecx,%edx
8010286c:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010286d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102870:	89 fa                	mov    %edi,%edx
80102872:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102875:	b8 02 00 00 00       	mov    $0x2,%eax
8010287a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287b:	89 ca                	mov    %ecx,%edx
8010287d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
8010287e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102881:	89 fa                	mov    %edi,%edx
80102883:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102886:	b8 04 00 00 00       	mov    $0x4,%eax
8010288b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288c:	89 ca                	mov    %ecx,%edx
8010288e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
8010288f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102892:	89 fa                	mov    %edi,%edx
80102894:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102897:	b8 07 00 00 00       	mov    $0x7,%eax
8010289c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289d:	89 ca                	mov    %ecx,%edx
8010289f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801028a0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a3:	89 fa                	mov    %edi,%edx
801028a5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028a8:	b8 08 00 00 00       	mov    $0x8,%eax
801028ad:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ae:	89 ca                	mov    %ecx,%edx
801028b0:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801028b1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b4:	89 fa                	mov    %edi,%edx
801028b6:	89 45 c8             	mov    %eax,-0x38(%ebp)
801028b9:	b8 09 00 00 00       	mov    $0x9,%eax
801028be:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028bf:	89 ca                	mov    %ecx,%edx
801028c1:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801028c2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c5:	89 fa                	mov    %edi,%edx
801028c7:	89 45 cc             	mov    %eax,-0x34(%ebp)
801028ca:	b8 0a 00 00 00       	mov    $0xa,%eax
801028cf:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d0:	89 ca                	mov    %ecx,%edx
801028d2:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028d3:	84 c0                	test   %al,%al
801028d5:	78 89                	js     80102860 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d7:	89 d8                	mov    %ebx,%eax
801028d9:	89 fa                	mov    %edi,%edx
801028db:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dc:	89 ca                	mov    %ecx,%edx
801028de:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
801028df:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e2:	89 fa                	mov    %edi,%edx
801028e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028e7:	b8 02 00 00 00       	mov    $0x2,%eax
801028ec:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ed:	89 ca                	mov    %ecx,%edx
801028ef:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
801028f0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f3:	89 fa                	mov    %edi,%edx
801028f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028f8:	b8 04 00 00 00       	mov    $0x4,%eax
801028fd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fe:	89 ca                	mov    %ecx,%edx
80102900:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102901:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102904:	89 fa                	mov    %edi,%edx
80102906:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102909:	b8 07 00 00 00       	mov    $0x7,%eax
8010290e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290f:	89 ca                	mov    %ecx,%edx
80102911:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102912:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102915:	89 fa                	mov    %edi,%edx
80102917:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010291a:	b8 08 00 00 00       	mov    $0x8,%eax
8010291f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102920:	89 ca                	mov    %ecx,%edx
80102922:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102923:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102926:	89 fa                	mov    %edi,%edx
80102928:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010292b:	b8 09 00 00 00       	mov    $0x9,%eax
80102930:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102931:	89 ca                	mov    %ecx,%edx
80102933:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102934:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102937:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
8010293a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010293d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102940:	6a 18                	push   $0x18
80102942:	56                   	push   %esi
80102943:	50                   	push   %eax
80102944:	e8 87 1b 00 00       	call   801044d0 <memcmp>
80102949:	83 c4 10             	add    $0x10,%esp
8010294c:	85 c0                	test   %eax,%eax
8010294e:	0f 85 0c ff ff ff    	jne    80102860 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102954:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102958:	75 78                	jne    801029d2 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010295a:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010295d:	89 c2                	mov    %eax,%edx
8010295f:	83 e0 0f             	and    $0xf,%eax
80102962:	c1 ea 04             	shr    $0x4,%edx
80102965:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102968:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010296b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010296e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102971:	89 c2                	mov    %eax,%edx
80102973:	83 e0 0f             	and    $0xf,%eax
80102976:	c1 ea 04             	shr    $0x4,%edx
80102979:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010297c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010297f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102982:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102985:	89 c2                	mov    %eax,%edx
80102987:	83 e0 0f             	and    $0xf,%eax
8010298a:	c1 ea 04             	shr    $0x4,%edx
8010298d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102990:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102993:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102996:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102999:	89 c2                	mov    %eax,%edx
8010299b:	83 e0 0f             	and    $0xf,%eax
8010299e:	c1 ea 04             	shr    $0x4,%edx
801029a1:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029a4:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029a7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029aa:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029ad:	89 c2                	mov    %eax,%edx
801029af:	83 e0 0f             	and    $0xf,%eax
801029b2:	c1 ea 04             	shr    $0x4,%edx
801029b5:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029b8:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029bb:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029be:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029c1:	89 c2                	mov    %eax,%edx
801029c3:	83 e0 0f             	and    $0xf,%eax
801029c6:	c1 ea 04             	shr    $0x4,%edx
801029c9:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029cc:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029cf:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029d2:	8b 75 08             	mov    0x8(%ebp),%esi
801029d5:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029d8:	89 06                	mov    %eax,(%esi)
801029da:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029dd:	89 46 04             	mov    %eax,0x4(%esi)
801029e0:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029e3:	89 46 08             	mov    %eax,0x8(%esi)
801029e6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029e9:	89 46 0c             	mov    %eax,0xc(%esi)
801029ec:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029ef:	89 46 10             	mov    %eax,0x10(%esi)
801029f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029f5:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029f8:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801029ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a02:	5b                   	pop    %ebx
80102a03:	5e                   	pop    %esi
80102a04:	5f                   	pop    %edi
80102a05:	5d                   	pop    %ebp
80102a06:	c3                   	ret    
80102a07:	66 90                	xchg   %ax,%ax
80102a09:	66 90                	xchg   %ax,%ax
80102a0b:	66 90                	xchg   %ax,%ax
80102a0d:	66 90                	xchg   %ax,%ax
80102a0f:	90                   	nop

80102a10 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a10:	8b 0d 48 33 11 80    	mov    0x80113348,%ecx
80102a16:	85 c9                	test   %ecx,%ecx
80102a18:	0f 8e 85 00 00 00    	jle    80102aa3 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102a1e:	55                   	push   %ebp
80102a1f:	89 e5                	mov    %esp,%ebp
80102a21:	57                   	push   %edi
80102a22:	56                   	push   %esi
80102a23:	53                   	push   %ebx
80102a24:	31 db                	xor    %ebx,%ebx
80102a26:	83 ec 0c             	sub    $0xc,%esp
80102a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a30:	a1 34 33 11 80       	mov    0x80113334,%eax
80102a35:	83 ec 08             	sub    $0x8,%esp
80102a38:	01 d8                	add    %ebx,%eax
80102a3a:	83 c0 01             	add    $0x1,%eax
80102a3d:	50                   	push   %eax
80102a3e:	ff 35 44 33 11 80    	pushl  0x80113344
80102a44:	e8 87 d6 ff ff       	call   801000d0 <bread>
80102a49:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a4b:	58                   	pop    %eax
80102a4c:	5a                   	pop    %edx
80102a4d:	ff 34 9d 4c 33 11 80 	pushl  -0x7feeccb4(,%ebx,4)
80102a54:	ff 35 44 33 11 80    	pushl  0x80113344
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a5a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a5d:	e8 6e d6 ff ff       	call   801000d0 <bread>
80102a62:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a64:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a67:	83 c4 0c             	add    $0xc,%esp
80102a6a:	68 00 02 00 00       	push   $0x200
80102a6f:	50                   	push   %eax
80102a70:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a73:	50                   	push   %eax
80102a74:	e8 b7 1a 00 00       	call   80104530 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 1f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a81:	89 3c 24             	mov    %edi,(%esp)
80102a84:	e8 57 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a89:	89 34 24             	mov    %esi,(%esp)
80102a8c:	e8 4f d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a91:	83 c4 10             	add    $0x10,%esp
80102a94:	39 1d 48 33 11 80    	cmp    %ebx,0x80113348
80102a9a:	7f 94                	jg     80102a30 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a9f:	5b                   	pop    %ebx
80102aa0:	5e                   	pop    %esi
80102aa1:	5f                   	pop    %edi
80102aa2:	5d                   	pop    %ebp
80102aa3:	f3 c3                	repz ret 
80102aa5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ab0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ab0:	55                   	push   %ebp
80102ab1:	89 e5                	mov    %esp,%ebp
80102ab3:	53                   	push   %ebx
80102ab4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ab7:	ff 35 34 33 11 80    	pushl  0x80113334
80102abd:	ff 35 44 33 11 80    	pushl  0x80113344
80102ac3:	e8 08 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ac8:	8b 0d 48 33 11 80    	mov    0x80113348,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ace:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102ad1:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ad3:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ad5:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ad8:	7e 1f                	jle    80102af9 <write_head+0x49>
80102ada:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102ae1:	31 d2                	xor    %edx,%edx
80102ae3:	90                   	nop
80102ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102ae8:	8b 8a 4c 33 11 80    	mov    -0x7feeccb4(%edx),%ecx
80102aee:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102af2:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102af5:	39 c2                	cmp    %eax,%edx
80102af7:	75 ef                	jne    80102ae8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102af9:	83 ec 0c             	sub    $0xc,%esp
80102afc:	53                   	push   %ebx
80102afd:	e8 9e d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b02:	89 1c 24             	mov    %ebx,(%esp)
80102b05:	e8 d6 d6 ff ff       	call   801001e0 <brelse>
}
80102b0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b0d:	c9                   	leave  
80102b0e:	c3                   	ret    
80102b0f:	90                   	nop

80102b10 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	53                   	push   %ebx
80102b14:	83 ec 2c             	sub    $0x2c,%esp
80102b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102b1a:	68 60 74 10 80       	push   $0x80107460
80102b1f:	68 00 33 11 80       	push   $0x80113300
80102b24:	e8 f7 16 00 00       	call   80104220 <initlock>
  readsb(dev, &sb);
80102b29:	58                   	pop    %eax
80102b2a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b2d:	5a                   	pop    %edx
80102b2e:	50                   	push   %eax
80102b2f:	53                   	push   %ebx
80102b30:	e8 eb e8 ff ff       	call   80101420 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b35:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b38:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b3b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102b3c:	89 1d 44 33 11 80    	mov    %ebx,0x80113344

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b42:	89 15 38 33 11 80    	mov    %edx,0x80113338
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b48:	a3 34 33 11 80       	mov    %eax,0x80113334

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b4d:	5a                   	pop    %edx
80102b4e:	50                   	push   %eax
80102b4f:	53                   	push   %ebx
80102b50:	e8 7b d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b55:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102b58:	83 c4 10             	add    $0x10,%esp
80102b5b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b5d:	89 0d 48 33 11 80    	mov    %ecx,0x80113348
  for (i = 0; i < log.lh.n; i++) {
80102b63:	7e 1c                	jle    80102b81 <initlog+0x71>
80102b65:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102b6c:	31 d2                	xor    %edx,%edx
80102b6e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102b70:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b74:	83 c2 04             	add    $0x4,%edx
80102b77:	89 8a 48 33 11 80    	mov    %ecx,-0x7feeccb8(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b7d:	39 da                	cmp    %ebx,%edx
80102b7f:	75 ef                	jne    80102b70 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b81:	83 ec 0c             	sub    $0xc,%esp
80102b84:	50                   	push   %eax
80102b85:	e8 56 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b8a:	e8 81 fe ff ff       	call   80102a10 <install_trans>
  log.lh.n = 0;
80102b8f:	c7 05 48 33 11 80 00 	movl   $0x0,0x80113348
80102b96:	00 00 00 
  write_head(); // clear the log
80102b99:	e8 12 ff ff ff       	call   80102ab0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ba1:	c9                   	leave  
80102ba2:	c3                   	ret    
80102ba3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bb0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bb0:	55                   	push   %ebp
80102bb1:	89 e5                	mov    %esp,%ebp
80102bb3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102bb6:	68 00 33 11 80       	push   $0x80113300
80102bbb:	e8 c0 17 00 00       	call   80104380 <acquire>
80102bc0:	83 c4 10             	add    $0x10,%esp
80102bc3:	eb 18                	jmp    80102bdd <begin_op+0x2d>
80102bc5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bc8:	83 ec 08             	sub    $0x8,%esp
80102bcb:	68 00 33 11 80       	push   $0x80113300
80102bd0:	68 00 33 11 80       	push   $0x80113300
80102bd5:	e8 b6 11 00 00       	call   80103d90 <sleep>
80102bda:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102bdd:	a1 40 33 11 80       	mov    0x80113340,%eax
80102be2:	85 c0                	test   %eax,%eax
80102be4:	75 e2                	jne    80102bc8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102be6:	a1 3c 33 11 80       	mov    0x8011333c,%eax
80102beb:	8b 15 48 33 11 80    	mov    0x80113348,%edx
80102bf1:	83 c0 01             	add    $0x1,%eax
80102bf4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102bf7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bfa:	83 fa 1e             	cmp    $0x1e,%edx
80102bfd:	7f c9                	jg     80102bc8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bff:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102c02:	a3 3c 33 11 80       	mov    %eax,0x8011333c
      release(&log.lock);
80102c07:	68 00 33 11 80       	push   $0x80113300
80102c0c:	e8 1f 18 00 00       	call   80104430 <release>
      break;
    }
  }
}
80102c11:	83 c4 10             	add    $0x10,%esp
80102c14:	c9                   	leave  
80102c15:	c3                   	ret    
80102c16:	8d 76 00             	lea    0x0(%esi),%esi
80102c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c20 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	57                   	push   %edi
80102c24:	56                   	push   %esi
80102c25:	53                   	push   %ebx
80102c26:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c29:	68 00 33 11 80       	push   $0x80113300
80102c2e:	e8 4d 17 00 00       	call   80104380 <acquire>
  log.outstanding -= 1;
80102c33:	a1 3c 33 11 80       	mov    0x8011333c,%eax
  if(log.committing)
80102c38:	8b 1d 40 33 11 80    	mov    0x80113340,%ebx
80102c3e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c41:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c44:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c46:	a3 3c 33 11 80       	mov    %eax,0x8011333c
  if(log.committing)
80102c4b:	0f 85 23 01 00 00    	jne    80102d74 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102c51:	85 c0                	test   %eax,%eax
80102c53:	0f 85 f7 00 00 00    	jne    80102d50 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c59:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102c5c:	c7 05 40 33 11 80 01 	movl   $0x1,0x80113340
80102c63:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c66:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c68:	68 00 33 11 80       	push   $0x80113300
80102c6d:	e8 be 17 00 00       	call   80104430 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c72:	8b 0d 48 33 11 80    	mov    0x80113348,%ecx
80102c78:	83 c4 10             	add    $0x10,%esp
80102c7b:	85 c9                	test   %ecx,%ecx
80102c7d:	0f 8e 8a 00 00 00    	jle    80102d0d <end_op+0xed>
80102c83:	90                   	nop
80102c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c88:	a1 34 33 11 80       	mov    0x80113334,%eax
80102c8d:	83 ec 08             	sub    $0x8,%esp
80102c90:	01 d8                	add    %ebx,%eax
80102c92:	83 c0 01             	add    $0x1,%eax
80102c95:	50                   	push   %eax
80102c96:	ff 35 44 33 11 80    	pushl  0x80113344
80102c9c:	e8 2f d4 ff ff       	call   801000d0 <bread>
80102ca1:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ca3:	58                   	pop    %eax
80102ca4:	5a                   	pop    %edx
80102ca5:	ff 34 9d 4c 33 11 80 	pushl  -0x7feeccb4(,%ebx,4)
80102cac:	ff 35 44 33 11 80    	pushl  0x80113344
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cb2:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cb5:	e8 16 d4 ff ff       	call   801000d0 <bread>
80102cba:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102cbc:	8d 40 5c             	lea    0x5c(%eax),%eax
80102cbf:	83 c4 0c             	add    $0xc,%esp
80102cc2:	68 00 02 00 00       	push   $0x200
80102cc7:	50                   	push   %eax
80102cc8:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ccb:	50                   	push   %eax
80102ccc:	e8 5f 18 00 00       	call   80104530 <memmove>
    bwrite(to);  // write the log
80102cd1:	89 34 24             	mov    %esi,(%esp)
80102cd4:	e8 c7 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cd9:	89 3c 24             	mov    %edi,(%esp)
80102cdc:	e8 ff d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ce1:	89 34 24             	mov    %esi,(%esp)
80102ce4:	e8 f7 d4 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ce9:	83 c4 10             	add    $0x10,%esp
80102cec:	3b 1d 48 33 11 80    	cmp    0x80113348,%ebx
80102cf2:	7c 94                	jl     80102c88 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cf4:	e8 b7 fd ff ff       	call   80102ab0 <write_head>
    install_trans(); // Now install writes to home locations
80102cf9:	e8 12 fd ff ff       	call   80102a10 <install_trans>
    log.lh.n = 0;
80102cfe:	c7 05 48 33 11 80 00 	movl   $0x0,0x80113348
80102d05:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d08:	e8 a3 fd ff ff       	call   80102ab0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102d0d:	83 ec 0c             	sub    $0xc,%esp
80102d10:	68 00 33 11 80       	push   $0x80113300
80102d15:	e8 66 16 00 00       	call   80104380 <acquire>
    log.committing = 0;
    wakeup(&log);
80102d1a:	c7 04 24 00 33 11 80 	movl   $0x80113300,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102d21:	c7 05 40 33 11 80 00 	movl   $0x0,0x80113340
80102d28:	00 00 00 
    wakeup(&log);
80102d2b:	e8 10 12 00 00       	call   80103f40 <wakeup>
    release(&log.lock);
80102d30:	c7 04 24 00 33 11 80 	movl   $0x80113300,(%esp)
80102d37:	e8 f4 16 00 00       	call   80104430 <release>
80102d3c:	83 c4 10             	add    $0x10,%esp
  }
}
80102d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d42:	5b                   	pop    %ebx
80102d43:	5e                   	pop    %esi
80102d44:	5f                   	pop    %edi
80102d45:	5d                   	pop    %ebp
80102d46:	c3                   	ret    
80102d47:	89 f6                	mov    %esi,%esi
80102d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102d50:	83 ec 0c             	sub    $0xc,%esp
80102d53:	68 00 33 11 80       	push   $0x80113300
80102d58:	e8 e3 11 00 00       	call   80103f40 <wakeup>
  }
  release(&log.lock);
80102d5d:	c7 04 24 00 33 11 80 	movl   $0x80113300,(%esp)
80102d64:	e8 c7 16 00 00       	call   80104430 <release>
80102d69:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102d6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d6f:	5b                   	pop    %ebx
80102d70:	5e                   	pop    %esi
80102d71:	5f                   	pop    %edi
80102d72:	5d                   	pop    %ebp
80102d73:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d74:	83 ec 0c             	sub    $0xc,%esp
80102d77:	68 64 74 10 80       	push   $0x80107464
80102d7c:	e8 ef d5 ff ff       	call   80100370 <panic>
80102d81:	eb 0d                	jmp    80102d90 <log_write>
80102d83:	90                   	nop
80102d84:	90                   	nop
80102d85:	90                   	nop
80102d86:	90                   	nop
80102d87:	90                   	nop
80102d88:	90                   	nop
80102d89:	90                   	nop
80102d8a:	90                   	nop
80102d8b:	90                   	nop
80102d8c:	90                   	nop
80102d8d:	90                   	nop
80102d8e:	90                   	nop
80102d8f:	90                   	nop

80102d90 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	53                   	push   %ebx
80102d94:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d97:	8b 15 48 33 11 80    	mov    0x80113348,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102da0:	83 fa 1d             	cmp    $0x1d,%edx
80102da3:	0f 8f 97 00 00 00    	jg     80102e40 <log_write+0xb0>
80102da9:	a1 38 33 11 80       	mov    0x80113338,%eax
80102dae:	83 e8 01             	sub    $0x1,%eax
80102db1:	39 c2                	cmp    %eax,%edx
80102db3:	0f 8d 87 00 00 00    	jge    80102e40 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102db9:	a1 3c 33 11 80       	mov    0x8011333c,%eax
80102dbe:	85 c0                	test   %eax,%eax
80102dc0:	0f 8e 87 00 00 00    	jle    80102e4d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102dc6:	83 ec 0c             	sub    $0xc,%esp
80102dc9:	68 00 33 11 80       	push   $0x80113300
80102dce:	e8 ad 15 00 00       	call   80104380 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102dd3:	8b 15 48 33 11 80    	mov    0x80113348,%edx
80102dd9:	83 c4 10             	add    $0x10,%esp
80102ddc:	83 fa 00             	cmp    $0x0,%edx
80102ddf:	7e 50                	jle    80102e31 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102de1:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102de4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102de6:	3b 0d 4c 33 11 80    	cmp    0x8011334c,%ecx
80102dec:	75 0b                	jne    80102df9 <log_write+0x69>
80102dee:	eb 38                	jmp    80102e28 <log_write+0x98>
80102df0:	39 0c 85 4c 33 11 80 	cmp    %ecx,-0x7feeccb4(,%eax,4)
80102df7:	74 2f                	je     80102e28 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102df9:	83 c0 01             	add    $0x1,%eax
80102dfc:	39 d0                	cmp    %edx,%eax
80102dfe:	75 f0                	jne    80102df0 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102e00:	89 0c 95 4c 33 11 80 	mov    %ecx,-0x7feeccb4(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e07:	83 c2 01             	add    $0x1,%edx
80102e0a:	89 15 48 33 11 80    	mov    %edx,0x80113348
  b->flags |= B_DIRTY; // prevent eviction
80102e10:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e13:	c7 45 08 00 33 11 80 	movl   $0x80113300,0x8(%ebp)
}
80102e1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e1d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102e1e:	e9 0d 16 00 00       	jmp    80104430 <release>
80102e23:	90                   	nop
80102e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102e28:	89 0c 85 4c 33 11 80 	mov    %ecx,-0x7feeccb4(,%eax,4)
80102e2f:	eb df                	jmp    80102e10 <log_write+0x80>
80102e31:	8b 43 08             	mov    0x8(%ebx),%eax
80102e34:	a3 4c 33 11 80       	mov    %eax,0x8011334c
  if (i == log.lh.n)
80102e39:	75 d5                	jne    80102e10 <log_write+0x80>
80102e3b:	eb ca                	jmp    80102e07 <log_write+0x77>
80102e3d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102e40:	83 ec 0c             	sub    $0xc,%esp
80102e43:	68 73 74 10 80       	push   $0x80107473
80102e48:	e8 23 d5 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102e4d:	83 ec 0c             	sub    $0xc,%esp
80102e50:	68 89 74 10 80       	push   $0x80107489
80102e55:	e8 16 d5 ff ff       	call   80100370 <panic>
80102e5a:	66 90                	xchg   %ax,%ax
80102e5c:	66 90                	xchg   %ax,%ax
80102e5e:	66 90                	xchg   %ax,%ax

80102e60 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	53                   	push   %ebx
80102e64:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e67:	e8 54 09 00 00       	call   801037c0 <cpuid>
80102e6c:	89 c3                	mov    %eax,%ebx
80102e6e:	e8 4d 09 00 00       	call   801037c0 <cpuid>
80102e73:	83 ec 04             	sub    $0x4,%esp
80102e76:	53                   	push   %ebx
80102e77:	50                   	push   %eax
80102e78:	68 a4 74 10 80       	push   $0x801074a4
80102e7d:	e8 de d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e82:	e8 39 29 00 00       	call   801057c0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e87:	e8 b4 08 00 00       	call   80103740 <mycpu>
80102e8c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e8e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e93:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e9a:	e8 01 0c 00 00       	call   80103aa0 <scheduler>
80102e9f:	90                   	nop

80102ea0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ea6:	e8 35 3a 00 00       	call   801068e0 <switchkvm>
  seginit();
80102eab:	e8 30 39 00 00       	call   801067e0 <seginit>
  lapicinit();
80102eb0:	e8 9b f7 ff ff       	call   80102650 <lapicinit>
  mpmain();
80102eb5:	e8 a6 ff ff ff       	call   80102e60 <mpmain>
80102eba:	66 90                	xchg   %ax,%ax
80102ebc:	66 90                	xchg   %ax,%ax
80102ebe:	66 90                	xchg   %ax,%ax

80102ec0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102ec0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ec4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ec7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eca:	55                   	push   %ebp
80102ecb:	89 e5                	mov    %esp,%ebp
80102ecd:	53                   	push   %ebx
80102ece:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102ecf:	bb 00 34 11 80       	mov    $0x80113400,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102ed4:	83 ec 08             	sub    $0x8,%esp
80102ed7:	68 00 00 40 80       	push   $0x80400000
80102edc:	68 28 61 11 80       	push   $0x80116128
80102ee1:	e8 3a f5 ff ff       	call   80102420 <kinit1>
  kvmalloc();      // kernel page table
80102ee6:	e8 95 3e 00 00       	call   80106d80 <kvmalloc>
  mpinit();        // detect other processors
80102eeb:	e8 70 01 00 00       	call   80103060 <mpinit>
  lapicinit();     // interrupt controller
80102ef0:	e8 5b f7 ff ff       	call   80102650 <lapicinit>
  seginit();       // segment descriptors
80102ef5:	e8 e6 38 00 00       	call   801067e0 <seginit>
  picinit();       // disable pic
80102efa:	e8 31 03 00 00       	call   80103230 <picinit>
  ioapicinit();    // another interrupt controller
80102eff:	e8 4c f3 ff ff       	call   80102250 <ioapicinit>
  consoleinit();   // console hardware
80102f04:	e8 97 da ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102f09:	e8 a2 2b 00 00       	call   80105ab0 <uartinit>
  pinit();         // process table
80102f0e:	e8 0d 08 00 00       	call   80103720 <pinit>
  tvinit();        // trap vectors
80102f13:	e8 08 28 00 00       	call   80105720 <tvinit>
  binit();         // buffer cache
80102f18:	e8 23 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f1d:	e8 2e de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102f22:	e8 09 f1 ff ff       	call   80102030 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f27:	83 c4 0c             	add    $0xc,%esp
80102f2a:	68 8a 00 00 00       	push   $0x8a
80102f2f:	68 8c a4 10 80       	push   $0x8010a48c
80102f34:	68 00 70 00 80       	push   $0x80007000
80102f39:	e8 f2 15 00 00       	call   80104530 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f3e:	69 05 80 39 11 80 b0 	imul   $0xb0,0x80113980,%eax
80102f45:	00 00 00 
80102f48:	83 c4 10             	add    $0x10,%esp
80102f4b:	05 00 34 11 80       	add    $0x80113400,%eax
80102f50:	39 d8                	cmp    %ebx,%eax
80102f52:	76 6f                	jbe    80102fc3 <main+0x103>
80102f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102f58:	e8 e3 07 00 00       	call   80103740 <mycpu>
80102f5d:	39 d8                	cmp    %ebx,%eax
80102f5f:	74 49                	je     80102faa <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f61:	e8 8a f5 ff ff       	call   801024f0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f66:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f6b:	c7 05 f8 6f 00 80 a0 	movl   $0x80102ea0,0x80006ff8
80102f72:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f75:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f7c:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f7f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f84:	0f b6 03             	movzbl (%ebx),%eax
80102f87:	83 ec 08             	sub    $0x8,%esp
80102f8a:	68 00 70 00 00       	push   $0x7000
80102f8f:	50                   	push   %eax
80102f90:	e8 0b f8 ff ff       	call   801027a0 <lapicstartap>
80102f95:	83 c4 10             	add    $0x10,%esp
80102f98:	90                   	nop
80102f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fa0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102fa6:	85 c0                	test   %eax,%eax
80102fa8:	74 f6                	je     80102fa0 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102faa:	69 05 80 39 11 80 b0 	imul   $0xb0,0x80113980,%eax
80102fb1:	00 00 00 
80102fb4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102fba:	05 00 34 11 80       	add    $0x80113400,%eax
80102fbf:	39 c3                	cmp    %eax,%ebx
80102fc1:	72 95                	jb     80102f58 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fc3:	83 ec 08             	sub    $0x8,%esp
80102fc6:	68 00 00 00 8e       	push   $0x8e000000
80102fcb:	68 00 00 40 80       	push   $0x80400000
80102fd0:	e8 bb f4 ff ff       	call   80102490 <kinit2>
  userinit();      // first user process
80102fd5:	e8 36 08 00 00       	call   80103810 <userinit>
  mpmain();        // finish this processor's setup
80102fda:	e8 81 fe ff ff       	call   80102e60 <mpmain>
80102fdf:	90                   	nop

80102fe0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	57                   	push   %edi
80102fe4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fe5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102feb:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102fec:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fef:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102ff2:	39 de                	cmp    %ebx,%esi
80102ff4:	73 48                	jae    8010303e <mpsearch1+0x5e>
80102ff6:	8d 76 00             	lea    0x0(%esi),%esi
80102ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103000:	83 ec 04             	sub    $0x4,%esp
80103003:	8d 7e 10             	lea    0x10(%esi),%edi
80103006:	6a 04                	push   $0x4
80103008:	68 b8 74 10 80       	push   $0x801074b8
8010300d:	56                   	push   %esi
8010300e:	e8 bd 14 00 00       	call   801044d0 <memcmp>
80103013:	83 c4 10             	add    $0x10,%esp
80103016:	85 c0                	test   %eax,%eax
80103018:	75 1e                	jne    80103038 <mpsearch1+0x58>
8010301a:	8d 7e 10             	lea    0x10(%esi),%edi
8010301d:	89 f2                	mov    %esi,%edx
8010301f:	31 c9                	xor    %ecx,%ecx
80103021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103028:	0f b6 02             	movzbl (%edx),%eax
8010302b:	83 c2 01             	add    $0x1,%edx
8010302e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103030:	39 fa                	cmp    %edi,%edx
80103032:	75 f4                	jne    80103028 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103034:	84 c9                	test   %cl,%cl
80103036:	74 10                	je     80103048 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103038:	39 fb                	cmp    %edi,%ebx
8010303a:	89 fe                	mov    %edi,%esi
8010303c:	77 c2                	ja     80103000 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010303e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103041:	31 c0                	xor    %eax,%eax
}
80103043:	5b                   	pop    %ebx
80103044:	5e                   	pop    %esi
80103045:	5f                   	pop    %edi
80103046:	5d                   	pop    %ebp
80103047:	c3                   	ret    
80103048:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010304b:	89 f0                	mov    %esi,%eax
8010304d:	5b                   	pop    %ebx
8010304e:	5e                   	pop    %esi
8010304f:	5f                   	pop    %edi
80103050:	5d                   	pop    %ebp
80103051:	c3                   	ret    
80103052:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103060 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	57                   	push   %edi
80103064:	56                   	push   %esi
80103065:	53                   	push   %ebx
80103066:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103069:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103070:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103077:	c1 e0 08             	shl    $0x8,%eax
8010307a:	09 d0                	or     %edx,%eax
8010307c:	c1 e0 04             	shl    $0x4,%eax
8010307f:	85 c0                	test   %eax,%eax
80103081:	75 1b                	jne    8010309e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103083:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010308a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103091:	c1 e0 08             	shl    $0x8,%eax
80103094:	09 d0                	or     %edx,%eax
80103096:	c1 e0 0a             	shl    $0xa,%eax
80103099:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010309e:	ba 00 04 00 00       	mov    $0x400,%edx
801030a3:	e8 38 ff ff ff       	call   80102fe0 <mpsearch1>
801030a8:	85 c0                	test   %eax,%eax
801030aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801030ad:	0f 84 37 01 00 00    	je     801031ea <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030b6:	8b 58 04             	mov    0x4(%eax),%ebx
801030b9:	85 db                	test   %ebx,%ebx
801030bb:	0f 84 43 01 00 00    	je     80103204 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030c1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030c7:	83 ec 04             	sub    $0x4,%esp
801030ca:	6a 04                	push   $0x4
801030cc:	68 bd 74 10 80       	push   $0x801074bd
801030d1:	56                   	push   %esi
801030d2:	e8 f9 13 00 00       	call   801044d0 <memcmp>
801030d7:	83 c4 10             	add    $0x10,%esp
801030da:	85 c0                	test   %eax,%eax
801030dc:	0f 85 22 01 00 00    	jne    80103204 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
801030e2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030e9:	3c 01                	cmp    $0x1,%al
801030eb:	74 08                	je     801030f5 <mpinit+0x95>
801030ed:	3c 04                	cmp    $0x4,%al
801030ef:	0f 85 0f 01 00 00    	jne    80103204 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030f5:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030fc:	85 ff                	test   %edi,%edi
801030fe:	74 21                	je     80103121 <mpinit+0xc1>
80103100:	31 d2                	xor    %edx,%edx
80103102:	31 c0                	xor    %eax,%eax
80103104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103108:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010310f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103110:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103113:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103115:	39 c7                	cmp    %eax,%edi
80103117:	75 ef                	jne    80103108 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103119:	84 d2                	test   %dl,%dl
8010311b:	0f 85 e3 00 00 00    	jne    80103204 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103121:	85 f6                	test   %esi,%esi
80103123:	0f 84 db 00 00 00    	je     80103204 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103129:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010312f:	a3 fc 32 11 80       	mov    %eax,0x801132fc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103134:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
8010313b:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103141:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103146:	01 d6                	add    %edx,%esi
80103148:	90                   	nop
80103149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103150:	39 c6                	cmp    %eax,%esi
80103152:	76 23                	jbe    80103177 <mpinit+0x117>
80103154:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
80103157:	80 fa 04             	cmp    $0x4,%dl
8010315a:	0f 87 c0 00 00 00    	ja     80103220 <mpinit+0x1c0>
80103160:	ff 24 95 fc 74 10 80 	jmp    *-0x7fef8b04(,%edx,4)
80103167:	89 f6                	mov    %esi,%esi
80103169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103170:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103173:	39 c6                	cmp    %eax,%esi
80103175:	77 dd                	ja     80103154 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103177:	85 db                	test   %ebx,%ebx
80103179:	0f 84 92 00 00 00    	je     80103211 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010317f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103182:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103186:	74 15                	je     8010319d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103188:	ba 22 00 00 00       	mov    $0x22,%edx
8010318d:	b8 70 00 00 00       	mov    $0x70,%eax
80103192:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103193:	ba 23 00 00 00       	mov    $0x23,%edx
80103198:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103199:	83 c8 01             	or     $0x1,%eax
8010319c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010319d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031a0:	5b                   	pop    %ebx
801031a1:	5e                   	pop    %esi
801031a2:	5f                   	pop    %edi
801031a3:	5d                   	pop    %ebp
801031a4:	c3                   	ret    
801031a5:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801031a8:	8b 0d 80 39 11 80    	mov    0x80113980,%ecx
801031ae:	83 f9 07             	cmp    $0x7,%ecx
801031b1:	7f 19                	jg     801031cc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031b3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031b7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801031bd:	83 c1 01             	add    $0x1,%ecx
801031c0:	89 0d 80 39 11 80    	mov    %ecx,0x80113980
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031c6:	88 97 00 34 11 80    	mov    %dl,-0x7feecc00(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
801031cc:	83 c0 14             	add    $0x14,%eax
      continue;
801031cf:	e9 7c ff ff ff       	jmp    80103150 <mpinit+0xf0>
801031d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801031d8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031dc:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801031df:	88 15 e0 33 11 80    	mov    %dl,0x801133e0
      p += sizeof(struct mpioapic);
      continue;
801031e5:	e9 66 ff ff ff       	jmp    80103150 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801031ea:	ba 00 00 01 00       	mov    $0x10000,%edx
801031ef:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031f4:	e8 e7 fd ff ff       	call   80102fe0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031f9:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801031fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031fe:	0f 85 af fe ff ff    	jne    801030b3 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103204:	83 ec 0c             	sub    $0xc,%esp
80103207:	68 c2 74 10 80       	push   $0x801074c2
8010320c:	e8 5f d1 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
80103211:	83 ec 0c             	sub    $0xc,%esp
80103214:	68 dc 74 10 80       	push   $0x801074dc
80103219:	e8 52 d1 ff ff       	call   80100370 <panic>
8010321e:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103220:	31 db                	xor    %ebx,%ebx
80103222:	e9 30 ff ff ff       	jmp    80103157 <mpinit+0xf7>
80103227:	66 90                	xchg   %ax,%ax
80103229:	66 90                	xchg   %ax,%ax
8010322b:	66 90                	xchg   %ax,%ax
8010322d:	66 90                	xchg   %ax,%ax
8010322f:	90                   	nop

80103230 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103230:	55                   	push   %ebp
80103231:	ba 21 00 00 00       	mov    $0x21,%edx
80103236:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010323b:	89 e5                	mov    %esp,%ebp
8010323d:	ee                   	out    %al,(%dx)
8010323e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103243:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103244:	5d                   	pop    %ebp
80103245:	c3                   	ret    
80103246:	66 90                	xchg   %ax,%ax
80103248:	66 90                	xchg   %ax,%ax
8010324a:	66 90                	xchg   %ax,%ax
8010324c:	66 90                	xchg   %ax,%ax
8010324e:	66 90                	xchg   %ax,%ax

80103250 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	57                   	push   %edi
80103254:	56                   	push   %esi
80103255:	53                   	push   %ebx
80103256:	83 ec 0c             	sub    $0xc,%esp
80103259:	8b 75 08             	mov    0x8(%ebp),%esi
8010325c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010325f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103265:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010326b:	e8 00 db ff ff       	call   80100d70 <filealloc>
80103270:	85 c0                	test   %eax,%eax
80103272:	89 06                	mov    %eax,(%esi)
80103274:	0f 84 a8 00 00 00    	je     80103322 <pipealloc+0xd2>
8010327a:	e8 f1 da ff ff       	call   80100d70 <filealloc>
8010327f:	85 c0                	test   %eax,%eax
80103281:	89 03                	mov    %eax,(%ebx)
80103283:	0f 84 87 00 00 00    	je     80103310 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103289:	e8 62 f2 ff ff       	call   801024f0 <kalloc>
8010328e:	85 c0                	test   %eax,%eax
80103290:	89 c7                	mov    %eax,%edi
80103292:	0f 84 b0 00 00 00    	je     80103348 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103298:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010329b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032a2:	00 00 00 
  p->writeopen = 1;
801032a5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032ac:	00 00 00 
  p->nwrite = 0;
801032af:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032b6:	00 00 00 
  p->nread = 0;
801032b9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801032c0:	00 00 00 
  initlock(&p->lock, "pipe");
801032c3:	68 10 75 10 80       	push   $0x80107510
801032c8:	50                   	push   %eax
801032c9:	e8 52 0f 00 00       	call   80104220 <initlock>
  (*f0)->type = FD_PIPE;
801032ce:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801032d0:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
801032d3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801032d9:	8b 06                	mov    (%esi),%eax
801032db:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801032df:	8b 06                	mov    (%esi),%eax
801032e1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801032e5:	8b 06                	mov    (%esi),%eax
801032e7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801032ea:	8b 03                	mov    (%ebx),%eax
801032ec:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801032f2:	8b 03                	mov    (%ebx),%eax
801032f4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801032f8:	8b 03                	mov    (%ebx),%eax
801032fa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801032fe:	8b 03                	mov    (%ebx),%eax
80103300:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103303:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103306:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103308:	5b                   	pop    %ebx
80103309:	5e                   	pop    %esi
8010330a:	5f                   	pop    %edi
8010330b:	5d                   	pop    %ebp
8010330c:	c3                   	ret    
8010330d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103310:	8b 06                	mov    (%esi),%eax
80103312:	85 c0                	test   %eax,%eax
80103314:	74 1e                	je     80103334 <pipealloc+0xe4>
    fileclose(*f0);
80103316:	83 ec 0c             	sub    $0xc,%esp
80103319:	50                   	push   %eax
8010331a:	e8 11 db ff ff       	call   80100e30 <fileclose>
8010331f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103322:	8b 03                	mov    (%ebx),%eax
80103324:	85 c0                	test   %eax,%eax
80103326:	74 0c                	je     80103334 <pipealloc+0xe4>
    fileclose(*f1);
80103328:	83 ec 0c             	sub    $0xc,%esp
8010332b:	50                   	push   %eax
8010332c:	e8 ff da ff ff       	call   80100e30 <fileclose>
80103331:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103334:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103337:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010333c:	5b                   	pop    %ebx
8010333d:	5e                   	pop    %esi
8010333e:	5f                   	pop    %edi
8010333f:	5d                   	pop    %ebp
80103340:	c3                   	ret    
80103341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103348:	8b 06                	mov    (%esi),%eax
8010334a:	85 c0                	test   %eax,%eax
8010334c:	75 c8                	jne    80103316 <pipealloc+0xc6>
8010334e:	eb d2                	jmp    80103322 <pipealloc+0xd2>

80103350 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	56                   	push   %esi
80103354:	53                   	push   %ebx
80103355:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103358:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010335b:	83 ec 0c             	sub    $0xc,%esp
8010335e:	53                   	push   %ebx
8010335f:	e8 1c 10 00 00       	call   80104380 <acquire>
  if(writable){
80103364:	83 c4 10             	add    $0x10,%esp
80103367:	85 f6                	test   %esi,%esi
80103369:	74 45                	je     801033b0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010336b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103371:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103374:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010337b:	00 00 00 
    wakeup(&p->nread);
8010337e:	50                   	push   %eax
8010337f:	e8 bc 0b 00 00       	call   80103f40 <wakeup>
80103384:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103387:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010338d:	85 d2                	test   %edx,%edx
8010338f:	75 0a                	jne    8010339b <pipeclose+0x4b>
80103391:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103397:	85 c0                	test   %eax,%eax
80103399:	74 35                	je     801033d0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010339b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010339e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033a1:	5b                   	pop    %ebx
801033a2:	5e                   	pop    %esi
801033a3:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033a4:	e9 87 10 00 00       	jmp    80104430 <release>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801033b0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033b6:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801033b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033c0:	00 00 00 
    wakeup(&p->nwrite);
801033c3:	50                   	push   %eax
801033c4:	e8 77 0b 00 00       	call   80103f40 <wakeup>
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	eb b9                	jmp    80103387 <pipeclose+0x37>
801033ce:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801033d0:	83 ec 0c             	sub    $0xc,%esp
801033d3:	53                   	push   %ebx
801033d4:	e8 57 10 00 00       	call   80104430 <release>
    kfree((char*)p);
801033d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033dc:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
801033df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033e2:	5b                   	pop    %ebx
801033e3:	5e                   	pop    %esi
801033e4:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801033e5:	e9 56 ef ff ff       	jmp    80102340 <kfree>
801033ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801033f0 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 28             	sub    $0x28,%esp
801033f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801033fc:	53                   	push   %ebx
801033fd:	e8 7e 0f 00 00       	call   80104380 <acquire>
  for(i = 0; i < n; i++){
80103402:	8b 45 10             	mov    0x10(%ebp),%eax
80103405:	83 c4 10             	add    $0x10,%esp
80103408:	85 c0                	test   %eax,%eax
8010340a:	0f 8e b9 00 00 00    	jle    801034c9 <pipewrite+0xd9>
80103410:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103413:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103419:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010341f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103425:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103428:	03 4d 10             	add    0x10(%ebp),%ecx
8010342b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010342e:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103434:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
8010343a:	39 d0                	cmp    %edx,%eax
8010343c:	74 38                	je     80103476 <pipewrite+0x86>
8010343e:	eb 59                	jmp    80103499 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
80103440:	e8 9b 03 00 00       	call   801037e0 <myproc>
80103445:	8b 48 24             	mov    0x24(%eax),%ecx
80103448:	85 c9                	test   %ecx,%ecx
8010344a:	75 34                	jne    80103480 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010344c:	83 ec 0c             	sub    $0xc,%esp
8010344f:	57                   	push   %edi
80103450:	e8 eb 0a 00 00       	call   80103f40 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103455:	58                   	pop    %eax
80103456:	5a                   	pop    %edx
80103457:	53                   	push   %ebx
80103458:	56                   	push   %esi
80103459:	e8 32 09 00 00       	call   80103d90 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010345e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103464:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010346a:	83 c4 10             	add    $0x10,%esp
8010346d:	05 00 02 00 00       	add    $0x200,%eax
80103472:	39 c2                	cmp    %eax,%edx
80103474:	75 2a                	jne    801034a0 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103476:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010347c:	85 c0                	test   %eax,%eax
8010347e:	75 c0                	jne    80103440 <pipewrite+0x50>
        release(&p->lock);
80103480:	83 ec 0c             	sub    $0xc,%esp
80103483:	53                   	push   %ebx
80103484:	e8 a7 0f 00 00       	call   80104430 <release>
        return -1;
80103489:	83 c4 10             	add    $0x10,%esp
8010348c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103491:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103494:	5b                   	pop    %ebx
80103495:	5e                   	pop    %esi
80103496:	5f                   	pop    %edi
80103497:	5d                   	pop    %ebp
80103498:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103499:	89 c2                	mov    %eax,%edx
8010349b:	90                   	nop
8010349c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801034a3:	8d 42 01             	lea    0x1(%edx),%eax
801034a6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801034aa:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034b0:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034b6:	0f b6 09             	movzbl (%ecx),%ecx
801034b9:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
801034bd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801034c0:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801034c3:	0f 85 65 ff ff ff    	jne    8010342e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034c9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034cf:	83 ec 0c             	sub    $0xc,%esp
801034d2:	50                   	push   %eax
801034d3:	e8 68 0a 00 00       	call   80103f40 <wakeup>
  release(&p->lock);
801034d8:	89 1c 24             	mov    %ebx,(%esp)
801034db:	e8 50 0f 00 00       	call   80104430 <release>
  return n;
801034e0:	83 c4 10             	add    $0x10,%esp
801034e3:	8b 45 10             	mov    0x10(%ebp),%eax
801034e6:	eb a9                	jmp    80103491 <pipewrite+0xa1>
801034e8:	90                   	nop
801034e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801034f0 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	57                   	push   %edi
801034f4:	56                   	push   %esi
801034f5:	53                   	push   %ebx
801034f6:	83 ec 18             	sub    $0x18,%esp
801034f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801034ff:	53                   	push   %ebx
80103500:	e8 7b 0e 00 00       	call   80104380 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103505:	83 c4 10             	add    $0x10,%esp
80103508:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010350e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103514:	75 6a                	jne    80103580 <piperead+0x90>
80103516:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010351c:	85 f6                	test   %esi,%esi
8010351e:	0f 84 cc 00 00 00    	je     801035f0 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103524:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010352a:	eb 2d                	jmp    80103559 <piperead+0x69>
8010352c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103530:	83 ec 08             	sub    $0x8,%esp
80103533:	53                   	push   %ebx
80103534:	56                   	push   %esi
80103535:	e8 56 08 00 00       	call   80103d90 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010353a:	83 c4 10             	add    $0x10,%esp
8010353d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103543:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103549:	75 35                	jne    80103580 <piperead+0x90>
8010354b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103551:	85 d2                	test   %edx,%edx
80103553:	0f 84 97 00 00 00    	je     801035f0 <piperead+0x100>
    if(myproc()->killed){
80103559:	e8 82 02 00 00       	call   801037e0 <myproc>
8010355e:	8b 48 24             	mov    0x24(%eax),%ecx
80103561:	85 c9                	test   %ecx,%ecx
80103563:	74 cb                	je     80103530 <piperead+0x40>
      release(&p->lock);
80103565:	83 ec 0c             	sub    $0xc,%esp
80103568:	53                   	push   %ebx
80103569:	e8 c2 0e 00 00       	call   80104430 <release>
      return -1;
8010356e:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103571:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103574:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103579:	5b                   	pop    %ebx
8010357a:	5e                   	pop    %esi
8010357b:	5f                   	pop    %edi
8010357c:	5d                   	pop    %ebp
8010357d:	c3                   	ret    
8010357e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103580:	8b 45 10             	mov    0x10(%ebp),%eax
80103583:	85 c0                	test   %eax,%eax
80103585:	7e 69                	jle    801035f0 <piperead+0x100>
    if(p->nread == p->nwrite)
80103587:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010358d:	31 c9                	xor    %ecx,%ecx
8010358f:	eb 15                	jmp    801035a6 <piperead+0xb6>
80103591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103598:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010359e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
801035a4:	74 5a                	je     80103600 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035a6:	8d 70 01             	lea    0x1(%eax),%esi
801035a9:	25 ff 01 00 00       	and    $0x1ff,%eax
801035ae:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
801035b4:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
801035b9:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035bc:	83 c1 01             	add    $0x1,%ecx
801035bf:	39 4d 10             	cmp    %ecx,0x10(%ebp)
801035c2:	75 d4                	jne    80103598 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035c4:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801035ca:	83 ec 0c             	sub    $0xc,%esp
801035cd:	50                   	push   %eax
801035ce:	e8 6d 09 00 00       	call   80103f40 <wakeup>
  release(&p->lock);
801035d3:	89 1c 24             	mov    %ebx,(%esp)
801035d6:	e8 55 0e 00 00       	call   80104430 <release>
  return i;
801035db:	8b 45 10             	mov    0x10(%ebp),%eax
801035de:	83 c4 10             	add    $0x10,%esp
}
801035e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035e4:	5b                   	pop    %ebx
801035e5:	5e                   	pop    %esi
801035e6:	5f                   	pop    %edi
801035e7:	5d                   	pop    %ebp
801035e8:	c3                   	ret    
801035e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035f0:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
801035f7:	eb cb                	jmp    801035c4 <piperead+0xd4>
801035f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103600:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103603:	eb bf                	jmp    801035c4 <piperead+0xd4>
80103605:	66 90                	xchg   %ax,%ax
80103607:	66 90                	xchg   %ax,%ax
80103609:	66 90                	xchg   %ax,%ax
8010360b:	66 90                	xchg   %ax,%ax
8010360d:	66 90                	xchg   %ax,%ax
8010360f:	90                   	nop

80103610 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103614:	bb d4 39 11 80       	mov    $0x801139d4,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103619:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010361c:	68 a0 39 11 80       	push   $0x801139a0
80103621:	e8 5a 0d 00 00       	call   80104380 <acquire>
80103626:	83 c4 10             	add    $0x10,%esp
80103629:	eb 10                	jmp    8010363b <allocproc+0x2b>
8010362b:	90                   	nop
8010362c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103630:	83 c3 7c             	add    $0x7c,%ebx
80103633:	81 fb d4 58 11 80    	cmp    $0x801158d4,%ebx
80103639:	74 75                	je     801036b0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010363b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010363e:	85 c0                	test   %eax,%eax
80103640:	75 ee                	jne    80103630 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103642:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103647:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010364a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;

  release(&ptable.lock);
80103651:	68 a0 39 11 80       	push   $0x801139a0
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103656:	8d 50 01             	lea    0x1(%eax),%edx
80103659:	89 43 10             	mov    %eax,0x10(%ebx)
8010365c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004

  release(&ptable.lock);
80103662:	e8 c9 0d 00 00       	call   80104430 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103667:	e8 84 ee ff ff       	call   801024f0 <kalloc>
8010366c:	83 c4 10             	add    $0x10,%esp
8010366f:	85 c0                	test   %eax,%eax
80103671:	89 43 08             	mov    %eax,0x8(%ebx)
80103674:	74 51                	je     801036c7 <allocproc+0xb7>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103676:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010367c:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010367f:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103684:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103687:	c7 40 14 0f 57 10 80 	movl   $0x8010570f,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010368e:	6a 14                	push   $0x14
80103690:	6a 00                	push   $0x0
80103692:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103693:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103696:	e8 e5 0d 00 00       	call   80104480 <memset>
  p->context->eip = (uint)forkret;
8010369b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010369e:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
801036a1:	c7 40 10 d0 36 10 80 	movl   $0x801036d0,0x10(%eax)

  return p;
801036a8:	89 d8                	mov    %ebx,%eax
}
801036aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036ad:	c9                   	leave  
801036ae:	c3                   	ret    
801036af:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	68 a0 39 11 80       	push   $0x801139a0
801036b8:	e8 73 0d 00 00       	call   80104430 <release>
  return 0;
801036bd:	83 c4 10             	add    $0x10,%esp
801036c0:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
801036c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036c5:	c9                   	leave  
801036c6:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801036c7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801036ce:	eb da                	jmp    801036aa <allocproc+0x9a>

801036d0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801036d6:	68 a0 39 11 80       	push   $0x801139a0
801036db:	e8 50 0d 00 00       	call   80104430 <release>

  if (first) {
801036e0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801036e5:	83 c4 10             	add    $0x10,%esp
801036e8:	85 c0                	test   %eax,%eax
801036ea:	75 04                	jne    801036f0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801036ec:	c9                   	leave  
801036ed:	c3                   	ret    
801036ee:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
801036f0:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801036f3:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801036fa:	00 00 00 
    iinit(ROOTDEV);
801036fd:	6a 01                	push   $0x1
801036ff:	e8 5c dd ff ff       	call   80101460 <iinit>
    initlog(ROOTDEV);
80103704:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010370b:	e8 00 f4 ff ff       	call   80102b10 <initlog>
80103710:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103713:	c9                   	leave  
80103714:	c3                   	ret    
80103715:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103720 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103726:	68 15 75 10 80       	push   $0x80107515
8010372b:	68 a0 39 11 80       	push   $0x801139a0
80103730:	e8 eb 0a 00 00       	call   80104220 <initlock>
}
80103735:	83 c4 10             	add    $0x10,%esp
80103738:	c9                   	leave  
80103739:	c3                   	ret    
8010373a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103740 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	56                   	push   %esi
80103744:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103745:	9c                   	pushf  
80103746:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103747:	f6 c4 02             	test   $0x2,%ah
8010374a:	75 5b                	jne    801037a7 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
8010374c:	e8 ff ef ff ff       	call   80102750 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103751:	8b 35 80 39 11 80    	mov    0x80113980,%esi
80103757:	85 f6                	test   %esi,%esi
80103759:	7e 3f                	jle    8010379a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010375b:	0f b6 15 00 34 11 80 	movzbl 0x80113400,%edx
80103762:	39 d0                	cmp    %edx,%eax
80103764:	74 30                	je     80103796 <mycpu+0x56>
80103766:	b9 b0 34 11 80       	mov    $0x801134b0,%ecx
8010376b:	31 d2                	xor    %edx,%edx
8010376d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103770:	83 c2 01             	add    $0x1,%edx
80103773:	39 f2                	cmp    %esi,%edx
80103775:	74 23                	je     8010379a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103777:	0f b6 19             	movzbl (%ecx),%ebx
8010377a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103780:	39 d8                	cmp    %ebx,%eax
80103782:	75 ec                	jne    80103770 <mycpu+0x30>
      return &cpus[i];
80103784:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010378a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010378d:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
8010378e:	05 00 34 11 80       	add    $0x80113400,%eax
  }
  panic("unknown apicid\n");
}
80103793:	5e                   	pop    %esi
80103794:	5d                   	pop    %ebp
80103795:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103796:	31 d2                	xor    %edx,%edx
80103798:	eb ea                	jmp    80103784 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010379a:	83 ec 0c             	sub    $0xc,%esp
8010379d:	68 1c 75 10 80       	push   $0x8010751c
801037a2:	e8 c9 cb ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
801037a7:	83 ec 0c             	sub    $0xc,%esp
801037aa:	68 f8 75 10 80       	push   $0x801075f8
801037af:	e8 bc cb ff ff       	call   80100370 <panic>
801037b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801037c0 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801037c6:	e8 75 ff ff ff       	call   80103740 <mycpu>
801037cb:	2d 00 34 11 80       	sub    $0x80113400,%eax
}
801037d0:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
801037d1:	c1 f8 04             	sar    $0x4,%eax
801037d4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801037da:	c3                   	ret    
801037db:	90                   	nop
801037dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801037e0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	53                   	push   %ebx
801037e4:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801037e7:	e8 b4 0a 00 00       	call   801042a0 <pushcli>
  c = mycpu();
801037ec:	e8 4f ff ff ff       	call   80103740 <mycpu>
  p = c->proc;
801037f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801037f7:	e8 e4 0a 00 00       	call   801042e0 <popcli>
  return p;
}
801037fc:	83 c4 04             	add    $0x4,%esp
801037ff:	89 d8                	mov    %ebx,%eax
80103801:	5b                   	pop    %ebx
80103802:	5d                   	pop    %ebp
80103803:	c3                   	ret    
80103804:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010380a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103810 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	53                   	push   %ebx
80103814:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103817:	e8 f4 fd ff ff       	call   80103610 <allocproc>
8010381c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010381e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103823:	e8 d8 34 00 00       	call   80106d00 <setupkvm>
80103828:	85 c0                	test   %eax,%eax
8010382a:	89 43 04             	mov    %eax,0x4(%ebx)
8010382d:	0f 84 bd 00 00 00    	je     801038f0 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103833:	83 ec 04             	sub    $0x4,%esp
80103836:	68 2c 00 00 00       	push   $0x2c
8010383b:	68 60 a4 10 80       	push   $0x8010a460
80103840:	50                   	push   %eax
80103841:	e8 ca 31 00 00       	call   80106a10 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103846:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103849:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010384f:	6a 4c                	push   $0x4c
80103851:	6a 00                	push   $0x0
80103853:	ff 73 18             	pushl  0x18(%ebx)
80103856:	e8 25 0c 00 00       	call   80104480 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010385b:	8b 43 18             	mov    0x18(%ebx),%eax
8010385e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103863:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103868:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010386b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010386f:	8b 43 18             	mov    0x18(%ebx),%eax
80103872:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103876:	8b 43 18             	mov    0x18(%ebx),%eax
80103879:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010387d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103881:	8b 43 18             	mov    0x18(%ebx),%eax
80103884:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103888:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010388c:	8b 43 18             	mov    0x18(%ebx),%eax
8010388f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103896:	8b 43 18             	mov    0x18(%ebx),%eax
80103899:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801038a0:	8b 43 18             	mov    0x18(%ebx),%eax
801038a3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801038aa:	8d 43 6c             	lea    0x6c(%ebx),%eax
801038ad:	6a 10                	push   $0x10
801038af:	68 45 75 10 80       	push   $0x80107545
801038b4:	50                   	push   %eax
801038b5:	e8 c6 0d 00 00       	call   80104680 <safestrcpy>
  p->cwd = namei("/");
801038ba:	c7 04 24 4e 75 10 80 	movl   $0x8010754e,(%esp)
801038c1:	e8 5a e6 ff ff       	call   80101f20 <namei>
801038c6:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801038c9:	c7 04 24 a0 39 11 80 	movl   $0x801139a0,(%esp)
801038d0:	e8 ab 0a 00 00       	call   80104380 <acquire>

  p->state = RUNNABLE;
801038d5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
801038dc:	c7 04 24 a0 39 11 80 	movl   $0x801139a0,(%esp)
801038e3:	e8 48 0b 00 00       	call   80104430 <release>
}
801038e8:	83 c4 10             	add    $0x10,%esp
801038eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038ee:	c9                   	leave  
801038ef:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
801038f0:	83 ec 0c             	sub    $0xc,%esp
801038f3:	68 2c 75 10 80       	push   $0x8010752c
801038f8:	e8 73 ca ff ff       	call   80100370 <panic>
801038fd:	8d 76 00             	lea    0x0(%esi),%esi

80103900 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	56                   	push   %esi
80103904:	53                   	push   %ebx
80103905:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103908:	e8 93 09 00 00       	call   801042a0 <pushcli>
  c = mycpu();
8010390d:	e8 2e fe ff ff       	call   80103740 <mycpu>
  p = c->proc;
80103912:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103918:	e8 c3 09 00 00       	call   801042e0 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
8010391d:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103920:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103922:	7e 34                	jle    80103958 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103924:	83 ec 04             	sub    $0x4,%esp
80103927:	01 c6                	add    %eax,%esi
80103929:	56                   	push   %esi
8010392a:	50                   	push   %eax
8010392b:	ff 73 04             	pushl  0x4(%ebx)
8010392e:	e8 1d 32 00 00       	call   80106b50 <allocuvm>
80103933:	83 c4 10             	add    $0x10,%esp
80103936:	85 c0                	test   %eax,%eax
80103938:	74 36                	je     80103970 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
8010393a:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
8010393d:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010393f:	53                   	push   %ebx
80103940:	e8 bb 2f 00 00       	call   80106900 <switchuvm>
  return 0;
80103945:	83 c4 10             	add    $0x10,%esp
80103948:	31 c0                	xor    %eax,%eax
}
8010394a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010394d:	5b                   	pop    %ebx
8010394e:	5e                   	pop    %esi
8010394f:	5d                   	pop    %ebp
80103950:	c3                   	ret    
80103951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103958:	74 e0                	je     8010393a <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010395a:	83 ec 04             	sub    $0x4,%esp
8010395d:	01 c6                	add    %eax,%esi
8010395f:	56                   	push   %esi
80103960:	50                   	push   %eax
80103961:	ff 73 04             	pushl  0x4(%ebx)
80103964:	e8 e7 32 00 00       	call   80106c50 <deallocuvm>
80103969:	83 c4 10             	add    $0x10,%esp
8010396c:	85 c0                	test   %eax,%eax
8010396e:	75 ca                	jne    8010393a <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103970:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103975:	eb d3                	jmp    8010394a <growproc+0x4a>
80103977:	89 f6                	mov    %esi,%esi
80103979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103980 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	57                   	push   %edi
80103984:	56                   	push   %esi
80103985:	53                   	push   %ebx
80103986:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103989:	e8 12 09 00 00       	call   801042a0 <pushcli>
  c = mycpu();
8010398e:	e8 ad fd ff ff       	call   80103740 <mycpu>
  p = c->proc;
80103993:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103999:	e8 42 09 00 00       	call   801042e0 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
8010399e:	e8 6d fc ff ff       	call   80103610 <allocproc>
801039a3:	85 c0                	test   %eax,%eax
801039a5:	89 c7                	mov    %eax,%edi
801039a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801039aa:	0f 84 b5 00 00 00    	je     80103a65 <fork+0xe5>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801039b0:	83 ec 08             	sub    $0x8,%esp
801039b3:	ff 33                	pushl  (%ebx)
801039b5:	ff 73 04             	pushl  0x4(%ebx)
801039b8:	e8 13 34 00 00       	call   80106dd0 <copyuvm>
801039bd:	83 c4 10             	add    $0x10,%esp
801039c0:	85 c0                	test   %eax,%eax
801039c2:	89 47 04             	mov    %eax,0x4(%edi)
801039c5:	0f 84 a1 00 00 00    	je     80103a6c <fork+0xec>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
801039cb:	8b 03                	mov    (%ebx),%eax
801039cd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801039d0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801039d2:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801039d5:	89 c8                	mov    %ecx,%eax
801039d7:	8b 79 18             	mov    0x18(%ecx),%edi
801039da:	8b 73 18             	mov    0x18(%ebx),%esi
801039dd:	b9 13 00 00 00       	mov    $0x13,%ecx
801039e2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801039e4:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801039e6:	8b 40 18             	mov    0x18(%eax),%eax
801039e9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
801039f0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801039f4:	85 c0                	test   %eax,%eax
801039f6:	74 13                	je     80103a0b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
801039f8:	83 ec 0c             	sub    $0xc,%esp
801039fb:	50                   	push   %eax
801039fc:	e8 df d3 ff ff       	call   80100de0 <filedup>
80103a01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a04:	83 c4 10             	add    $0x10,%esp
80103a07:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a0b:	83 c6 01             	add    $0x1,%esi
80103a0e:	83 fe 10             	cmp    $0x10,%esi
80103a11:	75 dd                	jne    801039f0 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a13:	83 ec 0c             	sub    $0xc,%esp
80103a16:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a19:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a1c:	e8 3f dc ff ff       	call   80101660 <idup>
80103a21:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a24:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a27:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a2a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103a2d:	6a 10                	push   $0x10
80103a2f:	53                   	push   %ebx
80103a30:	50                   	push   %eax
80103a31:	e8 4a 0c 00 00       	call   80104680 <safestrcpy>

  pid = np->pid;
80103a36:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103a39:	c7 04 24 a0 39 11 80 	movl   $0x801139a0,(%esp)
80103a40:	e8 3b 09 00 00       	call   80104380 <acquire>

  np->state = RUNNABLE;
80103a45:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103a4c:	c7 04 24 a0 39 11 80 	movl   $0x801139a0,(%esp)
80103a53:	e8 d8 09 00 00       	call   80104430 <release>

  return pid;
80103a58:	83 c4 10             	add    $0x10,%esp
80103a5b:	89 d8                	mov    %ebx,%eax
}
80103a5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a60:	5b                   	pop    %ebx
80103a61:	5e                   	pop    %esi
80103a62:	5f                   	pop    %edi
80103a63:	5d                   	pop    %ebp
80103a64:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103a65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a6a:	eb f1                	jmp    80103a5d <fork+0xdd>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103a6c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103a6f:	83 ec 0c             	sub    $0xc,%esp
80103a72:	ff 77 08             	pushl  0x8(%edi)
80103a75:	e8 c6 e8 ff ff       	call   80102340 <kfree>
    np->kstack = 0;
80103a7a:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103a81:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103a88:	83 c4 10             	add    $0x10,%esp
80103a8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a90:	eb cb                	jmp    80103a5d <fork+0xdd>
80103a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103aa0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	57                   	push   %edi
80103aa4:	56                   	push   %esi
80103aa5:	53                   	push   %ebx
80103aa6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103aa9:	e8 92 fc ff ff       	call   80103740 <mycpu>
80103aae:	8d 78 04             	lea    0x4(%eax),%edi
80103ab1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103ab3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103aba:	00 00 00 
80103abd:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103ac0:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103ac1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ac4:	bb d4 39 11 80       	mov    $0x801139d4,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103ac9:	68 a0 39 11 80       	push   $0x801139a0
80103ace:	e8 ad 08 00 00       	call   80104380 <acquire>
80103ad3:	83 c4 10             	add    $0x10,%esp
80103ad6:	eb 13                	jmp    80103aeb <scheduler+0x4b>
80103ad8:	90                   	nop
80103ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ae0:	83 c3 7c             	add    $0x7c,%ebx
80103ae3:	81 fb d4 58 11 80    	cmp    $0x801158d4,%ebx
80103ae9:	74 45                	je     80103b30 <scheduler+0x90>
      if(p->state != RUNNABLE)
80103aeb:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103aef:	75 ef                	jne    80103ae0 <scheduler+0x40>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103af1:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103af4:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103afa:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103afb:	83 c3 7c             	add    $0x7c,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103afe:	e8 fd 2d 00 00       	call   80106900 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103b03:	58                   	pop    %eax
80103b04:	5a                   	pop    %edx
80103b05:	ff 73 a0             	pushl  -0x60(%ebx)
80103b08:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103b09:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)

      swtch(&(c->scheduler), p->context);
80103b10:	e8 c6 0b 00 00       	call   801046db <swtch>
      switchkvm();
80103b15:	e8 c6 2d 00 00       	call   801068e0 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103b1a:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b1d:	81 fb d4 58 11 80    	cmp    $0x801158d4,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103b23:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103b2a:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b2d:	75 bc                	jne    80103aeb <scheduler+0x4b>
80103b2f:	90                   	nop

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103b30:	83 ec 0c             	sub    $0xc,%esp
80103b33:	68 a0 39 11 80       	push   $0x801139a0
80103b38:	e8 f3 08 00 00       	call   80104430 <release>

  }
80103b3d:	83 c4 10             	add    $0x10,%esp
80103b40:	e9 7b ff ff ff       	jmp    80103ac0 <scheduler+0x20>
80103b45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b50 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	56                   	push   %esi
80103b54:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b55:	e8 46 07 00 00       	call   801042a0 <pushcli>
  c = mycpu();
80103b5a:	e8 e1 fb ff ff       	call   80103740 <mycpu>
  p = c->proc;
80103b5f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b65:	e8 76 07 00 00       	call   801042e0 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103b6a:	83 ec 0c             	sub    $0xc,%esp
80103b6d:	68 a0 39 11 80       	push   $0x801139a0
80103b72:	e8 d9 07 00 00       	call   80104350 <holding>
80103b77:	83 c4 10             	add    $0x10,%esp
80103b7a:	85 c0                	test   %eax,%eax
80103b7c:	74 4f                	je     80103bcd <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103b7e:	e8 bd fb ff ff       	call   80103740 <mycpu>
80103b83:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103b8a:	75 68                	jne    80103bf4 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103b8c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103b90:	74 55                	je     80103be7 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b92:	9c                   	pushf  
80103b93:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103b94:	f6 c4 02             	test   $0x2,%ah
80103b97:	75 41                	jne    80103bda <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103b99:	e8 a2 fb ff ff       	call   80103740 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103b9e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103ba1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ba7:	e8 94 fb ff ff       	call   80103740 <mycpu>
80103bac:	83 ec 08             	sub    $0x8,%esp
80103baf:	ff 70 04             	pushl  0x4(%eax)
80103bb2:	53                   	push   %ebx
80103bb3:	e8 23 0b 00 00       	call   801046db <swtch>
  mycpu()->intena = intena;
80103bb8:	e8 83 fb ff ff       	call   80103740 <mycpu>
}
80103bbd:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103bc0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103bc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bc9:	5b                   	pop    %ebx
80103bca:	5e                   	pop    %esi
80103bcb:	5d                   	pop    %ebp
80103bcc:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103bcd:	83 ec 0c             	sub    $0xc,%esp
80103bd0:	68 50 75 10 80       	push   $0x80107550
80103bd5:	e8 96 c7 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103bda:	83 ec 0c             	sub    $0xc,%esp
80103bdd:	68 7c 75 10 80       	push   $0x8010757c
80103be2:	e8 89 c7 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103be7:	83 ec 0c             	sub    $0xc,%esp
80103bea:	68 6e 75 10 80       	push   $0x8010756e
80103bef:	e8 7c c7 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103bf4:	83 ec 0c             	sub    $0xc,%esp
80103bf7:	68 62 75 10 80       	push   $0x80107562
80103bfc:	e8 6f c7 ff ff       	call   80100370 <panic>
80103c01:	eb 0d                	jmp    80103c10 <exit>
80103c03:	90                   	nop
80103c04:	90                   	nop
80103c05:	90                   	nop
80103c06:	90                   	nop
80103c07:	90                   	nop
80103c08:	90                   	nop
80103c09:	90                   	nop
80103c0a:	90                   	nop
80103c0b:	90                   	nop
80103c0c:	90                   	nop
80103c0d:	90                   	nop
80103c0e:	90                   	nop
80103c0f:	90                   	nop

80103c10 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	57                   	push   %edi
80103c14:	56                   	push   %esi
80103c15:	53                   	push   %ebx
80103c16:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103c19:	e8 82 06 00 00       	call   801042a0 <pushcli>
  c = mycpu();
80103c1e:	e8 1d fb ff ff       	call   80103740 <mycpu>
  p = c->proc;
80103c23:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103c29:	e8 b2 06 00 00       	call   801042e0 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103c2e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103c34:	8d 5e 28             	lea    0x28(%esi),%ebx
80103c37:	8d 7e 68             	lea    0x68(%esi),%edi
80103c3a:	0f 84 e7 00 00 00    	je     80103d27 <exit+0x117>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103c40:	8b 03                	mov    (%ebx),%eax
80103c42:	85 c0                	test   %eax,%eax
80103c44:	74 12                	je     80103c58 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103c46:	83 ec 0c             	sub    $0xc,%esp
80103c49:	50                   	push   %eax
80103c4a:	e8 e1 d1 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103c4f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103c55:	83 c4 10             	add    $0x10,%esp
80103c58:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103c5b:	39 df                	cmp    %ebx,%edi
80103c5d:	75 e1                	jne    80103c40 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103c5f:	e8 4c ef ff ff       	call   80102bb0 <begin_op>
  iput(curproc->cwd);
80103c64:	83 ec 0c             	sub    $0xc,%esp
80103c67:	ff 76 68             	pushl  0x68(%esi)
80103c6a:	e8 51 db ff ff       	call   801017c0 <iput>
  end_op();
80103c6f:	e8 ac ef ff ff       	call   80102c20 <end_op>
  curproc->cwd = 0;
80103c74:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
80103c7b:	c7 04 24 a0 39 11 80 	movl   $0x801139a0,(%esp)
80103c82:	e8 f9 06 00 00       	call   80104380 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103c87:	8b 56 14             	mov    0x14(%esi),%edx
80103c8a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c8d:	b8 d4 39 11 80       	mov    $0x801139d4,%eax
80103c92:	eb 0e                	jmp    80103ca2 <exit+0x92>
80103c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c98:	83 c0 7c             	add    $0x7c,%eax
80103c9b:	3d d4 58 11 80       	cmp    $0x801158d4,%eax
80103ca0:	74 1c                	je     80103cbe <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103ca2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ca6:	75 f0                	jne    80103c98 <exit+0x88>
80103ca8:	3b 50 20             	cmp    0x20(%eax),%edx
80103cab:	75 eb                	jne    80103c98 <exit+0x88>
      p->state = RUNNABLE;
80103cad:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cb4:	83 c0 7c             	add    $0x7c,%eax
80103cb7:	3d d4 58 11 80       	cmp    $0x801158d4,%eax
80103cbc:	75 e4                	jne    80103ca2 <exit+0x92>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103cbe:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
80103cc4:	ba d4 39 11 80       	mov    $0x801139d4,%edx
80103cc9:	eb 10                	jmp    80103cdb <exit+0xcb>
80103ccb:	90                   	nop
80103ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cd0:	83 c2 7c             	add    $0x7c,%edx
80103cd3:	81 fa d4 58 11 80    	cmp    $0x801158d4,%edx
80103cd9:	74 33                	je     80103d0e <exit+0xfe>
    if(p->parent == curproc){
80103cdb:	39 72 14             	cmp    %esi,0x14(%edx)
80103cde:	75 f0                	jne    80103cd0 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103ce0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103ce4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103ce7:	75 e7                	jne    80103cd0 <exit+0xc0>
80103ce9:	b8 d4 39 11 80       	mov    $0x801139d4,%eax
80103cee:	eb 0a                	jmp    80103cfa <exit+0xea>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cf0:	83 c0 7c             	add    $0x7c,%eax
80103cf3:	3d d4 58 11 80       	cmp    $0x801158d4,%eax
80103cf8:	74 d6                	je     80103cd0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103cfa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103cfe:	75 f0                	jne    80103cf0 <exit+0xe0>
80103d00:	3b 48 20             	cmp    0x20(%eax),%ecx
80103d03:	75 eb                	jne    80103cf0 <exit+0xe0>
      p->state = RUNNABLE;
80103d05:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d0c:	eb e2                	jmp    80103cf0 <exit+0xe0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103d0e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103d15:	e8 36 fe ff ff       	call   80103b50 <sched>
  panic("zombie exit");
80103d1a:	83 ec 0c             	sub    $0xc,%esp
80103d1d:	68 9d 75 10 80       	push   $0x8010759d
80103d22:	e8 49 c6 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103d27:	83 ec 0c             	sub    $0xc,%esp
80103d2a:	68 90 75 10 80       	push   $0x80107590
80103d2f:	e8 3c c6 ff ff       	call   80100370 <panic>
80103d34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103d40 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	53                   	push   %ebx
80103d44:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103d47:	68 a0 39 11 80       	push   $0x801139a0
80103d4c:	e8 2f 06 00 00       	call   80104380 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d51:	e8 4a 05 00 00       	call   801042a0 <pushcli>
  c = mycpu();
80103d56:	e8 e5 f9 ff ff       	call   80103740 <mycpu>
  p = c->proc;
80103d5b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d61:	e8 7a 05 00 00       	call   801042e0 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80103d66:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103d6d:	e8 de fd ff ff       	call   80103b50 <sched>
  release(&ptable.lock);
80103d72:	c7 04 24 a0 39 11 80 	movl   $0x801139a0,(%esp)
80103d79:	e8 b2 06 00 00       	call   80104430 <release>
}
80103d7e:	83 c4 10             	add    $0x10,%esp
80103d81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d84:	c9                   	leave  
80103d85:	c3                   	ret    
80103d86:	8d 76 00             	lea    0x0(%esi),%esi
80103d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d90 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	57                   	push   %edi
80103d94:	56                   	push   %esi
80103d95:	53                   	push   %ebx
80103d96:	83 ec 0c             	sub    $0xc,%esp
80103d99:	8b 7d 08             	mov    0x8(%ebp),%edi
80103d9c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d9f:	e8 fc 04 00 00       	call   801042a0 <pushcli>
  c = mycpu();
80103da4:	e8 97 f9 ff ff       	call   80103740 <mycpu>
  p = c->proc;
80103da9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103daf:	e8 2c 05 00 00       	call   801042e0 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80103db4:	85 db                	test   %ebx,%ebx
80103db6:	0f 84 87 00 00 00    	je     80103e43 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
80103dbc:	85 f6                	test   %esi,%esi
80103dbe:	74 76                	je     80103e36 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103dc0:	81 fe a0 39 11 80    	cmp    $0x801139a0,%esi
80103dc6:	74 50                	je     80103e18 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103dc8:	83 ec 0c             	sub    $0xc,%esp
80103dcb:	68 a0 39 11 80       	push   $0x801139a0
80103dd0:	e8 ab 05 00 00       	call   80104380 <acquire>
    release(lk);
80103dd5:	89 34 24             	mov    %esi,(%esp)
80103dd8:	e8 53 06 00 00       	call   80104430 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103ddd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103de0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103de7:	e8 64 fd ff ff       	call   80103b50 <sched>

  // Tidy up.
  p->chan = 0;
80103dec:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103df3:	c7 04 24 a0 39 11 80 	movl   $0x801139a0,(%esp)
80103dfa:	e8 31 06 00 00       	call   80104430 <release>
    acquire(lk);
80103dff:	89 75 08             	mov    %esi,0x8(%ebp)
80103e02:	83 c4 10             	add    $0x10,%esp
  }
}
80103e05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e08:	5b                   	pop    %ebx
80103e09:	5e                   	pop    %esi
80103e0a:	5f                   	pop    %edi
80103e0b:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103e0c:	e9 6f 05 00 00       	jmp    80104380 <acquire>
80103e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103e18:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e1b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103e22:	e8 29 fd ff ff       	call   80103b50 <sched>

  // Tidy up.
  p->chan = 0;
80103e27:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103e2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e31:	5b                   	pop    %ebx
80103e32:	5e                   	pop    %esi
80103e33:	5f                   	pop    %edi
80103e34:	5d                   	pop    %ebp
80103e35:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103e36:	83 ec 0c             	sub    $0xc,%esp
80103e39:	68 af 75 10 80       	push   $0x801075af
80103e3e:	e8 2d c5 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103e43:	83 ec 0c             	sub    $0xc,%esp
80103e46:	68 a9 75 10 80       	push   $0x801075a9
80103e4b:	e8 20 c5 ff ff       	call   80100370 <panic>

80103e50 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	56                   	push   %esi
80103e54:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103e55:	e8 46 04 00 00       	call   801042a0 <pushcli>
  c = mycpu();
80103e5a:	e8 e1 f8 ff ff       	call   80103740 <mycpu>
  p = c->proc;
80103e5f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e65:	e8 76 04 00 00       	call   801042e0 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
80103e6a:	83 ec 0c             	sub    $0xc,%esp
80103e6d:	68 a0 39 11 80       	push   $0x801139a0
80103e72:	e8 09 05 00 00       	call   80104380 <acquire>
80103e77:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103e7a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e7c:	bb d4 39 11 80       	mov    $0x801139d4,%ebx
80103e81:	eb 10                	jmp    80103e93 <wait+0x43>
80103e83:	90                   	nop
80103e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e88:	83 c3 7c             	add    $0x7c,%ebx
80103e8b:	81 fb d4 58 11 80    	cmp    $0x801158d4,%ebx
80103e91:	74 1d                	je     80103eb0 <wait+0x60>
      if(p->parent != curproc)
80103e93:	39 73 14             	cmp    %esi,0x14(%ebx)
80103e96:	75 f0                	jne    80103e88 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103e98:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103e9c:	74 30                	je     80103ece <wait+0x7e>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e9e:	83 c3 7c             	add    $0x7c,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103ea1:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ea6:	81 fb d4 58 11 80    	cmp    $0x801158d4,%ebx
80103eac:	75 e5                	jne    80103e93 <wait+0x43>
80103eae:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103eb0:	85 c0                	test   %eax,%eax
80103eb2:	74 70                	je     80103f24 <wait+0xd4>
80103eb4:	8b 46 24             	mov    0x24(%esi),%eax
80103eb7:	85 c0                	test   %eax,%eax
80103eb9:	75 69                	jne    80103f24 <wait+0xd4>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103ebb:	83 ec 08             	sub    $0x8,%esp
80103ebe:	68 a0 39 11 80       	push   $0x801139a0
80103ec3:	56                   	push   %esi
80103ec4:	e8 c7 fe ff ff       	call   80103d90 <sleep>
  }
80103ec9:	83 c4 10             	add    $0x10,%esp
80103ecc:	eb ac                	jmp    80103e7a <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103ece:	83 ec 0c             	sub    $0xc,%esp
80103ed1:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103ed4:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103ed7:	e8 64 e4 ff ff       	call   80102340 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103edc:	5a                   	pop    %edx
80103edd:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103ee0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103ee7:	e8 94 2d 00 00       	call   80106c80 <freevm>
        p->pid = 0;
80103eec:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103ef3:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103efa:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103efe:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103f05:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f0c:	c7 04 24 a0 39 11 80 	movl   $0x801139a0,(%esp)
80103f13:	e8 18 05 00 00       	call   80104430 <release>
        return pid;
80103f18:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103f1e:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f20:	5b                   	pop    %ebx
80103f21:	5e                   	pop    %esi
80103f22:	5d                   	pop    %ebp
80103f23:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103f24:	83 ec 0c             	sub    $0xc,%esp
80103f27:	68 a0 39 11 80       	push   $0x801139a0
80103f2c:	e8 ff 04 00 00       	call   80104430 <release>
      return -1;
80103f31:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f34:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103f37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f3c:	5b                   	pop    %ebx
80103f3d:	5e                   	pop    %esi
80103f3e:	5d                   	pop    %ebp
80103f3f:	c3                   	ret    

80103f40 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
80103f43:	53                   	push   %ebx
80103f44:	83 ec 10             	sub    $0x10,%esp
80103f47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103f4a:	68 a0 39 11 80       	push   $0x801139a0
80103f4f:	e8 2c 04 00 00       	call   80104380 <acquire>
80103f54:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f57:	b8 d4 39 11 80       	mov    $0x801139d4,%eax
80103f5c:	eb 0c                	jmp    80103f6a <wakeup+0x2a>
80103f5e:	66 90                	xchg   %ax,%ax
80103f60:	83 c0 7c             	add    $0x7c,%eax
80103f63:	3d d4 58 11 80       	cmp    $0x801158d4,%eax
80103f68:	74 1c                	je     80103f86 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80103f6a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f6e:	75 f0                	jne    80103f60 <wakeup+0x20>
80103f70:	3b 58 20             	cmp    0x20(%eax),%ebx
80103f73:	75 eb                	jne    80103f60 <wakeup+0x20>
      p->state = RUNNABLE;
80103f75:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f7c:	83 c0 7c             	add    $0x7c,%eax
80103f7f:	3d d4 58 11 80       	cmp    $0x801158d4,%eax
80103f84:	75 e4                	jne    80103f6a <wakeup+0x2a>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103f86:	c7 45 08 a0 39 11 80 	movl   $0x801139a0,0x8(%ebp)
}
80103f8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f90:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103f91:	e9 9a 04 00 00       	jmp    80104430 <release>
80103f96:	8d 76 00             	lea    0x0(%esi),%esi
80103f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fa0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	53                   	push   %ebx
80103fa4:	83 ec 10             	sub    $0x10,%esp
80103fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103faa:	68 a0 39 11 80       	push   $0x801139a0
80103faf:	e8 cc 03 00 00       	call   80104380 <acquire>
80103fb4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fb7:	b8 d4 39 11 80       	mov    $0x801139d4,%eax
80103fbc:	eb 0c                	jmp    80103fca <kill+0x2a>
80103fbe:	66 90                	xchg   %ax,%ax
80103fc0:	83 c0 7c             	add    $0x7c,%eax
80103fc3:	3d d4 58 11 80       	cmp    $0x801158d4,%eax
80103fc8:	74 3e                	je     80104008 <kill+0x68>
    if(p->pid == pid){
80103fca:	39 58 10             	cmp    %ebx,0x10(%eax)
80103fcd:	75 f1                	jne    80103fc0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103fcf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103fd3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103fda:	74 1c                	je     80103ff8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103fdc:	83 ec 0c             	sub    $0xc,%esp
80103fdf:	68 a0 39 11 80       	push   $0x801139a0
80103fe4:	e8 47 04 00 00       	call   80104430 <release>
      return 0;
80103fe9:	83 c4 10             	add    $0x10,%esp
80103fec:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103fee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ff1:	c9                   	leave  
80103ff2:	c3                   	ret    
80103ff3:	90                   	nop
80103ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103ff8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fff:	eb db                	jmp    80103fdc <kill+0x3c>
80104001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104008:	83 ec 0c             	sub    $0xc,%esp
8010400b:	68 a0 39 11 80       	push   $0x801139a0
80104010:	e8 1b 04 00 00       	call   80104430 <release>
  return -1;
80104015:	83 c4 10             	add    $0x10,%esp
80104018:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010401d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104020:	c9                   	leave  
80104021:	c3                   	ret    
80104022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104030 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	57                   	push   %edi
80104034:	56                   	push   %esi
80104035:	53                   	push   %ebx
80104036:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104039:	bb 40 3a 11 80       	mov    $0x80113a40,%ebx
8010403e:	83 ec 3c             	sub    $0x3c,%esp
80104041:	eb 24                	jmp    80104067 <procdump+0x37>
80104043:	90                   	nop
80104044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104048:	83 ec 0c             	sub    $0xc,%esp
8010404b:	68 3b 79 10 80       	push   $0x8010793b
80104050:	e8 0b c6 ff ff       	call   80100660 <cprintf>
80104055:	83 c4 10             	add    $0x10,%esp
80104058:	83 c3 7c             	add    $0x7c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010405b:	81 fb 40 59 11 80    	cmp    $0x80115940,%ebx
80104061:	0f 84 81 00 00 00    	je     801040e8 <procdump+0xb8>
    if(p->state == UNUSED)
80104067:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010406a:	85 c0                	test   %eax,%eax
8010406c:	74 ea                	je     80104058 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010406e:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104071:	ba c0 75 10 80       	mov    $0x801075c0,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104076:	77 11                	ja     80104089 <procdump+0x59>
80104078:	8b 14 85 20 76 10 80 	mov    -0x7fef89e0(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
8010407f:	b8 c0 75 10 80       	mov    $0x801075c0,%eax
80104084:	85 d2                	test   %edx,%edx
80104086:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104089:	53                   	push   %ebx
8010408a:	52                   	push   %edx
8010408b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010408e:	68 c4 75 10 80       	push   $0x801075c4
80104093:	e8 c8 c5 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104098:	83 c4 10             	add    $0x10,%esp
8010409b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010409f:	75 a7                	jne    80104048 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801040a1:	8d 45 c0             	lea    -0x40(%ebp),%eax
801040a4:	83 ec 08             	sub    $0x8,%esp
801040a7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801040aa:	50                   	push   %eax
801040ab:	8b 43 b0             	mov    -0x50(%ebx),%eax
801040ae:	8b 40 0c             	mov    0xc(%eax),%eax
801040b1:	83 c0 08             	add    $0x8,%eax
801040b4:	50                   	push   %eax
801040b5:	e8 86 01 00 00       	call   80104240 <getcallerpcs>
801040ba:	83 c4 10             	add    $0x10,%esp
801040bd:	8d 76 00             	lea    0x0(%esi),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801040c0:	8b 17                	mov    (%edi),%edx
801040c2:	85 d2                	test   %edx,%edx
801040c4:	74 82                	je     80104048 <procdump+0x18>
        cprintf(" %p", pc[i]);
801040c6:	83 ec 08             	sub    $0x8,%esp
801040c9:	83 c7 04             	add    $0x4,%edi
801040cc:	52                   	push   %edx
801040cd:	68 01 70 10 80       	push   $0x80107001
801040d2:	e8 89 c5 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801040d7:	83 c4 10             	add    $0x10,%esp
801040da:	39 f7                	cmp    %esi,%edi
801040dc:	75 e2                	jne    801040c0 <procdump+0x90>
801040de:	e9 65 ff ff ff       	jmp    80104048 <procdump+0x18>
801040e3:	90                   	nop
801040e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801040e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040eb:	5b                   	pop    %ebx
801040ec:	5e                   	pop    %esi
801040ed:	5f                   	pop    %edi
801040ee:	5d                   	pop    %ebp
801040ef:	c3                   	ret    

801040f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	53                   	push   %ebx
801040f4:	83 ec 0c             	sub    $0xc,%esp
801040f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801040fa:	68 38 76 10 80       	push   $0x80107638
801040ff:	8d 43 04             	lea    0x4(%ebx),%eax
80104102:	50                   	push   %eax
80104103:	e8 18 01 00 00       	call   80104220 <initlock>
  lk->name = name;
80104108:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010410b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104111:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104114:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010411b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010411e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104121:	c9                   	leave  
80104122:	c3                   	ret    
80104123:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104130 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	56                   	push   %esi
80104134:	53                   	push   %ebx
80104135:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104138:	83 ec 0c             	sub    $0xc,%esp
8010413b:	8d 73 04             	lea    0x4(%ebx),%esi
8010413e:	56                   	push   %esi
8010413f:	e8 3c 02 00 00       	call   80104380 <acquire>
  while (lk->locked) {
80104144:	8b 13                	mov    (%ebx),%edx
80104146:	83 c4 10             	add    $0x10,%esp
80104149:	85 d2                	test   %edx,%edx
8010414b:	74 16                	je     80104163 <acquiresleep+0x33>
8010414d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104150:	83 ec 08             	sub    $0x8,%esp
80104153:	56                   	push   %esi
80104154:	53                   	push   %ebx
80104155:	e8 36 fc ff ff       	call   80103d90 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010415a:	8b 03                	mov    (%ebx),%eax
8010415c:	83 c4 10             	add    $0x10,%esp
8010415f:	85 c0                	test   %eax,%eax
80104161:	75 ed                	jne    80104150 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104163:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104169:	e8 72 f6 ff ff       	call   801037e0 <myproc>
8010416e:	8b 40 10             	mov    0x10(%eax),%eax
80104171:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104174:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104177:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010417a:	5b                   	pop    %ebx
8010417b:	5e                   	pop    %esi
8010417c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010417d:	e9 ae 02 00 00       	jmp    80104430 <release>
80104182:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104190 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	56                   	push   %esi
80104194:	53                   	push   %ebx
80104195:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104198:	83 ec 0c             	sub    $0xc,%esp
8010419b:	8d 73 04             	lea    0x4(%ebx),%esi
8010419e:	56                   	push   %esi
8010419f:	e8 dc 01 00 00       	call   80104380 <acquire>
  lk->locked = 0;
801041a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801041aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801041b1:	89 1c 24             	mov    %ebx,(%esp)
801041b4:	e8 87 fd ff ff       	call   80103f40 <wakeup>
  release(&lk->lk);
801041b9:	89 75 08             	mov    %esi,0x8(%ebp)
801041bc:	83 c4 10             	add    $0x10,%esp
}
801041bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041c2:	5b                   	pop    %ebx
801041c3:	5e                   	pop    %esi
801041c4:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
801041c5:	e9 66 02 00 00       	jmp    80104430 <release>
801041ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041d0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	57                   	push   %edi
801041d4:	56                   	push   %esi
801041d5:	53                   	push   %ebx
801041d6:	31 ff                	xor    %edi,%edi
801041d8:	83 ec 18             	sub    $0x18,%esp
801041db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801041de:	8d 73 04             	lea    0x4(%ebx),%esi
801041e1:	56                   	push   %esi
801041e2:	e8 99 01 00 00       	call   80104380 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801041e7:	8b 03                	mov    (%ebx),%eax
801041e9:	83 c4 10             	add    $0x10,%esp
801041ec:	85 c0                	test   %eax,%eax
801041ee:	74 13                	je     80104203 <holdingsleep+0x33>
801041f0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801041f3:	e8 e8 f5 ff ff       	call   801037e0 <myproc>
801041f8:	39 58 10             	cmp    %ebx,0x10(%eax)
801041fb:	0f 94 c0             	sete   %al
801041fe:	0f b6 c0             	movzbl %al,%eax
80104201:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104203:	83 ec 0c             	sub    $0xc,%esp
80104206:	56                   	push   %esi
80104207:	e8 24 02 00 00       	call   80104430 <release>
  return r;
}
8010420c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010420f:	89 f8                	mov    %edi,%eax
80104211:	5b                   	pop    %ebx
80104212:	5e                   	pop    %esi
80104213:	5f                   	pop    %edi
80104214:	5d                   	pop    %ebp
80104215:	c3                   	ret    
80104216:	66 90                	xchg   %ax,%ax
80104218:	66 90                	xchg   %ax,%ax
8010421a:	66 90                	xchg   %ax,%ax
8010421c:	66 90                	xchg   %ax,%ax
8010421e:	66 90                	xchg   %ax,%ax

80104220 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104226:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104229:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010422f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104232:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104239:	5d                   	pop    %ebp
8010423a:	c3                   	ret    
8010423b:	90                   	nop
8010423c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104240 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104244:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104247:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010424a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010424d:	31 c0                	xor    %eax,%eax
8010424f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104250:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104256:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010425c:	77 1a                	ja     80104278 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010425e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104261:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104264:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104267:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104269:	83 f8 0a             	cmp    $0xa,%eax
8010426c:	75 e2                	jne    80104250 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010426e:	5b                   	pop    %ebx
8010426f:	5d                   	pop    %ebp
80104270:	c3                   	ret    
80104271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104278:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010427f:	83 c0 01             	add    $0x1,%eax
80104282:	83 f8 0a             	cmp    $0xa,%eax
80104285:	74 e7                	je     8010426e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104287:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010428e:	83 c0 01             	add    $0x1,%eax
80104291:	83 f8 0a             	cmp    $0xa,%eax
80104294:	75 e2                	jne    80104278 <getcallerpcs+0x38>
80104296:	eb d6                	jmp    8010426e <getcallerpcs+0x2e>
80104298:	90                   	nop
80104299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	53                   	push   %ebx
801042a4:	83 ec 04             	sub    $0x4,%esp
801042a7:	9c                   	pushf  
801042a8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
801042a9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801042aa:	e8 91 f4 ff ff       	call   80103740 <mycpu>
801042af:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801042b5:	85 c0                	test   %eax,%eax
801042b7:	75 11                	jne    801042ca <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801042b9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801042bf:	e8 7c f4 ff ff       	call   80103740 <mycpu>
801042c4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801042ca:	e8 71 f4 ff ff       	call   80103740 <mycpu>
801042cf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801042d6:	83 c4 04             	add    $0x4,%esp
801042d9:	5b                   	pop    %ebx
801042da:	5d                   	pop    %ebp
801042db:	c3                   	ret    
801042dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042e0 <popcli>:

void
popcli(void)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042e6:	9c                   	pushf  
801042e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801042e8:	f6 c4 02             	test   $0x2,%ah
801042eb:	75 52                	jne    8010433f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801042ed:	e8 4e f4 ff ff       	call   80103740 <mycpu>
801042f2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801042f8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801042fb:	85 d2                	test   %edx,%edx
801042fd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104303:	78 2d                	js     80104332 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104305:	e8 36 f4 ff ff       	call   80103740 <mycpu>
8010430a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104310:	85 d2                	test   %edx,%edx
80104312:	74 0c                	je     80104320 <popcli+0x40>
    sti();
}
80104314:	c9                   	leave  
80104315:	c3                   	ret    
80104316:	8d 76 00             	lea    0x0(%esi),%esi
80104319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104320:	e8 1b f4 ff ff       	call   80103740 <mycpu>
80104325:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010432b:	85 c0                	test   %eax,%eax
8010432d:	74 e5                	je     80104314 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
8010432f:	fb                   	sti    
    sti();
}
80104330:	c9                   	leave  
80104331:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104332:	83 ec 0c             	sub    $0xc,%esp
80104335:	68 5a 76 10 80       	push   $0x8010765a
8010433a:	e8 31 c0 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010433f:	83 ec 0c             	sub    $0xc,%esp
80104342:	68 43 76 10 80       	push   $0x80107643
80104347:	e8 24 c0 ff ff       	call   80100370 <panic>
8010434c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104350 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	56                   	push   %esi
80104354:	53                   	push   %ebx
80104355:	8b 75 08             	mov    0x8(%ebp),%esi
80104358:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
8010435a:	e8 41 ff ff ff       	call   801042a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010435f:	8b 06                	mov    (%esi),%eax
80104361:	85 c0                	test   %eax,%eax
80104363:	74 10                	je     80104375 <holding+0x25>
80104365:	8b 5e 08             	mov    0x8(%esi),%ebx
80104368:	e8 d3 f3 ff ff       	call   80103740 <mycpu>
8010436d:	39 c3                	cmp    %eax,%ebx
8010436f:	0f 94 c3             	sete   %bl
80104372:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104375:	e8 66 ff ff ff       	call   801042e0 <popcli>
  return r;
}
8010437a:	89 d8                	mov    %ebx,%eax
8010437c:	5b                   	pop    %ebx
8010437d:	5e                   	pop    %esi
8010437e:	5d                   	pop    %ebp
8010437f:	c3                   	ret    

80104380 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	53                   	push   %ebx
80104384:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104387:	e8 14 ff ff ff       	call   801042a0 <pushcli>
  if(holding(lk))
8010438c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010438f:	83 ec 0c             	sub    $0xc,%esp
80104392:	53                   	push   %ebx
80104393:	e8 b8 ff ff ff       	call   80104350 <holding>
80104398:	83 c4 10             	add    $0x10,%esp
8010439b:	85 c0                	test   %eax,%eax
8010439d:	0f 85 7d 00 00 00    	jne    80104420 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801043a3:	ba 01 00 00 00       	mov    $0x1,%edx
801043a8:	eb 09                	jmp    801043b3 <acquire+0x33>
801043aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801043b3:	89 d0                	mov    %edx,%eax
801043b5:	f0 87 03             	lock xchg %eax,(%ebx)
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801043b8:	85 c0                	test   %eax,%eax
801043ba:	75 f4                	jne    801043b0 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801043bc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801043c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801043c4:	e8 77 f3 ff ff       	call   80103740 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801043c9:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
801043cb:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801043ce:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043d1:	31 c0                	xor    %eax,%eax
801043d3:	90                   	nop
801043d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801043d8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801043de:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801043e4:	77 1a                	ja     80104400 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
801043e6:	8b 5a 04             	mov    0x4(%edx),%ebx
801043e9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043ec:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801043ef:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043f1:	83 f8 0a             	cmp    $0xa,%eax
801043f4:	75 e2                	jne    801043d8 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
801043f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043f9:	c9                   	leave  
801043fa:	c3                   	ret    
801043fb:	90                   	nop
801043fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104400:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104407:	83 c0 01             	add    $0x1,%eax
8010440a:	83 f8 0a             	cmp    $0xa,%eax
8010440d:	74 e7                	je     801043f6 <acquire+0x76>
    pcs[i] = 0;
8010440f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104416:	83 c0 01             	add    $0x1,%eax
80104419:	83 f8 0a             	cmp    $0xa,%eax
8010441c:	75 e2                	jne    80104400 <acquire+0x80>
8010441e:	eb d6                	jmp    801043f6 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104420:	83 ec 0c             	sub    $0xc,%esp
80104423:	68 61 76 10 80       	push   $0x80107661
80104428:	e8 43 bf ff ff       	call   80100370 <panic>
8010442d:	8d 76 00             	lea    0x0(%esi),%esi

80104430 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	53                   	push   %ebx
80104434:	83 ec 10             	sub    $0x10,%esp
80104437:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010443a:	53                   	push   %ebx
8010443b:	e8 10 ff ff ff       	call   80104350 <holding>
80104440:	83 c4 10             	add    $0x10,%esp
80104443:	85 c0                	test   %eax,%eax
80104445:	74 22                	je     80104469 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
80104447:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010444e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104455:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010445a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104460:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104463:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104464:	e9 77 fe ff ff       	jmp    801042e0 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104469:	83 ec 0c             	sub    $0xc,%esp
8010446c:	68 69 76 10 80       	push   $0x80107669
80104471:	e8 fa be ff ff       	call   80100370 <panic>
80104476:	66 90                	xchg   %ax,%ax
80104478:	66 90                	xchg   %ax,%ax
8010447a:	66 90                	xchg   %ax,%ax
8010447c:	66 90                	xchg   %ax,%ax
8010447e:	66 90                	xchg   %ax,%ax

80104480 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	57                   	push   %edi
80104484:	53                   	push   %ebx
80104485:	8b 55 08             	mov    0x8(%ebp),%edx
80104488:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010448b:	f6 c2 03             	test   $0x3,%dl
8010448e:	75 05                	jne    80104495 <memset+0x15>
80104490:	f6 c1 03             	test   $0x3,%cl
80104493:	74 13                	je     801044a8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104495:	89 d7                	mov    %edx,%edi
80104497:	8b 45 0c             	mov    0xc(%ebp),%eax
8010449a:	fc                   	cld    
8010449b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010449d:	5b                   	pop    %ebx
8010449e:	89 d0                	mov    %edx,%eax
801044a0:	5f                   	pop    %edi
801044a1:	5d                   	pop    %ebp
801044a2:	c3                   	ret    
801044a3:	90                   	nop
801044a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801044a8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801044ac:	c1 e9 02             	shr    $0x2,%ecx
801044af:	89 fb                	mov    %edi,%ebx
801044b1:	89 f8                	mov    %edi,%eax
801044b3:	c1 e3 18             	shl    $0x18,%ebx
801044b6:	c1 e0 10             	shl    $0x10,%eax
801044b9:	09 d8                	or     %ebx,%eax
801044bb:	09 f8                	or     %edi,%eax
801044bd:	c1 e7 08             	shl    $0x8,%edi
801044c0:	09 f8                	or     %edi,%eax
801044c2:	89 d7                	mov    %edx,%edi
801044c4:	fc                   	cld    
801044c5:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801044c7:	5b                   	pop    %ebx
801044c8:	89 d0                	mov    %edx,%eax
801044ca:	5f                   	pop    %edi
801044cb:	5d                   	pop    %ebp
801044cc:	c3                   	ret    
801044cd:	8d 76 00             	lea    0x0(%esi),%esi

801044d0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	57                   	push   %edi
801044d4:	56                   	push   %esi
801044d5:	8b 45 10             	mov    0x10(%ebp),%eax
801044d8:	53                   	push   %ebx
801044d9:	8b 75 0c             	mov    0xc(%ebp),%esi
801044dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801044df:	85 c0                	test   %eax,%eax
801044e1:	74 29                	je     8010450c <memcmp+0x3c>
    if(*s1 != *s2)
801044e3:	0f b6 13             	movzbl (%ebx),%edx
801044e6:	0f b6 0e             	movzbl (%esi),%ecx
801044e9:	38 d1                	cmp    %dl,%cl
801044eb:	75 2b                	jne    80104518 <memcmp+0x48>
801044ed:	8d 78 ff             	lea    -0x1(%eax),%edi
801044f0:	31 c0                	xor    %eax,%eax
801044f2:	eb 14                	jmp    80104508 <memcmp+0x38>
801044f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044f8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
801044fd:	83 c0 01             	add    $0x1,%eax
80104500:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104504:	38 ca                	cmp    %cl,%dl
80104506:	75 10                	jne    80104518 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104508:	39 f8                	cmp    %edi,%eax
8010450a:	75 ec                	jne    801044f8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010450c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010450d:	31 c0                	xor    %eax,%eax
}
8010450f:	5e                   	pop    %esi
80104510:	5f                   	pop    %edi
80104511:	5d                   	pop    %ebp
80104512:	c3                   	ret    
80104513:	90                   	nop
80104514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104518:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
8010451b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
8010451c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010451e:	5e                   	pop    %esi
8010451f:	5f                   	pop    %edi
80104520:	5d                   	pop    %ebp
80104521:	c3                   	ret    
80104522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104530 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	56                   	push   %esi
80104534:	53                   	push   %ebx
80104535:	8b 45 08             	mov    0x8(%ebp),%eax
80104538:	8b 75 0c             	mov    0xc(%ebp),%esi
8010453b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010453e:	39 c6                	cmp    %eax,%esi
80104540:	73 2e                	jae    80104570 <memmove+0x40>
80104542:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104545:	39 c8                	cmp    %ecx,%eax
80104547:	73 27                	jae    80104570 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104549:	85 db                	test   %ebx,%ebx
8010454b:	8d 53 ff             	lea    -0x1(%ebx),%edx
8010454e:	74 17                	je     80104567 <memmove+0x37>
      *--d = *--s;
80104550:	29 d9                	sub    %ebx,%ecx
80104552:	89 cb                	mov    %ecx,%ebx
80104554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104558:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
8010455c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010455f:	83 ea 01             	sub    $0x1,%edx
80104562:	83 fa ff             	cmp    $0xffffffff,%edx
80104565:	75 f1                	jne    80104558 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104567:	5b                   	pop    %ebx
80104568:	5e                   	pop    %esi
80104569:	5d                   	pop    %ebp
8010456a:	c3                   	ret    
8010456b:	90                   	nop
8010456c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104570:	31 d2                	xor    %edx,%edx
80104572:	85 db                	test   %ebx,%ebx
80104574:	74 f1                	je     80104567 <memmove+0x37>
80104576:	8d 76 00             	lea    0x0(%esi),%esi
80104579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104580:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104584:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104587:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010458a:	39 d3                	cmp    %edx,%ebx
8010458c:	75 f2                	jne    80104580 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010458e:	5b                   	pop    %ebx
8010458f:	5e                   	pop    %esi
80104590:	5d                   	pop    %ebp
80104591:	c3                   	ret    
80104592:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045a0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801045a3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801045a4:	eb 8a                	jmp    80104530 <memmove>
801045a6:	8d 76 00             	lea    0x0(%esi),%esi
801045a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045b0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	57                   	push   %edi
801045b4:	56                   	push   %esi
801045b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045b8:	53                   	push   %ebx
801045b9:	8b 7d 08             	mov    0x8(%ebp),%edi
801045bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801045bf:	85 c9                	test   %ecx,%ecx
801045c1:	74 37                	je     801045fa <strncmp+0x4a>
801045c3:	0f b6 17             	movzbl (%edi),%edx
801045c6:	0f b6 1e             	movzbl (%esi),%ebx
801045c9:	84 d2                	test   %dl,%dl
801045cb:	74 3f                	je     8010460c <strncmp+0x5c>
801045cd:	38 d3                	cmp    %dl,%bl
801045cf:	75 3b                	jne    8010460c <strncmp+0x5c>
801045d1:	8d 47 01             	lea    0x1(%edi),%eax
801045d4:	01 cf                	add    %ecx,%edi
801045d6:	eb 1b                	jmp    801045f3 <strncmp+0x43>
801045d8:	90                   	nop
801045d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045e0:	0f b6 10             	movzbl (%eax),%edx
801045e3:	84 d2                	test   %dl,%dl
801045e5:	74 21                	je     80104608 <strncmp+0x58>
801045e7:	0f b6 19             	movzbl (%ecx),%ebx
801045ea:	83 c0 01             	add    $0x1,%eax
801045ed:	89 ce                	mov    %ecx,%esi
801045ef:	38 da                	cmp    %bl,%dl
801045f1:	75 19                	jne    8010460c <strncmp+0x5c>
801045f3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
801045f5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801045f8:	75 e6                	jne    801045e0 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801045fa:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
801045fb:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
801045fd:	5e                   	pop    %esi
801045fe:	5f                   	pop    %edi
801045ff:	5d                   	pop    %ebp
80104600:	c3                   	ret    
80104601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104608:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010460c:	0f b6 c2             	movzbl %dl,%eax
8010460f:	29 d8                	sub    %ebx,%eax
}
80104611:	5b                   	pop    %ebx
80104612:	5e                   	pop    %esi
80104613:	5f                   	pop    %edi
80104614:	5d                   	pop    %ebp
80104615:	c3                   	ret    
80104616:	8d 76 00             	lea    0x0(%esi),%esi
80104619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104620 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	56                   	push   %esi
80104624:	53                   	push   %ebx
80104625:	8b 45 08             	mov    0x8(%ebp),%eax
80104628:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010462b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010462e:	89 c2                	mov    %eax,%edx
80104630:	eb 19                	jmp    8010464b <strncpy+0x2b>
80104632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104638:	83 c3 01             	add    $0x1,%ebx
8010463b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010463f:	83 c2 01             	add    $0x1,%edx
80104642:	84 c9                	test   %cl,%cl
80104644:	88 4a ff             	mov    %cl,-0x1(%edx)
80104647:	74 09                	je     80104652 <strncpy+0x32>
80104649:	89 f1                	mov    %esi,%ecx
8010464b:	85 c9                	test   %ecx,%ecx
8010464d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104650:	7f e6                	jg     80104638 <strncpy+0x18>
    ;
  while(n-- > 0)
80104652:	31 c9                	xor    %ecx,%ecx
80104654:	85 f6                	test   %esi,%esi
80104656:	7e 17                	jle    8010466f <strncpy+0x4f>
80104658:	90                   	nop
80104659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104660:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104664:	89 f3                	mov    %esi,%ebx
80104666:	83 c1 01             	add    $0x1,%ecx
80104669:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010466b:	85 db                	test   %ebx,%ebx
8010466d:	7f f1                	jg     80104660 <strncpy+0x40>
    *s++ = 0;
  return os;
}
8010466f:	5b                   	pop    %ebx
80104670:	5e                   	pop    %esi
80104671:	5d                   	pop    %ebp
80104672:	c3                   	ret    
80104673:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104680 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
80104685:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104688:	8b 45 08             	mov    0x8(%ebp),%eax
8010468b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010468e:	85 c9                	test   %ecx,%ecx
80104690:	7e 26                	jle    801046b8 <safestrcpy+0x38>
80104692:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104696:	89 c1                	mov    %eax,%ecx
80104698:	eb 17                	jmp    801046b1 <safestrcpy+0x31>
8010469a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801046a0:	83 c2 01             	add    $0x1,%edx
801046a3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801046a7:	83 c1 01             	add    $0x1,%ecx
801046aa:	84 db                	test   %bl,%bl
801046ac:	88 59 ff             	mov    %bl,-0x1(%ecx)
801046af:	74 04                	je     801046b5 <safestrcpy+0x35>
801046b1:	39 f2                	cmp    %esi,%edx
801046b3:	75 eb                	jne    801046a0 <safestrcpy+0x20>
    ;
  *s = 0;
801046b5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801046b8:	5b                   	pop    %ebx
801046b9:	5e                   	pop    %esi
801046ba:	5d                   	pop    %ebp
801046bb:	c3                   	ret    
801046bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046c0 <strlen>:

int
strlen(const char *s)
{
801046c0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801046c1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
801046c3:	89 e5                	mov    %esp,%ebp
801046c5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801046c8:	80 3a 00             	cmpb   $0x0,(%edx)
801046cb:	74 0c                	je     801046d9 <strlen+0x19>
801046cd:	8d 76 00             	lea    0x0(%esi),%esi
801046d0:	83 c0 01             	add    $0x1,%eax
801046d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801046d7:	75 f7                	jne    801046d0 <strlen+0x10>
    ;
  return n;
}
801046d9:	5d                   	pop    %ebp
801046da:	c3                   	ret    

801046db <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801046db:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801046df:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801046e3:	55                   	push   %ebp
  pushl %ebx
801046e4:	53                   	push   %ebx
  pushl %esi
801046e5:	56                   	push   %esi
  pushl %edi
801046e6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801046e7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801046e9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801046eb:	5f                   	pop    %edi
  popl %esi
801046ec:	5e                   	pop    %esi
  popl %ebx
801046ed:	5b                   	pop    %ebx
  popl %ebp
801046ee:	5d                   	pop    %ebp
  ret
801046ef:	c3                   	ret    

801046f0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	53                   	push   %ebx
801046f4:	83 ec 04             	sub    $0x4,%esp
801046f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801046fa:	e8 e1 f0 ff ff       	call   801037e0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801046ff:	8b 00                	mov    (%eax),%eax
80104701:	39 d8                	cmp    %ebx,%eax
80104703:	76 1b                	jbe    80104720 <fetchint+0x30>
80104705:	8d 53 04             	lea    0x4(%ebx),%edx
80104708:	39 d0                	cmp    %edx,%eax
8010470a:	72 14                	jb     80104720 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010470c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010470f:	8b 13                	mov    (%ebx),%edx
80104711:	89 10                	mov    %edx,(%eax)
  return 0;
80104713:	31 c0                	xor    %eax,%eax
}
80104715:	83 c4 04             	add    $0x4,%esp
80104718:	5b                   	pop    %ebx
80104719:	5d                   	pop    %ebp
8010471a:	c3                   	ret    
8010471b:	90                   	nop
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104720:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104725:	eb ee                	jmp    80104715 <fetchint+0x25>
80104727:	89 f6                	mov    %esi,%esi
80104729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104730 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	53                   	push   %ebx
80104734:	83 ec 04             	sub    $0x4,%esp
80104737:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010473a:	e8 a1 f0 ff ff       	call   801037e0 <myproc>

  if(addr >= curproc->sz)
8010473f:	39 18                	cmp    %ebx,(%eax)
80104741:	76 29                	jbe    8010476c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104743:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104746:	89 da                	mov    %ebx,%edx
80104748:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010474a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010474c:	39 c3                	cmp    %eax,%ebx
8010474e:	73 1c                	jae    8010476c <fetchstr+0x3c>
    if(*s == 0)
80104750:	80 3b 00             	cmpb   $0x0,(%ebx)
80104753:	75 10                	jne    80104765 <fetchstr+0x35>
80104755:	eb 29                	jmp    80104780 <fetchstr+0x50>
80104757:	89 f6                	mov    %esi,%esi
80104759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104760:	80 3a 00             	cmpb   $0x0,(%edx)
80104763:	74 1b                	je     80104780 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104765:	83 c2 01             	add    $0x1,%edx
80104768:	39 d0                	cmp    %edx,%eax
8010476a:	77 f4                	ja     80104760 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
8010476c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
8010476f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104774:	5b                   	pop    %ebx
80104775:	5d                   	pop    %ebp
80104776:	c3                   	ret    
80104777:	89 f6                	mov    %esi,%esi
80104779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104780:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104783:	89 d0                	mov    %edx,%eax
80104785:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104787:	5b                   	pop    %ebx
80104788:	5d                   	pop    %ebp
80104789:	c3                   	ret    
8010478a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104790 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	56                   	push   %esi
80104794:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104795:	e8 46 f0 ff ff       	call   801037e0 <myproc>
8010479a:	8b 40 18             	mov    0x18(%eax),%eax
8010479d:	8b 55 08             	mov    0x8(%ebp),%edx
801047a0:	8b 40 44             	mov    0x44(%eax),%eax
801047a3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
801047a6:	e8 35 f0 ff ff       	call   801037e0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801047ab:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801047ad:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801047b0:	39 c6                	cmp    %eax,%esi
801047b2:	73 1c                	jae    801047d0 <argint+0x40>
801047b4:	8d 53 08             	lea    0x8(%ebx),%edx
801047b7:	39 d0                	cmp    %edx,%eax
801047b9:	72 15                	jb     801047d0 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
801047bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801047be:	8b 53 04             	mov    0x4(%ebx),%edx
801047c1:	89 10                	mov    %edx,(%eax)
  return 0;
801047c3:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
801047c5:	5b                   	pop    %ebx
801047c6:	5e                   	pop    %esi
801047c7:	5d                   	pop    %ebp
801047c8:	c3                   	ret    
801047c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
801047d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047d5:	eb ee                	jmp    801047c5 <argint+0x35>
801047d7:	89 f6                	mov    %esi,%esi
801047d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047e0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	56                   	push   %esi
801047e4:	53                   	push   %ebx
801047e5:	83 ec 10             	sub    $0x10,%esp
801047e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801047eb:	e8 f0 ef ff ff       	call   801037e0 <myproc>
801047f0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801047f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801047f5:	83 ec 08             	sub    $0x8,%esp
801047f8:	50                   	push   %eax
801047f9:	ff 75 08             	pushl  0x8(%ebp)
801047fc:	e8 8f ff ff ff       	call   80104790 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104801:	c1 e8 1f             	shr    $0x1f,%eax
80104804:	83 c4 10             	add    $0x10,%esp
80104807:	84 c0                	test   %al,%al
80104809:	75 2d                	jne    80104838 <argptr+0x58>
8010480b:	89 d8                	mov    %ebx,%eax
8010480d:	c1 e8 1f             	shr    $0x1f,%eax
80104810:	84 c0                	test   %al,%al
80104812:	75 24                	jne    80104838 <argptr+0x58>
80104814:	8b 16                	mov    (%esi),%edx
80104816:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104819:	39 c2                	cmp    %eax,%edx
8010481b:	76 1b                	jbe    80104838 <argptr+0x58>
8010481d:	01 c3                	add    %eax,%ebx
8010481f:	39 da                	cmp    %ebx,%edx
80104821:	72 15                	jb     80104838 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104823:	8b 55 0c             	mov    0xc(%ebp),%edx
80104826:	89 02                	mov    %eax,(%edx)
  return 0;
80104828:	31 c0                	xor    %eax,%eax
}
8010482a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010482d:	5b                   	pop    %ebx
8010482e:	5e                   	pop    %esi
8010482f:	5d                   	pop    %ebp
80104830:	c3                   	ret    
80104831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104838:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010483d:	eb eb                	jmp    8010482a <argptr+0x4a>
8010483f:	90                   	nop

80104840 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104846:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104849:	50                   	push   %eax
8010484a:	ff 75 08             	pushl  0x8(%ebp)
8010484d:	e8 3e ff ff ff       	call   80104790 <argint>
80104852:	83 c4 10             	add    $0x10,%esp
80104855:	85 c0                	test   %eax,%eax
80104857:	78 17                	js     80104870 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104859:	83 ec 08             	sub    $0x8,%esp
8010485c:	ff 75 0c             	pushl  0xc(%ebp)
8010485f:	ff 75 f4             	pushl  -0xc(%ebp)
80104862:	e8 c9 fe ff ff       	call   80104730 <fetchstr>
80104867:	83 c4 10             	add    $0x10,%esp
}
8010486a:	c9                   	leave  
8010486b:	c3                   	ret    
8010486c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104870:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104875:	c9                   	leave  
80104876:	c3                   	ret    
80104877:	89 f6                	mov    %esi,%esi
80104879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104880 <syscall>:
[SYS_date]    sys_date,
};

void
syscall(void)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	56                   	push   %esi
80104884:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104885:	e8 56 ef ff ff       	call   801037e0 <myproc>

  num = curproc->tf->eax;
8010488a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
8010488d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010488f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104892:	8d 50 ff             	lea    -0x1(%eax),%edx
80104895:	83 fa 15             	cmp    $0x15,%edx
80104898:	77 1e                	ja     801048b8 <syscall+0x38>
8010489a:	8b 14 85 a0 76 10 80 	mov    -0x7fef8960(,%eax,4),%edx
801048a1:	85 d2                	test   %edx,%edx
801048a3:	74 13                	je     801048b8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801048a5:	ff d2                	call   *%edx
801048a7:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801048aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048ad:	5b                   	pop    %ebx
801048ae:	5e                   	pop    %esi
801048af:	5d                   	pop    %ebp
801048b0:	c3                   	ret    
801048b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801048b8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801048b9:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801048bc:	50                   	push   %eax
801048bd:	ff 73 10             	pushl  0x10(%ebx)
801048c0:	68 71 76 10 80       	push   $0x80107671
801048c5:	e8 96 bd ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
801048ca:	8b 43 18             	mov    0x18(%ebx),%eax
801048cd:	83 c4 10             	add    $0x10,%esp
801048d0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801048d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048da:	5b                   	pop    %ebx
801048db:	5e                   	pop    %esi
801048dc:	5d                   	pop    %ebp
801048dd:	c3                   	ret    
801048de:	66 90                	xchg   %ax,%ax

801048e0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	57                   	push   %edi
801048e4:	56                   	push   %esi
801048e5:	53                   	push   %ebx
801048e6:	83 ec 54             	sub    $0x54,%esp
801048e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048ec:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801048ef:	89 4d b0             	mov    %ecx,-0x50(%ebp)
801048f2:	89 5d ac             	mov    %ebx,-0x54(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801048f5:	8d 5d c2             	lea    -0x3e(%ebp),%ebx
801048f8:	53                   	push   %ebx
801048f9:	50                   	push   %eax
801048fa:	e8 41 d6 ff ff       	call   80101f40 <nameiparent>
801048ff:	83 c4 10             	add    $0x10,%esp
80104902:	85 c0                	test   %eax,%eax
80104904:	0f 84 36 01 00 00    	je     80104a40 <create+0x160>
    return 0;
  ilock(dp);
8010490a:	83 ec 0c             	sub    $0xc,%esp
8010490d:	89 c6                	mov    %eax,%esi
8010490f:	50                   	push   %eax
80104910:	e8 7b cd ff ff       	call   80101690 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104915:	83 c4 0c             	add    $0xc,%esp
80104918:	6a 00                	push   $0x0
8010491a:	53                   	push   %ebx
8010491b:	56                   	push   %esi
8010491c:	e8 df d2 ff ff       	call   80101c00 <dirlookup>
80104921:	83 c4 10             	add    $0x10,%esp
80104924:	85 c0                	test   %eax,%eax
80104926:	89 c7                	mov    %eax,%edi
80104928:	74 56                	je     80104980 <create+0xa0>
    iunlockput(dp);
8010492a:	83 ec 0c             	sub    $0xc,%esp
8010492d:	56                   	push   %esi
8010492e:	e8 ed cf ff ff       	call   80101920 <iunlockput>
    ilock(ip);
80104933:	89 3c 24             	mov    %edi,(%esp)
80104936:	e8 55 cd ff ff       	call   80101690 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010493b:	83 c4 10             	add    $0x10,%esp
8010493e:	66 83 7d b4 02       	cmpw   $0x2,-0x4c(%ebp)
80104943:	75 1b                	jne    80104960 <create+0x80>
80104945:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
8010494a:	89 f9                	mov    %edi,%ecx
8010494c:	75 12                	jne    80104960 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010494e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104951:	89 c8                	mov    %ecx,%eax
80104953:	5b                   	pop    %ebx
80104954:	5e                   	pop    %esi
80104955:	5f                   	pop    %edi
80104956:	5d                   	pop    %ebp
80104957:	c3                   	ret    
80104958:	90                   	nop
80104959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104960:	83 ec 0c             	sub    $0xc,%esp
80104963:	57                   	push   %edi
80104964:	e8 b7 cf ff ff       	call   80101920 <iunlockput>
    return 0;
80104969:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010496c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
8010496f:	31 c9                	xor    %ecx,%ecx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104971:	89 c8                	mov    %ecx,%eax
80104973:	5b                   	pop    %ebx
80104974:	5e                   	pop    %esi
80104975:	5f                   	pop    %edi
80104976:	5d                   	pop    %ebp
80104977:	c3                   	ret    
80104978:	90                   	nop
80104979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104980:	0f bf 45 b4          	movswl -0x4c(%ebp),%eax
80104984:	83 ec 08             	sub    $0x8,%esp
80104987:	50                   	push   %eax
80104988:	ff 36                	pushl  (%esi)
8010498a:	e8 61 cb ff ff       	call   801014f0 <ialloc>
8010498f:	83 c4 10             	add    $0x10,%esp
80104992:	85 c0                	test   %eax,%eax
80104994:	89 c7                	mov    %eax,%edi
80104996:	0f 84 0c 01 00 00    	je     80104aa8 <create+0x1c8>
    panic("create: ialloc");

  ilock(ip);
8010499c:	83 ec 0c             	sub    $0xc,%esp
8010499f:	50                   	push   %eax
801049a0:	e8 eb cc ff ff       	call   80101690 <ilock>
  ip->major = major;
801049a5:	0f b7 45 b0          	movzwl -0x50(%ebp),%eax
801049a9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
801049ad:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
801049b1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
801049b5:	b8 01 00 00 00       	mov    $0x1,%eax
801049ba:	66 89 47 56          	mov    %ax,0x56(%edi)
  
  struct rtcdate r;
  cmostime(&r);
801049be:	8d 45 d0             	lea    -0x30(%ebp),%eax
801049c1:	89 04 24             	mov    %eax,(%esp)
801049c4:	e8 67 de ff ff       	call   80102830 <cmostime>
  ip->second = r.second;
801049c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
801049cc:	89 87 b8 00 00 00    	mov    %eax,0xb8(%edi)
  ip->minute = r.minute;
801049d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801049d5:	89 87 bc 00 00 00    	mov    %eax,0xbc(%edi)
  ip->hour = r.hour;
801049db:	8b 45 d8             	mov    -0x28(%ebp),%eax
801049de:	89 87 c0 00 00 00    	mov    %eax,0xc0(%edi)
  ip->day = r.day;
801049e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801049e7:	89 87 c4 00 00 00    	mov    %eax,0xc4(%edi)
  ip->month = r.month;
801049ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049f0:	89 87 c8 00 00 00    	mov    %eax,0xc8(%edi)
  ip->year = r.year;
801049f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801049f9:	89 87 cc 00 00 00    	mov    %eax,0xcc(%edi)

  iupdate(ip);
801049ff:	89 3c 24             	mov    %edi,(%esp)
80104a02:	e8 a9 cb ff ff       	call   801015b0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104a07:	83 c4 10             	add    $0x10,%esp
80104a0a:	66 83 7d b4 01       	cmpw   $0x1,-0x4c(%ebp)
80104a0f:	74 3f                	je     80104a50 <create+0x170>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104a11:	83 ec 04             	sub    $0x4,%esp
80104a14:	ff 77 04             	pushl  0x4(%edi)
80104a17:	53                   	push   %ebx
80104a18:	56                   	push   %esi
80104a19:	e8 42 d4 ff ff       	call   80101e60 <dirlink>
80104a1e:	83 c4 10             	add    $0x10,%esp
80104a21:	85 c0                	test   %eax,%eax
80104a23:	78 76                	js     80104a9b <create+0x1bb>
    panic("create: dirlink");

  iunlockput(dp);
80104a25:	83 ec 0c             	sub    $0xc,%esp
80104a28:	56                   	push   %esi
80104a29:	e8 f2 ce ff ff       	call   80101920 <iunlockput>

  return ip;
80104a2e:	83 c4 10             	add    $0x10,%esp
}
80104a31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104a34:	89 f9                	mov    %edi,%ecx
}
80104a36:	89 c8                	mov    %ecx,%eax
80104a38:	5b                   	pop    %ebx
80104a39:	5e                   	pop    %esi
80104a3a:	5f                   	pop    %edi
80104a3b:	5d                   	pop    %ebp
80104a3c:	c3                   	ret    
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104a40:	31 c9                	xor    %ecx,%ecx
80104a42:	e9 07 ff ff ff       	jmp    8010494e <create+0x6e>
80104a47:	89 f6                	mov    %esi,%esi
80104a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->year = r.year;

  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104a50:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80104a55:	83 ec 0c             	sub    $0xc,%esp
80104a58:	56                   	push   %esi
80104a59:	e8 52 cb ff ff       	call   801015b0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104a5e:	83 c4 0c             	add    $0xc,%esp
80104a61:	ff 77 04             	pushl  0x4(%edi)
80104a64:	68 18 77 10 80       	push   $0x80107718
80104a69:	57                   	push   %edi
80104a6a:	e8 f1 d3 ff ff       	call   80101e60 <dirlink>
80104a6f:	83 c4 10             	add    $0x10,%esp
80104a72:	85 c0                	test   %eax,%eax
80104a74:	78 18                	js     80104a8e <create+0x1ae>
80104a76:	83 ec 04             	sub    $0x4,%esp
80104a79:	ff 76 04             	pushl  0x4(%esi)
80104a7c:	68 17 77 10 80       	push   $0x80107717
80104a81:	57                   	push   %edi
80104a82:	e8 d9 d3 ff ff       	call   80101e60 <dirlink>
80104a87:	83 c4 10             	add    $0x10,%esp
80104a8a:	85 c0                	test   %eax,%eax
80104a8c:	79 83                	jns    80104a11 <create+0x131>
      panic("create dots");
80104a8e:	83 ec 0c             	sub    $0xc,%esp
80104a91:	68 0b 77 10 80       	push   $0x8010770b
80104a96:	e8 d5 b8 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104a9b:	83 ec 0c             	sub    $0xc,%esp
80104a9e:	68 1a 77 10 80       	push   $0x8010771a
80104aa3:	e8 c8 b8 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104aa8:	83 ec 0c             	sub    $0xc,%esp
80104aab:	68 fc 76 10 80       	push   $0x801076fc
80104ab0:	e8 bb b8 ff ff       	call   80100370 <panic>
80104ab5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ac0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	56                   	push   %esi
80104ac4:	53                   	push   %ebx
80104ac5:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104ac7:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104aca:	89 d3                	mov    %edx,%ebx
80104acc:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104acf:	50                   	push   %eax
80104ad0:	6a 00                	push   $0x0
80104ad2:	e8 b9 fc ff ff       	call   80104790 <argint>
80104ad7:	83 c4 10             	add    $0x10,%esp
80104ada:	85 c0                	test   %eax,%eax
80104adc:	78 32                	js     80104b10 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104ade:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ae2:	77 2c                	ja     80104b10 <argfd.constprop.0+0x50>
80104ae4:	e8 f7 ec ff ff       	call   801037e0 <myproc>
80104ae9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104aec:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104af0:	85 c0                	test   %eax,%eax
80104af2:	74 1c                	je     80104b10 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104af4:	85 f6                	test   %esi,%esi
80104af6:	74 02                	je     80104afa <argfd.constprop.0+0x3a>
    *pfd = fd;
80104af8:	89 16                	mov    %edx,(%esi)
  if(pf)
80104afa:	85 db                	test   %ebx,%ebx
80104afc:	74 22                	je     80104b20 <argfd.constprop.0+0x60>
    *pf = f;
80104afe:	89 03                	mov    %eax,(%ebx)
  return 0;
80104b00:	31 c0                	xor    %eax,%eax
}
80104b02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b05:	5b                   	pop    %ebx
80104b06:	5e                   	pop    %esi
80104b07:	5d                   	pop    %ebp
80104b08:	c3                   	ret    
80104b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b10:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104b13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104b18:	5b                   	pop    %ebx
80104b19:	5e                   	pop    %esi
80104b1a:	5d                   	pop    %ebp
80104b1b:	c3                   	ret    
80104b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104b20:	31 c0                	xor    %eax,%eax
80104b22:	eb de                	jmp    80104b02 <argfd.constprop.0+0x42>
80104b24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104b30 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104b30:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b31:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104b33:	89 e5                	mov    %esp,%ebp
80104b35:	56                   	push   %esi
80104b36:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b37:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104b3a:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b3d:	e8 7e ff ff ff       	call   80104ac0 <argfd.constprop.0>
80104b42:	85 c0                	test   %eax,%eax
80104b44:	78 1a                	js     80104b60 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104b46:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80104b48:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80104b4b:	e8 90 ec ff ff       	call   801037e0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104b50:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104b54:	85 d2                	test   %edx,%edx
80104b56:	74 18                	je     80104b70 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104b58:	83 c3 01             	add    $0x1,%ebx
80104b5b:	83 fb 10             	cmp    $0x10,%ebx
80104b5e:	75 f0                	jne    80104b50 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104b60:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104b63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104b68:	5b                   	pop    %ebx
80104b69:	5e                   	pop    %esi
80104b6a:	5d                   	pop    %ebp
80104b6b:	c3                   	ret    
80104b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104b70:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104b74:	83 ec 0c             	sub    $0xc,%esp
80104b77:	ff 75 f4             	pushl  -0xc(%ebp)
80104b7a:	e8 61 c2 ff ff       	call   80100de0 <filedup>
  return fd;
80104b7f:	83 c4 10             	add    $0x10,%esp
}
80104b82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104b85:	89 d8                	mov    %ebx,%eax
}
80104b87:	5b                   	pop    %ebx
80104b88:	5e                   	pop    %esi
80104b89:	5d                   	pop    %ebp
80104b8a:	c3                   	ret    
80104b8b:	90                   	nop
80104b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b90 <sys_read>:

int
sys_read(void)
{
80104b90:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b91:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104b93:	89 e5                	mov    %esp,%ebp
80104b95:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b98:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b9b:	e8 20 ff ff ff       	call   80104ac0 <argfd.constprop.0>
80104ba0:	85 c0                	test   %eax,%eax
80104ba2:	78 4c                	js     80104bf0 <sys_read+0x60>
80104ba4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ba7:	83 ec 08             	sub    $0x8,%esp
80104baa:	50                   	push   %eax
80104bab:	6a 02                	push   $0x2
80104bad:	e8 de fb ff ff       	call   80104790 <argint>
80104bb2:	83 c4 10             	add    $0x10,%esp
80104bb5:	85 c0                	test   %eax,%eax
80104bb7:	78 37                	js     80104bf0 <sys_read+0x60>
80104bb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bbc:	83 ec 04             	sub    $0x4,%esp
80104bbf:	ff 75 f0             	pushl  -0x10(%ebp)
80104bc2:	50                   	push   %eax
80104bc3:	6a 01                	push   $0x1
80104bc5:	e8 16 fc ff ff       	call   801047e0 <argptr>
80104bca:	83 c4 10             	add    $0x10,%esp
80104bcd:	85 c0                	test   %eax,%eax
80104bcf:	78 1f                	js     80104bf0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104bd1:	83 ec 04             	sub    $0x4,%esp
80104bd4:	ff 75 f0             	pushl  -0x10(%ebp)
80104bd7:	ff 75 f4             	pushl  -0xc(%ebp)
80104bda:	ff 75 ec             	pushl  -0x14(%ebp)
80104bdd:	e8 6e c3 ff ff       	call   80100f50 <fileread>
80104be2:	83 c4 10             	add    $0x10,%esp
}
80104be5:	c9                   	leave  
80104be6:	c3                   	ret    
80104be7:	89 f6                	mov    %esi,%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104bf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104bf5:	c9                   	leave  
80104bf6:	c3                   	ret    
80104bf7:	89 f6                	mov    %esi,%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c00 <sys_write>:

int
sys_write(void)
{
80104c00:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c01:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104c03:	89 e5                	mov    %esp,%ebp
80104c05:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c08:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104c0b:	e8 b0 fe ff ff       	call   80104ac0 <argfd.constprop.0>
80104c10:	85 c0                	test   %eax,%eax
80104c12:	78 4c                	js     80104c60 <sys_write+0x60>
80104c14:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c17:	83 ec 08             	sub    $0x8,%esp
80104c1a:	50                   	push   %eax
80104c1b:	6a 02                	push   $0x2
80104c1d:	e8 6e fb ff ff       	call   80104790 <argint>
80104c22:	83 c4 10             	add    $0x10,%esp
80104c25:	85 c0                	test   %eax,%eax
80104c27:	78 37                	js     80104c60 <sys_write+0x60>
80104c29:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c2c:	83 ec 04             	sub    $0x4,%esp
80104c2f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c32:	50                   	push   %eax
80104c33:	6a 01                	push   $0x1
80104c35:	e8 a6 fb ff ff       	call   801047e0 <argptr>
80104c3a:	83 c4 10             	add    $0x10,%esp
80104c3d:	85 c0                	test   %eax,%eax
80104c3f:	78 1f                	js     80104c60 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104c41:	83 ec 04             	sub    $0x4,%esp
80104c44:	ff 75 f0             	pushl  -0x10(%ebp)
80104c47:	ff 75 f4             	pushl  -0xc(%ebp)
80104c4a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c4d:	e8 8e c3 ff ff       	call   80100fe0 <filewrite>
80104c52:	83 c4 10             	add    $0x10,%esp
}
80104c55:	c9                   	leave  
80104c56:	c3                   	ret    
80104c57:	89 f6                	mov    %esi,%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104c65:	c9                   	leave  
80104c66:	c3                   	ret    
80104c67:	89 f6                	mov    %esi,%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <sys_close>:

int
sys_close(void)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104c76:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104c79:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c7c:	e8 3f fe ff ff       	call   80104ac0 <argfd.constprop.0>
80104c81:	85 c0                	test   %eax,%eax
80104c83:	78 2b                	js     80104cb0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80104c85:	e8 56 eb ff ff       	call   801037e0 <myproc>
80104c8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104c8d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80104c90:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104c97:	00 
  fileclose(f);
80104c98:	ff 75 f4             	pushl  -0xc(%ebp)
80104c9b:	e8 90 c1 ff ff       	call   80100e30 <fileclose>
  return 0;
80104ca0:	83 c4 10             	add    $0x10,%esp
80104ca3:	31 c0                	xor    %eax,%eax
}
80104ca5:	c9                   	leave  
80104ca6:	c3                   	ret    
80104ca7:	89 f6                	mov    %esi,%esi
80104ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104cb5:	c9                   	leave  
80104cb6:	c3                   	ret    
80104cb7:	89 f6                	mov    %esi,%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cc0 <sys_fstat>:

int
sys_fstat(void)
{
80104cc0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104cc1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104cc3:	89 e5                	mov    %esp,%ebp
80104cc5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104cc8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104ccb:	e8 f0 fd ff ff       	call   80104ac0 <argfd.constprop.0>
80104cd0:	85 c0                	test   %eax,%eax
80104cd2:	78 2c                	js     80104d00 <sys_fstat+0x40>
80104cd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cd7:	83 ec 04             	sub    $0x4,%esp
80104cda:	6a 2c                	push   $0x2c
80104cdc:	50                   	push   %eax
80104cdd:	6a 01                	push   $0x1
80104cdf:	e8 fc fa ff ff       	call   801047e0 <argptr>
80104ce4:	83 c4 10             	add    $0x10,%esp
80104ce7:	85 c0                	test   %eax,%eax
80104ce9:	78 15                	js     80104d00 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104ceb:	83 ec 08             	sub    $0x8,%esp
80104cee:	ff 75 f4             	pushl  -0xc(%ebp)
80104cf1:	ff 75 f0             	pushl  -0x10(%ebp)
80104cf4:	e8 07 c2 ff ff       	call   80100f00 <filestat>
80104cf9:	83 c4 10             	add    $0x10,%esp
}
80104cfc:	c9                   	leave  
80104cfd:	c3                   	ret    
80104cfe:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104d05:	c9                   	leave  
80104d06:	c3                   	ret    
80104d07:	89 f6                	mov    %esi,%esi
80104d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d10 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	57                   	push   %edi
80104d14:	56                   	push   %esi
80104d15:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d16:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104d19:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d1c:	50                   	push   %eax
80104d1d:	6a 00                	push   $0x0
80104d1f:	e8 1c fb ff ff       	call   80104840 <argstr>
80104d24:	83 c4 10             	add    $0x10,%esp
80104d27:	85 c0                	test   %eax,%eax
80104d29:	0f 88 fb 00 00 00    	js     80104e2a <sys_link+0x11a>
80104d2f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104d32:	83 ec 08             	sub    $0x8,%esp
80104d35:	50                   	push   %eax
80104d36:	6a 01                	push   $0x1
80104d38:	e8 03 fb ff ff       	call   80104840 <argstr>
80104d3d:	83 c4 10             	add    $0x10,%esp
80104d40:	85 c0                	test   %eax,%eax
80104d42:	0f 88 e2 00 00 00    	js     80104e2a <sys_link+0x11a>
    return -1;

  begin_op();
80104d48:	e8 63 de ff ff       	call   80102bb0 <begin_op>
  if((ip = namei(old)) == 0){
80104d4d:	83 ec 0c             	sub    $0xc,%esp
80104d50:	ff 75 d4             	pushl  -0x2c(%ebp)
80104d53:	e8 c8 d1 ff ff       	call   80101f20 <namei>
80104d58:	83 c4 10             	add    $0x10,%esp
80104d5b:	85 c0                	test   %eax,%eax
80104d5d:	89 c3                	mov    %eax,%ebx
80104d5f:	0f 84 f3 00 00 00    	je     80104e58 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104d65:	83 ec 0c             	sub    $0xc,%esp
80104d68:	50                   	push   %eax
80104d69:	e8 22 c9 ff ff       	call   80101690 <ilock>
  if(ip->type == T_DIR){
80104d6e:	83 c4 10             	add    $0x10,%esp
80104d71:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d76:	0f 84 c4 00 00 00    	je     80104e40 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104d7c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d81:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104d84:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104d87:	53                   	push   %ebx
80104d88:	e8 23 c8 ff ff       	call   801015b0 <iupdate>
  iunlock(ip);
80104d8d:	89 1c 24             	mov    %ebx,(%esp)
80104d90:	e8 db c9 ff ff       	call   80101770 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104d95:	58                   	pop    %eax
80104d96:	5a                   	pop    %edx
80104d97:	57                   	push   %edi
80104d98:	ff 75 d0             	pushl  -0x30(%ebp)
80104d9b:	e8 a0 d1 ff ff       	call   80101f40 <nameiparent>
80104da0:	83 c4 10             	add    $0x10,%esp
80104da3:	85 c0                	test   %eax,%eax
80104da5:	89 c6                	mov    %eax,%esi
80104da7:	74 5b                	je     80104e04 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104da9:	83 ec 0c             	sub    $0xc,%esp
80104dac:	50                   	push   %eax
80104dad:	e8 de c8 ff ff       	call   80101690 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104db2:	83 c4 10             	add    $0x10,%esp
80104db5:	8b 03                	mov    (%ebx),%eax
80104db7:	39 06                	cmp    %eax,(%esi)
80104db9:	75 3d                	jne    80104df8 <sys_link+0xe8>
80104dbb:	83 ec 04             	sub    $0x4,%esp
80104dbe:	ff 73 04             	pushl  0x4(%ebx)
80104dc1:	57                   	push   %edi
80104dc2:	56                   	push   %esi
80104dc3:	e8 98 d0 ff ff       	call   80101e60 <dirlink>
80104dc8:	83 c4 10             	add    $0x10,%esp
80104dcb:	85 c0                	test   %eax,%eax
80104dcd:	78 29                	js     80104df8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104dcf:	83 ec 0c             	sub    $0xc,%esp
80104dd2:	56                   	push   %esi
80104dd3:	e8 48 cb ff ff       	call   80101920 <iunlockput>
  iput(ip);
80104dd8:	89 1c 24             	mov    %ebx,(%esp)
80104ddb:	e8 e0 c9 ff ff       	call   801017c0 <iput>

  end_op();
80104de0:	e8 3b de ff ff       	call   80102c20 <end_op>

  return 0;
80104de5:	83 c4 10             	add    $0x10,%esp
80104de8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104dea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ded:	5b                   	pop    %ebx
80104dee:	5e                   	pop    %esi
80104def:	5f                   	pop    %edi
80104df0:	5d                   	pop    %ebp
80104df1:	c3                   	ret    
80104df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104df8:	83 ec 0c             	sub    $0xc,%esp
80104dfb:	56                   	push   %esi
80104dfc:	e8 1f cb ff ff       	call   80101920 <iunlockput>
    goto bad;
80104e01:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104e04:	83 ec 0c             	sub    $0xc,%esp
80104e07:	53                   	push   %ebx
80104e08:	e8 83 c8 ff ff       	call   80101690 <ilock>
  ip->nlink--;
80104e0d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e12:	89 1c 24             	mov    %ebx,(%esp)
80104e15:	e8 96 c7 ff ff       	call   801015b0 <iupdate>
  iunlockput(ip);
80104e1a:	89 1c 24             	mov    %ebx,(%esp)
80104e1d:	e8 fe ca ff ff       	call   80101920 <iunlockput>
  end_op();
80104e22:	e8 f9 dd ff ff       	call   80102c20 <end_op>
  return -1;
80104e27:	83 c4 10             	add    $0x10,%esp
}
80104e2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104e2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e32:	5b                   	pop    %ebx
80104e33:	5e                   	pop    %esi
80104e34:	5f                   	pop    %edi
80104e35:	5d                   	pop    %ebp
80104e36:	c3                   	ret    
80104e37:	89 f6                	mov    %esi,%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104e40:	83 ec 0c             	sub    $0xc,%esp
80104e43:	53                   	push   %ebx
80104e44:	e8 d7 ca ff ff       	call   80101920 <iunlockput>
    end_op();
80104e49:	e8 d2 dd ff ff       	call   80102c20 <end_op>
    return -1;
80104e4e:	83 c4 10             	add    $0x10,%esp
80104e51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e56:	eb 92                	jmp    80104dea <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80104e58:	e8 c3 dd ff ff       	call   80102c20 <end_op>
    return -1;
80104e5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e62:	eb 86                	jmp    80104dea <sys_link+0xda>
80104e64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e70 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	57                   	push   %edi
80104e74:	56                   	push   %esi
80104e75:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104e76:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104e79:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104e7c:	50                   	push   %eax
80104e7d:	6a 00                	push   $0x0
80104e7f:	e8 bc f9 ff ff       	call   80104840 <argstr>
80104e84:	83 c4 10             	add    $0x10,%esp
80104e87:	85 c0                	test   %eax,%eax
80104e89:	0f 88 82 01 00 00    	js     80105011 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80104e8f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80104e92:	e8 19 dd ff ff       	call   80102bb0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104e97:	83 ec 08             	sub    $0x8,%esp
80104e9a:	53                   	push   %ebx
80104e9b:	ff 75 c0             	pushl  -0x40(%ebp)
80104e9e:	e8 9d d0 ff ff       	call   80101f40 <nameiparent>
80104ea3:	83 c4 10             	add    $0x10,%esp
80104ea6:	85 c0                	test   %eax,%eax
80104ea8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104eab:	0f 84 6a 01 00 00    	je     8010501b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80104eb1:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104eb4:	83 ec 0c             	sub    $0xc,%esp
80104eb7:	56                   	push   %esi
80104eb8:	e8 d3 c7 ff ff       	call   80101690 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104ebd:	58                   	pop    %eax
80104ebe:	5a                   	pop    %edx
80104ebf:	68 18 77 10 80       	push   $0x80107718
80104ec4:	53                   	push   %ebx
80104ec5:	e8 16 cd ff ff       	call   80101be0 <namecmp>
80104eca:	83 c4 10             	add    $0x10,%esp
80104ecd:	85 c0                	test   %eax,%eax
80104ecf:	0f 84 fc 00 00 00    	je     80104fd1 <sys_unlink+0x161>
80104ed5:	83 ec 08             	sub    $0x8,%esp
80104ed8:	68 17 77 10 80       	push   $0x80107717
80104edd:	53                   	push   %ebx
80104ede:	e8 fd cc ff ff       	call   80101be0 <namecmp>
80104ee3:	83 c4 10             	add    $0x10,%esp
80104ee6:	85 c0                	test   %eax,%eax
80104ee8:	0f 84 e3 00 00 00    	je     80104fd1 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104eee:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104ef1:	83 ec 04             	sub    $0x4,%esp
80104ef4:	50                   	push   %eax
80104ef5:	53                   	push   %ebx
80104ef6:	56                   	push   %esi
80104ef7:	e8 04 cd ff ff       	call   80101c00 <dirlookup>
80104efc:	83 c4 10             	add    $0x10,%esp
80104eff:	85 c0                	test   %eax,%eax
80104f01:	89 c3                	mov    %eax,%ebx
80104f03:	0f 84 c8 00 00 00    	je     80104fd1 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80104f09:	83 ec 0c             	sub    $0xc,%esp
80104f0c:	50                   	push   %eax
80104f0d:	e8 7e c7 ff ff       	call   80101690 <ilock>

  if(ip->nlink < 1)
80104f12:	83 c4 10             	add    $0x10,%esp
80104f15:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104f1a:	0f 8e 24 01 00 00    	jle    80105044 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104f20:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f25:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104f28:	74 66                	je     80104f90 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104f2a:	83 ec 04             	sub    $0x4,%esp
80104f2d:	6a 10                	push   $0x10
80104f2f:	6a 00                	push   $0x0
80104f31:	56                   	push   %esi
80104f32:	e8 49 f5 ff ff       	call   80104480 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f37:	6a 10                	push   $0x10
80104f39:	ff 75 c4             	pushl  -0x3c(%ebp)
80104f3c:	56                   	push   %esi
80104f3d:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f40:	e8 6b cb ff ff       	call   80101ab0 <writei>
80104f45:	83 c4 20             	add    $0x20,%esp
80104f48:	83 f8 10             	cmp    $0x10,%eax
80104f4b:	0f 85 e6 00 00 00    	jne    80105037 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104f51:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f56:	0f 84 9c 00 00 00    	je     80104ff8 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104f5c:	83 ec 0c             	sub    $0xc,%esp
80104f5f:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f62:	e8 b9 c9 ff ff       	call   80101920 <iunlockput>

  ip->nlink--;
80104f67:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f6c:	89 1c 24             	mov    %ebx,(%esp)
80104f6f:	e8 3c c6 ff ff       	call   801015b0 <iupdate>
  iunlockput(ip);
80104f74:	89 1c 24             	mov    %ebx,(%esp)
80104f77:	e8 a4 c9 ff ff       	call   80101920 <iunlockput>

  end_op();
80104f7c:	e8 9f dc ff ff       	call   80102c20 <end_op>

  return 0;
80104f81:	83 c4 10             	add    $0x10,%esp
80104f84:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104f86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f89:	5b                   	pop    %ebx
80104f8a:	5e                   	pop    %esi
80104f8b:	5f                   	pop    %edi
80104f8c:	5d                   	pop    %ebp
80104f8d:	c3                   	ret    
80104f8e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104f90:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104f94:	76 94                	jbe    80104f2a <sys_unlink+0xba>
80104f96:	bf 20 00 00 00       	mov    $0x20,%edi
80104f9b:	eb 0f                	jmp    80104fac <sys_unlink+0x13c>
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi
80104fa0:	83 c7 10             	add    $0x10,%edi
80104fa3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104fa6:	0f 83 7e ff ff ff    	jae    80104f2a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104fac:	6a 10                	push   $0x10
80104fae:	57                   	push   %edi
80104faf:	56                   	push   %esi
80104fb0:	53                   	push   %ebx
80104fb1:	e8 fa c9 ff ff       	call   801019b0 <readi>
80104fb6:	83 c4 10             	add    $0x10,%esp
80104fb9:	83 f8 10             	cmp    $0x10,%eax
80104fbc:	75 6c                	jne    8010502a <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104fbe:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104fc3:	74 db                	je     80104fa0 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104fc5:	83 ec 0c             	sub    $0xc,%esp
80104fc8:	53                   	push   %ebx
80104fc9:	e8 52 c9 ff ff       	call   80101920 <iunlockput>
    goto bad;
80104fce:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104fd1:	83 ec 0c             	sub    $0xc,%esp
80104fd4:	ff 75 b4             	pushl  -0x4c(%ebp)
80104fd7:	e8 44 c9 ff ff       	call   80101920 <iunlockput>
  end_op();
80104fdc:	e8 3f dc ff ff       	call   80102c20 <end_op>
  return -1;
80104fe1:	83 c4 10             	add    $0x10,%esp
}
80104fe4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104fe7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fec:	5b                   	pop    %ebx
80104fed:	5e                   	pop    %esi
80104fee:	5f                   	pop    %edi
80104fef:	5d                   	pop    %ebp
80104ff0:	c3                   	ret    
80104ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104ff8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80104ffb:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104ffe:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105003:	50                   	push   %eax
80105004:	e8 a7 c5 ff ff       	call   801015b0 <iupdate>
80105009:	83 c4 10             	add    $0x10,%esp
8010500c:	e9 4b ff ff ff       	jmp    80104f5c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105011:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105016:	e9 6b ff ff ff       	jmp    80104f86 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
8010501b:	e8 00 dc ff ff       	call   80102c20 <end_op>
    return -1;
80105020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105025:	e9 5c ff ff ff       	jmp    80104f86 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010502a:	83 ec 0c             	sub    $0xc,%esp
8010502d:	68 3c 77 10 80       	push   $0x8010773c
80105032:	e8 39 b3 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105037:	83 ec 0c             	sub    $0xc,%esp
8010503a:	68 4e 77 10 80       	push   $0x8010774e
8010503f:	e8 2c b3 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105044:	83 ec 0c             	sub    $0xc,%esp
80105047:	68 2a 77 10 80       	push   $0x8010772a
8010504c:	e8 1f b3 ff ff       	call   80100370 <panic>
80105051:	eb 0d                	jmp    80105060 <sys_open>
80105053:	90                   	nop
80105054:	90                   	nop
80105055:	90                   	nop
80105056:	90                   	nop
80105057:	90                   	nop
80105058:	90                   	nop
80105059:	90                   	nop
8010505a:	90                   	nop
8010505b:	90                   	nop
8010505c:	90                   	nop
8010505d:	90                   	nop
8010505e:	90                   	nop
8010505f:	90                   	nop

80105060 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	57                   	push   %edi
80105064:	56                   	push   %esi
80105065:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105066:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105069:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010506c:	50                   	push   %eax
8010506d:	6a 00                	push   $0x0
8010506f:	e8 cc f7 ff ff       	call   80104840 <argstr>
80105074:	83 c4 10             	add    $0x10,%esp
80105077:	85 c0                	test   %eax,%eax
80105079:	0f 88 9e 00 00 00    	js     8010511d <sys_open+0xbd>
8010507f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105082:	83 ec 08             	sub    $0x8,%esp
80105085:	50                   	push   %eax
80105086:	6a 01                	push   $0x1
80105088:	e8 03 f7 ff ff       	call   80104790 <argint>
8010508d:	83 c4 10             	add    $0x10,%esp
80105090:	85 c0                	test   %eax,%eax
80105092:	0f 88 85 00 00 00    	js     8010511d <sys_open+0xbd>
    return -1;

  begin_op();
80105098:	e8 13 db ff ff       	call   80102bb0 <begin_op>

  if(omode & O_CREATE){
8010509d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801050a1:	0f 85 89 00 00 00    	jne    80105130 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801050a7:	83 ec 0c             	sub    $0xc,%esp
801050aa:	ff 75 e0             	pushl  -0x20(%ebp)
801050ad:	e8 6e ce ff ff       	call   80101f20 <namei>
801050b2:	83 c4 10             	add    $0x10,%esp
801050b5:	85 c0                	test   %eax,%eax
801050b7:	89 c6                	mov    %eax,%esi
801050b9:	0f 84 8e 00 00 00    	je     8010514d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
801050bf:	83 ec 0c             	sub    $0xc,%esp
801050c2:	50                   	push   %eax
801050c3:	e8 c8 c5 ff ff       	call   80101690 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801050c8:	83 c4 10             	add    $0x10,%esp
801050cb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801050d0:	0f 84 d2 00 00 00    	je     801051a8 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801050d6:	e8 95 bc ff ff       	call   80100d70 <filealloc>
801050db:	85 c0                	test   %eax,%eax
801050dd:	89 c7                	mov    %eax,%edi
801050df:	74 2b                	je     8010510c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801050e1:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801050e3:	e8 f8 e6 ff ff       	call   801037e0 <myproc>
801050e8:	90                   	nop
801050e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801050f0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801050f4:	85 d2                	test   %edx,%edx
801050f6:	74 68                	je     80105160 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801050f8:	83 c3 01             	add    $0x1,%ebx
801050fb:	83 fb 10             	cmp    $0x10,%ebx
801050fe:	75 f0                	jne    801050f0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105100:	83 ec 0c             	sub    $0xc,%esp
80105103:	57                   	push   %edi
80105104:	e8 27 bd ff ff       	call   80100e30 <fileclose>
80105109:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010510c:	83 ec 0c             	sub    $0xc,%esp
8010510f:	56                   	push   %esi
80105110:	e8 0b c8 ff ff       	call   80101920 <iunlockput>
    end_op();
80105115:	e8 06 db ff ff       	call   80102c20 <end_op>
    return -1;
8010511a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010511d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105125:	5b                   	pop    %ebx
80105126:	5e                   	pop    %esi
80105127:	5f                   	pop    %edi
80105128:	5d                   	pop    %ebp
80105129:	c3                   	ret    
8010512a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105130:	83 ec 0c             	sub    $0xc,%esp
80105133:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105136:	31 c9                	xor    %ecx,%ecx
80105138:	6a 00                	push   $0x0
8010513a:	ba 02 00 00 00       	mov    $0x2,%edx
8010513f:	e8 9c f7 ff ff       	call   801048e0 <create>
    if(ip == 0){
80105144:	83 c4 10             	add    $0x10,%esp
80105147:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105149:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010514b:	75 89                	jne    801050d6 <sys_open+0x76>
      end_op();
8010514d:	e8 ce da ff ff       	call   80102c20 <end_op>
      return -1;
80105152:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105157:	eb 43                	jmp    8010519c <sys_open+0x13c>
80105159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105160:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105163:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105167:	56                   	push   %esi
80105168:	e8 03 c6 ff ff       	call   80101770 <iunlock>
  end_op();
8010516d:	e8 ae da ff ff       	call   80102c20 <end_op>

  f->type = FD_INODE;
80105172:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105178:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010517b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010517e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105181:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105188:	89 d0                	mov    %edx,%eax
8010518a:	83 e0 01             	and    $0x1,%eax
8010518d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105190:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105193:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105196:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
8010519a:	89 d8                	mov    %ebx,%eax
}
8010519c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010519f:	5b                   	pop    %ebx
801051a0:	5e                   	pop    %esi
801051a1:	5f                   	pop    %edi
801051a2:	5d                   	pop    %ebp
801051a3:	c3                   	ret    
801051a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
801051a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801051ab:	85 c9                	test   %ecx,%ecx
801051ad:	0f 84 23 ff ff ff    	je     801050d6 <sys_open+0x76>
801051b3:	e9 54 ff ff ff       	jmp    8010510c <sys_open+0xac>
801051b8:	90                   	nop
801051b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801051c0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801051c6:	e8 e5 d9 ff ff       	call   80102bb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801051cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051ce:	83 ec 08             	sub    $0x8,%esp
801051d1:	50                   	push   %eax
801051d2:	6a 00                	push   $0x0
801051d4:	e8 67 f6 ff ff       	call   80104840 <argstr>
801051d9:	83 c4 10             	add    $0x10,%esp
801051dc:	85 c0                	test   %eax,%eax
801051de:	78 30                	js     80105210 <sys_mkdir+0x50>
801051e0:	83 ec 0c             	sub    $0xc,%esp
801051e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051e6:	31 c9                	xor    %ecx,%ecx
801051e8:	6a 00                	push   $0x0
801051ea:	ba 01 00 00 00       	mov    $0x1,%edx
801051ef:	e8 ec f6 ff ff       	call   801048e0 <create>
801051f4:	83 c4 10             	add    $0x10,%esp
801051f7:	85 c0                	test   %eax,%eax
801051f9:	74 15                	je     80105210 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801051fb:	83 ec 0c             	sub    $0xc,%esp
801051fe:	50                   	push   %eax
801051ff:	e8 1c c7 ff ff       	call   80101920 <iunlockput>
  end_op();
80105204:	e8 17 da ff ff       	call   80102c20 <end_op>
  return 0;
80105209:	83 c4 10             	add    $0x10,%esp
8010520c:	31 c0                	xor    %eax,%eax
}
8010520e:	c9                   	leave  
8010520f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105210:	e8 0b da ff ff       	call   80102c20 <end_op>
    return -1;
80105215:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010521a:	c9                   	leave  
8010521b:	c3                   	ret    
8010521c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105220 <sys_mknod>:

int
sys_mknod(void)
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105226:	e8 85 d9 ff ff       	call   80102bb0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010522b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010522e:	83 ec 08             	sub    $0x8,%esp
80105231:	50                   	push   %eax
80105232:	6a 00                	push   $0x0
80105234:	e8 07 f6 ff ff       	call   80104840 <argstr>
80105239:	83 c4 10             	add    $0x10,%esp
8010523c:	85 c0                	test   %eax,%eax
8010523e:	78 60                	js     801052a0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105240:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105243:	83 ec 08             	sub    $0x8,%esp
80105246:	50                   	push   %eax
80105247:	6a 01                	push   $0x1
80105249:	e8 42 f5 ff ff       	call   80104790 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010524e:	83 c4 10             	add    $0x10,%esp
80105251:	85 c0                	test   %eax,%eax
80105253:	78 4b                	js     801052a0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105255:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105258:	83 ec 08             	sub    $0x8,%esp
8010525b:	50                   	push   %eax
8010525c:	6a 02                	push   $0x2
8010525e:	e8 2d f5 ff ff       	call   80104790 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105263:	83 c4 10             	add    $0x10,%esp
80105266:	85 c0                	test   %eax,%eax
80105268:	78 36                	js     801052a0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010526a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010526e:	83 ec 0c             	sub    $0xc,%esp
80105271:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105275:	ba 03 00 00 00       	mov    $0x3,%edx
8010527a:	50                   	push   %eax
8010527b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010527e:	e8 5d f6 ff ff       	call   801048e0 <create>
80105283:	83 c4 10             	add    $0x10,%esp
80105286:	85 c0                	test   %eax,%eax
80105288:	74 16                	je     801052a0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010528a:	83 ec 0c             	sub    $0xc,%esp
8010528d:	50                   	push   %eax
8010528e:	e8 8d c6 ff ff       	call   80101920 <iunlockput>
  end_op();
80105293:	e8 88 d9 ff ff       	call   80102c20 <end_op>
  return 0;
80105298:	83 c4 10             	add    $0x10,%esp
8010529b:	31 c0                	xor    %eax,%eax
}
8010529d:	c9                   	leave  
8010529e:	c3                   	ret    
8010529f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801052a0:	e8 7b d9 ff ff       	call   80102c20 <end_op>
    return -1;
801052a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801052aa:	c9                   	leave  
801052ab:	c3                   	ret    
801052ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052b0 <sys_chdir>:

int
sys_chdir(void)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	56                   	push   %esi
801052b4:	53                   	push   %ebx
801052b5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801052b8:	e8 23 e5 ff ff       	call   801037e0 <myproc>
801052bd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801052bf:	e8 ec d8 ff ff       	call   80102bb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801052c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052c7:	83 ec 08             	sub    $0x8,%esp
801052ca:	50                   	push   %eax
801052cb:	6a 00                	push   $0x0
801052cd:	e8 6e f5 ff ff       	call   80104840 <argstr>
801052d2:	83 c4 10             	add    $0x10,%esp
801052d5:	85 c0                	test   %eax,%eax
801052d7:	78 77                	js     80105350 <sys_chdir+0xa0>
801052d9:	83 ec 0c             	sub    $0xc,%esp
801052dc:	ff 75 f4             	pushl  -0xc(%ebp)
801052df:	e8 3c cc ff ff       	call   80101f20 <namei>
801052e4:	83 c4 10             	add    $0x10,%esp
801052e7:	85 c0                	test   %eax,%eax
801052e9:	89 c3                	mov    %eax,%ebx
801052eb:	74 63                	je     80105350 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801052ed:	83 ec 0c             	sub    $0xc,%esp
801052f0:	50                   	push   %eax
801052f1:	e8 9a c3 ff ff       	call   80101690 <ilock>
  if(ip->type != T_DIR){
801052f6:	83 c4 10             	add    $0x10,%esp
801052f9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052fe:	75 30                	jne    80105330 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105300:	83 ec 0c             	sub    $0xc,%esp
80105303:	53                   	push   %ebx
80105304:	e8 67 c4 ff ff       	call   80101770 <iunlock>
  iput(curproc->cwd);
80105309:	58                   	pop    %eax
8010530a:	ff 76 68             	pushl  0x68(%esi)
8010530d:	e8 ae c4 ff ff       	call   801017c0 <iput>
  end_op();
80105312:	e8 09 d9 ff ff       	call   80102c20 <end_op>
  curproc->cwd = ip;
80105317:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010531a:	83 c4 10             	add    $0x10,%esp
8010531d:	31 c0                	xor    %eax,%eax
}
8010531f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105322:	5b                   	pop    %ebx
80105323:	5e                   	pop    %esi
80105324:	5d                   	pop    %ebp
80105325:	c3                   	ret    
80105326:	8d 76 00             	lea    0x0(%esi),%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105330:	83 ec 0c             	sub    $0xc,%esp
80105333:	53                   	push   %ebx
80105334:	e8 e7 c5 ff ff       	call   80101920 <iunlockput>
    end_op();
80105339:	e8 e2 d8 ff ff       	call   80102c20 <end_op>
    return -1;
8010533e:	83 c4 10             	add    $0x10,%esp
80105341:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105346:	eb d7                	jmp    8010531f <sys_chdir+0x6f>
80105348:	90                   	nop
80105349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105350:	e8 cb d8 ff ff       	call   80102c20 <end_op>
    return -1;
80105355:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010535a:	eb c3                	jmp    8010531f <sys_chdir+0x6f>
8010535c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105360 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	57                   	push   %edi
80105364:	56                   	push   %esi
80105365:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105366:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010536c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105372:	50                   	push   %eax
80105373:	6a 00                	push   $0x0
80105375:	e8 c6 f4 ff ff       	call   80104840 <argstr>
8010537a:	83 c4 10             	add    $0x10,%esp
8010537d:	85 c0                	test   %eax,%eax
8010537f:	78 7f                	js     80105400 <sys_exec+0xa0>
80105381:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105387:	83 ec 08             	sub    $0x8,%esp
8010538a:	50                   	push   %eax
8010538b:	6a 01                	push   $0x1
8010538d:	e8 fe f3 ff ff       	call   80104790 <argint>
80105392:	83 c4 10             	add    $0x10,%esp
80105395:	85 c0                	test   %eax,%eax
80105397:	78 67                	js     80105400 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105399:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010539f:	83 ec 04             	sub    $0x4,%esp
801053a2:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801053a8:	68 80 00 00 00       	push   $0x80
801053ad:	6a 00                	push   $0x0
801053af:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801053b5:	50                   	push   %eax
801053b6:	31 db                	xor    %ebx,%ebx
801053b8:	e8 c3 f0 ff ff       	call   80104480 <memset>
801053bd:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801053c0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801053c6:	83 ec 08             	sub    $0x8,%esp
801053c9:	57                   	push   %edi
801053ca:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801053cd:	50                   	push   %eax
801053ce:	e8 1d f3 ff ff       	call   801046f0 <fetchint>
801053d3:	83 c4 10             	add    $0x10,%esp
801053d6:	85 c0                	test   %eax,%eax
801053d8:	78 26                	js     80105400 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
801053da:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801053e0:	85 c0                	test   %eax,%eax
801053e2:	74 2c                	je     80105410 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801053e4:	83 ec 08             	sub    $0x8,%esp
801053e7:	56                   	push   %esi
801053e8:	50                   	push   %eax
801053e9:	e8 42 f3 ff ff       	call   80104730 <fetchstr>
801053ee:	83 c4 10             	add    $0x10,%esp
801053f1:	85 c0                	test   %eax,%eax
801053f3:	78 0b                	js     80105400 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801053f5:	83 c3 01             	add    $0x1,%ebx
801053f8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801053fb:	83 fb 20             	cmp    $0x20,%ebx
801053fe:	75 c0                	jne    801053c0 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105400:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105403:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105408:	5b                   	pop    %ebx
80105409:	5e                   	pop    %esi
8010540a:	5f                   	pop    %edi
8010540b:	5d                   	pop    %ebp
8010540c:	c3                   	ret    
8010540d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105410:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105416:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105419:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105420:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105424:	50                   	push   %eax
80105425:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010542b:	e8 c0 b5 ff ff       	call   801009f0 <exec>
80105430:	83 c4 10             	add    $0x10,%esp
}
80105433:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105436:	5b                   	pop    %ebx
80105437:	5e                   	pop    %esi
80105438:	5f                   	pop    %edi
80105439:	5d                   	pop    %ebp
8010543a:	c3                   	ret    
8010543b:	90                   	nop
8010543c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105440 <sys_pipe>:

int
sys_pipe(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	57                   	push   %edi
80105444:	56                   	push   %esi
80105445:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105446:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105449:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010544c:	6a 08                	push   $0x8
8010544e:	50                   	push   %eax
8010544f:	6a 00                	push   $0x0
80105451:	e8 8a f3 ff ff       	call   801047e0 <argptr>
80105456:	83 c4 10             	add    $0x10,%esp
80105459:	85 c0                	test   %eax,%eax
8010545b:	78 4a                	js     801054a7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010545d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105460:	83 ec 08             	sub    $0x8,%esp
80105463:	50                   	push   %eax
80105464:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105467:	50                   	push   %eax
80105468:	e8 e3 dd ff ff       	call   80103250 <pipealloc>
8010546d:	83 c4 10             	add    $0x10,%esp
80105470:	85 c0                	test   %eax,%eax
80105472:	78 33                	js     801054a7 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105474:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105476:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105479:	e8 62 e3 ff ff       	call   801037e0 <myproc>
8010547e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105480:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105484:	85 f6                	test   %esi,%esi
80105486:	74 30                	je     801054b8 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105488:	83 c3 01             	add    $0x1,%ebx
8010548b:	83 fb 10             	cmp    $0x10,%ebx
8010548e:	75 f0                	jne    80105480 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	ff 75 e0             	pushl  -0x20(%ebp)
80105496:	e8 95 b9 ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
8010549b:	58                   	pop    %eax
8010549c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010549f:	e8 8c b9 ff ff       	call   80100e30 <fileclose>
    return -1;
801054a4:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801054a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
801054aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801054af:	5b                   	pop    %ebx
801054b0:	5e                   	pop    %esi
801054b1:	5f                   	pop    %edi
801054b2:	5d                   	pop    %ebp
801054b3:	c3                   	ret    
801054b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801054b8:	8d 73 08             	lea    0x8(%ebx),%esi
801054bb:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801054bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801054c2:	e8 19 e3 ff ff       	call   801037e0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801054c7:	31 d2                	xor    %edx,%edx
801054c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801054d0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801054d4:	85 c9                	test   %ecx,%ecx
801054d6:	74 18                	je     801054f0 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801054d8:	83 c2 01             	add    $0x1,%edx
801054db:	83 fa 10             	cmp    $0x10,%edx
801054de:	75 f0                	jne    801054d0 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801054e0:	e8 fb e2 ff ff       	call   801037e0 <myproc>
801054e5:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801054ec:	00 
801054ed:	eb a1                	jmp    80105490 <sys_pipe+0x50>
801054ef:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801054f0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801054f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801054f7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801054f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801054fc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
801054ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105502:	31 c0                	xor    %eax,%eax
}
80105504:	5b                   	pop    %ebx
80105505:	5e                   	pop    %esi
80105506:	5f                   	pop    %edi
80105507:	5d                   	pop    %ebp
80105508:	c3                   	ret    
80105509:	66 90                	xchg   %ax,%ax
8010550b:	66 90                	xchg   %ax,%ax
8010550d:	66 90                	xchg   %ax,%ax
8010550f:	90                   	nop

80105510 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105513:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105514:	e9 67 e4 ff ff       	jmp    80103980 <fork>
80105519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105520 <sys_exit>:
}

int
sys_exit(void)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	83 ec 08             	sub    $0x8,%esp
  exit();
80105526:	e8 e5 e6 ff ff       	call   80103c10 <exit>
  return 0;  // not reached
}
8010552b:	31 c0                	xor    %eax,%eax
8010552d:	c9                   	leave  
8010552e:	c3                   	ret    
8010552f:	90                   	nop

80105530 <sys_wait>:

int
sys_wait(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105533:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105534:	e9 17 e9 ff ff       	jmp    80103e50 <wait>
80105539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105540 <sys_kill>:
}

int
sys_kill(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105546:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105549:	50                   	push   %eax
8010554a:	6a 00                	push   $0x0
8010554c:	e8 3f f2 ff ff       	call   80104790 <argint>
80105551:	83 c4 10             	add    $0x10,%esp
80105554:	85 c0                	test   %eax,%eax
80105556:	78 18                	js     80105570 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105558:	83 ec 0c             	sub    $0xc,%esp
8010555b:	ff 75 f4             	pushl  -0xc(%ebp)
8010555e:	e8 3d ea ff ff       	call   80103fa0 <kill>
80105563:	83 c4 10             	add    $0x10,%esp
}
80105566:	c9                   	leave  
80105567:	c3                   	ret    
80105568:	90                   	nop
80105569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105570:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105575:	c9                   	leave  
80105576:	c3                   	ret    
80105577:	89 f6                	mov    %esi,%esi
80105579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105580 <sys_getpid>:

int
sys_getpid(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105586:	e8 55 e2 ff ff       	call   801037e0 <myproc>
8010558b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010558e:	c9                   	leave  
8010558f:	c3                   	ret    

80105590 <sys_sbrk>:

int
sys_sbrk(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105594:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105597:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010559a:	50                   	push   %eax
8010559b:	6a 00                	push   $0x0
8010559d:	e8 ee f1 ff ff       	call   80104790 <argint>
801055a2:	83 c4 10             	add    $0x10,%esp
801055a5:	85 c0                	test   %eax,%eax
801055a7:	78 27                	js     801055d0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801055a9:	e8 32 e2 ff ff       	call   801037e0 <myproc>
  if(growproc(n) < 0)
801055ae:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
801055b1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801055b3:	ff 75 f4             	pushl  -0xc(%ebp)
801055b6:	e8 45 e3 ff ff       	call   80103900 <growproc>
801055bb:	83 c4 10             	add    $0x10,%esp
801055be:	85 c0                	test   %eax,%eax
801055c0:	78 0e                	js     801055d0 <sys_sbrk+0x40>
    return -1;
  return addr;
801055c2:	89 d8                	mov    %ebx,%eax
}
801055c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055c7:	c9                   	leave  
801055c8:	c3                   	ret    
801055c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
801055d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055d5:	eb ed                	jmp    801055c4 <sys_sbrk+0x34>
801055d7:	89 f6                	mov    %esi,%esi
801055d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055e0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801055e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
801055e7:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801055ea:	50                   	push   %eax
801055eb:	6a 00                	push   $0x0
801055ed:	e8 9e f1 ff ff       	call   80104790 <argint>
801055f2:	83 c4 10             	add    $0x10,%esp
801055f5:	85 c0                	test   %eax,%eax
801055f7:	0f 88 8a 00 00 00    	js     80105687 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801055fd:	83 ec 0c             	sub    $0xc,%esp
80105600:	68 e0 58 11 80       	push   $0x801158e0
80105605:	e8 76 ed ff ff       	call   80104380 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010560a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010560d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105610:	8b 1d 20 61 11 80    	mov    0x80116120,%ebx
  while(ticks - ticks0 < n){
80105616:	85 d2                	test   %edx,%edx
80105618:	75 27                	jne    80105641 <sys_sleep+0x61>
8010561a:	eb 54                	jmp    80105670 <sys_sleep+0x90>
8010561c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105620:	83 ec 08             	sub    $0x8,%esp
80105623:	68 e0 58 11 80       	push   $0x801158e0
80105628:	68 20 61 11 80       	push   $0x80116120
8010562d:	e8 5e e7 ff ff       	call   80103d90 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105632:	a1 20 61 11 80       	mov    0x80116120,%eax
80105637:	83 c4 10             	add    $0x10,%esp
8010563a:	29 d8                	sub    %ebx,%eax
8010563c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010563f:	73 2f                	jae    80105670 <sys_sleep+0x90>
    if(myproc()->killed){
80105641:	e8 9a e1 ff ff       	call   801037e0 <myproc>
80105646:	8b 40 24             	mov    0x24(%eax),%eax
80105649:	85 c0                	test   %eax,%eax
8010564b:	74 d3                	je     80105620 <sys_sleep+0x40>
      release(&tickslock);
8010564d:	83 ec 0c             	sub    $0xc,%esp
80105650:	68 e0 58 11 80       	push   $0x801158e0
80105655:	e8 d6 ed ff ff       	call   80104430 <release>
      return -1;
8010565a:	83 c4 10             	add    $0x10,%esp
8010565d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105662:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105665:	c9                   	leave  
80105666:	c3                   	ret    
80105667:	89 f6                	mov    %esi,%esi
80105669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105670:	83 ec 0c             	sub    $0xc,%esp
80105673:	68 e0 58 11 80       	push   $0x801158e0
80105678:	e8 b3 ed ff ff       	call   80104430 <release>
  return 0;
8010567d:	83 c4 10             	add    $0x10,%esp
80105680:	31 c0                	xor    %eax,%eax
}
80105682:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105685:	c9                   	leave  
80105686:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105687:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568c:	eb d4                	jmp    80105662 <sys_sleep+0x82>
8010568e:	66 90                	xchg   %ax,%ax

80105690 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	53                   	push   %ebx
80105694:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105697:	68 e0 58 11 80       	push   $0x801158e0
8010569c:	e8 df ec ff ff       	call   80104380 <acquire>
  xticks = ticks;
801056a1:	8b 1d 20 61 11 80    	mov    0x80116120,%ebx
  release(&tickslock);
801056a7:	c7 04 24 e0 58 11 80 	movl   $0x801158e0,(%esp)
801056ae:	e8 7d ed ff ff       	call   80104430 <release>
  return xticks;
}
801056b3:	89 d8                	mov    %ebx,%eax
801056b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056b8:	c9                   	leave  
801056b9:	c3                   	ret    
801056ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801056c0 <sys_date>:

//Get time
int
sys_date(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *r;
  if(argptr(0, (void*)&r, sizeof(r))<0){
801056c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056c9:	6a 04                	push   $0x4
801056cb:	50                   	push   %eax
801056cc:	6a 00                	push   $0x0
801056ce:	e8 0d f1 ff ff       	call   801047e0 <argptr>
801056d3:	83 c4 10             	add    $0x10,%esp
801056d6:	85 c0                	test   %eax,%eax
801056d8:	78 16                	js     801056f0 <sys_date+0x30>
    return -1;
  }
  cmostime(r);
801056da:	83 ec 0c             	sub    $0xc,%esp
801056dd:	ff 75 f4             	pushl  -0xc(%ebp)
801056e0:	e8 4b d1 ff ff       	call   80102830 <cmostime>
  return 0;
801056e5:	83 c4 10             	add    $0x10,%esp
801056e8:	31 c0                	xor    %eax,%eax
}
801056ea:	c9                   	leave  
801056eb:	c3                   	ret    
801056ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
sys_date(void)
{
  struct rtcdate *r;
  if(argptr(0, (void*)&r, sizeof(r))<0){
    return -1;
801056f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  cmostime(r);
  return 0;
}
801056f5:	c9                   	leave  
801056f6:	c3                   	ret    

801056f7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801056f7:	1e                   	push   %ds
  pushl %es
801056f8:	06                   	push   %es
  pushl %fs
801056f9:	0f a0                	push   %fs
  pushl %gs
801056fb:	0f a8                	push   %gs
  pushal
801056fd:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801056fe:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105702:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105704:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105706:	54                   	push   %esp
  call trap
80105707:	e8 e4 00 00 00       	call   801057f0 <trap>
  addl $4, %esp
8010570c:	83 c4 04             	add    $0x4,%esp

8010570f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010570f:	61                   	popa   
  popl %gs
80105710:	0f a9                	pop    %gs
  popl %fs
80105712:	0f a1                	pop    %fs
  popl %es
80105714:	07                   	pop    %es
  popl %ds
80105715:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105716:	83 c4 08             	add    $0x8,%esp
  iret
80105719:	cf                   	iret   
8010571a:	66 90                	xchg   %ax,%ax
8010571c:	66 90                	xchg   %ax,%ax
8010571e:	66 90                	xchg   %ax,%ax

80105720 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105720:	31 c0                	xor    %eax,%eax
80105722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105728:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010572f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105734:	c6 04 c5 24 59 11 80 	movb   $0x0,-0x7feea6dc(,%eax,8)
8010573b:	00 
8010573c:	66 89 0c c5 22 59 11 	mov    %cx,-0x7feea6de(,%eax,8)
80105743:	80 
80105744:	c6 04 c5 25 59 11 80 	movb   $0x8e,-0x7feea6db(,%eax,8)
8010574b:	8e 
8010574c:	66 89 14 c5 20 59 11 	mov    %dx,-0x7feea6e0(,%eax,8)
80105753:	80 
80105754:	c1 ea 10             	shr    $0x10,%edx
80105757:	66 89 14 c5 26 59 11 	mov    %dx,-0x7feea6da(,%eax,8)
8010575e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010575f:	83 c0 01             	add    $0x1,%eax
80105762:	3d 00 01 00 00       	cmp    $0x100,%eax
80105767:	75 bf                	jne    80105728 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105769:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010576a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010576f:	89 e5                	mov    %esp,%ebp
80105771:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105774:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105779:	68 5d 77 10 80       	push   $0x8010775d
8010577e:	68 e0 58 11 80       	push   $0x801158e0
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105783:	66 89 15 22 5b 11 80 	mov    %dx,0x80115b22
8010578a:	c6 05 24 5b 11 80 00 	movb   $0x0,0x80115b24
80105791:	66 a3 20 5b 11 80    	mov    %ax,0x80115b20
80105797:	c1 e8 10             	shr    $0x10,%eax
8010579a:	c6 05 25 5b 11 80 ef 	movb   $0xef,0x80115b25
801057a1:	66 a3 26 5b 11 80    	mov    %ax,0x80115b26

  initlock(&tickslock, "time");
801057a7:	e8 74 ea ff ff       	call   80104220 <initlock>
}
801057ac:	83 c4 10             	add    $0x10,%esp
801057af:	c9                   	leave  
801057b0:	c3                   	ret    
801057b1:	eb 0d                	jmp    801057c0 <idtinit>
801057b3:	90                   	nop
801057b4:	90                   	nop
801057b5:	90                   	nop
801057b6:	90                   	nop
801057b7:	90                   	nop
801057b8:	90                   	nop
801057b9:	90                   	nop
801057ba:	90                   	nop
801057bb:	90                   	nop
801057bc:	90                   	nop
801057bd:	90                   	nop
801057be:	90                   	nop
801057bf:	90                   	nop

801057c0 <idtinit>:

void
idtinit(void)
{
801057c0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801057c1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801057c6:	89 e5                	mov    %esp,%ebp
801057c8:	83 ec 10             	sub    $0x10,%esp
801057cb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801057cf:	b8 20 59 11 80       	mov    $0x80115920,%eax
801057d4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801057d8:	c1 e8 10             	shr    $0x10,%eax
801057db:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801057df:	8d 45 fa             	lea    -0x6(%ebp),%eax
801057e2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801057e5:	c9                   	leave  
801057e6:	c3                   	ret    
801057e7:	89 f6                	mov    %esi,%esi
801057e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057f0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	57                   	push   %edi
801057f4:	56                   	push   %esi
801057f5:	53                   	push   %ebx
801057f6:	83 ec 1c             	sub    $0x1c,%esp
801057f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801057fc:	8b 47 30             	mov    0x30(%edi),%eax
801057ff:	83 f8 40             	cmp    $0x40,%eax
80105802:	0f 84 88 01 00 00    	je     80105990 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105808:	83 e8 20             	sub    $0x20,%eax
8010580b:	83 f8 1f             	cmp    $0x1f,%eax
8010580e:	77 10                	ja     80105820 <trap+0x30>
80105810:	ff 24 85 04 78 10 80 	jmp    *-0x7fef87fc(,%eax,4)
80105817:	89 f6                	mov    %esi,%esi
80105819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105820:	e8 bb df ff ff       	call   801037e0 <myproc>
80105825:	85 c0                	test   %eax,%eax
80105827:	0f 84 d7 01 00 00    	je     80105a04 <trap+0x214>
8010582d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105831:	0f 84 cd 01 00 00    	je     80105a04 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105837:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010583a:	8b 57 38             	mov    0x38(%edi),%edx
8010583d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105840:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105843:	e8 78 df ff ff       	call   801037c0 <cpuid>
80105848:	8b 77 34             	mov    0x34(%edi),%esi
8010584b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010584e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105851:	e8 8a df ff ff       	call   801037e0 <myproc>
80105856:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105859:	e8 82 df ff ff       	call   801037e0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010585e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105861:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105864:	51                   	push   %ecx
80105865:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105866:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105869:	ff 75 e4             	pushl  -0x1c(%ebp)
8010586c:	56                   	push   %esi
8010586d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010586e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105871:	52                   	push   %edx
80105872:	ff 70 10             	pushl  0x10(%eax)
80105875:	68 c0 77 10 80       	push   $0x801077c0
8010587a:	e8 e1 ad ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010587f:	83 c4 20             	add    $0x20,%esp
80105882:	e8 59 df ff ff       	call   801037e0 <myproc>
80105887:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010588e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105890:	e8 4b df ff ff       	call   801037e0 <myproc>
80105895:	85 c0                	test   %eax,%eax
80105897:	74 0c                	je     801058a5 <trap+0xb5>
80105899:	e8 42 df ff ff       	call   801037e0 <myproc>
8010589e:	8b 50 24             	mov    0x24(%eax),%edx
801058a1:	85 d2                	test   %edx,%edx
801058a3:	75 4b                	jne    801058f0 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801058a5:	e8 36 df ff ff       	call   801037e0 <myproc>
801058aa:	85 c0                	test   %eax,%eax
801058ac:	74 0b                	je     801058b9 <trap+0xc9>
801058ae:	e8 2d df ff ff       	call   801037e0 <myproc>
801058b3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801058b7:	74 4f                	je     80105908 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801058b9:	e8 22 df ff ff       	call   801037e0 <myproc>
801058be:	85 c0                	test   %eax,%eax
801058c0:	74 1d                	je     801058df <trap+0xef>
801058c2:	e8 19 df ff ff       	call   801037e0 <myproc>
801058c7:	8b 40 24             	mov    0x24(%eax),%eax
801058ca:	85 c0                	test   %eax,%eax
801058cc:	74 11                	je     801058df <trap+0xef>
801058ce:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801058d2:	83 e0 03             	and    $0x3,%eax
801058d5:	66 83 f8 03          	cmp    $0x3,%ax
801058d9:	0f 84 da 00 00 00    	je     801059b9 <trap+0x1c9>
    exit();
}
801058df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058e2:	5b                   	pop    %ebx
801058e3:	5e                   	pop    %esi
801058e4:	5f                   	pop    %edi
801058e5:	5d                   	pop    %ebp
801058e6:	c3                   	ret    
801058e7:	89 f6                	mov    %esi,%esi
801058e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801058f0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801058f4:	83 e0 03             	and    $0x3,%eax
801058f7:	66 83 f8 03          	cmp    $0x3,%ax
801058fb:	75 a8                	jne    801058a5 <trap+0xb5>
    exit();
801058fd:	e8 0e e3 ff ff       	call   80103c10 <exit>
80105902:	eb a1                	jmp    801058a5 <trap+0xb5>
80105904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105908:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
8010590c:	75 ab                	jne    801058b9 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
8010590e:	e8 2d e4 ff ff       	call   80103d40 <yield>
80105913:	eb a4                	jmp    801058b9 <trap+0xc9>
80105915:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105918:	e8 a3 de ff ff       	call   801037c0 <cpuid>
8010591d:	85 c0                	test   %eax,%eax
8010591f:	0f 84 ab 00 00 00    	je     801059d0 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105925:	e8 46 ce ff ff       	call   80102770 <lapiceoi>
    break;
8010592a:	e9 61 ff ff ff       	jmp    80105890 <trap+0xa0>
8010592f:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105930:	e8 fb cc ff ff       	call   80102630 <kbdintr>
    lapiceoi();
80105935:	e8 36 ce ff ff       	call   80102770 <lapiceoi>
    break;
8010593a:	e9 51 ff ff ff       	jmp    80105890 <trap+0xa0>
8010593f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105940:	e8 5b 02 00 00       	call   80105ba0 <uartintr>
    lapiceoi();
80105945:	e8 26 ce ff ff       	call   80102770 <lapiceoi>
    break;
8010594a:	e9 41 ff ff ff       	jmp    80105890 <trap+0xa0>
8010594f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105950:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105954:	8b 77 38             	mov    0x38(%edi),%esi
80105957:	e8 64 de ff ff       	call   801037c0 <cpuid>
8010595c:	56                   	push   %esi
8010595d:	53                   	push   %ebx
8010595e:	50                   	push   %eax
8010595f:	68 68 77 10 80       	push   $0x80107768
80105964:	e8 f7 ac ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105969:	e8 02 ce ff ff       	call   80102770 <lapiceoi>
    break;
8010596e:	83 c4 10             	add    $0x10,%esp
80105971:	e9 1a ff ff ff       	jmp    80105890 <trap+0xa0>
80105976:	8d 76 00             	lea    0x0(%esi),%esi
80105979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105980:	e8 2b c7 ff ff       	call   801020b0 <ideintr>
80105985:	eb 9e                	jmp    80105925 <trap+0x135>
80105987:	89 f6                	mov    %esi,%esi
80105989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105990:	e8 4b de ff ff       	call   801037e0 <myproc>
80105995:	8b 58 24             	mov    0x24(%eax),%ebx
80105998:	85 db                	test   %ebx,%ebx
8010599a:	75 2c                	jne    801059c8 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
8010599c:	e8 3f de ff ff       	call   801037e0 <myproc>
801059a1:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801059a4:	e8 d7 ee ff ff       	call   80104880 <syscall>
    if(myproc()->killed)
801059a9:	e8 32 de ff ff       	call   801037e0 <myproc>
801059ae:	8b 48 24             	mov    0x24(%eax),%ecx
801059b1:	85 c9                	test   %ecx,%ecx
801059b3:	0f 84 26 ff ff ff    	je     801058df <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801059b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059bc:	5b                   	pop    %ebx
801059bd:	5e                   	pop    %esi
801059be:	5f                   	pop    %edi
801059bf:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
801059c0:	e9 4b e2 ff ff       	jmp    80103c10 <exit>
801059c5:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
801059c8:	e8 43 e2 ff ff       	call   80103c10 <exit>
801059cd:	eb cd                	jmp    8010599c <trap+0x1ac>
801059cf:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
801059d0:	83 ec 0c             	sub    $0xc,%esp
801059d3:	68 e0 58 11 80       	push   $0x801158e0
801059d8:	e8 a3 e9 ff ff       	call   80104380 <acquire>
      ticks++;
      wakeup(&ticks);
801059dd:	c7 04 24 20 61 11 80 	movl   $0x80116120,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
801059e4:	83 05 20 61 11 80 01 	addl   $0x1,0x80116120
      wakeup(&ticks);
801059eb:	e8 50 e5 ff ff       	call   80103f40 <wakeup>
      release(&tickslock);
801059f0:	c7 04 24 e0 58 11 80 	movl   $0x801158e0,(%esp)
801059f7:	e8 34 ea ff ff       	call   80104430 <release>
801059fc:	83 c4 10             	add    $0x10,%esp
801059ff:	e9 21 ff ff ff       	jmp    80105925 <trap+0x135>
80105a04:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105a07:	8b 5f 38             	mov    0x38(%edi),%ebx
80105a0a:	e8 b1 dd ff ff       	call   801037c0 <cpuid>
80105a0f:	83 ec 0c             	sub    $0xc,%esp
80105a12:	56                   	push   %esi
80105a13:	53                   	push   %ebx
80105a14:	50                   	push   %eax
80105a15:	ff 77 30             	pushl  0x30(%edi)
80105a18:	68 8c 77 10 80       	push   $0x8010778c
80105a1d:	e8 3e ac ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80105a22:	83 c4 14             	add    $0x14,%esp
80105a25:	68 62 77 10 80       	push   $0x80107762
80105a2a:	e8 41 a9 ff ff       	call   80100370 <panic>
80105a2f:	90                   	nop

80105a30 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105a30:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105a35:	55                   	push   %ebp
80105a36:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105a38:	85 c0                	test   %eax,%eax
80105a3a:	74 1c                	je     80105a58 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105a3c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105a41:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105a42:	a8 01                	test   $0x1,%al
80105a44:	74 12                	je     80105a58 <uartgetc+0x28>
80105a46:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a4b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105a4c:	0f b6 c0             	movzbl %al,%eax
}
80105a4f:	5d                   	pop    %ebp
80105a50:	c3                   	ret    
80105a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105a58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105a5d:	5d                   	pop    %ebp
80105a5e:	c3                   	ret    
80105a5f:	90                   	nop

80105a60 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	57                   	push   %edi
80105a64:	56                   	push   %esi
80105a65:	53                   	push   %ebx
80105a66:	89 c7                	mov    %eax,%edi
80105a68:	bb 80 00 00 00       	mov    $0x80,%ebx
80105a6d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105a72:	83 ec 0c             	sub    $0xc,%esp
80105a75:	eb 1b                	jmp    80105a92 <uartputc.part.0+0x32>
80105a77:	89 f6                	mov    %esi,%esi
80105a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105a80:	83 ec 0c             	sub    $0xc,%esp
80105a83:	6a 0a                	push   $0xa
80105a85:	e8 06 cd ff ff       	call   80102790 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105a8a:	83 c4 10             	add    $0x10,%esp
80105a8d:	83 eb 01             	sub    $0x1,%ebx
80105a90:	74 07                	je     80105a99 <uartputc.part.0+0x39>
80105a92:	89 f2                	mov    %esi,%edx
80105a94:	ec                   	in     (%dx),%al
80105a95:	a8 20                	test   $0x20,%al
80105a97:	74 e7                	je     80105a80 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105a99:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a9e:	89 f8                	mov    %edi,%eax
80105aa0:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105aa1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aa4:	5b                   	pop    %ebx
80105aa5:	5e                   	pop    %esi
80105aa6:	5f                   	pop    %edi
80105aa7:	5d                   	pop    %ebp
80105aa8:	c3                   	ret    
80105aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ab0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	31 c9                	xor    %ecx,%ecx
80105ab3:	89 c8                	mov    %ecx,%eax
80105ab5:	89 e5                	mov    %esp,%ebp
80105ab7:	57                   	push   %edi
80105ab8:	56                   	push   %esi
80105ab9:	53                   	push   %ebx
80105aba:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105abf:	89 da                	mov    %ebx,%edx
80105ac1:	83 ec 0c             	sub    $0xc,%esp
80105ac4:	ee                   	out    %al,(%dx)
80105ac5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105aca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105acf:	89 fa                	mov    %edi,%edx
80105ad1:	ee                   	out    %al,(%dx)
80105ad2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105ad7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105adc:	ee                   	out    %al,(%dx)
80105add:	be f9 03 00 00       	mov    $0x3f9,%esi
80105ae2:	89 c8                	mov    %ecx,%eax
80105ae4:	89 f2                	mov    %esi,%edx
80105ae6:	ee                   	out    %al,(%dx)
80105ae7:	b8 03 00 00 00       	mov    $0x3,%eax
80105aec:	89 fa                	mov    %edi,%edx
80105aee:	ee                   	out    %al,(%dx)
80105aef:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105af4:	89 c8                	mov    %ecx,%eax
80105af6:	ee                   	out    %al,(%dx)
80105af7:	b8 01 00 00 00       	mov    $0x1,%eax
80105afc:	89 f2                	mov    %esi,%edx
80105afe:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105aff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b04:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105b05:	3c ff                	cmp    $0xff,%al
80105b07:	74 5a                	je     80105b63 <uartinit+0xb3>
    return;
  uart = 1;
80105b09:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105b10:	00 00 00 
80105b13:	89 da                	mov    %ebx,%edx
80105b15:	ec                   	in     (%dx),%al
80105b16:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b1b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105b1c:	83 ec 08             	sub    $0x8,%esp
80105b1f:	bb 84 78 10 80       	mov    $0x80107884,%ebx
80105b24:	6a 00                	push   $0x0
80105b26:	6a 04                	push   $0x4
80105b28:	e8 d3 c7 ff ff       	call   80102300 <ioapicenable>
80105b2d:	83 c4 10             	add    $0x10,%esp
80105b30:	b8 78 00 00 00       	mov    $0x78,%eax
80105b35:	eb 13                	jmp    80105b4a <uartinit+0x9a>
80105b37:	89 f6                	mov    %esi,%esi
80105b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b40:	83 c3 01             	add    $0x1,%ebx
80105b43:	0f be 03             	movsbl (%ebx),%eax
80105b46:	84 c0                	test   %al,%al
80105b48:	74 19                	je     80105b63 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80105b4a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105b50:	85 d2                	test   %edx,%edx
80105b52:	74 ec                	je     80105b40 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b54:	83 c3 01             	add    $0x1,%ebx
80105b57:	e8 04 ff ff ff       	call   80105a60 <uartputc.part.0>
80105b5c:	0f be 03             	movsbl (%ebx),%eax
80105b5f:	84 c0                	test   %al,%al
80105b61:	75 e7                	jne    80105b4a <uartinit+0x9a>
    uartputc(*p);
}
80105b63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b66:	5b                   	pop    %ebx
80105b67:	5e                   	pop    %esi
80105b68:	5f                   	pop    %edi
80105b69:	5d                   	pop    %ebp
80105b6a:	c3                   	ret    
80105b6b:	90                   	nop
80105b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b70 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105b70:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105b76:	55                   	push   %ebp
80105b77:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80105b79:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80105b7e:	74 10                	je     80105b90 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105b80:	5d                   	pop    %ebp
80105b81:	e9 da fe ff ff       	jmp    80105a60 <uartputc.part.0>
80105b86:	8d 76 00             	lea    0x0(%esi),%esi
80105b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105b90:	5d                   	pop    %ebp
80105b91:	c3                   	ret    
80105b92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ba0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105ba6:	68 30 5a 10 80       	push   $0x80105a30
80105bab:	e8 40 ac ff ff       	call   801007f0 <consoleintr>
}
80105bb0:	83 c4 10             	add    $0x10,%esp
80105bb3:	c9                   	leave  
80105bb4:	c3                   	ret    

80105bb5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105bb5:	6a 00                	push   $0x0
  pushl $0
80105bb7:	6a 00                	push   $0x0
  jmp alltraps
80105bb9:	e9 39 fb ff ff       	jmp    801056f7 <alltraps>

80105bbe <vector1>:
.globl vector1
vector1:
  pushl $0
80105bbe:	6a 00                	push   $0x0
  pushl $1
80105bc0:	6a 01                	push   $0x1
  jmp alltraps
80105bc2:	e9 30 fb ff ff       	jmp    801056f7 <alltraps>

80105bc7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105bc7:	6a 00                	push   $0x0
  pushl $2
80105bc9:	6a 02                	push   $0x2
  jmp alltraps
80105bcb:	e9 27 fb ff ff       	jmp    801056f7 <alltraps>

80105bd0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105bd0:	6a 00                	push   $0x0
  pushl $3
80105bd2:	6a 03                	push   $0x3
  jmp alltraps
80105bd4:	e9 1e fb ff ff       	jmp    801056f7 <alltraps>

80105bd9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105bd9:	6a 00                	push   $0x0
  pushl $4
80105bdb:	6a 04                	push   $0x4
  jmp alltraps
80105bdd:	e9 15 fb ff ff       	jmp    801056f7 <alltraps>

80105be2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105be2:	6a 00                	push   $0x0
  pushl $5
80105be4:	6a 05                	push   $0x5
  jmp alltraps
80105be6:	e9 0c fb ff ff       	jmp    801056f7 <alltraps>

80105beb <vector6>:
.globl vector6
vector6:
  pushl $0
80105beb:	6a 00                	push   $0x0
  pushl $6
80105bed:	6a 06                	push   $0x6
  jmp alltraps
80105bef:	e9 03 fb ff ff       	jmp    801056f7 <alltraps>

80105bf4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105bf4:	6a 00                	push   $0x0
  pushl $7
80105bf6:	6a 07                	push   $0x7
  jmp alltraps
80105bf8:	e9 fa fa ff ff       	jmp    801056f7 <alltraps>

80105bfd <vector8>:
.globl vector8
vector8:
  pushl $8
80105bfd:	6a 08                	push   $0x8
  jmp alltraps
80105bff:	e9 f3 fa ff ff       	jmp    801056f7 <alltraps>

80105c04 <vector9>:
.globl vector9
vector9:
  pushl $0
80105c04:	6a 00                	push   $0x0
  pushl $9
80105c06:	6a 09                	push   $0x9
  jmp alltraps
80105c08:	e9 ea fa ff ff       	jmp    801056f7 <alltraps>

80105c0d <vector10>:
.globl vector10
vector10:
  pushl $10
80105c0d:	6a 0a                	push   $0xa
  jmp alltraps
80105c0f:	e9 e3 fa ff ff       	jmp    801056f7 <alltraps>

80105c14 <vector11>:
.globl vector11
vector11:
  pushl $11
80105c14:	6a 0b                	push   $0xb
  jmp alltraps
80105c16:	e9 dc fa ff ff       	jmp    801056f7 <alltraps>

80105c1b <vector12>:
.globl vector12
vector12:
  pushl $12
80105c1b:	6a 0c                	push   $0xc
  jmp alltraps
80105c1d:	e9 d5 fa ff ff       	jmp    801056f7 <alltraps>

80105c22 <vector13>:
.globl vector13
vector13:
  pushl $13
80105c22:	6a 0d                	push   $0xd
  jmp alltraps
80105c24:	e9 ce fa ff ff       	jmp    801056f7 <alltraps>

80105c29 <vector14>:
.globl vector14
vector14:
  pushl $14
80105c29:	6a 0e                	push   $0xe
  jmp alltraps
80105c2b:	e9 c7 fa ff ff       	jmp    801056f7 <alltraps>

80105c30 <vector15>:
.globl vector15
vector15:
  pushl $0
80105c30:	6a 00                	push   $0x0
  pushl $15
80105c32:	6a 0f                	push   $0xf
  jmp alltraps
80105c34:	e9 be fa ff ff       	jmp    801056f7 <alltraps>

80105c39 <vector16>:
.globl vector16
vector16:
  pushl $0
80105c39:	6a 00                	push   $0x0
  pushl $16
80105c3b:	6a 10                	push   $0x10
  jmp alltraps
80105c3d:	e9 b5 fa ff ff       	jmp    801056f7 <alltraps>

80105c42 <vector17>:
.globl vector17
vector17:
  pushl $17
80105c42:	6a 11                	push   $0x11
  jmp alltraps
80105c44:	e9 ae fa ff ff       	jmp    801056f7 <alltraps>

80105c49 <vector18>:
.globl vector18
vector18:
  pushl $0
80105c49:	6a 00                	push   $0x0
  pushl $18
80105c4b:	6a 12                	push   $0x12
  jmp alltraps
80105c4d:	e9 a5 fa ff ff       	jmp    801056f7 <alltraps>

80105c52 <vector19>:
.globl vector19
vector19:
  pushl $0
80105c52:	6a 00                	push   $0x0
  pushl $19
80105c54:	6a 13                	push   $0x13
  jmp alltraps
80105c56:	e9 9c fa ff ff       	jmp    801056f7 <alltraps>

80105c5b <vector20>:
.globl vector20
vector20:
  pushl $0
80105c5b:	6a 00                	push   $0x0
  pushl $20
80105c5d:	6a 14                	push   $0x14
  jmp alltraps
80105c5f:	e9 93 fa ff ff       	jmp    801056f7 <alltraps>

80105c64 <vector21>:
.globl vector21
vector21:
  pushl $0
80105c64:	6a 00                	push   $0x0
  pushl $21
80105c66:	6a 15                	push   $0x15
  jmp alltraps
80105c68:	e9 8a fa ff ff       	jmp    801056f7 <alltraps>

80105c6d <vector22>:
.globl vector22
vector22:
  pushl $0
80105c6d:	6a 00                	push   $0x0
  pushl $22
80105c6f:	6a 16                	push   $0x16
  jmp alltraps
80105c71:	e9 81 fa ff ff       	jmp    801056f7 <alltraps>

80105c76 <vector23>:
.globl vector23
vector23:
  pushl $0
80105c76:	6a 00                	push   $0x0
  pushl $23
80105c78:	6a 17                	push   $0x17
  jmp alltraps
80105c7a:	e9 78 fa ff ff       	jmp    801056f7 <alltraps>

80105c7f <vector24>:
.globl vector24
vector24:
  pushl $0
80105c7f:	6a 00                	push   $0x0
  pushl $24
80105c81:	6a 18                	push   $0x18
  jmp alltraps
80105c83:	e9 6f fa ff ff       	jmp    801056f7 <alltraps>

80105c88 <vector25>:
.globl vector25
vector25:
  pushl $0
80105c88:	6a 00                	push   $0x0
  pushl $25
80105c8a:	6a 19                	push   $0x19
  jmp alltraps
80105c8c:	e9 66 fa ff ff       	jmp    801056f7 <alltraps>

80105c91 <vector26>:
.globl vector26
vector26:
  pushl $0
80105c91:	6a 00                	push   $0x0
  pushl $26
80105c93:	6a 1a                	push   $0x1a
  jmp alltraps
80105c95:	e9 5d fa ff ff       	jmp    801056f7 <alltraps>

80105c9a <vector27>:
.globl vector27
vector27:
  pushl $0
80105c9a:	6a 00                	push   $0x0
  pushl $27
80105c9c:	6a 1b                	push   $0x1b
  jmp alltraps
80105c9e:	e9 54 fa ff ff       	jmp    801056f7 <alltraps>

80105ca3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105ca3:	6a 00                	push   $0x0
  pushl $28
80105ca5:	6a 1c                	push   $0x1c
  jmp alltraps
80105ca7:	e9 4b fa ff ff       	jmp    801056f7 <alltraps>

80105cac <vector29>:
.globl vector29
vector29:
  pushl $0
80105cac:	6a 00                	push   $0x0
  pushl $29
80105cae:	6a 1d                	push   $0x1d
  jmp alltraps
80105cb0:	e9 42 fa ff ff       	jmp    801056f7 <alltraps>

80105cb5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105cb5:	6a 00                	push   $0x0
  pushl $30
80105cb7:	6a 1e                	push   $0x1e
  jmp alltraps
80105cb9:	e9 39 fa ff ff       	jmp    801056f7 <alltraps>

80105cbe <vector31>:
.globl vector31
vector31:
  pushl $0
80105cbe:	6a 00                	push   $0x0
  pushl $31
80105cc0:	6a 1f                	push   $0x1f
  jmp alltraps
80105cc2:	e9 30 fa ff ff       	jmp    801056f7 <alltraps>

80105cc7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105cc7:	6a 00                	push   $0x0
  pushl $32
80105cc9:	6a 20                	push   $0x20
  jmp alltraps
80105ccb:	e9 27 fa ff ff       	jmp    801056f7 <alltraps>

80105cd0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105cd0:	6a 00                	push   $0x0
  pushl $33
80105cd2:	6a 21                	push   $0x21
  jmp alltraps
80105cd4:	e9 1e fa ff ff       	jmp    801056f7 <alltraps>

80105cd9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105cd9:	6a 00                	push   $0x0
  pushl $34
80105cdb:	6a 22                	push   $0x22
  jmp alltraps
80105cdd:	e9 15 fa ff ff       	jmp    801056f7 <alltraps>

80105ce2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ce2:	6a 00                	push   $0x0
  pushl $35
80105ce4:	6a 23                	push   $0x23
  jmp alltraps
80105ce6:	e9 0c fa ff ff       	jmp    801056f7 <alltraps>

80105ceb <vector36>:
.globl vector36
vector36:
  pushl $0
80105ceb:	6a 00                	push   $0x0
  pushl $36
80105ced:	6a 24                	push   $0x24
  jmp alltraps
80105cef:	e9 03 fa ff ff       	jmp    801056f7 <alltraps>

80105cf4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105cf4:	6a 00                	push   $0x0
  pushl $37
80105cf6:	6a 25                	push   $0x25
  jmp alltraps
80105cf8:	e9 fa f9 ff ff       	jmp    801056f7 <alltraps>

80105cfd <vector38>:
.globl vector38
vector38:
  pushl $0
80105cfd:	6a 00                	push   $0x0
  pushl $38
80105cff:	6a 26                	push   $0x26
  jmp alltraps
80105d01:	e9 f1 f9 ff ff       	jmp    801056f7 <alltraps>

80105d06 <vector39>:
.globl vector39
vector39:
  pushl $0
80105d06:	6a 00                	push   $0x0
  pushl $39
80105d08:	6a 27                	push   $0x27
  jmp alltraps
80105d0a:	e9 e8 f9 ff ff       	jmp    801056f7 <alltraps>

80105d0f <vector40>:
.globl vector40
vector40:
  pushl $0
80105d0f:	6a 00                	push   $0x0
  pushl $40
80105d11:	6a 28                	push   $0x28
  jmp alltraps
80105d13:	e9 df f9 ff ff       	jmp    801056f7 <alltraps>

80105d18 <vector41>:
.globl vector41
vector41:
  pushl $0
80105d18:	6a 00                	push   $0x0
  pushl $41
80105d1a:	6a 29                	push   $0x29
  jmp alltraps
80105d1c:	e9 d6 f9 ff ff       	jmp    801056f7 <alltraps>

80105d21 <vector42>:
.globl vector42
vector42:
  pushl $0
80105d21:	6a 00                	push   $0x0
  pushl $42
80105d23:	6a 2a                	push   $0x2a
  jmp alltraps
80105d25:	e9 cd f9 ff ff       	jmp    801056f7 <alltraps>

80105d2a <vector43>:
.globl vector43
vector43:
  pushl $0
80105d2a:	6a 00                	push   $0x0
  pushl $43
80105d2c:	6a 2b                	push   $0x2b
  jmp alltraps
80105d2e:	e9 c4 f9 ff ff       	jmp    801056f7 <alltraps>

80105d33 <vector44>:
.globl vector44
vector44:
  pushl $0
80105d33:	6a 00                	push   $0x0
  pushl $44
80105d35:	6a 2c                	push   $0x2c
  jmp alltraps
80105d37:	e9 bb f9 ff ff       	jmp    801056f7 <alltraps>

80105d3c <vector45>:
.globl vector45
vector45:
  pushl $0
80105d3c:	6a 00                	push   $0x0
  pushl $45
80105d3e:	6a 2d                	push   $0x2d
  jmp alltraps
80105d40:	e9 b2 f9 ff ff       	jmp    801056f7 <alltraps>

80105d45 <vector46>:
.globl vector46
vector46:
  pushl $0
80105d45:	6a 00                	push   $0x0
  pushl $46
80105d47:	6a 2e                	push   $0x2e
  jmp alltraps
80105d49:	e9 a9 f9 ff ff       	jmp    801056f7 <alltraps>

80105d4e <vector47>:
.globl vector47
vector47:
  pushl $0
80105d4e:	6a 00                	push   $0x0
  pushl $47
80105d50:	6a 2f                	push   $0x2f
  jmp alltraps
80105d52:	e9 a0 f9 ff ff       	jmp    801056f7 <alltraps>

80105d57 <vector48>:
.globl vector48
vector48:
  pushl $0
80105d57:	6a 00                	push   $0x0
  pushl $48
80105d59:	6a 30                	push   $0x30
  jmp alltraps
80105d5b:	e9 97 f9 ff ff       	jmp    801056f7 <alltraps>

80105d60 <vector49>:
.globl vector49
vector49:
  pushl $0
80105d60:	6a 00                	push   $0x0
  pushl $49
80105d62:	6a 31                	push   $0x31
  jmp alltraps
80105d64:	e9 8e f9 ff ff       	jmp    801056f7 <alltraps>

80105d69 <vector50>:
.globl vector50
vector50:
  pushl $0
80105d69:	6a 00                	push   $0x0
  pushl $50
80105d6b:	6a 32                	push   $0x32
  jmp alltraps
80105d6d:	e9 85 f9 ff ff       	jmp    801056f7 <alltraps>

80105d72 <vector51>:
.globl vector51
vector51:
  pushl $0
80105d72:	6a 00                	push   $0x0
  pushl $51
80105d74:	6a 33                	push   $0x33
  jmp alltraps
80105d76:	e9 7c f9 ff ff       	jmp    801056f7 <alltraps>

80105d7b <vector52>:
.globl vector52
vector52:
  pushl $0
80105d7b:	6a 00                	push   $0x0
  pushl $52
80105d7d:	6a 34                	push   $0x34
  jmp alltraps
80105d7f:	e9 73 f9 ff ff       	jmp    801056f7 <alltraps>

80105d84 <vector53>:
.globl vector53
vector53:
  pushl $0
80105d84:	6a 00                	push   $0x0
  pushl $53
80105d86:	6a 35                	push   $0x35
  jmp alltraps
80105d88:	e9 6a f9 ff ff       	jmp    801056f7 <alltraps>

80105d8d <vector54>:
.globl vector54
vector54:
  pushl $0
80105d8d:	6a 00                	push   $0x0
  pushl $54
80105d8f:	6a 36                	push   $0x36
  jmp alltraps
80105d91:	e9 61 f9 ff ff       	jmp    801056f7 <alltraps>

80105d96 <vector55>:
.globl vector55
vector55:
  pushl $0
80105d96:	6a 00                	push   $0x0
  pushl $55
80105d98:	6a 37                	push   $0x37
  jmp alltraps
80105d9a:	e9 58 f9 ff ff       	jmp    801056f7 <alltraps>

80105d9f <vector56>:
.globl vector56
vector56:
  pushl $0
80105d9f:	6a 00                	push   $0x0
  pushl $56
80105da1:	6a 38                	push   $0x38
  jmp alltraps
80105da3:	e9 4f f9 ff ff       	jmp    801056f7 <alltraps>

80105da8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105da8:	6a 00                	push   $0x0
  pushl $57
80105daa:	6a 39                	push   $0x39
  jmp alltraps
80105dac:	e9 46 f9 ff ff       	jmp    801056f7 <alltraps>

80105db1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105db1:	6a 00                	push   $0x0
  pushl $58
80105db3:	6a 3a                	push   $0x3a
  jmp alltraps
80105db5:	e9 3d f9 ff ff       	jmp    801056f7 <alltraps>

80105dba <vector59>:
.globl vector59
vector59:
  pushl $0
80105dba:	6a 00                	push   $0x0
  pushl $59
80105dbc:	6a 3b                	push   $0x3b
  jmp alltraps
80105dbe:	e9 34 f9 ff ff       	jmp    801056f7 <alltraps>

80105dc3 <vector60>:
.globl vector60
vector60:
  pushl $0
80105dc3:	6a 00                	push   $0x0
  pushl $60
80105dc5:	6a 3c                	push   $0x3c
  jmp alltraps
80105dc7:	e9 2b f9 ff ff       	jmp    801056f7 <alltraps>

80105dcc <vector61>:
.globl vector61
vector61:
  pushl $0
80105dcc:	6a 00                	push   $0x0
  pushl $61
80105dce:	6a 3d                	push   $0x3d
  jmp alltraps
80105dd0:	e9 22 f9 ff ff       	jmp    801056f7 <alltraps>

80105dd5 <vector62>:
.globl vector62
vector62:
  pushl $0
80105dd5:	6a 00                	push   $0x0
  pushl $62
80105dd7:	6a 3e                	push   $0x3e
  jmp alltraps
80105dd9:	e9 19 f9 ff ff       	jmp    801056f7 <alltraps>

80105dde <vector63>:
.globl vector63
vector63:
  pushl $0
80105dde:	6a 00                	push   $0x0
  pushl $63
80105de0:	6a 3f                	push   $0x3f
  jmp alltraps
80105de2:	e9 10 f9 ff ff       	jmp    801056f7 <alltraps>

80105de7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105de7:	6a 00                	push   $0x0
  pushl $64
80105de9:	6a 40                	push   $0x40
  jmp alltraps
80105deb:	e9 07 f9 ff ff       	jmp    801056f7 <alltraps>

80105df0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105df0:	6a 00                	push   $0x0
  pushl $65
80105df2:	6a 41                	push   $0x41
  jmp alltraps
80105df4:	e9 fe f8 ff ff       	jmp    801056f7 <alltraps>

80105df9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105df9:	6a 00                	push   $0x0
  pushl $66
80105dfb:	6a 42                	push   $0x42
  jmp alltraps
80105dfd:	e9 f5 f8 ff ff       	jmp    801056f7 <alltraps>

80105e02 <vector67>:
.globl vector67
vector67:
  pushl $0
80105e02:	6a 00                	push   $0x0
  pushl $67
80105e04:	6a 43                	push   $0x43
  jmp alltraps
80105e06:	e9 ec f8 ff ff       	jmp    801056f7 <alltraps>

80105e0b <vector68>:
.globl vector68
vector68:
  pushl $0
80105e0b:	6a 00                	push   $0x0
  pushl $68
80105e0d:	6a 44                	push   $0x44
  jmp alltraps
80105e0f:	e9 e3 f8 ff ff       	jmp    801056f7 <alltraps>

80105e14 <vector69>:
.globl vector69
vector69:
  pushl $0
80105e14:	6a 00                	push   $0x0
  pushl $69
80105e16:	6a 45                	push   $0x45
  jmp alltraps
80105e18:	e9 da f8 ff ff       	jmp    801056f7 <alltraps>

80105e1d <vector70>:
.globl vector70
vector70:
  pushl $0
80105e1d:	6a 00                	push   $0x0
  pushl $70
80105e1f:	6a 46                	push   $0x46
  jmp alltraps
80105e21:	e9 d1 f8 ff ff       	jmp    801056f7 <alltraps>

80105e26 <vector71>:
.globl vector71
vector71:
  pushl $0
80105e26:	6a 00                	push   $0x0
  pushl $71
80105e28:	6a 47                	push   $0x47
  jmp alltraps
80105e2a:	e9 c8 f8 ff ff       	jmp    801056f7 <alltraps>

80105e2f <vector72>:
.globl vector72
vector72:
  pushl $0
80105e2f:	6a 00                	push   $0x0
  pushl $72
80105e31:	6a 48                	push   $0x48
  jmp alltraps
80105e33:	e9 bf f8 ff ff       	jmp    801056f7 <alltraps>

80105e38 <vector73>:
.globl vector73
vector73:
  pushl $0
80105e38:	6a 00                	push   $0x0
  pushl $73
80105e3a:	6a 49                	push   $0x49
  jmp alltraps
80105e3c:	e9 b6 f8 ff ff       	jmp    801056f7 <alltraps>

80105e41 <vector74>:
.globl vector74
vector74:
  pushl $0
80105e41:	6a 00                	push   $0x0
  pushl $74
80105e43:	6a 4a                	push   $0x4a
  jmp alltraps
80105e45:	e9 ad f8 ff ff       	jmp    801056f7 <alltraps>

80105e4a <vector75>:
.globl vector75
vector75:
  pushl $0
80105e4a:	6a 00                	push   $0x0
  pushl $75
80105e4c:	6a 4b                	push   $0x4b
  jmp alltraps
80105e4e:	e9 a4 f8 ff ff       	jmp    801056f7 <alltraps>

80105e53 <vector76>:
.globl vector76
vector76:
  pushl $0
80105e53:	6a 00                	push   $0x0
  pushl $76
80105e55:	6a 4c                	push   $0x4c
  jmp alltraps
80105e57:	e9 9b f8 ff ff       	jmp    801056f7 <alltraps>

80105e5c <vector77>:
.globl vector77
vector77:
  pushl $0
80105e5c:	6a 00                	push   $0x0
  pushl $77
80105e5e:	6a 4d                	push   $0x4d
  jmp alltraps
80105e60:	e9 92 f8 ff ff       	jmp    801056f7 <alltraps>

80105e65 <vector78>:
.globl vector78
vector78:
  pushl $0
80105e65:	6a 00                	push   $0x0
  pushl $78
80105e67:	6a 4e                	push   $0x4e
  jmp alltraps
80105e69:	e9 89 f8 ff ff       	jmp    801056f7 <alltraps>

80105e6e <vector79>:
.globl vector79
vector79:
  pushl $0
80105e6e:	6a 00                	push   $0x0
  pushl $79
80105e70:	6a 4f                	push   $0x4f
  jmp alltraps
80105e72:	e9 80 f8 ff ff       	jmp    801056f7 <alltraps>

80105e77 <vector80>:
.globl vector80
vector80:
  pushl $0
80105e77:	6a 00                	push   $0x0
  pushl $80
80105e79:	6a 50                	push   $0x50
  jmp alltraps
80105e7b:	e9 77 f8 ff ff       	jmp    801056f7 <alltraps>

80105e80 <vector81>:
.globl vector81
vector81:
  pushl $0
80105e80:	6a 00                	push   $0x0
  pushl $81
80105e82:	6a 51                	push   $0x51
  jmp alltraps
80105e84:	e9 6e f8 ff ff       	jmp    801056f7 <alltraps>

80105e89 <vector82>:
.globl vector82
vector82:
  pushl $0
80105e89:	6a 00                	push   $0x0
  pushl $82
80105e8b:	6a 52                	push   $0x52
  jmp alltraps
80105e8d:	e9 65 f8 ff ff       	jmp    801056f7 <alltraps>

80105e92 <vector83>:
.globl vector83
vector83:
  pushl $0
80105e92:	6a 00                	push   $0x0
  pushl $83
80105e94:	6a 53                	push   $0x53
  jmp alltraps
80105e96:	e9 5c f8 ff ff       	jmp    801056f7 <alltraps>

80105e9b <vector84>:
.globl vector84
vector84:
  pushl $0
80105e9b:	6a 00                	push   $0x0
  pushl $84
80105e9d:	6a 54                	push   $0x54
  jmp alltraps
80105e9f:	e9 53 f8 ff ff       	jmp    801056f7 <alltraps>

80105ea4 <vector85>:
.globl vector85
vector85:
  pushl $0
80105ea4:	6a 00                	push   $0x0
  pushl $85
80105ea6:	6a 55                	push   $0x55
  jmp alltraps
80105ea8:	e9 4a f8 ff ff       	jmp    801056f7 <alltraps>

80105ead <vector86>:
.globl vector86
vector86:
  pushl $0
80105ead:	6a 00                	push   $0x0
  pushl $86
80105eaf:	6a 56                	push   $0x56
  jmp alltraps
80105eb1:	e9 41 f8 ff ff       	jmp    801056f7 <alltraps>

80105eb6 <vector87>:
.globl vector87
vector87:
  pushl $0
80105eb6:	6a 00                	push   $0x0
  pushl $87
80105eb8:	6a 57                	push   $0x57
  jmp alltraps
80105eba:	e9 38 f8 ff ff       	jmp    801056f7 <alltraps>

80105ebf <vector88>:
.globl vector88
vector88:
  pushl $0
80105ebf:	6a 00                	push   $0x0
  pushl $88
80105ec1:	6a 58                	push   $0x58
  jmp alltraps
80105ec3:	e9 2f f8 ff ff       	jmp    801056f7 <alltraps>

80105ec8 <vector89>:
.globl vector89
vector89:
  pushl $0
80105ec8:	6a 00                	push   $0x0
  pushl $89
80105eca:	6a 59                	push   $0x59
  jmp alltraps
80105ecc:	e9 26 f8 ff ff       	jmp    801056f7 <alltraps>

80105ed1 <vector90>:
.globl vector90
vector90:
  pushl $0
80105ed1:	6a 00                	push   $0x0
  pushl $90
80105ed3:	6a 5a                	push   $0x5a
  jmp alltraps
80105ed5:	e9 1d f8 ff ff       	jmp    801056f7 <alltraps>

80105eda <vector91>:
.globl vector91
vector91:
  pushl $0
80105eda:	6a 00                	push   $0x0
  pushl $91
80105edc:	6a 5b                	push   $0x5b
  jmp alltraps
80105ede:	e9 14 f8 ff ff       	jmp    801056f7 <alltraps>

80105ee3 <vector92>:
.globl vector92
vector92:
  pushl $0
80105ee3:	6a 00                	push   $0x0
  pushl $92
80105ee5:	6a 5c                	push   $0x5c
  jmp alltraps
80105ee7:	e9 0b f8 ff ff       	jmp    801056f7 <alltraps>

80105eec <vector93>:
.globl vector93
vector93:
  pushl $0
80105eec:	6a 00                	push   $0x0
  pushl $93
80105eee:	6a 5d                	push   $0x5d
  jmp alltraps
80105ef0:	e9 02 f8 ff ff       	jmp    801056f7 <alltraps>

80105ef5 <vector94>:
.globl vector94
vector94:
  pushl $0
80105ef5:	6a 00                	push   $0x0
  pushl $94
80105ef7:	6a 5e                	push   $0x5e
  jmp alltraps
80105ef9:	e9 f9 f7 ff ff       	jmp    801056f7 <alltraps>

80105efe <vector95>:
.globl vector95
vector95:
  pushl $0
80105efe:	6a 00                	push   $0x0
  pushl $95
80105f00:	6a 5f                	push   $0x5f
  jmp alltraps
80105f02:	e9 f0 f7 ff ff       	jmp    801056f7 <alltraps>

80105f07 <vector96>:
.globl vector96
vector96:
  pushl $0
80105f07:	6a 00                	push   $0x0
  pushl $96
80105f09:	6a 60                	push   $0x60
  jmp alltraps
80105f0b:	e9 e7 f7 ff ff       	jmp    801056f7 <alltraps>

80105f10 <vector97>:
.globl vector97
vector97:
  pushl $0
80105f10:	6a 00                	push   $0x0
  pushl $97
80105f12:	6a 61                	push   $0x61
  jmp alltraps
80105f14:	e9 de f7 ff ff       	jmp    801056f7 <alltraps>

80105f19 <vector98>:
.globl vector98
vector98:
  pushl $0
80105f19:	6a 00                	push   $0x0
  pushl $98
80105f1b:	6a 62                	push   $0x62
  jmp alltraps
80105f1d:	e9 d5 f7 ff ff       	jmp    801056f7 <alltraps>

80105f22 <vector99>:
.globl vector99
vector99:
  pushl $0
80105f22:	6a 00                	push   $0x0
  pushl $99
80105f24:	6a 63                	push   $0x63
  jmp alltraps
80105f26:	e9 cc f7 ff ff       	jmp    801056f7 <alltraps>

80105f2b <vector100>:
.globl vector100
vector100:
  pushl $0
80105f2b:	6a 00                	push   $0x0
  pushl $100
80105f2d:	6a 64                	push   $0x64
  jmp alltraps
80105f2f:	e9 c3 f7 ff ff       	jmp    801056f7 <alltraps>

80105f34 <vector101>:
.globl vector101
vector101:
  pushl $0
80105f34:	6a 00                	push   $0x0
  pushl $101
80105f36:	6a 65                	push   $0x65
  jmp alltraps
80105f38:	e9 ba f7 ff ff       	jmp    801056f7 <alltraps>

80105f3d <vector102>:
.globl vector102
vector102:
  pushl $0
80105f3d:	6a 00                	push   $0x0
  pushl $102
80105f3f:	6a 66                	push   $0x66
  jmp alltraps
80105f41:	e9 b1 f7 ff ff       	jmp    801056f7 <alltraps>

80105f46 <vector103>:
.globl vector103
vector103:
  pushl $0
80105f46:	6a 00                	push   $0x0
  pushl $103
80105f48:	6a 67                	push   $0x67
  jmp alltraps
80105f4a:	e9 a8 f7 ff ff       	jmp    801056f7 <alltraps>

80105f4f <vector104>:
.globl vector104
vector104:
  pushl $0
80105f4f:	6a 00                	push   $0x0
  pushl $104
80105f51:	6a 68                	push   $0x68
  jmp alltraps
80105f53:	e9 9f f7 ff ff       	jmp    801056f7 <alltraps>

80105f58 <vector105>:
.globl vector105
vector105:
  pushl $0
80105f58:	6a 00                	push   $0x0
  pushl $105
80105f5a:	6a 69                	push   $0x69
  jmp alltraps
80105f5c:	e9 96 f7 ff ff       	jmp    801056f7 <alltraps>

80105f61 <vector106>:
.globl vector106
vector106:
  pushl $0
80105f61:	6a 00                	push   $0x0
  pushl $106
80105f63:	6a 6a                	push   $0x6a
  jmp alltraps
80105f65:	e9 8d f7 ff ff       	jmp    801056f7 <alltraps>

80105f6a <vector107>:
.globl vector107
vector107:
  pushl $0
80105f6a:	6a 00                	push   $0x0
  pushl $107
80105f6c:	6a 6b                	push   $0x6b
  jmp alltraps
80105f6e:	e9 84 f7 ff ff       	jmp    801056f7 <alltraps>

80105f73 <vector108>:
.globl vector108
vector108:
  pushl $0
80105f73:	6a 00                	push   $0x0
  pushl $108
80105f75:	6a 6c                	push   $0x6c
  jmp alltraps
80105f77:	e9 7b f7 ff ff       	jmp    801056f7 <alltraps>

80105f7c <vector109>:
.globl vector109
vector109:
  pushl $0
80105f7c:	6a 00                	push   $0x0
  pushl $109
80105f7e:	6a 6d                	push   $0x6d
  jmp alltraps
80105f80:	e9 72 f7 ff ff       	jmp    801056f7 <alltraps>

80105f85 <vector110>:
.globl vector110
vector110:
  pushl $0
80105f85:	6a 00                	push   $0x0
  pushl $110
80105f87:	6a 6e                	push   $0x6e
  jmp alltraps
80105f89:	e9 69 f7 ff ff       	jmp    801056f7 <alltraps>

80105f8e <vector111>:
.globl vector111
vector111:
  pushl $0
80105f8e:	6a 00                	push   $0x0
  pushl $111
80105f90:	6a 6f                	push   $0x6f
  jmp alltraps
80105f92:	e9 60 f7 ff ff       	jmp    801056f7 <alltraps>

80105f97 <vector112>:
.globl vector112
vector112:
  pushl $0
80105f97:	6a 00                	push   $0x0
  pushl $112
80105f99:	6a 70                	push   $0x70
  jmp alltraps
80105f9b:	e9 57 f7 ff ff       	jmp    801056f7 <alltraps>

80105fa0 <vector113>:
.globl vector113
vector113:
  pushl $0
80105fa0:	6a 00                	push   $0x0
  pushl $113
80105fa2:	6a 71                	push   $0x71
  jmp alltraps
80105fa4:	e9 4e f7 ff ff       	jmp    801056f7 <alltraps>

80105fa9 <vector114>:
.globl vector114
vector114:
  pushl $0
80105fa9:	6a 00                	push   $0x0
  pushl $114
80105fab:	6a 72                	push   $0x72
  jmp alltraps
80105fad:	e9 45 f7 ff ff       	jmp    801056f7 <alltraps>

80105fb2 <vector115>:
.globl vector115
vector115:
  pushl $0
80105fb2:	6a 00                	push   $0x0
  pushl $115
80105fb4:	6a 73                	push   $0x73
  jmp alltraps
80105fb6:	e9 3c f7 ff ff       	jmp    801056f7 <alltraps>

80105fbb <vector116>:
.globl vector116
vector116:
  pushl $0
80105fbb:	6a 00                	push   $0x0
  pushl $116
80105fbd:	6a 74                	push   $0x74
  jmp alltraps
80105fbf:	e9 33 f7 ff ff       	jmp    801056f7 <alltraps>

80105fc4 <vector117>:
.globl vector117
vector117:
  pushl $0
80105fc4:	6a 00                	push   $0x0
  pushl $117
80105fc6:	6a 75                	push   $0x75
  jmp alltraps
80105fc8:	e9 2a f7 ff ff       	jmp    801056f7 <alltraps>

80105fcd <vector118>:
.globl vector118
vector118:
  pushl $0
80105fcd:	6a 00                	push   $0x0
  pushl $118
80105fcf:	6a 76                	push   $0x76
  jmp alltraps
80105fd1:	e9 21 f7 ff ff       	jmp    801056f7 <alltraps>

80105fd6 <vector119>:
.globl vector119
vector119:
  pushl $0
80105fd6:	6a 00                	push   $0x0
  pushl $119
80105fd8:	6a 77                	push   $0x77
  jmp alltraps
80105fda:	e9 18 f7 ff ff       	jmp    801056f7 <alltraps>

80105fdf <vector120>:
.globl vector120
vector120:
  pushl $0
80105fdf:	6a 00                	push   $0x0
  pushl $120
80105fe1:	6a 78                	push   $0x78
  jmp alltraps
80105fe3:	e9 0f f7 ff ff       	jmp    801056f7 <alltraps>

80105fe8 <vector121>:
.globl vector121
vector121:
  pushl $0
80105fe8:	6a 00                	push   $0x0
  pushl $121
80105fea:	6a 79                	push   $0x79
  jmp alltraps
80105fec:	e9 06 f7 ff ff       	jmp    801056f7 <alltraps>

80105ff1 <vector122>:
.globl vector122
vector122:
  pushl $0
80105ff1:	6a 00                	push   $0x0
  pushl $122
80105ff3:	6a 7a                	push   $0x7a
  jmp alltraps
80105ff5:	e9 fd f6 ff ff       	jmp    801056f7 <alltraps>

80105ffa <vector123>:
.globl vector123
vector123:
  pushl $0
80105ffa:	6a 00                	push   $0x0
  pushl $123
80105ffc:	6a 7b                	push   $0x7b
  jmp alltraps
80105ffe:	e9 f4 f6 ff ff       	jmp    801056f7 <alltraps>

80106003 <vector124>:
.globl vector124
vector124:
  pushl $0
80106003:	6a 00                	push   $0x0
  pushl $124
80106005:	6a 7c                	push   $0x7c
  jmp alltraps
80106007:	e9 eb f6 ff ff       	jmp    801056f7 <alltraps>

8010600c <vector125>:
.globl vector125
vector125:
  pushl $0
8010600c:	6a 00                	push   $0x0
  pushl $125
8010600e:	6a 7d                	push   $0x7d
  jmp alltraps
80106010:	e9 e2 f6 ff ff       	jmp    801056f7 <alltraps>

80106015 <vector126>:
.globl vector126
vector126:
  pushl $0
80106015:	6a 00                	push   $0x0
  pushl $126
80106017:	6a 7e                	push   $0x7e
  jmp alltraps
80106019:	e9 d9 f6 ff ff       	jmp    801056f7 <alltraps>

8010601e <vector127>:
.globl vector127
vector127:
  pushl $0
8010601e:	6a 00                	push   $0x0
  pushl $127
80106020:	6a 7f                	push   $0x7f
  jmp alltraps
80106022:	e9 d0 f6 ff ff       	jmp    801056f7 <alltraps>

80106027 <vector128>:
.globl vector128
vector128:
  pushl $0
80106027:	6a 00                	push   $0x0
  pushl $128
80106029:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010602e:	e9 c4 f6 ff ff       	jmp    801056f7 <alltraps>

80106033 <vector129>:
.globl vector129
vector129:
  pushl $0
80106033:	6a 00                	push   $0x0
  pushl $129
80106035:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010603a:	e9 b8 f6 ff ff       	jmp    801056f7 <alltraps>

8010603f <vector130>:
.globl vector130
vector130:
  pushl $0
8010603f:	6a 00                	push   $0x0
  pushl $130
80106041:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106046:	e9 ac f6 ff ff       	jmp    801056f7 <alltraps>

8010604b <vector131>:
.globl vector131
vector131:
  pushl $0
8010604b:	6a 00                	push   $0x0
  pushl $131
8010604d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106052:	e9 a0 f6 ff ff       	jmp    801056f7 <alltraps>

80106057 <vector132>:
.globl vector132
vector132:
  pushl $0
80106057:	6a 00                	push   $0x0
  pushl $132
80106059:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010605e:	e9 94 f6 ff ff       	jmp    801056f7 <alltraps>

80106063 <vector133>:
.globl vector133
vector133:
  pushl $0
80106063:	6a 00                	push   $0x0
  pushl $133
80106065:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010606a:	e9 88 f6 ff ff       	jmp    801056f7 <alltraps>

8010606f <vector134>:
.globl vector134
vector134:
  pushl $0
8010606f:	6a 00                	push   $0x0
  pushl $134
80106071:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106076:	e9 7c f6 ff ff       	jmp    801056f7 <alltraps>

8010607b <vector135>:
.globl vector135
vector135:
  pushl $0
8010607b:	6a 00                	push   $0x0
  pushl $135
8010607d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106082:	e9 70 f6 ff ff       	jmp    801056f7 <alltraps>

80106087 <vector136>:
.globl vector136
vector136:
  pushl $0
80106087:	6a 00                	push   $0x0
  pushl $136
80106089:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010608e:	e9 64 f6 ff ff       	jmp    801056f7 <alltraps>

80106093 <vector137>:
.globl vector137
vector137:
  pushl $0
80106093:	6a 00                	push   $0x0
  pushl $137
80106095:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010609a:	e9 58 f6 ff ff       	jmp    801056f7 <alltraps>

8010609f <vector138>:
.globl vector138
vector138:
  pushl $0
8010609f:	6a 00                	push   $0x0
  pushl $138
801060a1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801060a6:	e9 4c f6 ff ff       	jmp    801056f7 <alltraps>

801060ab <vector139>:
.globl vector139
vector139:
  pushl $0
801060ab:	6a 00                	push   $0x0
  pushl $139
801060ad:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801060b2:	e9 40 f6 ff ff       	jmp    801056f7 <alltraps>

801060b7 <vector140>:
.globl vector140
vector140:
  pushl $0
801060b7:	6a 00                	push   $0x0
  pushl $140
801060b9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801060be:	e9 34 f6 ff ff       	jmp    801056f7 <alltraps>

801060c3 <vector141>:
.globl vector141
vector141:
  pushl $0
801060c3:	6a 00                	push   $0x0
  pushl $141
801060c5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801060ca:	e9 28 f6 ff ff       	jmp    801056f7 <alltraps>

801060cf <vector142>:
.globl vector142
vector142:
  pushl $0
801060cf:	6a 00                	push   $0x0
  pushl $142
801060d1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801060d6:	e9 1c f6 ff ff       	jmp    801056f7 <alltraps>

801060db <vector143>:
.globl vector143
vector143:
  pushl $0
801060db:	6a 00                	push   $0x0
  pushl $143
801060dd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801060e2:	e9 10 f6 ff ff       	jmp    801056f7 <alltraps>

801060e7 <vector144>:
.globl vector144
vector144:
  pushl $0
801060e7:	6a 00                	push   $0x0
  pushl $144
801060e9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801060ee:	e9 04 f6 ff ff       	jmp    801056f7 <alltraps>

801060f3 <vector145>:
.globl vector145
vector145:
  pushl $0
801060f3:	6a 00                	push   $0x0
  pushl $145
801060f5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801060fa:	e9 f8 f5 ff ff       	jmp    801056f7 <alltraps>

801060ff <vector146>:
.globl vector146
vector146:
  pushl $0
801060ff:	6a 00                	push   $0x0
  pushl $146
80106101:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106106:	e9 ec f5 ff ff       	jmp    801056f7 <alltraps>

8010610b <vector147>:
.globl vector147
vector147:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $147
8010610d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106112:	e9 e0 f5 ff ff       	jmp    801056f7 <alltraps>

80106117 <vector148>:
.globl vector148
vector148:
  pushl $0
80106117:	6a 00                	push   $0x0
  pushl $148
80106119:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010611e:	e9 d4 f5 ff ff       	jmp    801056f7 <alltraps>

80106123 <vector149>:
.globl vector149
vector149:
  pushl $0
80106123:	6a 00                	push   $0x0
  pushl $149
80106125:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010612a:	e9 c8 f5 ff ff       	jmp    801056f7 <alltraps>

8010612f <vector150>:
.globl vector150
vector150:
  pushl $0
8010612f:	6a 00                	push   $0x0
  pushl $150
80106131:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106136:	e9 bc f5 ff ff       	jmp    801056f7 <alltraps>

8010613b <vector151>:
.globl vector151
vector151:
  pushl $0
8010613b:	6a 00                	push   $0x0
  pushl $151
8010613d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106142:	e9 b0 f5 ff ff       	jmp    801056f7 <alltraps>

80106147 <vector152>:
.globl vector152
vector152:
  pushl $0
80106147:	6a 00                	push   $0x0
  pushl $152
80106149:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010614e:	e9 a4 f5 ff ff       	jmp    801056f7 <alltraps>

80106153 <vector153>:
.globl vector153
vector153:
  pushl $0
80106153:	6a 00                	push   $0x0
  pushl $153
80106155:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010615a:	e9 98 f5 ff ff       	jmp    801056f7 <alltraps>

8010615f <vector154>:
.globl vector154
vector154:
  pushl $0
8010615f:	6a 00                	push   $0x0
  pushl $154
80106161:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106166:	e9 8c f5 ff ff       	jmp    801056f7 <alltraps>

8010616b <vector155>:
.globl vector155
vector155:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $155
8010616d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106172:	e9 80 f5 ff ff       	jmp    801056f7 <alltraps>

80106177 <vector156>:
.globl vector156
vector156:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $156
80106179:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010617e:	e9 74 f5 ff ff       	jmp    801056f7 <alltraps>

80106183 <vector157>:
.globl vector157
vector157:
  pushl $0
80106183:	6a 00                	push   $0x0
  pushl $157
80106185:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010618a:	e9 68 f5 ff ff       	jmp    801056f7 <alltraps>

8010618f <vector158>:
.globl vector158
vector158:
  pushl $0
8010618f:	6a 00                	push   $0x0
  pushl $158
80106191:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106196:	e9 5c f5 ff ff       	jmp    801056f7 <alltraps>

8010619b <vector159>:
.globl vector159
vector159:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $159
8010619d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801061a2:	e9 50 f5 ff ff       	jmp    801056f7 <alltraps>

801061a7 <vector160>:
.globl vector160
vector160:
  pushl $0
801061a7:	6a 00                	push   $0x0
  pushl $160
801061a9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801061ae:	e9 44 f5 ff ff       	jmp    801056f7 <alltraps>

801061b3 <vector161>:
.globl vector161
vector161:
  pushl $0
801061b3:	6a 00                	push   $0x0
  pushl $161
801061b5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801061ba:	e9 38 f5 ff ff       	jmp    801056f7 <alltraps>

801061bf <vector162>:
.globl vector162
vector162:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $162
801061c1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801061c6:	e9 2c f5 ff ff       	jmp    801056f7 <alltraps>

801061cb <vector163>:
.globl vector163
vector163:
  pushl $0
801061cb:	6a 00                	push   $0x0
  pushl $163
801061cd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801061d2:	e9 20 f5 ff ff       	jmp    801056f7 <alltraps>

801061d7 <vector164>:
.globl vector164
vector164:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $164
801061d9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801061de:	e9 14 f5 ff ff       	jmp    801056f7 <alltraps>

801061e3 <vector165>:
.globl vector165
vector165:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $165
801061e5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801061ea:	e9 08 f5 ff ff       	jmp    801056f7 <alltraps>

801061ef <vector166>:
.globl vector166
vector166:
  pushl $0
801061ef:	6a 00                	push   $0x0
  pushl $166
801061f1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801061f6:	e9 fc f4 ff ff       	jmp    801056f7 <alltraps>

801061fb <vector167>:
.globl vector167
vector167:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $167
801061fd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106202:	e9 f0 f4 ff ff       	jmp    801056f7 <alltraps>

80106207 <vector168>:
.globl vector168
vector168:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $168
80106209:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010620e:	e9 e4 f4 ff ff       	jmp    801056f7 <alltraps>

80106213 <vector169>:
.globl vector169
vector169:
  pushl $0
80106213:	6a 00                	push   $0x0
  pushl $169
80106215:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010621a:	e9 d8 f4 ff ff       	jmp    801056f7 <alltraps>

8010621f <vector170>:
.globl vector170
vector170:
  pushl $0
8010621f:	6a 00                	push   $0x0
  pushl $170
80106221:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106226:	e9 cc f4 ff ff       	jmp    801056f7 <alltraps>

8010622b <vector171>:
.globl vector171
vector171:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $171
8010622d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106232:	e9 c0 f4 ff ff       	jmp    801056f7 <alltraps>

80106237 <vector172>:
.globl vector172
vector172:
  pushl $0
80106237:	6a 00                	push   $0x0
  pushl $172
80106239:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010623e:	e9 b4 f4 ff ff       	jmp    801056f7 <alltraps>

80106243 <vector173>:
.globl vector173
vector173:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $173
80106245:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010624a:	e9 a8 f4 ff ff       	jmp    801056f7 <alltraps>

8010624f <vector174>:
.globl vector174
vector174:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $174
80106251:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106256:	e9 9c f4 ff ff       	jmp    801056f7 <alltraps>

8010625b <vector175>:
.globl vector175
vector175:
  pushl $0
8010625b:	6a 00                	push   $0x0
  pushl $175
8010625d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106262:	e9 90 f4 ff ff       	jmp    801056f7 <alltraps>

80106267 <vector176>:
.globl vector176
vector176:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $176
80106269:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010626e:	e9 84 f4 ff ff       	jmp    801056f7 <alltraps>

80106273 <vector177>:
.globl vector177
vector177:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $177
80106275:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010627a:	e9 78 f4 ff ff       	jmp    801056f7 <alltraps>

8010627f <vector178>:
.globl vector178
vector178:
  pushl $0
8010627f:	6a 00                	push   $0x0
  pushl $178
80106281:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106286:	e9 6c f4 ff ff       	jmp    801056f7 <alltraps>

8010628b <vector179>:
.globl vector179
vector179:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $179
8010628d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106292:	e9 60 f4 ff ff       	jmp    801056f7 <alltraps>

80106297 <vector180>:
.globl vector180
vector180:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $180
80106299:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010629e:	e9 54 f4 ff ff       	jmp    801056f7 <alltraps>

801062a3 <vector181>:
.globl vector181
vector181:
  pushl $0
801062a3:	6a 00                	push   $0x0
  pushl $181
801062a5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801062aa:	e9 48 f4 ff ff       	jmp    801056f7 <alltraps>

801062af <vector182>:
.globl vector182
vector182:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $182
801062b1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801062b6:	e9 3c f4 ff ff       	jmp    801056f7 <alltraps>

801062bb <vector183>:
.globl vector183
vector183:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $183
801062bd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801062c2:	e9 30 f4 ff ff       	jmp    801056f7 <alltraps>

801062c7 <vector184>:
.globl vector184
vector184:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $184
801062c9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801062ce:	e9 24 f4 ff ff       	jmp    801056f7 <alltraps>

801062d3 <vector185>:
.globl vector185
vector185:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $185
801062d5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801062da:	e9 18 f4 ff ff       	jmp    801056f7 <alltraps>

801062df <vector186>:
.globl vector186
vector186:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $186
801062e1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801062e6:	e9 0c f4 ff ff       	jmp    801056f7 <alltraps>

801062eb <vector187>:
.globl vector187
vector187:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $187
801062ed:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801062f2:	e9 00 f4 ff ff       	jmp    801056f7 <alltraps>

801062f7 <vector188>:
.globl vector188
vector188:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $188
801062f9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801062fe:	e9 f4 f3 ff ff       	jmp    801056f7 <alltraps>

80106303 <vector189>:
.globl vector189
vector189:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $189
80106305:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010630a:	e9 e8 f3 ff ff       	jmp    801056f7 <alltraps>

8010630f <vector190>:
.globl vector190
vector190:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $190
80106311:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106316:	e9 dc f3 ff ff       	jmp    801056f7 <alltraps>

8010631b <vector191>:
.globl vector191
vector191:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $191
8010631d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106322:	e9 d0 f3 ff ff       	jmp    801056f7 <alltraps>

80106327 <vector192>:
.globl vector192
vector192:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $192
80106329:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010632e:	e9 c4 f3 ff ff       	jmp    801056f7 <alltraps>

80106333 <vector193>:
.globl vector193
vector193:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $193
80106335:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010633a:	e9 b8 f3 ff ff       	jmp    801056f7 <alltraps>

8010633f <vector194>:
.globl vector194
vector194:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $194
80106341:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106346:	e9 ac f3 ff ff       	jmp    801056f7 <alltraps>

8010634b <vector195>:
.globl vector195
vector195:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $195
8010634d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106352:	e9 a0 f3 ff ff       	jmp    801056f7 <alltraps>

80106357 <vector196>:
.globl vector196
vector196:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $196
80106359:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010635e:	e9 94 f3 ff ff       	jmp    801056f7 <alltraps>

80106363 <vector197>:
.globl vector197
vector197:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $197
80106365:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010636a:	e9 88 f3 ff ff       	jmp    801056f7 <alltraps>

8010636f <vector198>:
.globl vector198
vector198:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $198
80106371:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106376:	e9 7c f3 ff ff       	jmp    801056f7 <alltraps>

8010637b <vector199>:
.globl vector199
vector199:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $199
8010637d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106382:	e9 70 f3 ff ff       	jmp    801056f7 <alltraps>

80106387 <vector200>:
.globl vector200
vector200:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $200
80106389:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010638e:	e9 64 f3 ff ff       	jmp    801056f7 <alltraps>

80106393 <vector201>:
.globl vector201
vector201:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $201
80106395:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010639a:	e9 58 f3 ff ff       	jmp    801056f7 <alltraps>

8010639f <vector202>:
.globl vector202
vector202:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $202
801063a1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801063a6:	e9 4c f3 ff ff       	jmp    801056f7 <alltraps>

801063ab <vector203>:
.globl vector203
vector203:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $203
801063ad:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801063b2:	e9 40 f3 ff ff       	jmp    801056f7 <alltraps>

801063b7 <vector204>:
.globl vector204
vector204:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $204
801063b9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801063be:	e9 34 f3 ff ff       	jmp    801056f7 <alltraps>

801063c3 <vector205>:
.globl vector205
vector205:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $205
801063c5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801063ca:	e9 28 f3 ff ff       	jmp    801056f7 <alltraps>

801063cf <vector206>:
.globl vector206
vector206:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $206
801063d1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801063d6:	e9 1c f3 ff ff       	jmp    801056f7 <alltraps>

801063db <vector207>:
.globl vector207
vector207:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $207
801063dd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801063e2:	e9 10 f3 ff ff       	jmp    801056f7 <alltraps>

801063e7 <vector208>:
.globl vector208
vector208:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $208
801063e9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801063ee:	e9 04 f3 ff ff       	jmp    801056f7 <alltraps>

801063f3 <vector209>:
.globl vector209
vector209:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $209
801063f5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801063fa:	e9 f8 f2 ff ff       	jmp    801056f7 <alltraps>

801063ff <vector210>:
.globl vector210
vector210:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $210
80106401:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106406:	e9 ec f2 ff ff       	jmp    801056f7 <alltraps>

8010640b <vector211>:
.globl vector211
vector211:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $211
8010640d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106412:	e9 e0 f2 ff ff       	jmp    801056f7 <alltraps>

80106417 <vector212>:
.globl vector212
vector212:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $212
80106419:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010641e:	e9 d4 f2 ff ff       	jmp    801056f7 <alltraps>

80106423 <vector213>:
.globl vector213
vector213:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $213
80106425:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010642a:	e9 c8 f2 ff ff       	jmp    801056f7 <alltraps>

8010642f <vector214>:
.globl vector214
vector214:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $214
80106431:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106436:	e9 bc f2 ff ff       	jmp    801056f7 <alltraps>

8010643b <vector215>:
.globl vector215
vector215:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $215
8010643d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106442:	e9 b0 f2 ff ff       	jmp    801056f7 <alltraps>

80106447 <vector216>:
.globl vector216
vector216:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $216
80106449:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010644e:	e9 a4 f2 ff ff       	jmp    801056f7 <alltraps>

80106453 <vector217>:
.globl vector217
vector217:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $217
80106455:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010645a:	e9 98 f2 ff ff       	jmp    801056f7 <alltraps>

8010645f <vector218>:
.globl vector218
vector218:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $218
80106461:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106466:	e9 8c f2 ff ff       	jmp    801056f7 <alltraps>

8010646b <vector219>:
.globl vector219
vector219:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $219
8010646d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106472:	e9 80 f2 ff ff       	jmp    801056f7 <alltraps>

80106477 <vector220>:
.globl vector220
vector220:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $220
80106479:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010647e:	e9 74 f2 ff ff       	jmp    801056f7 <alltraps>

80106483 <vector221>:
.globl vector221
vector221:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $221
80106485:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010648a:	e9 68 f2 ff ff       	jmp    801056f7 <alltraps>

8010648f <vector222>:
.globl vector222
vector222:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $222
80106491:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106496:	e9 5c f2 ff ff       	jmp    801056f7 <alltraps>

8010649b <vector223>:
.globl vector223
vector223:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $223
8010649d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801064a2:	e9 50 f2 ff ff       	jmp    801056f7 <alltraps>

801064a7 <vector224>:
.globl vector224
vector224:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $224
801064a9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801064ae:	e9 44 f2 ff ff       	jmp    801056f7 <alltraps>

801064b3 <vector225>:
.globl vector225
vector225:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $225
801064b5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801064ba:	e9 38 f2 ff ff       	jmp    801056f7 <alltraps>

801064bf <vector226>:
.globl vector226
vector226:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $226
801064c1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801064c6:	e9 2c f2 ff ff       	jmp    801056f7 <alltraps>

801064cb <vector227>:
.globl vector227
vector227:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $227
801064cd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801064d2:	e9 20 f2 ff ff       	jmp    801056f7 <alltraps>

801064d7 <vector228>:
.globl vector228
vector228:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $228
801064d9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801064de:	e9 14 f2 ff ff       	jmp    801056f7 <alltraps>

801064e3 <vector229>:
.globl vector229
vector229:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $229
801064e5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801064ea:	e9 08 f2 ff ff       	jmp    801056f7 <alltraps>

801064ef <vector230>:
.globl vector230
vector230:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $230
801064f1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801064f6:	e9 fc f1 ff ff       	jmp    801056f7 <alltraps>

801064fb <vector231>:
.globl vector231
vector231:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $231
801064fd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106502:	e9 f0 f1 ff ff       	jmp    801056f7 <alltraps>

80106507 <vector232>:
.globl vector232
vector232:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $232
80106509:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010650e:	e9 e4 f1 ff ff       	jmp    801056f7 <alltraps>

80106513 <vector233>:
.globl vector233
vector233:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $233
80106515:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010651a:	e9 d8 f1 ff ff       	jmp    801056f7 <alltraps>

8010651f <vector234>:
.globl vector234
vector234:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $234
80106521:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106526:	e9 cc f1 ff ff       	jmp    801056f7 <alltraps>

8010652b <vector235>:
.globl vector235
vector235:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $235
8010652d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106532:	e9 c0 f1 ff ff       	jmp    801056f7 <alltraps>

80106537 <vector236>:
.globl vector236
vector236:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $236
80106539:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010653e:	e9 b4 f1 ff ff       	jmp    801056f7 <alltraps>

80106543 <vector237>:
.globl vector237
vector237:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $237
80106545:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010654a:	e9 a8 f1 ff ff       	jmp    801056f7 <alltraps>

8010654f <vector238>:
.globl vector238
vector238:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $238
80106551:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106556:	e9 9c f1 ff ff       	jmp    801056f7 <alltraps>

8010655b <vector239>:
.globl vector239
vector239:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $239
8010655d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106562:	e9 90 f1 ff ff       	jmp    801056f7 <alltraps>

80106567 <vector240>:
.globl vector240
vector240:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $240
80106569:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010656e:	e9 84 f1 ff ff       	jmp    801056f7 <alltraps>

80106573 <vector241>:
.globl vector241
vector241:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $241
80106575:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010657a:	e9 78 f1 ff ff       	jmp    801056f7 <alltraps>

8010657f <vector242>:
.globl vector242
vector242:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $242
80106581:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106586:	e9 6c f1 ff ff       	jmp    801056f7 <alltraps>

8010658b <vector243>:
.globl vector243
vector243:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $243
8010658d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106592:	e9 60 f1 ff ff       	jmp    801056f7 <alltraps>

80106597 <vector244>:
.globl vector244
vector244:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $244
80106599:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010659e:	e9 54 f1 ff ff       	jmp    801056f7 <alltraps>

801065a3 <vector245>:
.globl vector245
vector245:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $245
801065a5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801065aa:	e9 48 f1 ff ff       	jmp    801056f7 <alltraps>

801065af <vector246>:
.globl vector246
vector246:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $246
801065b1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801065b6:	e9 3c f1 ff ff       	jmp    801056f7 <alltraps>

801065bb <vector247>:
.globl vector247
vector247:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $247
801065bd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801065c2:	e9 30 f1 ff ff       	jmp    801056f7 <alltraps>

801065c7 <vector248>:
.globl vector248
vector248:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $248
801065c9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801065ce:	e9 24 f1 ff ff       	jmp    801056f7 <alltraps>

801065d3 <vector249>:
.globl vector249
vector249:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $249
801065d5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801065da:	e9 18 f1 ff ff       	jmp    801056f7 <alltraps>

801065df <vector250>:
.globl vector250
vector250:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $250
801065e1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801065e6:	e9 0c f1 ff ff       	jmp    801056f7 <alltraps>

801065eb <vector251>:
.globl vector251
vector251:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $251
801065ed:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801065f2:	e9 00 f1 ff ff       	jmp    801056f7 <alltraps>

801065f7 <vector252>:
.globl vector252
vector252:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $252
801065f9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801065fe:	e9 f4 f0 ff ff       	jmp    801056f7 <alltraps>

80106603 <vector253>:
.globl vector253
vector253:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $253
80106605:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010660a:	e9 e8 f0 ff ff       	jmp    801056f7 <alltraps>

8010660f <vector254>:
.globl vector254
vector254:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $254
80106611:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106616:	e9 dc f0 ff ff       	jmp    801056f7 <alltraps>

8010661b <vector255>:
.globl vector255
vector255:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $255
8010661d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106622:	e9 d0 f0 ff ff       	jmp    801056f7 <alltraps>
80106627:	66 90                	xchg   %ax,%ax
80106629:	66 90                	xchg   %ax,%ax
8010662b:	66 90                	xchg   %ax,%ax
8010662d:	66 90                	xchg   %ax,%ax
8010662f:	90                   	nop

80106630 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106630:	55                   	push   %ebp
80106631:	89 e5                	mov    %esp,%ebp
80106633:	57                   	push   %edi
80106634:	56                   	push   %esi
80106635:	53                   	push   %ebx
80106636:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106638:	c1 ea 16             	shr    $0x16,%edx
8010663b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010663e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106641:	8b 07                	mov    (%edi),%eax
80106643:	a8 01                	test   $0x1,%al
80106645:	74 29                	je     80106670 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106647:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010664c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106652:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106655:	c1 eb 0a             	shr    $0xa,%ebx
80106658:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010665e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106661:	5b                   	pop    %ebx
80106662:	5e                   	pop    %esi
80106663:	5f                   	pop    %edi
80106664:	5d                   	pop    %ebp
80106665:	c3                   	ret    
80106666:	8d 76 00             	lea    0x0(%esi),%esi
80106669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106670:	85 c9                	test   %ecx,%ecx
80106672:	74 2c                	je     801066a0 <walkpgdir+0x70>
80106674:	e8 77 be ff ff       	call   801024f0 <kalloc>
80106679:	85 c0                	test   %eax,%eax
8010667b:	89 c6                	mov    %eax,%esi
8010667d:	74 21                	je     801066a0 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010667f:	83 ec 04             	sub    $0x4,%esp
80106682:	68 00 10 00 00       	push   $0x1000
80106687:	6a 00                	push   $0x0
80106689:	50                   	push   %eax
8010668a:	e8 f1 dd ff ff       	call   80104480 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010668f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106695:	83 c4 10             	add    $0x10,%esp
80106698:	83 c8 07             	or     $0x7,%eax
8010669b:	89 07                	mov    %eax,(%edi)
8010669d:	eb b3                	jmp    80106652 <walkpgdir+0x22>
8010669f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
801066a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
801066a3:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801066a5:	5b                   	pop    %ebx
801066a6:	5e                   	pop    %esi
801066a7:	5f                   	pop    %edi
801066a8:	5d                   	pop    %ebp
801066a9:	c3                   	ret    
801066aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801066b0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801066b0:	55                   	push   %ebp
801066b1:	89 e5                	mov    %esp,%ebp
801066b3:	57                   	push   %edi
801066b4:	56                   	push   %esi
801066b5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801066b6:	89 d3                	mov    %edx,%ebx
801066b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801066be:	83 ec 1c             	sub    $0x1c,%esp
801066c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801066c4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801066c8:	8b 7d 08             	mov    0x8(%ebp),%edi
801066cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801066d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801066d6:	29 df                	sub    %ebx,%edi
801066d8:	83 c8 01             	or     $0x1,%eax
801066db:	89 45 dc             	mov    %eax,-0x24(%ebp)
801066de:	eb 15                	jmp    801066f5 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801066e0:	f6 00 01             	testb  $0x1,(%eax)
801066e3:	75 45                	jne    8010672a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801066e5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801066e8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801066eb:	89 30                	mov    %esi,(%eax)
    if(a == last)
801066ed:	74 31                	je     80106720 <mappages+0x70>
      break;
    a += PGSIZE;
801066ef:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801066f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066f8:	b9 01 00 00 00       	mov    $0x1,%ecx
801066fd:	89 da                	mov    %ebx,%edx
801066ff:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106702:	e8 29 ff ff ff       	call   80106630 <walkpgdir>
80106707:	85 c0                	test   %eax,%eax
80106709:	75 d5                	jne    801066e0 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010670b:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010670e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106713:	5b                   	pop    %ebx
80106714:	5e                   	pop    %esi
80106715:	5f                   	pop    %edi
80106716:	5d                   	pop    %ebp
80106717:	c3                   	ret    
80106718:	90                   	nop
80106719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106720:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106723:	31 c0                	xor    %eax,%eax
}
80106725:	5b                   	pop    %ebx
80106726:	5e                   	pop    %esi
80106727:	5f                   	pop    %edi
80106728:	5d                   	pop    %ebp
80106729:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
8010672a:	83 ec 0c             	sub    $0xc,%esp
8010672d:	68 8c 78 10 80       	push   $0x8010788c
80106732:	e8 39 9c ff ff       	call   80100370 <panic>
80106737:	89 f6                	mov    %esi,%esi
80106739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106740 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106740:	55                   	push   %ebp
80106741:	89 e5                	mov    %esp,%ebp
80106743:	57                   	push   %edi
80106744:	56                   	push   %esi
80106745:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106746:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010674c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010674e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106754:	83 ec 1c             	sub    $0x1c,%esp
80106757:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010675a:	39 d3                	cmp    %edx,%ebx
8010675c:	73 66                	jae    801067c4 <deallocuvm.part.0+0x84>
8010675e:	89 d6                	mov    %edx,%esi
80106760:	eb 3d                	jmp    8010679f <deallocuvm.part.0+0x5f>
80106762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106768:	8b 10                	mov    (%eax),%edx
8010676a:	f6 c2 01             	test   $0x1,%dl
8010676d:	74 26                	je     80106795 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010676f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106775:	74 58                	je     801067cf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106777:	83 ec 0c             	sub    $0xc,%esp
8010677a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106780:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106783:	52                   	push   %edx
80106784:	e8 b7 bb ff ff       	call   80102340 <kfree>
      *pte = 0;
80106789:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010678c:	83 c4 10             	add    $0x10,%esp
8010678f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106795:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010679b:	39 f3                	cmp    %esi,%ebx
8010679d:	73 25                	jae    801067c4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010679f:	31 c9                	xor    %ecx,%ecx
801067a1:	89 da                	mov    %ebx,%edx
801067a3:	89 f8                	mov    %edi,%eax
801067a5:	e8 86 fe ff ff       	call   80106630 <walkpgdir>
    if(!pte)
801067aa:	85 c0                	test   %eax,%eax
801067ac:	75 ba                	jne    80106768 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801067ae:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801067b4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801067ba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067c0:	39 f3                	cmp    %esi,%ebx
801067c2:	72 db                	jb     8010679f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801067c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801067c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067ca:	5b                   	pop    %ebx
801067cb:	5e                   	pop    %esi
801067cc:	5f                   	pop    %edi
801067cd:	5d                   	pop    %ebp
801067ce:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
801067cf:	83 ec 0c             	sub    $0xc,%esp
801067d2:	68 26 72 10 80       	push   $0x80107226
801067d7:	e8 94 9b ff ff       	call   80100370 <panic>
801067dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801067e0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801067e0:	55                   	push   %ebp
801067e1:	89 e5                	mov    %esp,%ebp
801067e3:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801067e6:	e8 d5 cf ff ff       	call   801037c0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801067eb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801067f1:	31 c9                	xor    %ecx,%ecx
801067f3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801067f8:	66 89 90 78 34 11 80 	mov    %dx,-0x7feecb88(%eax)
801067ff:	66 89 88 7a 34 11 80 	mov    %cx,-0x7feecb86(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106806:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010680b:	31 c9                	xor    %ecx,%ecx
8010680d:	66 89 90 80 34 11 80 	mov    %dx,-0x7feecb80(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106814:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106819:	66 89 88 82 34 11 80 	mov    %cx,-0x7feecb7e(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106820:	31 c9                	xor    %ecx,%ecx
80106822:	66 89 90 88 34 11 80 	mov    %dx,-0x7feecb78(%eax)
80106829:	66 89 88 8a 34 11 80 	mov    %cx,-0x7feecb76(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106830:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106835:	31 c9                	xor    %ecx,%ecx
80106837:	66 89 90 90 34 11 80 	mov    %dx,-0x7feecb70(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010683e:	c6 80 7c 34 11 80 00 	movb   $0x0,-0x7feecb84(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106845:	ba 2f 00 00 00       	mov    $0x2f,%edx
8010684a:	c6 80 7d 34 11 80 9a 	movb   $0x9a,-0x7feecb83(%eax)
80106851:	c6 80 7e 34 11 80 cf 	movb   $0xcf,-0x7feecb82(%eax)
80106858:	c6 80 7f 34 11 80 00 	movb   $0x0,-0x7feecb81(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010685f:	c6 80 84 34 11 80 00 	movb   $0x0,-0x7feecb7c(%eax)
80106866:	c6 80 85 34 11 80 92 	movb   $0x92,-0x7feecb7b(%eax)
8010686d:	c6 80 86 34 11 80 cf 	movb   $0xcf,-0x7feecb7a(%eax)
80106874:	c6 80 87 34 11 80 00 	movb   $0x0,-0x7feecb79(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010687b:	c6 80 8c 34 11 80 00 	movb   $0x0,-0x7feecb74(%eax)
80106882:	c6 80 8d 34 11 80 fa 	movb   $0xfa,-0x7feecb73(%eax)
80106889:	c6 80 8e 34 11 80 cf 	movb   $0xcf,-0x7feecb72(%eax)
80106890:	c6 80 8f 34 11 80 00 	movb   $0x0,-0x7feecb71(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106897:	66 89 88 92 34 11 80 	mov    %cx,-0x7feecb6e(%eax)
8010689e:	c6 80 94 34 11 80 00 	movb   $0x0,-0x7feecb6c(%eax)
801068a5:	c6 80 95 34 11 80 f2 	movb   $0xf2,-0x7feecb6b(%eax)
801068ac:	c6 80 96 34 11 80 cf 	movb   $0xcf,-0x7feecb6a(%eax)
801068b3:	c6 80 97 34 11 80 00 	movb   $0x0,-0x7feecb69(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801068ba:	05 70 34 11 80       	add    $0x80113470,%eax
801068bf:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
801068c3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801068c7:	c1 e8 10             	shr    $0x10,%eax
801068ca:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801068ce:	8d 45 f2             	lea    -0xe(%ebp),%eax
801068d1:	0f 01 10             	lgdtl  (%eax)
}
801068d4:	c9                   	leave  
801068d5:	c3                   	ret    
801068d6:	8d 76 00             	lea    0x0(%esi),%esi
801068d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068e0 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801068e0:	a1 24 61 11 80       	mov    0x80116124,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801068e5:	55                   	push   %ebp
801068e6:	89 e5                	mov    %esp,%ebp
801068e8:	05 00 00 00 80       	add    $0x80000000,%eax
801068ed:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
801068f0:	5d                   	pop    %ebp
801068f1:	c3                   	ret    
801068f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106900 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106900:	55                   	push   %ebp
80106901:	89 e5                	mov    %esp,%ebp
80106903:	57                   	push   %edi
80106904:	56                   	push   %esi
80106905:	53                   	push   %ebx
80106906:	83 ec 1c             	sub    $0x1c,%esp
80106909:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010690c:	85 f6                	test   %esi,%esi
8010690e:	0f 84 cd 00 00 00    	je     801069e1 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106914:	8b 46 08             	mov    0x8(%esi),%eax
80106917:	85 c0                	test   %eax,%eax
80106919:	0f 84 dc 00 00 00    	je     801069fb <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010691f:	8b 7e 04             	mov    0x4(%esi),%edi
80106922:	85 ff                	test   %edi,%edi
80106924:	0f 84 c4 00 00 00    	je     801069ee <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
8010692a:	e8 71 d9 ff ff       	call   801042a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010692f:	e8 0c ce ff ff       	call   80103740 <mycpu>
80106934:	89 c3                	mov    %eax,%ebx
80106936:	e8 05 ce ff ff       	call   80103740 <mycpu>
8010693b:	89 c7                	mov    %eax,%edi
8010693d:	e8 fe cd ff ff       	call   80103740 <mycpu>
80106942:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106945:	83 c7 08             	add    $0x8,%edi
80106948:	e8 f3 cd ff ff       	call   80103740 <mycpu>
8010694d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106950:	83 c0 08             	add    $0x8,%eax
80106953:	ba 67 00 00 00       	mov    $0x67,%edx
80106958:	c1 e8 18             	shr    $0x18,%eax
8010695b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106962:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106969:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106970:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106977:	83 c1 08             	add    $0x8,%ecx
8010697a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106980:	c1 e9 10             	shr    $0x10,%ecx
80106983:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106989:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010698e:	e8 ad cd ff ff       	call   80103740 <mycpu>
80106993:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010699a:	e8 a1 cd ff ff       	call   80103740 <mycpu>
8010699f:	b9 10 00 00 00       	mov    $0x10,%ecx
801069a4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801069a8:	e8 93 cd ff ff       	call   80103740 <mycpu>
801069ad:	8b 56 08             	mov    0x8(%esi),%edx
801069b0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
801069b6:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801069b9:	e8 82 cd ff ff       	call   80103740 <mycpu>
801069be:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
801069c2:	b8 28 00 00 00       	mov    $0x28,%eax
801069c7:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801069ca:	8b 46 04             	mov    0x4(%esi),%eax
801069cd:	05 00 00 00 80       	add    $0x80000000,%eax
801069d2:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
801069d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069d8:	5b                   	pop    %ebx
801069d9:	5e                   	pop    %esi
801069da:	5f                   	pop    %edi
801069db:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
801069dc:	e9 ff d8 ff ff       	jmp    801042e0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
801069e1:	83 ec 0c             	sub    $0xc,%esp
801069e4:	68 92 78 10 80       	push   $0x80107892
801069e9:	e8 82 99 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
801069ee:	83 ec 0c             	sub    $0xc,%esp
801069f1:	68 bd 78 10 80       	push   $0x801078bd
801069f6:	e8 75 99 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
801069fb:	83 ec 0c             	sub    $0xc,%esp
801069fe:	68 a8 78 10 80       	push   $0x801078a8
80106a03:	e8 68 99 ff ff       	call   80100370 <panic>
80106a08:	90                   	nop
80106a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a10 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106a10:	55                   	push   %ebp
80106a11:	89 e5                	mov    %esp,%ebp
80106a13:	57                   	push   %edi
80106a14:	56                   	push   %esi
80106a15:	53                   	push   %ebx
80106a16:	83 ec 1c             	sub    $0x1c,%esp
80106a19:	8b 75 10             	mov    0x10(%ebp),%esi
80106a1c:	8b 45 08             	mov    0x8(%ebp),%eax
80106a1f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106a22:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106a28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106a2b:	77 49                	ja     80106a76 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80106a2d:	e8 be ba ff ff       	call   801024f0 <kalloc>
  memset(mem, 0, PGSIZE);
80106a32:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106a35:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106a37:	68 00 10 00 00       	push   $0x1000
80106a3c:	6a 00                	push   $0x0
80106a3e:	50                   	push   %eax
80106a3f:	e8 3c da ff ff       	call   80104480 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106a44:	58                   	pop    %eax
80106a45:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a4b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a50:	5a                   	pop    %edx
80106a51:	6a 06                	push   $0x6
80106a53:	50                   	push   %eax
80106a54:	31 d2                	xor    %edx,%edx
80106a56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a59:	e8 52 fc ff ff       	call   801066b0 <mappages>
  memmove(mem, init, sz);
80106a5e:	89 75 10             	mov    %esi,0x10(%ebp)
80106a61:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106a64:	83 c4 10             	add    $0x10,%esp
80106a67:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106a6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a6d:	5b                   	pop    %ebx
80106a6e:	5e                   	pop    %esi
80106a6f:	5f                   	pop    %edi
80106a70:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106a71:	e9 ba da ff ff       	jmp    80104530 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106a76:	83 ec 0c             	sub    $0xc,%esp
80106a79:	68 d1 78 10 80       	push   $0x801078d1
80106a7e:	e8 ed 98 ff ff       	call   80100370 <panic>
80106a83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a90 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106a90:	55                   	push   %ebp
80106a91:	89 e5                	mov    %esp,%ebp
80106a93:	57                   	push   %edi
80106a94:	56                   	push   %esi
80106a95:	53                   	push   %ebx
80106a96:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106a99:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106aa0:	0f 85 91 00 00 00    	jne    80106b37 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106aa6:	8b 75 18             	mov    0x18(%ebp),%esi
80106aa9:	31 db                	xor    %ebx,%ebx
80106aab:	85 f6                	test   %esi,%esi
80106aad:	75 1a                	jne    80106ac9 <loaduvm+0x39>
80106aaf:	eb 6f                	jmp    80106b20 <loaduvm+0x90>
80106ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ab8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106abe:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106ac4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106ac7:	76 57                	jbe    80106b20 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ac9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106acc:	8b 45 08             	mov    0x8(%ebp),%eax
80106acf:	31 c9                	xor    %ecx,%ecx
80106ad1:	01 da                	add    %ebx,%edx
80106ad3:	e8 58 fb ff ff       	call   80106630 <walkpgdir>
80106ad8:	85 c0                	test   %eax,%eax
80106ada:	74 4e                	je     80106b2a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106adc:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ade:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106ae1:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106ae6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106aeb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106af1:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106af4:	01 d9                	add    %ebx,%ecx
80106af6:	05 00 00 00 80       	add    $0x80000000,%eax
80106afb:	57                   	push   %edi
80106afc:	51                   	push   %ecx
80106afd:	50                   	push   %eax
80106afe:	ff 75 10             	pushl  0x10(%ebp)
80106b01:	e8 aa ae ff ff       	call   801019b0 <readi>
80106b06:	83 c4 10             	add    $0x10,%esp
80106b09:	39 c7                	cmp    %eax,%edi
80106b0b:	74 ab                	je     80106ab8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106b0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106b15:	5b                   	pop    %ebx
80106b16:	5e                   	pop    %esi
80106b17:	5f                   	pop    %edi
80106b18:	5d                   	pop    %ebp
80106b19:	c3                   	ret    
80106b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b20:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106b23:	31 c0                	xor    %eax,%eax
}
80106b25:	5b                   	pop    %ebx
80106b26:	5e                   	pop    %esi
80106b27:	5f                   	pop    %edi
80106b28:	5d                   	pop    %ebp
80106b29:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106b2a:	83 ec 0c             	sub    $0xc,%esp
80106b2d:	68 eb 78 10 80       	push   $0x801078eb
80106b32:	e8 39 98 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106b37:	83 ec 0c             	sub    $0xc,%esp
80106b3a:	68 8c 79 10 80       	push   $0x8010798c
80106b3f:	e8 2c 98 ff ff       	call   80100370 <panic>
80106b44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106b50 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	57                   	push   %edi
80106b54:	56                   	push   %esi
80106b55:	53                   	push   %ebx
80106b56:	83 ec 0c             	sub    $0xc,%esp
80106b59:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106b5c:	85 ff                	test   %edi,%edi
80106b5e:	0f 88 ca 00 00 00    	js     80106c2e <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80106b64:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106b67:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106b6a:	0f 82 82 00 00 00    	jb     80106bf2 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106b70:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106b76:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106b7c:	39 df                	cmp    %ebx,%edi
80106b7e:	77 43                	ja     80106bc3 <allocuvm+0x73>
80106b80:	e9 bb 00 00 00       	jmp    80106c40 <allocuvm+0xf0>
80106b85:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106b88:	83 ec 04             	sub    $0x4,%esp
80106b8b:	68 00 10 00 00       	push   $0x1000
80106b90:	6a 00                	push   $0x0
80106b92:	50                   	push   %eax
80106b93:	e8 e8 d8 ff ff       	call   80104480 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106b98:	58                   	pop    %eax
80106b99:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106b9f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ba4:	5a                   	pop    %edx
80106ba5:	6a 06                	push   $0x6
80106ba7:	50                   	push   %eax
80106ba8:	89 da                	mov    %ebx,%edx
80106baa:	8b 45 08             	mov    0x8(%ebp),%eax
80106bad:	e8 fe fa ff ff       	call   801066b0 <mappages>
80106bb2:	83 c4 10             	add    $0x10,%esp
80106bb5:	85 c0                	test   %eax,%eax
80106bb7:	78 47                	js     80106c00 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106bb9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bbf:	39 df                	cmp    %ebx,%edi
80106bc1:	76 7d                	jbe    80106c40 <allocuvm+0xf0>
    mem = kalloc();
80106bc3:	e8 28 b9 ff ff       	call   801024f0 <kalloc>
    if(mem == 0){
80106bc8:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106bca:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106bcc:	75 ba                	jne    80106b88 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106bce:	83 ec 0c             	sub    $0xc,%esp
80106bd1:	68 09 79 10 80       	push   $0x80107909
80106bd6:	e8 85 9a ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106bdb:	83 c4 10             	add    $0x10,%esp
80106bde:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106be1:	76 4b                	jbe    80106c2e <allocuvm+0xde>
80106be3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106be6:	8b 45 08             	mov    0x8(%ebp),%eax
80106be9:	89 fa                	mov    %edi,%edx
80106beb:	e8 50 fb ff ff       	call   80106740 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106bf0:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106bf2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bf5:	5b                   	pop    %ebx
80106bf6:	5e                   	pop    %esi
80106bf7:	5f                   	pop    %edi
80106bf8:	5d                   	pop    %ebp
80106bf9:	c3                   	ret    
80106bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106c00:	83 ec 0c             	sub    $0xc,%esp
80106c03:	68 21 79 10 80       	push   $0x80107921
80106c08:	e8 53 9a ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106c0d:	83 c4 10             	add    $0x10,%esp
80106c10:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106c13:	76 0d                	jbe    80106c22 <allocuvm+0xd2>
80106c15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c18:	8b 45 08             	mov    0x8(%ebp),%eax
80106c1b:	89 fa                	mov    %edi,%edx
80106c1d:	e8 1e fb ff ff       	call   80106740 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106c22:	83 ec 0c             	sub    $0xc,%esp
80106c25:	56                   	push   %esi
80106c26:	e8 15 b7 ff ff       	call   80102340 <kfree>
      return 0;
80106c2b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106c2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106c31:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106c33:	5b                   	pop    %ebx
80106c34:	5e                   	pop    %esi
80106c35:	5f                   	pop    %edi
80106c36:	5d                   	pop    %ebp
80106c37:	c3                   	ret    
80106c38:	90                   	nop
80106c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c40:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106c43:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106c45:	5b                   	pop    %ebx
80106c46:	5e                   	pop    %esi
80106c47:	5f                   	pop    %edi
80106c48:	5d                   	pop    %ebp
80106c49:	c3                   	ret    
80106c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c50 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c56:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106c59:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106c5c:	39 d1                	cmp    %edx,%ecx
80106c5e:	73 10                	jae    80106c70 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106c60:	5d                   	pop    %ebp
80106c61:	e9 da fa ff ff       	jmp    80106740 <deallocuvm.part.0>
80106c66:	8d 76 00             	lea    0x0(%esi),%esi
80106c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106c70:	89 d0                	mov    %edx,%eax
80106c72:	5d                   	pop    %ebp
80106c73:	c3                   	ret    
80106c74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c80 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	57                   	push   %edi
80106c84:	56                   	push   %esi
80106c85:	53                   	push   %ebx
80106c86:	83 ec 0c             	sub    $0xc,%esp
80106c89:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106c8c:	85 f6                	test   %esi,%esi
80106c8e:	74 59                	je     80106ce9 <freevm+0x69>
80106c90:	31 c9                	xor    %ecx,%ecx
80106c92:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106c97:	89 f0                	mov    %esi,%eax
80106c99:	e8 a2 fa ff ff       	call   80106740 <deallocuvm.part.0>
80106c9e:	89 f3                	mov    %esi,%ebx
80106ca0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106ca6:	eb 0f                	jmp    80106cb7 <freevm+0x37>
80106ca8:	90                   	nop
80106ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cb0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106cb3:	39 fb                	cmp    %edi,%ebx
80106cb5:	74 23                	je     80106cda <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106cb7:	8b 03                	mov    (%ebx),%eax
80106cb9:	a8 01                	test   $0x1,%al
80106cbb:	74 f3                	je     80106cb0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106cbd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106cc2:	83 ec 0c             	sub    $0xc,%esp
80106cc5:	83 c3 04             	add    $0x4,%ebx
80106cc8:	05 00 00 00 80       	add    $0x80000000,%eax
80106ccd:	50                   	push   %eax
80106cce:	e8 6d b6 ff ff       	call   80102340 <kfree>
80106cd3:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106cd6:	39 fb                	cmp    %edi,%ebx
80106cd8:	75 dd                	jne    80106cb7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106cda:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106cdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ce0:	5b                   	pop    %ebx
80106ce1:	5e                   	pop    %esi
80106ce2:	5f                   	pop    %edi
80106ce3:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106ce4:	e9 57 b6 ff ff       	jmp    80102340 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106ce9:	83 ec 0c             	sub    $0xc,%esp
80106cec:	68 3d 79 10 80       	push   $0x8010793d
80106cf1:	e8 7a 96 ff ff       	call   80100370 <panic>
80106cf6:	8d 76 00             	lea    0x0(%esi),%esi
80106cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d00 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	56                   	push   %esi
80106d04:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106d05:	e8 e6 b7 ff ff       	call   801024f0 <kalloc>
80106d0a:	85 c0                	test   %eax,%eax
80106d0c:	74 6a                	je     80106d78 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106d0e:	83 ec 04             	sub    $0x4,%esp
80106d11:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d13:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106d18:	68 00 10 00 00       	push   $0x1000
80106d1d:	6a 00                	push   $0x0
80106d1f:	50                   	push   %eax
80106d20:	e8 5b d7 ff ff       	call   80104480 <memset>
80106d25:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106d28:	8b 43 04             	mov    0x4(%ebx),%eax
80106d2b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106d2e:	83 ec 08             	sub    $0x8,%esp
80106d31:	8b 13                	mov    (%ebx),%edx
80106d33:	ff 73 0c             	pushl  0xc(%ebx)
80106d36:	50                   	push   %eax
80106d37:	29 c1                	sub    %eax,%ecx
80106d39:	89 f0                	mov    %esi,%eax
80106d3b:	e8 70 f9 ff ff       	call   801066b0 <mappages>
80106d40:	83 c4 10             	add    $0x10,%esp
80106d43:	85 c0                	test   %eax,%eax
80106d45:	78 19                	js     80106d60 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d47:	83 c3 10             	add    $0x10,%ebx
80106d4a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106d50:	75 d6                	jne    80106d28 <setupkvm+0x28>
80106d52:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106d54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106d57:	5b                   	pop    %ebx
80106d58:	5e                   	pop    %esi
80106d59:	5d                   	pop    %ebp
80106d5a:	c3                   	ret    
80106d5b:	90                   	nop
80106d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106d60:	83 ec 0c             	sub    $0xc,%esp
80106d63:	56                   	push   %esi
80106d64:	e8 17 ff ff ff       	call   80106c80 <freevm>
      return 0;
80106d69:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
80106d6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106d6f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106d71:	5b                   	pop    %ebx
80106d72:	5e                   	pop    %esi
80106d73:	5d                   	pop    %ebp
80106d74:	c3                   	ret    
80106d75:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106d78:	31 c0                	xor    %eax,%eax
80106d7a:	eb d8                	jmp    80106d54 <setupkvm+0x54>
80106d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d80 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106d80:	55                   	push   %ebp
80106d81:	89 e5                	mov    %esp,%ebp
80106d83:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106d86:	e8 75 ff ff ff       	call   80106d00 <setupkvm>
80106d8b:	a3 24 61 11 80       	mov    %eax,0x80116124
80106d90:	05 00 00 00 80       	add    $0x80000000,%eax
80106d95:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80106d98:	c9                   	leave  
80106d99:	c3                   	ret    
80106d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106da0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106da0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106da1:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106da3:	89 e5                	mov    %esp,%ebp
80106da5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106da8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106dab:	8b 45 08             	mov    0x8(%ebp),%eax
80106dae:	e8 7d f8 ff ff       	call   80106630 <walkpgdir>
  if(pte == 0)
80106db3:	85 c0                	test   %eax,%eax
80106db5:	74 05                	je     80106dbc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106db7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106dba:	c9                   	leave  
80106dbb:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106dbc:	83 ec 0c             	sub    $0xc,%esp
80106dbf:	68 4e 79 10 80       	push   $0x8010794e
80106dc4:	e8 a7 95 ff ff       	call   80100370 <panic>
80106dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106dd0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	57                   	push   %edi
80106dd4:	56                   	push   %esi
80106dd5:	53                   	push   %ebx
80106dd6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106dd9:	e8 22 ff ff ff       	call   80106d00 <setupkvm>
80106dde:	85 c0                	test   %eax,%eax
80106de0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106de3:	0f 84 c5 00 00 00    	je     80106eae <copyuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106de9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106dec:	85 c9                	test   %ecx,%ecx
80106dee:	0f 84 9c 00 00 00    	je     80106e90 <copyuvm+0xc0>
80106df4:	31 ff                	xor    %edi,%edi
80106df6:	eb 4a                	jmp    80106e42 <copyuvm+0x72>
80106df8:	90                   	nop
80106df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106e00:	83 ec 04             	sub    $0x4,%esp
80106e03:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106e09:	68 00 10 00 00       	push   $0x1000
80106e0e:	53                   	push   %ebx
80106e0f:	50                   	push   %eax
80106e10:	e8 1b d7 ff ff       	call   80104530 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106e15:	58                   	pop    %eax
80106e16:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106e1c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e21:	5a                   	pop    %edx
80106e22:	ff 75 e4             	pushl  -0x1c(%ebp)
80106e25:	50                   	push   %eax
80106e26:	89 fa                	mov    %edi,%edx
80106e28:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e2b:	e8 80 f8 ff ff       	call   801066b0 <mappages>
80106e30:	83 c4 10             	add    $0x10,%esp
80106e33:	85 c0                	test   %eax,%eax
80106e35:	78 69                	js     80106ea0 <copyuvm+0xd0>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e37:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106e3d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106e40:	76 4e                	jbe    80106e90 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106e42:	8b 45 08             	mov    0x8(%ebp),%eax
80106e45:	31 c9                	xor    %ecx,%ecx
80106e47:	89 fa                	mov    %edi,%edx
80106e49:	e8 e2 f7 ff ff       	call   80106630 <walkpgdir>
80106e4e:	85 c0                	test   %eax,%eax
80106e50:	74 6d                	je     80106ebf <copyuvm+0xef>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106e52:	8b 00                	mov    (%eax),%eax
80106e54:	a8 01                	test   $0x1,%al
80106e56:	74 5a                	je     80106eb2 <copyuvm+0xe2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106e58:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80106e5a:	25 ff 0f 00 00       	and    $0xfff,%eax
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106e5f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80106e65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80106e68:	e8 83 b6 ff ff       	call   801024f0 <kalloc>
80106e6d:	85 c0                	test   %eax,%eax
80106e6f:	89 c6                	mov    %eax,%esi
80106e71:	75 8d                	jne    80106e00 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80106e73:	83 ec 0c             	sub    $0xc,%esp
80106e76:	ff 75 e0             	pushl  -0x20(%ebp)
80106e79:	e8 02 fe ff ff       	call   80106c80 <freevm>
  return 0;
80106e7e:	83 c4 10             	add    $0x10,%esp
80106e81:	31 c0                	xor    %eax,%eax
}
80106e83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e86:	5b                   	pop    %ebx
80106e87:	5e                   	pop    %esi
80106e88:	5f                   	pop    %edi
80106e89:	5d                   	pop    %ebp
80106e8a:	c3                   	ret    
80106e8b:	90                   	nop
80106e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80106e93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e96:	5b                   	pop    %ebx
80106e97:	5e                   	pop    %esi
80106e98:	5f                   	pop    %edi
80106e99:	5d                   	pop    %ebp
80106e9a:	c3                   	ret    
80106e9b:	90                   	nop
80106e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
80106ea0:	83 ec 0c             	sub    $0xc,%esp
80106ea3:	56                   	push   %esi
80106ea4:	e8 97 b4 ff ff       	call   80102340 <kfree>
      goto bad;
80106ea9:	83 c4 10             	add    $0x10,%esp
80106eac:	eb c5                	jmp    80106e73 <copyuvm+0xa3>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106eae:	31 c0                	xor    %eax,%eax
80106eb0:	eb d1                	jmp    80106e83 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106eb2:	83 ec 0c             	sub    $0xc,%esp
80106eb5:	68 72 79 10 80       	push   $0x80107972
80106eba:	e8 b1 94 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106ebf:	83 ec 0c             	sub    $0xc,%esp
80106ec2:	68 58 79 10 80       	push   $0x80107958
80106ec7:	e8 a4 94 ff ff       	call   80100370 <panic>
80106ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ed0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106ed0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ed1:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106ed3:	89 e5                	mov    %esp,%ebp
80106ed5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ed8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106edb:	8b 45 08             	mov    0x8(%ebp),%eax
80106ede:	e8 4d f7 ff ff       	call   80106630 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106ee3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106ee5:	89 c2                	mov    %eax,%edx
80106ee7:	83 e2 05             	and    $0x5,%edx
80106eea:	83 fa 05             	cmp    $0x5,%edx
80106eed:	75 11                	jne    80106f00 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106eef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80106ef4:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106ef5:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106efa:	c3                   	ret    
80106efb:	90                   	nop
80106efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106f00:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106f02:	c9                   	leave  
80106f03:	c3                   	ret    
80106f04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f10 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106f10:	55                   	push   %ebp
80106f11:	89 e5                	mov    %esp,%ebp
80106f13:	57                   	push   %edi
80106f14:	56                   	push   %esi
80106f15:	53                   	push   %ebx
80106f16:	83 ec 1c             	sub    $0x1c,%esp
80106f19:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106f1c:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f1f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f22:	85 db                	test   %ebx,%ebx
80106f24:	75 40                	jne    80106f66 <copyout+0x56>
80106f26:	eb 70                	jmp    80106f98 <copyout+0x88>
80106f28:	90                   	nop
80106f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106f30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106f33:	89 f1                	mov    %esi,%ecx
80106f35:	29 d1                	sub    %edx,%ecx
80106f37:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80106f3d:	39 d9                	cmp    %ebx,%ecx
80106f3f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106f42:	29 f2                	sub    %esi,%edx
80106f44:	83 ec 04             	sub    $0x4,%esp
80106f47:	01 d0                	add    %edx,%eax
80106f49:	51                   	push   %ecx
80106f4a:	57                   	push   %edi
80106f4b:	50                   	push   %eax
80106f4c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106f4f:	e8 dc d5 ff ff       	call   80104530 <memmove>
    len -= n;
    buf += n;
80106f54:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f57:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80106f5a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106f60:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f62:	29 cb                	sub    %ecx,%ebx
80106f64:	74 32                	je     80106f98 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80106f66:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f68:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106f6b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106f6e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f74:	56                   	push   %esi
80106f75:	ff 75 08             	pushl  0x8(%ebp)
80106f78:	e8 53 ff ff ff       	call   80106ed0 <uva2ka>
    if(pa0 == 0)
80106f7d:	83 c4 10             	add    $0x10,%esp
80106f80:	85 c0                	test   %eax,%eax
80106f82:	75 ac                	jne    80106f30 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106f84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106f87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106f8c:	5b                   	pop    %ebx
80106f8d:	5e                   	pop    %esi
80106f8e:	5f                   	pop    %edi
80106f8f:	5d                   	pop    %ebp
80106f90:	c3                   	ret    
80106f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f98:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106f9b:	31 c0                	xor    %eax,%eax
}
80106f9d:	5b                   	pop    %ebx
80106f9e:	5e                   	pop    %esi
80106f9f:	5f                   	pop    %edi
80106fa0:	5d                   	pop    %ebp
80106fa1:	c3                   	ret    
