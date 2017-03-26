
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

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
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

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
80100044:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 14             	sub    $0x14,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 00 6e 10 	movl   $0x80106e00,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010005b:	e8 70 41 00 00       	call   801041d0 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
80100060:	ba dc fc 10 80       	mov    $0x8010fcdc,%edx

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100065:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 07 6e 10 	movl   $0x80106e07,0x4(%esp)
8010009b:	80 
8010009c:	e8 1f 40 00 00       	call   801040c0 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d dc fc 10 80       	cmp    $0x8010fcdc,%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b4:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
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
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000dc:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000e6:	e8 65 41 00 00       	call   80104250 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000f1:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
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

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100126:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
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
8010015a:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100161:	e8 1a 42 00 00       	call   80104380 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 8f 3f 00 00       	call   80104100 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!(b->flags & B_VALID)) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 02 20 00 00       	call   80102180 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100188:	c7 04 24 0e 6e 10 80 	movl   $0x80106e0e,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 eb 3f 00 00       	call   801041a0 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 b7 1f 00 00       	jmp    80102180 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	c7 04 24 1f 6e 10 80 	movl   $0x80106e1f,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
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
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 aa 3f 00 00       	call   801041a0 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 5e 3f 00 00       	call   80104160 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100209:	e8 42 40 00 00       	call   80104250 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100235:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
80100250:	e9 2b 41 00 00       	jmp    80104380 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100255:	c7 04 24 26 6e 10 80 	movl   $0x80106e26,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

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
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 69 15 00 00       	call   801017f0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 bd 3f 00 00       	call   80104250 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 26                	jmp    801002c9 <consoleread+0x59>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(proc->killed){
801002a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801002ae:	8b 40 24             	mov    0x24(%eax),%eax
801002b1:	85 c0                	test   %eax,%eax
801002b3:	75 73                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b5:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bc:	80 
801002bd:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
801002c4:	e8 97 3a 00 00       	call   80103d60 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c9:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801002ce:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801002d4:	74 d2                	je     801002a8 <consoleread+0x38>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d6:	8d 50 01             	lea    0x1(%eax),%edx
801002d9:	89 15 c0 ff 10 80    	mov    %edx,0x8010ffc0
801002df:	89 c2                	mov    %eax,%edx
801002e1:	83 e2 7f             	and    $0x7f,%edx
801002e4:	0f b6 8a 40 ff 10 80 	movzbl -0x7fef00c0(%edx),%ecx
801002eb:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ee:	83 fa 04             	cmp    $0x4,%edx
801002f1:	74 56                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f3:	83 c6 01             	add    $0x1,%esi
    --n;
801002f6:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f9:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002fc:	88 4e ff             	mov    %cl,-0x1(%esi)
    --n;
    if(c == '\n')
801002ff:	74 52                	je     80100353 <consoleread+0xe3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100301:	85 db                	test   %ebx,%ebx
80100303:	75 c4                	jne    801002c9 <consoleread+0x59>
80100305:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100308:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100312:	e8 69 40 00 00       	call   80104380 <release>
  ilock(ip);
80100317:	89 3c 24             	mov    %edi,(%esp)
8010031a:	e8 01 14 00 00       	call   80101720 <ilock>
8010031f:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100322:	eb 1d                	jmp    80100341 <consoleread+0xd1>
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(proc->killed){
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 4c 40 00 00       	call   80104380 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 e4 13 00 00       	call   80101720 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
8010034e:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ae                	jmp    80100308 <consoleread+0x98>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb aa                	jmp    80100308 <consoleread+0x98>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100369:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
8010036f:	8d 5d d0             	lea    -0x30(%ebp),%ebx
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100372:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100379:	00 00 00 
8010037c:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
8010037f:	0f b6 00             	movzbl (%eax),%eax
80100382:	c7 04 24 2d 6e 10 80 	movl   $0x80106e2d,(%esp)
80100389:	89 44 24 04          	mov    %eax,0x4(%esp)
8010038d:	e8 be 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
80100392:	8b 45 08             	mov    0x8(%ebp),%eax
80100395:	89 04 24             	mov    %eax,(%esp)
80100398:	e8 b3 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
8010039d:	c7 04 24 26 73 10 80 	movl   $0x80107326,(%esp)
801003a4:	e8 a7 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a9:	8d 45 08             	lea    0x8(%ebp),%eax
801003ac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003b0:	89 04 24             	mov    %eax,(%esp)
801003b3:	e8 38 3e 00 00       	call   801041f0 <getcallerpcs>
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 49 6e 10 80 	movl   $0x80106e49,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 12 55 00 00       	call   80105920 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx

  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 

  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 62 54 00 00       	call   80105920 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 56 54 00 00       	call   80105920 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 4a 54 00 00       	call   80105920 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 6f 3f 00 00       	call   80104470 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 b2 3e 00 00       	call   801043d0 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010052a:	c7 04 24 4d 6e 10 80 	movl   $0x80106e4d,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  else
    x = xx;

  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 78 6e 10 80 	movzbl -0x7fef9188(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>

  if(sign)
801005a8:	85 ff                	test   %edi,%edi
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  }while((x /= base) != 0);

  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
    consputc(buf[i]);
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 e9 11 00 00       	call   801017f0 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 3d 3c 00 00       	call   80104250 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 45 3d 00 00       	call   80104380 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 da 10 00 00       	call   80101720 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
    acquire(&cons.lock);

  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
      break;
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
      consputc(c);
      break;
    }
  }

  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 88 3c 00 00       	call   80104380 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 60 6e 10 80       	mov    $0x80106e60,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 b4 3a 00 00       	call   80104250 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007a1:	c7 04 24 67 6e 10 80 	movl   $0x80106e67,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 86 3a 00 00       	call   80104250 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801007f2:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801007f7:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 54 3b 00 00       	call   80104380 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 c8 ff 10 80    	mov    %edx,0x8010ffc8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 40 ff 10 80    	mov    %cl,-0x7fef00c0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d c0 ff 10 80    	mov    0x8010ffc0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008a6:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ad:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
801008b2:	e8 59 36 00 00       	call   80103f10 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008c0:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801008c5:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008d8:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008e7:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801008ec:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100900:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 c4 36 00 00       	jmp    80103ff0 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 70 6e 10 	movl   $0x80106e70,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 66 38 00 00       	call   801041d0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
8010096a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
80100971:	c7 05 8c 09 11 80 f0 	movl   $0x801005f0,0x8011098c
80100978:	05 10 80 
  devsw[CONSOLE].read = consoleread;
8010097b:	c7 05 88 09 11 80 70 	movl   $0x80100270,0x80110988
80100982:	02 10 80 
  cons.locking = 1;
80100985:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
8010098c:	00 00 00 

  picenable(IRQ_KBD);
8010098f:	e8 cc 28 00 00       	call   80103260 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100994:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010099b:	00 
8010099c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801009a3:	e8 68 19 00 00       	call   80102310 <ioapicenable>
}
801009a8:	c9                   	leave  
801009a9:	c3                   	ret    
801009aa:	66 90                	xchg   %ax,%ax
801009ac:	66 90                	xchg   %ax,%ax
801009ae:	66 90                	xchg   %ax,%ax

801009b0 <pseudo_main>:
#include "x86.h"
#include "elf.h"
#include "syscall.h"
void 
pseudo_main(int (*entry)(int, char**), int argc, char **argv) 
{
801009b0:	55                   	push   %ebp
801009b1:	89 e5                	mov    %esp,%ebp
801009b3:	83 ec 18             	sub    $0x18,%esp
  entry(argc, argv);
801009b6:	8b 45 10             	mov    0x10(%ebp),%eax
801009b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801009bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801009c0:	89 04 24             	mov    %eax,(%esp)
801009c3:	ff 55 08             	call   *0x8(%ebp)
  __asm__ (
801009c6:	50                   	push   %eax
801009c7:	6a 00                	push   $0x0
801009c9:	b8 02 00 00 00       	mov    $0x2,%eax
801009ce:	cd 40                	int    $0x40
          "pushl %eax\n\t" // return value
          "pushl $0\n\t" // ret addr - we don't give a shit about that
          "movl $2, %eax\n\t" // sys_exit index
          "int $64"); // system call

}
801009d0:	c9                   	leave  
801009d1:	c3                   	ret    
801009d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009e0 <exec>:

int
exec(char *path, char **argv)
{
801009e0:	55                   	push   %ebp
801009e1:	89 e5                	mov    %esp,%ebp
801009e3:	57                   	push   %edi
801009e4:	56                   	push   %esi
801009e5:	53                   	push   %ebx
801009e6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
801009ec:	e8 ff 21 00 00       	call   80102bf0 <begin_op>

  if((ip = namei(path)) == 0){
801009f1:	8b 45 08             	mov    0x8(%ebp),%eax
801009f4:	89 04 24             	mov    %eax,(%esp)
801009f7:	e8 54 15 00 00       	call   80101f50 <namei>
801009fc:	85 c0                	test   %eax,%eax
801009fe:	89 c3                	mov    %eax,%ebx
80100a00:	74 37                	je     80100a39 <exec+0x59>
    end_op();
    return -1;
  }
  ilock(ip);
80100a02:	89 04 24             	mov    %eax,(%esp)
80100a05:	e8 16 0d 00 00       	call   80101720 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a0a:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a10:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100a17:	00 
80100a18:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100a1f:	00 
80100a20:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a24:	89 1c 24             	mov    %ebx,(%esp)
80100a27:	e8 84 0f 00 00       	call   801019b0 <readi>
80100a2c:	83 f8 34             	cmp    $0x34,%eax
80100a2f:	74 1f                	je     80100a50 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a31:	89 1c 24             	mov    %ebx,(%esp)
80100a34:	e8 27 0f 00 00       	call   80101960 <iunlockput>
    end_op();
80100a39:	e8 22 22 00 00       	call   80102c60 <end_op>
  }
  return -1;
80100a3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

80100a43:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a49:	5b                   	pop    %ebx
80100a4a:	5e                   	pop    %esi
80100a4b:	5f                   	pop    %edi
80100a4c:	5d                   	pop    %ebp
80100a4d:	c3                   	ret    
80100a4e:	66 90                	xchg   %ax,%ax
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a50:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a57:	45 4c 46 
80100a5a:	75 d5                	jne    80100a31 <exec+0x51>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a5c:	e8 3f 5d 00 00       	call   801067a0 <setupkvm>
80100a61:	85 c0                	test   %eax,%eax
80100a63:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a69:	74 c6                	je     80100a31 <exec+0x51>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a6b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a72:	00 
80100a73:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
80100a79:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100a80:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a83:	0f 84 da 00 00 00    	je     80100b63 <exec+0x183>
80100a89:	31 ff                	xor    %edi,%edi
80100a8b:	eb 18                	jmp    80100aa5 <exec+0xc5>
80100a8d:	8d 76 00             	lea    0x0(%esi),%esi
80100a90:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a97:	83 c7 01             	add    $0x1,%edi
80100a9a:	83 c6 20             	add    $0x20,%esi
80100a9d:	39 f8                	cmp    %edi,%eax
80100a9f:	0f 8e be 00 00 00    	jle    80100b63 <exec+0x183>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100aa5:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100aab:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100ab2:	00 
80100ab3:	89 74 24 08          	mov    %esi,0x8(%esp)
80100ab7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100abb:	89 1c 24             	mov    %ebx,(%esp)
80100abe:	e8 ed 0e 00 00       	call   801019b0 <readi>
80100ac3:	83 f8 20             	cmp    $0x20,%eax
80100ac6:	0f 85 84 00 00 00    	jne    80100b50 <exec+0x170>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100acc:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ad3:	75 bb                	jne    80100a90 <exec+0xb0>
      continue;
    if(ph.memsz < ph.filesz)
80100ad5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100adb:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ae1:	72 6d                	jb     80100b50 <exec+0x170>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 65                	jb     80100b50 <exec+0x170>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100aef:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100af5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100aff:	89 04 24             	mov    %eax,(%esp)
80100b02:	e8 69 5f 00 00       	call   80106a70 <allocuvm>
80100b07:	85 c0                	test   %eax,%eax
80100b09:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b0f:	74 3f                	je     80100b50 <exec+0x170>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b11:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b17:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b1c:	75 32                	jne    80100b50 <exec+0x170>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b1e:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100b24:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b28:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b2e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b32:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b36:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b3c:	89 04 24             	mov    %eax,(%esp)
80100b3f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b43:	e8 68 5e 00 00       	call   801069b0 <loaduvm>
80100b48:	85 c0                	test   %eax,%eax
80100b4a:	0f 89 40 ff ff ff    	jns    80100a90 <exec+0xb0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b50:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b56:	89 04 24             	mov    %eax,(%esp)
80100b59:	e8 22 60 00 00       	call   80106b80 <freevm>
80100b5e:	e9 ce fe ff ff       	jmp    80100a31 <exec+0x51>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b63:	89 1c 24             	mov    %ebx,(%esp)
80100b66:	e8 f5 0d 00 00       	call   80101960 <iunlockput>
80100b6b:	90                   	nop
80100b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b70:	e8 eb 20 00 00       	call   80102c60 <end_op>

  pointer_pseudo_main = sz;  

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b75:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b7b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b80:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 3*PGSIZE)) == 0)
80100b85:	8d 90 00 30 00 00    	lea    0x3000(%eax),%edx
80100b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b8f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b95:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b99:	89 04 24             	mov    %eax,(%esp)
80100b9c:	e8 cf 5e 00 00       	call   80106a70 <allocuvm>
80100ba1:	85 c0                	test   %eax,%eax
80100ba3:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100ba9:	75 18                	jne    80100bc3 <exec+0x1e3>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100bab:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100bb1:	89 04 24             	mov    %eax,(%esp)
80100bb4:	e8 c7 5f 00 00       	call   80106b80 <freevm>
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bbe:	e9 80 fe ff ff       	jmp    80100a43 <exec+0x63>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 3*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bc3:	8b b5 e8 fe ff ff    	mov    -0x118(%ebp),%esi
80100bc9:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100bcf:	89 f0                	mov    %esi,%eax
80100bd1:	2d 00 20 00 00       	sub    $0x2000,%eax
80100bd6:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bda:	89 3c 24             	mov    %edi,(%esp)
80100bdd:	e8 1e 60 00 00       	call   80106c00 <clearpteu>
  
  if (copyout(pgdir, pointer_pseudo_main, pseudo_main, (uint)exec - (uint)pseudo_main) < 0)
80100be2:	b8 e0 09 10 80       	mov    $0x801009e0,%eax
80100be7:	2d b0 09 10 80       	sub    $0x801009b0,%eax
80100bec:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100bf0:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bf6:	c7 44 24 08 b0 09 10 	movl   $0x801009b0,0x8(%esp)
80100bfd:	80 
80100bfe:	89 3c 24             	mov    %edi,(%esp)
80100c01:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c05:	e8 56 61 00 00       	call   80106d60 <copyout>
80100c0a:	85 c0                	test   %eax,%eax
80100c0c:	78 9d                	js     80100bab <exec+0x1cb>
    goto bad;

  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c11:	8b 00                	mov    (%eax),%eax
80100c13:	85 c0                	test   %eax,%eax
80100c15:	0f 84 74 01 00 00    	je     80100d8f <exec+0x3af>
80100c1b:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100c1e:	31 db                	xor    %ebx,%ebx
80100c20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100c23:	89 da                	mov    %ebx,%edx
80100c25:	89 fb                	mov    %edi,%ebx
80100c27:	89 d7                	mov    %edx,%edi
80100c29:	83 c1 04             	add    $0x4,%ecx
80100c2c:	eb 0e                	jmp    80100c3c <exec+0x25c>
80100c2e:	66 90                	xchg   %ax,%ax
80100c30:	83 c1 04             	add    $0x4,%ecx
    if(argc >= MAXARG)
80100c33:	83 ff 20             	cmp    $0x20,%edi
80100c36:	0f 84 6f ff ff ff    	je     80100bab <exec+0x1cb>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c3c:	89 04 24             	mov    %eax,(%esp)
80100c3f:	89 8d ec fe ff ff    	mov    %ecx,-0x114(%ebp)
80100c45:	e8 a6 39 00 00       	call   801045f0 <strlen>
80100c4a:	f7 d0                	not    %eax
80100c4c:	01 c6                	add    %eax,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c4e:	8b 03                	mov    (%ebx),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c50:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c53:	89 04 24             	mov    %eax,(%esp)
80100c56:	e8 95 39 00 00       	call   801045f0 <strlen>
80100c5b:	83 c0 01             	add    $0x1,%eax
80100c5e:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c62:	8b 03                	mov    (%ebx),%eax
80100c64:	89 74 24 04          	mov    %esi,0x4(%esp)
80100c68:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c6c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c72:	89 04 24             	mov    %eax,(%esp)
80100c75:	e8 e6 60 00 00       	call   80106d60 <copyout>
80100c7a:	85 c0                	test   %eax,%eax
80100c7c:	0f 88 29 ff ff ff    	js     80100bab <exec+0x1cb>
    goto bad;

  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c82:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[4+argc] = sp;
80100c88:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c8e:	89 b4 bd 68 ff ff ff 	mov    %esi,-0x98(%ebp,%edi,4)
    goto bad;

  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c95:	83 c7 01             	add    $0x1,%edi
80100c98:	8b 01                	mov    (%ecx),%eax
80100c9a:	89 cb                	mov    %ecx,%ebx
80100c9c:	85 c0                	test   %eax,%eax
80100c9e:	75 90                	jne    80100c30 <exec+0x250>
80100ca0:	89 fb                	mov    %edi,%ebx
    ustack[4+argc] = sp;
  }
  ustack[4+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = elf.entry;
80100ca2:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  ustack[2] = argc;
  ustack[3] = sp - (argc+1)*4;  // argv pointer
80100ca8:	89 f1                	mov    %esi,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[4+argc] = sp;
  }
  ustack[4+argc] = 0;
80100caa:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80100cb1:	00 00 00 00 
  ustack[1] = elf.entry;
  ustack[2] = argc;
  ustack[3] = sp - (argc+1)*4;  // argv pointer

  sp -= (4+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (4+argc+1)*4) < 0)
80100cb5:	89 54 24 08          	mov    %edx,0x8(%esp)
  }
  ustack[4+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = elf.entry;
  ustack[2] = argc;
80100cb9:	89 9d 60 ff ff ff    	mov    %ebx,-0xa0(%ebp)
    ustack[4+argc] = sp;
  }
  ustack[4+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = elf.entry;
80100cbf:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = argc;
  ustack[3] = sp - (argc+1)*4;  // argv pointer
80100cc5:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
80100ccc:	29 c1                	sub    %eax,%ecx

  sp -= (4+argc+1) * 4;
80100cce:	83 c0 10             	add    $0x10,%eax
80100cd1:	29 c6                	sub    %eax,%esi
  if(copyout(pgdir, sp, ustack, (4+argc+1)*4) < 0)
80100cd3:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100cd7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = elf.entry;
  ustack[2] = argc;
  ustack[3] = sp - (argc+1)*4;  // argv pointer

  sp -= (4+argc+1) * 4;
80100cdd:	89 f3                	mov    %esi,%ebx
  if(copyout(pgdir, sp, ustack, (4+argc+1)*4) < 0)
80100cdf:	89 74 24 04          	mov    %esi,0x4(%esp)
      goto bad;
    ustack[4+argc] = sp;
  }
  ustack[4+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100ce3:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100cea:	ff ff ff 
  ustack[1] = elf.entry;
  ustack[2] = argc;
  ustack[3] = sp - (argc+1)*4;  // argv pointer
80100ced:	89 8d 64 ff ff ff    	mov    %ecx,-0x9c(%ebp)

  sp -= (4+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (4+argc+1)*4) < 0)
80100cf3:	89 04 24             	mov    %eax,(%esp)
80100cf6:	e8 65 60 00 00       	call   80106d60 <copyout>
80100cfb:	85 c0                	test   %eax,%eax
80100cfd:	0f 88 a8 fe ff ff    	js     80100bab <exec+0x1cb>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100d03:	8b 45 08             	mov    0x8(%ebp),%eax
80100d06:	0f b6 10             	movzbl (%eax),%edx
80100d09:	84 d2                	test   %dl,%dl
80100d0b:	74 19                	je     80100d26 <exec+0x346>
80100d0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100d10:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100d13:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (4+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (4+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100d16:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100d19:	0f 44 c8             	cmove  %eax,%ecx
80100d1c:	83 c0 01             	add    $0x1,%eax
  sp -= (4+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (4+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100d1f:	84 d2                	test   %dl,%dl
80100d21:	75 f0                	jne    80100d13 <exec+0x333>
80100d23:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100d26:	8b 45 08             	mov    0x8(%ebp),%eax
80100d29:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100d30:	00 
80100d31:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d35:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100d3b:	83 c0 6c             	add    $0x6c,%eax
80100d3e:	89 04 24             	mov    %eax,(%esp)
80100d41:	e8 6a 38 00 00       	call   801045b0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100d46:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100d4c:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100d52:	8b 70 04             	mov    0x4(%eax),%esi
  proc->pgdir = pgdir;
80100d55:	89 48 04             	mov    %ecx,0x4(%eax)
  proc->sz = sz;
80100d58:	8b 8d e8 fe ff ff    	mov    -0x118(%ebp),%ecx
80100d5e:	89 08                	mov    %ecx,(%eax)
  proc->tf->eip = pointer_pseudo_main;  // main
80100d60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100d66:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100d6c:	8b 50 18             	mov    0x18(%eax),%edx
80100d6f:	89 4a 38             	mov    %ecx,0x38(%edx)
  proc->tf->esp = sp;
80100d72:	8b 50 18             	mov    0x18(%eax),%edx
80100d75:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(proc);
80100d78:	89 04 24             	mov    %eax,(%esp)
80100d7b:	e8 e0 5a 00 00       	call   80106860 <switchuvm>
  freevm(oldpgdir);
80100d80:	89 34 24             	mov    %esi,(%esp)
80100d83:	e8 f8 5d 00 00       	call   80106b80 <freevm>
  return 0;
80100d88:	31 c0                	xor    %eax,%eax
80100d8a:	e9 b4 fc ff ff       	jmp    80100a43 <exec+0x63>
    goto bad;

  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d8f:	8b b5 e8 fe ff ff    	mov    -0x118(%ebp),%esi
80100d95:	31 db                	xor    %ebx,%ebx
80100d97:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100d9d:	e9 00 ff ff ff       	jmp    80100ca2 <exec+0x2c2>
80100da2:	66 90                	xchg   %ax,%ax
80100da4:	66 90                	xchg   %ax,%ax
80100da6:	66 90                	xchg   %ax,%ax
80100da8:	66 90                	xchg   %ax,%ax
80100daa:	66 90                	xchg   %ax,%ax
80100dac:	66 90                	xchg   %ax,%ax
80100dae:	66 90                	xchg   %ax,%ax

80100db0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100db0:	55                   	push   %ebp
80100db1:	89 e5                	mov    %esp,%ebp
80100db3:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100db6:	c7 44 24 04 89 6e 10 	movl   $0x80106e89,0x4(%esp)
80100dbd:	80 
80100dbe:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100dc5:	e8 06 34 00 00       	call   801041d0 <initlock>
}
80100dca:	c9                   	leave  
80100dcb:	c3                   	ret    
80100dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100dd0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100dd0:	55                   	push   %ebp
80100dd1:	89 e5                	mov    %esp,%ebp
80100dd3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dd4:	bb 14 00 11 80       	mov    $0x80110014,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100dd9:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100ddc:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100de3:	e8 68 34 00 00       	call   80104250 <acquire>
80100de8:	eb 11                	jmp    80100dfb <filealloc+0x2b>
80100dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100df0:	83 c3 18             	add    $0x18,%ebx
80100df3:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80100df9:	74 25                	je     80100e20 <filealloc+0x50>
    if(f->ref == 0){
80100dfb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dfe:	85 c0                	test   %eax,%eax
80100e00:	75 ee                	jne    80100df0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e02:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100e09:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e10:	e8 6b 35 00 00       	call   80104380 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e15:	83 c4 14             	add    $0x14,%esp
  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
80100e18:	89 d8                	mov    %ebx,%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e1a:	5b                   	pop    %ebx
80100e1b:	5d                   	pop    %ebp
80100e1c:	c3                   	ret    
80100e1d:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100e20:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100e27:	e8 54 35 00 00       	call   80104380 <release>
  return 0;
}
80100e2c:	83 c4 14             	add    $0x14,%esp
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
80100e2f:	31 c0                	xor    %eax,%eax
}
80100e31:	5b                   	pop    %ebx
80100e32:	5d                   	pop    %ebp
80100e33:	c3                   	ret    
80100e34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100e40 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	53                   	push   %ebx
80100e44:	83 ec 14             	sub    $0x14,%esp
80100e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e4a:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100e51:	e8 fa 33 00 00       	call   80104250 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	85 c0                	test   %eax,%eax
80100e5b:	7e 1a                	jle    80100e77 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100e5d:	83 c0 01             	add    $0x1,%eax
80100e60:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e63:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100e6a:	e8 11 35 00 00       	call   80104380 <release>
  return f;
}
80100e6f:	83 c4 14             	add    $0x14,%esp
80100e72:	89 d8                	mov    %ebx,%eax
80100e74:	5b                   	pop    %ebx
80100e75:	5d                   	pop    %ebp
80100e76:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e77:	c7 04 24 90 6e 10 80 	movl   $0x80106e90,(%esp)
80100e7e:	e8 dd f4 ff ff       	call   80100360 <panic>
80100e83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e90 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e90:	55                   	push   %ebp
80100e91:	89 e5                	mov    %esp,%ebp
80100e93:	57                   	push   %edi
80100e94:	56                   	push   %esi
80100e95:	53                   	push   %ebx
80100e96:	83 ec 1c             	sub    $0x1c,%esp
80100e99:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e9c:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100ea3:	e8 a8 33 00 00       	call   80104250 <acquire>
  if(f->ref < 1)
80100ea8:	8b 57 04             	mov    0x4(%edi),%edx
80100eab:	85 d2                	test   %edx,%edx
80100ead:	0f 8e 89 00 00 00    	jle    80100f3c <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100eb3:	83 ea 01             	sub    $0x1,%edx
80100eb6:	85 d2                	test   %edx,%edx
80100eb8:	89 57 04             	mov    %edx,0x4(%edi)
80100ebb:	74 13                	je     80100ed0 <fileclose+0x40>
    release(&ftable.lock);
80100ebd:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ec4:	83 c4 1c             	add    $0x1c,%esp
80100ec7:	5b                   	pop    %ebx
80100ec8:	5e                   	pop    %esi
80100ec9:	5f                   	pop    %edi
80100eca:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100ecb:	e9 b0 34 00 00       	jmp    80104380 <release>
    return;
  }
  ff = *f;
80100ed0:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100ed4:	8b 37                	mov    (%edi),%esi
80100ed6:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
80100ed9:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100edf:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ee2:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ee5:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100eec:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100eef:	e8 8c 34 00 00       	call   80104380 <release>

  if(ff.type == FD_PIPE)
80100ef4:	83 fe 01             	cmp    $0x1,%esi
80100ef7:	74 0f                	je     80100f08 <fileclose+0x78>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ef9:	83 fe 02             	cmp    $0x2,%esi
80100efc:	74 22                	je     80100f20 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100efe:	83 c4 1c             	add    $0x1c,%esp
80100f01:	5b                   	pop    %ebx
80100f02:	5e                   	pop    %esi
80100f03:	5f                   	pop    %edi
80100f04:	5d                   	pop    %ebp
80100f05:	c3                   	ret    
80100f06:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100f08:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100f0c:	89 1c 24             	mov    %ebx,(%esp)
80100f0f:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f13:	e8 f8 24 00 00       	call   80103410 <pipeclose>
80100f18:	eb e4                	jmp    80100efe <fileclose+0x6e>
80100f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100f20:	e8 cb 1c 00 00       	call   80102bf0 <begin_op>
    iput(ff.ip);
80100f25:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f28:	89 04 24             	mov    %eax,(%esp)
80100f2b:	e8 00 09 00 00       	call   80101830 <iput>
    end_op();
  }
}
80100f30:	83 c4 1c             	add    $0x1c,%esp
80100f33:	5b                   	pop    %ebx
80100f34:	5e                   	pop    %esi
80100f35:	5f                   	pop    %edi
80100f36:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100f37:	e9 24 1d 00 00       	jmp    80102c60 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100f3c:	c7 04 24 98 6e 10 80 	movl   $0x80106e98,(%esp)
80100f43:	e8 18 f4 ff ff       	call   80100360 <panic>
80100f48:	90                   	nop
80100f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f50 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	53                   	push   %ebx
80100f54:	83 ec 14             	sub    $0x14,%esp
80100f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f5a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f5d:	75 31                	jne    80100f90 <filestat+0x40>
    ilock(f->ip);
80100f5f:	8b 43 10             	mov    0x10(%ebx),%eax
80100f62:	89 04 24             	mov    %eax,(%esp)
80100f65:	e8 b6 07 00 00       	call   80101720 <ilock>
    stati(f->ip, st);
80100f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f6d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f71:	8b 43 10             	mov    0x10(%ebx),%eax
80100f74:	89 04 24             	mov    %eax,(%esp)
80100f77:	e8 04 0a 00 00       	call   80101980 <stati>
    iunlock(f->ip);
80100f7c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f7f:	89 04 24             	mov    %eax,(%esp)
80100f82:	e8 69 08 00 00       	call   801017f0 <iunlock>
    return 0;
  }
  return -1;
}
80100f87:	83 c4 14             	add    $0x14,%esp
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
80100f8a:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f8c:	5b                   	pop    %ebx
80100f8d:	5d                   	pop    %ebp
80100f8e:	c3                   	ret    
80100f8f:	90                   	nop
80100f90:	83 c4 14             	add    $0x14,%esp
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f98:	5b                   	pop    %ebx
80100f99:	5d                   	pop    %ebp
80100f9a:	c3                   	ret    
80100f9b:	90                   	nop
80100f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fa0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100fa0:	55                   	push   %ebp
80100fa1:	89 e5                	mov    %esp,%ebp
80100fa3:	57                   	push   %edi
80100fa4:	56                   	push   %esi
80100fa5:	53                   	push   %ebx
80100fa6:	83 ec 1c             	sub    $0x1c,%esp
80100fa9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100fac:	8b 75 0c             	mov    0xc(%ebp),%esi
80100faf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100fb2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100fb6:	74 68                	je     80101020 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100fb8:	8b 03                	mov    (%ebx),%eax
80100fba:	83 f8 01             	cmp    $0x1,%eax
80100fbd:	74 49                	je     80101008 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fbf:	83 f8 02             	cmp    $0x2,%eax
80100fc2:	75 63                	jne    80101027 <fileread+0x87>
    ilock(f->ip);
80100fc4:	8b 43 10             	mov    0x10(%ebx),%eax
80100fc7:	89 04 24             	mov    %eax,(%esp)
80100fca:	e8 51 07 00 00       	call   80101720 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fcf:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100fd3:	8b 43 14             	mov    0x14(%ebx),%eax
80100fd6:	89 74 24 04          	mov    %esi,0x4(%esp)
80100fda:	89 44 24 08          	mov    %eax,0x8(%esp)
80100fde:	8b 43 10             	mov    0x10(%ebx),%eax
80100fe1:	89 04 24             	mov    %eax,(%esp)
80100fe4:	e8 c7 09 00 00       	call   801019b0 <readi>
80100fe9:	85 c0                	test   %eax,%eax
80100feb:	89 c6                	mov    %eax,%esi
80100fed:	7e 03                	jle    80100ff2 <fileread+0x52>
      f->off += r;
80100fef:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100ff2:	8b 43 10             	mov    0x10(%ebx),%eax
80100ff5:	89 04 24             	mov    %eax,(%esp)
80100ff8:	e8 f3 07 00 00       	call   801017f0 <iunlock>
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100ffd:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fff:	83 c4 1c             	add    $0x1c,%esp
80101002:	5b                   	pop    %ebx
80101003:	5e                   	pop    %esi
80101004:	5f                   	pop    %edi
80101005:	5d                   	pop    %ebp
80101006:	c3                   	ret    
80101007:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80101008:	8b 43 0c             	mov    0xc(%ebx),%eax
8010100b:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
8010100e:	83 c4 1c             	add    $0x1c,%esp
80101011:	5b                   	pop    %ebx
80101012:	5e                   	pop    %esi
80101013:	5f                   	pop    %edi
80101014:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80101015:	e9 a6 25 00 00       	jmp    801035c0 <piperead>
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80101020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101025:	eb d8                	jmp    80100fff <fileread+0x5f>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80101027:	c7 04 24 a2 6e 10 80 	movl   $0x80106ea2,(%esp)
8010102e:	e8 2d f3 ff ff       	call   80100360 <panic>
80101033:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101040 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	57                   	push   %edi
80101044:	56                   	push   %esi
80101045:	53                   	push   %ebx
80101046:	83 ec 2c             	sub    $0x2c,%esp
80101049:	8b 45 0c             	mov    0xc(%ebp),%eax
8010104c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010104f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101052:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101055:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101059:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
8010105c:	0f 84 ae 00 00 00    	je     80101110 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101062:	8b 07                	mov    (%edi),%eax
80101064:	83 f8 01             	cmp    $0x1,%eax
80101067:	0f 84 c2 00 00 00    	je     8010112f <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010106d:	83 f8 02             	cmp    $0x2,%eax
80101070:	0f 85 d7 00 00 00    	jne    8010114d <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101076:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101079:	31 db                	xor    %ebx,%ebx
8010107b:	85 c0                	test   %eax,%eax
8010107d:	7f 31                	jg     801010b0 <filewrite+0x70>
8010107f:	e9 9c 00 00 00       	jmp    80101120 <filewrite+0xe0>
80101084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101088:	8b 4f 10             	mov    0x10(%edi),%ecx
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
8010108b:	01 47 14             	add    %eax,0x14(%edi)
8010108e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101091:	89 0c 24             	mov    %ecx,(%esp)
80101094:	e8 57 07 00 00       	call   801017f0 <iunlock>
      end_op();
80101099:	e8 c2 1b 00 00       	call   80102c60 <end_op>
8010109e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
801010a1:	39 f0                	cmp    %esi,%eax
801010a3:	0f 85 98 00 00 00    	jne    80101141 <filewrite+0x101>
        panic("short filewrite");
      i += r;
801010a9:	01 c3                	add    %eax,%ebx
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ab:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
801010ae:	7e 70                	jle    80101120 <filewrite+0xe0>
      int n1 = n - i;
801010b0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801010b3:	b8 00 1a 00 00       	mov    $0x1a00,%eax
801010b8:	29 de                	sub    %ebx,%esi
801010ba:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
801010c0:	0f 4f f0             	cmovg  %eax,%esi
      if(n1 > max)
        n1 = max;

      begin_op();
801010c3:	e8 28 1b 00 00       	call   80102bf0 <begin_op>
      ilock(f->ip);
801010c8:	8b 47 10             	mov    0x10(%edi),%eax
801010cb:	89 04 24             	mov    %eax,(%esp)
801010ce:	e8 4d 06 00 00       	call   80101720 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010d3:	89 74 24 0c          	mov    %esi,0xc(%esp)
801010d7:	8b 47 14             	mov    0x14(%edi),%eax
801010da:	89 44 24 08          	mov    %eax,0x8(%esp)
801010de:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010e1:	01 d8                	add    %ebx,%eax
801010e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801010e7:	8b 47 10             	mov    0x10(%edi),%eax
801010ea:	89 04 24             	mov    %eax,(%esp)
801010ed:	e8 be 09 00 00       	call   80101ab0 <writei>
801010f2:	85 c0                	test   %eax,%eax
801010f4:	7f 92                	jg     80101088 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
801010f6:	8b 4f 10             	mov    0x10(%edi),%ecx
801010f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010fc:	89 0c 24             	mov    %ecx,(%esp)
801010ff:	e8 ec 06 00 00       	call   801017f0 <iunlock>
      end_op();
80101104:	e8 57 1b 00 00       	call   80102c60 <end_op>

      if(r < 0)
80101109:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010110c:	85 c0                	test   %eax,%eax
8010110e:	74 91                	je     801010a1 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101110:	83 c4 2c             	add    $0x2c,%esp
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
80101113:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101118:	5b                   	pop    %ebx
80101119:	5e                   	pop    %esi
8010111a:	5f                   	pop    %edi
8010111b:	5d                   	pop    %ebp
8010111c:	c3                   	ret    
8010111d:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101120:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80101123:	89 d8                	mov    %ebx,%eax
80101125:	75 e9                	jne    80101110 <filewrite+0xd0>
  }
  panic("filewrite");
}
80101127:	83 c4 2c             	add    $0x2c,%esp
8010112a:	5b                   	pop    %ebx
8010112b:	5e                   	pop    %esi
8010112c:	5f                   	pop    %edi
8010112d:	5d                   	pop    %ebp
8010112e:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010112f:	8b 47 0c             	mov    0xc(%edi),%eax
80101132:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101135:	83 c4 2c             	add    $0x2c,%esp
80101138:	5b                   	pop    %ebx
80101139:	5e                   	pop    %esi
8010113a:	5f                   	pop    %edi
8010113b:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010113c:	e9 5f 23 00 00       	jmp    801034a0 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
80101141:	c7 04 24 ab 6e 10 80 	movl   $0x80106eab,(%esp)
80101148:	e8 13 f2 ff ff       	call   80100360 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
8010114d:	c7 04 24 b1 6e 10 80 	movl   $0x80106eb1,(%esp)
80101154:	e8 07 f2 ff ff       	call   80100360 <panic>
80101159:	66 90                	xchg   %ax,%ax
8010115b:	66 90                	xchg   %ax,%ax
8010115d:	66 90                	xchg   %ax,%ax
8010115f:	90                   	nop

80101160 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101160:	55                   	push   %ebp
80101161:	89 e5                	mov    %esp,%ebp
80101163:	57                   	push   %edi
80101164:	56                   	push   %esi
80101165:	53                   	push   %ebx
80101166:	83 ec 2c             	sub    $0x2c,%esp
80101169:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010116c:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101171:	85 c0                	test   %eax,%eax
80101173:	0f 84 8c 00 00 00    	je     80101205 <balloc+0xa5>
80101179:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101180:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101183:	89 f0                	mov    %esi,%eax
80101185:	c1 f8 0c             	sar    $0xc,%eax
80101188:	03 05 f8 09 11 80    	add    0x801109f8,%eax
8010118e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101192:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101195:	89 04 24             	mov    %eax,(%esp)
80101198:	e8 33 ef ff ff       	call   801000d0 <bread>
8010119d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011a0:	a1 e0 09 11 80       	mov    0x801109e0,%eax
801011a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011a8:	31 c0                	xor    %eax,%eax
801011aa:	eb 33                	jmp    801011df <balloc+0x7f>
801011ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011b0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011b3:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801011b5:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011b7:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801011ba:	83 e1 07             	and    $0x7,%ecx
801011bd:	bf 01 00 00 00       	mov    $0x1,%edi
801011c2:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011c4:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801011c9:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011cb:	0f b6 fb             	movzbl %bl,%edi
801011ce:	85 cf                	test   %ecx,%edi
801011d0:	74 46                	je     80101218 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011d2:	83 c0 01             	add    $0x1,%eax
801011d5:	83 c6 01             	add    $0x1,%esi
801011d8:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011dd:	74 05                	je     801011e4 <balloc+0x84>
801011df:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801011e2:	72 cc                	jb     801011b0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011e7:	89 04 24             	mov    %eax,(%esp)
801011ea:	e8 f1 ef ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011ef:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011f9:	3b 05 e0 09 11 80    	cmp    0x801109e0,%eax
801011ff:	0f 82 7b ff ff ff    	jb     80101180 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101205:	c7 04 24 bb 6e 10 80 	movl   $0x80106ebb,(%esp)
8010120c:	e8 4f f1 ff ff       	call   80100360 <panic>
80101211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101218:	09 d9                	or     %ebx,%ecx
8010121a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010121d:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
80101221:	89 1c 24             	mov    %ebx,(%esp)
80101224:	e8 67 1b 00 00       	call   80102d90 <log_write>
        brelse(bp);
80101229:	89 1c 24             	mov    %ebx,(%esp)
8010122c:	e8 af ef ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
80101231:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101234:	89 74 24 04          	mov    %esi,0x4(%esp)
80101238:	89 04 24             	mov    %eax,(%esp)
8010123b:	e8 90 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101240:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101247:	00 
80101248:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010124f:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
80101250:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101252:	8d 40 5c             	lea    0x5c(%eax),%eax
80101255:	89 04 24             	mov    %eax,(%esp)
80101258:	e8 73 31 00 00       	call   801043d0 <memset>
  log_write(bp);
8010125d:	89 1c 24             	mov    %ebx,(%esp)
80101260:	e8 2b 1b 00 00       	call   80102d90 <log_write>
  brelse(bp);
80101265:	89 1c 24             	mov    %ebx,(%esp)
80101268:	e8 73 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010126d:	83 c4 2c             	add    $0x2c,%esp
80101270:	89 f0                	mov    %esi,%eax
80101272:	5b                   	pop    %ebx
80101273:	5e                   	pop    %esi
80101274:	5f                   	pop    %edi
80101275:	5d                   	pop    %ebp
80101276:	c3                   	ret    
80101277:	89 f6                	mov    %esi,%esi
80101279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
80101284:	89 c7                	mov    %eax,%edi
80101286:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101287:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101289:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128a:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010128f:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101292:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101299:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010129c:	e8 af 2f 00 00       	call   80104250 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012a4:	eb 14                	jmp    801012ba <iget+0x3a>
801012a6:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012a8:	85 f6                	test   %esi,%esi
801012aa:	74 3c                	je     801012e8 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ac:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012b2:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
801012b8:	74 46                	je     80101300 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ba:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012bd:	85 c9                	test   %ecx,%ecx
801012bf:	7e e7                	jle    801012a8 <iget+0x28>
801012c1:	39 3b                	cmp    %edi,(%ebx)
801012c3:	75 e3                	jne    801012a8 <iget+0x28>
801012c5:	39 53 04             	cmp    %edx,0x4(%ebx)
801012c8:	75 de                	jne    801012a8 <iget+0x28>
      ip->ref++;
801012ca:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
801012cd:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
801012cf:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012d6:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012d9:	e8 a2 30 00 00       	call   80104380 <release>
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
801012de:	83 c4 1c             	add    $0x1c,%esp
801012e1:	89 f0                	mov    %esi,%eax
801012e3:	5b                   	pop    %ebx
801012e4:	5e                   	pop    %esi
801012e5:	5f                   	pop    %edi
801012e6:	5d                   	pop    %ebp
801012e7:	c3                   	ret    
801012e8:	85 c9                	test   %ecx,%ecx
801012ea:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ed:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012f3:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
801012f9:	75 bf                	jne    801012ba <iget+0x3a>
801012fb:	90                   	nop
801012fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101300:	85 f6                	test   %esi,%esi
80101302:	74 29                	je     8010132d <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101304:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101306:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101309:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
80101310:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101317:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010131e:	e8 5d 30 00 00       	call   80104380 <release>

  return ip;
}
80101323:	83 c4 1c             	add    $0x1c,%esp
80101326:	89 f0                	mov    %esi,%eax
80101328:	5b                   	pop    %ebx
80101329:	5e                   	pop    %esi
8010132a:	5f                   	pop    %edi
8010132b:	5d                   	pop    %ebp
8010132c:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
8010132d:	c7 04 24 d1 6e 10 80 	movl   $0x80106ed1,(%esp)
80101334:	e8 27 f0 ff ff       	call   80100360 <panic>
80101339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101340 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	57                   	push   %edi
80101344:	56                   	push   %esi
80101345:	53                   	push   %ebx
80101346:	89 c3                	mov    %eax,%ebx
80101348:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010134b:	83 fa 0b             	cmp    $0xb,%edx
8010134e:	77 18                	ja     80101368 <bmap+0x28>
80101350:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
80101353:	8b 46 5c             	mov    0x5c(%esi),%eax
80101356:	85 c0                	test   %eax,%eax
80101358:	74 66                	je     801013c0 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010135a:	83 c4 1c             	add    $0x1c,%esp
8010135d:	5b                   	pop    %ebx
8010135e:	5e                   	pop    %esi
8010135f:	5f                   	pop    %edi
80101360:	5d                   	pop    %ebp
80101361:	c3                   	ret    
80101362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101368:	8d 72 f4             	lea    -0xc(%edx),%esi

  if(bn < NINDIRECT){
8010136b:	83 fe 7f             	cmp    $0x7f,%esi
8010136e:	77 77                	ja     801013e7 <bmap+0xa7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101370:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101376:	85 c0                	test   %eax,%eax
80101378:	74 5e                	je     801013d8 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010137a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010137e:	8b 03                	mov    (%ebx),%eax
80101380:	89 04 24             	mov    %eax,(%esp)
80101383:	e8 48 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101388:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010138c:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010138e:	8b 32                	mov    (%edx),%esi
80101390:	85 f6                	test   %esi,%esi
80101392:	75 19                	jne    801013ad <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101394:	8b 03                	mov    (%ebx),%eax
80101396:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101399:	e8 c2 fd ff ff       	call   80101160 <balloc>
8010139e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013a1:	89 02                	mov    %eax,(%edx)
801013a3:	89 c6                	mov    %eax,%esi
      log_write(bp);
801013a5:	89 3c 24             	mov    %edi,(%esp)
801013a8:	e8 e3 19 00 00       	call   80102d90 <log_write>
    }
    brelse(bp);
801013ad:	89 3c 24             	mov    %edi,(%esp)
801013b0:	e8 2b ee ff ff       	call   801001e0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
801013b5:	83 c4 1c             	add    $0x1c,%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013b8:	89 f0                	mov    %esi,%eax
    return addr;
  }

  panic("bmap: out of range");
}
801013ba:	5b                   	pop    %ebx
801013bb:	5e                   	pop    %esi
801013bc:	5f                   	pop    %edi
801013bd:	5d                   	pop    %ebp
801013be:	c3                   	ret    
801013bf:	90                   	nop
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
801013c0:	8b 03                	mov    (%ebx),%eax
801013c2:	e8 99 fd ff ff       	call   80101160 <balloc>
801013c7:	89 46 5c             	mov    %eax,0x5c(%esi)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013ca:	83 c4 1c             	add    $0x1c,%esp
801013cd:	5b                   	pop    %ebx
801013ce:	5e                   	pop    %esi
801013cf:	5f                   	pop    %edi
801013d0:	5d                   	pop    %ebp
801013d1:	c3                   	ret    
801013d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013d8:	8b 03                	mov    (%ebx),%eax
801013da:	e8 81 fd ff ff       	call   80101160 <balloc>
801013df:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
801013e5:	eb 93                	jmp    8010137a <bmap+0x3a>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
801013e7:	c7 04 24 e1 6e 10 80 	movl   $0x80106ee1,(%esp)
801013ee:	e8 6d ef ff ff       	call   80100360 <panic>
801013f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101400 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101400:	55                   	push   %ebp
80101401:	89 e5                	mov    %esp,%ebp
80101403:	56                   	push   %esi
80101404:	53                   	push   %ebx
80101405:	83 ec 10             	sub    $0x10,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101408:	8b 45 08             	mov    0x8(%ebp),%eax
8010140b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101412:	00 
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101413:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101416:	89 04 24             	mov    %eax,(%esp)
80101419:	e8 b2 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010141e:	89 34 24             	mov    %esi,(%esp)
80101421:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101428:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
80101429:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010142b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010142e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101432:	e8 39 30 00 00       	call   80104470 <memmove>
  brelse(bp);
80101437:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010143a:	83 c4 10             	add    $0x10,%esp
8010143d:	5b                   	pop    %ebx
8010143e:	5e                   	pop    %esi
8010143f:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101440:	e9 9b ed ff ff       	jmp    801001e0 <brelse>
80101445:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101450 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	89 d7                	mov    %edx,%edi
80101456:	56                   	push   %esi
80101457:	53                   	push   %ebx
80101458:	89 c3                	mov    %eax,%ebx
8010145a:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
8010145d:	89 04 24             	mov    %eax,(%esp)
80101460:	c7 44 24 04 e0 09 11 	movl   $0x801109e0,0x4(%esp)
80101467:	80 
80101468:	e8 93 ff ff ff       	call   80101400 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010146d:	89 fa                	mov    %edi,%edx
8010146f:	c1 ea 0c             	shr    $0xc,%edx
80101472:	03 15 f8 09 11 80    	add    0x801109f8,%edx
80101478:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
8010147b:	bb 01 00 00 00       	mov    $0x1,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
80101480:	89 54 24 04          	mov    %edx,0x4(%esp)
80101484:	e8 47 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101489:	89 f9                	mov    %edi,%ecx
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
8010148b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101491:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101493:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101496:	c1 fa 03             	sar    $0x3,%edx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101499:	d3 e3                	shl    %cl,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
8010149b:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
8010149d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
801014a2:	0f b6 c8             	movzbl %al,%ecx
801014a5:	85 d9                	test   %ebx,%ecx
801014a7:	74 20                	je     801014c9 <bfree+0x79>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801014a9:	f7 d3                	not    %ebx
801014ab:	21 c3                	and    %eax,%ebx
801014ad:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
801014b1:	89 34 24             	mov    %esi,(%esp)
801014b4:	e8 d7 18 00 00       	call   80102d90 <log_write>
  brelse(bp);
801014b9:	89 34 24             	mov    %esi,(%esp)
801014bc:	e8 1f ed ff ff       	call   801001e0 <brelse>
}
801014c1:	83 c4 1c             	add    $0x1c,%esp
801014c4:	5b                   	pop    %ebx
801014c5:	5e                   	pop    %esi
801014c6:	5f                   	pop    %edi
801014c7:	5d                   	pop    %ebp
801014c8:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
801014c9:	c7 04 24 f4 6e 10 80 	movl   $0x80106ef4,(%esp)
801014d0:	e8 8b ee ff ff       	call   80100360 <panic>
801014d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014e0 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801014e0:	55                   	push   %ebp
801014e1:	89 e5                	mov    %esp,%ebp
801014e3:	53                   	push   %ebx
801014e4:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
801014e9:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
801014ec:	c7 44 24 04 07 6f 10 	movl   $0x80106f07,0x4(%esp)
801014f3:	80 
801014f4:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801014fb:	e8 d0 2c 00 00       	call   801041d0 <initlock>
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101500:	89 1c 24             	mov    %ebx,(%esp)
80101503:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101509:	c7 44 24 04 0e 6f 10 	movl   $0x80106f0e,0x4(%esp)
80101510:	80 
80101511:	e8 aa 2b 00 00       	call   801040c0 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101516:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
8010151c:	75 e2                	jne    80101500 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }
  
  readsb(dev, &sb);
8010151e:	8b 45 08             	mov    0x8(%ebp),%eax
80101521:	c7 44 24 04 e0 09 11 	movl   $0x801109e0,0x4(%esp)
80101528:	80 
80101529:	89 04 24             	mov    %eax,(%esp)
8010152c:	e8 cf fe ff ff       	call   80101400 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101531:	a1 f8 09 11 80       	mov    0x801109f8,%eax
80101536:	c7 04 24 64 6f 10 80 	movl   $0x80106f64,(%esp)
8010153d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101541:	a1 f4 09 11 80       	mov    0x801109f4,%eax
80101546:	89 44 24 18          	mov    %eax,0x18(%esp)
8010154a:	a1 f0 09 11 80       	mov    0x801109f0,%eax
8010154f:	89 44 24 14          	mov    %eax,0x14(%esp)
80101553:	a1 ec 09 11 80       	mov    0x801109ec,%eax
80101558:	89 44 24 10          	mov    %eax,0x10(%esp)
8010155c:	a1 e8 09 11 80       	mov    0x801109e8,%eax
80101561:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101565:	a1 e4 09 11 80       	mov    0x801109e4,%eax
8010156a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010156e:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101573:	89 44 24 04          	mov    %eax,0x4(%esp)
80101577:	e8 d4 f0 ff ff       	call   80100650 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010157c:	83 c4 24             	add    $0x24,%esp
8010157f:	5b                   	pop    %ebx
80101580:	5d                   	pop    %ebp
80101581:	c3                   	ret    
80101582:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101590 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101590:	55                   	push   %ebp
80101591:	89 e5                	mov    %esp,%ebp
80101593:	57                   	push   %edi
80101594:	56                   	push   %esi
80101595:	53                   	push   %ebx
80101596:	83 ec 2c             	sub    $0x2c,%esp
80101599:	8b 45 0c             	mov    0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010159c:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015a3:	8b 7d 08             	mov    0x8(%ebp),%edi
801015a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801015a9:	0f 86 a2 00 00 00    	jbe    80101651 <ialloc+0xc1>
801015af:	be 01 00 00 00       	mov    $0x1,%esi
801015b4:	bb 01 00 00 00       	mov    $0x1,%ebx
801015b9:	eb 1a                	jmp    801015d5 <ialloc+0x45>
801015bb:	90                   	nop
801015bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801015c0:	89 14 24             	mov    %edx,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801015c3:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801015c6:	e8 15 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801015cb:	89 de                	mov    %ebx,%esi
801015cd:	3b 1d e8 09 11 80    	cmp    0x801109e8,%ebx
801015d3:	73 7c                	jae    80101651 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
801015d5:	89 f0                	mov    %esi,%eax
801015d7:	c1 e8 03             	shr    $0x3,%eax
801015da:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801015e0:	89 3c 24             	mov    %edi,(%esp)
801015e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801015e7:	e8 e4 ea ff ff       	call   801000d0 <bread>
801015ec:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
801015ee:	89 f0                	mov    %esi,%eax
801015f0:	83 e0 07             	and    $0x7,%eax
801015f3:	c1 e0 06             	shl    $0x6,%eax
801015f6:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015fa:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015fe:	75 c0                	jne    801015c0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101600:	89 0c 24             	mov    %ecx,(%esp)
80101603:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010160a:	00 
8010160b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101612:	00 
80101613:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101616:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101619:	e8 b2 2d 00 00       	call   801043d0 <memset>
      dip->type = type;
8010161e:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
80101622:	8b 55 dc             	mov    -0x24(%ebp),%edx
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
80101625:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
80101628:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
8010162b:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010162e:	89 14 24             	mov    %edx,(%esp)
80101631:	e8 5a 17 00 00       	call   80102d90 <log_write>
      brelse(bp);
80101636:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101639:	89 14 24             	mov    %edx,(%esp)
8010163c:	e8 9f eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101641:	83 c4 2c             	add    $0x2c,%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101644:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101646:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101647:	89 f8                	mov    %edi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101649:	5e                   	pop    %esi
8010164a:	5f                   	pop    %edi
8010164b:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010164c:	e9 2f fc ff ff       	jmp    80101280 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101651:	c7 04 24 14 6f 10 80 	movl   $0x80106f14,(%esp)
80101658:	e8 03 ed ff ff       	call   80100360 <panic>
8010165d:	8d 76 00             	lea    0x0(%esi),%esi

80101660 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	56                   	push   %esi
80101664:	53                   	push   %ebx
80101665:	83 ec 10             	sub    $0x10,%esp
80101668:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010166b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010166e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101671:	c1 e8 03             	shr    $0x3,%eax
80101674:	03 05 f4 09 11 80    	add    0x801109f4,%eax
8010167a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010167e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101681:	89 04 24             	mov    %eax,(%esp)
80101684:	e8 47 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101689:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010168c:	83 e2 07             	and    $0x7,%edx
8010168f:	c1 e2 06             	shl    $0x6,%edx
80101692:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101696:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
80101698:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010169c:	83 c2 0c             	add    $0xc,%edx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
8010169f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
801016a3:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
801016a7:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
801016ab:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
801016af:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
801016b3:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
801016b7:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
801016bb:	8b 43 fc             	mov    -0x4(%ebx),%eax
801016be:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016c1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801016c5:	89 14 24             	mov    %edx,(%esp)
801016c8:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801016cf:	00 
801016d0:	e8 9b 2d 00 00       	call   80104470 <memmove>
  log_write(bp);
801016d5:	89 34 24             	mov    %esi,(%esp)
801016d8:	e8 b3 16 00 00       	call   80102d90 <log_write>
  brelse(bp);
801016dd:	89 75 08             	mov    %esi,0x8(%ebp)
}
801016e0:	83 c4 10             	add    $0x10,%esp
801016e3:	5b                   	pop    %ebx
801016e4:	5e                   	pop    %esi
801016e5:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
801016e6:	e9 f5 ea ff ff       	jmp    801001e0 <brelse>
801016eb:	90                   	nop
801016ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016f0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	53                   	push   %ebx
801016f4:	83 ec 14             	sub    $0x14,%esp
801016f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016fa:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101701:	e8 4a 2b 00 00       	call   80104250 <acquire>
  ip->ref++;
80101706:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010170a:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101711:	e8 6a 2c 00 00       	call   80104380 <release>
  return ip;
}
80101716:	83 c4 14             	add    $0x14,%esp
80101719:	89 d8                	mov    %ebx,%eax
8010171b:	5b                   	pop    %ebx
8010171c:	5d                   	pop    %ebp
8010171d:	c3                   	ret    
8010171e:	66 90                	xchg   %ax,%ax

80101720 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	56                   	push   %esi
80101724:	53                   	push   %ebx
80101725:	83 ec 10             	sub    $0x10,%esp
80101728:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
8010172b:	85 db                	test   %ebx,%ebx
8010172d:	0f 84 b0 00 00 00    	je     801017e3 <ilock+0xc3>
80101733:	8b 43 08             	mov    0x8(%ebx),%eax
80101736:	85 c0                	test   %eax,%eax
80101738:	0f 8e a5 00 00 00    	jle    801017e3 <ilock+0xc3>
    panic("ilock");

  acquiresleep(&ip->lock);
8010173e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101741:	89 04 24             	mov    %eax,(%esp)
80101744:	e8 b7 29 00 00       	call   80104100 <acquiresleep>

  if(!(ip->flags & I_VALID)){
80101749:	f6 43 4c 02          	testb  $0x2,0x4c(%ebx)
8010174d:	74 09                	je     80101758 <ilock+0x38>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
8010174f:	83 c4 10             	add    $0x10,%esp
80101752:	5b                   	pop    %ebx
80101753:	5e                   	pop    %esi
80101754:	5d                   	pop    %ebp
80101755:	c3                   	ret    
80101756:	66 90                	xchg   %ax,%ax
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101758:	8b 43 04             	mov    0x4(%ebx),%eax
8010175b:	c1 e8 03             	shr    $0x3,%eax
8010175e:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101764:	89 44 24 04          	mov    %eax,0x4(%esp)
80101768:	8b 03                	mov    (%ebx),%eax
8010176a:	89 04 24             	mov    %eax,(%esp)
8010176d:	e8 5e e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101772:	8b 53 04             	mov    0x4(%ebx),%edx
80101775:	83 e2 07             	and    $0x7,%edx
80101778:	c1 e2 06             	shl    $0x6,%edx
8010177b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010177f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101781:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101784:	83 c2 0c             	add    $0xc,%edx
  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101787:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010178b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010178f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101793:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101797:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010179b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010179f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
801017a3:	8b 42 fc             	mov    -0x4(%edx),%eax
801017a6:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017a9:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017ac:	89 54 24 04          	mov    %edx,0x4(%esp)
801017b0:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801017b7:	00 
801017b8:	89 04 24             	mov    %eax,(%esp)
801017bb:	e8 b0 2c 00 00       	call   80104470 <memmove>
    brelse(bp);
801017c0:	89 34 24             	mov    %esi,(%esp)
801017c3:	e8 18 ea ff ff       	call   801001e0 <brelse>
    ip->flags |= I_VALID;
801017c8:	83 4b 4c 02          	orl    $0x2,0x4c(%ebx)
    if(ip->type == 0)
801017cc:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
801017d1:	0f 85 78 ff ff ff    	jne    8010174f <ilock+0x2f>
      panic("ilock: no type");
801017d7:	c7 04 24 2c 6f 10 80 	movl   $0x80106f2c,(%esp)
801017de:	e8 7d eb ff ff       	call   80100360 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
801017e3:	c7 04 24 26 6f 10 80 	movl   $0x80106f26,(%esp)
801017ea:	e8 71 eb ff ff       	call   80100360 <panic>
801017ef:	90                   	nop

801017f0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	56                   	push   %esi
801017f4:	53                   	push   %ebx
801017f5:	83 ec 10             	sub    $0x10,%esp
801017f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017fb:	85 db                	test   %ebx,%ebx
801017fd:	74 24                	je     80101823 <iunlock+0x33>
801017ff:	8d 73 0c             	lea    0xc(%ebx),%esi
80101802:	89 34 24             	mov    %esi,(%esp)
80101805:	e8 96 29 00 00       	call   801041a0 <holdingsleep>
8010180a:	85 c0                	test   %eax,%eax
8010180c:	74 15                	je     80101823 <iunlock+0x33>
8010180e:	8b 43 08             	mov    0x8(%ebx),%eax
80101811:	85 c0                	test   %eax,%eax
80101813:	7e 0e                	jle    80101823 <iunlock+0x33>
    panic("iunlock");

  releasesleep(&ip->lock);
80101815:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101818:	83 c4 10             	add    $0x10,%esp
8010181b:	5b                   	pop    %ebx
8010181c:	5e                   	pop    %esi
8010181d:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010181e:	e9 3d 29 00 00       	jmp    80104160 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101823:	c7 04 24 3b 6f 10 80 	movl   $0x80106f3b,(%esp)
8010182a:	e8 31 eb ff ff       	call   80100360 <panic>
8010182f:	90                   	nop

80101830 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101830:	55                   	push   %ebp
80101831:	89 e5                	mov    %esp,%ebp
80101833:	57                   	push   %edi
80101834:	56                   	push   %esi
80101835:	53                   	push   %ebx
80101836:	83 ec 1c             	sub    $0x1c,%esp
80101839:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
8010183c:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101843:	e8 08 2a 00 00       	call   80104250 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101848:	8b 46 08             	mov    0x8(%esi),%eax
8010184b:	83 f8 01             	cmp    $0x1,%eax
8010184e:	74 20                	je     80101870 <iput+0x40>
    ip->type = 0;
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
80101850:	83 e8 01             	sub    $0x1,%eax
80101853:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
80101856:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
8010185d:	83 c4 1c             	add    $0x1c,%esp
80101860:	5b                   	pop    %ebx
80101861:	5e                   	pop    %esi
80101862:	5f                   	pop    %edi
80101863:	5d                   	pop    %ebp
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
  release(&icache.lock);
80101864:	e9 17 2b 00 00       	jmp    80104380 <release>
80101869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
// case it has to free the inode.
void
iput(struct inode *ip)
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101870:	f6 46 4c 02          	testb  $0x2,0x4c(%esi)
80101874:	74 da                	je     80101850 <iput+0x20>
80101876:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
8010187b:	75 d3                	jne    80101850 <iput+0x20>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
8010187d:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101884:	89 f3                	mov    %esi,%ebx
80101886:	e8 f5 2a 00 00       	call   80104380 <release>
8010188b:	8d 7e 30             	lea    0x30(%esi),%edi
8010188e:	eb 07                	jmp    80101897 <iput+0x67>
80101890:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101893:	39 fb                	cmp    %edi,%ebx
80101895:	74 19                	je     801018b0 <iput+0x80>
    if(ip->addrs[i]){
80101897:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010189a:	85 d2                	test   %edx,%edx
8010189c:	74 f2                	je     80101890 <iput+0x60>
      bfree(ip->dev, ip->addrs[i]);
8010189e:	8b 06                	mov    (%esi),%eax
801018a0:	e8 ab fb ff ff       	call   80101450 <bfree>
      ip->addrs[i] = 0;
801018a5:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
801018ac:	eb e2                	jmp    80101890 <iput+0x60>
801018ae:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
801018b0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801018b6:	85 c0                	test   %eax,%eax
801018b8:	75 3e                	jne    801018f8 <iput+0xc8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801018ba:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801018c1:	89 34 24             	mov    %esi,(%esp)
801018c4:	e8 97 fd ff ff       	call   80101660 <iupdate>
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
801018c9:	31 c0                	xor    %eax,%eax
801018cb:	66 89 46 50          	mov    %ax,0x50(%esi)
    iupdate(ip);
801018cf:	89 34 24             	mov    %esi,(%esp)
801018d2:	e8 89 fd ff ff       	call   80101660 <iupdate>
    acquire(&icache.lock);
801018d7:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801018de:	e8 6d 29 00 00       	call   80104250 <acquire>
801018e3:	8b 46 08             	mov    0x8(%esi),%eax
    ip->flags = 0;
801018e6:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018ed:	e9 5e ff ff ff       	jmp    80101850 <iput+0x20>
801018f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018fc:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018fe:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101900:	89 04 24             	mov    %eax,(%esp)
80101903:	e8 c8 e7 ff ff       	call   801000d0 <bread>
80101908:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
8010190b:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
8010190e:	31 c0                	xor    %eax,%eax
80101910:	eb 13                	jmp    80101925 <iput+0xf5>
80101912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101918:	83 c3 01             	add    $0x1,%ebx
8010191b:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80101921:	89 d8                	mov    %ebx,%eax
80101923:	74 10                	je     80101935 <iput+0x105>
      if(a[j])
80101925:	8b 14 87             	mov    (%edi,%eax,4),%edx
80101928:	85 d2                	test   %edx,%edx
8010192a:	74 ec                	je     80101918 <iput+0xe8>
        bfree(ip->dev, a[j]);
8010192c:	8b 06                	mov    (%esi),%eax
8010192e:	e8 1d fb ff ff       	call   80101450 <bfree>
80101933:	eb e3                	jmp    80101918 <iput+0xe8>
    }
    brelse(bp);
80101935:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101938:	89 04 24             	mov    %eax,(%esp)
8010193b:	e8 a0 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101940:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101946:	8b 06                	mov    (%esi),%eax
80101948:	e8 03 fb ff ff       	call   80101450 <bfree>
    ip->addrs[NDIRECT] = 0;
8010194d:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101954:	00 00 00 
80101957:	e9 5e ff ff ff       	jmp    801018ba <iput+0x8a>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	53                   	push   %ebx
80101964:	83 ec 14             	sub    $0x14,%esp
80101967:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010196a:	89 1c 24             	mov    %ebx,(%esp)
8010196d:	e8 7e fe ff ff       	call   801017f0 <iunlock>
  iput(ip);
80101972:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101975:	83 c4 14             	add    $0x14,%esp
80101978:	5b                   	pop    %ebx
80101979:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010197a:	e9 b1 fe ff ff       	jmp    80101830 <iput>
8010197f:	90                   	nop

80101980 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	8b 55 08             	mov    0x8(%ebp),%edx
80101986:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101989:	8b 0a                	mov    (%edx),%ecx
8010198b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010198e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101991:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101994:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101998:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010199b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010199f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019a3:	8b 52 58             	mov    0x58(%edx),%edx
801019a6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019a9:	5d                   	pop    %ebp
801019aa:	c3                   	ret    
801019ab:	90                   	nop
801019ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019b0 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	57                   	push   %edi
801019b4:	56                   	push   %esi
801019b5:	53                   	push   %ebx
801019b6:	83 ec 2c             	sub    $0x2c,%esp
801019b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801019bc:	8b 7d 08             	mov    0x8(%ebp),%edi
801019bf:	8b 75 10             	mov    0x10(%ebp),%esi
801019c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019c5:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019c8:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019d0:	0f 84 aa 00 00 00    	je     80101a80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019d6:	8b 47 58             	mov    0x58(%edi),%eax
801019d9:	39 f0                	cmp    %esi,%eax
801019db:	0f 82 c7 00 00 00    	jb     80101aa8 <readi+0xf8>
801019e1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019e4:	89 da                	mov    %ebx,%edx
801019e6:	01 f2                	add    %esi,%edx
801019e8:	0f 82 ba 00 00 00    	jb     80101aa8 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019ee:	89 c1                	mov    %eax,%ecx
801019f0:	29 f1                	sub    %esi,%ecx
801019f2:	39 d0                	cmp    %edx,%eax
801019f4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f7:	31 c0                	xor    %eax,%eax
801019f9:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019fb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019fe:	74 70                	je     80101a70 <readi+0xc0>
80101a00:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101a03:	89 c7                	mov    %eax,%edi
80101a05:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a08:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a0b:	89 f2                	mov    %esi,%edx
80101a0d:	c1 ea 09             	shr    $0x9,%edx
80101a10:	89 d8                	mov    %ebx,%eax
80101a12:	e8 29 f9 ff ff       	call   80101340 <bmap>
80101a17:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a1b:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a1d:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a22:	89 04 24             	mov    %eax,(%esp)
80101a25:	e8 a6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a2a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101a2d:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a2f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a31:	89 f0                	mov    %esi,%eax
80101a33:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a38:	29 c3                	sub    %eax,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101a3a:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a3e:	39 cb                	cmp    %ecx,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101a40:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a47:	0f 47 d9             	cmova  %ecx,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101a4a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a4e:	01 df                	add    %ebx,%edi
80101a50:	01 de                	add    %ebx,%esi
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101a52:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a55:	89 04 24             	mov    %eax,(%esp)
80101a58:	e8 13 2a 00 00       	call   80104470 <memmove>
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
80101a6b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a6e:	77 98                	ja     80101a08 <readi+0x58>
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a73:	83 c4 2c             	add    $0x2c,%esp
80101a76:	5b                   	pop    %ebx
80101a77:	5e                   	pop    %esi
80101a78:	5f                   	pop    %edi
80101a79:	5d                   	pop    %ebp
80101a7a:	c3                   	ret    
80101a7b:	90                   	nop
80101a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a80:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a84:	66 83 f8 09          	cmp    $0x9,%ax
80101a88:	77 1e                	ja     80101aa8 <readi+0xf8>
80101a8a:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
80101a91:	85 c0                	test   %eax,%eax
80101a93:	74 13                	je     80101aa8 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a95:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a98:	89 75 10             	mov    %esi,0x10(%ebp)
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a9b:	83 c4 2c             	add    $0x2c,%esp
80101a9e:	5b                   	pop    %ebx
80101a9f:	5e                   	pop    %esi
80101aa0:	5f                   	pop    %edi
80101aa1:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101aa2:	ff e0                	jmp    *%eax
80101aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101aa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101aad:	eb c4                	jmp    80101a73 <readi+0xc3>
80101aaf:	90                   	nop

80101ab0 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	57                   	push   %edi
80101ab4:	56                   	push   %esi
80101ab5:	53                   	push   %ebx
80101ab6:	83 ec 2c             	sub    $0x2c,%esp
80101ab9:	8b 45 08             	mov    0x8(%ebp),%eax
80101abc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101abf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ac2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ac7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aca:	8b 75 10             	mov    0x10(%ebp),%esi
80101acd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ad0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
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
80101adf:	0f 82 e3 00 00 00    	jb     80101bc8 <writei+0x118>
80101ae5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ae8:	89 c8                	mov    %ecx,%eax
80101aea:	01 f0                	add    %esi,%eax
80101aec:	0f 82 d6 00 00 00    	jb     80101bc8 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101af2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101af7:	0f 87 cb 00 00 00    	ja     80101bc8 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101afd:	85 c9                	test   %ecx,%ecx
80101aff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b06:	74 77                	je     80101b7f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b08:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b0b:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0d:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	c1 ea 09             	shr    $0x9,%edx
80101b15:	89 f8                	mov    %edi,%eax
80101b17:	e8 24 f8 ff ff       	call   80101340 <bmap>
80101b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b20:	8b 07                	mov    (%edi),%eax
80101b22:	89 04 24             	mov    %eax,(%esp)
80101b25:	e8 a6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b2a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b2d:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b30:	8b 55 dc             	mov    -0x24(%ebp),%edx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b33:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b35:	89 f0                	mov    %esi,%eax
80101b37:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b3c:	29 c3                	sub    %eax,%ebx
80101b3e:	39 cb                	cmp    %ecx,%ebx
80101b40:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b43:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b47:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101b49:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b4d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b51:	89 04 24             	mov    %eax,(%esp)
80101b54:	e8 17 29 00 00       	call   80104470 <memmove>
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
80101b6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b6f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b72:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b75:	77 91                	ja     80101b08 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b77:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b7a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b7d:	72 39                	jb     80101bb8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b82:	83 c4 2c             	add    $0x2c,%esp
80101b85:	5b                   	pop    %ebx
80101b86:	5e                   	pop    %esi
80101b87:	5f                   	pop    %edi
80101b88:	5d                   	pop    %ebp
80101b89:	c3                   	ret    
80101b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b94:	66 83 f8 09          	cmp    $0x9,%ax
80101b98:	77 2e                	ja     80101bc8 <writei+0x118>
80101b9a:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101ba1:	85 c0                	test   %eax,%eax
80101ba3:	74 23                	je     80101bc8 <writei+0x118>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101ba5:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101ba8:	83 c4 2c             	add    $0x2c,%esp
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
80101bbb:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101bbe:	89 04 24             	mov    %eax,(%esp)
80101bc1:	e8 9a fa ff ff       	call   80101660 <iupdate>
80101bc6:	eb b7                	jmp    80101b7f <writei+0xcf>
  }
  return n;
}
80101bc8:	83 c4 2c             	add    $0x2c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101bcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101bd0:	5b                   	pop    %ebx
80101bd1:	5e                   	pop    %esi
80101bd2:	5f                   	pop    %edi
80101bd3:	5d                   	pop    %ebp
80101bd4:	c3                   	ret    
80101bd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101be0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101be6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101be9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101bf0:	00 
80101bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bf5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf8:	89 04 24             	mov    %eax,(%esp)
80101bfb:	e8 f0 28 00 00       	call   801044f0 <strncmp>
}
80101c00:	c9                   	leave  
80101c01:	c3                   	ret    
80101c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c10 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c10:	55                   	push   %ebp
80101c11:	89 e5                	mov    %esp,%ebp
80101c13:	57                   	push   %edi
80101c14:	56                   	push   %esi
80101c15:	53                   	push   %ebx
80101c16:	83 ec 2c             	sub    $0x2c,%esp
80101c19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c1c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c21:	0f 85 97 00 00 00    	jne    80101cbe <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c27:	8b 53 58             	mov    0x58(%ebx),%edx
80101c2a:	31 ff                	xor    %edi,%edi
80101c2c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c2f:	85 d2                	test   %edx,%edx
80101c31:	75 0d                	jne    80101c40 <dirlookup+0x30>
80101c33:	eb 73                	jmp    80101ca8 <dirlookup+0x98>
80101c35:	8d 76 00             	lea    0x0(%esi),%esi
80101c38:	83 c7 10             	add    $0x10,%edi
80101c3b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101c3e:	76 68                	jbe    80101ca8 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c40:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c47:	00 
80101c48:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c4c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c50:	89 1c 24             	mov    %ebx,(%esp)
80101c53:	e8 58 fd ff ff       	call   801019b0 <readi>
80101c58:	83 f8 10             	cmp    $0x10,%eax
80101c5b:	75 55                	jne    80101cb2 <dirlookup+0xa2>
      panic("dirlink read");
    if(de.inum == 0)
80101c5d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c62:	74 d4                	je     80101c38 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c64:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c67:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c6e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c75:	00 
80101c76:	89 04 24             	mov    %eax,(%esp)
80101c79:	e8 72 28 00 00       	call   801044f0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c7e:	85 c0                	test   %eax,%eax
80101c80:	75 b6                	jne    80101c38 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c82:	8b 45 10             	mov    0x10(%ebp),%eax
80101c85:	85 c0                	test   %eax,%eax
80101c87:	74 05                	je     80101c8e <dirlookup+0x7e>
        *poff = off;
80101c89:	8b 45 10             	mov    0x10(%ebp),%eax
80101c8c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c8e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c92:	8b 03                	mov    (%ebx),%eax
80101c94:	e8 e7 f5 ff ff       	call   80101280 <iget>
    }
  }

  return 0;
}
80101c99:	83 c4 2c             	add    $0x2c,%esp
80101c9c:	5b                   	pop    %ebx
80101c9d:	5e                   	pop    %esi
80101c9e:	5f                   	pop    %edi
80101c9f:	5d                   	pop    %ebp
80101ca0:	c3                   	ret    
80101ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ca8:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101cab:	31 c0                	xor    %eax,%eax
}
80101cad:	5b                   	pop    %ebx
80101cae:	5e                   	pop    %esi
80101caf:	5f                   	pop    %edi
80101cb0:	5d                   	pop    %ebp
80101cb1:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101cb2:	c7 04 24 55 6f 10 80 	movl   $0x80106f55,(%esp)
80101cb9:	e8 a2 e6 ff ff       	call   80100360 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101cbe:	c7 04 24 43 6f 10 80 	movl   $0x80106f43,(%esp)
80101cc5:	e8 96 e6 ff ff       	call   80100360 <panic>
80101cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cd0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	57                   	push   %edi
80101cd4:	89 cf                	mov    %ecx,%edi
80101cd6:	56                   	push   %esi
80101cd7:	53                   	push   %ebx
80101cd8:	89 c3                	mov    %eax,%ebx
80101cda:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cdd:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ce0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101ce3:	0f 84 51 01 00 00    	je     80101e3a <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101ce9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101cef:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101cf2:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101cf9:	e8 52 25 00 00       	call   80104250 <acquire>
  ip->ref++;
80101cfe:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d02:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101d09:	e8 72 26 00 00       	call   80104380 <release>
80101d0e:	eb 03                	jmp    80101d13 <namex+0x43>
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101d10:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101d13:	0f b6 03             	movzbl (%ebx),%eax
80101d16:	3c 2f                	cmp    $0x2f,%al
80101d18:	74 f6                	je     80101d10 <namex+0x40>
    path++;
  if(*path == 0)
80101d1a:	84 c0                	test   %al,%al
80101d1c:	0f 84 ed 00 00 00    	je     80101e0f <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d22:	0f b6 03             	movzbl (%ebx),%eax
80101d25:	89 da                	mov    %ebx,%edx
80101d27:	84 c0                	test   %al,%al
80101d29:	0f 84 b1 00 00 00    	je     80101de0 <namex+0x110>
80101d2f:	3c 2f                	cmp    $0x2f,%al
80101d31:	75 0f                	jne    80101d42 <namex+0x72>
80101d33:	e9 a8 00 00 00       	jmp    80101de0 <namex+0x110>
80101d38:	3c 2f                	cmp    $0x2f,%al
80101d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d40:	74 0a                	je     80101d4c <namex+0x7c>
    path++;
80101d42:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d45:	0f b6 02             	movzbl (%edx),%eax
80101d48:	84 c0                	test   %al,%al
80101d4a:	75 ec                	jne    80101d38 <namex+0x68>
80101d4c:	89 d1                	mov    %edx,%ecx
80101d4e:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101d50:	83 f9 0d             	cmp    $0xd,%ecx
80101d53:	0f 8e 8f 00 00 00    	jle    80101de8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d59:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d5d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d64:	00 
80101d65:	89 3c 24             	mov    %edi,(%esp)
80101d68:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d6b:	e8 00 27 00 00       	call   80104470 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d73:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d75:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d78:	75 0e                	jne    80101d88 <namex+0xb8>
80101d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d80:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d83:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d86:	74 f8                	je     80101d80 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d88:	89 34 24             	mov    %esi,(%esp)
80101d8b:	e8 90 f9 ff ff       	call   80101720 <ilock>
    if(ip->type != T_DIR){
80101d90:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d95:	0f 85 85 00 00 00    	jne    80101e20 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d9b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d9e:	85 d2                	test   %edx,%edx
80101da0:	74 09                	je     80101dab <namex+0xdb>
80101da2:	80 3b 00             	cmpb   $0x0,(%ebx)
80101da5:	0f 84 a5 00 00 00    	je     80101e50 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101dab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101db2:	00 
80101db3:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101db7:	89 34 24             	mov    %esi,(%esp)
80101dba:	e8 51 fe ff ff       	call   80101c10 <dirlookup>
80101dbf:	85 c0                	test   %eax,%eax
80101dc1:	74 5d                	je     80101e20 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101dc3:	89 34 24             	mov    %esi,(%esp)
80101dc6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101dc9:	e8 22 fa ff ff       	call   801017f0 <iunlock>
  iput(ip);
80101dce:	89 34 24             	mov    %esi,(%esp)
80101dd1:	e8 5a fa ff ff       	call   80101830 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101dd9:	89 c6                	mov    %eax,%esi
80101ddb:	e9 33 ff ff ff       	jmp    80101d13 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101de0:	31 c9                	xor    %ecx,%ecx
80101de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101de8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101dec:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101df0:	89 3c 24             	mov    %edi,(%esp)
80101df3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101df6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101df9:	e8 72 26 00 00       	call   80104470 <memmove>
    name[len] = 0;
80101dfe:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e01:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e04:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e08:	89 d3                	mov    %edx,%ebx
80101e0a:	e9 66 ff ff ff       	jmp    80101d75 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e12:	85 c0                	test   %eax,%eax
80101e14:	75 4c                	jne    80101e62 <namex+0x192>
80101e16:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101e18:	83 c4 2c             	add    $0x2c,%esp
80101e1b:	5b                   	pop    %ebx
80101e1c:	5e                   	pop    %esi
80101e1d:	5f                   	pop    %edi
80101e1e:	5d                   	pop    %ebp
80101e1f:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101e20:	89 34 24             	mov    %esi,(%esp)
80101e23:	e8 c8 f9 ff ff       	call   801017f0 <iunlock>
  iput(ip);
80101e28:	89 34 24             	mov    %esi,(%esp)
80101e2b:	e8 00 fa ff ff       	call   80101830 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e30:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101e33:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e35:	5b                   	pop    %ebx
80101e36:	5e                   	pop    %esi
80101e37:	5f                   	pop    %edi
80101e38:	5d                   	pop    %ebp
80101e39:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101e3a:	ba 01 00 00 00       	mov    $0x1,%edx
80101e3f:	b8 01 00 00 00       	mov    $0x1,%eax
80101e44:	e8 37 f4 ff ff       	call   80101280 <iget>
80101e49:	89 c6                	mov    %eax,%esi
80101e4b:	e9 c3 fe ff ff       	jmp    80101d13 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e50:	89 34 24             	mov    %esi,(%esp)
80101e53:	e8 98 f9 ff ff       	call   801017f0 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e58:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101e5b:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e5d:	5b                   	pop    %ebx
80101e5e:	5e                   	pop    %esi
80101e5f:	5f                   	pop    %edi
80101e60:	5d                   	pop    %ebp
80101e61:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e62:	89 34 24             	mov    %esi,(%esp)
80101e65:	e8 c6 f9 ff ff       	call   80101830 <iput>
    return 0;
80101e6a:	31 c0                	xor    %eax,%eax
80101e6c:	eb aa                	jmp    80101e18 <namex+0x148>
80101e6e:	66 90                	xchg   %ax,%ax

80101e70 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e70:	55                   	push   %ebp
80101e71:	89 e5                	mov    %esp,%ebp
80101e73:	57                   	push   %edi
80101e74:	56                   	push   %esi
80101e75:	53                   	push   %ebx
80101e76:	83 ec 2c             	sub    $0x2c,%esp
80101e79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e7f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e86:	00 
80101e87:	89 1c 24             	mov    %ebx,(%esp)
80101e8a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e8e:	e8 7d fd ff ff       	call   80101c10 <dirlookup>
80101e93:	85 c0                	test   %eax,%eax
80101e95:	0f 85 8b 00 00 00    	jne    80101f26 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e9b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e9e:	31 ff                	xor    %edi,%edi
80101ea0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ea3:	85 c0                	test   %eax,%eax
80101ea5:	75 13                	jne    80101eba <dirlink+0x4a>
80101ea7:	eb 35                	jmp    80101ede <dirlink+0x6e>
80101ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eb0:	8d 57 10             	lea    0x10(%edi),%edx
80101eb3:	39 53 58             	cmp    %edx,0x58(%ebx)
80101eb6:	89 d7                	mov    %edx,%edi
80101eb8:	76 24                	jbe    80101ede <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eba:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ec1:	00 
80101ec2:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ec6:	89 74 24 04          	mov    %esi,0x4(%esp)
80101eca:	89 1c 24             	mov    %ebx,(%esp)
80101ecd:	e8 de fa ff ff       	call   801019b0 <readi>
80101ed2:	83 f8 10             	cmp    $0x10,%eax
80101ed5:	75 5e                	jne    80101f35 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80101ed7:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101edc:	75 d2                	jne    80101eb0 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101ede:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ee1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ee8:	00 
80101ee9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101eed:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ef0:	89 04 24             	mov    %eax,(%esp)
80101ef3:	e8 68 26 00 00       	call   80104560 <strncpy>
  de.inum = inum;
80101ef8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101efb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101f02:	00 
80101f03:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101f07:	89 74 24 04          	mov    %esi,0x4(%esp)
80101f0b:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101f0e:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f12:	e8 99 fb ff ff       	call   80101ab0 <writei>
80101f17:	83 f8 10             	cmp    $0x10,%eax
80101f1a:	75 25                	jne    80101f41 <dirlink+0xd1>
    panic("dirlink");

  return 0;
80101f1c:	31 c0                	xor    %eax,%eax
}
80101f1e:	83 c4 2c             	add    $0x2c,%esp
80101f21:	5b                   	pop    %ebx
80101f22:	5e                   	pop    %esi
80101f23:	5f                   	pop    %edi
80101f24:	5d                   	pop    %ebp
80101f25:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101f26:	89 04 24             	mov    %eax,(%esp)
80101f29:	e8 02 f9 ff ff       	call   80101830 <iput>
    return -1;
80101f2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f33:	eb e9                	jmp    80101f1e <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101f35:	c7 04 24 55 6f 10 80 	movl   $0x80106f55,(%esp)
80101f3c:	e8 1f e4 ff ff       	call   80100360 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101f41:	c7 04 24 1e 75 10 80 	movl   $0x8010751e,(%esp)
80101f48:	e8 13 e4 ff ff       	call   80100360 <panic>
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi

80101f50 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101f50:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f51:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101f53:	89 e5                	mov    %esp,%ebp
80101f55:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f58:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f5e:	e8 6d fd ff ff       	call   80101cd0 <namex>
}
80101f63:	c9                   	leave  
80101f64:	c3                   	ret    
80101f65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f70 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f70:	55                   	push   %ebp
  return namex(path, 1, name);
80101f71:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f76:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f7b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f7e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f7f:	e9 4c fd ff ff       	jmp    80101cd0 <namex>
80101f84:	66 90                	xchg   %ax,%ax
80101f86:	66 90                	xchg   %ax,%ax
80101f88:	66 90                	xchg   %ax,%ax
80101f8a:	66 90                	xchg   %ax,%ax
80101f8c:	66 90                	xchg   %ax,%ax
80101f8e:	66 90                	xchg   %ax,%ax

80101f90 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f90:	55                   	push   %ebp
80101f91:	89 e5                	mov    %esp,%ebp
80101f93:	56                   	push   %esi
80101f94:	89 c6                	mov    %eax,%esi
80101f96:	53                   	push   %ebx
80101f97:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f9a:	85 c0                	test   %eax,%eax
80101f9c:	0f 84 99 00 00 00    	je     8010203b <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101fa2:	8b 48 08             	mov    0x8(%eax),%ecx
80101fa5:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101fab:	0f 87 7e 00 00 00    	ja     8010202f <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fb1:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fb6:	66 90                	xchg   %ax,%ax
80101fb8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fb9:	83 e0 c0             	and    $0xffffffc0,%eax
80101fbc:	3c 40                	cmp    $0x40,%al
80101fbe:	75 f8                	jne    80101fb8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fc0:	31 db                	xor    %ebx,%ebx
80101fc2:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101fc7:	89 d8                	mov    %ebx,%eax
80101fc9:	ee                   	out    %al,(%dx)
80101fca:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101fcf:	b8 01 00 00 00       	mov    $0x1,%eax
80101fd4:	ee                   	out    %al,(%dx)
80101fd5:	0f b6 c1             	movzbl %cl,%eax
80101fd8:	b2 f3                	mov    $0xf3,%dl
80101fda:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101fdb:	89 c8                	mov    %ecx,%eax
80101fdd:	b2 f4                	mov    $0xf4,%dl
80101fdf:	c1 f8 08             	sar    $0x8,%eax
80101fe2:	ee                   	out    %al,(%dx)
80101fe3:	b2 f5                	mov    $0xf5,%dl
80101fe5:	89 d8                	mov    %ebx,%eax
80101fe7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fe8:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fec:	b2 f6                	mov    $0xf6,%dl
80101fee:	83 e0 01             	and    $0x1,%eax
80101ff1:	c1 e0 04             	shl    $0x4,%eax
80101ff4:	83 c8 e0             	or     $0xffffffe0,%eax
80101ff7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101ff8:	f6 06 04             	testb  $0x4,(%esi)
80101ffb:	75 13                	jne    80102010 <idestart+0x80>
80101ffd:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102002:	b8 20 00 00 00       	mov    $0x20,%eax
80102007:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102008:	83 c4 10             	add    $0x10,%esp
8010200b:	5b                   	pop    %ebx
8010200c:	5e                   	pop    %esi
8010200d:	5d                   	pop    %ebp
8010200e:	c3                   	ret    
8010200f:	90                   	nop
80102010:	b2 f7                	mov    $0xf7,%dl
80102012:	b8 30 00 00 00       	mov    $0x30,%eax
80102017:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102018:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
8010201d:	83 c6 5c             	add    $0x5c,%esi
80102020:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102025:	fc                   	cld    
80102026:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102028:	83 c4 10             	add    $0x10,%esp
8010202b:	5b                   	pop    %ebx
8010202c:	5e                   	pop    %esi
8010202d:	5d                   	pop    %ebp
8010202e:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010202f:	c7 04 24 c0 6f 10 80 	movl   $0x80106fc0,(%esp)
80102036:	e8 25 e3 ff ff       	call   80100360 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010203b:	c7 04 24 b7 6f 10 80 	movl   $0x80106fb7,(%esp)
80102042:	e8 19 e3 ff ff       	call   80100360 <panic>
80102047:	89 f6                	mov    %esi,%esi
80102049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102050 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102056:	c7 44 24 04 d2 6f 10 	movl   $0x80106fd2,0x4(%esp)
8010205d:	80 
8010205e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102065:	e8 66 21 00 00       	call   801041d0 <initlock>
  picenable(IRQ_IDE);
8010206a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102071:	e8 ea 11 00 00       	call   80103260 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102076:	a1 80 2d 11 80       	mov    0x80112d80,%eax
8010207b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102082:	83 e8 01             	sub    $0x1,%eax
80102085:	89 44 24 04          	mov    %eax,0x4(%esp)
80102089:	e8 82 02 00 00       	call   80102310 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010208e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102093:	90                   	nop
80102094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102098:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102099:	83 e0 c0             	and    $0xffffffc0,%eax
8010209c:	3c 40                	cmp    $0x40,%al
8010209e:	75 f8                	jne    80102098 <ideinit+0x48>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020a0:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020a5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801020aa:	ee                   	out    %al,(%dx)
801020ab:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b0:	b2 f7                	mov    $0xf7,%dl
801020b2:	eb 09                	jmp    801020bd <ideinit+0x6d>
801020b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801020b8:	83 e9 01             	sub    $0x1,%ecx
801020bb:	74 0f                	je     801020cc <ideinit+0x7c>
801020bd:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801020be:	84 c0                	test   %al,%al
801020c0:	74 f6                	je     801020b8 <ideinit+0x68>
      havedisk1 = 1;
801020c2:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801020c9:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020cc:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020d1:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801020d6:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
801020d7:	c9                   	leave  
801020d8:	c3                   	ret    
801020d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020e0 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020e9:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020f0:	e8 5b 21 00 00       	call   80104250 <acquire>
  if((b = idequeue) == 0){
801020f5:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020fb:	85 db                	test   %ebx,%ebx
801020fd:	74 30                	je     8010212f <ideintr+0x4f>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
801020ff:	8b 43 58             	mov    0x58(%ebx),%eax
80102102:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102107:	8b 33                	mov    (%ebx),%esi
80102109:	f7 c6 04 00 00 00    	test   $0x4,%esi
8010210f:	74 37                	je     80102148 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102111:	83 e6 fb             	and    $0xfffffffb,%esi
80102114:	83 ce 02             	or     $0x2,%esi
80102117:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102119:	89 1c 24             	mov    %ebx,(%esp)
8010211c:	e8 ef 1d 00 00       	call   80103f10 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102121:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102126:	85 c0                	test   %eax,%eax
80102128:	74 05                	je     8010212f <ideintr+0x4f>
    idestart(idequeue);
8010212a:	e8 61 fe ff ff       	call   80101f90 <idestart>
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
  if((b = idequeue) == 0){
    release(&idelock);
8010212f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102136:	e8 45 22 00 00       	call   80104380 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
8010213b:	83 c4 1c             	add    $0x1c,%esp
8010213e:	5b                   	pop    %ebx
8010213f:	5e                   	pop    %esi
80102140:	5f                   	pop    %edi
80102141:	5d                   	pop    %ebp
80102142:	c3                   	ret    
80102143:	90                   	nop
80102144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102148:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010214d:	8d 76 00             	lea    0x0(%esi),%esi
80102150:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102151:	89 c1                	mov    %eax,%ecx
80102153:	83 e1 c0             	and    $0xffffffc0,%ecx
80102156:	80 f9 40             	cmp    $0x40,%cl
80102159:	75 f5                	jne    80102150 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010215b:	a8 21                	test   $0x21,%al
8010215d:	75 b2                	jne    80102111 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
8010215f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
80102162:	b9 80 00 00 00       	mov    $0x80,%ecx
80102167:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010216c:	fc                   	cld    
8010216d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010216f:	8b 33                	mov    (%ebx),%esi
80102171:	eb 9e                	jmp    80102111 <ideintr+0x31>
80102173:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102180 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102180:	55                   	push   %ebp
80102181:	89 e5                	mov    %esp,%ebp
80102183:	53                   	push   %ebx
80102184:	83 ec 14             	sub    $0x14,%esp
80102187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010218a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010218d:	89 04 24             	mov    %eax,(%esp)
80102190:	e8 0b 20 00 00       	call   801041a0 <holdingsleep>
80102195:	85 c0                	test   %eax,%eax
80102197:	0f 84 9e 00 00 00    	je     8010223b <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010219d:	8b 03                	mov    (%ebx),%eax
8010219f:	83 e0 06             	and    $0x6,%eax
801021a2:	83 f8 02             	cmp    $0x2,%eax
801021a5:	0f 84 a8 00 00 00    	je     80102253 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801021ab:	8b 53 04             	mov    0x4(%ebx),%edx
801021ae:	85 d2                	test   %edx,%edx
801021b0:	74 0d                	je     801021bf <iderw+0x3f>
801021b2:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801021b7:	85 c0                	test   %eax,%eax
801021b9:	0f 84 88 00 00 00    	je     80102247 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801021bf:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801021c6:	e8 85 20 00 00       	call   80104250 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021cb:	a1 64 a5 10 80       	mov    0x8010a564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
801021d0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021d7:	85 c0                	test   %eax,%eax
801021d9:	75 07                	jne    801021e2 <iderw+0x62>
801021db:	eb 4e                	jmp    8010222b <iderw+0xab>
801021dd:	8d 76 00             	lea    0x0(%esi),%esi
801021e0:	89 d0                	mov    %edx,%eax
801021e2:	8b 50 58             	mov    0x58(%eax),%edx
801021e5:	85 d2                	test   %edx,%edx
801021e7:	75 f7                	jne    801021e0 <iderw+0x60>
801021e9:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
801021ec:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801021ee:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021f4:	74 3c                	je     80102232 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021f6:	8b 03                	mov    (%ebx),%eax
801021f8:	83 e0 06             	and    $0x6,%eax
801021fb:	83 f8 02             	cmp    $0x2,%eax
801021fe:	74 1a                	je     8010221a <iderw+0x9a>
    sleep(b, &idelock);
80102200:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
80102207:	80 
80102208:	89 1c 24             	mov    %ebx,(%esp)
8010220b:	e8 50 1b 00 00       	call   80103d60 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102210:	8b 13                	mov    (%ebx),%edx
80102212:	83 e2 06             	and    $0x6,%edx
80102215:	83 fa 02             	cmp    $0x2,%edx
80102218:	75 e6                	jne    80102200 <iderw+0x80>
    sleep(b, &idelock);
  }

  release(&idelock);
8010221a:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102221:	83 c4 14             	add    $0x14,%esp
80102224:	5b                   	pop    %ebx
80102225:	5d                   	pop    %ebp
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }

  release(&idelock);
80102226:	e9 55 21 00 00       	jmp    80104380 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010222b:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
80102230:	eb ba                	jmp    801021ec <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102232:	89 d8                	mov    %ebx,%eax
80102234:	e8 57 fd ff ff       	call   80101f90 <idestart>
80102239:	eb bb                	jmp    801021f6 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010223b:	c7 04 24 d6 6f 10 80 	movl   $0x80106fd6,(%esp)
80102242:	e8 19 e1 ff ff       	call   80100360 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102247:	c7 04 24 01 70 10 80 	movl   $0x80107001,(%esp)
8010224e:	e8 0d e1 ff ff       	call   80100360 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102253:	c7 04 24 ec 6f 10 80 	movl   $0x80106fec,(%esp)
8010225a:	e8 01 e1 ff ff       	call   80100360 <panic>
8010225f:	90                   	nop

80102260 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
80102260:	a1 84 27 11 80       	mov    0x80112784,%eax
80102265:	85 c0                	test   %eax,%eax
80102267:	0f 84 9b 00 00 00    	je     80102308 <ioapicinit+0xa8>
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010226d:	55                   	push   %ebp
8010226e:	89 e5                	mov    %esp,%ebp
80102270:	56                   	push   %esi
80102271:	53                   	push   %ebx
80102272:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102275:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
8010227c:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010227f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102286:	00 00 00 
  return ioapic->data;
80102289:	8b 15 54 26 11 80    	mov    0x80112654,%edx
8010228f:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102292:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102298:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010229e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022a5:	c1 e8 10             	shr    $0x10,%eax
801022a8:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
801022ab:	8b 43 10             	mov    0x10(%ebx),%eax
  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
801022ae:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801022b1:	39 c2                	cmp    %eax,%edx
801022b3:	74 12                	je     801022c7 <ioapicinit+0x67>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801022b5:	c7 04 24 20 70 10 80 	movl   $0x80107020,(%esp)
801022bc:	e8 8f e3 ff ff       	call   80100650 <cprintf>
801022c1:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
801022c7:	ba 10 00 00 00       	mov    $0x10,%edx
801022cc:	31 c0                	xor    %eax,%eax
801022ce:	eb 02                	jmp    801022d2 <ioapicinit+0x72>
801022d0:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022d2:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
801022d4:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
801022da:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022dd:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022e3:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022e6:	89 4b 10             	mov    %ecx,0x10(%ebx)
801022e9:	8d 4a 01             	lea    0x1(%edx),%ecx
801022ec:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022ef:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801022f1:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022f7:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022f9:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102300:	7d ce                	jge    801022d0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102302:	83 c4 10             	add    $0x10,%esp
80102305:	5b                   	pop    %ebx
80102306:	5e                   	pop    %esi
80102307:	5d                   	pop    %ebp
80102308:	f3 c3                	repz ret 
8010230a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102310 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
80102310:	8b 15 84 27 11 80    	mov    0x80112784,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102316:	55                   	push   %ebp
80102317:	89 e5                	mov    %esp,%ebp
80102319:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
8010231c:	85 d2                	test   %edx,%edx
8010231e:	74 29                	je     80102349 <ioapicenable+0x39>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102320:	8d 48 20             	lea    0x20(%eax),%ecx
80102323:	8d 54 00 10          	lea    0x10(%eax,%eax,1),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102327:	a1 54 26 11 80       	mov    0x80112654,%eax
8010232c:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
8010232e:	a1 54 26 11 80       	mov    0x80112654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102333:	83 c2 01             	add    $0x1,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102336:	89 48 10             	mov    %ecx,0x10(%eax)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102339:	8b 4d 0c             	mov    0xc(%ebp),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010233c:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
8010233e:	a1 54 26 11 80       	mov    0x80112654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102343:	c1 e1 18             	shl    $0x18,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102346:	89 48 10             	mov    %ecx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102349:	5d                   	pop    %ebp
8010234a:	c3                   	ret    
8010234b:	66 90                	xchg   %ax,%ax
8010234d:	66 90                	xchg   %ax,%ax
8010234f:	90                   	nop

80102350 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	53                   	push   %ebx
80102354:	83 ec 14             	sub    $0x14,%esp
80102357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010235a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102360:	75 7c                	jne    801023de <kfree+0x8e>
80102362:	81 fb 28 56 11 80    	cmp    $0x80115628,%ebx
80102368:	72 74                	jb     801023de <kfree+0x8e>
8010236a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102370:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102375:	77 67                	ja     801023de <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102377:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010237e:	00 
8010237f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102386:	00 
80102387:	89 1c 24             	mov    %ebx,(%esp)
8010238a:	e8 41 20 00 00       	call   801043d0 <memset>

  if(kmem.use_lock)
8010238f:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102395:	85 d2                	test   %edx,%edx
80102397:	75 37                	jne    801023d0 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102399:	a1 98 26 11 80       	mov    0x80112698,%eax
8010239e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801023a0:	a1 94 26 11 80       	mov    0x80112694,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
801023a5:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
801023ab:	85 c0                	test   %eax,%eax
801023ad:	75 09                	jne    801023b8 <kfree+0x68>
    release(&kmem.lock);
}
801023af:	83 c4 14             	add    $0x14,%esp
801023b2:	5b                   	pop    %ebx
801023b3:	5d                   	pop    %ebp
801023b4:	c3                   	ret    
801023b5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801023b8:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
801023bf:	83 c4 14             	add    $0x14,%esp
801023c2:	5b                   	pop    %ebx
801023c3:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801023c4:	e9 b7 1f 00 00       	jmp    80104380 <release>
801023c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
801023d0:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801023d7:	e8 74 1e 00 00       	call   80104250 <acquire>
801023dc:	eb bb                	jmp    80102399 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
801023de:	c7 04 24 52 70 10 80 	movl   $0x80107052,(%esp)
801023e5:	e8 76 df ff ff       	call   80100360 <panic>
801023ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023f0 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801023fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023fe:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102404:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010240a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102410:	39 de                	cmp    %ebx,%esi
80102412:	73 08                	jae    8010241c <freerange+0x2c>
80102414:	eb 18                	jmp    8010242e <freerange+0x3e>
80102416:	66 90                	xchg   %ax,%ax
80102418:	89 da                	mov    %ebx,%edx
8010241a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010241c:	89 14 24             	mov    %edx,(%esp)
8010241f:	e8 2c ff ff ff       	call   80102350 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102424:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010242a:	39 f0                	cmp    %esi,%eax
8010242c:	76 ea                	jbe    80102418 <freerange+0x28>
    kfree(p);
}
8010242e:	83 c4 10             	add    $0x10,%esp
80102431:	5b                   	pop    %ebx
80102432:	5e                   	pop    %esi
80102433:	5d                   	pop    %ebp
80102434:	c3                   	ret    
80102435:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102440 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	56                   	push   %esi
80102444:	53                   	push   %ebx
80102445:	83 ec 10             	sub    $0x10,%esp
80102448:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010244b:	c7 44 24 04 58 70 10 	movl   $0x80107058,0x4(%esp)
80102452:	80 
80102453:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
8010245a:	e8 71 1d 00 00       	call   801041d0 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010245f:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102462:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102469:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010246c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102472:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102478:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010247e:	39 de                	cmp    %ebx,%esi
80102480:	73 0a                	jae    8010248c <kinit1+0x4c>
80102482:	eb 1a                	jmp    8010249e <kinit1+0x5e>
80102484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102488:	89 da                	mov    %ebx,%edx
8010248a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010248c:	89 14 24             	mov    %edx,(%esp)
8010248f:	e8 bc fe ff ff       	call   80102350 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102494:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010249a:	39 c6                	cmp    %eax,%esi
8010249c:	73 ea                	jae    80102488 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010249e:	83 c4 10             	add    $0x10,%esp
801024a1:	5b                   	pop    %ebx
801024a2:	5e                   	pop    %esi
801024a3:	5d                   	pop    %ebp
801024a4:	c3                   	ret    
801024a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024b0 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	56                   	push   %esi
801024b4:	53                   	push   %ebx
801024b5:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801024b8:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
801024bb:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801024be:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801024c4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024ca:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801024d0:	39 de                	cmp    %ebx,%esi
801024d2:	73 08                	jae    801024dc <kinit2+0x2c>
801024d4:	eb 18                	jmp    801024ee <kinit2+0x3e>
801024d6:	66 90                	xchg   %ax,%ax
801024d8:	89 da                	mov    %ebx,%edx
801024da:	89 c3                	mov    %eax,%ebx
    kfree(p);
801024dc:	89 14 24             	mov    %edx,(%esp)
801024df:	e8 6c fe ff ff       	call   80102350 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024e4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801024ea:	39 c6                	cmp    %eax,%esi
801024ec:	73 ea                	jae    801024d8 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
801024ee:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
801024f5:	00 00 00 
}
801024f8:	83 c4 10             	add    $0x10,%esp
801024fb:	5b                   	pop    %ebx
801024fc:	5e                   	pop    %esi
801024fd:	5d                   	pop    %ebp
801024fe:	c3                   	ret    
801024ff:	90                   	nop

80102500 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102500:	55                   	push   %ebp
80102501:	89 e5                	mov    %esp,%ebp
80102503:	53                   	push   %ebx
80102504:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
80102507:	a1 94 26 11 80       	mov    0x80112694,%eax
8010250c:	85 c0                	test   %eax,%eax
8010250e:	75 30                	jne    80102540 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102510:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
80102516:	85 db                	test   %ebx,%ebx
80102518:	74 08                	je     80102522 <kalloc+0x22>
    kmem.freelist = r->next;
8010251a:	8b 13                	mov    (%ebx),%edx
8010251c:	89 15 98 26 11 80    	mov    %edx,0x80112698
  if(kmem.use_lock)
80102522:	85 c0                	test   %eax,%eax
80102524:	74 0c                	je     80102532 <kalloc+0x32>
    release(&kmem.lock);
80102526:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
8010252d:	e8 4e 1e 00 00       	call   80104380 <release>
  return (char*)r;
}
80102532:	83 c4 14             	add    $0x14,%esp
80102535:	89 d8                	mov    %ebx,%eax
80102537:	5b                   	pop    %ebx
80102538:	5d                   	pop    %ebp
80102539:	c3                   	ret    
8010253a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102540:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
80102547:	e8 04 1d 00 00       	call   80104250 <acquire>
8010254c:	a1 94 26 11 80       	mov    0x80112694,%eax
80102551:	eb bd                	jmp    80102510 <kalloc+0x10>
80102553:	66 90                	xchg   %ax,%ax
80102555:	66 90                	xchg   %ax,%ax
80102557:	66 90                	xchg   %ax,%ax
80102559:	66 90                	xchg   %ax,%ax
8010255b:	66 90                	xchg   %ax,%ax
8010255d:	66 90                	xchg   %ax,%ax
8010255f:	90                   	nop

80102560 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102560:	ba 64 00 00 00       	mov    $0x64,%edx
80102565:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102566:	a8 01                	test   $0x1,%al
80102568:	0f 84 ba 00 00 00    	je     80102628 <kbdgetc+0xc8>
8010256e:	b2 60                	mov    $0x60,%dl
80102570:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102571:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102574:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010257a:	0f 84 88 00 00 00    	je     80102608 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102580:	84 c0                	test   %al,%al
80102582:	79 2c                	jns    801025b0 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102584:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010258a:	f6 c2 40             	test   $0x40,%dl
8010258d:	75 05                	jne    80102594 <kbdgetc+0x34>
8010258f:	89 c1                	mov    %eax,%ecx
80102591:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102594:	0f b6 81 80 71 10 80 	movzbl -0x7fef8e80(%ecx),%eax
8010259b:	83 c8 40             	or     $0x40,%eax
8010259e:	0f b6 c0             	movzbl %al,%eax
801025a1:	f7 d0                	not    %eax
801025a3:	21 d0                	and    %edx,%eax
801025a5:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
801025aa:	31 c0                	xor    %eax,%eax
801025ac:	c3                   	ret    
801025ad:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	53                   	push   %ebx
801025b4:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801025ba:	f6 c3 40             	test   $0x40,%bl
801025bd:	74 09                	je     801025c8 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025bf:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801025c2:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025c5:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
801025c8:	0f b6 91 80 71 10 80 	movzbl -0x7fef8e80(%ecx),%edx
  shift ^= togglecode[data];
801025cf:	0f b6 81 80 70 10 80 	movzbl -0x7fef8f80(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
801025d6:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801025d8:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801025da:	89 d0                	mov    %edx,%eax
801025dc:	83 e0 03             	and    $0x3,%eax
801025df:	8b 04 85 60 70 10 80 	mov    -0x7fef8fa0(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801025e6:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
801025ec:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
801025ef:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801025f3:	74 0b                	je     80102600 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
801025f5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025f8:	83 fa 19             	cmp    $0x19,%edx
801025fb:	77 1b                	ja     80102618 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025fd:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102600:	5b                   	pop    %ebx
80102601:	5d                   	pop    %ebp
80102602:	c3                   	ret    
80102603:	90                   	nop
80102604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102608:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
8010260f:	31 c0                	xor    %eax,%eax
80102611:	c3                   	ret    
80102612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102618:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010261b:	8d 50 20             	lea    0x20(%eax),%edx
8010261e:	83 f9 19             	cmp    $0x19,%ecx
80102621:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
80102624:	eb da                	jmp    80102600 <kbdgetc+0xa0>
80102626:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102628:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010262d:	c3                   	ret    
8010262e:	66 90                	xchg   %ax,%ax

80102630 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102636:	c7 04 24 60 25 10 80 	movl   $0x80102560,(%esp)
8010263d:	e8 6e e1 ff ff       	call   801007b0 <consoleintr>
}
80102642:	c9                   	leave  
80102643:	c3                   	ret    
80102644:	66 90                	xchg   %ax,%ax
80102646:	66 90                	xchg   %ax,%ax
80102648:	66 90                	xchg   %ax,%ax
8010264a:	66 90                	xchg   %ax,%ax
8010264c:	66 90                	xchg   %ax,%ax
8010264e:	66 90                	xchg   %ax,%ax

80102650 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
80102650:	55                   	push   %ebp
80102651:	89 c1                	mov    %eax,%ecx
80102653:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102655:	ba 70 00 00 00       	mov    $0x70,%edx
8010265a:	53                   	push   %ebx
8010265b:	31 c0                	xor    %eax,%eax
8010265d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010265e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102663:	89 da                	mov    %ebx,%edx
80102665:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102666:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102669:	b2 70                	mov    $0x70,%dl
8010266b:	89 01                	mov    %eax,(%ecx)
8010266d:	b8 02 00 00 00       	mov    $0x2,%eax
80102672:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102673:	89 da                	mov    %ebx,%edx
80102675:	ec                   	in     (%dx),%al
80102676:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102679:	b2 70                	mov    $0x70,%dl
8010267b:	89 41 04             	mov    %eax,0x4(%ecx)
8010267e:	b8 04 00 00 00       	mov    $0x4,%eax
80102683:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102684:	89 da                	mov    %ebx,%edx
80102686:	ec                   	in     (%dx),%al
80102687:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010268a:	b2 70                	mov    $0x70,%dl
8010268c:	89 41 08             	mov    %eax,0x8(%ecx)
8010268f:	b8 07 00 00 00       	mov    $0x7,%eax
80102694:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102695:	89 da                	mov    %ebx,%edx
80102697:	ec                   	in     (%dx),%al
80102698:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010269b:	b2 70                	mov    $0x70,%dl
8010269d:	89 41 0c             	mov    %eax,0xc(%ecx)
801026a0:	b8 08 00 00 00       	mov    $0x8,%eax
801026a5:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026a6:	89 da                	mov    %ebx,%edx
801026a8:	ec                   	in     (%dx),%al
801026a9:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026ac:	b2 70                	mov    $0x70,%dl
801026ae:	89 41 10             	mov    %eax,0x10(%ecx)
801026b1:	b8 09 00 00 00       	mov    $0x9,%eax
801026b6:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026b7:	89 da                	mov    %ebx,%edx
801026b9:	ec                   	in     (%dx),%al
801026ba:	0f b6 d8             	movzbl %al,%ebx
801026bd:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
801026c0:	5b                   	pop    %ebx
801026c1:	5d                   	pop    %ebp
801026c2:	c3                   	ret    
801026c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801026c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026d0 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
801026d0:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}
//PAGEBREAK!

void
lapicinit(void)
{
801026d5:	55                   	push   %ebp
801026d6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801026d8:	85 c0                	test   %eax,%eax
801026da:	0f 84 c0 00 00 00    	je     801027a0 <lapicinit+0xd0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026e7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ea:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026ed:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f7:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026fa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102701:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102704:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102707:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010270e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102711:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102714:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010271b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010271e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102721:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102728:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010272b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010272e:	8b 50 30             	mov    0x30(%eax),%edx
80102731:	c1 ea 10             	shr    $0x10,%edx
80102734:	80 fa 03             	cmp    $0x3,%dl
80102737:	77 6f                	ja     801027a8 <lapicinit+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102739:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102740:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102743:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102746:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010274d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102750:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102753:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010275a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010275d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102760:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102767:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010276a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010276d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102774:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102777:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010277a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102781:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102784:	8b 50 20             	mov    0x20(%eax),%edx
80102787:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102788:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010278e:	80 e6 10             	and    $0x10,%dh
80102791:	75 f5                	jne    80102788 <lapicinit+0xb8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102793:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010279a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010279d:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801027a0:	5d                   	pop    %ebp
801027a1:	c3                   	ret    
801027a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027a8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801027af:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027b2:	8b 50 20             	mov    0x20(%eax),%edx
801027b5:	eb 82                	jmp    80102739 <lapicinit+0x69>
801027b7:	89 f6                	mov    %esi,%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027c0 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
801027c3:	56                   	push   %esi
801027c4:	53                   	push   %ebx
801027c5:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801027c8:	9c                   	pushf  
801027c9:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
801027ca:	f6 c4 02             	test   $0x2,%ah
801027cd:	74 12                	je     801027e1 <cpunum+0x21>
    static int n;
    if(n++ == 0)
801027cf:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
801027d4:	8d 50 01             	lea    0x1(%eax),%edx
801027d7:	85 c0                	test   %eax,%eax
801027d9:	89 15 b8 a5 10 80    	mov    %edx,0x8010a5b8
801027df:	74 4a                	je     8010282b <cpunum+0x6b>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
801027e1:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801027e6:	85 c0                	test   %eax,%eax
801027e8:	74 5d                	je     80102847 <cpunum+0x87>
    return 0;

  apicid = lapic[ID] >> 24;
801027ea:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
801027ed:	8b 35 80 2d 11 80    	mov    0x80112d80,%esi
  }

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
801027f3:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
801027f6:	85 f6                	test   %esi,%esi
801027f8:	7e 56                	jle    80102850 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
801027fa:	0f b6 05 a0 27 11 80 	movzbl 0x801127a0,%eax
80102801:	39 d8                	cmp    %ebx,%eax
80102803:	74 42                	je     80102847 <cpunum+0x87>
80102805:	ba 5c 28 11 80       	mov    $0x8011285c,%edx

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
8010280a:	31 c0                	xor    %eax,%eax
8010280c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102810:	83 c0 01             	add    $0x1,%eax
80102813:	39 f0                	cmp    %esi,%eax
80102815:	74 39                	je     80102850 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
80102817:	0f b6 0a             	movzbl (%edx),%ecx
8010281a:	81 c2 bc 00 00 00    	add    $0xbc,%edx
80102820:	39 d9                	cmp    %ebx,%ecx
80102822:	75 ec                	jne    80102810 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
80102824:	83 c4 10             	add    $0x10,%esp
80102827:	5b                   	pop    %ebx
80102828:	5e                   	pop    %esi
80102829:	5d                   	pop    %ebp
8010282a:	c3                   	ret    
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
8010282b:	8b 45 04             	mov    0x4(%ebp),%eax
8010282e:	c7 04 24 80 72 10 80 	movl   $0x80107280,(%esp)
80102835:	89 44 24 04          	mov    %eax,0x4(%esp)
80102839:	e8 12 de ff ff       	call   80100650 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
8010283e:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102843:	85 c0                	test   %eax,%eax
80102845:	75 a3                	jne    801027ea <cpunum+0x2a>
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
80102847:	83 c4 10             	add    $0x10,%esp
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
    return 0;
8010284a:	31 c0                	xor    %eax,%eax
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
8010284c:	5b                   	pop    %ebx
8010284d:	5e                   	pop    %esi
8010284e:	5d                   	pop    %ebp
8010284f:	c3                   	ret    
  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
80102850:	c7 04 24 ac 72 10 80 	movl   $0x801072ac,(%esp)
80102857:	e8 04 db ff ff       	call   80100360 <panic>
8010285c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102860 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102860:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102865:	55                   	push   %ebp
80102866:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102868:	85 c0                	test   %eax,%eax
8010286a:	74 0d                	je     80102879 <lapiceoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010286c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102873:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102876:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102879:	5d                   	pop    %ebp
8010287a:	c3                   	ret    
8010287b:	90                   	nop
8010287c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102880 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102880:	55                   	push   %ebp
80102881:	89 e5                	mov    %esp,%ebp
}
80102883:	5d                   	pop    %ebp
80102884:	c3                   	ret    
80102885:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102890 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102890:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102891:	ba 70 00 00 00       	mov    $0x70,%edx
80102896:	89 e5                	mov    %esp,%ebp
80102898:	b8 0f 00 00 00       	mov    $0xf,%eax
8010289d:	53                   	push   %ebx
8010289e:	8b 4d 08             	mov    0x8(%ebp),%ecx
801028a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801028a4:	ee                   	out    %al,(%dx)
801028a5:	b8 0a 00 00 00       	mov    $0xa,%eax
801028aa:	b2 71                	mov    $0x71,%dl
801028ac:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801028ad:	31 c0                	xor    %eax,%eax
801028af:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801028b5:	89 d8                	mov    %ebx,%eax
801028b7:	c1 e8 04             	shr    $0x4,%eax
801028ba:	66 a3 69 04 00 80    	mov    %ax,0x80000469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028c0:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801028c5:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801028c8:	c1 eb 0c             	shr    $0xc,%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028cb:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028d1:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028d4:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801028db:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028de:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028e1:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801028e8:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028eb:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028ee:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028f4:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801028f7:	89 da                	mov    %ebx,%edx
801028f9:	80 ce 06             	or     $0x6,%dh
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028fc:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102902:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102905:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010290b:	8b 48 20             	mov    0x20(%eax),%ecx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010290e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102914:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102917:	5b                   	pop    %ebx
80102918:	5d                   	pop    %ebp
80102919:	c3                   	ret    
8010291a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102920 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102920:	55                   	push   %ebp
80102921:	ba 70 00 00 00       	mov    $0x70,%edx
80102926:	89 e5                	mov    %esp,%ebp
80102928:	b8 0b 00 00 00       	mov    $0xb,%eax
8010292d:	57                   	push   %edi
8010292e:	56                   	push   %esi
8010292f:	53                   	push   %ebx
80102930:	83 ec 4c             	sub    $0x4c,%esp
80102933:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102934:	b2 71                	mov    $0x71,%dl
80102936:	ec                   	in     (%dx),%al
80102937:	88 45 b7             	mov    %al,-0x49(%ebp)
8010293a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010293d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102941:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102948:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010294d:	89 d8                	mov    %ebx,%eax
8010294f:	e8 fc fc ff ff       	call   80102650 <fill_rtcdate>
80102954:	b8 0a 00 00 00       	mov    $0xa,%eax
80102959:	89 f2                	mov    %esi,%edx
8010295b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010295c:	ba 71 00 00 00       	mov    $0x71,%edx
80102961:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102962:	84 c0                	test   %al,%al
80102964:	78 e7                	js     8010294d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102966:	89 f8                	mov    %edi,%eax
80102968:	e8 e3 fc ff ff       	call   80102650 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010296d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102974:	00 
80102975:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102979:	89 1c 24             	mov    %ebx,(%esp)
8010297c:	e8 9f 1a 00 00       	call   80104420 <memcmp>
80102981:	85 c0                	test   %eax,%eax
80102983:	75 c3                	jne    80102948 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102985:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102989:	75 78                	jne    80102a03 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010298b:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010298e:	89 c2                	mov    %eax,%edx
80102990:	83 e0 0f             	and    $0xf,%eax
80102993:	c1 ea 04             	shr    $0x4,%edx
80102996:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102999:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010299f:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029a2:	89 c2                	mov    %eax,%edx
801029a4:	83 e0 0f             	and    $0xf,%eax
801029a7:	c1 ea 04             	shr    $0x4,%edx
801029aa:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ad:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029b0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801029b3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029b6:	89 c2                	mov    %eax,%edx
801029b8:	83 e0 0f             	and    $0xf,%eax
801029bb:	c1 ea 04             	shr    $0x4,%edx
801029be:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029c1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801029c7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029ca:	89 c2                	mov    %eax,%edx
801029cc:	83 e0 0f             	and    $0xf,%eax
801029cf:	c1 ea 04             	shr    $0x4,%edx
801029d2:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029d5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029d8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029db:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029de:	89 c2                	mov    %eax,%edx
801029e0:	83 e0 0f             	and    $0xf,%eax
801029e3:	c1 ea 04             	shr    $0x4,%edx
801029e6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029e9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ec:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029f2:	89 c2                	mov    %eax,%edx
801029f4:	83 e0 0f             	and    $0xf,%eax
801029f7:	c1 ea 04             	shr    $0x4,%edx
801029fa:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029fd:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a00:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102a03:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102a06:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a09:	89 01                	mov    %eax,(%ecx)
80102a0b:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a0e:	89 41 04             	mov    %eax,0x4(%ecx)
80102a11:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a14:	89 41 08             	mov    %eax,0x8(%ecx)
80102a17:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a1a:	89 41 0c             	mov    %eax,0xc(%ecx)
80102a1d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a20:	89 41 10             	mov    %eax,0x10(%ecx)
80102a23:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a26:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102a29:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102a30:	83 c4 4c             	add    $0x4c,%esp
80102a33:	5b                   	pop    %ebx
80102a34:	5e                   	pop    %esi
80102a35:	5f                   	pop    %edi
80102a36:	5d                   	pop    %ebp
80102a37:	c3                   	ret    
80102a38:	66 90                	xchg   %ax,%ax
80102a3a:	66 90                	xchg   %ax,%ax
80102a3c:	66 90                	xchg   %ax,%ax
80102a3e:	66 90                	xchg   %ax,%ax

80102a40 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102a40:	55                   	push   %ebp
80102a41:	89 e5                	mov    %esp,%ebp
80102a43:	57                   	push   %edi
80102a44:	56                   	push   %esi
80102a45:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a46:	31 db                	xor    %ebx,%ebx
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102a48:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a4b:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102a50:	85 c0                	test   %eax,%eax
80102a52:	7e 78                	jle    80102acc <install_trans+0x8c>
80102a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a58:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102a5d:	01 d8                	add    %ebx,%eax
80102a5f:	83 c0 01             	add    $0x1,%eax
80102a62:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a66:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102a6b:	89 04 24             	mov    %eax,(%esp)
80102a6e:	e8 5d d6 ff ff       	call   801000d0 <bread>
80102a73:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a75:	8b 04 9d ec 26 11 80 	mov    -0x7feed914(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a7c:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a83:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102a88:	89 04 24             	mov    %eax,(%esp)
80102a8b:	e8 40 d6 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a90:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102a97:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a98:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a9a:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a9d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102aa1:	8d 46 5c             	lea    0x5c(%esi),%eax
80102aa4:	89 04 24             	mov    %eax,(%esp)
80102aa7:	e8 c4 19 00 00       	call   80104470 <memmove>
    bwrite(dbuf);  // write dst to disk
80102aac:	89 34 24             	mov    %esi,(%esp)
80102aaf:	e8 ec d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102ab4:	89 3c 24             	mov    %edi,(%esp)
80102ab7:	e8 24 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102abc:	89 34 24             	mov    %esi,(%esp)
80102abf:	e8 1c d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ac4:	39 1d e8 26 11 80    	cmp    %ebx,0x801126e8
80102aca:	7f 8c                	jg     80102a58 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102acc:	83 c4 1c             	add    $0x1c,%esp
80102acf:	5b                   	pop    %ebx
80102ad0:	5e                   	pop    %esi
80102ad1:	5f                   	pop    %edi
80102ad2:	5d                   	pop    %ebp
80102ad3:	c3                   	ret    
80102ad4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102ada:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102ae0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	57                   	push   %edi
80102ae4:	56                   	push   %esi
80102ae5:	53                   	push   %ebx
80102ae6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ae9:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102aee:	89 44 24 04          	mov    %eax,0x4(%esp)
80102af2:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102af7:	89 04 24             	mov    %eax,(%esp)
80102afa:	e8 d1 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102aff:	8b 1d e8 26 11 80    	mov    0x801126e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b05:	31 d2                	xor    %edx,%edx
80102b07:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b09:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102b0b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102b0e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102b11:	7e 17                	jle    80102b2a <write_head+0x4a>
80102b13:	90                   	nop
80102b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102b18:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102b1f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102b23:	83 c2 01             	add    $0x1,%edx
80102b26:	39 da                	cmp    %ebx,%edx
80102b28:	75 ee                	jne    80102b18 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102b2a:	89 3c 24             	mov    %edi,(%esp)
80102b2d:	e8 6e d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b32:	89 3c 24             	mov    %edi,(%esp)
80102b35:	e8 a6 d6 ff ff       	call   801001e0 <brelse>
}
80102b3a:	83 c4 1c             	add    $0x1c,%esp
80102b3d:	5b                   	pop    %ebx
80102b3e:	5e                   	pop    %esi
80102b3f:	5f                   	pop    %edi
80102b40:	5d                   	pop    %ebp
80102b41:	c3                   	ret    
80102b42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b50 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102b50:	55                   	push   %ebp
80102b51:	89 e5                	mov    %esp,%ebp
80102b53:	56                   	push   %esi
80102b54:	53                   	push   %ebx
80102b55:	83 ec 30             	sub    $0x30,%esp
80102b58:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102b5b:	c7 44 24 04 bc 72 10 	movl   $0x801072bc,0x4(%esp)
80102b62:	80 
80102b63:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102b6a:	e8 61 16 00 00       	call   801041d0 <initlock>
  readsb(dev, &sb);
80102b6f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b72:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b76:	89 1c 24             	mov    %ebx,(%esp)
80102b79:	e8 82 e8 ff ff       	call   80101400 <readsb>
  log.start = sb.logstart;
80102b7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102b81:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b84:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102b87:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b8d:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b91:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b97:	a3 d4 26 11 80       	mov    %eax,0x801126d4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b9c:	e8 2f d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102ba1:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ba3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ba6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ba9:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102bab:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102bb1:	7e 17                	jle    80102bca <initlog+0x7a>
80102bb3:	90                   	nop
80102bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102bb8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102bbc:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102bc3:	83 c2 01             	add    $0x1,%edx
80102bc6:	39 da                	cmp    %ebx,%edx
80102bc8:	75 ee                	jne    80102bb8 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102bca:	89 04 24             	mov    %eax,(%esp)
80102bcd:	e8 0e d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102bd2:	e8 69 fe ff ff       	call   80102a40 <install_trans>
  log.lh.n = 0;
80102bd7:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102bde:	00 00 00 
  write_head(); // clear the log
80102be1:	e8 fa fe ff ff       	call   80102ae0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102be6:	83 c4 30             	add    $0x30,%esp
80102be9:	5b                   	pop    %ebx
80102bea:	5e                   	pop    %esi
80102beb:	5d                   	pop    %ebp
80102bec:	c3                   	ret    
80102bed:	8d 76 00             	lea    0x0(%esi),%esi

80102bf0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bf0:	55                   	push   %ebp
80102bf1:	89 e5                	mov    %esp,%ebp
80102bf3:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102bf6:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102bfd:	e8 4e 16 00 00       	call   80104250 <acquire>
80102c02:	eb 18                	jmp    80102c1c <begin_op+0x2c>
80102c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102c08:	c7 44 24 04 a0 26 11 	movl   $0x801126a0,0x4(%esp)
80102c0f:	80 
80102c10:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102c17:	e8 44 11 00 00       	call   80103d60 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102c1c:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102c21:	85 c0                	test   %eax,%eax
80102c23:	75 e3                	jne    80102c08 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c25:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102c2a:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102c30:	83 c0 01             	add    $0x1,%eax
80102c33:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c36:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c39:	83 fa 1e             	cmp    $0x1e,%edx
80102c3c:	7f ca                	jg     80102c08 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c3e:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102c45:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102c4a:	e8 31 17 00 00       	call   80104380 <release>
      break;
    }
  }
}
80102c4f:	c9                   	leave  
80102c50:	c3                   	ret    
80102c51:	eb 0d                	jmp    80102c60 <end_op>
80102c53:	90                   	nop
80102c54:	90                   	nop
80102c55:	90                   	nop
80102c56:	90                   	nop
80102c57:	90                   	nop
80102c58:	90                   	nop
80102c59:	90                   	nop
80102c5a:	90                   	nop
80102c5b:	90                   	nop
80102c5c:	90                   	nop
80102c5d:	90                   	nop
80102c5e:	90                   	nop
80102c5f:	90                   	nop

80102c60 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	57                   	push   %edi
80102c64:	56                   	push   %esi
80102c65:	53                   	push   %ebx
80102c66:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c69:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102c70:	e8 db 15 00 00       	call   80104250 <acquire>
  log.outstanding -= 1;
80102c75:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102c7a:	8b 15 e0 26 11 80    	mov    0x801126e0,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c80:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c83:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c85:	a3 dc 26 11 80       	mov    %eax,0x801126dc
  if(log.committing)
80102c8a:	0f 85 f3 00 00 00    	jne    80102d83 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102c90:	85 c0                	test   %eax,%eax
80102c92:	0f 85 cb 00 00 00    	jne    80102d63 <end_op+0x103>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c98:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c9f:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102ca1:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102ca8:	00 00 00 
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102cab:	e8 d0 16 00 00       	call   80104380 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102cb0:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102cb5:	85 c0                	test   %eax,%eax
80102cb7:	0f 8e 90 00 00 00    	jle    80102d4d <end_op+0xed>
80102cbd:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102cc0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102cc5:	01 d8                	add    %ebx,%eax
80102cc7:	83 c0 01             	add    $0x1,%eax
80102cca:	89 44 24 04          	mov    %eax,0x4(%esp)
80102cce:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102cd3:	89 04 24             	mov    %eax,(%esp)
80102cd6:	e8 f5 d3 ff ff       	call   801000d0 <bread>
80102cdb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cdd:	8b 04 9d ec 26 11 80 	mov    -0x7feed914(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ce4:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ce7:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ceb:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102cf0:	89 04 24             	mov    %eax,(%esp)
80102cf3:	e8 d8 d3 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102cf8:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102cff:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d00:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102d02:	8d 40 5c             	lea    0x5c(%eax),%eax
80102d05:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d09:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d0c:	89 04 24             	mov    %eax,(%esp)
80102d0f:	e8 5c 17 00 00       	call   80104470 <memmove>
    bwrite(to);  // write the log
80102d14:	89 34 24             	mov    %esi,(%esp)
80102d17:	e8 84 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102d1c:	89 3c 24             	mov    %edi,(%esp)
80102d1f:	e8 bc d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102d24:	89 34 24             	mov    %esi,(%esp)
80102d27:	e8 b4 d4 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d2c:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102d32:	7c 8c                	jl     80102cc0 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d34:	e8 a7 fd ff ff       	call   80102ae0 <write_head>
    install_trans(); // Now install writes to home locations
80102d39:	e8 02 fd ff ff       	call   80102a40 <install_trans>
    log.lh.n = 0;
80102d3e:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d45:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d48:	e8 93 fd ff ff       	call   80102ae0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102d4d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d54:	e8 f7 14 00 00       	call   80104250 <acquire>
    log.committing = 0;
80102d59:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102d60:	00 00 00 
    wakeup(&log);
80102d63:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d6a:	e8 a1 11 00 00       	call   80103f10 <wakeup>
    release(&log.lock);
80102d6f:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d76:	e8 05 16 00 00       	call   80104380 <release>
  }
}
80102d7b:	83 c4 1c             	add    $0x1c,%esp
80102d7e:	5b                   	pop    %ebx
80102d7f:	5e                   	pop    %esi
80102d80:	5f                   	pop    %edi
80102d81:	5d                   	pop    %ebp
80102d82:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d83:	c7 04 24 c0 72 10 80 	movl   $0x801072c0,(%esp)
80102d8a:	e8 d1 d5 ff ff       	call   80100360 <panic>
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
80102d94:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d97:	a1 e8 26 11 80       	mov    0x801126e8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d9f:	83 f8 1d             	cmp    $0x1d,%eax
80102da2:	0f 8f 98 00 00 00    	jg     80102e40 <log_write+0xb0>
80102da8:	8b 0d d8 26 11 80    	mov    0x801126d8,%ecx
80102dae:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102db1:	39 d0                	cmp    %edx,%eax
80102db3:	0f 8d 87 00 00 00    	jge    80102e40 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102db9:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102dbe:	85 c0                	test   %eax,%eax
80102dc0:	0f 8e 86 00 00 00    	jle    80102e4c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102dc6:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102dcd:	e8 7e 14 00 00       	call   80104250 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102dd2:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102dd8:	83 fa 00             	cmp    $0x0,%edx
80102ddb:	7e 54                	jle    80102e31 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ddd:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102de0:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102de2:	39 0d ec 26 11 80    	cmp    %ecx,0x801126ec
80102de8:	75 0f                	jne    80102df9 <log_write+0x69>
80102dea:	eb 3c                	jmp    80102e28 <log_write+0x98>
80102dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102df0:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
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
80102e00:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e07:	83 c2 01             	add    $0x1,%edx
80102e0a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
  b->flags |= B_DIRTY; // prevent eviction
80102e10:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e13:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102e1a:	83 c4 14             	add    $0x14,%esp
80102e1d:	5b                   	pop    %ebx
80102e1e:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102e1f:	e9 5c 15 00 00       	jmp    80104380 <release>
80102e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102e28:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
80102e2f:	eb df                	jmp    80102e10 <log_write+0x80>
80102e31:	8b 43 08             	mov    0x8(%ebx),%eax
80102e34:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102e39:	75 d5                	jne    80102e10 <log_write+0x80>
80102e3b:	eb ca                	jmp    80102e07 <log_write+0x77>
80102e3d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102e40:	c7 04 24 cf 72 10 80 	movl   $0x801072cf,(%esp)
80102e47:	e8 14 d5 ff ff       	call   80100360 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102e4c:	c7 04 24 e5 72 10 80 	movl   $0x801072e5,(%esp)
80102e53:	e8 08 d5 ff ff       	call   80100360 <panic>
80102e58:	66 90                	xchg   %ax,%ax
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
80102e63:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpunum());
80102e66:	e8 55 f9 ff ff       	call   801027c0 <cpunum>
80102e6b:	c7 04 24 00 73 10 80 	movl   $0x80107300,(%esp)
80102e72:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e76:	e8 d5 d7 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102e7b:	e8 b0 27 00 00       	call   80105630 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102e80:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e87:	b8 01 00 00 00       	mov    $0x1,%eax
80102e8c:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102e93:	e8 f8 0b 00 00       	call   80103a90 <scheduler>
80102e98:	90                   	nop
80102e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

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
80102ea6:	e8 95 39 00 00       	call   80106840 <switchkvm>
  seginit();
80102eab:	e8 b0 37 00 00       	call   80106660 <seginit>
  lapicinit();
80102eb0:	e8 1b f8 ff ff       	call   801026d0 <lapicinit>
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
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
80102ec3:	53                   	push   %ebx
80102ec4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ec7:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102eca:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102ed1:	80 
80102ed2:	c7 04 24 28 56 11 80 	movl   $0x80115628,(%esp)
80102ed9:	e8 62 f5 ff ff       	call   80102440 <kinit1>
  kvmalloc();      // kernel page table
80102ede:	e8 3d 39 00 00       	call   80106820 <kvmalloc>
  mpinit();        // detect other processors
80102ee3:	e8 a8 01 00 00       	call   80103090 <mpinit>
  lapicinit();     // interrupt controller
80102ee8:	e8 e3 f7 ff ff       	call   801026d0 <lapicinit>
80102eed:	8d 76 00             	lea    0x0(%esi),%esi
  seginit();       // segment descriptors
80102ef0:	e8 6b 37 00 00       	call   80106660 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80102ef5:	e8 c6 f8 ff ff       	call   801027c0 <cpunum>
80102efa:	c7 04 24 11 73 10 80 	movl   $0x80107311,(%esp)
80102f01:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f05:	e8 46 d7 ff ff       	call   80100650 <cprintf>
  picinit();       // another interrupt controller
80102f0a:	e8 81 03 00 00       	call   80103290 <picinit>
  ioapicinit();    // another interrupt controller
80102f0f:	e8 4c f3 ff ff       	call   80102260 <ioapicinit>
  consoleinit();   // console hardware
80102f14:	e8 37 da ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102f19:	e8 52 2a 00 00       	call   80105970 <uartinit>
80102f1e:	66 90                	xchg   %ax,%ax
  pinit();         // process table
80102f20:	e8 9b 08 00 00       	call   801037c0 <pinit>
  tvinit();        // trap vectors
80102f25:	e8 66 26 00 00       	call   80105590 <tvinit>
  binit();         // buffer cache
80102f2a:	e8 11 d1 ff ff       	call   80100040 <binit>
80102f2f:	90                   	nop
  fileinit();      // file table
80102f30:	e8 7b de ff ff       	call   80100db0 <fileinit>
  ideinit();       // disk
80102f35:	e8 16 f1 ff ff       	call   80102050 <ideinit>
  if(!ismp)
80102f3a:	a1 84 27 11 80       	mov    0x80112784,%eax
80102f3f:	85 c0                	test   %eax,%eax
80102f41:	0f 84 ca 00 00 00    	je     80103011 <main+0x151>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f47:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102f4e:	00 

  for(c = cpus; c < cpus+ncpu; c++){
80102f4f:	bb a0 27 11 80       	mov    $0x801127a0,%ebx

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f54:	c7 44 24 04 90 a4 10 	movl   $0x8010a490,0x4(%esp)
80102f5b:	80 
80102f5c:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102f63:	e8 08 15 00 00       	call   80104470 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f68:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80102f6f:	00 00 00 
80102f72:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f77:	39 d8                	cmp    %ebx,%eax
80102f79:	76 78                	jbe    80102ff3 <main+0x133>
80102f7b:	90                   	nop
80102f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == cpus+cpunum())  // We've started already.
80102f80:	e8 3b f8 ff ff       	call   801027c0 <cpunum>
80102f85:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80102f8b:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f90:	39 c3                	cmp    %eax,%ebx
80102f92:	74 46                	je     80102fda <main+0x11a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f94:	e8 67 f5 ff ff       	call   80102500 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102f99:	c7 05 f8 6f 00 80 a0 	movl   $0x80102ea0,0x80006ff8
80102fa0:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102fa3:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102faa:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fad:	05 00 10 00 00       	add    $0x1000,%eax
80102fb2:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102fb7:	0f b6 03             	movzbl (%ebx),%eax
80102fba:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102fc1:	00 
80102fc2:	89 04 24             	mov    %eax,(%esp)
80102fc5:	e8 c6 f8 ff ff       	call   80102890 <lapicstartap>
80102fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fd0:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80102fd6:	85 c0                	test   %eax,%eax
80102fd8:	74 f6                	je     80102fd0 <main+0x110>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102fda:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80102fe1:	00 00 00 
80102fe4:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
80102fea:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102fef:	39 c3                	cmp    %eax,%ebx
80102ff1:	72 8d                	jb     80102f80 <main+0xc0>
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102ff3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102ffa:	8e 
80102ffb:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103002:	e8 a9 f4 ff ff       	call   801024b0 <kinit2>
  userinit();      // first user process
80103007:	e8 d4 07 00 00       	call   801037e0 <userinit>
  mpmain();        // finish this processor's setup
8010300c:	e8 4f fe ff ff       	call   80102e60 <mpmain>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
80103011:	e8 1a 25 00 00       	call   80105530 <timerinit>
80103016:	e9 2c ff ff ff       	jmp    80102f47 <main+0x87>
8010301b:	66 90                	xchg   %ax,%ax
8010301d:	66 90                	xchg   %ax,%ax
8010301f:	90                   	nop

80103020 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103024:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010302a:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010302b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010302e:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103031:	39 de                	cmp    %ebx,%esi
80103033:	73 3c                	jae    80103071 <mpsearch1+0x51>
80103035:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103038:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010303f:	00 
80103040:	c7 44 24 04 28 73 10 	movl   $0x80107328,0x4(%esp)
80103047:	80 
80103048:	89 34 24             	mov    %esi,(%esp)
8010304b:	e8 d0 13 00 00       	call   80104420 <memcmp>
80103050:	85 c0                	test   %eax,%eax
80103052:	75 16                	jne    8010306a <mpsearch1+0x4a>
80103054:	31 c9                	xor    %ecx,%ecx
80103056:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103058:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010305c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010305f:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103061:	83 fa 10             	cmp    $0x10,%edx
80103064:	75 f2                	jne    80103058 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103066:	84 c9                	test   %cl,%cl
80103068:	74 10                	je     8010307a <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
8010306a:	83 c6 10             	add    $0x10,%esi
8010306d:	39 f3                	cmp    %esi,%ebx
8010306f:	77 c7                	ja     80103038 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80103071:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103074:	31 c0                	xor    %eax,%eax
}
80103076:	5b                   	pop    %ebx
80103077:	5e                   	pop    %esi
80103078:	5d                   	pop    %ebp
80103079:	c3                   	ret    
8010307a:	83 c4 10             	add    $0x10,%esp
8010307d:	89 f0                	mov    %esi,%eax
8010307f:	5b                   	pop    %ebx
80103080:	5e                   	pop    %esi
80103081:	5d                   	pop    %ebp
80103082:	c3                   	ret    
80103083:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103090 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103090:	55                   	push   %ebp
80103091:	89 e5                	mov    %esp,%ebp
80103093:	57                   	push   %edi
80103094:	56                   	push   %esi
80103095:	53                   	push   %ebx
80103096:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103099:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801030a0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801030a7:	c1 e0 08             	shl    $0x8,%eax
801030aa:	09 d0                	or     %edx,%eax
801030ac:	c1 e0 04             	shl    $0x4,%eax
801030af:	85 c0                	test   %eax,%eax
801030b1:	75 1b                	jne    801030ce <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801030b3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030ba:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030c1:	c1 e0 08             	shl    $0x8,%eax
801030c4:	09 d0                	or     %edx,%eax
801030c6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801030c9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
801030ce:	ba 00 04 00 00       	mov    $0x400,%edx
801030d3:	e8 48 ff ff ff       	call   80103020 <mpsearch1>
801030d8:	85 c0                	test   %eax,%eax
801030da:	89 c7                	mov    %eax,%edi
801030dc:	0f 84 4e 01 00 00    	je     80103230 <mpinit+0x1a0>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030e2:	8b 77 04             	mov    0x4(%edi),%esi
801030e5:	85 f6                	test   %esi,%esi
801030e7:	0f 84 ce 00 00 00    	je     801031bb <mpinit+0x12b>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030ed:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801030f3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801030fa:	00 
801030fb:	c7 44 24 04 2d 73 10 	movl   $0x8010732d,0x4(%esp)
80103102:	80 
80103103:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103106:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103109:	e8 12 13 00 00       	call   80104420 <memcmp>
8010310e:	85 c0                	test   %eax,%eax
80103110:	0f 85 a5 00 00 00    	jne    801031bb <mpinit+0x12b>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103116:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010311d:	3c 04                	cmp    $0x4,%al
8010311f:	0f 85 29 01 00 00    	jne    8010324e <mpinit+0x1be>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103125:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010312c:	85 c0                	test   %eax,%eax
8010312e:	74 1d                	je     8010314d <mpinit+0xbd>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
80103130:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103132:	31 d2                	xor    %edx,%edx
80103134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103138:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010313f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103140:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103143:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103145:	39 d0                	cmp    %edx,%eax
80103147:	7f ef                	jg     80103138 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103149:	84 c9                	test   %cl,%cl
8010314b:	75 6e                	jne    801031bb <mpinit+0x12b>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
8010314d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103150:	85 db                	test   %ebx,%ebx
80103152:	74 67                	je     801031bb <mpinit+0x12b>
    return;
  ismp = 1;
80103154:	c7 05 84 27 11 80 01 	movl   $0x1,0x80112784
8010315b:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
8010315e:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103164:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103169:	0f b7 8e 04 00 00 80 	movzwl -0x7ffffffc(%esi),%ecx
80103170:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103176:	01 d9                	add    %ebx,%ecx
80103178:	39 c8                	cmp    %ecx,%eax
8010317a:	0f 83 90 00 00 00    	jae    80103210 <mpinit+0x180>
    switch(*p){
80103180:	80 38 04             	cmpb   $0x4,(%eax)
80103183:	77 7b                	ja     80103200 <mpinit+0x170>
80103185:	0f b6 10             	movzbl (%eax),%edx
80103188:	ff 24 95 34 73 10 80 	jmp    *-0x7fef8ccc(,%edx,4)
8010318f:	90                   	nop
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103190:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103193:	39 c1                	cmp    %eax,%ecx
80103195:	77 e9                	ja     80103180 <mpinit+0xf0>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
80103197:	a1 84 27 11 80       	mov    0x80112784,%eax
8010319c:	85 c0                	test   %eax,%eax
8010319e:	75 70                	jne    80103210 <mpinit+0x180>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801031a0:	c7 05 80 2d 11 80 01 	movl   $0x1,0x80112d80
801031a7:	00 00 00 
    lapic = 0;
801031aa:	c7 05 9c 26 11 80 00 	movl   $0x0,0x8011269c
801031b1:	00 00 00 
    ioapicid = 0;
801031b4:	c6 05 80 27 11 80 00 	movb   $0x0,0x80112780
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801031bb:	83 c4 1c             	add    $0x1c,%esp
801031be:	5b                   	pop    %ebx
801031bf:	5e                   	pop    %esi
801031c0:	5f                   	pop    %edi
801031c1:	5d                   	pop    %ebp
801031c2:	c3                   	ret    
801031c3:	90                   	nop
801031c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801031c8:	8b 15 80 2d 11 80    	mov    0x80112d80,%edx
801031ce:	83 fa 07             	cmp    $0x7,%edx
801031d1:	7f 17                	jg     801031ea <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031d3:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
801031d7:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
        ncpu++;
801031dd:	83 05 80 2d 11 80 01 	addl   $0x1,0x80112d80
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031e4:	88 9a a0 27 11 80    	mov    %bl,-0x7feed860(%edx)
        ncpu++;
      }
      p += sizeof(struct mpproc);
801031ea:	83 c0 14             	add    $0x14,%eax
      continue;
801031ed:	eb a4                	jmp    80103193 <mpinit+0x103>
801031ef:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801031f0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031f4:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801031f7:	88 15 80 27 11 80    	mov    %dl,0x80112780
      p += sizeof(struct mpioapic);
      continue;
801031fd:	eb 94                	jmp    80103193 <mpinit+0x103>
801031ff:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103200:	c7 05 84 27 11 80 00 	movl   $0x0,0x80112784
80103207:	00 00 00 
      break;
8010320a:	eb 87                	jmp    80103193 <mpinit+0x103>
8010320c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
80103210:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
80103214:	74 a5                	je     801031bb <mpinit+0x12b>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103216:	ba 22 00 00 00       	mov    $0x22,%edx
8010321b:	b8 70 00 00 00       	mov    $0x70,%eax
80103220:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103221:	b2 23                	mov    $0x23,%dl
80103223:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103224:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103227:	ee                   	out    %al,(%dx)
  }
}
80103228:	83 c4 1c             	add    $0x1c,%esp
8010322b:	5b                   	pop    %ebx
8010322c:	5e                   	pop    %esi
8010322d:	5f                   	pop    %edi
8010322e:	5d                   	pop    %ebp
8010322f:	c3                   	ret    
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103230:	ba 00 00 01 00       	mov    $0x10000,%edx
80103235:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010323a:	e8 e1 fd ff ff       	call   80103020 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010323f:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103241:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103243:	0f 85 99 fe ff ff    	jne    801030e2 <mpinit+0x52>
80103249:	e9 6d ff ff ff       	jmp    801031bb <mpinit+0x12b>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
8010324e:	3c 01                	cmp    $0x1,%al
80103250:	0f 84 cf fe ff ff    	je     80103125 <mpinit+0x95>
80103256:	e9 60 ff ff ff       	jmp    801031bb <mpinit+0x12b>
8010325b:	66 90                	xchg   %ax,%ax
8010325d:	66 90                	xchg   %ax,%ax
8010325f:	90                   	nop

80103260 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103260:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
80103261:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103266:	89 e5                	mov    %esp,%ebp
80103268:	ba 21 00 00 00       	mov    $0x21,%edx
  picsetmask(irqmask & ~(1<<irq));
8010326d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103270:	d3 c0                	rol    %cl,%eax
80103272:	66 23 05 00 a0 10 80 	and    0x8010a000,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
80103279:	66 a3 00 a0 10 80    	mov    %ax,0x8010a000
8010327f:	ee                   	out    %al,(%dx)
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
80103280:	66 c1 e8 08          	shr    $0x8,%ax
80103284:	b2 a1                	mov    $0xa1,%dl
80103286:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
80103287:	5d                   	pop    %ebp
80103288:	c3                   	ret    
80103289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103290 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103290:	55                   	push   %ebp
80103291:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103296:	89 e5                	mov    %esp,%ebp
80103298:	57                   	push   %edi
80103299:	56                   	push   %esi
8010329a:	53                   	push   %ebx
8010329b:	bb 21 00 00 00       	mov    $0x21,%ebx
801032a0:	89 da                	mov    %ebx,%edx
801032a2:	ee                   	out    %al,(%dx)
801032a3:	b9 a1 00 00 00       	mov    $0xa1,%ecx
801032a8:	89 ca                	mov    %ecx,%edx
801032aa:	ee                   	out    %al,(%dx)
801032ab:	bf 11 00 00 00       	mov    $0x11,%edi
801032b0:	be 20 00 00 00       	mov    $0x20,%esi
801032b5:	89 f8                	mov    %edi,%eax
801032b7:	89 f2                	mov    %esi,%edx
801032b9:	ee                   	out    %al,(%dx)
801032ba:	b8 20 00 00 00       	mov    $0x20,%eax
801032bf:	89 da                	mov    %ebx,%edx
801032c1:	ee                   	out    %al,(%dx)
801032c2:	b8 04 00 00 00       	mov    $0x4,%eax
801032c7:	ee                   	out    %al,(%dx)
801032c8:	b8 03 00 00 00       	mov    $0x3,%eax
801032cd:	ee                   	out    %al,(%dx)
801032ce:	b3 a0                	mov    $0xa0,%bl
801032d0:	89 f8                	mov    %edi,%eax
801032d2:	89 da                	mov    %ebx,%edx
801032d4:	ee                   	out    %al,(%dx)
801032d5:	b8 28 00 00 00       	mov    $0x28,%eax
801032da:	89 ca                	mov    %ecx,%edx
801032dc:	ee                   	out    %al,(%dx)
801032dd:	b8 02 00 00 00       	mov    $0x2,%eax
801032e2:	ee                   	out    %al,(%dx)
801032e3:	b8 03 00 00 00       	mov    $0x3,%eax
801032e8:	ee                   	out    %al,(%dx)
801032e9:	bf 68 00 00 00       	mov    $0x68,%edi
801032ee:	89 f2                	mov    %esi,%edx
801032f0:	89 f8                	mov    %edi,%eax
801032f2:	ee                   	out    %al,(%dx)
801032f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
801032f8:	89 c8                	mov    %ecx,%eax
801032fa:	ee                   	out    %al,(%dx)
801032fb:	89 f8                	mov    %edi,%eax
801032fd:	89 da                	mov    %ebx,%edx
801032ff:	ee                   	out    %al,(%dx)
80103300:	89 c8                	mov    %ecx,%eax
80103302:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
80103303:	0f b7 05 00 a0 10 80 	movzwl 0x8010a000,%eax
8010330a:	66 83 f8 ff          	cmp    $0xffff,%ax
8010330e:	74 0a                	je     8010331a <picinit+0x8a>
80103310:	b2 21                	mov    $0x21,%dl
80103312:	ee                   	out    %al,(%dx)
static void
picsetmask(ushort mask)
{
  irqmask = mask;
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
80103313:	66 c1 e8 08          	shr    $0x8,%ax
80103317:	b2 a1                	mov    $0xa1,%dl
80103319:	ee                   	out    %al,(%dx)
  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    picsetmask(irqmask);
}
8010331a:	5b                   	pop    %ebx
8010331b:	5e                   	pop    %esi
8010331c:	5f                   	pop    %edi
8010331d:	5d                   	pop    %ebp
8010331e:	c3                   	ret    
8010331f:	90                   	nop

80103320 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	57                   	push   %edi
80103324:	56                   	push   %esi
80103325:	53                   	push   %ebx
80103326:	83 ec 1c             	sub    $0x1c,%esp
80103329:	8b 75 08             	mov    0x8(%ebp),%esi
8010332c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010332f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103335:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010333b:	e8 90 da ff ff       	call   80100dd0 <filealloc>
80103340:	85 c0                	test   %eax,%eax
80103342:	89 06                	mov    %eax,(%esi)
80103344:	0f 84 a4 00 00 00    	je     801033ee <pipealloc+0xce>
8010334a:	e8 81 da ff ff       	call   80100dd0 <filealloc>
8010334f:	85 c0                	test   %eax,%eax
80103351:	89 03                	mov    %eax,(%ebx)
80103353:	0f 84 87 00 00 00    	je     801033e0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103359:	e8 a2 f1 ff ff       	call   80102500 <kalloc>
8010335e:	85 c0                	test   %eax,%eax
80103360:	89 c7                	mov    %eax,%edi
80103362:	74 7c                	je     801033e0 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
80103364:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010336b:	00 00 00 
  p->writeopen = 1;
8010336e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103375:	00 00 00 
  p->nwrite = 0;
80103378:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010337f:	00 00 00 
  p->nread = 0;
80103382:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103389:	00 00 00 
  initlock(&p->lock, "pipe");
8010338c:	89 04 24             	mov    %eax,(%esp)
8010338f:	c7 44 24 04 48 73 10 	movl   $0x80107348,0x4(%esp)
80103396:	80 
80103397:	e8 34 0e 00 00       	call   801041d0 <initlock>
  (*f0)->type = FD_PIPE;
8010339c:	8b 06                	mov    (%esi),%eax
8010339e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801033a4:	8b 06                	mov    (%esi),%eax
801033a6:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801033aa:	8b 06                	mov    (%esi),%eax
801033ac:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801033b0:	8b 06                	mov    (%esi),%eax
801033b2:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801033b5:	8b 03                	mov    (%ebx),%eax
801033b7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801033bd:	8b 03                	mov    (%ebx),%eax
801033bf:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801033c3:	8b 03                	mov    (%ebx),%eax
801033c5:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801033c9:	8b 03                	mov    (%ebx),%eax
  return 0;
801033cb:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
801033cd:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801033d0:	83 c4 1c             	add    $0x1c,%esp
801033d3:	89 d8                	mov    %ebx,%eax
801033d5:	5b                   	pop    %ebx
801033d6:	5e                   	pop    %esi
801033d7:	5f                   	pop    %edi
801033d8:	5d                   	pop    %ebp
801033d9:	c3                   	ret    
801033da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801033e0:	8b 06                	mov    (%esi),%eax
801033e2:	85 c0                	test   %eax,%eax
801033e4:	74 08                	je     801033ee <pipealloc+0xce>
    fileclose(*f0);
801033e6:	89 04 24             	mov    %eax,(%esp)
801033e9:	e8 a2 da ff ff       	call   80100e90 <fileclose>
  if(*f1)
801033ee:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
801033f0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
801033f5:	85 c0                	test   %eax,%eax
801033f7:	74 d7                	je     801033d0 <pipealloc+0xb0>
    fileclose(*f1);
801033f9:	89 04 24             	mov    %eax,(%esp)
801033fc:	e8 8f da ff ff       	call   80100e90 <fileclose>
  return -1;
}
80103401:	83 c4 1c             	add    $0x1c,%esp
80103404:	89 d8                	mov    %ebx,%eax
80103406:	5b                   	pop    %ebx
80103407:	5e                   	pop    %esi
80103408:	5f                   	pop    %edi
80103409:	5d                   	pop    %ebp
8010340a:	c3                   	ret    
8010340b:	90                   	nop
8010340c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103410 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	56                   	push   %esi
80103414:	53                   	push   %ebx
80103415:	83 ec 10             	sub    $0x10,%esp
80103418:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010341b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010341e:	89 1c 24             	mov    %ebx,(%esp)
80103421:	e8 2a 0e 00 00       	call   80104250 <acquire>
  if(writable){
80103426:	85 f6                	test   %esi,%esi
80103428:	74 3e                	je     80103468 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010342a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103430:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103437:	00 00 00 
    wakeup(&p->nread);
8010343a:	89 04 24             	mov    %eax,(%esp)
8010343d:	e8 ce 0a 00 00       	call   80103f10 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103442:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103448:	85 d2                	test   %edx,%edx
8010344a:	75 0a                	jne    80103456 <pipeclose+0x46>
8010344c:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103452:	85 c0                	test   %eax,%eax
80103454:	74 32                	je     80103488 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103456:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103459:	83 c4 10             	add    $0x10,%esp
8010345c:	5b                   	pop    %ebx
8010345d:	5e                   	pop    %esi
8010345e:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010345f:	e9 1c 0f 00 00       	jmp    80104380 <release>
80103464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103468:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
8010346e:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103475:	00 00 00 
    wakeup(&p->nwrite);
80103478:	89 04 24             	mov    %eax,(%esp)
8010347b:	e8 90 0a 00 00       	call   80103f10 <wakeup>
80103480:	eb c0                	jmp    80103442 <pipeclose+0x32>
80103482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103488:	89 1c 24             	mov    %ebx,(%esp)
8010348b:	e8 f0 0e 00 00       	call   80104380 <release>
    kfree((char*)p);
80103490:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
80103493:	83 c4 10             	add    $0x10,%esp
80103496:	5b                   	pop    %ebx
80103497:	5e                   	pop    %esi
80103498:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103499:	e9 b2 ee ff ff       	jmp    80102350 <kfree>
8010349e:	66 90                	xchg   %ax,%ax

801034a0 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	57                   	push   %edi
801034a4:	56                   	push   %esi
801034a5:	53                   	push   %ebx
801034a6:	83 ec 1c             	sub    $0x1c,%esp
801034a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
801034ac:	89 3c 24             	mov    %edi,(%esp)
801034af:	e8 9c 0d 00 00       	call   80104250 <acquire>
  for(i = 0; i < n; i++){
801034b4:	8b 45 10             	mov    0x10(%ebp),%eax
801034b7:	85 c0                	test   %eax,%eax
801034b9:	0f 8e c2 00 00 00    	jle    80103581 <pipewrite+0xe1>
801034bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801034c2:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
801034c8:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
801034ce:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
801034d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801034d7:	03 45 10             	add    0x10(%ebp),%eax
801034da:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034dd:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801034e3:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801034e9:	39 d1                	cmp    %edx,%ecx
801034eb:	0f 85 c4 00 00 00    	jne    801035b5 <pipewrite+0x115>
      if(p->readopen == 0 || proc->killed){
801034f1:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
801034f7:	85 d2                	test   %edx,%edx
801034f9:	0f 84 a1 00 00 00    	je     801035a0 <pipewrite+0x100>
801034ff:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103506:	8b 42 24             	mov    0x24(%edx),%eax
80103509:	85 c0                	test   %eax,%eax
8010350b:	74 22                	je     8010352f <pipewrite+0x8f>
8010350d:	e9 8e 00 00 00       	jmp    801035a0 <pipewrite+0x100>
80103512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103518:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
8010351e:	85 c0                	test   %eax,%eax
80103520:	74 7e                	je     801035a0 <pipewrite+0x100>
80103522:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103528:	8b 48 24             	mov    0x24(%eax),%ecx
8010352b:	85 c9                	test   %ecx,%ecx
8010352d:	75 71                	jne    801035a0 <pipewrite+0x100>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010352f:	89 34 24             	mov    %esi,(%esp)
80103532:	e8 d9 09 00 00       	call   80103f10 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103537:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010353b:	89 1c 24             	mov    %ebx,(%esp)
8010353e:	e8 1d 08 00 00       	call   80103d60 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103543:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
80103549:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
8010354f:	05 00 02 00 00       	add    $0x200,%eax
80103554:	39 c2                	cmp    %eax,%edx
80103556:	74 c0                	je     80103518 <pipewrite+0x78>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103558:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010355b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010355e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103564:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
8010356a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010356e:	0f b6 00             	movzbl (%eax),%eax
80103571:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103575:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103578:	3b 45 e0             	cmp    -0x20(%ebp),%eax
8010357b:	0f 85 5c ff ff ff    	jne    801034dd <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103581:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
80103587:	89 14 24             	mov    %edx,(%esp)
8010358a:	e8 81 09 00 00       	call   80103f10 <wakeup>
  release(&p->lock);
8010358f:	89 3c 24             	mov    %edi,(%esp)
80103592:	e8 e9 0d 00 00       	call   80104380 <release>
  return n;
80103597:	8b 45 10             	mov    0x10(%ebp),%eax
8010359a:	eb 11                	jmp    801035ad <pipewrite+0x10d>
8010359c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
801035a0:	89 3c 24             	mov    %edi,(%esp)
801035a3:	e8 d8 0d 00 00       	call   80104380 <release>
        return -1;
801035a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801035ad:	83 c4 1c             	add    $0x1c,%esp
801035b0:	5b                   	pop    %ebx
801035b1:	5e                   	pop    %esi
801035b2:	5f                   	pop    %edi
801035b3:	5d                   	pop    %ebp
801035b4:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035b5:	89 ca                	mov    %ecx,%edx
801035b7:	eb 9f                	jmp    80103558 <pipewrite+0xb8>
801035b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801035c0 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	57                   	push   %edi
801035c4:	56                   	push   %esi
801035c5:	53                   	push   %ebx
801035c6:	83 ec 1c             	sub    $0x1c,%esp
801035c9:	8b 75 08             	mov    0x8(%ebp),%esi
801035cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801035cf:	89 34 24             	mov    %esi,(%esp)
801035d2:	e8 79 0c 00 00       	call   80104250 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035d7:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801035dd:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801035e3:	75 5b                	jne    80103640 <piperead+0x80>
801035e5:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801035eb:	85 db                	test   %ebx,%ebx
801035ed:	74 51                	je     80103640 <piperead+0x80>
801035ef:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801035f5:	eb 25                	jmp    8010361c <piperead+0x5c>
801035f7:	90                   	nop
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801035f8:	89 74 24 04          	mov    %esi,0x4(%esp)
801035fc:	89 1c 24             	mov    %ebx,(%esp)
801035ff:	e8 5c 07 00 00       	call   80103d60 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103604:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010360a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103610:	75 2e                	jne    80103640 <piperead+0x80>
80103612:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103618:	85 d2                	test   %edx,%edx
8010361a:	74 24                	je     80103640 <piperead+0x80>
    if(proc->killed){
8010361c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103622:	8b 48 24             	mov    0x24(%eax),%ecx
80103625:	85 c9                	test   %ecx,%ecx
80103627:	74 cf                	je     801035f8 <piperead+0x38>
      release(&p->lock);
80103629:	89 34 24             	mov    %esi,(%esp)
8010362c:	e8 4f 0d 00 00       	call   80104380 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103631:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      return -1;
80103634:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103639:	5b                   	pop    %ebx
8010363a:	5e                   	pop    %esi
8010363b:	5f                   	pop    %edi
8010363c:	5d                   	pop    %ebp
8010363d:	c3                   	ret    
8010363e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103640:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103643:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103645:	85 d2                	test   %edx,%edx
80103647:	7f 2b                	jg     80103674 <piperead+0xb4>
80103649:	eb 31                	jmp    8010367c <piperead+0xbc>
8010364b:	90                   	nop
8010364c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103650:	8d 48 01             	lea    0x1(%eax),%ecx
80103653:	25 ff 01 00 00       	and    $0x1ff,%eax
80103658:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010365e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103663:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103666:	83 c3 01             	add    $0x1,%ebx
80103669:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010366c:	74 0e                	je     8010367c <piperead+0xbc>
    if(p->nread == p->nwrite)
8010366e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103674:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010367a:	75 d4                	jne    80103650 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010367c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103682:	89 04 24             	mov    %eax,(%esp)
80103685:	e8 86 08 00 00       	call   80103f10 <wakeup>
  release(&p->lock);
8010368a:	89 34 24             	mov    %esi,(%esp)
8010368d:	e8 ee 0c 00 00       	call   80104380 <release>
  return i;
}
80103692:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
80103695:	89 d8                	mov    %ebx,%eax
}
80103697:	5b                   	pop    %ebx
80103698:	5e                   	pop    %esi
80103699:	5f                   	pop    %edi
8010369a:	5d                   	pop    %ebp
8010369b:	c3                   	ret    
8010369c:	66 90                	xchg   %ax,%ax
8010369e:	66 90                	xchg   %ax,%ax

801036a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036a4:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801036a9:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801036ac:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801036b3:	e8 98 0b 00 00       	call   80104250 <acquire>
801036b8:	eb 11                	jmp    801036cb <allocproc+0x2b>
801036ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036c0:	83 eb 80             	sub    $0xffffff80,%ebx
801036c3:	81 fb d4 4d 11 80    	cmp    $0x80114dd4,%ebx
801036c9:	74 7d                	je     80103748 <allocproc+0xa8>
    if(p->state == UNUSED)
801036cb:	8b 43 0c             	mov    0xc(%ebx),%eax
801036ce:	85 c0                	test   %eax,%eax
801036d0:	75 ee                	jne    801036c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801036d2:	a1 08 a0 10 80       	mov    0x8010a008,%eax

  release(&ptable.lock);
801036d7:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801036de:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801036e5:	8d 50 01             	lea    0x1(%eax),%edx
801036e8:	89 15 08 a0 10 80    	mov    %edx,0x8010a008
801036ee:	89 43 10             	mov    %eax,0x10(%ebx)

  release(&ptable.lock);
801036f1:	e8 8a 0c 00 00       	call   80104380 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801036f6:	e8 05 ee ff ff       	call   80102500 <kalloc>
801036fb:	85 c0                	test   %eax,%eax
801036fd:	89 43 08             	mov    %eax,0x8(%ebx)
80103700:	74 5a                	je     8010375c <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103702:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103708:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010370d:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103710:	c7 40 14 7d 55 10 80 	movl   $0x8010557d,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103717:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010371e:	00 
8010371f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103726:	00 
80103727:	89 04 24             	mov    %eax,(%esp)
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
8010372a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010372d:	e8 9e 0c 00 00       	call   801043d0 <memset>
  p->context->eip = (uint)forkret;
80103732:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103735:	c7 40 10 70 37 10 80 	movl   $0x80103770,0x10(%eax)

  return p;
8010373c:	89 d8                	mov    %ebx,%eax
}
8010373e:	83 c4 14             	add    $0x14,%esp
80103741:	5b                   	pop    %ebx
80103742:	5d                   	pop    %ebp
80103743:	c3                   	ret    
80103744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103748:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010374f:	e8 2c 0c 00 00       	call   80104380 <release>
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103754:	83 c4 14             	add    $0x14,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
80103757:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103759:	5b                   	pop    %ebx
8010375a:	5d                   	pop    %ebp
8010375b:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010375c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103763:	eb d9                	jmp    8010373e <allocproc+0x9e>
80103765:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103770 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103776:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010377d:	e8 fe 0b 00 00       	call   80104380 <release>

  if (first) {
80103782:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103787:	85 c0                	test   %eax,%eax
80103789:	75 05                	jne    80103790 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010378b:	c9                   	leave  
8010378c:	c3                   	ret    
8010378d:	8d 76 00             	lea    0x0(%esi),%esi
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103790:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103797:	c7 05 04 a0 10 80 00 	movl   $0x0,0x8010a004
8010379e:	00 00 00 
    iinit(ROOTDEV);
801037a1:	e8 3a dd ff ff       	call   801014e0 <iinit>
    initlog(ROOTDEV);
801037a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801037ad:	e8 9e f3 ff ff       	call   80102b50 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
801037b2:	c9                   	leave  
801037b3:	c3                   	ret    
801037b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801037c0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801037c6:	c7 44 24 04 4d 73 10 	movl   $0x8010734d,0x4(%esp)
801037cd:	80 
801037ce:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801037d5:	e8 f6 09 00 00       	call   801041d0 <initlock>
}
801037da:	c9                   	leave  
801037db:	c3                   	ret    
801037dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801037e0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	53                   	push   %ebx
801037e4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801037e7:	e8 b4 fe ff ff       	call   801036a0 <allocproc>
801037ec:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
801037ee:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
  if((p->pgdir = setupkvm()) == 0)
801037f3:	e8 a8 2f 00 00       	call   801067a0 <setupkvm>
801037f8:	85 c0                	test   %eax,%eax
801037fa:	89 43 04             	mov    %eax,0x4(%ebx)
801037fd:	0f 84 d4 00 00 00    	je     801038d7 <userinit+0xf7>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103803:	89 04 24             	mov    %eax,(%esp)
80103806:	c7 44 24 08 30 00 00 	movl   $0x30,0x8(%esp)
8010380d:	00 
8010380e:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103815:	80 
80103816:	e8 15 31 00 00       	call   80106930 <inituvm>
  p->sz = PGSIZE;
8010381b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103821:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103828:	00 
80103829:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103830:	00 
80103831:	8b 43 18             	mov    0x18(%ebx),%eax
80103834:	89 04 24             	mov    %eax,(%esp)
80103837:	e8 94 0b 00 00       	call   801043d0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010383c:	8b 43 18             	mov    0x18(%ebx),%eax
8010383f:	ba 23 00 00 00       	mov    $0x23,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103844:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103849:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010384d:	8b 43 18             	mov    0x18(%ebx),%eax
80103850:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103854:	8b 43 18             	mov    0x18(%ebx),%eax
80103857:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010385b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010385f:	8b 43 18             	mov    0x18(%ebx),%eax
80103862:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103866:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010386a:	8b 43 18             	mov    0x18(%ebx),%eax
8010386d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103874:	8b 43 18             	mov    0x18(%ebx),%eax
80103877:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010387e:	8b 43 18             	mov    0x18(%ebx),%eax
80103881:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103888:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010388b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103892:	00 
80103893:	c7 44 24 04 6d 73 10 	movl   $0x8010736d,0x4(%esp)
8010389a:	80 
8010389b:	89 04 24             	mov    %eax,(%esp)
8010389e:	e8 0d 0d 00 00       	call   801045b0 <safestrcpy>
  p->cwd = namei("/");
801038a3:	c7 04 24 76 73 10 80 	movl   $0x80107376,(%esp)
801038aa:	e8 a1 e6 ff ff       	call   80101f50 <namei>
801038af:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801038b2:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801038b9:	e8 92 09 00 00       	call   80104250 <acquire>

  p->state = RUNNABLE;
801038be:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
801038c5:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801038cc:	e8 af 0a 00 00       	call   80104380 <release>
}
801038d1:	83 c4 14             	add    $0x14,%esp
801038d4:	5b                   	pop    %ebx
801038d5:	5d                   	pop    %ebp
801038d6:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
801038d7:	c7 04 24 54 73 10 80 	movl   $0x80107354,(%esp)
801038de:	e8 7d ca ff ff       	call   80100360 <panic>
801038e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038f0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	83 ec 18             	sub    $0x18,%esp
  uint sz;

  sz = proc->sz;
801038f6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801038fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint sz;

  sz = proc->sz;
80103900:	8b 02                	mov    (%edx),%eax
  if(n > 0){
80103902:	83 f9 00             	cmp    $0x0,%ecx
80103905:	7e 39                	jle    80103940 <growproc+0x50>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80103907:	01 c1                	add    %eax,%ecx
80103909:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010390d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103911:	8b 42 04             	mov    0x4(%edx),%eax
80103914:	89 04 24             	mov    %eax,(%esp)
80103917:	e8 54 31 00 00       	call   80106a70 <allocuvm>
8010391c:	85 c0                	test   %eax,%eax
8010391e:	74 40                	je     80103960 <growproc+0x70>
80103920:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
80103927:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
80103929:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010392f:	89 04 24             	mov    %eax,(%esp)
80103932:	e8 29 2f 00 00       	call   80106860 <switchuvm>
  return 0;
80103937:	31 c0                	xor    %eax,%eax
}
80103939:	c9                   	leave  
8010393a:	c3                   	ret    
8010393b:	90                   	nop
8010393c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103940:	74 e5                	je     80103927 <growproc+0x37>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80103942:	01 c1                	add    %eax,%ecx
80103944:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80103948:	89 44 24 04          	mov    %eax,0x4(%esp)
8010394c:	8b 42 04             	mov    0x4(%edx),%eax
8010394f:	89 04 24             	mov    %eax,(%esp)
80103952:	e8 09 32 00 00       	call   80106b60 <deallocuvm>
80103957:	85 c0                	test   %eax,%eax
80103959:	75 c5                	jne    80103920 <growproc+0x30>
8010395b:	90                   	nop
8010395c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint sz;

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
80103960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}
80103965:	c9                   	leave  
80103966:	c3                   	ret    
80103967:	89 f6                	mov    %esi,%esi
80103969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103970 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	57                   	push   %edi
80103974:	56                   	push   %esi
80103975:	53                   	push   %ebx
80103976:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
80103979:	e8 22 fd ff ff       	call   801036a0 <allocproc>
8010397e:	85 c0                	test   %eax,%eax
80103980:	89 c3                	mov    %eax,%ebx
80103982:	0f 84 d5 00 00 00    	je     80103a5d <fork+0xed>
    return -1;
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80103988:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010398e:	8b 10                	mov    (%eax),%edx
80103990:	89 54 24 04          	mov    %edx,0x4(%esp)
80103994:	8b 40 04             	mov    0x4(%eax),%eax
80103997:	89 04 24             	mov    %eax,(%esp)
8010399a:	e8 91 32 00 00       	call   80106c30 <copyuvm>
8010399f:	85 c0                	test   %eax,%eax
801039a1:	89 43 04             	mov    %eax,0x4(%ebx)
801039a4:	0f 84 ba 00 00 00    	je     80103a64 <fork+0xf4>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
801039aa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent = proc;
  *np->tf = *proc->tf;
801039b0:	b9 13 00 00 00       	mov    $0x13,%ecx
801039b5:	8b 7b 18             	mov    0x18(%ebx),%edi
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
801039b8:	8b 00                	mov    (%eax),%eax
801039ba:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
801039bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801039c2:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
801039c5:	8b 70 18             	mov    0x18(%eax),%esi
801039c8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801039ca:	31 f6                	xor    %esi,%esi
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801039cc:	8b 43 18             	mov    0x18(%ebx),%eax
801039cf:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801039d6:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801039dd:	8d 76 00             	lea    0x0(%esi),%esi

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
801039e0:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
801039e4:	85 c0                	test   %eax,%eax
801039e6:	74 13                	je     801039fb <fork+0x8b>
      np->ofile[i] = filedup(proc->ofile[i]);
801039e8:	89 04 24             	mov    %eax,(%esp)
801039eb:	e8 50 d4 ff ff       	call   80100e40 <filedup>
801039f0:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
801039f4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801039fb:	83 c6 01             	add    $0x1,%esi
801039fe:	83 fe 10             	cmp    $0x10,%esi
80103a01:	75 dd                	jne    801039e0 <fork+0x70>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80103a03:	8b 42 68             	mov    0x68(%edx),%eax
80103a06:	89 04 24             	mov    %eax,(%esp)
80103a09:	e8 e2 dc ff ff       	call   801016f0 <idup>
80103a0e:	89 43 68             	mov    %eax,0x68(%ebx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80103a11:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a17:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103a1e:	00 
80103a1f:	83 c0 6c             	add    $0x6c,%eax
80103a22:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a26:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a29:	89 04 24             	mov    %eax,(%esp)
80103a2c:	e8 7f 0b 00 00       	call   801045b0 <safestrcpy>

  pid = np->pid;
80103a31:	8b 73 10             	mov    0x10(%ebx),%esi

  acquire(&ptable.lock);
80103a34:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103a3b:	e8 10 08 00 00       	call   80104250 <acquire>

  np->state = RUNNABLE;
80103a40:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103a47:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103a4e:	e8 2d 09 00 00       	call   80104380 <release>

  return pid;
80103a53:	89 f0                	mov    %esi,%eax
}
80103a55:	83 c4 1c             	add    $0x1c,%esp
80103a58:	5b                   	pop    %ebx
80103a59:	5e                   	pop    %esi
80103a5a:	5f                   	pop    %edi
80103a5b:	5d                   	pop    %ebp
80103a5c:	c3                   	ret    
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103a5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a62:	eb f1                	jmp    80103a55 <fork+0xe5>
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
80103a64:	8b 43 08             	mov    0x8(%ebx),%eax
80103a67:	89 04 24             	mov    %eax,(%esp)
80103a6a:	e8 e1 e8 ff ff       	call   80102350 <kfree>
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
80103a6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
80103a74:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103a7b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103a82:	eb d1                	jmp    80103a55 <fork+0xe5>
80103a84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a90 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	53                   	push   %ebx
80103a94:	83 ec 14             	sub    $0x14,%esp
80103a97:	90                   	nop
}

static inline void
sti(void)
{
  asm volatile("sti");
80103a98:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a99:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103aa0:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103aa5:	e8 a6 07 00 00       	call   80104250 <acquire>
80103aaa:	eb 0f                	jmp    80103abb <scheduler+0x2b>
80103aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ab0:	83 eb 80             	sub    $0xffffff80,%ebx
80103ab3:	81 fb d4 4d 11 80    	cmp    $0x80114dd4,%ebx
80103ab9:	74 55                	je     80103b10 <scheduler+0x80>
      if(p->state != RUNNABLE)
80103abb:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103abf:	75 ef                	jne    80103ab0 <scheduler+0x20>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103ac1:	89 1c 24             	mov    %ebx,(%esp)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80103ac4:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103acb:	83 eb 80             	sub    $0xffffff80,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103ace:	e8 8d 2d 00 00       	call   80106860 <switchuvm>
      p->state = RUNNING;
      swtch(&cpu->scheduler, p->context);
80103ad3:	8b 43 9c             	mov    -0x64(%ebx),%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103ad6:	c7 43 8c 04 00 00 00 	movl   $0x4,-0x74(%ebx)
      swtch(&cpu->scheduler, p->context);
80103add:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ae1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103ae7:	83 c0 04             	add    $0x4,%eax
80103aea:	89 04 24             	mov    %eax,(%esp)
80103aed:	e8 19 0b 00 00       	call   8010460b <swtch>
      switchkvm();
80103af2:	e8 49 2d 00 00       	call   80106840 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103af7:	81 fb d4 4d 11 80    	cmp    $0x80114dd4,%ebx
      swtch(&cpu->scheduler, p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103afd:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103b04:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b08:	75 b1                	jne    80103abb <scheduler+0x2b>
80103b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80103b10:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103b17:	e8 64 08 00 00       	call   80104380 <release>

  }
80103b1c:	e9 77 ff ff ff       	jmp    80103a98 <scheduler+0x8>
80103b21:	eb 0d                	jmp    80103b30 <sched>
80103b23:	90                   	nop
80103b24:	90                   	nop
80103b25:	90                   	nop
80103b26:	90                   	nop
80103b27:	90                   	nop
80103b28:	90                   	nop
80103b29:	90                   	nop
80103b2a:	90                   	nop
80103b2b:	90                   	nop
80103b2c:	90                   	nop
80103b2d:	90                   	nop
80103b2e:	90                   	nop
80103b2f:	90                   	nop

80103b30 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	53                   	push   %ebx
80103b34:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
80103b37:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103b3e:	e8 9d 07 00 00       	call   801042e0 <holding>
80103b43:	85 c0                	test   %eax,%eax
80103b45:	74 4d                	je     80103b94 <sched+0x64>
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
80103b47:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103b4d:	83 b8 ac 00 00 00 01 	cmpl   $0x1,0xac(%eax)
80103b54:	75 62                	jne    80103bb8 <sched+0x88>
    panic("sched locks");
  if(proc->state == RUNNING)
80103b56:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103b5d:	83 7a 0c 04          	cmpl   $0x4,0xc(%edx)
80103b61:	74 49                	je     80103bac <sched+0x7c>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b63:	9c                   	pushf  
80103b64:	59                   	pop    %ecx
    panic("sched running");
  if(readeflags()&FL_IF)
80103b65:	80 e5 02             	and    $0x2,%ch
80103b68:	75 36                	jne    80103ba0 <sched+0x70>
    panic("sched interruptible");
  intena = cpu->intena;
80103b6a:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
  swtch(&proc->context, cpu->scheduler);
80103b70:	83 c2 1c             	add    $0x1c,%edx
80103b73:	8b 40 04             	mov    0x4(%eax),%eax
80103b76:	89 14 24             	mov    %edx,(%esp)
80103b79:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b7d:	e8 89 0a 00 00       	call   8010460b <swtch>
  cpu->intena = intena;
80103b82:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103b88:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80103b8e:	83 c4 14             	add    $0x14,%esp
80103b91:	5b                   	pop    %ebx
80103b92:	5d                   	pop    %ebp
80103b93:	c3                   	ret    
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103b94:	c7 04 24 78 73 10 80 	movl   $0x80107378,(%esp)
80103b9b:	e8 c0 c7 ff ff       	call   80100360 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103ba0:	c7 04 24 a4 73 10 80 	movl   $0x801073a4,(%esp)
80103ba7:	e8 b4 c7 ff ff       	call   80100360 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
80103bac:	c7 04 24 96 73 10 80 	movl   $0x80107396,(%esp)
80103bb3:	e8 a8 c7 ff ff       	call   80100360 <panic>
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
80103bb8:	c7 04 24 8a 73 10 80 	movl   $0x8010738a,(%esp)
80103bbf:	e8 9c c7 ff ff       	call   80100360 <panic>
80103bc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103bd0 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(int status)
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	57                   	push   %edi
80103bd4:	56                   	push   %esi
80103bd5:	53                   	push   %ebx
  struct proc *p;
  int fd;
  cprintf("status: %d\n", status);

  if(proc == initproc)
80103bd6:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(int status)
{
80103bd8:	83 ec 1c             	sub    $0x1c,%esp
80103bdb:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct proc *p;
  int fd;
  cprintf("status: %d\n", status);
80103bde:	c7 04 24 b8 73 10 80 	movl   $0x801073b8,(%esp)
80103be5:	89 7c 24 04          	mov    %edi,0x4(%esp)
80103be9:	e8 62 ca ff ff       	call   80100650 <cprintf>

  if(proc == initproc)
80103bee:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103bf5:	3b 15 bc a5 10 80    	cmp    0x8010a5bc,%edx
80103bfb:	0f 84 0d 01 00 00    	je     80103d0e <exit+0x13e>
80103c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
80103c08:	8d 73 08             	lea    0x8(%ebx),%esi
80103c0b:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
80103c0f:	85 c0                	test   %eax,%eax
80103c11:	74 17                	je     80103c2a <exit+0x5a>
      fileclose(proc->ofile[fd]);
80103c13:	89 04 24             	mov    %eax,(%esp)
80103c16:	e8 75 d2 ff ff       	call   80100e90 <fileclose>
      proc->ofile[fd] = 0;
80103c1b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103c22:	c7 44 b2 08 00 00 00 	movl   $0x0,0x8(%edx,%esi,4)
80103c29:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103c2a:	83 c3 01             	add    $0x1,%ebx
80103c2d:	83 fb 10             	cmp    $0x10,%ebx
80103c30:	75 d6                	jne    80103c08 <exit+0x38>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80103c32:	e8 b9 ef ff ff       	call   80102bf0 <begin_op>
  iput(proc->cwd);
80103c37:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103c3d:	8b 40 68             	mov    0x68(%eax),%eax
80103c40:	89 04 24             	mov    %eax,(%esp)
80103c43:	e8 e8 db ff ff       	call   80101830 <iput>
  end_op();
80103c48:	e8 13 f0 ff ff       	call   80102c60 <end_op>
  proc->cwd = 0;
80103c4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103c53:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  proc->status = status;
80103c5a:	89 78 7c             	mov    %edi,0x7c(%eax)

  acquire(&ptable.lock);
80103c5d:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103c64:	e8 e7 05 00 00       	call   80104250 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103c69:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c70:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
  proc->status = status;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103c75:	8b 51 14             	mov    0x14(%ecx),%edx
80103c78:	eb 10                	jmp    80103c8a <exit+0xba>
80103c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c80:	83 e8 80             	sub    $0xffffff80,%eax
80103c83:	3d d4 4d 11 80       	cmp    $0x80114dd4,%eax
80103c88:	74 1c                	je     80103ca6 <exit+0xd6>
    if(p->state == SLEEPING && p->chan == chan)
80103c8a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103c8e:	75 f0                	jne    80103c80 <exit+0xb0>
80103c90:	3b 50 20             	cmp    0x20(%eax),%edx
80103c93:	75 eb                	jne    80103c80 <exit+0xb0>
      p->state = RUNNABLE;
80103c95:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c9c:	83 e8 80             	sub    $0xffffff80,%eax
80103c9f:	3d d4 4d 11 80       	cmp    $0x80114dd4,%eax
80103ca4:	75 e4                	jne    80103c8a <exit+0xba>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103ca6:	8b 1d bc a5 10 80    	mov    0x8010a5bc,%ebx
80103cac:	ba d4 2d 11 80       	mov    $0x80112dd4,%edx
80103cb1:	eb 10                	jmp    80103cc3 <exit+0xf3>
80103cb3:	90                   	nop
80103cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cb8:	83 ea 80             	sub    $0xffffff80,%edx
80103cbb:	81 fa d4 4d 11 80    	cmp    $0x80114dd4,%edx
80103cc1:	74 33                	je     80103cf6 <exit+0x126>
    if(p->parent == proc){
80103cc3:	3b 4a 14             	cmp    0x14(%edx),%ecx
80103cc6:	75 f0                	jne    80103cb8 <exit+0xe8>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103cc8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103ccc:	89 5a 14             	mov    %ebx,0x14(%edx)
      if(p->state == ZOMBIE)
80103ccf:	75 e7                	jne    80103cb8 <exit+0xe8>
80103cd1:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103cd6:	eb 0a                	jmp    80103ce2 <exit+0x112>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cd8:	83 e8 80             	sub    $0xffffff80,%eax
80103cdb:	3d d4 4d 11 80       	cmp    $0x80114dd4,%eax
80103ce0:	74 d6                	je     80103cb8 <exit+0xe8>
    if(p->state == SLEEPING && p->chan == chan)
80103ce2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ce6:	75 f0                	jne    80103cd8 <exit+0x108>
80103ce8:	3b 58 20             	cmp    0x20(%eax),%ebx
80103ceb:	75 eb                	jne    80103cd8 <exit+0x108>
      p->state = RUNNABLE;
80103ced:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103cf4:	eb e2                	jmp    80103cd8 <exit+0x108>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80103cf6:	c7 41 0c 05 00 00 00 	movl   $0x5,0xc(%ecx)
  sched();
80103cfd:	e8 2e fe ff ff       	call   80103b30 <sched>
  panic("zombie exit");
80103d02:	c7 04 24 d1 73 10 80 	movl   $0x801073d1,(%esp)
80103d09:	e8 52 c6 ff ff       	call   80100360 <panic>
  struct proc *p;
  int fd;
  cprintf("status: %d\n", status);

  if(proc == initproc)
    panic("init exiting");
80103d0e:	c7 04 24 c4 73 10 80 	movl   $0x801073c4,(%esp)
80103d15:	e8 46 c6 ff ff       	call   80100360 <panic>
80103d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d20 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103d26:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103d2d:	e8 1e 05 00 00       	call   80104250 <acquire>
  proc->state = RUNNABLE;
80103d32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103d38:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103d3f:	e8 ec fd ff ff       	call   80103b30 <sched>
  release(&ptable.lock);
80103d44:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103d4b:	e8 30 06 00 00       	call   80104380 <release>
}
80103d50:	c9                   	leave  
80103d51:	c3                   	ret    
80103d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d60 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	56                   	push   %esi
80103d64:	53                   	push   %ebx
80103d65:	83 ec 10             	sub    $0x10,%esp
  if(proc == 0)
80103d68:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103d6e:	8b 75 08             	mov    0x8(%ebp),%esi
80103d71:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
80103d74:	85 c0                	test   %eax,%eax
80103d76:	0f 84 8b 00 00 00    	je     80103e07 <sleep+0xa7>
    panic("sleep");

  if(lk == 0)
80103d7c:	85 db                	test   %ebx,%ebx
80103d7e:	74 7b                	je     80103dfb <sleep+0x9b>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d80:	81 fb a0 2d 11 80    	cmp    $0x80112da0,%ebx
80103d86:	74 50                	je     80103dd8 <sleep+0x78>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d88:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103d8f:	e8 bc 04 00 00       	call   80104250 <acquire>
    release(lk);
80103d94:	89 1c 24             	mov    %ebx,(%esp)
80103d97:	e8 e4 05 00 00       	call   80104380 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80103d9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103da2:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103da5:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103dac:	e8 7f fd ff ff       	call   80103b30 <sched>

  // Tidy up.
  proc->chan = 0;
80103db1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103db7:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103dbe:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103dc5:	e8 b6 05 00 00       	call   80104380 <release>
    acquire(lk);
80103dca:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
80103dcd:	83 c4 10             	add    $0x10,%esp
80103dd0:	5b                   	pop    %ebx
80103dd1:	5e                   	pop    %esi
80103dd2:	5d                   	pop    %ebp
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103dd3:	e9 78 04 00 00       	jmp    80104250 <acquire>
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
80103dd8:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103ddb:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103de2:	e8 49 fd ff ff       	call   80103b30 <sched>

  // Tidy up.
  proc->chan = 0;
80103de7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ded:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103df4:	83 c4 10             	add    $0x10,%esp
80103df7:	5b                   	pop    %ebx
80103df8:	5e                   	pop    %esi
80103df9:	5d                   	pop    %ebp
80103dfa:	c3                   	ret    
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103dfb:	c7 04 24 e3 73 10 80 	movl   $0x801073e3,(%esp)
80103e02:	e8 59 c5 ff ff       	call   80100360 <panic>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
80103e07:	c7 04 24 dd 73 10 80 	movl   $0x801073dd,(%esp)
80103e0e:	e8 4d c5 ff ff       	call   80100360 <panic>
80103e13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e20 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(int *status)
{
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	57                   	push   %edi
80103e24:	56                   	push   %esi
80103e25:	53                   	push   %ebx
80103e26:	83 ec 1c             	sub    $0x1c,%esp
80103e29:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80103e2c:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103e33:	e8 18 04 00 00       	call   80104250 <acquire>
80103e38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103e3e:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e40:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
80103e45:	eb 0c                	jmp    80103e53 <wait+0x33>
80103e47:	90                   	nop
80103e48:	83 eb 80             	sub    $0xffffff80,%ebx
80103e4b:	81 fb d4 4d 11 80    	cmp    $0x80114dd4,%ebx
80103e51:	74 1d                	je     80103e70 <wait+0x50>
      if(p->parent != proc)
80103e53:	39 43 14             	cmp    %eax,0x14(%ebx)
80103e56:	75 f0                	jne    80103e48 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103e58:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103e5c:	74 2f                	je     80103e8d <wait+0x6d>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e5e:	83 eb 80             	sub    $0xffffff80,%ebx
      if(p->parent != proc)
        continue;
      havekids = 1;
80103e61:	ba 01 00 00 00       	mov    $0x1,%edx

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e66:	81 fb d4 4d 11 80    	cmp    $0x80114dd4,%ebx
80103e6c:	75 e5                	jne    80103e53 <wait+0x33>
80103e6e:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80103e70:	85 d2                	test   %edx,%edx
80103e72:	74 78                	je     80103eec <wait+0xcc>
80103e74:	8b 50 24             	mov    0x24(%eax),%edx
80103e77:	85 d2                	test   %edx,%edx
80103e79:	75 71                	jne    80103eec <wait+0xcc>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80103e7b:	c7 44 24 04 a0 2d 11 	movl   $0x80112da0,0x4(%esp)
80103e82:	80 
80103e83:	89 04 24             	mov    %eax,(%esp)
80103e86:	e8 d5 fe ff ff       	call   80103d60 <sleep>
  }
80103e8b:	eb ab                	jmp    80103e38 <wait+0x18>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103e8d:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103e90:	8b 7b 10             	mov    0x10(%ebx),%edi
        kfree(p->kstack);
80103e93:	89 04 24             	mov    %eax,(%esp)
80103e96:	e8 b5 e4 ff ff       	call   80102350 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103e9b:	8b 43 04             	mov    0x4(%ebx),%eax
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103e9e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103ea5:	89 04 24             	mov    %eax,(%esp)
80103ea8:	e8 d3 2c 00 00       	call   80106b80 <freevm>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
		if (status != 0) {
80103ead:	85 f6                	test   %esi,%esi
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
80103eaf:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103eb6:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103ebd:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103ec1:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103ec8:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		if (status != 0) {
80103ecf:	74 05                	je     80103ed6 <wait+0xb6>
			*status = p->status;
80103ed1:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103ed4:	89 06                	mov    %eax,(%esi)
		}
        release(&ptable.lock);
80103ed6:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103edd:	e8 9e 04 00 00       	call   80104380 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103ee2:	83 c4 1c             	add    $0x1c,%esp
        p->state = UNUSED;
		if (status != 0) {
			*status = p->status;
		}
        release(&ptable.lock);
        return pid;
80103ee5:	89 f8                	mov    %edi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103ee7:	5b                   	pop    %ebx
80103ee8:	5e                   	pop    %esi
80103ee9:	5f                   	pop    %edi
80103eea:	5d                   	pop    %ebp
80103eeb:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
80103eec:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103ef3:	e8 88 04 00 00       	call   80104380 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103ef8:	83 c4 1c             	add    $0x1c,%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
80103efb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f00:	5b                   	pop    %ebx
80103f01:	5e                   	pop    %esi
80103f02:	5f                   	pop    %edi
80103f03:	5d                   	pop    %ebp
80103f04:	c3                   	ret    
80103f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f10 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	53                   	push   %ebx
80103f14:	83 ec 14             	sub    $0x14,%esp
80103f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103f1a:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103f21:	e8 2a 03 00 00       	call   80104250 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f26:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103f2b:	eb 0d                	jmp    80103f3a <wakeup+0x2a>
80103f2d:	8d 76 00             	lea    0x0(%esi),%esi
80103f30:	83 e8 80             	sub    $0xffffff80,%eax
80103f33:	3d d4 4d 11 80       	cmp    $0x80114dd4,%eax
80103f38:	74 1e                	je     80103f58 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
80103f3a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f3e:	75 f0                	jne    80103f30 <wakeup+0x20>
80103f40:	3b 58 20             	cmp    0x20(%eax),%ebx
80103f43:	75 eb                	jne    80103f30 <wakeup+0x20>
      p->state = RUNNABLE;
80103f45:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f4c:	83 e8 80             	sub    $0xffffff80,%eax
80103f4f:	3d d4 4d 11 80       	cmp    $0x80114dd4,%eax
80103f54:	75 e4                	jne    80103f3a <wakeup+0x2a>
80103f56:	66 90                	xchg   %ax,%ax
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103f58:	c7 45 08 a0 2d 11 80 	movl   $0x80112da0,0x8(%ebp)
}
80103f5f:	83 c4 14             	add    $0x14,%esp
80103f62:	5b                   	pop    %ebx
80103f63:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103f64:	e9 17 04 00 00       	jmp    80104380 <release>
80103f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f70 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	53                   	push   %ebx
80103f74:	83 ec 14             	sub    $0x14,%esp
80103f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103f7a:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103f81:	e8 ca 02 00 00       	call   80104250 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f86:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103f8b:	eb 0d                	jmp    80103f9a <kill+0x2a>
80103f8d:	8d 76 00             	lea    0x0(%esi),%esi
80103f90:	83 e8 80             	sub    $0xffffff80,%eax
80103f93:	3d d4 4d 11 80       	cmp    $0x80114dd4,%eax
80103f98:	74 36                	je     80103fd0 <kill+0x60>
    if(p->pid == pid){
80103f9a:	39 58 10             	cmp    %ebx,0x10(%eax)
80103f9d:	75 f1                	jne    80103f90 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f9f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103fa3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103faa:	74 14                	je     80103fc0 <kill+0x50>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103fac:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103fb3:	e8 c8 03 00 00       	call   80104380 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103fb8:	83 c4 14             	add    $0x14,%esp
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
80103fbb:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103fbd:	5b                   	pop    %ebx
80103fbe:	5d                   	pop    %ebp
80103fbf:	c3                   	ret    
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103fc0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fc7:	eb e3                	jmp    80103fac <kill+0x3c>
80103fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103fd0:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103fd7:	e8 a4 03 00 00       	call   80104380 <release>
  return -1;
}
80103fdc:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
80103fdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103fe4:	5b                   	pop    %ebx
80103fe5:	5d                   	pop    %ebp
80103fe6:	c3                   	ret    
80103fe7:	89 f6                	mov    %esi,%esi
80103fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ff0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	57                   	push   %edi
80103ff4:	56                   	push   %esi
80103ff5:	53                   	push   %ebx
80103ff6:	bb 40 2e 11 80       	mov    $0x80112e40,%ebx
80103ffb:	83 ec 4c             	sub    $0x4c,%esp
80103ffe:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104001:	eb 20                	jmp    80104023 <procdump+0x33>
80104003:	90                   	nop
80104004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104008:	c7 04 24 26 73 10 80 	movl   $0x80107326,(%esp)
8010400f:	e8 3c c6 ff ff       	call   80100650 <cprintf>
80104014:	83 eb 80             	sub    $0xffffff80,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104017:	81 fb 40 4e 11 80    	cmp    $0x80114e40,%ebx
8010401d:	0f 84 8d 00 00 00    	je     801040b0 <procdump+0xc0>
    if(p->state == UNUSED)
80104023:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104026:	85 c0                	test   %eax,%eax
80104028:	74 ea                	je     80104014 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010402a:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
8010402d:	ba f4 73 10 80       	mov    $0x801073f4,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104032:	77 11                	ja     80104045 <procdump+0x55>
80104034:	8b 14 85 2c 74 10 80 	mov    -0x7fef8bd4(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
8010403b:	b8 f4 73 10 80       	mov    $0x801073f4,%eax
80104040:	85 d2                	test   %edx,%edx
80104042:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104045:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80104048:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010404c:	89 54 24 08          	mov    %edx,0x8(%esp)
80104050:	c7 04 24 f8 73 10 80 	movl   $0x801073f8,(%esp)
80104057:	89 44 24 04          	mov    %eax,0x4(%esp)
8010405b:	e8 f0 c5 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80104060:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104064:	75 a2                	jne    80104008 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104066:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104069:	89 44 24 04          	mov    %eax,0x4(%esp)
8010406d:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104070:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104073:	8b 40 0c             	mov    0xc(%eax),%eax
80104076:	83 c0 08             	add    $0x8,%eax
80104079:	89 04 24             	mov    %eax,(%esp)
8010407c:	e8 6f 01 00 00       	call   801041f0 <getcallerpcs>
80104081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104088:	8b 17                	mov    (%edi),%edx
8010408a:	85 d2                	test   %edx,%edx
8010408c:	0f 84 76 ff ff ff    	je     80104008 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104092:	89 54 24 04          	mov    %edx,0x4(%esp)
80104096:	83 c7 04             	add    $0x4,%edi
80104099:	c7 04 24 49 6e 10 80 	movl   $0x80106e49,(%esp)
801040a0:	e8 ab c5 ff ff       	call   80100650 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801040a5:	39 f7                	cmp    %esi,%edi
801040a7:	75 df                	jne    80104088 <procdump+0x98>
801040a9:	e9 5a ff ff ff       	jmp    80104008 <procdump+0x18>
801040ae:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801040b0:	83 c4 4c             	add    $0x4c,%esp
801040b3:	5b                   	pop    %ebx
801040b4:	5e                   	pop    %esi
801040b5:	5f                   	pop    %edi
801040b6:	5d                   	pop    %ebp
801040b7:	c3                   	ret    
801040b8:	66 90                	xchg   %ax,%ax
801040ba:	66 90                	xchg   %ax,%ax
801040bc:	66 90                	xchg   %ax,%ax
801040be:	66 90                	xchg   %ax,%ax

801040c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	53                   	push   %ebx
801040c4:	83 ec 14             	sub    $0x14,%esp
801040c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801040ca:	c7 44 24 04 44 74 10 	movl   $0x80107444,0x4(%esp)
801040d1:	80 
801040d2:	8d 43 04             	lea    0x4(%ebx),%eax
801040d5:	89 04 24             	mov    %eax,(%esp)
801040d8:	e8 f3 00 00 00       	call   801041d0 <initlock>
  lk->name = name;
801040dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801040e0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801040e6:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
801040ed:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
801040f0:	83 c4 14             	add    $0x14,%esp
801040f3:	5b                   	pop    %ebx
801040f4:	5d                   	pop    %ebp
801040f5:	c3                   	ret    
801040f6:	8d 76 00             	lea    0x0(%esi),%esi
801040f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104100 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	56                   	push   %esi
80104104:	53                   	push   %ebx
80104105:	83 ec 10             	sub    $0x10,%esp
80104108:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010410b:	8d 73 04             	lea    0x4(%ebx),%esi
8010410e:	89 34 24             	mov    %esi,(%esp)
80104111:	e8 3a 01 00 00       	call   80104250 <acquire>
  while (lk->locked) {
80104116:	8b 13                	mov    (%ebx),%edx
80104118:	85 d2                	test   %edx,%edx
8010411a:	74 16                	je     80104132 <acquiresleep+0x32>
8010411c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104120:	89 74 24 04          	mov    %esi,0x4(%esp)
80104124:	89 1c 24             	mov    %ebx,(%esp)
80104127:	e8 34 fc ff ff       	call   80103d60 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010412c:	8b 03                	mov    (%ebx),%eax
8010412e:	85 c0                	test   %eax,%eax
80104130:	75 ee                	jne    80104120 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104132:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = proc->pid;
80104138:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010413e:	8b 40 10             	mov    0x10(%eax),%eax
80104141:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104144:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104147:	83 c4 10             	add    $0x10,%esp
8010414a:	5b                   	pop    %ebx
8010414b:	5e                   	pop    %esi
8010414c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = proc->pid;
  release(&lk->lk);
8010414d:	e9 2e 02 00 00       	jmp    80104380 <release>
80104152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104160 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	56                   	push   %esi
80104164:	53                   	push   %ebx
80104165:	83 ec 10             	sub    $0x10,%esp
80104168:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010416b:	8d 73 04             	lea    0x4(%ebx),%esi
8010416e:	89 34 24             	mov    %esi,(%esp)
80104171:	e8 da 00 00 00       	call   80104250 <acquire>
  lk->locked = 0;
80104176:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010417c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104183:	89 1c 24             	mov    %ebx,(%esp)
80104186:	e8 85 fd ff ff       	call   80103f10 <wakeup>
  release(&lk->lk);
8010418b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010418e:	83 c4 10             	add    $0x10,%esp
80104191:	5b                   	pop    %ebx
80104192:	5e                   	pop    %esi
80104193:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104194:	e9 e7 01 00 00       	jmp    80104380 <release>
80104199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041a0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	56                   	push   %esi
801041a4:	53                   	push   %ebx
801041a5:	83 ec 10             	sub    $0x10,%esp
801041a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801041ab:	8d 73 04             	lea    0x4(%ebx),%esi
801041ae:	89 34 24             	mov    %esi,(%esp)
801041b1:	e8 9a 00 00 00       	call   80104250 <acquire>
  r = lk->locked;
801041b6:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
801041b8:	89 34 24             	mov    %esi,(%esp)
801041bb:	e8 c0 01 00 00       	call   80104380 <release>
  return r;
}
801041c0:	83 c4 10             	add    $0x10,%esp
801041c3:	89 d8                	mov    %ebx,%eax
801041c5:	5b                   	pop    %ebx
801041c6:	5e                   	pop    %esi
801041c7:	5d                   	pop    %ebp
801041c8:	c3                   	ret    
801041c9:	66 90                	xchg   %ax,%ax
801041cb:	66 90                	xchg   %ax,%ax
801041cd:	66 90                	xchg   %ax,%ax
801041cf:	90                   	nop

801041d0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801041d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801041d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
801041df:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
801041e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801041e9:	5d                   	pop    %ebp
801041ea:	c3                   	ret    
801041eb:	90                   	nop
801041ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801041f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801041f3:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801041f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801041f9:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801041fa:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801041fd:	31 c0                	xor    %eax,%eax
801041ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104200:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104206:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010420c:	77 1a                	ja     80104228 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010420e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104211:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104214:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104217:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104219:	83 f8 0a             	cmp    $0xa,%eax
8010421c:	75 e2                	jne    80104200 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010421e:	5b                   	pop    %ebx
8010421f:	5d                   	pop    %ebp
80104220:	c3                   	ret    
80104221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104228:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010422f:	83 c0 01             	add    $0x1,%eax
80104232:	83 f8 0a             	cmp    $0xa,%eax
80104235:	74 e7                	je     8010421e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104237:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010423e:	83 c0 01             	add    $0x1,%eax
80104241:	83 f8 0a             	cmp    $0xa,%eax
80104244:	75 e2                	jne    80104228 <getcallerpcs+0x38>
80104246:	eb d6                	jmp    8010421e <getcallerpcs+0x2e>
80104248:	90                   	nop
80104249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104250 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	83 ec 18             	sub    $0x18,%esp
80104256:	9c                   	pushf  
80104257:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104258:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
80104259:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010425f:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104265:	85 d2                	test   %edx,%edx
80104267:	75 0c                	jne    80104275 <acquire+0x25>
    cpu->intena = eflags & FL_IF;
80104269:	81 e1 00 02 00 00    	and    $0x200,%ecx
8010426f:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
  cpu->ncli += 1;
80104275:	83 c2 01             	add    $0x1,%edx
80104278:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
8010427e:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104281:	8b 0a                	mov    (%edx),%ecx
80104283:	85 c9                	test   %ecx,%ecx
80104285:	74 05                	je     8010428c <acquire+0x3c>
80104287:	3b 42 08             	cmp    0x8(%edx),%eax
8010428a:	74 3e                	je     801042ca <acquire+0x7a>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010428c:	b9 01 00 00 00       	mov    $0x1,%ecx
80104291:	eb 08                	jmp    8010429b <acquire+0x4b>
80104293:	90                   	nop
80104294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104298:	8b 55 08             	mov    0x8(%ebp),%edx
8010429b:	89 c8                	mov    %ecx,%eax
8010429d:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801042a0:	85 c0                	test   %eax,%eax
801042a2:	75 f4                	jne    80104298 <acquire+0x48>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801042a4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801042a9:	8b 45 08             	mov    0x8(%ebp),%eax
801042ac:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  getcallerpcs(&lk, lk->pcs);
801042b3:	83 c0 0c             	add    $0xc,%eax
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801042b6:	89 50 fc             	mov    %edx,-0x4(%eax)
  getcallerpcs(&lk, lk->pcs);
801042b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801042bd:	8d 45 08             	lea    0x8(%ebp),%eax
801042c0:	89 04 24             	mov    %eax,(%esp)
801042c3:	e8 28 ff ff ff       	call   801041f0 <getcallerpcs>
}
801042c8:	c9                   	leave  
801042c9:	c3                   	ret    
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
801042ca:	c7 04 24 4f 74 10 80 	movl   $0x8010744f,(%esp)
801042d1:	e8 8a c0 ff ff       	call   80100360 <panic>
801042d6:	8d 76 00             	lea    0x0(%esi),%esi
801042d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042e0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801042e0:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu;
801042e1:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801042e3:	89 e5                	mov    %esp,%ebp
801042e5:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
801042e8:	8b 0a                	mov    (%edx),%ecx
801042ea:	85 c9                	test   %ecx,%ecx
801042ec:	74 0f                	je     801042fd <holding+0x1d>
801042ee:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801042f4:	39 42 08             	cmp    %eax,0x8(%edx)
801042f7:	0f 94 c0             	sete   %al
801042fa:	0f b6 c0             	movzbl %al,%eax
}
801042fd:	5d                   	pop    %ebp
801042fe:	c3                   	ret    
801042ff:	90                   	nop

80104300 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104303:	9c                   	pushf  
80104304:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104305:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
80104306:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010430c:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104312:	85 d2                	test   %edx,%edx
80104314:	75 0c                	jne    80104322 <pushcli+0x22>
    cpu->intena = eflags & FL_IF;
80104316:	81 e1 00 02 00 00    	and    $0x200,%ecx
8010431c:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
  cpu->ncli += 1;
80104322:	83 c2 01             	add    $0x1,%edx
80104325:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
}
8010432b:	5d                   	pop    %ebp
8010432c:	c3                   	ret    
8010432d:	8d 76 00             	lea    0x0(%esi),%esi

80104330 <popcli>:

void
popcli(void)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104336:	9c                   	pushf  
80104337:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104338:	f6 c4 02             	test   $0x2,%ah
8010433b:	75 34                	jne    80104371 <popcli+0x41>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
8010433d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104343:	8b 88 ac 00 00 00    	mov    0xac(%eax),%ecx
80104349:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010434c:	85 d2                	test   %edx,%edx
8010434e:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104354:	78 0f                	js     80104365 <popcli+0x35>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
80104356:	75 0b                	jne    80104363 <popcli+0x33>
80104358:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010435e:	85 c0                	test   %eax,%eax
80104360:	74 01                	je     80104363 <popcli+0x33>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104362:	fb                   	sti    
    sti();
}
80104363:	c9                   	leave  
80104364:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
80104365:	c7 04 24 6e 74 10 80 	movl   $0x8010746e,(%esp)
8010436c:	e8 ef bf ff ff       	call   80100360 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104371:	c7 04 24 57 74 10 80 	movl   $0x80107457,(%esp)
80104378:	e8 e3 bf ff ff       	call   80100360 <panic>
8010437d:	8d 76 00             	lea    0x0(%esi),%esi

80104380 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	83 ec 18             	sub    $0x18,%esp
80104386:	8b 45 08             	mov    0x8(%ebp),%eax

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104389:	8b 10                	mov    (%eax),%edx
8010438b:	85 d2                	test   %edx,%edx
8010438d:	74 0c                	je     8010439b <release+0x1b>
8010438f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104396:	39 50 08             	cmp    %edx,0x8(%eax)
80104399:	74 0d                	je     801043a8 <release+0x28>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010439b:	c7 04 24 75 74 10 80 	movl   $0x80107475,(%esp)
801043a2:	e8 b9 bf ff ff       	call   80100360 <panic>
801043a7:	90                   	nop

  lk->pcs[0] = 0;
801043a8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801043af:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801043b6:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801043bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
}
801043c1:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
801043c2:	e9 69 ff ff ff       	jmp    80104330 <popcli>
801043c7:	66 90                	xchg   %ax,%ax
801043c9:	66 90                	xchg   %ax,%ax
801043cb:	66 90                	xchg   %ax,%ax
801043cd:	66 90                	xchg   %ax,%ax
801043cf:	90                   	nop

801043d0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	8b 55 08             	mov    0x8(%ebp),%edx
801043d6:	57                   	push   %edi
801043d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801043da:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801043db:	f6 c2 03             	test   $0x3,%dl
801043de:	75 05                	jne    801043e5 <memset+0x15>
801043e0:	f6 c1 03             	test   $0x3,%cl
801043e3:	74 13                	je     801043f8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801043e5:	89 d7                	mov    %edx,%edi
801043e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801043ea:	fc                   	cld    
801043eb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801043ed:	5b                   	pop    %ebx
801043ee:	89 d0                	mov    %edx,%eax
801043f0:	5f                   	pop    %edi
801043f1:	5d                   	pop    %ebp
801043f2:	c3                   	ret    
801043f3:	90                   	nop
801043f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801043f8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801043fc:	c1 e9 02             	shr    $0x2,%ecx
801043ff:	89 f8                	mov    %edi,%eax
80104401:	89 fb                	mov    %edi,%ebx
80104403:	c1 e0 18             	shl    $0x18,%eax
80104406:	c1 e3 10             	shl    $0x10,%ebx
80104409:	09 d8                	or     %ebx,%eax
8010440b:	09 f8                	or     %edi,%eax
8010440d:	c1 e7 08             	shl    $0x8,%edi
80104410:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104412:	89 d7                	mov    %edx,%edi
80104414:	fc                   	cld    
80104415:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104417:	5b                   	pop    %ebx
80104418:	89 d0                	mov    %edx,%eax
8010441a:	5f                   	pop    %edi
8010441b:	5d                   	pop    %ebp
8010441c:	c3                   	ret    
8010441d:	8d 76 00             	lea    0x0(%esi),%esi

80104420 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	8b 45 10             	mov    0x10(%ebp),%eax
80104426:	57                   	push   %edi
80104427:	56                   	push   %esi
80104428:	8b 75 0c             	mov    0xc(%ebp),%esi
8010442b:	53                   	push   %ebx
8010442c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010442f:	85 c0                	test   %eax,%eax
80104431:	8d 78 ff             	lea    -0x1(%eax),%edi
80104434:	74 26                	je     8010445c <memcmp+0x3c>
    if(*s1 != *s2)
80104436:	0f b6 03             	movzbl (%ebx),%eax
80104439:	31 d2                	xor    %edx,%edx
8010443b:	0f b6 0e             	movzbl (%esi),%ecx
8010443e:	38 c8                	cmp    %cl,%al
80104440:	74 16                	je     80104458 <memcmp+0x38>
80104442:	eb 24                	jmp    80104468 <memcmp+0x48>
80104444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104448:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010444d:	83 c2 01             	add    $0x1,%edx
80104450:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104454:	38 c8                	cmp    %cl,%al
80104456:	75 10                	jne    80104468 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104458:	39 fa                	cmp    %edi,%edx
8010445a:	75 ec                	jne    80104448 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010445c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010445d:	31 c0                	xor    %eax,%eax
}
8010445f:	5e                   	pop    %esi
80104460:	5f                   	pop    %edi
80104461:	5d                   	pop    %ebp
80104462:	c3                   	ret    
80104463:	90                   	nop
80104464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104468:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104469:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010446b:	5e                   	pop    %esi
8010446c:	5f                   	pop    %edi
8010446d:	5d                   	pop    %ebp
8010446e:	c3                   	ret    
8010446f:	90                   	nop

80104470 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	57                   	push   %edi
80104474:	8b 45 08             	mov    0x8(%ebp),%eax
80104477:	56                   	push   %esi
80104478:	8b 75 0c             	mov    0xc(%ebp),%esi
8010447b:	53                   	push   %ebx
8010447c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010447f:	39 c6                	cmp    %eax,%esi
80104481:	73 35                	jae    801044b8 <memmove+0x48>
80104483:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104486:	39 c8                	cmp    %ecx,%eax
80104488:	73 2e                	jae    801044b8 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010448a:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
8010448c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010448f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104492:	74 1b                	je     801044af <memmove+0x3f>
80104494:	f7 db                	neg    %ebx
80104496:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104499:	01 fb                	add    %edi,%ebx
8010449b:	90                   	nop
8010449c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801044a0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801044a4:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801044a7:	83 ea 01             	sub    $0x1,%edx
801044aa:	83 fa ff             	cmp    $0xffffffff,%edx
801044ad:	75 f1                	jne    801044a0 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801044af:	5b                   	pop    %ebx
801044b0:	5e                   	pop    %esi
801044b1:	5f                   	pop    %edi
801044b2:	5d                   	pop    %ebp
801044b3:	c3                   	ret    
801044b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801044b8:	31 d2                	xor    %edx,%edx
801044ba:	85 db                	test   %ebx,%ebx
801044bc:	74 f1                	je     801044af <memmove+0x3f>
801044be:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801044c0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801044c4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801044c7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801044ca:	39 da                	cmp    %ebx,%edx
801044cc:	75 f2                	jne    801044c0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
801044ce:	5b                   	pop    %ebx
801044cf:	5e                   	pop    %esi
801044d0:	5f                   	pop    %edi
801044d1:	5d                   	pop    %ebp
801044d2:	c3                   	ret    
801044d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044e0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801044e3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801044e4:	e9 87 ff ff ff       	jmp    80104470 <memmove>
801044e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044f0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	56                   	push   %esi
801044f4:	8b 75 10             	mov    0x10(%ebp),%esi
801044f7:	53                   	push   %ebx
801044f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801044fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801044fe:	85 f6                	test   %esi,%esi
80104500:	74 30                	je     80104532 <strncmp+0x42>
80104502:	0f b6 01             	movzbl (%ecx),%eax
80104505:	84 c0                	test   %al,%al
80104507:	74 2f                	je     80104538 <strncmp+0x48>
80104509:	0f b6 13             	movzbl (%ebx),%edx
8010450c:	38 d0                	cmp    %dl,%al
8010450e:	75 46                	jne    80104556 <strncmp+0x66>
80104510:	8d 51 01             	lea    0x1(%ecx),%edx
80104513:	01 ce                	add    %ecx,%esi
80104515:	eb 14                	jmp    8010452b <strncmp+0x3b>
80104517:	90                   	nop
80104518:	0f b6 02             	movzbl (%edx),%eax
8010451b:	84 c0                	test   %al,%al
8010451d:	74 31                	je     80104550 <strncmp+0x60>
8010451f:	0f b6 19             	movzbl (%ecx),%ebx
80104522:	83 c2 01             	add    $0x1,%edx
80104525:	38 d8                	cmp    %bl,%al
80104527:	75 17                	jne    80104540 <strncmp+0x50>
    n--, p++, q++;
80104529:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010452b:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
8010452d:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104530:	75 e6                	jne    80104518 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104532:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104533:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104535:	5e                   	pop    %esi
80104536:	5d                   	pop    %ebp
80104537:	c3                   	ret    
80104538:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010453b:	31 c0                	xor    %eax,%eax
8010453d:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104540:	0f b6 d3             	movzbl %bl,%edx
80104543:	29 d0                	sub    %edx,%eax
}
80104545:	5b                   	pop    %ebx
80104546:	5e                   	pop    %esi
80104547:	5d                   	pop    %ebp
80104548:	c3                   	ret    
80104549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104550:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104554:	eb ea                	jmp    80104540 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104556:	89 d3                	mov    %edx,%ebx
80104558:	eb e6                	jmp    80104540 <strncmp+0x50>
8010455a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104560 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	8b 45 08             	mov    0x8(%ebp),%eax
80104566:	56                   	push   %esi
80104567:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010456a:	53                   	push   %ebx
8010456b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010456e:	89 c2                	mov    %eax,%edx
80104570:	eb 19                	jmp    8010458b <strncpy+0x2b>
80104572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104578:	83 c3 01             	add    $0x1,%ebx
8010457b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010457f:	83 c2 01             	add    $0x1,%edx
80104582:	84 c9                	test   %cl,%cl
80104584:	88 4a ff             	mov    %cl,-0x1(%edx)
80104587:	74 09                	je     80104592 <strncpy+0x32>
80104589:	89 f1                	mov    %esi,%ecx
8010458b:	85 c9                	test   %ecx,%ecx
8010458d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104590:	7f e6                	jg     80104578 <strncpy+0x18>
    ;
  while(n-- > 0)
80104592:	31 c9                	xor    %ecx,%ecx
80104594:	85 f6                	test   %esi,%esi
80104596:	7e 0f                	jle    801045a7 <strncpy+0x47>
    *s++ = 0;
80104598:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010459c:	89 f3                	mov    %esi,%ebx
8010459e:	83 c1 01             	add    $0x1,%ecx
801045a1:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801045a3:	85 db                	test   %ebx,%ebx
801045a5:	7f f1                	jg     80104598 <strncpy+0x38>
    *s++ = 0;
  return os;
}
801045a7:	5b                   	pop    %ebx
801045a8:	5e                   	pop    %esi
801045a9:	5d                   	pop    %ebp
801045aa:	c3                   	ret    
801045ab:	90                   	nop
801045ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045b0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045b6:	56                   	push   %esi
801045b7:	8b 45 08             	mov    0x8(%ebp),%eax
801045ba:	53                   	push   %ebx
801045bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801045be:	85 c9                	test   %ecx,%ecx
801045c0:	7e 26                	jle    801045e8 <safestrcpy+0x38>
801045c2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801045c6:	89 c1                	mov    %eax,%ecx
801045c8:	eb 17                	jmp    801045e1 <safestrcpy+0x31>
801045ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801045d0:	83 c2 01             	add    $0x1,%edx
801045d3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801045d7:	83 c1 01             	add    $0x1,%ecx
801045da:	84 db                	test   %bl,%bl
801045dc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801045df:	74 04                	je     801045e5 <safestrcpy+0x35>
801045e1:	39 f2                	cmp    %esi,%edx
801045e3:	75 eb                	jne    801045d0 <safestrcpy+0x20>
    ;
  *s = 0;
801045e5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801045e8:	5b                   	pop    %ebx
801045e9:	5e                   	pop    %esi
801045ea:	5d                   	pop    %ebp
801045eb:	c3                   	ret    
801045ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045f0 <strlen>:

int
strlen(const char *s)
{
801045f0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801045f1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
801045f3:	89 e5                	mov    %esp,%ebp
801045f5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801045f8:	80 3a 00             	cmpb   $0x0,(%edx)
801045fb:	74 0c                	je     80104609 <strlen+0x19>
801045fd:	8d 76 00             	lea    0x0(%esi),%esi
80104600:	83 c0 01             	add    $0x1,%eax
80104603:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104607:	75 f7                	jne    80104600 <strlen+0x10>
    ;
  return n;
}
80104609:	5d                   	pop    %ebp
8010460a:	c3                   	ret    

8010460b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010460b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010460f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104613:	55                   	push   %ebp
  pushl %ebx
80104614:	53                   	push   %ebx
  pushl %esi
80104615:	56                   	push   %esi
  pushl %edi
80104616:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104617:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104619:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010461b:	5f                   	pop    %edi
  popl %esi
8010461c:	5e                   	pop    %esi
  popl %ebx
8010461d:	5b                   	pop    %ebx
  popl %ebp
8010461e:	5d                   	pop    %ebp
  ret
8010461f:	c3                   	ret    

80104620 <fetchint>:

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104620:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104627:	55                   	push   %ebp
80104628:	89 e5                	mov    %esp,%ebp
8010462a:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
8010462d:	8b 12                	mov    (%edx),%edx
8010462f:	39 c2                	cmp    %eax,%edx
80104631:	76 15                	jbe    80104648 <fetchint+0x28>
80104633:	8d 48 04             	lea    0x4(%eax),%ecx
80104636:	39 ca                	cmp    %ecx,%edx
80104638:	72 0e                	jb     80104648 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
8010463a:	8b 10                	mov    (%eax),%edx
8010463c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010463f:	89 10                	mov    %edx,(%eax)
  return 0;
80104641:	31 c0                	xor    %eax,%eax
}
80104643:	5d                   	pop    %ebp
80104644:	c3                   	ret    
80104645:	8d 76 00             	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104648:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  *ip = *(int*)(addr);
  return 0;
}
8010464d:	5d                   	pop    %ebp
8010464e:	c3                   	ret    
8010464f:	90                   	nop

80104650 <fetchstr>:
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
80104650:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104656:	55                   	push   %ebp
80104657:	89 e5                	mov    %esp,%ebp
80104659:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *s, *ep;

  if(addr >= proc->sz)
8010465c:	39 08                	cmp    %ecx,(%eax)
8010465e:	76 2c                	jbe    8010468c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104660:	8b 55 0c             	mov    0xc(%ebp),%edx
80104663:	89 c8                	mov    %ecx,%eax
80104665:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
80104667:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010466e:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104670:	39 d1                	cmp    %edx,%ecx
80104672:	73 18                	jae    8010468c <fetchstr+0x3c>
    if(*s == 0)
80104674:	80 39 00             	cmpb   $0x0,(%ecx)
80104677:	75 0c                	jne    80104685 <fetchstr+0x35>
80104679:	eb 1d                	jmp    80104698 <fetchstr+0x48>
8010467b:	90                   	nop
8010467c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104680:	80 38 00             	cmpb   $0x0,(%eax)
80104683:	74 13                	je     80104698 <fetchstr+0x48>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104685:	83 c0 01             	add    $0x1,%eax
80104688:	39 c2                	cmp    %eax,%edx
8010468a:	77 f4                	ja     80104680 <fetchstr+0x30>
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
    return -1;
8010468c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
  return -1;
}
80104691:	5d                   	pop    %ebp
80104692:	c3                   	ret    
80104693:	90                   	nop
80104694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
80104698:	29 c8                	sub    %ecx,%eax
  return -1;
}
8010469a:	5d                   	pop    %ebp
8010469b:	c3                   	ret    
8010469c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046a0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801046a0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801046a7:	55                   	push   %ebp
801046a8:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801046aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
801046ad:	8b 42 18             	mov    0x18(%edx),%eax

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801046b0:	8b 12                	mov    (%edx),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801046b2:	8b 40 44             	mov    0x44(%eax),%eax
801046b5:	8d 04 88             	lea    (%eax,%ecx,4),%eax
801046b8:	8d 48 04             	lea    0x4(%eax),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801046bb:	39 d1                	cmp    %edx,%ecx
801046bd:	73 19                	jae    801046d8 <argint+0x38>
801046bf:	8d 48 08             	lea    0x8(%eax),%ecx
801046c2:	39 ca                	cmp    %ecx,%edx
801046c4:	72 12                	jb     801046d8 <argint+0x38>
    return -1;
  *ip = *(int*)(addr);
801046c6:	8b 50 04             	mov    0x4(%eax),%edx
801046c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801046cc:	89 10                	mov    %edx,(%eax)
  return 0;
801046ce:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
801046d0:	5d                   	pop    %ebp
801046d1:	c3                   	ret    
801046d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
801046d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
801046dd:	5d                   	pop    %ebp
801046de:	c3                   	ret    
801046df:	90                   	nop

801046e0 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801046e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801046e6:	55                   	push   %ebp
801046e7:	89 e5                	mov    %esp,%ebp
801046e9:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801046ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
801046ed:	8b 50 18             	mov    0x18(%eax),%edx
801046f0:	8b 52 44             	mov    0x44(%edx),%edx
801046f3:	8d 0c 8a             	lea    (%edx,%ecx,4),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801046f6:	8b 10                	mov    (%eax),%edx
argptr(int n, char **pp, int size)
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
801046f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801046fd:	8d 59 04             	lea    0x4(%ecx),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104700:	39 d3                	cmp    %edx,%ebx
80104702:	73 25                	jae    80104729 <argptr+0x49>
80104704:	8d 59 08             	lea    0x8(%ecx),%ebx
80104707:	39 da                	cmp    %ebx,%edx
80104709:	72 1e                	jb     80104729 <argptr+0x49>
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
8010470b:	8b 5d 10             	mov    0x10(%ebp),%ebx
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
8010470e:	8b 49 04             	mov    0x4(%ecx),%ecx
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
80104711:	85 db                	test   %ebx,%ebx
80104713:	78 14                	js     80104729 <argptr+0x49>
80104715:	39 d1                	cmp    %edx,%ecx
80104717:	73 10                	jae    80104729 <argptr+0x49>
80104719:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010471c:	01 cb                	add    %ecx,%ebx
8010471e:	39 d3                	cmp    %edx,%ebx
80104720:	77 07                	ja     80104729 <argptr+0x49>
    return -1;
  *pp = (char*)i;
80104722:	8b 45 0c             	mov    0xc(%ebp),%eax
80104725:	89 08                	mov    %ecx,(%eax)
  return 0;
80104727:	31 c0                	xor    %eax,%eax
}
80104729:	5b                   	pop    %ebx
8010472a:	5d                   	pop    %ebp
8010472b:	c3                   	ret    
8010472c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104730 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104730:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104736:	55                   	push   %ebp
80104737:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104739:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010473c:	8b 50 18             	mov    0x18(%eax),%edx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010473f:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104741:	8b 52 44             	mov    0x44(%edx),%edx
80104744:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
80104747:	8d 4a 04             	lea    0x4(%edx),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010474a:	39 c1                	cmp    %eax,%ecx
8010474c:	73 07                	jae    80104755 <argstr+0x25>
8010474e:	8d 4a 08             	lea    0x8(%edx),%ecx
80104751:	39 c8                	cmp    %ecx,%eax
80104753:	73 0b                	jae    80104760 <argstr+0x30>
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104755:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
8010475a:	5d                   	pop    %ebp
8010475b:	c3                   	ret    
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
80104760:	8b 4a 04             	mov    0x4(%edx),%ecx
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
80104763:	39 c1                	cmp    %eax,%ecx
80104765:	73 ee                	jae    80104755 <argstr+0x25>
    return -1;
  *pp = (char*)addr;
80104767:	8b 55 0c             	mov    0xc(%ebp),%edx
8010476a:	89 c8                	mov    %ecx,%eax
8010476c:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
8010476e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104775:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104777:	39 d1                	cmp    %edx,%ecx
80104779:	73 da                	jae    80104755 <argstr+0x25>
    if(*s == 0)
8010477b:	80 39 00             	cmpb   $0x0,(%ecx)
8010477e:	75 12                	jne    80104792 <argstr+0x62>
80104780:	eb 1e                	jmp    801047a0 <argstr+0x70>
80104782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104788:	80 38 00             	cmpb   $0x0,(%eax)
8010478b:	90                   	nop
8010478c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104790:	74 0e                	je     801047a0 <argstr+0x70>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104792:	83 c0 01             	add    $0x1,%eax
80104795:	39 c2                	cmp    %eax,%edx
80104797:	77 ef                	ja     80104788 <argstr+0x58>
80104799:	eb ba                	jmp    80104755 <argstr+0x25>
8010479b:	90                   	nop
8010479c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == 0)
      return s - *pp;
801047a0:	29 c8                	sub    %ecx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801047a2:	5d                   	pop    %ebp
801047a3:	c3                   	ret    
801047a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801047b0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	53                   	push   %ebx
801047b4:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
801047b7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801047be:	8b 5a 18             	mov    0x18(%edx),%ebx
801047c1:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801047c4:	8d 48 ff             	lea    -0x1(%eax),%ecx
801047c7:	83 f9 14             	cmp    $0x14,%ecx
801047ca:	77 1c                	ja     801047e8 <syscall+0x38>
801047cc:	8b 0c 85 a0 74 10 80 	mov    -0x7fef8b60(,%eax,4),%ecx
801047d3:	85 c9                	test   %ecx,%ecx
801047d5:	74 11                	je     801047e8 <syscall+0x38>
    proc->tf->eax = syscalls[num]();
801047d7:	ff d1                	call   *%ecx
801047d9:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
801047dc:	83 c4 14             	add    $0x14,%esp
801047df:	5b                   	pop    %ebx
801047e0:	5d                   	pop    %ebp
801047e1:	c3                   	ret    
801047e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801047e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
            proc->pid, proc->name, num);
801047ec:	8d 42 6c             	lea    0x6c(%edx),%eax
801047ef:	89 44 24 08          	mov    %eax,0x8(%esp)

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801047f3:	8b 42 10             	mov    0x10(%edx),%eax
801047f6:	c7 04 24 7d 74 10 80 	movl   $0x8010747d,(%esp)
801047fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80104801:	e8 4a be ff ff       	call   80100650 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80104806:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010480c:	8b 40 18             	mov    0x18(%eax),%eax
8010480f:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104816:	83 c4 14             	add    $0x14,%esp
80104819:	5b                   	pop    %ebx
8010481a:	5d                   	pop    %ebp
8010481b:	c3                   	ret    
8010481c:	66 90                	xchg   %ax,%ax
8010481e:	66 90                	xchg   %ax,%ax

80104820 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	57                   	push   %edi
80104824:	56                   	push   %esi
80104825:	53                   	push   %ebx
80104826:	83 ec 4c             	sub    $0x4c,%esp
80104829:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010482c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010482f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104832:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104836:	89 04 24             	mov    %eax,(%esp)
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104839:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010483c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010483f:	e8 2c d7 ff ff       	call   80101f70 <nameiparent>
80104844:	85 c0                	test   %eax,%eax
80104846:	89 c7                	mov    %eax,%edi
80104848:	0f 84 da 00 00 00    	je     80104928 <create+0x108>
    return 0;
  ilock(dp);
8010484e:	89 04 24             	mov    %eax,(%esp)
80104851:	e8 ca ce ff ff       	call   80101720 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104856:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104859:	89 44 24 08          	mov    %eax,0x8(%esp)
8010485d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104861:	89 3c 24             	mov    %edi,(%esp)
80104864:	e8 a7 d3 ff ff       	call   80101c10 <dirlookup>
80104869:	85 c0                	test   %eax,%eax
8010486b:	89 c6                	mov    %eax,%esi
8010486d:	74 41                	je     801048b0 <create+0x90>
    iunlockput(dp);
8010486f:	89 3c 24             	mov    %edi,(%esp)
80104872:	e8 e9 d0 ff ff       	call   80101960 <iunlockput>
    ilock(ip);
80104877:	89 34 24             	mov    %esi,(%esp)
8010487a:	e8 a1 ce ff ff       	call   80101720 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010487f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104884:	75 12                	jne    80104898 <create+0x78>
80104886:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010488b:	89 f0                	mov    %esi,%eax
8010488d:	75 09                	jne    80104898 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010488f:	83 c4 4c             	add    $0x4c,%esp
80104892:	5b                   	pop    %ebx
80104893:	5e                   	pop    %esi
80104894:	5f                   	pop    %edi
80104895:	5d                   	pop    %ebp
80104896:	c3                   	ret    
80104897:	90                   	nop
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104898:	89 34 24             	mov    %esi,(%esp)
8010489b:	e8 c0 d0 ff ff       	call   80101960 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801048a0:	83 c4 4c             	add    $0x4c,%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801048a3:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801048a5:	5b                   	pop    %ebx
801048a6:	5e                   	pop    %esi
801048a7:	5f                   	pop    %edi
801048a8:	5d                   	pop    %ebp
801048a9:	c3                   	ret    
801048aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801048b0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801048b4:	89 44 24 04          	mov    %eax,0x4(%esp)
801048b8:	8b 07                	mov    (%edi),%eax
801048ba:	89 04 24             	mov    %eax,(%esp)
801048bd:	e8 ce cc ff ff       	call   80101590 <ialloc>
801048c2:	85 c0                	test   %eax,%eax
801048c4:	89 c6                	mov    %eax,%esi
801048c6:	0f 84 bf 00 00 00    	je     8010498b <create+0x16b>
    panic("create: ialloc");

  ilock(ip);
801048cc:	89 04 24             	mov    %eax,(%esp)
801048cf:	e8 4c ce ff ff       	call   80101720 <ilock>
  ip->major = major;
801048d4:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801048d8:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801048dc:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801048e0:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801048e4:	b8 01 00 00 00       	mov    $0x1,%eax
801048e9:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801048ed:	89 34 24             	mov    %esi,(%esp)
801048f0:	e8 6b cd ff ff       	call   80101660 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801048f5:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801048fa:	74 34                	je     80104930 <create+0x110>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
801048fc:	8b 46 04             	mov    0x4(%esi),%eax
801048ff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104903:	89 3c 24             	mov    %edi,(%esp)
80104906:	89 44 24 08          	mov    %eax,0x8(%esp)
8010490a:	e8 61 d5 ff ff       	call   80101e70 <dirlink>
8010490f:	85 c0                	test   %eax,%eax
80104911:	78 6c                	js     8010497f <create+0x15f>
    panic("create: dirlink");

  iunlockput(dp);
80104913:	89 3c 24             	mov    %edi,(%esp)
80104916:	e8 45 d0 ff ff       	call   80101960 <iunlockput>

  return ip;
}
8010491b:	83 c4 4c             	add    $0x4c,%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
8010491e:	89 f0                	mov    %esi,%eax
}
80104920:	5b                   	pop    %ebx
80104921:	5e                   	pop    %esi
80104922:	5f                   	pop    %edi
80104923:	5d                   	pop    %ebp
80104924:	c3                   	ret    
80104925:	8d 76 00             	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104928:	31 c0                	xor    %eax,%eax
8010492a:	e9 60 ff ff ff       	jmp    8010488f <create+0x6f>
8010492f:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104930:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104935:	89 3c 24             	mov    %edi,(%esp)
80104938:	e8 23 cd ff ff       	call   80101660 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010493d:	8b 46 04             	mov    0x4(%esi),%eax
80104940:	c7 44 24 04 14 75 10 	movl   $0x80107514,0x4(%esp)
80104947:	80 
80104948:	89 34 24             	mov    %esi,(%esp)
8010494b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010494f:	e8 1c d5 ff ff       	call   80101e70 <dirlink>
80104954:	85 c0                	test   %eax,%eax
80104956:	78 1b                	js     80104973 <create+0x153>
80104958:	8b 47 04             	mov    0x4(%edi),%eax
8010495b:	c7 44 24 04 13 75 10 	movl   $0x80107513,0x4(%esp)
80104962:	80 
80104963:	89 34 24             	mov    %esi,(%esp)
80104966:	89 44 24 08          	mov    %eax,0x8(%esp)
8010496a:	e8 01 d5 ff ff       	call   80101e70 <dirlink>
8010496f:	85 c0                	test   %eax,%eax
80104971:	79 89                	jns    801048fc <create+0xdc>
      panic("create dots");
80104973:	c7 04 24 07 75 10 80 	movl   $0x80107507,(%esp)
8010497a:	e8 e1 b9 ff ff       	call   80100360 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010497f:	c7 04 24 16 75 10 80 	movl   $0x80107516,(%esp)
80104986:	e8 d5 b9 ff ff       	call   80100360 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
8010498b:	c7 04 24 f8 74 10 80 	movl   $0x801074f8,(%esp)
80104992:	e8 c9 b9 ff ff       	call   80100360 <panic>
80104997:	89 f6                	mov    %esi,%esi
80104999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049a0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	56                   	push   %esi
801049a4:	89 c6                	mov    %eax,%esi
801049a6:	53                   	push   %ebx
801049a7:	89 d3                	mov    %edx,%ebx
801049a9:	83 ec 20             	sub    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801049ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049af:	89 44 24 04          	mov    %eax,0x4(%esp)
801049b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801049ba:	e8 e1 fc ff ff       	call   801046a0 <argint>
801049bf:	85 c0                	test   %eax,%eax
801049c1:	78 35                	js     801049f8 <argfd.constprop.0+0x58>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801049c3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801049c6:	83 f9 0f             	cmp    $0xf,%ecx
801049c9:	77 2d                	ja     801049f8 <argfd.constprop.0+0x58>
801049cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049d1:	8b 44 88 28          	mov    0x28(%eax,%ecx,4),%eax
801049d5:	85 c0                	test   %eax,%eax
801049d7:	74 1f                	je     801049f8 <argfd.constprop.0+0x58>
    return -1;
  if(pfd)
801049d9:	85 f6                	test   %esi,%esi
801049db:	74 02                	je     801049df <argfd.constprop.0+0x3f>
    *pfd = fd;
801049dd:	89 0e                	mov    %ecx,(%esi)
  if(pf)
801049df:	85 db                	test   %ebx,%ebx
801049e1:	74 0d                	je     801049f0 <argfd.constprop.0+0x50>
    *pf = f;
801049e3:	89 03                	mov    %eax,(%ebx)
  return 0;
801049e5:	31 c0                	xor    %eax,%eax
}
801049e7:	83 c4 20             	add    $0x20,%esp
801049ea:	5b                   	pop    %ebx
801049eb:	5e                   	pop    %esi
801049ec:	5d                   	pop    %ebp
801049ed:	c3                   	ret    
801049ee:	66 90                	xchg   %ax,%ax
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
801049f0:	31 c0                	xor    %eax,%eax
801049f2:	eb f3                	jmp    801049e7 <argfd.constprop.0+0x47>
801049f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
801049f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049fd:	eb e8                	jmp    801049e7 <argfd.constprop.0+0x47>
801049ff:	90                   	nop

80104a00 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104a00:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104a01:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104a03:	89 e5                	mov    %esp,%ebp
80104a05:	53                   	push   %ebx
80104a06:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104a09:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104a0c:	e8 8f ff ff ff       	call   801049a0 <argfd.constprop.0>
80104a11:	85 c0                	test   %eax,%eax
80104a13:	78 1b                	js     80104a30 <sys_dup+0x30>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104a15:	8b 55 f4             	mov    -0xc(%ebp),%edx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104a18:	31 db                	xor    %ebx,%ebx
80104a1a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    if(proc->ofile[fd] == 0){
80104a20:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
80104a24:	85 c9                	test   %ecx,%ecx
80104a26:	74 18                	je     80104a40 <sys_dup+0x40>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104a28:	83 c3 01             	add    $0x1,%ebx
80104a2b:	83 fb 10             	cmp    $0x10,%ebx
80104a2e:	75 f0                	jne    80104a20 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104a30:	83 c4 24             	add    $0x24,%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104a33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104a38:	5b                   	pop    %ebx
80104a39:	5d                   	pop    %ebp
80104a3a:	c3                   	ret    
80104a3b:	90                   	nop
80104a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104a40:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104a44:	89 14 24             	mov    %edx,(%esp)
80104a47:	e8 f4 c3 ff ff       	call   80100e40 <filedup>
  return fd;
}
80104a4c:	83 c4 24             	add    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104a4f:	89 d8                	mov    %ebx,%eax
}
80104a51:	5b                   	pop    %ebx
80104a52:	5d                   	pop    %ebp
80104a53:	c3                   	ret    
80104a54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a60 <sys_read>:

int
sys_read(void)
{
80104a60:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a61:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104a63:	89 e5                	mov    %esp,%ebp
80104a65:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a68:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104a6b:	e8 30 ff ff ff       	call   801049a0 <argfd.constprop.0>
80104a70:	85 c0                	test   %eax,%eax
80104a72:	78 54                	js     80104ac8 <sys_read+0x68>
80104a74:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a77:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a7b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104a82:	e8 19 fc ff ff       	call   801046a0 <argint>
80104a87:	85 c0                	test   %eax,%eax
80104a89:	78 3d                	js     80104ac8 <sys_read+0x68>
80104a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a8e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a95:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aa0:	e8 3b fc ff ff       	call   801046e0 <argptr>
80104aa5:	85 c0                	test   %eax,%eax
80104aa7:	78 1f                	js     80104ac8 <sys_read+0x68>
    return -1;
  return fileread(f, p, n);
80104aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104aac:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ab7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104aba:	89 04 24             	mov    %eax,(%esp)
80104abd:	e8 de c4 ff ff       	call   80100fa0 <fileread>
}
80104ac2:	c9                   	leave  
80104ac3:	c3                   	ret    
80104ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104ac8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104acd:	c9                   	leave  
80104ace:	c3                   	ret    
80104acf:	90                   	nop

80104ad0 <sys_write>:

int
sys_write(void)
{
80104ad0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ad1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104ad3:	89 e5                	mov    %esp,%ebp
80104ad5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ad8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104adb:	e8 c0 fe ff ff       	call   801049a0 <argfd.constprop.0>
80104ae0:	85 c0                	test   %eax,%eax
80104ae2:	78 54                	js     80104b38 <sys_write+0x68>
80104ae4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aeb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104af2:	e8 a9 fb ff ff       	call   801046a0 <argint>
80104af7:	85 c0                	test   %eax,%eax
80104af9:	78 3d                	js     80104b38 <sys_write+0x68>
80104afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104afe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b05:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b10:	e8 cb fb ff ff       	call   801046e0 <argptr>
80104b15:	85 c0                	test   %eax,%eax
80104b17:	78 1f                	js     80104b38 <sys_write+0x68>
    return -1;
  return filewrite(f, p, n);
80104b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b1c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b23:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b27:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b2a:	89 04 24             	mov    %eax,(%esp)
80104b2d:	e8 0e c5 ff ff       	call   80101040 <filewrite>
}
80104b32:	c9                   	leave  
80104b33:	c3                   	ret    
80104b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104b38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104b3d:	c9                   	leave  
80104b3e:	c3                   	ret    
80104b3f:	90                   	nop

80104b40 <sys_close>:

int
sys_close(void)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104b46:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104b49:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b4c:	e8 4f fe ff ff       	call   801049a0 <argfd.constprop.0>
80104b51:	85 c0                	test   %eax,%eax
80104b53:	78 23                	js     80104b78 <sys_close+0x38>
    return -1;
  proc->ofile[fd] = 0;
80104b55:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b5e:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104b65:	00 
  fileclose(f);
80104b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b69:	89 04 24             	mov    %eax,(%esp)
80104b6c:	e8 1f c3 ff ff       	call   80100e90 <fileclose>
  return 0;
80104b71:	31 c0                	xor    %eax,%eax
}
80104b73:	c9                   	leave  
80104b74:	c3                   	ret    
80104b75:	8d 76 00             	lea    0x0(%esi),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104b78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  proc->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104b7d:	c9                   	leave  
80104b7e:	c3                   	ret    
80104b7f:	90                   	nop

80104b80 <sys_fstat>:

int
sys_fstat(void)
{
80104b80:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b81:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104b83:	89 e5                	mov    %esp,%ebp
80104b85:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b88:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104b8b:	e8 10 fe ff ff       	call   801049a0 <argfd.constprop.0>
80104b90:	85 c0                	test   %eax,%eax
80104b92:	78 34                	js     80104bc8 <sys_fstat+0x48>
80104b94:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b97:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104b9e:	00 
80104b9f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ba3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104baa:	e8 31 fb ff ff       	call   801046e0 <argptr>
80104baf:	85 c0                	test   %eax,%eax
80104bb1:	78 15                	js     80104bc8 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80104bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb6:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bbd:	89 04 24             	mov    %eax,(%esp)
80104bc0:	e8 8b c3 ff ff       	call   80100f50 <filestat>
}
80104bc5:	c9                   	leave  
80104bc6:	c3                   	ret    
80104bc7:	90                   	nop
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104bc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104bcd:	c9                   	leave  
80104bce:	c3                   	ret    
80104bcf:	90                   	nop

80104bd0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	57                   	push   %edi
80104bd4:	56                   	push   %esi
80104bd5:	53                   	push   %ebx
80104bd6:	83 ec 3c             	sub    $0x3c,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104bd9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104be0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104be7:	e8 44 fb ff ff       	call   80104730 <argstr>
80104bec:	85 c0                	test   %eax,%eax
80104bee:	0f 88 e6 00 00 00    	js     80104cda <sys_link+0x10a>
80104bf4:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bfb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c02:	e8 29 fb ff ff       	call   80104730 <argstr>
80104c07:	85 c0                	test   %eax,%eax
80104c09:	0f 88 cb 00 00 00    	js     80104cda <sys_link+0x10a>
    return -1;

  begin_op();
80104c0f:	e8 dc df ff ff       	call   80102bf0 <begin_op>
  if((ip = namei(old)) == 0){
80104c14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104c17:	89 04 24             	mov    %eax,(%esp)
80104c1a:	e8 31 d3 ff ff       	call   80101f50 <namei>
80104c1f:	85 c0                	test   %eax,%eax
80104c21:	89 c3                	mov    %eax,%ebx
80104c23:	0f 84 ac 00 00 00    	je     80104cd5 <sys_link+0x105>
    end_op();
    return -1;
  }

  ilock(ip);
80104c29:	89 04 24             	mov    %eax,(%esp)
80104c2c:	e8 ef ca ff ff       	call   80101720 <ilock>
  if(ip->type == T_DIR){
80104c31:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c36:	0f 84 91 00 00 00    	je     80104ccd <sys_link+0xfd>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104c3c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104c41:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104c44:	89 1c 24             	mov    %ebx,(%esp)
80104c47:	e8 14 ca ff ff       	call   80101660 <iupdate>
  iunlock(ip);
80104c4c:	89 1c 24             	mov    %ebx,(%esp)
80104c4f:	e8 9c cb ff ff       	call   801017f0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104c54:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104c57:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c5b:	89 04 24             	mov    %eax,(%esp)
80104c5e:	e8 0d d3 ff ff       	call   80101f70 <nameiparent>
80104c63:	85 c0                	test   %eax,%eax
80104c65:	89 c6                	mov    %eax,%esi
80104c67:	74 4f                	je     80104cb8 <sys_link+0xe8>
    goto bad;
  ilock(dp);
80104c69:	89 04 24             	mov    %eax,(%esp)
80104c6c:	e8 af ca ff ff       	call   80101720 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104c71:	8b 03                	mov    (%ebx),%eax
80104c73:	39 06                	cmp    %eax,(%esi)
80104c75:	75 39                	jne    80104cb0 <sys_link+0xe0>
80104c77:	8b 43 04             	mov    0x4(%ebx),%eax
80104c7a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c7e:	89 34 24             	mov    %esi,(%esp)
80104c81:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c85:	e8 e6 d1 ff ff       	call   80101e70 <dirlink>
80104c8a:	85 c0                	test   %eax,%eax
80104c8c:	78 22                	js     80104cb0 <sys_link+0xe0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104c8e:	89 34 24             	mov    %esi,(%esp)
80104c91:	e8 ca cc ff ff       	call   80101960 <iunlockput>
  iput(ip);
80104c96:	89 1c 24             	mov    %ebx,(%esp)
80104c99:	e8 92 cb ff ff       	call   80101830 <iput>

  end_op();
80104c9e:	e8 bd df ff ff       	call   80102c60 <end_op>
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104ca3:	83 c4 3c             	add    $0x3c,%esp
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;
80104ca6:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104ca8:	5b                   	pop    %ebx
80104ca9:	5e                   	pop    %esi
80104caa:	5f                   	pop    %edi
80104cab:	5d                   	pop    %ebp
80104cac:	c3                   	ret    
80104cad:	8d 76 00             	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104cb0:	89 34 24             	mov    %esi,(%esp)
80104cb3:	e8 a8 cc ff ff       	call   80101960 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80104cb8:	89 1c 24             	mov    %ebx,(%esp)
80104cbb:	e8 60 ca ff ff       	call   80101720 <ilock>
  ip->nlink--;
80104cc0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104cc5:	89 1c 24             	mov    %ebx,(%esp)
80104cc8:	e8 93 c9 ff ff       	call   80101660 <iupdate>
  iunlockput(ip);
80104ccd:	89 1c 24             	mov    %ebx,(%esp)
80104cd0:	e8 8b cc ff ff       	call   80101960 <iunlockput>
  end_op();
80104cd5:	e8 86 df ff ff       	call   80102c60 <end_op>
  return -1;
}
80104cda:	83 c4 3c             	add    $0x3c,%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104cdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ce2:	5b                   	pop    %ebx
80104ce3:	5e                   	pop    %esi
80104ce4:	5f                   	pop    %edi
80104ce5:	5d                   	pop    %ebp
80104ce6:	c3                   	ret    
80104ce7:	89 f6                	mov    %esi,%esi
80104ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cf0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	57                   	push   %edi
80104cf4:	56                   	push   %esi
80104cf5:	53                   	push   %ebx
80104cf6:	83 ec 5c             	sub    $0x5c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104cf9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d00:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104d07:	e8 24 fa ff ff       	call   80104730 <argstr>
80104d0c:	85 c0                	test   %eax,%eax
80104d0e:	0f 88 76 01 00 00    	js     80104e8a <sys_unlink+0x19a>
    return -1;

  begin_op();
80104d14:	e8 d7 de ff ff       	call   80102bf0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104d19:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104d1c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104d1f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d23:	89 04 24             	mov    %eax,(%esp)
80104d26:	e8 45 d2 ff ff       	call   80101f70 <nameiparent>
80104d2b:	85 c0                	test   %eax,%eax
80104d2d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104d30:	0f 84 4f 01 00 00    	je     80104e85 <sys_unlink+0x195>
    end_op();
    return -1;
  }

  ilock(dp);
80104d36:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104d39:	89 34 24             	mov    %esi,(%esp)
80104d3c:	e8 df c9 ff ff       	call   80101720 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104d41:	c7 44 24 04 14 75 10 	movl   $0x80107514,0x4(%esp)
80104d48:	80 
80104d49:	89 1c 24             	mov    %ebx,(%esp)
80104d4c:	e8 8f ce ff ff       	call   80101be0 <namecmp>
80104d51:	85 c0                	test   %eax,%eax
80104d53:	0f 84 21 01 00 00    	je     80104e7a <sys_unlink+0x18a>
80104d59:	c7 44 24 04 13 75 10 	movl   $0x80107513,0x4(%esp)
80104d60:	80 
80104d61:	89 1c 24             	mov    %ebx,(%esp)
80104d64:	e8 77 ce ff ff       	call   80101be0 <namecmp>
80104d69:	85 c0                	test   %eax,%eax
80104d6b:	0f 84 09 01 00 00    	je     80104e7a <sys_unlink+0x18a>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104d71:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104d74:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d78:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d7c:	89 34 24             	mov    %esi,(%esp)
80104d7f:	e8 8c ce ff ff       	call   80101c10 <dirlookup>
80104d84:	85 c0                	test   %eax,%eax
80104d86:	89 c3                	mov    %eax,%ebx
80104d88:	0f 84 ec 00 00 00    	je     80104e7a <sys_unlink+0x18a>
    goto bad;
  ilock(ip);
80104d8e:	89 04 24             	mov    %eax,(%esp)
80104d91:	e8 8a c9 ff ff       	call   80101720 <ilock>

  if(ip->nlink < 1)
80104d96:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104d9b:	0f 8e 24 01 00 00    	jle    80104ec5 <sys_unlink+0x1d5>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104da1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104da6:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104da9:	74 7d                	je     80104e28 <sys_unlink+0x138>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104dab:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104db2:	00 
80104db3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104dba:	00 
80104dbb:	89 34 24             	mov    %esi,(%esp)
80104dbe:	e8 0d f6 ff ff       	call   801043d0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104dc3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104dc6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104dcd:	00 
80104dce:	89 74 24 04          	mov    %esi,0x4(%esp)
80104dd2:	89 44 24 08          	mov    %eax,0x8(%esp)
80104dd6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104dd9:	89 04 24             	mov    %eax,(%esp)
80104ddc:	e8 cf cc ff ff       	call   80101ab0 <writei>
80104de1:	83 f8 10             	cmp    $0x10,%eax
80104de4:	0f 85 cf 00 00 00    	jne    80104eb9 <sys_unlink+0x1c9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104dea:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104def:	0f 84 a3 00 00 00    	je     80104e98 <sys_unlink+0x1a8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104df5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104df8:	89 04 24             	mov    %eax,(%esp)
80104dfb:	e8 60 cb ff ff       	call   80101960 <iunlockput>

  ip->nlink--;
80104e00:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e05:	89 1c 24             	mov    %ebx,(%esp)
80104e08:	e8 53 c8 ff ff       	call   80101660 <iupdate>
  iunlockput(ip);
80104e0d:	89 1c 24             	mov    %ebx,(%esp)
80104e10:	e8 4b cb ff ff       	call   80101960 <iunlockput>

  end_op();
80104e15:	e8 46 de ff ff       	call   80102c60 <end_op>

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104e1a:	83 c4 5c             	add    $0x5c,%esp
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;
80104e1d:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104e1f:	5b                   	pop    %ebx
80104e20:	5e                   	pop    %esi
80104e21:	5f                   	pop    %edi
80104e22:	5d                   	pop    %ebp
80104e23:	c3                   	ret    
80104e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104e28:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104e2c:	0f 86 79 ff ff ff    	jbe    80104dab <sys_unlink+0xbb>
80104e32:	bf 20 00 00 00       	mov    $0x20,%edi
80104e37:	eb 15                	jmp    80104e4e <sys_unlink+0x15e>
80104e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e40:	8d 57 10             	lea    0x10(%edi),%edx
80104e43:	3b 53 58             	cmp    0x58(%ebx),%edx
80104e46:	0f 83 5f ff ff ff    	jae    80104dab <sys_unlink+0xbb>
80104e4c:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104e4e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104e55:	00 
80104e56:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104e5a:	89 74 24 04          	mov    %esi,0x4(%esp)
80104e5e:	89 1c 24             	mov    %ebx,(%esp)
80104e61:	e8 4a cb ff ff       	call   801019b0 <readi>
80104e66:	83 f8 10             	cmp    $0x10,%eax
80104e69:	75 42                	jne    80104ead <sys_unlink+0x1bd>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104e6b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104e70:	74 ce                	je     80104e40 <sys_unlink+0x150>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104e72:	89 1c 24             	mov    %ebx,(%esp)
80104e75:	e8 e6 ca ff ff       	call   80101960 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104e7a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e7d:	89 04 24             	mov    %eax,(%esp)
80104e80:	e8 db ca ff ff       	call   80101960 <iunlockput>
  end_op();
80104e85:	e8 d6 dd ff ff       	call   80102c60 <end_op>
  return -1;
}
80104e8a:	83 c4 5c             	add    $0x5c,%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104e8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e92:	5b                   	pop    %ebx
80104e93:	5e                   	pop    %esi
80104e94:	5f                   	pop    %edi
80104e95:	5d                   	pop    %ebp
80104e96:	c3                   	ret    
80104e97:	90                   	nop

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104e98:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e9b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104ea0:	89 04 24             	mov    %eax,(%esp)
80104ea3:	e8 b8 c7 ff ff       	call   80101660 <iupdate>
80104ea8:	e9 48 ff ff ff       	jmp    80104df5 <sys_unlink+0x105>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104ead:	c7 04 24 38 75 10 80 	movl   $0x80107538,(%esp)
80104eb4:	e8 a7 b4 ff ff       	call   80100360 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104eb9:	c7 04 24 4a 75 10 80 	movl   $0x8010754a,(%esp)
80104ec0:	e8 9b b4 ff ff       	call   80100360 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104ec5:	c7 04 24 26 75 10 80 	movl   $0x80107526,(%esp)
80104ecc:	e8 8f b4 ff ff       	call   80100360 <panic>
80104ed1:	eb 0d                	jmp    80104ee0 <sys_open>
80104ed3:	90                   	nop
80104ed4:	90                   	nop
80104ed5:	90                   	nop
80104ed6:	90                   	nop
80104ed7:	90                   	nop
80104ed8:	90                   	nop
80104ed9:	90                   	nop
80104eda:	90                   	nop
80104edb:	90                   	nop
80104edc:	90                   	nop
80104edd:	90                   	nop
80104ede:	90                   	nop
80104edf:	90                   	nop

80104ee0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	57                   	push   %edi
80104ee4:	56                   	push   %esi
80104ee5:	53                   	push   %ebx
80104ee6:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104ee9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104eec:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ef0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ef7:	e8 34 f8 ff ff       	call   80104730 <argstr>
80104efc:	85 c0                	test   %eax,%eax
80104efe:	0f 88 81 00 00 00    	js     80104f85 <sys_open+0xa5>
80104f04:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104f07:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f12:	e8 89 f7 ff ff       	call   801046a0 <argint>
80104f17:	85 c0                	test   %eax,%eax
80104f19:	78 6a                	js     80104f85 <sys_open+0xa5>
    return -1;

  begin_op();
80104f1b:	e8 d0 dc ff ff       	call   80102bf0 <begin_op>

  if(omode & O_CREATE){
80104f20:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104f24:	75 72                	jne    80104f98 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104f26:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f29:	89 04 24             	mov    %eax,(%esp)
80104f2c:	e8 1f d0 ff ff       	call   80101f50 <namei>
80104f31:	85 c0                	test   %eax,%eax
80104f33:	89 c7                	mov    %eax,%edi
80104f35:	74 49                	je     80104f80 <sys_open+0xa0>
      end_op();
      return -1;
    }
    ilock(ip);
80104f37:	89 04 24             	mov    %eax,(%esp)
80104f3a:	e8 e1 c7 ff ff       	call   80101720 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104f3f:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80104f44:	0f 84 ae 00 00 00    	je     80104ff8 <sys_open+0x118>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104f4a:	e8 81 be ff ff       	call   80100dd0 <filealloc>
80104f4f:	85 c0                	test   %eax,%eax
80104f51:	89 c6                	mov    %eax,%esi
80104f53:	74 23                	je     80104f78 <sys_open+0x98>
80104f55:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104f5c:	31 db                	xor    %ebx,%ebx
80104f5e:	66 90                	xchg   %ax,%ax
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80104f60:	8b 44 9a 28          	mov    0x28(%edx,%ebx,4),%eax
80104f64:	85 c0                	test   %eax,%eax
80104f66:	74 50                	je     80104fb8 <sys_open+0xd8>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104f68:	83 c3 01             	add    $0x1,%ebx
80104f6b:	83 fb 10             	cmp    $0x10,%ebx
80104f6e:	75 f0                	jne    80104f60 <sys_open+0x80>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80104f70:	89 34 24             	mov    %esi,(%esp)
80104f73:	e8 18 bf ff ff       	call   80100e90 <fileclose>
    iunlockput(ip);
80104f78:	89 3c 24             	mov    %edi,(%esp)
80104f7b:	e8 e0 c9 ff ff       	call   80101960 <iunlockput>
    end_op();
80104f80:	e8 db dc ff ff       	call   80102c60 <end_op>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104f85:	83 c4 2c             	add    $0x2c,%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80104f88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104f8d:	5b                   	pop    %ebx
80104f8e:	5e                   	pop    %esi
80104f8f:	5f                   	pop    %edi
80104f90:	5d                   	pop    %ebp
80104f91:	c3                   	ret    
80104f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104f98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f9b:	31 c9                	xor    %ecx,%ecx
80104f9d:	ba 02 00 00 00       	mov    $0x2,%edx
80104fa2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fa9:	e8 72 f8 ff ff       	call   80104820 <create>
    if(ip == 0){
80104fae:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104fb0:	89 c7                	mov    %eax,%edi
    if(ip == 0){
80104fb2:	75 96                	jne    80104f4a <sys_open+0x6a>
80104fb4:	eb ca                	jmp    80104f80 <sys_open+0xa0>
80104fb6:	66 90                	xchg   %ax,%ax
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104fb8:	89 74 9a 28          	mov    %esi,0x28(%edx,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104fbc:	89 3c 24             	mov    %edi,(%esp)
80104fbf:	e8 2c c8 ff ff       	call   801017f0 <iunlock>
  end_op();
80104fc4:	e8 97 dc ff ff       	call   80102c60 <end_op>

  f->type = FD_INODE;
80104fc9:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104fcf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80104fd2:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
80104fd5:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
80104fdc:	89 d0                	mov    %edx,%eax
80104fde:	83 e0 01             	and    $0x1,%eax
80104fe1:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104fe4:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104fe7:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
80104fea:	89 d8                	mov    %ebx,%eax

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104fec:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
}
80104ff0:	83 c4 2c             	add    $0x2c,%esp
80104ff3:	5b                   	pop    %ebx
80104ff4:	5e                   	pop    %esi
80104ff5:	5f                   	pop    %edi
80104ff6:	5d                   	pop    %ebp
80104ff7:	c3                   	ret    
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80104ff8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104ffb:	85 d2                	test   %edx,%edx
80104ffd:	0f 84 47 ff ff ff    	je     80104f4a <sys_open+0x6a>
80105003:	e9 70 ff ff ff       	jmp    80104f78 <sys_open+0x98>
80105008:	90                   	nop
80105009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105010 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105016:	e8 d5 db ff ff       	call   80102bf0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010501b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010501e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105022:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105029:	e8 02 f7 ff ff       	call   80104730 <argstr>
8010502e:	85 c0                	test   %eax,%eax
80105030:	78 2e                	js     80105060 <sys_mkdir+0x50>
80105032:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105035:	31 c9                	xor    %ecx,%ecx
80105037:	ba 01 00 00 00       	mov    $0x1,%edx
8010503c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105043:	e8 d8 f7 ff ff       	call   80104820 <create>
80105048:	85 c0                	test   %eax,%eax
8010504a:	74 14                	je     80105060 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010504c:	89 04 24             	mov    %eax,(%esp)
8010504f:	e8 0c c9 ff ff       	call   80101960 <iunlockput>
  end_op();
80105054:	e8 07 dc ff ff       	call   80102c60 <end_op>
  return 0;
80105059:	31 c0                	xor    %eax,%eax
}
8010505b:	c9                   	leave  
8010505c:	c3                   	ret    
8010505d:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105060:	e8 fb db ff ff       	call   80102c60 <end_op>
    return -1;
80105065:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010506a:	c9                   	leave  
8010506b:	c3                   	ret    
8010506c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105070 <sys_mknod>:

int
sys_mknod(void)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105076:	e8 75 db ff ff       	call   80102bf0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010507b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010507e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105082:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105089:	e8 a2 f6 ff ff       	call   80104730 <argstr>
8010508e:	85 c0                	test   %eax,%eax
80105090:	78 5e                	js     801050f0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105092:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105095:	89 44 24 04          	mov    %eax,0x4(%esp)
80105099:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801050a0:	e8 fb f5 ff ff       	call   801046a0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801050a5:	85 c0                	test   %eax,%eax
801050a7:	78 47                	js     801050f0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801050a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801050b0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801050b7:	e8 e4 f5 ff ff       	call   801046a0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801050bc:	85 c0                	test   %eax,%eax
801050be:	78 30                	js     801050f0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801050c0:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801050c4:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
801050c9:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801050cd:	89 04 24             	mov    %eax,(%esp)
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801050d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801050d3:	e8 48 f7 ff ff       	call   80104820 <create>
801050d8:	85 c0                	test   %eax,%eax
801050da:	74 14                	je     801050f0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
801050dc:	89 04 24             	mov    %eax,(%esp)
801050df:	e8 7c c8 ff ff       	call   80101960 <iunlockput>
  end_op();
801050e4:	e8 77 db ff ff       	call   80102c60 <end_op>
  return 0;
801050e9:	31 c0                	xor    %eax,%eax
}
801050eb:	c9                   	leave  
801050ec:	c3                   	ret    
801050ed:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801050f0:	e8 6b db ff ff       	call   80102c60 <end_op>
    return -1;
801050f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801050fa:	c9                   	leave  
801050fb:	c3                   	ret    
801050fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105100 <sys_chdir>:

int
sys_chdir(void)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	53                   	push   %ebx
80105104:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105107:	e8 e4 da ff ff       	call   80102bf0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010510c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010510f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105113:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010511a:	e8 11 f6 ff ff       	call   80104730 <argstr>
8010511f:	85 c0                	test   %eax,%eax
80105121:	78 5a                	js     8010517d <sys_chdir+0x7d>
80105123:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105126:	89 04 24             	mov    %eax,(%esp)
80105129:	e8 22 ce ff ff       	call   80101f50 <namei>
8010512e:	85 c0                	test   %eax,%eax
80105130:	89 c3                	mov    %eax,%ebx
80105132:	74 49                	je     8010517d <sys_chdir+0x7d>
    end_op();
    return -1;
  }
  ilock(ip);
80105134:	89 04 24             	mov    %eax,(%esp)
80105137:	e8 e4 c5 ff ff       	call   80101720 <ilock>
  if(ip->type != T_DIR){
8010513c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105141:	89 1c 24             	mov    %ebx,(%esp)
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
80105144:	75 32                	jne    80105178 <sys_chdir+0x78>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105146:	e8 a5 c6 ff ff       	call   801017f0 <iunlock>
  iput(proc->cwd);
8010514b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105151:	8b 40 68             	mov    0x68(%eax),%eax
80105154:	89 04 24             	mov    %eax,(%esp)
80105157:	e8 d4 c6 ff ff       	call   80101830 <iput>
  end_op();
8010515c:	e8 ff da ff ff       	call   80102c60 <end_op>
  proc->cwd = ip;
80105161:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105167:	89 58 68             	mov    %ebx,0x68(%eax)
  return 0;
}
8010516a:	83 c4 24             	add    $0x24,%esp
  }
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
8010516d:	31 c0                	xor    %eax,%eax
}
8010516f:	5b                   	pop    %ebx
80105170:	5d                   	pop    %ebp
80105171:	c3                   	ret    
80105172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105178:	e8 e3 c7 ff ff       	call   80101960 <iunlockput>
    end_op();
8010517d:	e8 de da ff ff       	call   80102c60 <end_op>
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
80105182:	83 c4 24             	add    $0x24,%esp
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
80105185:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
8010518a:	5b                   	pop    %ebx
8010518b:	5d                   	pop    %ebp
8010518c:	c3                   	ret    
8010518d:	8d 76 00             	lea    0x0(%esi),%esi

80105190 <sys_exec>:

int
sys_exec(void)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	57                   	push   %edi
80105194:	56                   	push   %esi
80105195:	53                   	push   %ebx
80105196:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010519c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801051a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801051a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051ad:	e8 7e f5 ff ff       	call   80104730 <argstr>
801051b2:	85 c0                	test   %eax,%eax
801051b4:	0f 88 84 00 00 00    	js     8010523e <sys_exec+0xae>
801051ba:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801051c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801051c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801051cb:	e8 d0 f4 ff ff       	call   801046a0 <argint>
801051d0:	85 c0                	test   %eax,%eax
801051d2:	78 6a                	js     8010523e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801051d4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801051da:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801051dc:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801051e3:	00 
801051e4:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801051ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801051f1:	00 
801051f2:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801051f8:	89 04 24             	mov    %eax,(%esp)
801051fb:	e8 d0 f1 ff ff       	call   801043d0 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105200:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105206:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010520a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010520d:	89 04 24             	mov    %eax,(%esp)
80105210:	e8 0b f4 ff ff       	call   80104620 <fetchint>
80105215:	85 c0                	test   %eax,%eax
80105217:	78 25                	js     8010523e <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80105219:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010521f:	85 c0                	test   %eax,%eax
80105221:	74 2d                	je     80105250 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105223:	89 74 24 04          	mov    %esi,0x4(%esp)
80105227:	89 04 24             	mov    %eax,(%esp)
8010522a:	e8 21 f4 ff ff       	call   80104650 <fetchstr>
8010522f:	85 c0                	test   %eax,%eax
80105231:	78 0b                	js     8010523e <sys_exec+0xae>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105233:	83 c3 01             	add    $0x1,%ebx
80105236:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105239:	83 fb 20             	cmp    $0x20,%ebx
8010523c:	75 c2                	jne    80105200 <sys_exec+0x70>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
8010523e:	81 c4 ac 00 00 00    	add    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105244:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105249:	5b                   	pop    %ebx
8010524a:	5e                   	pop    %esi
8010524b:	5f                   	pop    %edi
8010524c:	5d                   	pop    %ebp
8010524d:	c3                   	ret    
8010524e:	66 90                	xchg   %ax,%ax
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105250:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105256:	89 44 24 04          	mov    %eax,0x4(%esp)
8010525a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105260:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105267:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010526b:	89 04 24             	mov    %eax,(%esp)
8010526e:	e8 6d b7 ff ff       	call   801009e0 <exec>
}
80105273:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105279:	5b                   	pop    %ebx
8010527a:	5e                   	pop    %esi
8010527b:	5f                   	pop    %edi
8010527c:	5d                   	pop    %ebp
8010527d:	c3                   	ret    
8010527e:	66 90                	xchg   %ax,%ax

80105280 <sys_pipe>:

int
sys_pipe(void)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	57                   	push   %edi
80105284:	56                   	push   %esi
80105285:	53                   	push   %ebx
80105286:	83 ec 2c             	sub    $0x2c,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105289:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010528c:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105293:	00 
80105294:	89 44 24 04          	mov    %eax,0x4(%esp)
80105298:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010529f:	e8 3c f4 ff ff       	call   801046e0 <argptr>
801052a4:	85 c0                	test   %eax,%eax
801052a6:	78 7a                	js     80105322 <sys_pipe+0xa2>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801052a8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801052ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801052af:	8d 45 e0             	lea    -0x20(%ebp),%eax
801052b2:	89 04 24             	mov    %eax,(%esp)
801052b5:	e8 66 e0 ff ff       	call   80103320 <pipealloc>
801052ba:	85 c0                	test   %eax,%eax
801052bc:	78 64                	js     80105322 <sys_pipe+0xa2>
801052be:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801052c5:	31 c0                	xor    %eax,%eax
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801052c7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
801052ca:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
801052ce:	85 d2                	test   %edx,%edx
801052d0:	74 16                	je     801052e8 <sys_pipe+0x68>
801052d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801052d8:	83 c0 01             	add    $0x1,%eax
801052db:	83 f8 10             	cmp    $0x10,%eax
801052de:	74 2f                	je     8010530f <sys_pipe+0x8f>
    if(proc->ofile[fd] == 0){
801052e0:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
801052e4:	85 d2                	test   %edx,%edx
801052e6:	75 f0                	jne    801052d8 <sys_pipe+0x58>
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801052e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801052eb:	8d 70 08             	lea    0x8(%eax),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801052ee:	31 d2                	xor    %edx,%edx
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801052f0:	89 5c b1 08          	mov    %ebx,0x8(%ecx,%esi,4)
801052f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
801052f8:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
801052fd:	74 31                	je     80105330 <sys_pipe+0xb0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801052ff:	83 c2 01             	add    $0x1,%edx
80105302:	83 fa 10             	cmp    $0x10,%edx
80105305:	75 f1                	jne    801052f8 <sys_pipe+0x78>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
80105307:	c7 44 b1 08 00 00 00 	movl   $0x0,0x8(%ecx,%esi,4)
8010530e:	00 
    fileclose(rf);
8010530f:	89 1c 24             	mov    %ebx,(%esp)
80105312:	e8 79 bb ff ff       	call   80100e90 <fileclose>
    fileclose(wf);
80105317:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010531a:	89 04 24             	mov    %eax,(%esp)
8010531d:	e8 6e bb ff ff       	call   80100e90 <fileclose>
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105322:	83 c4 2c             	add    $0x2c,%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105325:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010532a:	5b                   	pop    %ebx
8010532b:	5e                   	pop    %esi
8010532c:	5f                   	pop    %edi
8010532d:	5d                   	pop    %ebp
8010532e:	c3                   	ret    
8010532f:	90                   	nop
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105330:	89 7c 91 28          	mov    %edi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105334:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80105337:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
80105339:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010533c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
8010533f:	83 c4 2c             	add    $0x2c,%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105342:	31 c0                	xor    %eax,%eax
}
80105344:	5b                   	pop    %ebx
80105345:	5e                   	pop    %esi
80105346:	5f                   	pop    %edi
80105347:	5d                   	pop    %ebp
80105348:	c3                   	ret    
80105349:	66 90                	xchg   %ax,%ax
8010534b:	66 90                	xchg   %ax,%ax
8010534d:	66 90                	xchg   %ax,%ax
8010534f:	90                   	nop

80105350 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105353:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105354:	e9 17 e6 ff ff       	jmp    80103970 <fork>
80105359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105360 <sys_exit>:
}

int
sys_exit(void)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	83 ec 28             	sub    $0x28,%esp
	int status;
	argint(0, &status);
80105366:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105369:	89 44 24 04          	mov    %eax,0x4(%esp)
8010536d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105374:	e8 27 f3 ff ff       	call   801046a0 <argint>
	exit(status);
80105379:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010537c:	89 04 24             	mov    %eax,(%esp)
8010537f:	e8 4c e8 ff ff       	call   80103bd0 <exit>
	return 0;  // not reached
}
80105384:	31 c0                	xor    %eax,%eax
80105386:	c9                   	leave  
80105387:	c3                   	ret    
80105388:	90                   	nop
80105389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105390 <sys_wait>:

int
sys_wait(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	83 ec 18             	sub    $0x18,%esp
  return wait(0);
80105396:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010539d:	e8 7e ea ff ff       	call   80103e20 <wait>
}
801053a2:	c9                   	leave  
801053a3:	c3                   	ret    
801053a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801053b0 <sys_kill>:

int
sys_kill(void)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801053b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801053bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053c4:	e8 d7 f2 ff ff       	call   801046a0 <argint>
801053c9:	85 c0                	test   %eax,%eax
801053cb:	78 13                	js     801053e0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801053cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053d0:	89 04 24             	mov    %eax,(%esp)
801053d3:	e8 98 eb ff ff       	call   80103f70 <kill>
}
801053d8:	c9                   	leave  
801053d9:	c3                   	ret    
801053da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
801053e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
801053e5:	c9                   	leave  
801053e6:	c3                   	ret    
801053e7:	89 f6                	mov    %esi,%esi
801053e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053f0 <sys_getpid>:

int
sys_getpid(void)
{
  return proc->pid;
801053f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
801053f6:	55                   	push   %ebp
801053f7:	89 e5                	mov    %esp,%ebp
  return proc->pid;
}
801053f9:	5d                   	pop    %ebp
}

int
sys_getpid(void)
{
  return proc->pid;
801053fa:	8b 40 10             	mov    0x10(%eax),%eax
}
801053fd:	c3                   	ret    
801053fe:	66 90                	xchg   %ax,%ax

80105400 <sys_sbrk>:

int
sys_sbrk(void)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	53                   	push   %ebx
80105404:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105407:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010540a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010540e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105415:	e8 86 f2 ff ff       	call   801046a0 <argint>
8010541a:	85 c0                	test   %eax,%eax
8010541c:	78 22                	js     80105440 <sys_sbrk+0x40>
    return -1;
  addr = proc->sz;
8010541e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(growproc(n) < 0)
80105424:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
80105427:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105429:	89 14 24             	mov    %edx,(%esp)
8010542c:	e8 bf e4 ff ff       	call   801038f0 <growproc>
80105431:	85 c0                	test   %eax,%eax
80105433:	78 0b                	js     80105440 <sys_sbrk+0x40>
    return -1;
  return addr;
80105435:	89 d8                	mov    %ebx,%eax
}
80105437:	83 c4 24             	add    $0x24,%esp
8010543a:	5b                   	pop    %ebx
8010543b:	5d                   	pop    %ebp
8010543c:	c3                   	ret    
8010543d:	8d 76 00             	lea    0x0(%esi),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105445:	eb f0                	jmp    80105437 <sys_sbrk+0x37>
80105447:	89 f6                	mov    %esi,%esi
80105449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105450 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	53                   	push   %ebx
80105454:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105457:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010545a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010545e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105465:	e8 36 f2 ff ff       	call   801046a0 <argint>
8010546a:	85 c0                	test   %eax,%eax
8010546c:	78 7e                	js     801054ec <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010546e:	c7 04 24 e0 4d 11 80 	movl   $0x80114de0,(%esp)
80105475:	e8 d6 ed ff ff       	call   80104250 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010547a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
8010547d:	8b 1d 20 56 11 80    	mov    0x80115620,%ebx
  while(ticks - ticks0 < n){
80105483:	85 d2                	test   %edx,%edx
80105485:	75 29                	jne    801054b0 <sys_sleep+0x60>
80105487:	eb 4f                	jmp    801054d8 <sys_sleep+0x88>
80105489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105490:	c7 44 24 04 e0 4d 11 	movl   $0x80114de0,0x4(%esp)
80105497:	80 
80105498:	c7 04 24 20 56 11 80 	movl   $0x80115620,(%esp)
8010549f:	e8 bc e8 ff ff       	call   80103d60 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801054a4:	a1 20 56 11 80       	mov    0x80115620,%eax
801054a9:	29 d8                	sub    %ebx,%eax
801054ab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801054ae:	73 28                	jae    801054d8 <sys_sleep+0x88>
    if(proc->killed){
801054b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054b6:	8b 40 24             	mov    0x24(%eax),%eax
801054b9:	85 c0                	test   %eax,%eax
801054bb:	74 d3                	je     80105490 <sys_sleep+0x40>
      release(&tickslock);
801054bd:	c7 04 24 e0 4d 11 80 	movl   $0x80114de0,(%esp)
801054c4:	e8 b7 ee ff ff       	call   80104380 <release>
      return -1;
801054c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
801054ce:	83 c4 24             	add    $0x24,%esp
801054d1:	5b                   	pop    %ebx
801054d2:	5d                   	pop    %ebp
801054d3:	c3                   	ret    
801054d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801054d8:	c7 04 24 e0 4d 11 80 	movl   $0x80114de0,(%esp)
801054df:	e8 9c ee ff ff       	call   80104380 <release>
  return 0;
}
801054e4:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
801054e7:	31 c0                	xor    %eax,%eax
}
801054e9:	5b                   	pop    %ebx
801054ea:	5d                   	pop    %ebp
801054eb:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
801054ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054f1:	eb db                	jmp    801054ce <sys_sleep+0x7e>
801054f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105500 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	53                   	push   %ebx
80105504:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105507:	c7 04 24 e0 4d 11 80 	movl   $0x80114de0,(%esp)
8010550e:	e8 3d ed ff ff       	call   80104250 <acquire>
  xticks = ticks;
80105513:	8b 1d 20 56 11 80    	mov    0x80115620,%ebx
  release(&tickslock);
80105519:	c7 04 24 e0 4d 11 80 	movl   $0x80114de0,(%esp)
80105520:	e8 5b ee ff ff       	call   80104380 <release>
  return xticks;
}
80105525:	83 c4 14             	add    $0x14,%esp
80105528:	89 d8                	mov    %ebx,%eax
8010552a:	5b                   	pop    %ebx
8010552b:	5d                   	pop    %ebp
8010552c:	c3                   	ret    
8010552d:	66 90                	xchg   %ax,%ax
8010552f:	90                   	nop

80105530 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80105530:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105531:	ba 43 00 00 00       	mov    $0x43,%edx
80105536:	89 e5                	mov    %esp,%ebp
80105538:	b8 34 00 00 00       	mov    $0x34,%eax
8010553d:	83 ec 18             	sub    $0x18,%esp
80105540:	ee                   	out    %al,(%dx)
80105541:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
80105546:	b2 40                	mov    $0x40,%dl
80105548:	ee                   	out    %al,(%dx)
80105549:	b8 2e 00 00 00       	mov    $0x2e,%eax
8010554e:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
8010554f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105556:	e8 05 dd ff ff       	call   80103260 <picenable>
}
8010555b:	c9                   	leave  
8010555c:	c3                   	ret    

8010555d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010555d:	1e                   	push   %ds
  pushl %es
8010555e:	06                   	push   %es
  pushl %fs
8010555f:	0f a0                	push   %fs
  pushl %gs
80105561:	0f a8                	push   %gs
  pushal
80105563:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80105564:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105568:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010556a:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010556c:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80105570:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80105572:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80105574:	54                   	push   %esp
  call trap
80105575:	e8 e6 00 00 00       	call   80105660 <trap>
  addl $4, %esp
8010557a:	83 c4 04             	add    $0x4,%esp

8010557d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010557d:	61                   	popa   
  popl %gs
8010557e:	0f a9                	pop    %gs
  popl %fs
80105580:	0f a1                	pop    %fs
  popl %es
80105582:	07                   	pop    %es
  popl %ds
80105583:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105584:	83 c4 08             	add    $0x8,%esp
  iret
80105587:	cf                   	iret   
80105588:	66 90                	xchg   %ax,%ax
8010558a:	66 90                	xchg   %ax,%ax
8010558c:	66 90                	xchg   %ax,%ax
8010558e:	66 90                	xchg   %ax,%ax

80105590 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105590:	31 c0                	xor    %eax,%eax
80105592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105598:	8b 14 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%edx
8010559f:	b9 08 00 00 00       	mov    $0x8,%ecx
801055a4:	66 89 0c c5 22 4e 11 	mov    %cx,-0x7feeb1de(,%eax,8)
801055ab:	80 
801055ac:	c6 04 c5 24 4e 11 80 	movb   $0x0,-0x7feeb1dc(,%eax,8)
801055b3:	00 
801055b4:	c6 04 c5 25 4e 11 80 	movb   $0x8e,-0x7feeb1db(,%eax,8)
801055bb:	8e 
801055bc:	66 89 14 c5 20 4e 11 	mov    %dx,-0x7feeb1e0(,%eax,8)
801055c3:	80 
801055c4:	c1 ea 10             	shr    $0x10,%edx
801055c7:	66 89 14 c5 26 4e 11 	mov    %dx,-0x7feeb1da(,%eax,8)
801055ce:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801055cf:	83 c0 01             	add    $0x1,%eax
801055d2:	3d 00 01 00 00       	cmp    $0x100,%eax
801055d7:	75 bf                	jne    80105598 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801055d9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801055da:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801055df:	89 e5                	mov    %esp,%ebp
801055e1:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801055e4:	a1 0c a1 10 80       	mov    0x8010a10c,%eax

  initlock(&tickslock, "time");
801055e9:	c7 44 24 04 59 75 10 	movl   $0x80107559,0x4(%esp)
801055f0:	80 
801055f1:	c7 04 24 e0 4d 11 80 	movl   $0x80114de0,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801055f8:	66 89 15 22 50 11 80 	mov    %dx,0x80115022
801055ff:	66 a3 20 50 11 80    	mov    %ax,0x80115020
80105605:	c1 e8 10             	shr    $0x10,%eax
80105608:	c6 05 24 50 11 80 00 	movb   $0x0,0x80115024
8010560f:	c6 05 25 50 11 80 ef 	movb   $0xef,0x80115025
80105616:	66 a3 26 50 11 80    	mov    %ax,0x80115026

  initlock(&tickslock, "time");
8010561c:	e8 af eb ff ff       	call   801041d0 <initlock>
}
80105621:	c9                   	leave  
80105622:	c3                   	ret    
80105623:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105630 <idtinit>:

void
idtinit(void)
{
80105630:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105631:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105636:	89 e5                	mov    %esp,%ebp
80105638:	83 ec 10             	sub    $0x10,%esp
8010563b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010563f:	b8 20 4e 11 80       	mov    $0x80114e20,%eax
80105644:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105648:	c1 e8 10             	shr    $0x10,%eax
8010564b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010564f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105652:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105655:	c9                   	leave  
80105656:	c3                   	ret    
80105657:	89 f6                	mov    %esi,%esi
80105659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105660 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	57                   	push   %edi
80105664:	56                   	push   %esi
80105665:	53                   	push   %ebx
80105666:	83 ec 2c             	sub    $0x2c,%esp
80105669:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010566c:	8b 43 30             	mov    0x30(%ebx),%eax
8010566f:	83 f8 40             	cmp    $0x40,%eax
80105672:	0f 84 08 01 00 00    	je     80105780 <trap+0x120>
    if(proc->killed)
      exit(0);
    return;
  }

  switch(tf->trapno){
80105678:	83 e8 20             	sub    $0x20,%eax
8010567b:	83 f8 1f             	cmp    $0x1f,%eax
8010567e:	77 60                	ja     801056e0 <trap+0x80>
80105680:	ff 24 85 00 76 10 80 	jmp    *-0x7fef8a00(,%eax,4)
80105687:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80105688:	e8 33 d1 ff ff       	call   801027c0 <cpunum>
8010568d:	85 c0                	test   %eax,%eax
8010568f:	90                   	nop
80105690:	0f 84 ea 01 00 00    	je     80105880 <trap+0x220>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
80105696:	e8 c5 d1 ff ff       	call   80102860 <lapiceoi>
8010569b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801056a1:	85 c0                	test   %eax,%eax
801056a3:	74 2d                	je     801056d2 <trap+0x72>
801056a5:	8b 50 24             	mov    0x24(%eax),%edx
801056a8:	85 d2                	test   %edx,%edx
801056aa:	0f 85 9c 00 00 00    	jne    8010574c <trap+0xec>
    exit(0);

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801056b0:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801056b4:	0f 84 9e 01 00 00    	je     80105858 <trap+0x1f8>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801056ba:	8b 40 24             	mov    0x24(%eax),%eax
801056bd:	85 c0                	test   %eax,%eax
801056bf:	74 11                	je     801056d2 <trap+0x72>
801056c1:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801056c5:	83 e0 03             	and    $0x3,%eax
801056c8:	66 83 f8 03          	cmp    $0x3,%ax
801056cc:	0f 84 d8 00 00 00    	je     801057aa <trap+0x14a>
    exit(0);
}
801056d2:	83 c4 2c             	add    $0x2c,%esp
801056d5:	5b                   	pop    %ebx
801056d6:	5e                   	pop    %esi
801056d7:	5f                   	pop    %edi
801056d8:	5d                   	pop    %ebp
801056d9:	c3                   	ret    
801056da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801056e0:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
801056e7:	85 c9                	test   %ecx,%ecx
801056e9:	0f 84 c1 01 00 00    	je     801058b0 <trap+0x250>
801056ef:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801056f3:	0f 84 b7 01 00 00    	je     801058b0 <trap+0x250>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801056f9:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801056fc:	8b 73 38             	mov    0x38(%ebx),%esi
801056ff:	e8 bc d0 ff ff       	call   801027c0 <cpunum>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105704:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010570b:	89 7c 24 1c          	mov    %edi,0x1c(%esp)
8010570f:	89 74 24 18          	mov    %esi,0x18(%esp)
80105713:	89 44 24 14          	mov    %eax,0x14(%esp)
80105717:	8b 43 34             	mov    0x34(%ebx),%eax
8010571a:	89 44 24 10          	mov    %eax,0x10(%esp)
8010571e:	8b 43 30             	mov    0x30(%ebx),%eax
80105721:	89 44 24 0c          	mov    %eax,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105725:	8d 42 6c             	lea    0x6c(%edx),%eax
80105728:	89 44 24 08          	mov    %eax,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010572c:	8b 42 10             	mov    0x10(%edx),%eax
8010572f:	c7 04 24 bc 75 10 80 	movl   $0x801075bc,(%esp)
80105736:	89 44 24 04          	mov    %eax,0x4(%esp)
8010573a:	e8 11 af ff ff       	call   80100650 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
8010573f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105745:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010574c:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
80105750:	83 e2 03             	and    $0x3,%edx
80105753:	66 83 fa 03          	cmp    $0x3,%dx
80105757:	0f 85 53 ff ff ff    	jne    801056b0 <trap+0x50>
    exit(0);
8010575d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105764:	e8 67 e4 ff ff       	call   80103bd0 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105769:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010576f:	85 c0                	test   %eax,%eax
80105771:	0f 85 39 ff ff ff    	jne    801056b0 <trap+0x50>
80105777:	e9 56 ff ff ff       	jmp    801056d2 <trap+0x72>
8010577c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
80105780:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105786:	8b 70 24             	mov    0x24(%eax),%esi
80105789:	85 f6                	test   %esi,%esi
8010578b:	0f 85 af 00 00 00    	jne    80105840 <trap+0x1e0>
      exit(0);
    proc->tf = tf;
80105791:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105794:	e8 17 f0 ff ff       	call   801047b0 <syscall>
    if(proc->killed)
80105799:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010579f:	8b 58 24             	mov    0x24(%eax),%ebx
801057a2:	85 db                	test   %ebx,%ebx
801057a4:	0f 84 28 ff ff ff    	je     801056d2 <trap+0x72>
      exit(0);
801057aa:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit(0);
}
801057b1:	83 c4 2c             	add    $0x2c,%esp
801057b4:	5b                   	pop    %ebx
801057b5:	5e                   	pop    %esi
801057b6:	5f                   	pop    %edi
801057b7:	5d                   	pop    %ebp
    if(proc->killed)
      exit(0);
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit(0);
801057b8:	e9 13 e4 ff ff       	jmp    80103bd0 <exit>
801057bd:	8d 76 00             	lea    0x0(%esi),%esi
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801057c0:	e8 6b ce ff ff       	call   80102630 <kbdintr>
    lapiceoi();
801057c5:	e8 96 d0 ff ff       	call   80102860 <lapiceoi>
801057ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
801057d0:	e9 cc fe ff ff       	jmp    801056a1 <trap+0x41>
801057d5:	8d 76 00             	lea    0x0(%esi),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801057d8:	e8 03 c9 ff ff       	call   801020e0 <ideintr>
    lapiceoi();
801057dd:	e8 7e d0 ff ff       	call   80102860 <lapiceoi>
801057e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
801057e8:	e9 b4 fe ff ff       	jmp    801056a1 <trap+0x41>
801057ed:	8d 76 00             	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801057f0:	e8 2b 02 00 00       	call   80105a20 <uartintr>
    lapiceoi();
801057f5:	e8 66 d0 ff ff       	call   80102860 <lapiceoi>
801057fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105800:	e9 9c fe ff ff       	jmp    801056a1 <trap+0x41>
80105805:	8d 76 00             	lea    0x0(%esi),%esi
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105808:	8b 7b 38             	mov    0x38(%ebx),%edi
8010580b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010580f:	e8 ac cf ff ff       	call   801027c0 <cpunum>
80105814:	c7 04 24 64 75 10 80 	movl   $0x80107564,(%esp)
8010581b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
8010581f:	89 74 24 08          	mov    %esi,0x8(%esp)
80105823:	89 44 24 04          	mov    %eax,0x4(%esp)
80105827:	e8 24 ae ff ff       	call   80100650 <cprintf>
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
8010582c:	e8 2f d0 ff ff       	call   80102860 <lapiceoi>
80105831:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105837:	e9 65 fe ff ff       	jmp    801056a1 <trap+0x41>
8010583c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit(0);
80105840:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105847:	e8 84 e3 ff ff       	call   80103bd0 <exit>
8010584c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105852:	e9 3a ff ff ff       	jmp    80105791 <trap+0x131>
80105857:	90                   	nop
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit(0);

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105858:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010585c:	0f 85 58 fe ff ff    	jne    801056ba <trap+0x5a>
    yield();
80105862:	e8 b9 e4 ff ff       	call   80103d20 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105867:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010586d:	85 c0                	test   %eax,%eax
8010586f:	0f 85 45 fe ff ff    	jne    801056ba <trap+0x5a>
80105875:	e9 58 fe ff ff       	jmp    801056d2 <trap+0x72>
8010587a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
80105880:	c7 04 24 e0 4d 11 80 	movl   $0x80114de0,(%esp)
80105887:	e8 c4 e9 ff ff       	call   80104250 <acquire>
      ticks++;
      wakeup(&ticks);
8010588c:	c7 04 24 20 56 11 80 	movl   $0x80115620,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
      ticks++;
80105893:	83 05 20 56 11 80 01 	addl   $0x1,0x80115620
      wakeup(&ticks);
8010589a:	e8 71 e6 ff ff       	call   80103f10 <wakeup>
      release(&tickslock);
8010589f:	c7 04 24 e0 4d 11 80 	movl   $0x80114de0,(%esp)
801058a6:	e8 d5 ea ff ff       	call   80104380 <release>
801058ab:	e9 e6 fd ff ff       	jmp    80105696 <trap+0x36>
801058b0:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801058b3:	8b 73 38             	mov    0x38(%ebx),%esi
801058b6:	e8 05 cf ff ff       	call   801027c0 <cpunum>
801058bb:	89 7c 24 10          	mov    %edi,0x10(%esp)
801058bf:	89 74 24 0c          	mov    %esi,0xc(%esp)
801058c3:	89 44 24 08          	mov    %eax,0x8(%esp)
801058c7:	8b 43 30             	mov    0x30(%ebx),%eax
801058ca:	c7 04 24 88 75 10 80 	movl   $0x80107588,(%esp)
801058d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801058d5:	e8 76 ad ff ff       	call   80100650 <cprintf>
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
801058da:	c7 04 24 5e 75 10 80 	movl   $0x8010755e,(%esp)
801058e1:	e8 7a aa ff ff       	call   80100360 <panic>
801058e6:	66 90                	xchg   %ax,%ax
801058e8:	66 90                	xchg   %ax,%ax
801058ea:	66 90                	xchg   %ax,%ax
801058ec:	66 90                	xchg   %ax,%ax
801058ee:	66 90                	xchg   %ax,%ax

801058f0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801058f0:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801058f5:	55                   	push   %ebp
801058f6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801058f8:	85 c0                	test   %eax,%eax
801058fa:	74 14                	je     80105910 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801058fc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105901:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105902:	a8 01                	test   $0x1,%al
80105904:	74 0a                	je     80105910 <uartgetc+0x20>
80105906:	b2 f8                	mov    $0xf8,%dl
80105908:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105909:	0f b6 c0             	movzbl %al,%eax
}
8010590c:	5d                   	pop    %ebp
8010590d:	c3                   	ret    
8010590e:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105915:	5d                   	pop    %ebp
80105916:	c3                   	ret    
80105917:	89 f6                	mov    %esi,%esi
80105919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105920 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105920:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
80105925:	85 c0                	test   %eax,%eax
80105927:	74 3f                	je     80105968 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
80105929:	55                   	push   %ebp
8010592a:	89 e5                	mov    %esp,%ebp
8010592c:	56                   	push   %esi
8010592d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105932:	53                   	push   %ebx
  int i;

  if(!uart)
80105933:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
80105938:	83 ec 10             	sub    $0x10,%esp
8010593b:	eb 14                	jmp    80105951 <uartputc+0x31>
8010593d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105940:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105947:	e8 34 cf ff ff       	call   80102880 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010594c:	83 eb 01             	sub    $0x1,%ebx
8010594f:	74 07                	je     80105958 <uartputc+0x38>
80105951:	89 f2                	mov    %esi,%edx
80105953:	ec                   	in     (%dx),%al
80105954:	a8 20                	test   $0x20,%al
80105956:	74 e8                	je     80105940 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
80105958:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010595c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105961:	ee                   	out    %al,(%dx)
}
80105962:	83 c4 10             	add    $0x10,%esp
80105965:	5b                   	pop    %ebx
80105966:	5e                   	pop    %esi
80105967:	5d                   	pop    %ebp
80105968:	f3 c3                	repz ret 
8010596a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105970 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105970:	55                   	push   %ebp
80105971:	31 c9                	xor    %ecx,%ecx
80105973:	89 e5                	mov    %esp,%ebp
80105975:	89 c8                	mov    %ecx,%eax
80105977:	57                   	push   %edi
80105978:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010597d:	56                   	push   %esi
8010597e:	89 fa                	mov    %edi,%edx
80105980:	53                   	push   %ebx
80105981:	83 ec 1c             	sub    $0x1c,%esp
80105984:	ee                   	out    %al,(%dx)
80105985:	be fb 03 00 00       	mov    $0x3fb,%esi
8010598a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010598f:	89 f2                	mov    %esi,%edx
80105991:	ee                   	out    %al,(%dx)
80105992:	b8 0c 00 00 00       	mov    $0xc,%eax
80105997:	b2 f8                	mov    $0xf8,%dl
80105999:	ee                   	out    %al,(%dx)
8010599a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
8010599f:	89 c8                	mov    %ecx,%eax
801059a1:	89 da                	mov    %ebx,%edx
801059a3:	ee                   	out    %al,(%dx)
801059a4:	b8 03 00 00 00       	mov    $0x3,%eax
801059a9:	89 f2                	mov    %esi,%edx
801059ab:	ee                   	out    %al,(%dx)
801059ac:	b2 fc                	mov    $0xfc,%dl
801059ae:	89 c8                	mov    %ecx,%eax
801059b0:	ee                   	out    %al,(%dx)
801059b1:	b8 01 00 00 00       	mov    $0x1,%eax
801059b6:	89 da                	mov    %ebx,%edx
801059b8:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801059b9:	b2 fd                	mov    $0xfd,%dl
801059bb:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801059bc:	3c ff                	cmp    $0xff,%al
801059be:	74 52                	je     80105a12 <uartinit+0xa2>
    return;
  uart = 1;
801059c0:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
801059c7:	00 00 00 
801059ca:	89 fa                	mov    %edi,%edx
801059cc:	ec                   	in     (%dx),%al
801059cd:	b2 f8                	mov    $0xf8,%dl
801059cf:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
801059d0:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801059d7:	bb 80 76 10 80       	mov    $0x80107680,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
801059dc:	e8 7f d8 ff ff       	call   80103260 <picenable>
  ioapicenable(IRQ_COM1, 0);
801059e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801059e8:	00 
801059e9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801059f0:	e8 1b c9 ff ff       	call   80102310 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801059f5:	b8 78 00 00 00       	mov    $0x78,%eax
801059fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartputc(*p);
80105a00:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105a03:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105a06:	e8 15 ff ff ff       	call   80105920 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105a0b:	0f be 03             	movsbl (%ebx),%eax
80105a0e:	84 c0                	test   %al,%al
80105a10:	75 ee                	jne    80105a00 <uartinit+0x90>
    uartputc(*p);
}
80105a12:	83 c4 1c             	add    $0x1c,%esp
80105a15:	5b                   	pop    %ebx
80105a16:	5e                   	pop    %esi
80105a17:	5f                   	pop    %edi
80105a18:	5d                   	pop    %ebp
80105a19:	c3                   	ret    
80105a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a20 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105a26:	c7 04 24 f0 58 10 80 	movl   $0x801058f0,(%esp)
80105a2d:	e8 7e ad ff ff       	call   801007b0 <consoleintr>
}
80105a32:	c9                   	leave  
80105a33:	c3                   	ret    

80105a34 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105a34:	6a 00                	push   $0x0
  pushl $0
80105a36:	6a 00                	push   $0x0
  jmp alltraps
80105a38:	e9 20 fb ff ff       	jmp    8010555d <alltraps>

80105a3d <vector1>:
.globl vector1
vector1:
  pushl $0
80105a3d:	6a 00                	push   $0x0
  pushl $1
80105a3f:	6a 01                	push   $0x1
  jmp alltraps
80105a41:	e9 17 fb ff ff       	jmp    8010555d <alltraps>

80105a46 <vector2>:
.globl vector2
vector2:
  pushl $0
80105a46:	6a 00                	push   $0x0
  pushl $2
80105a48:	6a 02                	push   $0x2
  jmp alltraps
80105a4a:	e9 0e fb ff ff       	jmp    8010555d <alltraps>

80105a4f <vector3>:
.globl vector3
vector3:
  pushl $0
80105a4f:	6a 00                	push   $0x0
  pushl $3
80105a51:	6a 03                	push   $0x3
  jmp alltraps
80105a53:	e9 05 fb ff ff       	jmp    8010555d <alltraps>

80105a58 <vector4>:
.globl vector4
vector4:
  pushl $0
80105a58:	6a 00                	push   $0x0
  pushl $4
80105a5a:	6a 04                	push   $0x4
  jmp alltraps
80105a5c:	e9 fc fa ff ff       	jmp    8010555d <alltraps>

80105a61 <vector5>:
.globl vector5
vector5:
  pushl $0
80105a61:	6a 00                	push   $0x0
  pushl $5
80105a63:	6a 05                	push   $0x5
  jmp alltraps
80105a65:	e9 f3 fa ff ff       	jmp    8010555d <alltraps>

80105a6a <vector6>:
.globl vector6
vector6:
  pushl $0
80105a6a:	6a 00                	push   $0x0
  pushl $6
80105a6c:	6a 06                	push   $0x6
  jmp alltraps
80105a6e:	e9 ea fa ff ff       	jmp    8010555d <alltraps>

80105a73 <vector7>:
.globl vector7
vector7:
  pushl $0
80105a73:	6a 00                	push   $0x0
  pushl $7
80105a75:	6a 07                	push   $0x7
  jmp alltraps
80105a77:	e9 e1 fa ff ff       	jmp    8010555d <alltraps>

80105a7c <vector8>:
.globl vector8
vector8:
  pushl $8
80105a7c:	6a 08                	push   $0x8
  jmp alltraps
80105a7e:	e9 da fa ff ff       	jmp    8010555d <alltraps>

80105a83 <vector9>:
.globl vector9
vector9:
  pushl $0
80105a83:	6a 00                	push   $0x0
  pushl $9
80105a85:	6a 09                	push   $0x9
  jmp alltraps
80105a87:	e9 d1 fa ff ff       	jmp    8010555d <alltraps>

80105a8c <vector10>:
.globl vector10
vector10:
  pushl $10
80105a8c:	6a 0a                	push   $0xa
  jmp alltraps
80105a8e:	e9 ca fa ff ff       	jmp    8010555d <alltraps>

80105a93 <vector11>:
.globl vector11
vector11:
  pushl $11
80105a93:	6a 0b                	push   $0xb
  jmp alltraps
80105a95:	e9 c3 fa ff ff       	jmp    8010555d <alltraps>

80105a9a <vector12>:
.globl vector12
vector12:
  pushl $12
80105a9a:	6a 0c                	push   $0xc
  jmp alltraps
80105a9c:	e9 bc fa ff ff       	jmp    8010555d <alltraps>

80105aa1 <vector13>:
.globl vector13
vector13:
  pushl $13
80105aa1:	6a 0d                	push   $0xd
  jmp alltraps
80105aa3:	e9 b5 fa ff ff       	jmp    8010555d <alltraps>

80105aa8 <vector14>:
.globl vector14
vector14:
  pushl $14
80105aa8:	6a 0e                	push   $0xe
  jmp alltraps
80105aaa:	e9 ae fa ff ff       	jmp    8010555d <alltraps>

80105aaf <vector15>:
.globl vector15
vector15:
  pushl $0
80105aaf:	6a 00                	push   $0x0
  pushl $15
80105ab1:	6a 0f                	push   $0xf
  jmp alltraps
80105ab3:	e9 a5 fa ff ff       	jmp    8010555d <alltraps>

80105ab8 <vector16>:
.globl vector16
vector16:
  pushl $0
80105ab8:	6a 00                	push   $0x0
  pushl $16
80105aba:	6a 10                	push   $0x10
  jmp alltraps
80105abc:	e9 9c fa ff ff       	jmp    8010555d <alltraps>

80105ac1 <vector17>:
.globl vector17
vector17:
  pushl $17
80105ac1:	6a 11                	push   $0x11
  jmp alltraps
80105ac3:	e9 95 fa ff ff       	jmp    8010555d <alltraps>

80105ac8 <vector18>:
.globl vector18
vector18:
  pushl $0
80105ac8:	6a 00                	push   $0x0
  pushl $18
80105aca:	6a 12                	push   $0x12
  jmp alltraps
80105acc:	e9 8c fa ff ff       	jmp    8010555d <alltraps>

80105ad1 <vector19>:
.globl vector19
vector19:
  pushl $0
80105ad1:	6a 00                	push   $0x0
  pushl $19
80105ad3:	6a 13                	push   $0x13
  jmp alltraps
80105ad5:	e9 83 fa ff ff       	jmp    8010555d <alltraps>

80105ada <vector20>:
.globl vector20
vector20:
  pushl $0
80105ada:	6a 00                	push   $0x0
  pushl $20
80105adc:	6a 14                	push   $0x14
  jmp alltraps
80105ade:	e9 7a fa ff ff       	jmp    8010555d <alltraps>

80105ae3 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ae3:	6a 00                	push   $0x0
  pushl $21
80105ae5:	6a 15                	push   $0x15
  jmp alltraps
80105ae7:	e9 71 fa ff ff       	jmp    8010555d <alltraps>

80105aec <vector22>:
.globl vector22
vector22:
  pushl $0
80105aec:	6a 00                	push   $0x0
  pushl $22
80105aee:	6a 16                	push   $0x16
  jmp alltraps
80105af0:	e9 68 fa ff ff       	jmp    8010555d <alltraps>

80105af5 <vector23>:
.globl vector23
vector23:
  pushl $0
80105af5:	6a 00                	push   $0x0
  pushl $23
80105af7:	6a 17                	push   $0x17
  jmp alltraps
80105af9:	e9 5f fa ff ff       	jmp    8010555d <alltraps>

80105afe <vector24>:
.globl vector24
vector24:
  pushl $0
80105afe:	6a 00                	push   $0x0
  pushl $24
80105b00:	6a 18                	push   $0x18
  jmp alltraps
80105b02:	e9 56 fa ff ff       	jmp    8010555d <alltraps>

80105b07 <vector25>:
.globl vector25
vector25:
  pushl $0
80105b07:	6a 00                	push   $0x0
  pushl $25
80105b09:	6a 19                	push   $0x19
  jmp alltraps
80105b0b:	e9 4d fa ff ff       	jmp    8010555d <alltraps>

80105b10 <vector26>:
.globl vector26
vector26:
  pushl $0
80105b10:	6a 00                	push   $0x0
  pushl $26
80105b12:	6a 1a                	push   $0x1a
  jmp alltraps
80105b14:	e9 44 fa ff ff       	jmp    8010555d <alltraps>

80105b19 <vector27>:
.globl vector27
vector27:
  pushl $0
80105b19:	6a 00                	push   $0x0
  pushl $27
80105b1b:	6a 1b                	push   $0x1b
  jmp alltraps
80105b1d:	e9 3b fa ff ff       	jmp    8010555d <alltraps>

80105b22 <vector28>:
.globl vector28
vector28:
  pushl $0
80105b22:	6a 00                	push   $0x0
  pushl $28
80105b24:	6a 1c                	push   $0x1c
  jmp alltraps
80105b26:	e9 32 fa ff ff       	jmp    8010555d <alltraps>

80105b2b <vector29>:
.globl vector29
vector29:
  pushl $0
80105b2b:	6a 00                	push   $0x0
  pushl $29
80105b2d:	6a 1d                	push   $0x1d
  jmp alltraps
80105b2f:	e9 29 fa ff ff       	jmp    8010555d <alltraps>

80105b34 <vector30>:
.globl vector30
vector30:
  pushl $0
80105b34:	6a 00                	push   $0x0
  pushl $30
80105b36:	6a 1e                	push   $0x1e
  jmp alltraps
80105b38:	e9 20 fa ff ff       	jmp    8010555d <alltraps>

80105b3d <vector31>:
.globl vector31
vector31:
  pushl $0
80105b3d:	6a 00                	push   $0x0
  pushl $31
80105b3f:	6a 1f                	push   $0x1f
  jmp alltraps
80105b41:	e9 17 fa ff ff       	jmp    8010555d <alltraps>

80105b46 <vector32>:
.globl vector32
vector32:
  pushl $0
80105b46:	6a 00                	push   $0x0
  pushl $32
80105b48:	6a 20                	push   $0x20
  jmp alltraps
80105b4a:	e9 0e fa ff ff       	jmp    8010555d <alltraps>

80105b4f <vector33>:
.globl vector33
vector33:
  pushl $0
80105b4f:	6a 00                	push   $0x0
  pushl $33
80105b51:	6a 21                	push   $0x21
  jmp alltraps
80105b53:	e9 05 fa ff ff       	jmp    8010555d <alltraps>

80105b58 <vector34>:
.globl vector34
vector34:
  pushl $0
80105b58:	6a 00                	push   $0x0
  pushl $34
80105b5a:	6a 22                	push   $0x22
  jmp alltraps
80105b5c:	e9 fc f9 ff ff       	jmp    8010555d <alltraps>

80105b61 <vector35>:
.globl vector35
vector35:
  pushl $0
80105b61:	6a 00                	push   $0x0
  pushl $35
80105b63:	6a 23                	push   $0x23
  jmp alltraps
80105b65:	e9 f3 f9 ff ff       	jmp    8010555d <alltraps>

80105b6a <vector36>:
.globl vector36
vector36:
  pushl $0
80105b6a:	6a 00                	push   $0x0
  pushl $36
80105b6c:	6a 24                	push   $0x24
  jmp alltraps
80105b6e:	e9 ea f9 ff ff       	jmp    8010555d <alltraps>

80105b73 <vector37>:
.globl vector37
vector37:
  pushl $0
80105b73:	6a 00                	push   $0x0
  pushl $37
80105b75:	6a 25                	push   $0x25
  jmp alltraps
80105b77:	e9 e1 f9 ff ff       	jmp    8010555d <alltraps>

80105b7c <vector38>:
.globl vector38
vector38:
  pushl $0
80105b7c:	6a 00                	push   $0x0
  pushl $38
80105b7e:	6a 26                	push   $0x26
  jmp alltraps
80105b80:	e9 d8 f9 ff ff       	jmp    8010555d <alltraps>

80105b85 <vector39>:
.globl vector39
vector39:
  pushl $0
80105b85:	6a 00                	push   $0x0
  pushl $39
80105b87:	6a 27                	push   $0x27
  jmp alltraps
80105b89:	e9 cf f9 ff ff       	jmp    8010555d <alltraps>

80105b8e <vector40>:
.globl vector40
vector40:
  pushl $0
80105b8e:	6a 00                	push   $0x0
  pushl $40
80105b90:	6a 28                	push   $0x28
  jmp alltraps
80105b92:	e9 c6 f9 ff ff       	jmp    8010555d <alltraps>

80105b97 <vector41>:
.globl vector41
vector41:
  pushl $0
80105b97:	6a 00                	push   $0x0
  pushl $41
80105b99:	6a 29                	push   $0x29
  jmp alltraps
80105b9b:	e9 bd f9 ff ff       	jmp    8010555d <alltraps>

80105ba0 <vector42>:
.globl vector42
vector42:
  pushl $0
80105ba0:	6a 00                	push   $0x0
  pushl $42
80105ba2:	6a 2a                	push   $0x2a
  jmp alltraps
80105ba4:	e9 b4 f9 ff ff       	jmp    8010555d <alltraps>

80105ba9 <vector43>:
.globl vector43
vector43:
  pushl $0
80105ba9:	6a 00                	push   $0x0
  pushl $43
80105bab:	6a 2b                	push   $0x2b
  jmp alltraps
80105bad:	e9 ab f9 ff ff       	jmp    8010555d <alltraps>

80105bb2 <vector44>:
.globl vector44
vector44:
  pushl $0
80105bb2:	6a 00                	push   $0x0
  pushl $44
80105bb4:	6a 2c                	push   $0x2c
  jmp alltraps
80105bb6:	e9 a2 f9 ff ff       	jmp    8010555d <alltraps>

80105bbb <vector45>:
.globl vector45
vector45:
  pushl $0
80105bbb:	6a 00                	push   $0x0
  pushl $45
80105bbd:	6a 2d                	push   $0x2d
  jmp alltraps
80105bbf:	e9 99 f9 ff ff       	jmp    8010555d <alltraps>

80105bc4 <vector46>:
.globl vector46
vector46:
  pushl $0
80105bc4:	6a 00                	push   $0x0
  pushl $46
80105bc6:	6a 2e                	push   $0x2e
  jmp alltraps
80105bc8:	e9 90 f9 ff ff       	jmp    8010555d <alltraps>

80105bcd <vector47>:
.globl vector47
vector47:
  pushl $0
80105bcd:	6a 00                	push   $0x0
  pushl $47
80105bcf:	6a 2f                	push   $0x2f
  jmp alltraps
80105bd1:	e9 87 f9 ff ff       	jmp    8010555d <alltraps>

80105bd6 <vector48>:
.globl vector48
vector48:
  pushl $0
80105bd6:	6a 00                	push   $0x0
  pushl $48
80105bd8:	6a 30                	push   $0x30
  jmp alltraps
80105bda:	e9 7e f9 ff ff       	jmp    8010555d <alltraps>

80105bdf <vector49>:
.globl vector49
vector49:
  pushl $0
80105bdf:	6a 00                	push   $0x0
  pushl $49
80105be1:	6a 31                	push   $0x31
  jmp alltraps
80105be3:	e9 75 f9 ff ff       	jmp    8010555d <alltraps>

80105be8 <vector50>:
.globl vector50
vector50:
  pushl $0
80105be8:	6a 00                	push   $0x0
  pushl $50
80105bea:	6a 32                	push   $0x32
  jmp alltraps
80105bec:	e9 6c f9 ff ff       	jmp    8010555d <alltraps>

80105bf1 <vector51>:
.globl vector51
vector51:
  pushl $0
80105bf1:	6a 00                	push   $0x0
  pushl $51
80105bf3:	6a 33                	push   $0x33
  jmp alltraps
80105bf5:	e9 63 f9 ff ff       	jmp    8010555d <alltraps>

80105bfa <vector52>:
.globl vector52
vector52:
  pushl $0
80105bfa:	6a 00                	push   $0x0
  pushl $52
80105bfc:	6a 34                	push   $0x34
  jmp alltraps
80105bfe:	e9 5a f9 ff ff       	jmp    8010555d <alltraps>

80105c03 <vector53>:
.globl vector53
vector53:
  pushl $0
80105c03:	6a 00                	push   $0x0
  pushl $53
80105c05:	6a 35                	push   $0x35
  jmp alltraps
80105c07:	e9 51 f9 ff ff       	jmp    8010555d <alltraps>

80105c0c <vector54>:
.globl vector54
vector54:
  pushl $0
80105c0c:	6a 00                	push   $0x0
  pushl $54
80105c0e:	6a 36                	push   $0x36
  jmp alltraps
80105c10:	e9 48 f9 ff ff       	jmp    8010555d <alltraps>

80105c15 <vector55>:
.globl vector55
vector55:
  pushl $0
80105c15:	6a 00                	push   $0x0
  pushl $55
80105c17:	6a 37                	push   $0x37
  jmp alltraps
80105c19:	e9 3f f9 ff ff       	jmp    8010555d <alltraps>

80105c1e <vector56>:
.globl vector56
vector56:
  pushl $0
80105c1e:	6a 00                	push   $0x0
  pushl $56
80105c20:	6a 38                	push   $0x38
  jmp alltraps
80105c22:	e9 36 f9 ff ff       	jmp    8010555d <alltraps>

80105c27 <vector57>:
.globl vector57
vector57:
  pushl $0
80105c27:	6a 00                	push   $0x0
  pushl $57
80105c29:	6a 39                	push   $0x39
  jmp alltraps
80105c2b:	e9 2d f9 ff ff       	jmp    8010555d <alltraps>

80105c30 <vector58>:
.globl vector58
vector58:
  pushl $0
80105c30:	6a 00                	push   $0x0
  pushl $58
80105c32:	6a 3a                	push   $0x3a
  jmp alltraps
80105c34:	e9 24 f9 ff ff       	jmp    8010555d <alltraps>

80105c39 <vector59>:
.globl vector59
vector59:
  pushl $0
80105c39:	6a 00                	push   $0x0
  pushl $59
80105c3b:	6a 3b                	push   $0x3b
  jmp alltraps
80105c3d:	e9 1b f9 ff ff       	jmp    8010555d <alltraps>

80105c42 <vector60>:
.globl vector60
vector60:
  pushl $0
80105c42:	6a 00                	push   $0x0
  pushl $60
80105c44:	6a 3c                	push   $0x3c
  jmp alltraps
80105c46:	e9 12 f9 ff ff       	jmp    8010555d <alltraps>

80105c4b <vector61>:
.globl vector61
vector61:
  pushl $0
80105c4b:	6a 00                	push   $0x0
  pushl $61
80105c4d:	6a 3d                	push   $0x3d
  jmp alltraps
80105c4f:	e9 09 f9 ff ff       	jmp    8010555d <alltraps>

80105c54 <vector62>:
.globl vector62
vector62:
  pushl $0
80105c54:	6a 00                	push   $0x0
  pushl $62
80105c56:	6a 3e                	push   $0x3e
  jmp alltraps
80105c58:	e9 00 f9 ff ff       	jmp    8010555d <alltraps>

80105c5d <vector63>:
.globl vector63
vector63:
  pushl $0
80105c5d:	6a 00                	push   $0x0
  pushl $63
80105c5f:	6a 3f                	push   $0x3f
  jmp alltraps
80105c61:	e9 f7 f8 ff ff       	jmp    8010555d <alltraps>

80105c66 <vector64>:
.globl vector64
vector64:
  pushl $0
80105c66:	6a 00                	push   $0x0
  pushl $64
80105c68:	6a 40                	push   $0x40
  jmp alltraps
80105c6a:	e9 ee f8 ff ff       	jmp    8010555d <alltraps>

80105c6f <vector65>:
.globl vector65
vector65:
  pushl $0
80105c6f:	6a 00                	push   $0x0
  pushl $65
80105c71:	6a 41                	push   $0x41
  jmp alltraps
80105c73:	e9 e5 f8 ff ff       	jmp    8010555d <alltraps>

80105c78 <vector66>:
.globl vector66
vector66:
  pushl $0
80105c78:	6a 00                	push   $0x0
  pushl $66
80105c7a:	6a 42                	push   $0x42
  jmp alltraps
80105c7c:	e9 dc f8 ff ff       	jmp    8010555d <alltraps>

80105c81 <vector67>:
.globl vector67
vector67:
  pushl $0
80105c81:	6a 00                	push   $0x0
  pushl $67
80105c83:	6a 43                	push   $0x43
  jmp alltraps
80105c85:	e9 d3 f8 ff ff       	jmp    8010555d <alltraps>

80105c8a <vector68>:
.globl vector68
vector68:
  pushl $0
80105c8a:	6a 00                	push   $0x0
  pushl $68
80105c8c:	6a 44                	push   $0x44
  jmp alltraps
80105c8e:	e9 ca f8 ff ff       	jmp    8010555d <alltraps>

80105c93 <vector69>:
.globl vector69
vector69:
  pushl $0
80105c93:	6a 00                	push   $0x0
  pushl $69
80105c95:	6a 45                	push   $0x45
  jmp alltraps
80105c97:	e9 c1 f8 ff ff       	jmp    8010555d <alltraps>

80105c9c <vector70>:
.globl vector70
vector70:
  pushl $0
80105c9c:	6a 00                	push   $0x0
  pushl $70
80105c9e:	6a 46                	push   $0x46
  jmp alltraps
80105ca0:	e9 b8 f8 ff ff       	jmp    8010555d <alltraps>

80105ca5 <vector71>:
.globl vector71
vector71:
  pushl $0
80105ca5:	6a 00                	push   $0x0
  pushl $71
80105ca7:	6a 47                	push   $0x47
  jmp alltraps
80105ca9:	e9 af f8 ff ff       	jmp    8010555d <alltraps>

80105cae <vector72>:
.globl vector72
vector72:
  pushl $0
80105cae:	6a 00                	push   $0x0
  pushl $72
80105cb0:	6a 48                	push   $0x48
  jmp alltraps
80105cb2:	e9 a6 f8 ff ff       	jmp    8010555d <alltraps>

80105cb7 <vector73>:
.globl vector73
vector73:
  pushl $0
80105cb7:	6a 00                	push   $0x0
  pushl $73
80105cb9:	6a 49                	push   $0x49
  jmp alltraps
80105cbb:	e9 9d f8 ff ff       	jmp    8010555d <alltraps>

80105cc0 <vector74>:
.globl vector74
vector74:
  pushl $0
80105cc0:	6a 00                	push   $0x0
  pushl $74
80105cc2:	6a 4a                	push   $0x4a
  jmp alltraps
80105cc4:	e9 94 f8 ff ff       	jmp    8010555d <alltraps>

80105cc9 <vector75>:
.globl vector75
vector75:
  pushl $0
80105cc9:	6a 00                	push   $0x0
  pushl $75
80105ccb:	6a 4b                	push   $0x4b
  jmp alltraps
80105ccd:	e9 8b f8 ff ff       	jmp    8010555d <alltraps>

80105cd2 <vector76>:
.globl vector76
vector76:
  pushl $0
80105cd2:	6a 00                	push   $0x0
  pushl $76
80105cd4:	6a 4c                	push   $0x4c
  jmp alltraps
80105cd6:	e9 82 f8 ff ff       	jmp    8010555d <alltraps>

80105cdb <vector77>:
.globl vector77
vector77:
  pushl $0
80105cdb:	6a 00                	push   $0x0
  pushl $77
80105cdd:	6a 4d                	push   $0x4d
  jmp alltraps
80105cdf:	e9 79 f8 ff ff       	jmp    8010555d <alltraps>

80105ce4 <vector78>:
.globl vector78
vector78:
  pushl $0
80105ce4:	6a 00                	push   $0x0
  pushl $78
80105ce6:	6a 4e                	push   $0x4e
  jmp alltraps
80105ce8:	e9 70 f8 ff ff       	jmp    8010555d <alltraps>

80105ced <vector79>:
.globl vector79
vector79:
  pushl $0
80105ced:	6a 00                	push   $0x0
  pushl $79
80105cef:	6a 4f                	push   $0x4f
  jmp alltraps
80105cf1:	e9 67 f8 ff ff       	jmp    8010555d <alltraps>

80105cf6 <vector80>:
.globl vector80
vector80:
  pushl $0
80105cf6:	6a 00                	push   $0x0
  pushl $80
80105cf8:	6a 50                	push   $0x50
  jmp alltraps
80105cfa:	e9 5e f8 ff ff       	jmp    8010555d <alltraps>

80105cff <vector81>:
.globl vector81
vector81:
  pushl $0
80105cff:	6a 00                	push   $0x0
  pushl $81
80105d01:	6a 51                	push   $0x51
  jmp alltraps
80105d03:	e9 55 f8 ff ff       	jmp    8010555d <alltraps>

80105d08 <vector82>:
.globl vector82
vector82:
  pushl $0
80105d08:	6a 00                	push   $0x0
  pushl $82
80105d0a:	6a 52                	push   $0x52
  jmp alltraps
80105d0c:	e9 4c f8 ff ff       	jmp    8010555d <alltraps>

80105d11 <vector83>:
.globl vector83
vector83:
  pushl $0
80105d11:	6a 00                	push   $0x0
  pushl $83
80105d13:	6a 53                	push   $0x53
  jmp alltraps
80105d15:	e9 43 f8 ff ff       	jmp    8010555d <alltraps>

80105d1a <vector84>:
.globl vector84
vector84:
  pushl $0
80105d1a:	6a 00                	push   $0x0
  pushl $84
80105d1c:	6a 54                	push   $0x54
  jmp alltraps
80105d1e:	e9 3a f8 ff ff       	jmp    8010555d <alltraps>

80105d23 <vector85>:
.globl vector85
vector85:
  pushl $0
80105d23:	6a 00                	push   $0x0
  pushl $85
80105d25:	6a 55                	push   $0x55
  jmp alltraps
80105d27:	e9 31 f8 ff ff       	jmp    8010555d <alltraps>

80105d2c <vector86>:
.globl vector86
vector86:
  pushl $0
80105d2c:	6a 00                	push   $0x0
  pushl $86
80105d2e:	6a 56                	push   $0x56
  jmp alltraps
80105d30:	e9 28 f8 ff ff       	jmp    8010555d <alltraps>

80105d35 <vector87>:
.globl vector87
vector87:
  pushl $0
80105d35:	6a 00                	push   $0x0
  pushl $87
80105d37:	6a 57                	push   $0x57
  jmp alltraps
80105d39:	e9 1f f8 ff ff       	jmp    8010555d <alltraps>

80105d3e <vector88>:
.globl vector88
vector88:
  pushl $0
80105d3e:	6a 00                	push   $0x0
  pushl $88
80105d40:	6a 58                	push   $0x58
  jmp alltraps
80105d42:	e9 16 f8 ff ff       	jmp    8010555d <alltraps>

80105d47 <vector89>:
.globl vector89
vector89:
  pushl $0
80105d47:	6a 00                	push   $0x0
  pushl $89
80105d49:	6a 59                	push   $0x59
  jmp alltraps
80105d4b:	e9 0d f8 ff ff       	jmp    8010555d <alltraps>

80105d50 <vector90>:
.globl vector90
vector90:
  pushl $0
80105d50:	6a 00                	push   $0x0
  pushl $90
80105d52:	6a 5a                	push   $0x5a
  jmp alltraps
80105d54:	e9 04 f8 ff ff       	jmp    8010555d <alltraps>

80105d59 <vector91>:
.globl vector91
vector91:
  pushl $0
80105d59:	6a 00                	push   $0x0
  pushl $91
80105d5b:	6a 5b                	push   $0x5b
  jmp alltraps
80105d5d:	e9 fb f7 ff ff       	jmp    8010555d <alltraps>

80105d62 <vector92>:
.globl vector92
vector92:
  pushl $0
80105d62:	6a 00                	push   $0x0
  pushl $92
80105d64:	6a 5c                	push   $0x5c
  jmp alltraps
80105d66:	e9 f2 f7 ff ff       	jmp    8010555d <alltraps>

80105d6b <vector93>:
.globl vector93
vector93:
  pushl $0
80105d6b:	6a 00                	push   $0x0
  pushl $93
80105d6d:	6a 5d                	push   $0x5d
  jmp alltraps
80105d6f:	e9 e9 f7 ff ff       	jmp    8010555d <alltraps>

80105d74 <vector94>:
.globl vector94
vector94:
  pushl $0
80105d74:	6a 00                	push   $0x0
  pushl $94
80105d76:	6a 5e                	push   $0x5e
  jmp alltraps
80105d78:	e9 e0 f7 ff ff       	jmp    8010555d <alltraps>

80105d7d <vector95>:
.globl vector95
vector95:
  pushl $0
80105d7d:	6a 00                	push   $0x0
  pushl $95
80105d7f:	6a 5f                	push   $0x5f
  jmp alltraps
80105d81:	e9 d7 f7 ff ff       	jmp    8010555d <alltraps>

80105d86 <vector96>:
.globl vector96
vector96:
  pushl $0
80105d86:	6a 00                	push   $0x0
  pushl $96
80105d88:	6a 60                	push   $0x60
  jmp alltraps
80105d8a:	e9 ce f7 ff ff       	jmp    8010555d <alltraps>

80105d8f <vector97>:
.globl vector97
vector97:
  pushl $0
80105d8f:	6a 00                	push   $0x0
  pushl $97
80105d91:	6a 61                	push   $0x61
  jmp alltraps
80105d93:	e9 c5 f7 ff ff       	jmp    8010555d <alltraps>

80105d98 <vector98>:
.globl vector98
vector98:
  pushl $0
80105d98:	6a 00                	push   $0x0
  pushl $98
80105d9a:	6a 62                	push   $0x62
  jmp alltraps
80105d9c:	e9 bc f7 ff ff       	jmp    8010555d <alltraps>

80105da1 <vector99>:
.globl vector99
vector99:
  pushl $0
80105da1:	6a 00                	push   $0x0
  pushl $99
80105da3:	6a 63                	push   $0x63
  jmp alltraps
80105da5:	e9 b3 f7 ff ff       	jmp    8010555d <alltraps>

80105daa <vector100>:
.globl vector100
vector100:
  pushl $0
80105daa:	6a 00                	push   $0x0
  pushl $100
80105dac:	6a 64                	push   $0x64
  jmp alltraps
80105dae:	e9 aa f7 ff ff       	jmp    8010555d <alltraps>

80105db3 <vector101>:
.globl vector101
vector101:
  pushl $0
80105db3:	6a 00                	push   $0x0
  pushl $101
80105db5:	6a 65                	push   $0x65
  jmp alltraps
80105db7:	e9 a1 f7 ff ff       	jmp    8010555d <alltraps>

80105dbc <vector102>:
.globl vector102
vector102:
  pushl $0
80105dbc:	6a 00                	push   $0x0
  pushl $102
80105dbe:	6a 66                	push   $0x66
  jmp alltraps
80105dc0:	e9 98 f7 ff ff       	jmp    8010555d <alltraps>

80105dc5 <vector103>:
.globl vector103
vector103:
  pushl $0
80105dc5:	6a 00                	push   $0x0
  pushl $103
80105dc7:	6a 67                	push   $0x67
  jmp alltraps
80105dc9:	e9 8f f7 ff ff       	jmp    8010555d <alltraps>

80105dce <vector104>:
.globl vector104
vector104:
  pushl $0
80105dce:	6a 00                	push   $0x0
  pushl $104
80105dd0:	6a 68                	push   $0x68
  jmp alltraps
80105dd2:	e9 86 f7 ff ff       	jmp    8010555d <alltraps>

80105dd7 <vector105>:
.globl vector105
vector105:
  pushl $0
80105dd7:	6a 00                	push   $0x0
  pushl $105
80105dd9:	6a 69                	push   $0x69
  jmp alltraps
80105ddb:	e9 7d f7 ff ff       	jmp    8010555d <alltraps>

80105de0 <vector106>:
.globl vector106
vector106:
  pushl $0
80105de0:	6a 00                	push   $0x0
  pushl $106
80105de2:	6a 6a                	push   $0x6a
  jmp alltraps
80105de4:	e9 74 f7 ff ff       	jmp    8010555d <alltraps>

80105de9 <vector107>:
.globl vector107
vector107:
  pushl $0
80105de9:	6a 00                	push   $0x0
  pushl $107
80105deb:	6a 6b                	push   $0x6b
  jmp alltraps
80105ded:	e9 6b f7 ff ff       	jmp    8010555d <alltraps>

80105df2 <vector108>:
.globl vector108
vector108:
  pushl $0
80105df2:	6a 00                	push   $0x0
  pushl $108
80105df4:	6a 6c                	push   $0x6c
  jmp alltraps
80105df6:	e9 62 f7 ff ff       	jmp    8010555d <alltraps>

80105dfb <vector109>:
.globl vector109
vector109:
  pushl $0
80105dfb:	6a 00                	push   $0x0
  pushl $109
80105dfd:	6a 6d                	push   $0x6d
  jmp alltraps
80105dff:	e9 59 f7 ff ff       	jmp    8010555d <alltraps>

80105e04 <vector110>:
.globl vector110
vector110:
  pushl $0
80105e04:	6a 00                	push   $0x0
  pushl $110
80105e06:	6a 6e                	push   $0x6e
  jmp alltraps
80105e08:	e9 50 f7 ff ff       	jmp    8010555d <alltraps>

80105e0d <vector111>:
.globl vector111
vector111:
  pushl $0
80105e0d:	6a 00                	push   $0x0
  pushl $111
80105e0f:	6a 6f                	push   $0x6f
  jmp alltraps
80105e11:	e9 47 f7 ff ff       	jmp    8010555d <alltraps>

80105e16 <vector112>:
.globl vector112
vector112:
  pushl $0
80105e16:	6a 00                	push   $0x0
  pushl $112
80105e18:	6a 70                	push   $0x70
  jmp alltraps
80105e1a:	e9 3e f7 ff ff       	jmp    8010555d <alltraps>

80105e1f <vector113>:
.globl vector113
vector113:
  pushl $0
80105e1f:	6a 00                	push   $0x0
  pushl $113
80105e21:	6a 71                	push   $0x71
  jmp alltraps
80105e23:	e9 35 f7 ff ff       	jmp    8010555d <alltraps>

80105e28 <vector114>:
.globl vector114
vector114:
  pushl $0
80105e28:	6a 00                	push   $0x0
  pushl $114
80105e2a:	6a 72                	push   $0x72
  jmp alltraps
80105e2c:	e9 2c f7 ff ff       	jmp    8010555d <alltraps>

80105e31 <vector115>:
.globl vector115
vector115:
  pushl $0
80105e31:	6a 00                	push   $0x0
  pushl $115
80105e33:	6a 73                	push   $0x73
  jmp alltraps
80105e35:	e9 23 f7 ff ff       	jmp    8010555d <alltraps>

80105e3a <vector116>:
.globl vector116
vector116:
  pushl $0
80105e3a:	6a 00                	push   $0x0
  pushl $116
80105e3c:	6a 74                	push   $0x74
  jmp alltraps
80105e3e:	e9 1a f7 ff ff       	jmp    8010555d <alltraps>

80105e43 <vector117>:
.globl vector117
vector117:
  pushl $0
80105e43:	6a 00                	push   $0x0
  pushl $117
80105e45:	6a 75                	push   $0x75
  jmp alltraps
80105e47:	e9 11 f7 ff ff       	jmp    8010555d <alltraps>

80105e4c <vector118>:
.globl vector118
vector118:
  pushl $0
80105e4c:	6a 00                	push   $0x0
  pushl $118
80105e4e:	6a 76                	push   $0x76
  jmp alltraps
80105e50:	e9 08 f7 ff ff       	jmp    8010555d <alltraps>

80105e55 <vector119>:
.globl vector119
vector119:
  pushl $0
80105e55:	6a 00                	push   $0x0
  pushl $119
80105e57:	6a 77                	push   $0x77
  jmp alltraps
80105e59:	e9 ff f6 ff ff       	jmp    8010555d <alltraps>

80105e5e <vector120>:
.globl vector120
vector120:
  pushl $0
80105e5e:	6a 00                	push   $0x0
  pushl $120
80105e60:	6a 78                	push   $0x78
  jmp alltraps
80105e62:	e9 f6 f6 ff ff       	jmp    8010555d <alltraps>

80105e67 <vector121>:
.globl vector121
vector121:
  pushl $0
80105e67:	6a 00                	push   $0x0
  pushl $121
80105e69:	6a 79                	push   $0x79
  jmp alltraps
80105e6b:	e9 ed f6 ff ff       	jmp    8010555d <alltraps>

80105e70 <vector122>:
.globl vector122
vector122:
  pushl $0
80105e70:	6a 00                	push   $0x0
  pushl $122
80105e72:	6a 7a                	push   $0x7a
  jmp alltraps
80105e74:	e9 e4 f6 ff ff       	jmp    8010555d <alltraps>

80105e79 <vector123>:
.globl vector123
vector123:
  pushl $0
80105e79:	6a 00                	push   $0x0
  pushl $123
80105e7b:	6a 7b                	push   $0x7b
  jmp alltraps
80105e7d:	e9 db f6 ff ff       	jmp    8010555d <alltraps>

80105e82 <vector124>:
.globl vector124
vector124:
  pushl $0
80105e82:	6a 00                	push   $0x0
  pushl $124
80105e84:	6a 7c                	push   $0x7c
  jmp alltraps
80105e86:	e9 d2 f6 ff ff       	jmp    8010555d <alltraps>

80105e8b <vector125>:
.globl vector125
vector125:
  pushl $0
80105e8b:	6a 00                	push   $0x0
  pushl $125
80105e8d:	6a 7d                	push   $0x7d
  jmp alltraps
80105e8f:	e9 c9 f6 ff ff       	jmp    8010555d <alltraps>

80105e94 <vector126>:
.globl vector126
vector126:
  pushl $0
80105e94:	6a 00                	push   $0x0
  pushl $126
80105e96:	6a 7e                	push   $0x7e
  jmp alltraps
80105e98:	e9 c0 f6 ff ff       	jmp    8010555d <alltraps>

80105e9d <vector127>:
.globl vector127
vector127:
  pushl $0
80105e9d:	6a 00                	push   $0x0
  pushl $127
80105e9f:	6a 7f                	push   $0x7f
  jmp alltraps
80105ea1:	e9 b7 f6 ff ff       	jmp    8010555d <alltraps>

80105ea6 <vector128>:
.globl vector128
vector128:
  pushl $0
80105ea6:	6a 00                	push   $0x0
  pushl $128
80105ea8:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105ead:	e9 ab f6 ff ff       	jmp    8010555d <alltraps>

80105eb2 <vector129>:
.globl vector129
vector129:
  pushl $0
80105eb2:	6a 00                	push   $0x0
  pushl $129
80105eb4:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105eb9:	e9 9f f6 ff ff       	jmp    8010555d <alltraps>

80105ebe <vector130>:
.globl vector130
vector130:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $130
80105ec0:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105ec5:	e9 93 f6 ff ff       	jmp    8010555d <alltraps>

80105eca <vector131>:
.globl vector131
vector131:
  pushl $0
80105eca:	6a 00                	push   $0x0
  pushl $131
80105ecc:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105ed1:	e9 87 f6 ff ff       	jmp    8010555d <alltraps>

80105ed6 <vector132>:
.globl vector132
vector132:
  pushl $0
80105ed6:	6a 00                	push   $0x0
  pushl $132
80105ed8:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105edd:	e9 7b f6 ff ff       	jmp    8010555d <alltraps>

80105ee2 <vector133>:
.globl vector133
vector133:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $133
80105ee4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105ee9:	e9 6f f6 ff ff       	jmp    8010555d <alltraps>

80105eee <vector134>:
.globl vector134
vector134:
  pushl $0
80105eee:	6a 00                	push   $0x0
  pushl $134
80105ef0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105ef5:	e9 63 f6 ff ff       	jmp    8010555d <alltraps>

80105efa <vector135>:
.globl vector135
vector135:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $135
80105efc:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105f01:	e9 57 f6 ff ff       	jmp    8010555d <alltraps>

80105f06 <vector136>:
.globl vector136
vector136:
  pushl $0
80105f06:	6a 00                	push   $0x0
  pushl $136
80105f08:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105f0d:	e9 4b f6 ff ff       	jmp    8010555d <alltraps>

80105f12 <vector137>:
.globl vector137
vector137:
  pushl $0
80105f12:	6a 00                	push   $0x0
  pushl $137
80105f14:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105f19:	e9 3f f6 ff ff       	jmp    8010555d <alltraps>

80105f1e <vector138>:
.globl vector138
vector138:
  pushl $0
80105f1e:	6a 00                	push   $0x0
  pushl $138
80105f20:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105f25:	e9 33 f6 ff ff       	jmp    8010555d <alltraps>

80105f2a <vector139>:
.globl vector139
vector139:
  pushl $0
80105f2a:	6a 00                	push   $0x0
  pushl $139
80105f2c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105f31:	e9 27 f6 ff ff       	jmp    8010555d <alltraps>

80105f36 <vector140>:
.globl vector140
vector140:
  pushl $0
80105f36:	6a 00                	push   $0x0
  pushl $140
80105f38:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105f3d:	e9 1b f6 ff ff       	jmp    8010555d <alltraps>

80105f42 <vector141>:
.globl vector141
vector141:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $141
80105f44:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105f49:	e9 0f f6 ff ff       	jmp    8010555d <alltraps>

80105f4e <vector142>:
.globl vector142
vector142:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $142
80105f50:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105f55:	e9 03 f6 ff ff       	jmp    8010555d <alltraps>

80105f5a <vector143>:
.globl vector143
vector143:
  pushl $0
80105f5a:	6a 00                	push   $0x0
  pushl $143
80105f5c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105f61:	e9 f7 f5 ff ff       	jmp    8010555d <alltraps>

80105f66 <vector144>:
.globl vector144
vector144:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $144
80105f68:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105f6d:	e9 eb f5 ff ff       	jmp    8010555d <alltraps>

80105f72 <vector145>:
.globl vector145
vector145:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $145
80105f74:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105f79:	e9 df f5 ff ff       	jmp    8010555d <alltraps>

80105f7e <vector146>:
.globl vector146
vector146:
  pushl $0
80105f7e:	6a 00                	push   $0x0
  pushl $146
80105f80:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105f85:	e9 d3 f5 ff ff       	jmp    8010555d <alltraps>

80105f8a <vector147>:
.globl vector147
vector147:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $147
80105f8c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105f91:	e9 c7 f5 ff ff       	jmp    8010555d <alltraps>

80105f96 <vector148>:
.globl vector148
vector148:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $148
80105f98:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105f9d:	e9 bb f5 ff ff       	jmp    8010555d <alltraps>

80105fa2 <vector149>:
.globl vector149
vector149:
  pushl $0
80105fa2:	6a 00                	push   $0x0
  pushl $149
80105fa4:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105fa9:	e9 af f5 ff ff       	jmp    8010555d <alltraps>

80105fae <vector150>:
.globl vector150
vector150:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $150
80105fb0:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105fb5:	e9 a3 f5 ff ff       	jmp    8010555d <alltraps>

80105fba <vector151>:
.globl vector151
vector151:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $151
80105fbc:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105fc1:	e9 97 f5 ff ff       	jmp    8010555d <alltraps>

80105fc6 <vector152>:
.globl vector152
vector152:
  pushl $0
80105fc6:	6a 00                	push   $0x0
  pushl $152
80105fc8:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105fcd:	e9 8b f5 ff ff       	jmp    8010555d <alltraps>

80105fd2 <vector153>:
.globl vector153
vector153:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $153
80105fd4:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105fd9:	e9 7f f5 ff ff       	jmp    8010555d <alltraps>

80105fde <vector154>:
.globl vector154
vector154:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $154
80105fe0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105fe5:	e9 73 f5 ff ff       	jmp    8010555d <alltraps>

80105fea <vector155>:
.globl vector155
vector155:
  pushl $0
80105fea:	6a 00                	push   $0x0
  pushl $155
80105fec:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105ff1:	e9 67 f5 ff ff       	jmp    8010555d <alltraps>

80105ff6 <vector156>:
.globl vector156
vector156:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $156
80105ff8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105ffd:	e9 5b f5 ff ff       	jmp    8010555d <alltraps>

80106002 <vector157>:
.globl vector157
vector157:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $157
80106004:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106009:	e9 4f f5 ff ff       	jmp    8010555d <alltraps>

8010600e <vector158>:
.globl vector158
vector158:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $158
80106010:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106015:	e9 43 f5 ff ff       	jmp    8010555d <alltraps>

8010601a <vector159>:
.globl vector159
vector159:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $159
8010601c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106021:	e9 37 f5 ff ff       	jmp    8010555d <alltraps>

80106026 <vector160>:
.globl vector160
vector160:
  pushl $0
80106026:	6a 00                	push   $0x0
  pushl $160
80106028:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010602d:	e9 2b f5 ff ff       	jmp    8010555d <alltraps>

80106032 <vector161>:
.globl vector161
vector161:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $161
80106034:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106039:	e9 1f f5 ff ff       	jmp    8010555d <alltraps>

8010603e <vector162>:
.globl vector162
vector162:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $162
80106040:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106045:	e9 13 f5 ff ff       	jmp    8010555d <alltraps>

8010604a <vector163>:
.globl vector163
vector163:
  pushl $0
8010604a:	6a 00                	push   $0x0
  pushl $163
8010604c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106051:	e9 07 f5 ff ff       	jmp    8010555d <alltraps>

80106056 <vector164>:
.globl vector164
vector164:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $164
80106058:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010605d:	e9 fb f4 ff ff       	jmp    8010555d <alltraps>

80106062 <vector165>:
.globl vector165
vector165:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $165
80106064:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106069:	e9 ef f4 ff ff       	jmp    8010555d <alltraps>

8010606e <vector166>:
.globl vector166
vector166:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $166
80106070:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106075:	e9 e3 f4 ff ff       	jmp    8010555d <alltraps>

8010607a <vector167>:
.globl vector167
vector167:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $167
8010607c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106081:	e9 d7 f4 ff ff       	jmp    8010555d <alltraps>

80106086 <vector168>:
.globl vector168
vector168:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $168
80106088:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010608d:	e9 cb f4 ff ff       	jmp    8010555d <alltraps>

80106092 <vector169>:
.globl vector169
vector169:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $169
80106094:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106099:	e9 bf f4 ff ff       	jmp    8010555d <alltraps>

8010609e <vector170>:
.globl vector170
vector170:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $170
801060a0:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801060a5:	e9 b3 f4 ff ff       	jmp    8010555d <alltraps>

801060aa <vector171>:
.globl vector171
vector171:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $171
801060ac:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801060b1:	e9 a7 f4 ff ff       	jmp    8010555d <alltraps>

801060b6 <vector172>:
.globl vector172
vector172:
  pushl $0
801060b6:	6a 00                	push   $0x0
  pushl $172
801060b8:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801060bd:	e9 9b f4 ff ff       	jmp    8010555d <alltraps>

801060c2 <vector173>:
.globl vector173
vector173:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $173
801060c4:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801060c9:	e9 8f f4 ff ff       	jmp    8010555d <alltraps>

801060ce <vector174>:
.globl vector174
vector174:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $174
801060d0:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801060d5:	e9 83 f4 ff ff       	jmp    8010555d <alltraps>

801060da <vector175>:
.globl vector175
vector175:
  pushl $0
801060da:	6a 00                	push   $0x0
  pushl $175
801060dc:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801060e1:	e9 77 f4 ff ff       	jmp    8010555d <alltraps>

801060e6 <vector176>:
.globl vector176
vector176:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $176
801060e8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801060ed:	e9 6b f4 ff ff       	jmp    8010555d <alltraps>

801060f2 <vector177>:
.globl vector177
vector177:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $177
801060f4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801060f9:	e9 5f f4 ff ff       	jmp    8010555d <alltraps>

801060fe <vector178>:
.globl vector178
vector178:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $178
80106100:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106105:	e9 53 f4 ff ff       	jmp    8010555d <alltraps>

8010610a <vector179>:
.globl vector179
vector179:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $179
8010610c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106111:	e9 47 f4 ff ff       	jmp    8010555d <alltraps>

80106116 <vector180>:
.globl vector180
vector180:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $180
80106118:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010611d:	e9 3b f4 ff ff       	jmp    8010555d <alltraps>

80106122 <vector181>:
.globl vector181
vector181:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $181
80106124:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106129:	e9 2f f4 ff ff       	jmp    8010555d <alltraps>

8010612e <vector182>:
.globl vector182
vector182:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $182
80106130:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106135:	e9 23 f4 ff ff       	jmp    8010555d <alltraps>

8010613a <vector183>:
.globl vector183
vector183:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $183
8010613c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106141:	e9 17 f4 ff ff       	jmp    8010555d <alltraps>

80106146 <vector184>:
.globl vector184
vector184:
  pushl $0
80106146:	6a 00                	push   $0x0
  pushl $184
80106148:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010614d:	e9 0b f4 ff ff       	jmp    8010555d <alltraps>

80106152 <vector185>:
.globl vector185
vector185:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $185
80106154:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106159:	e9 ff f3 ff ff       	jmp    8010555d <alltraps>

8010615e <vector186>:
.globl vector186
vector186:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $186
80106160:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106165:	e9 f3 f3 ff ff       	jmp    8010555d <alltraps>

8010616a <vector187>:
.globl vector187
vector187:
  pushl $0
8010616a:	6a 00                	push   $0x0
  pushl $187
8010616c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106171:	e9 e7 f3 ff ff       	jmp    8010555d <alltraps>

80106176 <vector188>:
.globl vector188
vector188:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $188
80106178:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010617d:	e9 db f3 ff ff       	jmp    8010555d <alltraps>

80106182 <vector189>:
.globl vector189
vector189:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $189
80106184:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106189:	e9 cf f3 ff ff       	jmp    8010555d <alltraps>

8010618e <vector190>:
.globl vector190
vector190:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $190
80106190:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106195:	e9 c3 f3 ff ff       	jmp    8010555d <alltraps>

8010619a <vector191>:
.globl vector191
vector191:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $191
8010619c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801061a1:	e9 b7 f3 ff ff       	jmp    8010555d <alltraps>

801061a6 <vector192>:
.globl vector192
vector192:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $192
801061a8:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801061ad:	e9 ab f3 ff ff       	jmp    8010555d <alltraps>

801061b2 <vector193>:
.globl vector193
vector193:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $193
801061b4:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801061b9:	e9 9f f3 ff ff       	jmp    8010555d <alltraps>

801061be <vector194>:
.globl vector194
vector194:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $194
801061c0:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801061c5:	e9 93 f3 ff ff       	jmp    8010555d <alltraps>

801061ca <vector195>:
.globl vector195
vector195:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $195
801061cc:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801061d1:	e9 87 f3 ff ff       	jmp    8010555d <alltraps>

801061d6 <vector196>:
.globl vector196
vector196:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $196
801061d8:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801061dd:	e9 7b f3 ff ff       	jmp    8010555d <alltraps>

801061e2 <vector197>:
.globl vector197
vector197:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $197
801061e4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801061e9:	e9 6f f3 ff ff       	jmp    8010555d <alltraps>

801061ee <vector198>:
.globl vector198
vector198:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $198
801061f0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801061f5:	e9 63 f3 ff ff       	jmp    8010555d <alltraps>

801061fa <vector199>:
.globl vector199
vector199:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $199
801061fc:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106201:	e9 57 f3 ff ff       	jmp    8010555d <alltraps>

80106206 <vector200>:
.globl vector200
vector200:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $200
80106208:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010620d:	e9 4b f3 ff ff       	jmp    8010555d <alltraps>

80106212 <vector201>:
.globl vector201
vector201:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $201
80106214:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106219:	e9 3f f3 ff ff       	jmp    8010555d <alltraps>

8010621e <vector202>:
.globl vector202
vector202:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $202
80106220:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106225:	e9 33 f3 ff ff       	jmp    8010555d <alltraps>

8010622a <vector203>:
.globl vector203
vector203:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $203
8010622c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106231:	e9 27 f3 ff ff       	jmp    8010555d <alltraps>

80106236 <vector204>:
.globl vector204
vector204:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $204
80106238:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010623d:	e9 1b f3 ff ff       	jmp    8010555d <alltraps>

80106242 <vector205>:
.globl vector205
vector205:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $205
80106244:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106249:	e9 0f f3 ff ff       	jmp    8010555d <alltraps>

8010624e <vector206>:
.globl vector206
vector206:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $206
80106250:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106255:	e9 03 f3 ff ff       	jmp    8010555d <alltraps>

8010625a <vector207>:
.globl vector207
vector207:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $207
8010625c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106261:	e9 f7 f2 ff ff       	jmp    8010555d <alltraps>

80106266 <vector208>:
.globl vector208
vector208:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $208
80106268:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010626d:	e9 eb f2 ff ff       	jmp    8010555d <alltraps>

80106272 <vector209>:
.globl vector209
vector209:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $209
80106274:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106279:	e9 df f2 ff ff       	jmp    8010555d <alltraps>

8010627e <vector210>:
.globl vector210
vector210:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $210
80106280:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106285:	e9 d3 f2 ff ff       	jmp    8010555d <alltraps>

8010628a <vector211>:
.globl vector211
vector211:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $211
8010628c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106291:	e9 c7 f2 ff ff       	jmp    8010555d <alltraps>

80106296 <vector212>:
.globl vector212
vector212:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $212
80106298:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010629d:	e9 bb f2 ff ff       	jmp    8010555d <alltraps>

801062a2 <vector213>:
.globl vector213
vector213:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $213
801062a4:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801062a9:	e9 af f2 ff ff       	jmp    8010555d <alltraps>

801062ae <vector214>:
.globl vector214
vector214:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $214
801062b0:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801062b5:	e9 a3 f2 ff ff       	jmp    8010555d <alltraps>

801062ba <vector215>:
.globl vector215
vector215:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $215
801062bc:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801062c1:	e9 97 f2 ff ff       	jmp    8010555d <alltraps>

801062c6 <vector216>:
.globl vector216
vector216:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $216
801062c8:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801062cd:	e9 8b f2 ff ff       	jmp    8010555d <alltraps>

801062d2 <vector217>:
.globl vector217
vector217:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $217
801062d4:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801062d9:	e9 7f f2 ff ff       	jmp    8010555d <alltraps>

801062de <vector218>:
.globl vector218
vector218:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $218
801062e0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801062e5:	e9 73 f2 ff ff       	jmp    8010555d <alltraps>

801062ea <vector219>:
.globl vector219
vector219:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $219
801062ec:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801062f1:	e9 67 f2 ff ff       	jmp    8010555d <alltraps>

801062f6 <vector220>:
.globl vector220
vector220:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $220
801062f8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801062fd:	e9 5b f2 ff ff       	jmp    8010555d <alltraps>

80106302 <vector221>:
.globl vector221
vector221:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $221
80106304:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106309:	e9 4f f2 ff ff       	jmp    8010555d <alltraps>

8010630e <vector222>:
.globl vector222
vector222:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $222
80106310:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106315:	e9 43 f2 ff ff       	jmp    8010555d <alltraps>

8010631a <vector223>:
.globl vector223
vector223:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $223
8010631c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106321:	e9 37 f2 ff ff       	jmp    8010555d <alltraps>

80106326 <vector224>:
.globl vector224
vector224:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $224
80106328:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010632d:	e9 2b f2 ff ff       	jmp    8010555d <alltraps>

80106332 <vector225>:
.globl vector225
vector225:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $225
80106334:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106339:	e9 1f f2 ff ff       	jmp    8010555d <alltraps>

8010633e <vector226>:
.globl vector226
vector226:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $226
80106340:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106345:	e9 13 f2 ff ff       	jmp    8010555d <alltraps>

8010634a <vector227>:
.globl vector227
vector227:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $227
8010634c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106351:	e9 07 f2 ff ff       	jmp    8010555d <alltraps>

80106356 <vector228>:
.globl vector228
vector228:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $228
80106358:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010635d:	e9 fb f1 ff ff       	jmp    8010555d <alltraps>

80106362 <vector229>:
.globl vector229
vector229:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $229
80106364:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106369:	e9 ef f1 ff ff       	jmp    8010555d <alltraps>

8010636e <vector230>:
.globl vector230
vector230:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $230
80106370:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106375:	e9 e3 f1 ff ff       	jmp    8010555d <alltraps>

8010637a <vector231>:
.globl vector231
vector231:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $231
8010637c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106381:	e9 d7 f1 ff ff       	jmp    8010555d <alltraps>

80106386 <vector232>:
.globl vector232
vector232:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $232
80106388:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010638d:	e9 cb f1 ff ff       	jmp    8010555d <alltraps>

80106392 <vector233>:
.globl vector233
vector233:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $233
80106394:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106399:	e9 bf f1 ff ff       	jmp    8010555d <alltraps>

8010639e <vector234>:
.globl vector234
vector234:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $234
801063a0:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801063a5:	e9 b3 f1 ff ff       	jmp    8010555d <alltraps>

801063aa <vector235>:
.globl vector235
vector235:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $235
801063ac:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801063b1:	e9 a7 f1 ff ff       	jmp    8010555d <alltraps>

801063b6 <vector236>:
.globl vector236
vector236:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $236
801063b8:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801063bd:	e9 9b f1 ff ff       	jmp    8010555d <alltraps>

801063c2 <vector237>:
.globl vector237
vector237:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $237
801063c4:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801063c9:	e9 8f f1 ff ff       	jmp    8010555d <alltraps>

801063ce <vector238>:
.globl vector238
vector238:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $238
801063d0:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801063d5:	e9 83 f1 ff ff       	jmp    8010555d <alltraps>

801063da <vector239>:
.globl vector239
vector239:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $239
801063dc:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801063e1:	e9 77 f1 ff ff       	jmp    8010555d <alltraps>

801063e6 <vector240>:
.globl vector240
vector240:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $240
801063e8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801063ed:	e9 6b f1 ff ff       	jmp    8010555d <alltraps>

801063f2 <vector241>:
.globl vector241
vector241:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $241
801063f4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801063f9:	e9 5f f1 ff ff       	jmp    8010555d <alltraps>

801063fe <vector242>:
.globl vector242
vector242:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $242
80106400:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106405:	e9 53 f1 ff ff       	jmp    8010555d <alltraps>

8010640a <vector243>:
.globl vector243
vector243:
  pushl $0
8010640a:	6a 00                	push   $0x0
  pushl $243
8010640c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106411:	e9 47 f1 ff ff       	jmp    8010555d <alltraps>

80106416 <vector244>:
.globl vector244
vector244:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $244
80106418:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010641d:	e9 3b f1 ff ff       	jmp    8010555d <alltraps>

80106422 <vector245>:
.globl vector245
vector245:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $245
80106424:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106429:	e9 2f f1 ff ff       	jmp    8010555d <alltraps>

8010642e <vector246>:
.globl vector246
vector246:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $246
80106430:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106435:	e9 23 f1 ff ff       	jmp    8010555d <alltraps>

8010643a <vector247>:
.globl vector247
vector247:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $247
8010643c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106441:	e9 17 f1 ff ff       	jmp    8010555d <alltraps>

80106446 <vector248>:
.globl vector248
vector248:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $248
80106448:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010644d:	e9 0b f1 ff ff       	jmp    8010555d <alltraps>

80106452 <vector249>:
.globl vector249
vector249:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $249
80106454:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106459:	e9 ff f0 ff ff       	jmp    8010555d <alltraps>

8010645e <vector250>:
.globl vector250
vector250:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $250
80106460:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106465:	e9 f3 f0 ff ff       	jmp    8010555d <alltraps>

8010646a <vector251>:
.globl vector251
vector251:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $251
8010646c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106471:	e9 e7 f0 ff ff       	jmp    8010555d <alltraps>

80106476 <vector252>:
.globl vector252
vector252:
  pushl $0
80106476:	6a 00                	push   $0x0
  pushl $252
80106478:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010647d:	e9 db f0 ff ff       	jmp    8010555d <alltraps>

80106482 <vector253>:
.globl vector253
vector253:
  pushl $0
80106482:	6a 00                	push   $0x0
  pushl $253
80106484:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106489:	e9 cf f0 ff ff       	jmp    8010555d <alltraps>

8010648e <vector254>:
.globl vector254
vector254:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $254
80106490:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106495:	e9 c3 f0 ff ff       	jmp    8010555d <alltraps>

8010649a <vector255>:
.globl vector255
vector255:
  pushl $0
8010649a:	6a 00                	push   $0x0
  pushl $255
8010649c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801064a1:	e9 b7 f0 ff ff       	jmp    8010555d <alltraps>
801064a6:	66 90                	xchg   %ax,%ax
801064a8:	66 90                	xchg   %ax,%ax
801064aa:	66 90                	xchg   %ax,%ax
801064ac:	66 90                	xchg   %ax,%ax
801064ae:	66 90                	xchg   %ax,%ax

801064b0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801064b0:	55                   	push   %ebp
801064b1:	89 e5                	mov    %esp,%ebp
801064b3:	57                   	push   %edi
801064b4:	56                   	push   %esi
801064b5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801064b7:	c1 ea 16             	shr    $0x16,%edx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801064ba:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801064bb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801064be:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
801064c1:	8b 1f                	mov    (%edi),%ebx
801064c3:	f6 c3 01             	test   $0x1,%bl
801064c6:	74 28                	je     801064f0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801064c8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801064ce:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801064d4:	c1 ee 0a             	shr    $0xa,%esi
}
801064d7:	83 c4 1c             	add    $0x1c,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801064da:	89 f2                	mov    %esi,%edx
801064dc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801064e2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801064e5:	5b                   	pop    %ebx
801064e6:	5e                   	pop    %esi
801064e7:	5f                   	pop    %edi
801064e8:	5d                   	pop    %ebp
801064e9:	c3                   	ret    
801064ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801064f0:	85 c9                	test   %ecx,%ecx
801064f2:	74 34                	je     80106528 <walkpgdir+0x78>
801064f4:	e8 07 c0 ff ff       	call   80102500 <kalloc>
801064f9:	85 c0                	test   %eax,%eax
801064fb:	89 c3                	mov    %eax,%ebx
801064fd:	74 29                	je     80106528 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801064ff:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106506:	00 
80106507:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010650e:	00 
8010650f:	89 04 24             	mov    %eax,(%esp)
80106512:	e8 b9 de ff ff       	call   801043d0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106517:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010651d:	83 c8 07             	or     $0x7,%eax
80106520:	89 07                	mov    %eax,(%edi)
80106522:	eb b0                	jmp    801064d4 <walkpgdir+0x24>
80106524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  return &pgtab[PTX(va)];
}
80106528:	83 c4 1c             	add    $0x1c,%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
8010652b:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
8010652d:	5b                   	pop    %ebx
8010652e:	5e                   	pop    %esi
8010652f:	5f                   	pop    %edi
80106530:	5d                   	pop    %ebp
80106531:	c3                   	ret    
80106532:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106540 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106540:	55                   	push   %ebp
80106541:	89 e5                	mov    %esp,%ebp
80106543:	57                   	push   %edi
80106544:	56                   	push   %esi
80106545:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106546:	89 d3                	mov    %edx,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106548:	83 ec 1c             	sub    $0x1c,%esp
8010654b:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010654e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106554:	89 45 e0             	mov    %eax,-0x20(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106557:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
8010655b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010655e:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106562:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
80106569:	29 df                	sub    %ebx,%edi
8010656b:	eb 18                	jmp    80106585 <mappages+0x45>
8010656d:	8d 76 00             	lea    0x0(%esi),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106570:	f6 00 01             	testb  $0x1,(%eax)
80106573:	75 3d                	jne    801065b2 <mappages+0x72>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106575:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
80106578:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010657b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010657d:	74 29                	je     801065a8 <mappages+0x68>
      break;
    a += PGSIZE;
8010657f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106585:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106588:	b9 01 00 00 00       	mov    $0x1,%ecx
8010658d:	89 da                	mov    %ebx,%edx
8010658f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106592:	e8 19 ff ff ff       	call   801064b0 <walkpgdir>
80106597:	85 c0                	test   %eax,%eax
80106599:	75 d5                	jne    80106570 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010659b:	83 c4 1c             	add    $0x1c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010659e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801065a3:	5b                   	pop    %ebx
801065a4:	5e                   	pop    %esi
801065a5:	5f                   	pop    %edi
801065a6:	5d                   	pop    %ebp
801065a7:	c3                   	ret    
801065a8:	83 c4 1c             	add    $0x1c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801065ab:	31 c0                	xor    %eax,%eax
}
801065ad:	5b                   	pop    %ebx
801065ae:	5e                   	pop    %esi
801065af:	5f                   	pop    %edi
801065b0:	5d                   	pop    %ebp
801065b1:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
801065b2:	c7 04 24 88 76 10 80 	movl   $0x80107688,(%esp)
801065b9:	e8 a2 9d ff ff       	call   80100360 <panic>
801065be:	66 90                	xchg   %ax,%ax

801065c0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801065c0:	55                   	push   %ebp
801065c1:	89 e5                	mov    %esp,%ebp
801065c3:	57                   	push   %edi
801065c4:	89 c7                	mov    %eax,%edi
801065c6:	56                   	push   %esi
801065c7:	89 d6                	mov    %edx,%esi
801065c9:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801065ca:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801065d0:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801065d3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801065d9:	39 d3                	cmp    %edx,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801065db:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801065de:	72 3b                	jb     8010661b <deallocuvm.part.0+0x5b>
801065e0:	eb 5e                	jmp    80106640 <deallocuvm.part.0+0x80>
801065e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801065e8:	8b 10                	mov    (%eax),%edx
801065ea:	f6 c2 01             	test   $0x1,%dl
801065ed:	74 22                	je     80106611 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801065ef:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801065f5:	74 54                	je     8010664b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
801065f7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801065fd:	89 14 24             	mov    %edx,(%esp)
80106600:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106603:	e8 48 bd ff ff       	call   80102350 <kfree>
      *pte = 0;
80106608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010660b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106617:	39 f3                	cmp    %esi,%ebx
80106619:	73 25                	jae    80106640 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010661b:	31 c9                	xor    %ecx,%ecx
8010661d:	89 da                	mov    %ebx,%edx
8010661f:	89 f8                	mov    %edi,%eax
80106621:	e8 8a fe ff ff       	call   801064b0 <walkpgdir>
    if(!pte)
80106626:	85 c0                	test   %eax,%eax
80106628:	75 be                	jne    801065e8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010662a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106630:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106636:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010663c:	39 f3                	cmp    %esi,%ebx
8010663e:	72 db                	jb     8010661b <deallocuvm.part.0+0x5b>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106640:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106643:	83 c4 1c             	add    $0x1c,%esp
80106646:	5b                   	pop    %ebx
80106647:	5e                   	pop    %esi
80106648:	5f                   	pop    %edi
80106649:	5d                   	pop    %ebp
8010664a:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010664b:	c7 04 24 52 70 10 80 	movl   $0x80107052,(%esp)
80106652:	e8 09 9d ff ff       	call   80100360 <panic>
80106657:	89 f6                	mov    %esi,%esi
80106659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106660 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106660:	55                   	push   %ebp
80106661:	89 e5                	mov    %esp,%ebp
80106663:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106666:	e8 55 c1 ff ff       	call   801027c0 <cpunum>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010666b:	31 c9                	xor    %ecx,%ecx
8010666d:	ba ff ff ff ff       	mov    $0xffffffff,%edx

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106672:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80106678:	05 a0 27 11 80       	add    $0x801127a0,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010667d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106681:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106686:	66 89 48 7a          	mov    %cx,0x7a(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010668a:	31 c9                	xor    %ecx,%ecx
8010668c:	66 89 90 80 00 00 00 	mov    %dx,0x80(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106693:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106698:	66 89 88 82 00 00 00 	mov    %cx,0x82(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010669f:	31 c9                	xor    %ecx,%ecx
801066a1:	66 89 90 90 00 00 00 	mov    %dx,0x90(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801066a8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801066ad:	66 89 88 92 00 00 00 	mov    %cx,0x92(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801066b4:	31 c9                	xor    %ecx,%ecx
801066b6:	66 89 90 98 00 00 00 	mov    %dx,0x98(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801066bd:	8d 90 b4 00 00 00    	lea    0xb4(%eax),%edx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801066c3:	66 89 88 9a 00 00 00 	mov    %cx,0x9a(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801066ca:	31 c9                	xor    %ecx,%ecx
801066cc:	66 89 88 88 00 00 00 	mov    %cx,0x88(%eax)
801066d3:	89 d1                	mov    %edx,%ecx
801066d5:	c1 e9 10             	shr    $0x10,%ecx
801066d8:	66 89 90 8a 00 00 00 	mov    %dx,0x8a(%eax)
801066df:	c1 ea 18             	shr    $0x18,%edx
801066e2:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801066e8:	b9 37 00 00 00       	mov    $0x37,%ecx
801066ed:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801066f3:	8d 50 70             	lea    0x70(%eax),%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801066f6:	c6 40 7d 9a          	movb   $0x9a,0x7d(%eax)
801066fa:	c6 40 7e cf          	movb   $0xcf,0x7e(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801066fe:	c6 80 85 00 00 00 92 	movb   $0x92,0x85(%eax)
80106705:	c6 80 86 00 00 00 cf 	movb   $0xcf,0x86(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010670c:	c6 80 95 00 00 00 fa 	movb   $0xfa,0x95(%eax)
80106713:	c6 80 96 00 00 00 cf 	movb   $0xcf,0x96(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010671a:	c6 80 9d 00 00 00 f2 	movb   $0xf2,0x9d(%eax)
80106721:	c6 80 9e 00 00 00 cf 	movb   $0xcf,0x9e(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106728:	c6 80 8d 00 00 00 92 	movb   $0x92,0x8d(%eax)
8010672f:	c6 80 8e 00 00 00 c0 	movb   $0xc0,0x8e(%eax)
80106736:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  pd[1] = (uint)p;
8010673a:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
8010673e:	c1 ea 10             	shr    $0x10,%edx
80106741:	66 89 55 f6          	mov    %dx,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106745:	8d 55 f2             	lea    -0xe(%ebp),%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106748:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010674c:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106750:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80106757:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010675e:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80106765:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010676c:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80106773:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)
8010677a:	0f 01 12             	lgdtl  (%edx)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
8010677d:	ba 18 00 00 00       	mov    $0x18,%edx
80106782:	8e ea                	mov    %edx,%gs
  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
80106784:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010678b:	00 00 00 00 

  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
8010678f:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
}
80106795:	c9                   	leave  
80106796:	c3                   	ret    
80106797:	89 f6                	mov    %esi,%esi
80106799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067a0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801067a0:	55                   	push   %ebp
801067a1:	89 e5                	mov    %esp,%ebp
801067a3:	56                   	push   %esi
801067a4:	53                   	push   %ebx
801067a5:	83 ec 10             	sub    $0x10,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801067a8:	e8 53 bd ff ff       	call   80102500 <kalloc>
801067ad:	85 c0                	test   %eax,%eax
801067af:	89 c6                	mov    %eax,%esi
801067b1:	74 55                	je     80106808 <setupkvm+0x68>
    return 0;
  memset(pgdir, 0, PGSIZE);
801067b3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801067ba:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801067bb:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
801067c0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801067c7:	00 
801067c8:	89 04 24             	mov    %eax,(%esp)
801067cb:	e8 00 dc ff ff       	call   801043d0 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801067d0:	8b 53 0c             	mov    0xc(%ebx),%edx
801067d3:	8b 43 04             	mov    0x4(%ebx),%eax
801067d6:	8b 4b 08             	mov    0x8(%ebx),%ecx
801067d9:	89 54 24 04          	mov    %edx,0x4(%esp)
801067dd:	8b 13                	mov    (%ebx),%edx
801067df:	89 04 24             	mov    %eax,(%esp)
801067e2:	29 c1                	sub    %eax,%ecx
801067e4:	89 f0                	mov    %esi,%eax
801067e6:	e8 55 fd ff ff       	call   80106540 <mappages>
801067eb:	85 c0                	test   %eax,%eax
801067ed:	78 19                	js     80106808 <setupkvm+0x68>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801067ef:	83 c3 10             	add    $0x10,%ebx
801067f2:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801067f8:	72 d6                	jb     801067d0 <setupkvm+0x30>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
801067fa:	83 c4 10             	add    $0x10,%esp
801067fd:	89 f0                	mov    %esi,%eax
801067ff:	5b                   	pop    %ebx
80106800:	5e                   	pop    %esi
80106801:	5d                   	pop    %ebp
80106802:	c3                   	ret    
80106803:	90                   	nop
80106804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106808:	83 c4 10             	add    $0x10,%esp
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
8010680b:	31 c0                	xor    %eax,%eax
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
8010680d:	5b                   	pop    %ebx
8010680e:	5e                   	pop    %esi
8010680f:	5d                   	pop    %ebp
80106810:	c3                   	ret    
80106811:	eb 0d                	jmp    80106820 <kvmalloc>
80106813:	90                   	nop
80106814:	90                   	nop
80106815:	90                   	nop
80106816:	90                   	nop
80106817:	90                   	nop
80106818:	90                   	nop
80106819:	90                   	nop
8010681a:	90                   	nop
8010681b:	90                   	nop
8010681c:	90                   	nop
8010681d:	90                   	nop
8010681e:	90                   	nop
8010681f:	90                   	nop

80106820 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106820:	55                   	push   %ebp
80106821:	89 e5                	mov    %esp,%ebp
80106823:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106826:	e8 75 ff ff ff       	call   801067a0 <setupkvm>
8010682b:	a3 24 56 11 80       	mov    %eax,0x80115624
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106830:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106835:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
80106838:	c9                   	leave  
80106839:	c3                   	ret    
8010683a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106840 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106840:	a1 24 56 11 80       	mov    0x80115624,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106845:	55                   	push   %ebp
80106846:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106848:	05 00 00 00 80       	add    $0x80000000,%eax
8010684d:	0f 22 d8             	mov    %eax,%cr3
}
80106850:	5d                   	pop    %ebp
80106851:	c3                   	ret    
80106852:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106860 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106860:	55                   	push   %ebp
80106861:	89 e5                	mov    %esp,%ebp
80106863:	53                   	push   %ebx
80106864:	83 ec 14             	sub    $0x14,%esp
80106867:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010686a:	85 db                	test   %ebx,%ebx
8010686c:	0f 84 94 00 00 00    	je     80106906 <switchuvm+0xa6>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106872:	8b 43 08             	mov    0x8(%ebx),%eax
80106875:	85 c0                	test   %eax,%eax
80106877:	0f 84 a1 00 00 00    	je     8010691e <switchuvm+0xbe>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010687d:	8b 43 04             	mov    0x4(%ebx),%eax
80106880:	85 c0                	test   %eax,%eax
80106882:	0f 84 8a 00 00 00    	je     80106912 <switchuvm+0xb2>
    panic("switchuvm: no pgdir");

  pushcli();
80106888:	e8 73 da ff ff       	call   80104300 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010688d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106893:	b9 67 00 00 00       	mov    $0x67,%ecx
80106898:	8d 50 08             	lea    0x8(%eax),%edx
8010689b:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
801068a2:	89 d1                	mov    %edx,%ecx
801068a4:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
801068ab:	c1 ea 18             	shr    $0x18,%edx
801068ae:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
801068b4:	c1 e9 10             	shr    $0x10,%ecx
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
801068b7:	ba 10 00 00 00       	mov    $0x10,%edx
801068bc:	66 89 50 10          	mov    %dx,0x10(%eax)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801068c0:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
801068c6:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801068cd:	c6 80 a5 00 00 00 89 	movb   $0x89,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801068d4:	8b 4b 08             	mov    0x8(%ebx),%ecx
801068d7:	8d 91 00 10 00 00    	lea    0x1000(%ecx),%edx
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
801068dd:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801068e2:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
801068e5:	66 89 48 6e          	mov    %cx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
801068e9:	b8 30 00 00 00       	mov    $0x30,%eax
801068ee:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801068f1:	8b 43 04             	mov    0x4(%ebx),%eax
801068f4:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801068f9:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
801068fc:	83 c4 14             	add    $0x14,%esp
801068ff:	5b                   	pop    %ebx
80106900:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106901:	e9 2a da ff ff       	jmp    80104330 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106906:	c7 04 24 8e 76 10 80 	movl   $0x8010768e,(%esp)
8010690d:	e8 4e 9a ff ff       	call   80100360 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106912:	c7 04 24 b9 76 10 80 	movl   $0x801076b9,(%esp)
80106919:	e8 42 9a ff ff       	call   80100360 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
8010691e:	c7 04 24 a4 76 10 80 	movl   $0x801076a4,(%esp)
80106925:	e8 36 9a ff ff       	call   80100360 <panic>
8010692a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106930 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106930:	55                   	push   %ebp
80106931:	89 e5                	mov    %esp,%ebp
80106933:	57                   	push   %edi
80106934:	56                   	push   %esi
80106935:	53                   	push   %ebx
80106936:	83 ec 1c             	sub    $0x1c,%esp
80106939:	8b 75 10             	mov    0x10(%ebp),%esi
8010693c:	8b 45 08             	mov    0x8(%ebp),%eax
8010693f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106942:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106948:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
8010694b:	77 54                	ja     801069a1 <inituvm+0x71>
    panic("inituvm: more than a page");
  mem = kalloc();
8010694d:	e8 ae bb ff ff       	call   80102500 <kalloc>
  memset(mem, 0, PGSIZE);
80106952:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106959:	00 
8010695a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106961:	00 
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106962:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106964:	89 04 24             	mov    %eax,(%esp)
80106967:	e8 64 da ff ff       	call   801043d0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010696c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106972:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106977:	89 04 24             	mov    %eax,(%esp)
8010697a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010697d:	31 d2                	xor    %edx,%edx
8010697f:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106986:	00 
80106987:	e8 b4 fb ff ff       	call   80106540 <mappages>
  memmove(mem, init, sz);
8010698c:	89 75 10             	mov    %esi,0x10(%ebp)
8010698f:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106992:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106995:	83 c4 1c             	add    $0x1c,%esp
80106998:	5b                   	pop    %ebx
80106999:	5e                   	pop    %esi
8010699a:	5f                   	pop    %edi
8010699b:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
8010699c:	e9 cf da ff ff       	jmp    80104470 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
801069a1:	c7 04 24 cd 76 10 80 	movl   $0x801076cd,(%esp)
801069a8:	e8 b3 99 ff ff       	call   80100360 <panic>
801069ad:	8d 76 00             	lea    0x0(%esi),%esi

801069b0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801069b0:	55                   	push   %ebp
801069b1:	89 e5                	mov    %esp,%ebp
801069b3:	57                   	push   %edi
801069b4:	56                   	push   %esi
801069b5:	53                   	push   %ebx
801069b6:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801069b9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801069c0:	0f 85 98 00 00 00    	jne    80106a5e <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801069c6:	8b 75 18             	mov    0x18(%ebp),%esi
801069c9:	31 db                	xor    %ebx,%ebx
801069cb:	85 f6                	test   %esi,%esi
801069cd:	75 1a                	jne    801069e9 <loaduvm+0x39>
801069cf:	eb 77                	jmp    80106a48 <loaduvm+0x98>
801069d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069d8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801069de:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801069e4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801069e7:	76 5f                	jbe    80106a48 <loaduvm+0x98>
801069e9:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801069ec:	31 c9                	xor    %ecx,%ecx
801069ee:	8b 45 08             	mov    0x8(%ebp),%eax
801069f1:	01 da                	add    %ebx,%edx
801069f3:	e8 b8 fa ff ff       	call   801064b0 <walkpgdir>
801069f8:	85 c0                	test   %eax,%eax
801069fa:	74 56                	je     80106a52 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801069fc:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
801069fe:	bf 00 10 00 00       	mov    $0x1000,%edi
80106a03:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106a06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80106a0b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106a11:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106a14:	05 00 00 00 80       	add    $0x80000000,%eax
80106a19:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a1d:	8b 45 10             	mov    0x10(%ebp),%eax
80106a20:	01 d9                	add    %ebx,%ecx
80106a22:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106a26:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106a2a:	89 04 24             	mov    %eax,(%esp)
80106a2d:	e8 7e af ff ff       	call   801019b0 <readi>
80106a32:	39 f8                	cmp    %edi,%eax
80106a34:	74 a2                	je     801069d8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106a36:	83 c4 1c             	add    $0x1c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106a39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106a3e:	5b                   	pop    %ebx
80106a3f:	5e                   	pop    %esi
80106a40:	5f                   	pop    %edi
80106a41:	5d                   	pop    %ebp
80106a42:	c3                   	ret    
80106a43:	90                   	nop
80106a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a48:	83 c4 1c             	add    $0x1c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106a4b:	31 c0                	xor    %eax,%eax
}
80106a4d:	5b                   	pop    %ebx
80106a4e:	5e                   	pop    %esi
80106a4f:	5f                   	pop    %edi
80106a50:	5d                   	pop    %ebp
80106a51:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106a52:	c7 04 24 e7 76 10 80 	movl   $0x801076e7,(%esp)
80106a59:	e8 02 99 ff ff       	call   80100360 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106a5e:	c7 04 24 88 77 10 80 	movl   $0x80107788,(%esp)
80106a65:	e8 f6 98 ff ff       	call   80100360 <panic>
80106a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a70 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106a70:	55                   	push   %ebp
80106a71:	89 e5                	mov    %esp,%ebp
80106a73:	57                   	push   %edi
80106a74:	56                   	push   %esi
80106a75:	53                   	push   %ebx
80106a76:	83 ec 1c             	sub    $0x1c,%esp
80106a79:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106a7c:	85 ff                	test   %edi,%edi
80106a7e:	0f 88 7e 00 00 00    	js     80106b02 <allocuvm+0x92>
    return 0;
  if(newsz < oldsz)
80106a84:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106a8a:	72 78                	jb     80106b04 <allocuvm+0x94>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106a8c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106a92:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106a98:	39 df                	cmp    %ebx,%edi
80106a9a:	77 4a                	ja     80106ae6 <allocuvm+0x76>
80106a9c:	eb 72                	jmp    80106b10 <allocuvm+0xa0>
80106a9e:	66 90                	xchg   %ax,%ax
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106aa0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106aa7:	00 
80106aa8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106aaf:	00 
80106ab0:	89 04 24             	mov    %eax,(%esp)
80106ab3:	e8 18 d9 ff ff       	call   801043d0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106ab8:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106abe:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ac3:	89 04 24             	mov    %eax,(%esp)
80106ac6:	8b 45 08             	mov    0x8(%ebp),%eax
80106ac9:	89 da                	mov    %ebx,%edx
80106acb:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106ad2:	00 
80106ad3:	e8 68 fa ff ff       	call   80106540 <mappages>
80106ad8:	85 c0                	test   %eax,%eax
80106ada:	78 44                	js     80106b20 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106adc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ae2:	39 df                	cmp    %ebx,%edi
80106ae4:	76 2a                	jbe    80106b10 <allocuvm+0xa0>
    mem = kalloc();
80106ae6:	e8 15 ba ff ff       	call   80102500 <kalloc>
    if(mem == 0){
80106aeb:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106aed:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106aef:	75 af                	jne    80106aa0 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106af1:	c7 04 24 05 77 10 80 	movl   $0x80107705,(%esp)
80106af8:	e8 53 9b ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106afd:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106b00:	77 48                	ja     80106b4a <allocuvm+0xda>
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106b02:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106b04:	83 c4 1c             	add    $0x1c,%esp
80106b07:	5b                   	pop    %ebx
80106b08:	5e                   	pop    %esi
80106b09:	5f                   	pop    %edi
80106b0a:	5d                   	pop    %ebp
80106b0b:	c3                   	ret    
80106b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b10:	83 c4 1c             	add    $0x1c,%esp
80106b13:	89 f8                	mov    %edi,%eax
80106b15:	5b                   	pop    %ebx
80106b16:	5e                   	pop    %esi
80106b17:	5f                   	pop    %edi
80106b18:	5d                   	pop    %ebp
80106b19:	c3                   	ret    
80106b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106b20:	c7 04 24 1d 77 10 80 	movl   $0x8010771d,(%esp)
80106b27:	e8 24 9b ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106b2c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106b2f:	76 0d                	jbe    80106b3e <allocuvm+0xce>
80106b31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106b34:	89 fa                	mov    %edi,%edx
80106b36:	8b 45 08             	mov    0x8(%ebp),%eax
80106b39:	e8 82 fa ff ff       	call   801065c0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106b3e:	89 34 24             	mov    %esi,(%esp)
80106b41:	e8 0a b8 ff ff       	call   80102350 <kfree>
      return 0;
80106b46:	31 c0                	xor    %eax,%eax
80106b48:	eb ba                	jmp    80106b04 <allocuvm+0x94>
80106b4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106b4d:	89 fa                	mov    %edi,%edx
80106b4f:	8b 45 08             	mov    0x8(%ebp),%eax
80106b52:	e8 69 fa ff ff       	call   801065c0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106b57:	31 c0                	xor    %eax,%eax
80106b59:	eb a9                	jmp    80106b04 <allocuvm+0x94>
80106b5b:	90                   	nop
80106b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b60 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b66:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106b69:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106b6c:	39 d1                	cmp    %edx,%ecx
80106b6e:	73 08                	jae    80106b78 <deallocuvm+0x18>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106b70:	5d                   	pop    %ebp
80106b71:	e9 4a fa ff ff       	jmp    801065c0 <deallocuvm.part.0>
80106b76:	66 90                	xchg   %ax,%ax
80106b78:	89 d0                	mov    %edx,%eax
80106b7a:	5d                   	pop    %ebp
80106b7b:	c3                   	ret    
80106b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b80 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106b80:	55                   	push   %ebp
80106b81:	89 e5                	mov    %esp,%ebp
80106b83:	56                   	push   %esi
80106b84:	53                   	push   %ebx
80106b85:	83 ec 10             	sub    $0x10,%esp
80106b88:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106b8b:	85 f6                	test   %esi,%esi
80106b8d:	74 59                	je     80106be8 <freevm+0x68>
80106b8f:	31 c9                	xor    %ecx,%ecx
80106b91:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106b96:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106b98:	31 db                	xor    %ebx,%ebx
80106b9a:	e8 21 fa ff ff       	call   801065c0 <deallocuvm.part.0>
80106b9f:	eb 12                	jmp    80106bb3 <freevm+0x33>
80106ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ba8:	83 c3 01             	add    $0x1,%ebx
80106bab:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106bb1:	74 27                	je     80106bda <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106bb3:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106bb6:	f6 c2 01             	test   $0x1,%dl
80106bb9:	74 ed                	je     80106ba8 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106bbb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106bc1:	83 c3 01             	add    $0x1,%ebx
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106bc4:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106bca:	89 14 24             	mov    %edx,(%esp)
80106bcd:	e8 7e b7 ff ff       	call   80102350 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106bd2:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106bd8:	75 d9                	jne    80106bb3 <freevm+0x33>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106bda:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106bdd:	83 c4 10             	add    $0x10,%esp
80106be0:	5b                   	pop    %ebx
80106be1:	5e                   	pop    %esi
80106be2:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106be3:	e9 68 b7 ff ff       	jmp    80102350 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106be8:	c7 04 24 39 77 10 80 	movl   $0x80107739,(%esp)
80106bef:	e8 6c 97 ff ff       	call   80100360 <panic>
80106bf4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c00 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106c00:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c01:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106c03:	89 e5                	mov    %esp,%ebp
80106c05:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c08:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c0b:	8b 45 08             	mov    0x8(%ebp),%eax
80106c0e:	e8 9d f8 ff ff       	call   801064b0 <walkpgdir>
  if(pte == 0)
80106c13:	85 c0                	test   %eax,%eax
80106c15:	74 05                	je     80106c1c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106c17:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106c1a:	c9                   	leave  
80106c1b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106c1c:	c7 04 24 4a 77 10 80 	movl   $0x8010774a,(%esp)
80106c23:	e8 38 97 ff ff       	call   80100360 <panic>
80106c28:	90                   	nop
80106c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c30 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106c30:	55                   	push   %ebp
80106c31:	89 e5                	mov    %esp,%ebp
80106c33:	57                   	push   %edi
80106c34:	56                   	push   %esi
80106c35:	53                   	push   %ebx
80106c36:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106c39:	e8 62 fb ff ff       	call   801067a0 <setupkvm>
80106c3e:	85 c0                	test   %eax,%eax
80106c40:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106c43:	0f 84 b2 00 00 00    	je     80106cfb <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c4c:	85 c0                	test   %eax,%eax
80106c4e:	0f 84 9c 00 00 00    	je     80106cf0 <copyuvm+0xc0>
80106c54:	31 db                	xor    %ebx,%ebx
80106c56:	eb 48                	jmp    80106ca0 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106c58:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106c5e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c65:	00 
80106c66:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106c6a:	89 04 24             	mov    %eax,(%esp)
80106c6d:	e8 fe d7 ff ff       	call   80104470 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106c72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c75:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106c7b:	89 14 24             	mov    %edx,(%esp)
80106c7e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c83:	89 da                	mov    %ebx,%edx
80106c85:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c89:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c8c:	e8 af f8 ff ff       	call   80106540 <mappages>
80106c91:	85 c0                	test   %eax,%eax
80106c93:	78 41                	js     80106cd6 <copyuvm+0xa6>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106c95:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c9b:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106c9e:	76 50                	jbe    80106cf0 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106ca0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ca3:	31 c9                	xor    %ecx,%ecx
80106ca5:	89 da                	mov    %ebx,%edx
80106ca7:	e8 04 f8 ff ff       	call   801064b0 <walkpgdir>
80106cac:	85 c0                	test   %eax,%eax
80106cae:	74 5b                	je     80106d0b <copyuvm+0xdb>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106cb0:	8b 30                	mov    (%eax),%esi
80106cb2:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106cb8:	74 45                	je     80106cff <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106cba:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106cbc:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106cc2:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106cc5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106ccb:	e8 30 b8 ff ff       	call   80102500 <kalloc>
80106cd0:	85 c0                	test   %eax,%eax
80106cd2:	89 c6                	mov    %eax,%esi
80106cd4:	75 82                	jne    80106c58 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106cd6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106cd9:	89 04 24             	mov    %eax,(%esp)
80106cdc:	e8 9f fe ff ff       	call   80106b80 <freevm>
  return 0;
80106ce1:	31 c0                	xor    %eax,%eax
}
80106ce3:	83 c4 2c             	add    $0x2c,%esp
80106ce6:	5b                   	pop    %ebx
80106ce7:	5e                   	pop    %esi
80106ce8:	5f                   	pop    %edi
80106ce9:	5d                   	pop    %ebp
80106cea:	c3                   	ret    
80106ceb:	90                   	nop
80106cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cf0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106cf3:	83 c4 2c             	add    $0x2c,%esp
80106cf6:	5b                   	pop    %ebx
80106cf7:	5e                   	pop    %esi
80106cf8:	5f                   	pop    %edi
80106cf9:	5d                   	pop    %ebp
80106cfa:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106cfb:	31 c0                	xor    %eax,%eax
80106cfd:	eb e4                	jmp    80106ce3 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106cff:	c7 04 24 6e 77 10 80 	movl   $0x8010776e,(%esp)
80106d06:	e8 55 96 ff ff       	call   80100360 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106d0b:	c7 04 24 54 77 10 80 	movl   $0x80107754,(%esp)
80106d12:	e8 49 96 ff ff       	call   80100360 <panic>
80106d17:	89 f6                	mov    %esi,%esi
80106d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d20 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106d20:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d21:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106d23:	89 e5                	mov    %esp,%ebp
80106d25:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d28:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d2b:	8b 45 08             	mov    0x8(%ebp),%eax
80106d2e:	e8 7d f7 ff ff       	call   801064b0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106d33:	8b 00                	mov    (%eax),%eax
80106d35:	89 c2                	mov    %eax,%edx
80106d37:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106d3a:	83 fa 05             	cmp    $0x5,%edx
80106d3d:	75 11                	jne    80106d50 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106d3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d44:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106d49:	c9                   	leave  
80106d4a:	c3                   	ret    
80106d4b:	90                   	nop
80106d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106d50:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106d52:	c9                   	leave  
80106d53:	c3                   	ret    
80106d54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d60 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106d60:	55                   	push   %ebp
80106d61:	89 e5                	mov    %esp,%ebp
80106d63:	57                   	push   %edi
80106d64:	56                   	push   %esi
80106d65:	53                   	push   %ebx
80106d66:	83 ec 1c             	sub    $0x1c,%esp
80106d69:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106d6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106d72:	85 db                	test   %ebx,%ebx
80106d74:	75 3a                	jne    80106db0 <copyout+0x50>
80106d76:	eb 68                	jmp    80106de0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106d78:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d7b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106d7d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106d81:	29 ca                	sub    %ecx,%edx
80106d83:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106d89:	39 da                	cmp    %ebx,%edx
80106d8b:	0f 47 d3             	cmova  %ebx,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106d8e:	29 f1                	sub    %esi,%ecx
80106d90:	01 c8                	add    %ecx,%eax
80106d92:	89 54 24 08          	mov    %edx,0x8(%esp)
80106d96:	89 04 24             	mov    %eax,(%esp)
80106d99:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106d9c:	e8 cf d6 ff ff       	call   80104470 <memmove>
    len -= n;
    buf += n;
80106da1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106da4:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106daa:	01 d7                	add    %edx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106dac:	29 d3                	sub    %edx,%ebx
80106dae:	74 30                	je     80106de0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
80106db0:	8b 45 08             	mov    0x8(%ebp),%eax
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106db3:	89 ce                	mov    %ecx,%esi
80106db5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106dbb:	89 74 24 04          	mov    %esi,0x4(%esp)
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106dbf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106dc2:	89 04 24             	mov    %eax,(%esp)
80106dc5:	e8 56 ff ff ff       	call   80106d20 <uva2ka>
    if(pa0 == 0)
80106dca:	85 c0                	test   %eax,%eax
80106dcc:	75 aa                	jne    80106d78 <copyout+0x18>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106dce:	83 c4 1c             	add    $0x1c,%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106dd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106dd6:	5b                   	pop    %ebx
80106dd7:	5e                   	pop    %esi
80106dd8:	5f                   	pop    %edi
80106dd9:	5d                   	pop    %ebp
80106dda:	c3                   	ret    
80106ddb:	90                   	nop
80106ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106de0:	83 c4 1c             	add    $0x1c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106de3:	31 c0                	xor    %eax,%eax
}
80106de5:	5b                   	pop    %ebx
80106de6:	5e                   	pop    %esi
80106de7:	5f                   	pop    %edi
80106de8:	5d                   	pop    %ebp
80106de9:	c3                   	ret    
