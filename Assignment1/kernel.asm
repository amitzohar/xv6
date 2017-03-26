
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
8010002d:	b8 90 2e 10 80       	mov    $0x80102e90,%eax
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
8010004c:	c7 44 24 04 40 6d 10 	movl   $0x80106d40,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010005b:	e8 10 41 00 00       	call   80104170 <initlock>

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
80100094:	c7 44 24 04 47 6d 10 	movl   $0x80106d47,0x4(%esp)
8010009b:	80 
8010009c:	e8 bf 3f 00 00       	call   80104060 <initsleeplock>
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
801000e6:	e8 05 41 00 00       	call   801041f0 <acquire>

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
80100161:	e8 ba 41 00 00       	call   80104320 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 2f 3f 00 00       	call   801040a0 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!(b->flags & B_VALID)) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 d2 1f 00 00       	call   80102150 <iderw>
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
80100188:	c7 04 24 4e 6d 10 80 	movl   $0x80106d4e,(%esp)
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
801001b0:	e8 8b 3f 00 00       	call   80104140 <holdingsleep>
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
801001c4:	e9 87 1f 00 00       	jmp    80102150 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	c7 04 24 5f 6d 10 80 	movl   $0x80106d5f,(%esp)
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
801001f1:	e8 4a 3f 00 00       	call   80104140 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 fe 3e 00 00       	call   80104100 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100209:	e8 e2 3f 00 00       	call   801041f0 <acquire>
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
80100250:	e9 cb 40 00 00       	jmp    80104320 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100255:	c7 04 24 66 6d 10 80 	movl   $0x80106d66,(%esp)
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
80100282:	e8 39 15 00 00       	call   801017c0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 5d 3f 00 00       	call   801041f0 <acquire>
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
801002c4:	e8 47 3a 00 00       	call   80103d10 <sleep>

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
80100312:	e8 09 40 00 00       	call   80104320 <release>
  ilock(ip);
80100317:	89 3c 24             	mov    %edi,(%esp)
8010031a:	e8 d1 13 00 00       	call   801016f0 <ilock>
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
8010032f:	e8 ec 3f 00 00       	call   80104320 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 b4 13 00 00       	call   801016f0 <ilock>
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
80100382:	c7 04 24 6d 6d 10 80 	movl   $0x80106d6d,(%esp)
80100389:	89 44 24 04          	mov    %eax,0x4(%esp)
8010038d:	e8 be 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
80100392:	8b 45 08             	mov    0x8(%ebp),%eax
80100395:	89 04 24             	mov    %eax,(%esp)
80100398:	e8 b3 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
8010039d:	c7 04 24 66 72 10 80 	movl   $0x80107266,(%esp)
801003a4:	e8 a7 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a9:	8d 45 08             	lea    0x8(%ebp),%eax
801003ac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003b0:	89 04 24             	mov    %eax,(%esp)
801003b3:	e8 d8 3d 00 00       	call   80104190 <getcallerpcs>
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 89 6d 10 80 	movl   $0x80106d89,(%esp)
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
80100409:	e8 62 54 00 00       	call   80105870 <uartputc>
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
801004b9:	e8 b2 53 00 00       	call   80105870 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 a6 53 00 00       	call   80105870 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 9a 53 00 00       	call   80105870 <uartputc>
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
801004fc:	e8 0f 3f 00 00       	call   80104410 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 52 3e 00 00       	call   80104370 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010052a:	c7 04 24 8d 6d 10 80 	movl   $0x80106d8d,(%esp)
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
80100599:	0f b6 92 b8 6d 10 80 	movzbl -0x7fef9248(%edx),%edx
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
80100602:	e8 b9 11 00 00       	call   801017c0 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 dd 3b 00 00       	call   801041f0 <acquire>
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
80100636:	e8 e5 3c 00 00       	call   80104320 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 aa 10 00 00       	call   801016f0 <ilock>

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
801006f3:	e8 28 3c 00 00       	call   80104320 <release>
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
80100760:	b8 a0 6d 10 80       	mov    $0x80106da0,%eax
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
80100797:	e8 54 3a 00 00       	call   801041f0 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007a1:	c7 04 24 a7 6d 10 80 	movl   $0x80106da7,(%esp)
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
801007c5:	e8 26 3a 00 00       	call   801041f0 <acquire>
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
80100827:	e8 f4 3a 00 00       	call   80104320 <release>
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
801008b2:	e8 f9 35 00 00       	call   80103eb0 <wakeup>
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
80100927:	e9 64 36 00 00       	jmp    80103f90 <procdump>
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
80100956:	c7 44 24 04 b0 6d 10 	movl   $0x80106db0,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 06 38 00 00       	call   80104170 <initlock>

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
8010098f:	e8 9c 28 00 00       	call   80103230 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100994:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010099b:	00 
8010099c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801009a3:	e8 38 19 00 00       	call   801022e0 <ioapicenable>
}
801009a8:	c9                   	leave  
801009a9:	c3                   	ret    
801009aa:	66 90                	xchg   %ax,%ax
801009ac:	66 90                	xchg   %ax,%ax
801009ae:	66 90                	xchg   %ax,%ax

801009b0 <pseudo_main>:
#include "x86.h"
#include "elf.h"

void 
pseudo_main(int (*entry)(int, char**), int argc, char **argv) 
{
801009b0:	55                   	push   %ebp
801009b1:	89 e5                	mov    %esp,%ebp
}
801009b3:	5d                   	pop    %ebp
801009b4:	c3                   	ret    
801009b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009c0 <exec>:

int
exec(char *path, char **argv)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	57                   	push   %edi
801009c4:	56                   	push   %esi
801009c5:	53                   	push   %ebx
801009c6:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
801009cc:	e8 ef 21 00 00       	call   80102bc0 <begin_op>

  if((ip = namei(path)) == 0){
801009d1:	8b 45 08             	mov    0x8(%ebp),%eax
801009d4:	89 04 24             	mov    %eax,(%esp)
801009d7:	e8 44 15 00 00       	call   80101f20 <namei>
801009dc:	85 c0                	test   %eax,%eax
801009de:	89 c3                	mov    %eax,%ebx
801009e0:	74 37                	je     80100a19 <exec+0x59>
    end_op();
    return -1;
  }
  ilock(ip);
801009e2:	89 04 24             	mov    %eax,(%esp)
801009e5:	e8 06 0d 00 00       	call   801016f0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009ea:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009f0:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009f7:	00 
801009f8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ff:	00 
80100a00:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a04:	89 1c 24             	mov    %ebx,(%esp)
80100a07:	e8 74 0f 00 00       	call   80101980 <readi>
80100a0c:	83 f8 34             	cmp    $0x34,%eax
80100a0f:	74 1f                	je     80100a30 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a11:	89 1c 24             	mov    %ebx,(%esp)
80100a14:	e8 17 0f 00 00       	call   80101930 <iunlockput>
    end_op();
80100a19:	e8 12 22 00 00       	call   80102c30 <end_op>
  }
  return -1;
80100a1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a23:	81 c4 1c 01 00 00    	add    $0x11c,%esp
80100a29:	5b                   	pop    %ebx
80100a2a:	5e                   	pop    %esi
80100a2b:	5f                   	pop    %edi
80100a2c:	5d                   	pop    %ebp
80100a2d:	c3                   	ret    
80100a2e:	66 90                	xchg   %ax,%ax
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a30:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a37:	45 4c 46 
80100a3a:	75 d5                	jne    80100a11 <exec+0x51>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a3c:	e8 af 5c 00 00       	call   801066f0 <setupkvm>
80100a41:	85 c0                	test   %eax,%eax
80100a43:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a49:	74 c6                	je     80100a11 <exec+0x51>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a4b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a52:	00 
80100a53:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
80100a59:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100a60:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a63:	0f 84 da 00 00 00    	je     80100b43 <exec+0x183>
80100a69:	31 ff                	xor    %edi,%edi
80100a6b:	eb 18                	jmp    80100a85 <exec+0xc5>
80100a6d:	8d 76 00             	lea    0x0(%esi),%esi
80100a70:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a77:	83 c7 01             	add    $0x1,%edi
80100a7a:	83 c6 20             	add    $0x20,%esi
80100a7d:	39 f8                	cmp    %edi,%eax
80100a7f:	0f 8e be 00 00 00    	jle    80100b43 <exec+0x183>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a85:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a8b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a92:	00 
80100a93:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a97:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a9b:	89 1c 24             	mov    %ebx,(%esp)
80100a9e:	e8 dd 0e 00 00       	call   80101980 <readi>
80100aa3:	83 f8 20             	cmp    $0x20,%eax
80100aa6:	0f 85 84 00 00 00    	jne    80100b30 <exec+0x170>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100aac:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ab3:	75 bb                	jne    80100a70 <exec+0xb0>
      continue;
    if(ph.memsz < ph.filesz)
80100ab5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100abb:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ac1:	72 6d                	jb     80100b30 <exec+0x170>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ac3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ac9:	72 65                	jb     80100b30 <exec+0x170>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100acb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100acf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ad5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ad9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100adf:	89 04 24             	mov    %eax,(%esp)
80100ae2:	e8 d9 5e 00 00       	call   801069c0 <allocuvm>
80100ae7:	85 c0                	test   %eax,%eax
80100ae9:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aef:	74 3f                	je     80100b30 <exec+0x170>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100af1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100af7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100afc:	75 32                	jne    80100b30 <exec+0x170>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100afe:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100b04:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b08:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b0e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b12:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b16:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b1c:	89 04 24             	mov    %eax,(%esp)
80100b1f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b23:	e8 d8 5d 00 00       	call   80106900 <loaduvm>
80100b28:	85 c0                	test   %eax,%eax
80100b2a:	0f 89 40 ff ff ff    	jns    80100a70 <exec+0xb0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b30:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b36:	89 04 24             	mov    %eax,(%esp)
80100b39:	e8 92 5f 00 00       	call   80106ad0 <freevm>
80100b3e:	e9 ce fe ff ff       	jmp    80100a11 <exec+0x51>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b43:	89 1c 24             	mov    %ebx,(%esp)
80100b46:	e8 e5 0d 00 00       	call   80101930 <iunlockput>
80100b4b:	90                   	nop
80100b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b50:	e8 db 20 00 00       	call   80102c30 <end_op>

  pointer_pseudo_main = sz;  

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b55:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b5b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b60:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 3*PGSIZE)) == 0)
80100b65:	8d 90 00 30 00 00    	lea    0x3000(%eax),%edx
80100b6b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b6f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b75:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b79:	89 04 24             	mov    %eax,(%esp)
80100b7c:	e8 3f 5e 00 00       	call   801069c0 <allocuvm>
80100b81:	85 c0                	test   %eax,%eax
80100b83:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b89:	75 18                	jne    80100ba3 <exec+0x1e3>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b8b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b91:	89 04 24             	mov    %eax,(%esp)
80100b94:	e8 37 5f 00 00       	call   80106ad0 <freevm>
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100b99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b9e:	e9 80 fe ff ff       	jmp    80100a23 <exec+0x63>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 3*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ba3:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100ba9:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100baf:	89 d8                	mov    %ebx,%eax
80100bb1:	2d 00 20 00 00       	sub    $0x2000,%eax
80100bb6:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bba:	89 3c 24             	mov    %edi,(%esp)
80100bbd:	e8 8e 5f 00 00       	call   80106b50 <clearpteu>
  
  if (copyout(pgdir, pointer_pseudo_main, pseudo_main, (uint)exec - (uint)pseudo_main) < 0)
80100bc2:	b8 c0 09 10 80       	mov    $0x801009c0,%eax
80100bc7:	2d b0 09 10 80       	sub    $0x801009b0,%eax
80100bcc:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100bd0:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bd6:	c7 44 24 08 b0 09 10 	movl   $0x801009b0,0x8(%esp)
80100bdd:	80 
80100bde:	89 3c 24             	mov    %edi,(%esp)
80100be1:	89 44 24 04          	mov    %eax,0x4(%esp)
80100be5:	e8 c6 60 00 00       	call   80106cb0 <copyout>
80100bea:	85 c0                	test   %eax,%eax
80100bec:	78 9d                	js     80100b8b <exec+0x1cb>
    goto bad;

  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bee:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bf1:	8b 00                	mov    (%eax),%eax
80100bf3:	85 c0                	test   %eax,%eax
80100bf5:	0f 84 66 01 00 00    	je     80100d61 <exec+0x3a1>
80100bfb:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100bfe:	31 f6                	xor    %esi,%esi
80100c00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100c03:	89 f2                	mov    %esi,%edx
80100c05:	89 fe                	mov    %edi,%esi
80100c07:	89 d7                	mov    %edx,%edi
80100c09:	83 c1 04             	add    $0x4,%ecx
80100c0c:	eb 0e                	jmp    80100c1c <exec+0x25c>
80100c0e:	66 90                	xchg   %ax,%ax
80100c10:	83 c1 04             	add    $0x4,%ecx
    if(argc >= MAXARG)
80100c13:	83 ff 20             	cmp    $0x20,%edi
80100c16:	0f 84 6f ff ff ff    	je     80100b8b <exec+0x1cb>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c1c:	89 04 24             	mov    %eax,(%esp)
80100c1f:	89 8d f0 fe ff ff    	mov    %ecx,-0x110(%ebp)
80100c25:	e8 66 39 00 00       	call   80104590 <strlen>
80100c2a:	f7 d0                	not    %eax
80100c2c:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c2e:	8b 06                	mov    (%esi),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c30:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c33:	89 04 24             	mov    %eax,(%esp)
80100c36:	e8 55 39 00 00       	call   80104590 <strlen>
80100c3b:	83 c0 01             	add    $0x1,%eax
80100c3e:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c42:	8b 06                	mov    (%esi),%eax
80100c44:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c48:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c4c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c52:	89 04 24             	mov    %eax,(%esp)
80100c55:	e8 56 60 00 00       	call   80106cb0 <copyout>
80100c5a:	85 c0                	test   %eax,%eax
80100c5c:	0f 88 29 ff ff ff    	js     80100b8b <exec+0x1cb>
    goto bad;

  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c62:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c68:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c6e:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;

  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c75:	83 c7 01             	add    $0x1,%edi
80100c78:	8b 01                	mov    (%ecx),%eax
80100c7a:	89 ce                	mov    %ecx,%esi
80100c7c:	85 c0                	test   %eax,%eax
80100c7e:	75 90                	jne    80100c10 <exec+0x250>
80100c80:	89 fe                	mov    %edi,%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c82:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100c89:	89 d9                	mov    %ebx,%ecx
80100c8b:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100c8d:	83 c0 0c             	add    $0xc,%eax
80100c90:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c92:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c96:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c9c:	89 54 24 08          	mov    %edx,0x8(%esp)
80100ca0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100ca4:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100cab:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100caf:	89 04 24             	mov    %eax,(%esp)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100cb2:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100cb9:	ff ff ff 
  ustack[1] = argc;
80100cbc:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc2:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc8:	e8 e3 5f 00 00       	call   80106cb0 <copyout>
80100ccd:	85 c0                	test   %eax,%eax
80100ccf:	0f 88 b6 fe ff ff    	js     80100b8b <exec+0x1cb>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cd5:	8b 45 08             	mov    0x8(%ebp),%eax
80100cd8:	0f b6 10             	movzbl (%eax),%edx
80100cdb:	84 d2                	test   %dl,%dl
80100cdd:	74 19                	je     80100cf8 <exec+0x338>
80100cdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100ce2:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100ce5:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ce8:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100ceb:	0f 44 c8             	cmove  %eax,%ecx
80100cee:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cf1:	84 d2                	test   %dl,%dl
80100cf3:	75 f0                	jne    80100ce5 <exec+0x325>
80100cf5:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100cf8:	8b 45 08             	mov    0x8(%ebp),%eax
80100cfb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100d02:	00 
80100d03:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d07:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100d0d:	83 c0 6c             	add    $0x6c,%eax
80100d10:	89 04 24             	mov    %eax,(%esp)
80100d13:	e8 38 38 00 00       	call   80104550 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100d18:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100d1e:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100d24:	8b 70 04             	mov    0x4(%eax),%esi
  proc->pgdir = pgdir;
80100d27:	89 48 04             	mov    %ecx,0x4(%eax)
  proc->sz = sz;
80100d2a:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100d30:	89 08                	mov    %ecx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100d32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100d38:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100d3e:	8b 50 18             	mov    0x18(%eax),%edx
80100d41:	89 4a 38             	mov    %ecx,0x38(%edx)
  proc->tf->esp = sp;
80100d44:	8b 50 18             	mov    0x18(%eax),%edx
80100d47:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(proc);
80100d4a:	89 04 24             	mov    %eax,(%esp)
80100d4d:	e8 5e 5a 00 00       	call   801067b0 <switchuvm>
  freevm(oldpgdir);
80100d52:	89 34 24             	mov    %esi,(%esp)
80100d55:	e8 76 5d 00 00       	call   80106ad0 <freevm>
  return 0;
80100d5a:	31 c0                	xor    %eax,%eax
80100d5c:	e9 c2 fc ff ff       	jmp    80100a23 <exec+0x63>
    goto bad;

  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d61:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100d67:	31 f6                	xor    %esi,%esi
80100d69:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100d6f:	e9 0e ff ff ff       	jmp    80100c82 <exec+0x2c2>
80100d74:	66 90                	xchg   %ax,%ax
80100d76:	66 90                	xchg   %ax,%ax
80100d78:	66 90                	xchg   %ax,%ax
80100d7a:	66 90                	xchg   %ax,%ax
80100d7c:	66 90                	xchg   %ax,%ax
80100d7e:	66 90                	xchg   %ax,%ax

80100d80 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d86:	c7 44 24 04 c9 6d 10 	movl   $0x80106dc9,0x4(%esp)
80100d8d:	80 
80100d8e:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100d95:	e8 d6 33 00 00       	call   80104170 <initlock>
}
80100d9a:	c9                   	leave  
80100d9b:	c3                   	ret    
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100da0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100da0:	55                   	push   %ebp
80100da1:	89 e5                	mov    %esp,%ebp
80100da3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da4:	bb 14 00 11 80       	mov    $0x80110014,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100da9:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100dac:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100db3:	e8 38 34 00 00       	call   801041f0 <acquire>
80100db8:	eb 11                	jmp    80100dcb <filealloc+0x2b>
80100dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dc0:	83 c3 18             	add    $0x18,%ebx
80100dc3:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80100dc9:	74 25                	je     80100df0 <filealloc+0x50>
    if(f->ref == 0){
80100dcb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dce:	85 c0                	test   %eax,%eax
80100dd0:	75 ee                	jne    80100dc0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100dd2:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100dd9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100de0:	e8 3b 35 00 00       	call   80104320 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100de5:	83 c4 14             	add    $0x14,%esp
  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
80100de8:	89 d8                	mov    %ebx,%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dea:	5b                   	pop    %ebx
80100deb:	5d                   	pop    %ebp
80100dec:	c3                   	ret    
80100ded:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100df0:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100df7:	e8 24 35 00 00       	call   80104320 <release>
  return 0;
}
80100dfc:	83 c4 14             	add    $0x14,%esp
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
80100dff:	31 c0                	xor    %eax,%eax
}
80100e01:	5b                   	pop    %ebx
80100e02:	5d                   	pop    %ebp
80100e03:	c3                   	ret    
80100e04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100e10 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	53                   	push   %ebx
80100e14:	83 ec 14             	sub    $0x14,%esp
80100e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e1a:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100e21:	e8 ca 33 00 00       	call   801041f0 <acquire>
  if(f->ref < 1)
80100e26:	8b 43 04             	mov    0x4(%ebx),%eax
80100e29:	85 c0                	test   %eax,%eax
80100e2b:	7e 1a                	jle    80100e47 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100e2d:	83 c0 01             	add    $0x1,%eax
80100e30:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e33:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100e3a:	e8 e1 34 00 00       	call   80104320 <release>
  return f;
}
80100e3f:	83 c4 14             	add    $0x14,%esp
80100e42:	89 d8                	mov    %ebx,%eax
80100e44:	5b                   	pop    %ebx
80100e45:	5d                   	pop    %ebp
80100e46:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e47:	c7 04 24 d0 6d 10 80 	movl   $0x80106dd0,(%esp)
80100e4e:	e8 0d f5 ff ff       	call   80100360 <panic>
80100e53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e60 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	57                   	push   %edi
80100e64:	56                   	push   %esi
80100e65:	53                   	push   %ebx
80100e66:	83 ec 1c             	sub    $0x1c,%esp
80100e69:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e6c:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100e73:	e8 78 33 00 00       	call   801041f0 <acquire>
  if(f->ref < 1)
80100e78:	8b 57 04             	mov    0x4(%edi),%edx
80100e7b:	85 d2                	test   %edx,%edx
80100e7d:	0f 8e 89 00 00 00    	jle    80100f0c <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e83:	83 ea 01             	sub    $0x1,%edx
80100e86:	85 d2                	test   %edx,%edx
80100e88:	89 57 04             	mov    %edx,0x4(%edi)
80100e8b:	74 13                	je     80100ea0 <fileclose+0x40>
    release(&ftable.lock);
80100e8d:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e94:	83 c4 1c             	add    $0x1c,%esp
80100e97:	5b                   	pop    %ebx
80100e98:	5e                   	pop    %esi
80100e99:	5f                   	pop    %edi
80100e9a:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e9b:	e9 80 34 00 00       	jmp    80104320 <release>
    return;
  }
  ff = *f;
80100ea0:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100ea4:	8b 37                	mov    (%edi),%esi
80100ea6:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
80100ea9:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100eaf:	88 45 e7             	mov    %al,-0x19(%ebp)
80100eb2:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100eb5:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ebc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ebf:	e8 5c 34 00 00       	call   80104320 <release>

  if(ff.type == FD_PIPE)
80100ec4:	83 fe 01             	cmp    $0x1,%esi
80100ec7:	74 0f                	je     80100ed8 <fileclose+0x78>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ec9:	83 fe 02             	cmp    $0x2,%esi
80100ecc:	74 22                	je     80100ef0 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ece:	83 c4 1c             	add    $0x1c,%esp
80100ed1:	5b                   	pop    %ebx
80100ed2:	5e                   	pop    %esi
80100ed3:	5f                   	pop    %edi
80100ed4:	5d                   	pop    %ebp
80100ed5:	c3                   	ret    
80100ed6:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100ed8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100edc:	89 1c 24             	mov    %ebx,(%esp)
80100edf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100ee3:	e8 f8 24 00 00       	call   801033e0 <pipeclose>
80100ee8:	eb e4                	jmp    80100ece <fileclose+0x6e>
80100eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ef0:	e8 cb 1c 00 00       	call   80102bc0 <begin_op>
    iput(ff.ip);
80100ef5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ef8:	89 04 24             	mov    %eax,(%esp)
80100efb:	e8 00 09 00 00       	call   80101800 <iput>
    end_op();
  }
}
80100f00:	83 c4 1c             	add    $0x1c,%esp
80100f03:	5b                   	pop    %ebx
80100f04:	5e                   	pop    %esi
80100f05:	5f                   	pop    %edi
80100f06:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100f07:	e9 24 1d 00 00       	jmp    80102c30 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100f0c:	c7 04 24 d8 6d 10 80 	movl   $0x80106dd8,(%esp)
80100f13:	e8 48 f4 ff ff       	call   80100360 <panic>
80100f18:	90                   	nop
80100f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f20 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	53                   	push   %ebx
80100f24:	83 ec 14             	sub    $0x14,%esp
80100f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f2a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f2d:	75 31                	jne    80100f60 <filestat+0x40>
    ilock(f->ip);
80100f2f:	8b 43 10             	mov    0x10(%ebx),%eax
80100f32:	89 04 24             	mov    %eax,(%esp)
80100f35:	e8 b6 07 00 00       	call   801016f0 <ilock>
    stati(f->ip, st);
80100f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f3d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f41:	8b 43 10             	mov    0x10(%ebx),%eax
80100f44:	89 04 24             	mov    %eax,(%esp)
80100f47:	e8 04 0a 00 00       	call   80101950 <stati>
    iunlock(f->ip);
80100f4c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f4f:	89 04 24             	mov    %eax,(%esp)
80100f52:	e8 69 08 00 00       	call   801017c0 <iunlock>
    return 0;
  }
  return -1;
}
80100f57:	83 c4 14             	add    $0x14,%esp
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
80100f5a:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f5c:	5b                   	pop    %ebx
80100f5d:	5d                   	pop    %ebp
80100f5e:	c3                   	ret    
80100f5f:	90                   	nop
80100f60:	83 c4 14             	add    $0x14,%esp
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f68:	5b                   	pop    %ebx
80100f69:	5d                   	pop    %ebp
80100f6a:	c3                   	ret    
80100f6b:	90                   	nop
80100f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f70 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f70:	55                   	push   %ebp
80100f71:	89 e5                	mov    %esp,%ebp
80100f73:	57                   	push   %edi
80100f74:	56                   	push   %esi
80100f75:	53                   	push   %ebx
80100f76:	83 ec 1c             	sub    $0x1c,%esp
80100f79:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f7f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f82:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f86:	74 68                	je     80100ff0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f88:	8b 03                	mov    (%ebx),%eax
80100f8a:	83 f8 01             	cmp    $0x1,%eax
80100f8d:	74 49                	je     80100fd8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f8f:	83 f8 02             	cmp    $0x2,%eax
80100f92:	75 63                	jne    80100ff7 <fileread+0x87>
    ilock(f->ip);
80100f94:	8b 43 10             	mov    0x10(%ebx),%eax
80100f97:	89 04 24             	mov    %eax,(%esp)
80100f9a:	e8 51 07 00 00       	call   801016f0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f9f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100fa3:	8b 43 14             	mov    0x14(%ebx),%eax
80100fa6:	89 74 24 04          	mov    %esi,0x4(%esp)
80100faa:	89 44 24 08          	mov    %eax,0x8(%esp)
80100fae:	8b 43 10             	mov    0x10(%ebx),%eax
80100fb1:	89 04 24             	mov    %eax,(%esp)
80100fb4:	e8 c7 09 00 00       	call   80101980 <readi>
80100fb9:	85 c0                	test   %eax,%eax
80100fbb:	89 c6                	mov    %eax,%esi
80100fbd:	7e 03                	jle    80100fc2 <fileread+0x52>
      f->off += r;
80100fbf:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fc2:	8b 43 10             	mov    0x10(%ebx),%eax
80100fc5:	89 04 24             	mov    %eax,(%esp)
80100fc8:	e8 f3 07 00 00       	call   801017c0 <iunlock>
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fcd:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fcf:	83 c4 1c             	add    $0x1c,%esp
80100fd2:	5b                   	pop    %ebx
80100fd3:	5e                   	pop    %esi
80100fd4:	5f                   	pop    %edi
80100fd5:	5d                   	pop    %ebp
80100fd6:	c3                   	ret    
80100fd7:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fd8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fdb:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fde:	83 c4 1c             	add    $0x1c,%esp
80100fe1:	5b                   	pop    %ebx
80100fe2:	5e                   	pop    %esi
80100fe3:	5f                   	pop    %edi
80100fe4:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fe5:	e9 a6 25 00 00       	jmp    80103590 <piperead>
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ff5:	eb d8                	jmp    80100fcf <fileread+0x5f>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100ff7:	c7 04 24 e2 6d 10 80 	movl   $0x80106de2,(%esp)
80100ffe:	e8 5d f3 ff ff       	call   80100360 <panic>
80101003:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101010 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	57                   	push   %edi
80101014:	56                   	push   %esi
80101015:	53                   	push   %ebx
80101016:	83 ec 2c             	sub    $0x2c,%esp
80101019:	8b 45 0c             	mov    0xc(%ebp),%eax
8010101c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010101f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101022:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101025:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101029:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
8010102c:	0f 84 ae 00 00 00    	je     801010e0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101032:	8b 07                	mov    (%edi),%eax
80101034:	83 f8 01             	cmp    $0x1,%eax
80101037:	0f 84 c2 00 00 00    	je     801010ff <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103d:	83 f8 02             	cmp    $0x2,%eax
80101040:	0f 85 d7 00 00 00    	jne    8010111d <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101046:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101049:	31 db                	xor    %ebx,%ebx
8010104b:	85 c0                	test   %eax,%eax
8010104d:	7f 31                	jg     80101080 <filewrite+0x70>
8010104f:	e9 9c 00 00 00       	jmp    801010f0 <filewrite+0xe0>
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101058:	8b 4f 10             	mov    0x10(%edi),%ecx
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
8010105b:	01 47 14             	add    %eax,0x14(%edi)
8010105e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101061:	89 0c 24             	mov    %ecx,(%esp)
80101064:	e8 57 07 00 00       	call   801017c0 <iunlock>
      end_op();
80101069:	e8 c2 1b 00 00       	call   80102c30 <end_op>
8010106e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101071:	39 f0                	cmp    %esi,%eax
80101073:	0f 85 98 00 00 00    	jne    80101111 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101079:	01 c3                	add    %eax,%ebx
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010107b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010107e:	7e 70                	jle    801010f0 <filewrite+0xe0>
      int n1 = n - i;
80101080:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101083:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101088:	29 de                	sub    %ebx,%esi
8010108a:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
80101090:	0f 4f f0             	cmovg  %eax,%esi
      if(n1 > max)
        n1 = max;

      begin_op();
80101093:	e8 28 1b 00 00       	call   80102bc0 <begin_op>
      ilock(f->ip);
80101098:	8b 47 10             	mov    0x10(%edi),%eax
8010109b:	89 04 24             	mov    %eax,(%esp)
8010109e:	e8 4d 06 00 00       	call   801016f0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010a3:	89 74 24 0c          	mov    %esi,0xc(%esp)
801010a7:	8b 47 14             	mov    0x14(%edi),%eax
801010aa:	89 44 24 08          	mov    %eax,0x8(%esp)
801010ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010b1:	01 d8                	add    %ebx,%eax
801010b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801010b7:	8b 47 10             	mov    0x10(%edi),%eax
801010ba:	89 04 24             	mov    %eax,(%esp)
801010bd:	e8 be 09 00 00       	call   80101a80 <writei>
801010c2:	85 c0                	test   %eax,%eax
801010c4:	7f 92                	jg     80101058 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
801010c6:	8b 4f 10             	mov    0x10(%edi),%ecx
801010c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010cc:	89 0c 24             	mov    %ecx,(%esp)
801010cf:	e8 ec 06 00 00       	call   801017c0 <iunlock>
      end_op();
801010d4:	e8 57 1b 00 00       	call   80102c30 <end_op>

      if(r < 0)
801010d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010dc:	85 c0                	test   %eax,%eax
801010de:	74 91                	je     80101071 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010e0:	83 c4 2c             	add    $0x2c,%esp
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
801010e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010e8:	5b                   	pop    %ebx
801010e9:	5e                   	pop    %esi
801010ea:	5f                   	pop    %edi
801010eb:	5d                   	pop    %ebp
801010ec:	c3                   	ret    
801010ed:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010f0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010f3:	89 d8                	mov    %ebx,%eax
801010f5:	75 e9                	jne    801010e0 <filewrite+0xd0>
  }
  panic("filewrite");
}
801010f7:	83 c4 2c             	add    $0x2c,%esp
801010fa:	5b                   	pop    %ebx
801010fb:	5e                   	pop    %esi
801010fc:	5f                   	pop    %edi
801010fd:	5d                   	pop    %ebp
801010fe:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010ff:	8b 47 0c             	mov    0xc(%edi),%eax
80101102:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101105:	83 c4 2c             	add    $0x2c,%esp
80101108:	5b                   	pop    %ebx
80101109:	5e                   	pop    %esi
8010110a:	5f                   	pop    %edi
8010110b:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010110c:	e9 5f 23 00 00       	jmp    80103470 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
80101111:	c7 04 24 eb 6d 10 80 	movl   $0x80106deb,(%esp)
80101118:	e8 43 f2 ff ff       	call   80100360 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
8010111d:	c7 04 24 f1 6d 10 80 	movl   $0x80106df1,(%esp)
80101124:	e8 37 f2 ff ff       	call   80100360 <panic>
80101129:	66 90                	xchg   %ax,%ax
8010112b:	66 90                	xchg   %ax,%ax
8010112d:	66 90                	xchg   %ax,%ax
8010112f:	90                   	nop

80101130 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101130:	55                   	push   %ebp
80101131:	89 e5                	mov    %esp,%ebp
80101133:	57                   	push   %edi
80101134:	56                   	push   %esi
80101135:	53                   	push   %ebx
80101136:	83 ec 2c             	sub    $0x2c,%esp
80101139:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010113c:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101141:	85 c0                	test   %eax,%eax
80101143:	0f 84 8c 00 00 00    	je     801011d5 <balloc+0xa5>
80101149:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101150:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101153:	89 f0                	mov    %esi,%eax
80101155:	c1 f8 0c             	sar    $0xc,%eax
80101158:	03 05 f8 09 11 80    	add    0x801109f8,%eax
8010115e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101162:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101165:	89 04 24             	mov    %eax,(%esp)
80101168:	e8 63 ef ff ff       	call   801000d0 <bread>
8010116d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101170:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101175:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101178:	31 c0                	xor    %eax,%eax
8010117a:	eb 33                	jmp    801011af <balloc+0x7f>
8010117c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101180:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101183:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101185:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101187:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010118a:	83 e1 07             	and    $0x7,%ecx
8010118d:	bf 01 00 00 00       	mov    $0x1,%edi
80101192:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101194:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101199:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010119b:	0f b6 fb             	movzbl %bl,%edi
8010119e:	85 cf                	test   %ecx,%edi
801011a0:	74 46                	je     801011e8 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011a2:	83 c0 01             	add    $0x1,%eax
801011a5:	83 c6 01             	add    $0x1,%esi
801011a8:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011ad:	74 05                	je     801011b4 <balloc+0x84>
801011af:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801011b2:	72 cc                	jb     80101180 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011b7:	89 04 24             	mov    %eax,(%esp)
801011ba:	e8 21 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011bf:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011c9:	3b 05 e0 09 11 80    	cmp    0x801109e0,%eax
801011cf:	0f 82 7b ff ff ff    	jb     80101150 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801011d5:	c7 04 24 fb 6d 10 80 	movl   $0x80106dfb,(%esp)
801011dc:	e8 7f f1 ff ff       	call   80100360 <panic>
801011e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011e8:	09 d9                	or     %ebx,%ecx
801011ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011ed:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011f1:	89 1c 24             	mov    %ebx,(%esp)
801011f4:	e8 67 1b 00 00       	call   80102d60 <log_write>
        brelse(bp);
801011f9:	89 1c 24             	mov    %ebx,(%esp)
801011fc:	e8 df ef ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
80101201:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101204:	89 74 24 04          	mov    %esi,0x4(%esp)
80101208:	89 04 24             	mov    %eax,(%esp)
8010120b:	e8 c0 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101210:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101217:	00 
80101218:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010121f:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
80101220:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101222:	8d 40 5c             	lea    0x5c(%eax),%eax
80101225:	89 04 24             	mov    %eax,(%esp)
80101228:	e8 43 31 00 00       	call   80104370 <memset>
  log_write(bp);
8010122d:	89 1c 24             	mov    %ebx,(%esp)
80101230:	e8 2b 1b 00 00       	call   80102d60 <log_write>
  brelse(bp);
80101235:	89 1c 24             	mov    %ebx,(%esp)
80101238:	e8 a3 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010123d:	83 c4 2c             	add    $0x2c,%esp
80101240:	89 f0                	mov    %esi,%eax
80101242:	5b                   	pop    %ebx
80101243:	5e                   	pop    %esi
80101244:	5f                   	pop    %edi
80101245:	5d                   	pop    %ebp
80101246:	c3                   	ret    
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101250 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	89 c7                	mov    %eax,%edi
80101256:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101257:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101259:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010125a:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010125f:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101262:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101269:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010126c:	e8 7f 2f 00 00       	call   801041f0 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101271:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101274:	eb 14                	jmp    8010128a <iget+0x3a>
80101276:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101278:	85 f6                	test   %esi,%esi
8010127a:	74 3c                	je     801012b8 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010127c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101282:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101288:	74 46                	je     801012d0 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010128a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010128d:	85 c9                	test   %ecx,%ecx
8010128f:	7e e7                	jle    80101278 <iget+0x28>
80101291:	39 3b                	cmp    %edi,(%ebx)
80101293:	75 e3                	jne    80101278 <iget+0x28>
80101295:	39 53 04             	cmp    %edx,0x4(%ebx)
80101298:	75 de                	jne    80101278 <iget+0x28>
      ip->ref++;
8010129a:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
8010129d:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010129f:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012a6:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012a9:	e8 72 30 00 00       	call   80104320 <release>
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
801012ae:	83 c4 1c             	add    $0x1c,%esp
801012b1:	89 f0                	mov    %esi,%eax
801012b3:	5b                   	pop    %ebx
801012b4:	5e                   	pop    %esi
801012b5:	5f                   	pop    %edi
801012b6:	5d                   	pop    %ebp
801012b7:	c3                   	ret    
801012b8:	85 c9                	test   %ecx,%ecx
801012ba:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012bd:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c3:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
801012c9:	75 bf                	jne    8010128a <iget+0x3a>
801012cb:	90                   	nop
801012cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012d0:	85 f6                	test   %esi,%esi
801012d2:	74 29                	je     801012fd <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801012d4:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012d6:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012d9:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
801012e0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012e7:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801012ee:	e8 2d 30 00 00       	call   80104320 <release>

  return ip;
}
801012f3:	83 c4 1c             	add    $0x1c,%esp
801012f6:	89 f0                	mov    %esi,%eax
801012f8:	5b                   	pop    %ebx
801012f9:	5e                   	pop    %esi
801012fa:	5f                   	pop    %edi
801012fb:	5d                   	pop    %ebp
801012fc:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012fd:	c7 04 24 11 6e 10 80 	movl   $0x80106e11,(%esp)
80101304:	e8 57 f0 ff ff       	call   80100360 <panic>
80101309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101310 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101310:	55                   	push   %ebp
80101311:	89 e5                	mov    %esp,%ebp
80101313:	57                   	push   %edi
80101314:	56                   	push   %esi
80101315:	53                   	push   %ebx
80101316:	89 c3                	mov    %eax,%ebx
80101318:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010131b:	83 fa 0b             	cmp    $0xb,%edx
8010131e:	77 18                	ja     80101338 <bmap+0x28>
80101320:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
80101323:	8b 46 5c             	mov    0x5c(%esi),%eax
80101326:	85 c0                	test   %eax,%eax
80101328:	74 66                	je     80101390 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010132a:	83 c4 1c             	add    $0x1c,%esp
8010132d:	5b                   	pop    %ebx
8010132e:	5e                   	pop    %esi
8010132f:	5f                   	pop    %edi
80101330:	5d                   	pop    %ebp
80101331:	c3                   	ret    
80101332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101338:	8d 72 f4             	lea    -0xc(%edx),%esi

  if(bn < NINDIRECT){
8010133b:	83 fe 7f             	cmp    $0x7f,%esi
8010133e:	77 77                	ja     801013b7 <bmap+0xa7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101340:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101346:	85 c0                	test   %eax,%eax
80101348:	74 5e                	je     801013a8 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010134a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010134e:	8b 03                	mov    (%ebx),%eax
80101350:	89 04 24             	mov    %eax,(%esp)
80101353:	e8 78 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101358:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010135c:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010135e:	8b 32                	mov    (%edx),%esi
80101360:	85 f6                	test   %esi,%esi
80101362:	75 19                	jne    8010137d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101364:	8b 03                	mov    (%ebx),%eax
80101366:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101369:	e8 c2 fd ff ff       	call   80101130 <balloc>
8010136e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101371:	89 02                	mov    %eax,(%edx)
80101373:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101375:	89 3c 24             	mov    %edi,(%esp)
80101378:	e8 e3 19 00 00       	call   80102d60 <log_write>
    }
    brelse(bp);
8010137d:	89 3c 24             	mov    %edi,(%esp)
80101380:	e8 5b ee ff ff       	call   801001e0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
80101385:	83 c4 1c             	add    $0x1c,%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101388:	89 f0                	mov    %esi,%eax
    return addr;
  }

  panic("bmap: out of range");
}
8010138a:	5b                   	pop    %ebx
8010138b:	5e                   	pop    %esi
8010138c:	5f                   	pop    %edi
8010138d:	5d                   	pop    %ebp
8010138e:	c3                   	ret    
8010138f:	90                   	nop
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101390:	8b 03                	mov    (%ebx),%eax
80101392:	e8 99 fd ff ff       	call   80101130 <balloc>
80101397:	89 46 5c             	mov    %eax,0x5c(%esi)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010139a:	83 c4 1c             	add    $0x1c,%esp
8010139d:	5b                   	pop    %ebx
8010139e:	5e                   	pop    %esi
8010139f:	5f                   	pop    %edi
801013a0:	5d                   	pop    %ebp
801013a1:	c3                   	ret    
801013a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013a8:	8b 03                	mov    (%ebx),%eax
801013aa:	e8 81 fd ff ff       	call   80101130 <balloc>
801013af:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
801013b5:	eb 93                	jmp    8010134a <bmap+0x3a>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
801013b7:	c7 04 24 21 6e 10 80 	movl   $0x80106e21,(%esp)
801013be:	e8 9d ef ff ff       	call   80100360 <panic>
801013c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013d0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	83 ec 10             	sub    $0x10,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801013d8:	8b 45 08             	mov    0x8(%ebp),%eax
801013db:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013e2:	00 
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013e3:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013e6:	89 04 24             	mov    %eax,(%esp)
801013e9:	e8 e2 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801013ee:	89 34 24             	mov    %esi,(%esp)
801013f1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013f8:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
801013f9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013fb:	8d 40 5c             	lea    0x5c(%eax),%eax
801013fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80101402:	e8 09 30 00 00       	call   80104410 <memmove>
  brelse(bp);
80101407:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010140a:	83 c4 10             	add    $0x10,%esp
8010140d:	5b                   	pop    %ebx
8010140e:	5e                   	pop    %esi
8010140f:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101410:	e9 cb ed ff ff       	jmp    801001e0 <brelse>
80101415:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101420 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	57                   	push   %edi
80101424:	89 d7                	mov    %edx,%edi
80101426:	56                   	push   %esi
80101427:	53                   	push   %ebx
80101428:	89 c3                	mov    %eax,%ebx
8010142a:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
8010142d:	89 04 24             	mov    %eax,(%esp)
80101430:	c7 44 24 04 e0 09 11 	movl   $0x801109e0,0x4(%esp)
80101437:	80 
80101438:	e8 93 ff ff ff       	call   801013d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010143d:	89 fa                	mov    %edi,%edx
8010143f:	c1 ea 0c             	shr    $0xc,%edx
80101442:	03 15 f8 09 11 80    	add    0x801109f8,%edx
80101448:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
8010144b:	bb 01 00 00 00       	mov    $0x1,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
80101450:	89 54 24 04          	mov    %edx,0x4(%esp)
80101454:	e8 77 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101459:	89 f9                	mov    %edi,%ecx
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
8010145b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101461:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101463:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101466:	c1 fa 03             	sar    $0x3,%edx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101469:	d3 e3                	shl    %cl,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
8010146b:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
8010146d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101472:	0f b6 c8             	movzbl %al,%ecx
80101475:	85 d9                	test   %ebx,%ecx
80101477:	74 20                	je     80101499 <bfree+0x79>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101479:	f7 d3                	not    %ebx
8010147b:	21 c3                	and    %eax,%ebx
8010147d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101481:	89 34 24             	mov    %esi,(%esp)
80101484:	e8 d7 18 00 00       	call   80102d60 <log_write>
  brelse(bp);
80101489:	89 34 24             	mov    %esi,(%esp)
8010148c:	e8 4f ed ff ff       	call   801001e0 <brelse>
}
80101491:	83 c4 1c             	add    $0x1c,%esp
80101494:	5b                   	pop    %ebx
80101495:	5e                   	pop    %esi
80101496:	5f                   	pop    %edi
80101497:	5d                   	pop    %ebp
80101498:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101499:	c7 04 24 34 6e 10 80 	movl   $0x80106e34,(%esp)
801014a0:	e8 bb ee ff ff       	call   80100360 <panic>
801014a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014b0 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	53                   	push   %ebx
801014b4:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
801014b9:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
801014bc:	c7 44 24 04 47 6e 10 	movl   $0x80106e47,0x4(%esp)
801014c3:	80 
801014c4:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801014cb:	e8 a0 2c 00 00       	call   80104170 <initlock>
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801014d0:	89 1c 24             	mov    %ebx,(%esp)
801014d3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014d9:	c7 44 24 04 4e 6e 10 	movl   $0x80106e4e,0x4(%esp)
801014e0:	80 
801014e1:	e8 7a 2b 00 00       	call   80104060 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014e6:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
801014ec:	75 e2                	jne    801014d0 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }
  
  readsb(dev, &sb);
801014ee:	8b 45 08             	mov    0x8(%ebp),%eax
801014f1:	c7 44 24 04 e0 09 11 	movl   $0x801109e0,0x4(%esp)
801014f8:	80 
801014f9:	89 04 24             	mov    %eax,(%esp)
801014fc:	e8 cf fe ff ff       	call   801013d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101501:	a1 f8 09 11 80       	mov    0x801109f8,%eax
80101506:	c7 04 24 a4 6e 10 80 	movl   $0x80106ea4,(%esp)
8010150d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101511:	a1 f4 09 11 80       	mov    0x801109f4,%eax
80101516:	89 44 24 18          	mov    %eax,0x18(%esp)
8010151a:	a1 f0 09 11 80       	mov    0x801109f0,%eax
8010151f:	89 44 24 14          	mov    %eax,0x14(%esp)
80101523:	a1 ec 09 11 80       	mov    0x801109ec,%eax
80101528:	89 44 24 10          	mov    %eax,0x10(%esp)
8010152c:	a1 e8 09 11 80       	mov    0x801109e8,%eax
80101531:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101535:	a1 e4 09 11 80       	mov    0x801109e4,%eax
8010153a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010153e:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101543:	89 44 24 04          	mov    %eax,0x4(%esp)
80101547:	e8 04 f1 ff ff       	call   80100650 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010154c:	83 c4 24             	add    $0x24,%esp
8010154f:	5b                   	pop    %ebx
80101550:	5d                   	pop    %ebp
80101551:	c3                   	ret    
80101552:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101560 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	57                   	push   %edi
80101564:	56                   	push   %esi
80101565:	53                   	push   %ebx
80101566:	83 ec 2c             	sub    $0x2c,%esp
80101569:	8b 45 0c             	mov    0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010156c:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101573:	8b 7d 08             	mov    0x8(%ebp),%edi
80101576:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101579:	0f 86 a2 00 00 00    	jbe    80101621 <ialloc+0xc1>
8010157f:	be 01 00 00 00       	mov    $0x1,%esi
80101584:	bb 01 00 00 00       	mov    $0x1,%ebx
80101589:	eb 1a                	jmp    801015a5 <ialloc+0x45>
8010158b:	90                   	nop
8010158c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101590:	89 14 24             	mov    %edx,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101593:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101596:	e8 45 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010159b:	89 de                	mov    %ebx,%esi
8010159d:	3b 1d e8 09 11 80    	cmp    0x801109e8,%ebx
801015a3:	73 7c                	jae    80101621 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
801015a5:	89 f0                	mov    %esi,%eax
801015a7:	c1 e8 03             	shr    $0x3,%eax
801015aa:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801015b0:	89 3c 24             	mov    %edi,(%esp)
801015b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801015b7:	e8 14 eb ff ff       	call   801000d0 <bread>
801015bc:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
801015be:	89 f0                	mov    %esi,%eax
801015c0:	83 e0 07             	and    $0x7,%eax
801015c3:	c1 e0 06             	shl    $0x6,%eax
801015c6:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015ca:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015ce:	75 c0                	jne    80101590 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015d0:	89 0c 24             	mov    %ecx,(%esp)
801015d3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801015da:	00 
801015db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015e2:	00 
801015e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015e6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015e9:	e8 82 2d 00 00       	call   80104370 <memset>
      dip->type = type;
801015ee:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015f5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015f8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015fb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015fe:	89 14 24             	mov    %edx,(%esp)
80101601:	e8 5a 17 00 00       	call   80102d60 <log_write>
      brelse(bp);
80101606:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101609:	89 14 24             	mov    %edx,(%esp)
8010160c:	e8 cf eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101611:	83 c4 2c             	add    $0x2c,%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101614:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101616:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101617:	89 f8                	mov    %edi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101619:	5e                   	pop    %esi
8010161a:	5f                   	pop    %edi
8010161b:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010161c:	e9 2f fc ff ff       	jmp    80101250 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101621:	c7 04 24 54 6e 10 80 	movl   $0x80106e54,(%esp)
80101628:	e8 33 ed ff ff       	call   80100360 <panic>
8010162d:	8d 76 00             	lea    0x0(%esi),%esi

80101630 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	56                   	push   %esi
80101634:	53                   	push   %ebx
80101635:	83 ec 10             	sub    $0x10,%esp
80101638:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010163b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101641:	c1 e8 03             	shr    $0x3,%eax
80101644:	03 05 f4 09 11 80    	add    0x801109f4,%eax
8010164a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010164e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101651:	89 04 24             	mov    %eax,(%esp)
80101654:	e8 77 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101659:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010165c:	83 e2 07             	and    $0x7,%edx
8010165f:	c1 e2 06             	shl    $0x6,%edx
80101662:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101666:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
80101668:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010166c:	83 c2 0c             	add    $0xc,%edx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
8010166f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101673:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101677:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010167b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010167f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101683:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101687:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010168b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010168e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101691:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101695:	89 14 24             	mov    %edx,(%esp)
80101698:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010169f:	00 
801016a0:	e8 6b 2d 00 00       	call   80104410 <memmove>
  log_write(bp);
801016a5:	89 34 24             	mov    %esi,(%esp)
801016a8:	e8 b3 16 00 00       	call   80102d60 <log_write>
  brelse(bp);
801016ad:	89 75 08             	mov    %esi,0x8(%ebp)
}
801016b0:	83 c4 10             	add    $0x10,%esp
801016b3:	5b                   	pop    %ebx
801016b4:	5e                   	pop    %esi
801016b5:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
801016b6:	e9 25 eb ff ff       	jmp    801001e0 <brelse>
801016bb:	90                   	nop
801016bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016c0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	53                   	push   %ebx
801016c4:	83 ec 14             	sub    $0x14,%esp
801016c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016ca:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801016d1:	e8 1a 2b 00 00       	call   801041f0 <acquire>
  ip->ref++;
801016d6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016da:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801016e1:	e8 3a 2c 00 00       	call   80104320 <release>
  return ip;
}
801016e6:	83 c4 14             	add    $0x14,%esp
801016e9:	89 d8                	mov    %ebx,%eax
801016eb:	5b                   	pop    %ebx
801016ec:	5d                   	pop    %ebp
801016ed:	c3                   	ret    
801016ee:	66 90                	xchg   %ax,%ax

801016f0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	56                   	push   %esi
801016f4:	53                   	push   %ebx
801016f5:	83 ec 10             	sub    $0x10,%esp
801016f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801016fb:	85 db                	test   %ebx,%ebx
801016fd:	0f 84 b0 00 00 00    	je     801017b3 <ilock+0xc3>
80101703:	8b 43 08             	mov    0x8(%ebx),%eax
80101706:	85 c0                	test   %eax,%eax
80101708:	0f 8e a5 00 00 00    	jle    801017b3 <ilock+0xc3>
    panic("ilock");

  acquiresleep(&ip->lock);
8010170e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101711:	89 04 24             	mov    %eax,(%esp)
80101714:	e8 87 29 00 00       	call   801040a0 <acquiresleep>

  if(!(ip->flags & I_VALID)){
80101719:	f6 43 4c 02          	testb  $0x2,0x4c(%ebx)
8010171d:	74 09                	je     80101728 <ilock+0x38>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
8010171f:	83 c4 10             	add    $0x10,%esp
80101722:	5b                   	pop    %ebx
80101723:	5e                   	pop    %esi
80101724:	5d                   	pop    %ebp
80101725:	c3                   	ret    
80101726:	66 90                	xchg   %ax,%ax
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101728:	8b 43 04             	mov    0x4(%ebx),%eax
8010172b:	c1 e8 03             	shr    $0x3,%eax
8010172e:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101734:	89 44 24 04          	mov    %eax,0x4(%esp)
80101738:	8b 03                	mov    (%ebx),%eax
8010173a:	89 04 24             	mov    %eax,(%esp)
8010173d:	e8 8e e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101742:	8b 53 04             	mov    0x4(%ebx),%edx
80101745:	83 e2 07             	and    $0x7,%edx
80101748:	c1 e2 06             	shl    $0x6,%edx
8010174b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010174f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101751:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101754:	83 c2 0c             	add    $0xc,%edx
  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101757:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010175b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010175f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101763:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101767:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010176b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010176f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101773:	8b 42 fc             	mov    -0x4(%edx),%eax
80101776:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101779:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010177c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101780:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101787:	00 
80101788:	89 04 24             	mov    %eax,(%esp)
8010178b:	e8 80 2c 00 00       	call   80104410 <memmove>
    brelse(bp);
80101790:	89 34 24             	mov    %esi,(%esp)
80101793:	e8 48 ea ff ff       	call   801001e0 <brelse>
    ip->flags |= I_VALID;
80101798:	83 4b 4c 02          	orl    $0x2,0x4c(%ebx)
    if(ip->type == 0)
8010179c:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
801017a1:	0f 85 78 ff ff ff    	jne    8010171f <ilock+0x2f>
      panic("ilock: no type");
801017a7:	c7 04 24 6c 6e 10 80 	movl   $0x80106e6c,(%esp)
801017ae:	e8 ad eb ff ff       	call   80100360 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
801017b3:	c7 04 24 66 6e 10 80 	movl   $0x80106e66,(%esp)
801017ba:	e8 a1 eb ff ff       	call   80100360 <panic>
801017bf:	90                   	nop

801017c0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	56                   	push   %esi
801017c4:	53                   	push   %ebx
801017c5:	83 ec 10             	sub    $0x10,%esp
801017c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017cb:	85 db                	test   %ebx,%ebx
801017cd:	74 24                	je     801017f3 <iunlock+0x33>
801017cf:	8d 73 0c             	lea    0xc(%ebx),%esi
801017d2:	89 34 24             	mov    %esi,(%esp)
801017d5:	e8 66 29 00 00       	call   80104140 <holdingsleep>
801017da:	85 c0                	test   %eax,%eax
801017dc:	74 15                	je     801017f3 <iunlock+0x33>
801017de:	8b 43 08             	mov    0x8(%ebx),%eax
801017e1:	85 c0                	test   %eax,%eax
801017e3:	7e 0e                	jle    801017f3 <iunlock+0x33>
    panic("iunlock");

  releasesleep(&ip->lock);
801017e5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017e8:	83 c4 10             	add    $0x10,%esp
801017eb:	5b                   	pop    %ebx
801017ec:	5e                   	pop    %esi
801017ed:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017ee:	e9 0d 29 00 00       	jmp    80104100 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017f3:	c7 04 24 7b 6e 10 80 	movl   $0x80106e7b,(%esp)
801017fa:	e8 61 eb ff ff       	call   80100360 <panic>
801017ff:	90                   	nop

80101800 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	57                   	push   %edi
80101804:	56                   	push   %esi
80101805:	53                   	push   %ebx
80101806:	83 ec 1c             	sub    $0x1c,%esp
80101809:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
8010180c:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101813:	e8 d8 29 00 00       	call   801041f0 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101818:	8b 46 08             	mov    0x8(%esi),%eax
8010181b:	83 f8 01             	cmp    $0x1,%eax
8010181e:	74 20                	je     80101840 <iput+0x40>
    ip->type = 0;
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
80101820:	83 e8 01             	sub    $0x1,%eax
80101823:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
80101826:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
8010182d:	83 c4 1c             	add    $0x1c,%esp
80101830:	5b                   	pop    %ebx
80101831:	5e                   	pop    %esi
80101832:	5f                   	pop    %edi
80101833:	5d                   	pop    %ebp
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
  release(&icache.lock);
80101834:	e9 e7 2a 00 00       	jmp    80104320 <release>
80101839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
// case it has to free the inode.
void
iput(struct inode *ip)
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101840:	f6 46 4c 02          	testb  $0x2,0x4c(%esi)
80101844:	74 da                	je     80101820 <iput+0x20>
80101846:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
8010184b:	75 d3                	jne    80101820 <iput+0x20>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
8010184d:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101854:	89 f3                	mov    %esi,%ebx
80101856:	e8 c5 2a 00 00       	call   80104320 <release>
8010185b:	8d 7e 30             	lea    0x30(%esi),%edi
8010185e:	eb 07                	jmp    80101867 <iput+0x67>
80101860:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101863:	39 fb                	cmp    %edi,%ebx
80101865:	74 19                	je     80101880 <iput+0x80>
    if(ip->addrs[i]){
80101867:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010186a:	85 d2                	test   %edx,%edx
8010186c:	74 f2                	je     80101860 <iput+0x60>
      bfree(ip->dev, ip->addrs[i]);
8010186e:	8b 06                	mov    (%esi),%eax
80101870:	e8 ab fb ff ff       	call   80101420 <bfree>
      ip->addrs[i] = 0;
80101875:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010187c:	eb e2                	jmp    80101860 <iput+0x60>
8010187e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101880:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101886:	85 c0                	test   %eax,%eax
80101888:	75 3e                	jne    801018c8 <iput+0xc8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010188a:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101891:	89 34 24             	mov    %esi,(%esp)
80101894:	e8 97 fd ff ff       	call   80101630 <iupdate>
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
80101899:	31 c0                	xor    %eax,%eax
8010189b:	66 89 46 50          	mov    %ax,0x50(%esi)
    iupdate(ip);
8010189f:	89 34 24             	mov    %esi,(%esp)
801018a2:	e8 89 fd ff ff       	call   80101630 <iupdate>
    acquire(&icache.lock);
801018a7:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801018ae:	e8 3d 29 00 00       	call   801041f0 <acquire>
801018b3:	8b 46 08             	mov    0x8(%esi),%eax
    ip->flags = 0;
801018b6:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018bd:	e9 5e ff ff ff       	jmp    80101820 <iput+0x20>
801018c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018cc:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018ce:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018d0:	89 04 24             	mov    %eax,(%esp)
801018d3:	e8 f8 e7 ff ff       	call   801000d0 <bread>
801018d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018db:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
801018de:	31 c0                	xor    %eax,%eax
801018e0:	eb 13                	jmp    801018f5 <iput+0xf5>
801018e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801018e8:	83 c3 01             	add    $0x1,%ebx
801018eb:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018f1:	89 d8                	mov    %ebx,%eax
801018f3:	74 10                	je     80101905 <iput+0x105>
      if(a[j])
801018f5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018f8:	85 d2                	test   %edx,%edx
801018fa:	74 ec                	je     801018e8 <iput+0xe8>
        bfree(ip->dev, a[j]);
801018fc:	8b 06                	mov    (%esi),%eax
801018fe:	e8 1d fb ff ff       	call   80101420 <bfree>
80101903:	eb e3                	jmp    801018e8 <iput+0xe8>
    }
    brelse(bp);
80101905:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101908:	89 04 24             	mov    %eax,(%esp)
8010190b:	e8 d0 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101910:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101916:	8b 06                	mov    (%esi),%eax
80101918:	e8 03 fb ff ff       	call   80101420 <bfree>
    ip->addrs[NDIRECT] = 0;
8010191d:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101924:	00 00 00 
80101927:	e9 5e ff ff ff       	jmp    8010188a <iput+0x8a>
8010192c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101930 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	53                   	push   %ebx
80101934:	83 ec 14             	sub    $0x14,%esp
80101937:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010193a:	89 1c 24             	mov    %ebx,(%esp)
8010193d:	e8 7e fe ff ff       	call   801017c0 <iunlock>
  iput(ip);
80101942:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101945:	83 c4 14             	add    $0x14,%esp
80101948:	5b                   	pop    %ebx
80101949:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010194a:	e9 b1 fe ff ff       	jmp    80101800 <iput>
8010194f:	90                   	nop

80101950 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	8b 55 08             	mov    0x8(%ebp),%edx
80101956:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101959:	8b 0a                	mov    (%edx),%ecx
8010195b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010195e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101961:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101964:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101968:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010196b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010196f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101973:	8b 52 58             	mov    0x58(%edx),%edx
80101976:	89 50 10             	mov    %edx,0x10(%eax)
}
80101979:	5d                   	pop    %ebp
8010197a:	c3                   	ret    
8010197b:	90                   	nop
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101980 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	57                   	push   %edi
80101984:	56                   	push   %esi
80101985:	53                   	push   %ebx
80101986:	83 ec 2c             	sub    $0x2c,%esp
80101989:	8b 45 0c             	mov    0xc(%ebp),%eax
8010198c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010198f:	8b 75 10             	mov    0x10(%ebp),%esi
80101992:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101995:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101998:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
8010199d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019a0:	0f 84 aa 00 00 00    	je     80101a50 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019a6:	8b 47 58             	mov    0x58(%edi),%eax
801019a9:	39 f0                	cmp    %esi,%eax
801019ab:	0f 82 c7 00 00 00    	jb     80101a78 <readi+0xf8>
801019b1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019b4:	89 da                	mov    %ebx,%edx
801019b6:	01 f2                	add    %esi,%edx
801019b8:	0f 82 ba 00 00 00    	jb     80101a78 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019be:	89 c1                	mov    %eax,%ecx
801019c0:	29 f1                	sub    %esi,%ecx
801019c2:	39 d0                	cmp    %edx,%eax
801019c4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c7:	31 c0                	xor    %eax,%eax
801019c9:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019cb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ce:	74 70                	je     80101a40 <readi+0xc0>
801019d0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019d3:	89 c7                	mov    %eax,%edi
801019d5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019db:	89 f2                	mov    %esi,%edx
801019dd:	c1 ea 09             	shr    $0x9,%edx
801019e0:	89 d8                	mov    %ebx,%eax
801019e2:	e8 29 f9 ff ff       	call   80101310 <bmap>
801019e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019eb:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019ed:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019f2:	89 04 24             	mov    %eax,(%esp)
801019f5:	e8 d6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019fa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019fd:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ff:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a01:	89 f0                	mov    %esi,%eax
80101a03:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a08:	29 c3                	sub    %eax,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101a0a:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a0e:	39 cb                	cmp    %ecx,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101a10:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a17:	0f 47 d9             	cmova  %ecx,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101a1a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a1e:	01 df                	add    %ebx,%edi
80101a20:	01 de                	add    %ebx,%esi
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101a22:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a25:	89 04 24             	mov    %eax,(%esp)
80101a28:	e8 e3 29 00 00       	call   80104410 <memmove>
    brelse(bp);
80101a2d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a30:	89 14 24             	mov    %edx,(%esp)
80101a33:	e8 a8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a38:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a3b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a3e:	77 98                	ja     801019d8 <readi+0x58>
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a43:	83 c4 2c             	add    $0x2c,%esp
80101a46:	5b                   	pop    %ebx
80101a47:	5e                   	pop    %esi
80101a48:	5f                   	pop    %edi
80101a49:	5d                   	pop    %ebp
80101a4a:	c3                   	ret    
80101a4b:	90                   	nop
80101a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a50:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a54:	66 83 f8 09          	cmp    $0x9,%ax
80101a58:	77 1e                	ja     80101a78 <readi+0xf8>
80101a5a:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
80101a61:	85 c0                	test   %eax,%eax
80101a63:	74 13                	je     80101a78 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a65:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a68:	89 75 10             	mov    %esi,0x10(%ebp)
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a6b:	83 c4 2c             	add    $0x2c,%esp
80101a6e:	5b                   	pop    %ebx
80101a6f:	5e                   	pop    %esi
80101a70:	5f                   	pop    %edi
80101a71:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a72:	ff e0                	jmp    *%eax
80101a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a7d:	eb c4                	jmp    80101a43 <readi+0xc3>
80101a7f:	90                   	nop

80101a80 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	57                   	push   %edi
80101a84:	56                   	push   %esi
80101a85:	53                   	push   %ebx
80101a86:	83 ec 2c             	sub    $0x2c,%esp
80101a89:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a8f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a92:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a97:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a9a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a9d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101aa0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa3:	0f 84 b7 00 00 00    	je     80101b60 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101aa9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aac:	39 70 58             	cmp    %esi,0x58(%eax)
80101aaf:	0f 82 e3 00 00 00    	jb     80101b98 <writei+0x118>
80101ab5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ab8:	89 c8                	mov    %ecx,%eax
80101aba:	01 f0                	add    %esi,%eax
80101abc:	0f 82 d6 00 00 00    	jb     80101b98 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ac2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ac7:	0f 87 cb 00 00 00    	ja     80101b98 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101acd:	85 c9                	test   %ecx,%ecx
80101acf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ad6:	74 77                	je     80101b4f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101adb:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101add:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae2:	c1 ea 09             	shr    $0x9,%edx
80101ae5:	89 f8                	mov    %edi,%eax
80101ae7:	e8 24 f8 ff ff       	call   80101310 <bmap>
80101aec:	89 44 24 04          	mov    %eax,0x4(%esp)
80101af0:	8b 07                	mov    (%edi),%eax
80101af2:	89 04 24             	mov    %eax,(%esp)
80101af5:	e8 d6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101afa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101afd:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b00:	8b 55 dc             	mov    -0x24(%ebp),%edx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b03:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b05:	89 f0                	mov    %esi,%eax
80101b07:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b0c:	29 c3                	sub    %eax,%ebx
80101b0e:	39 cb                	cmp    %ecx,%ebx
80101b10:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b13:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b17:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101b19:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b1d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b21:	89 04 24             	mov    %eax,(%esp)
80101b24:	e8 e7 28 00 00       	call   80104410 <memmove>
    log_write(bp);
80101b29:	89 3c 24             	mov    %edi,(%esp)
80101b2c:	e8 2f 12 00 00       	call   80102d60 <log_write>
    brelse(bp);
80101b31:	89 3c 24             	mov    %edi,(%esp)
80101b34:	e8 a7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b39:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b3f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b42:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b45:	77 91                	ja     80101ad8 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b47:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b4a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b4d:	72 39                	jb     80101b88 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b52:	83 c4 2c             	add    $0x2c,%esp
80101b55:	5b                   	pop    %ebx
80101b56:	5e                   	pop    %esi
80101b57:	5f                   	pop    %edi
80101b58:	5d                   	pop    %ebp
80101b59:	c3                   	ret    
80101b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 2e                	ja     80101b98 <writei+0x118>
80101b6a:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 23                	je     80101b98 <writei+0x118>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b75:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b78:	83 c4 2c             	add    $0x2c,%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b7f:	ff e0                	jmp    *%eax
80101b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b88:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b8b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b8e:	89 04 24             	mov    %eax,(%esp)
80101b91:	e8 9a fa ff ff       	call   80101630 <iupdate>
80101b96:	eb b7                	jmp    80101b4f <writei+0xcf>
  }
  return n;
}
80101b98:	83 c4 2c             	add    $0x2c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101ba0:	5b                   	pop    %ebx
80101ba1:	5e                   	pop    %esi
80101ba2:	5f                   	pop    %edi
80101ba3:	5d                   	pop    %ebp
80101ba4:	c3                   	ret    
80101ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bb9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101bc0:	00 
80101bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bc5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc8:	89 04 24             	mov    %eax,(%esp)
80101bcb:	e8 c0 28 00 00       	call   80104490 <strncmp>
}
80101bd0:	c9                   	leave  
80101bd1:	c3                   	ret    
80101bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101be0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	57                   	push   %edi
80101be4:	56                   	push   %esi
80101be5:	53                   	push   %ebx
80101be6:	83 ec 2c             	sub    $0x2c,%esp
80101be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bf1:	0f 85 97 00 00 00    	jne    80101c8e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bfa:	31 ff                	xor    %edi,%edi
80101bfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bff:	85 d2                	test   %edx,%edx
80101c01:	75 0d                	jne    80101c10 <dirlookup+0x30>
80101c03:	eb 73                	jmp    80101c78 <dirlookup+0x98>
80101c05:	8d 76 00             	lea    0x0(%esi),%esi
80101c08:	83 c7 10             	add    $0x10,%edi
80101c0b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101c0e:	76 68                	jbe    80101c78 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c10:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c17:	00 
80101c18:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c1c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c20:	89 1c 24             	mov    %ebx,(%esp)
80101c23:	e8 58 fd ff ff       	call   80101980 <readi>
80101c28:	83 f8 10             	cmp    $0x10,%eax
80101c2b:	75 55                	jne    80101c82 <dirlookup+0xa2>
      panic("dirlink read");
    if(de.inum == 0)
80101c2d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c32:	74 d4                	je     80101c08 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c37:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c3e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c45:	00 
80101c46:	89 04 24             	mov    %eax,(%esp)
80101c49:	e8 42 28 00 00       	call   80104490 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c4e:	85 c0                	test   %eax,%eax
80101c50:	75 b6                	jne    80101c08 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c52:	8b 45 10             	mov    0x10(%ebp),%eax
80101c55:	85 c0                	test   %eax,%eax
80101c57:	74 05                	je     80101c5e <dirlookup+0x7e>
        *poff = off;
80101c59:	8b 45 10             	mov    0x10(%ebp),%eax
80101c5c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c5e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c62:	8b 03                	mov    (%ebx),%eax
80101c64:	e8 e7 f5 ff ff       	call   80101250 <iget>
    }
  }

  return 0;
}
80101c69:	83 c4 2c             	add    $0x2c,%esp
80101c6c:	5b                   	pop    %ebx
80101c6d:	5e                   	pop    %esi
80101c6e:	5f                   	pop    %edi
80101c6f:	5d                   	pop    %ebp
80101c70:	c3                   	ret    
80101c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c78:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c7b:	31 c0                	xor    %eax,%eax
}
80101c7d:	5b                   	pop    %ebx
80101c7e:	5e                   	pop    %esi
80101c7f:	5f                   	pop    %edi
80101c80:	5d                   	pop    %ebp
80101c81:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101c82:	c7 04 24 95 6e 10 80 	movl   $0x80106e95,(%esp)
80101c89:	e8 d2 e6 ff ff       	call   80100360 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c8e:	c7 04 24 83 6e 10 80 	movl   $0x80106e83,(%esp)
80101c95:	e8 c6 e6 ff ff       	call   80100360 <panic>
80101c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ca0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ca0:	55                   	push   %ebp
80101ca1:	89 e5                	mov    %esp,%ebp
80101ca3:	57                   	push   %edi
80101ca4:	89 cf                	mov    %ecx,%edi
80101ca6:	56                   	push   %esi
80101ca7:	53                   	push   %ebx
80101ca8:	89 c3                	mov    %eax,%ebx
80101caa:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cad:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101cb3:	0f 84 51 01 00 00    	je     80101e0a <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101cb9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101cbf:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101cc2:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101cc9:	e8 22 25 00 00       	call   801041f0 <acquire>
  ip->ref++;
80101cce:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cd2:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101cd9:	e8 42 26 00 00       	call   80104320 <release>
80101cde:	eb 03                	jmp    80101ce3 <namex+0x43>
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101ce0:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101ce3:	0f b6 03             	movzbl (%ebx),%eax
80101ce6:	3c 2f                	cmp    $0x2f,%al
80101ce8:	74 f6                	je     80101ce0 <namex+0x40>
    path++;
  if(*path == 0)
80101cea:	84 c0                	test   %al,%al
80101cec:	0f 84 ed 00 00 00    	je     80101ddf <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cf2:	0f b6 03             	movzbl (%ebx),%eax
80101cf5:	89 da                	mov    %ebx,%edx
80101cf7:	84 c0                	test   %al,%al
80101cf9:	0f 84 b1 00 00 00    	je     80101db0 <namex+0x110>
80101cff:	3c 2f                	cmp    $0x2f,%al
80101d01:	75 0f                	jne    80101d12 <namex+0x72>
80101d03:	e9 a8 00 00 00       	jmp    80101db0 <namex+0x110>
80101d08:	3c 2f                	cmp    $0x2f,%al
80101d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d10:	74 0a                	je     80101d1c <namex+0x7c>
    path++;
80101d12:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d15:	0f b6 02             	movzbl (%edx),%eax
80101d18:	84 c0                	test   %al,%al
80101d1a:	75 ec                	jne    80101d08 <namex+0x68>
80101d1c:	89 d1                	mov    %edx,%ecx
80101d1e:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101d20:	83 f9 0d             	cmp    $0xd,%ecx
80101d23:	0f 8e 8f 00 00 00    	jle    80101db8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d29:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d2d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d34:	00 
80101d35:	89 3c 24             	mov    %edi,(%esp)
80101d38:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d3b:	e8 d0 26 00 00       	call   80104410 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d43:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d45:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d48:	75 0e                	jne    80101d58 <namex+0xb8>
80101d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d50:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d53:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d56:	74 f8                	je     80101d50 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d58:	89 34 24             	mov    %esi,(%esp)
80101d5b:	e8 90 f9 ff ff       	call   801016f0 <ilock>
    if(ip->type != T_DIR){
80101d60:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d65:	0f 85 85 00 00 00    	jne    80101df0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d6b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d6e:	85 d2                	test   %edx,%edx
80101d70:	74 09                	je     80101d7b <namex+0xdb>
80101d72:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d75:	0f 84 a5 00 00 00    	je     80101e20 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d7b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d82:	00 
80101d83:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d87:	89 34 24             	mov    %esi,(%esp)
80101d8a:	e8 51 fe ff ff       	call   80101be0 <dirlookup>
80101d8f:	85 c0                	test   %eax,%eax
80101d91:	74 5d                	je     80101df0 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d93:	89 34 24             	mov    %esi,(%esp)
80101d96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d99:	e8 22 fa ff ff       	call   801017c0 <iunlock>
  iput(ip);
80101d9e:	89 34 24             	mov    %esi,(%esp)
80101da1:	e8 5a fa ff ff       	call   80101800 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101da9:	89 c6                	mov    %eax,%esi
80101dab:	e9 33 ff ff ff       	jmp    80101ce3 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101db0:	31 c9                	xor    %ecx,%ecx
80101db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101db8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101dbc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101dc0:	89 3c 24             	mov    %edi,(%esp)
80101dc3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dc6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101dc9:	e8 42 26 00 00       	call   80104410 <memmove>
    name[len] = 0;
80101dce:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dd1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dd4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dd8:	89 d3                	mov    %edx,%ebx
80101dda:	e9 66 ff ff ff       	jmp    80101d45 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ddf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101de2:	85 c0                	test   %eax,%eax
80101de4:	75 4c                	jne    80101e32 <namex+0x192>
80101de6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101de8:	83 c4 2c             	add    $0x2c,%esp
80101deb:	5b                   	pop    %ebx
80101dec:	5e                   	pop    %esi
80101ded:	5f                   	pop    %edi
80101dee:	5d                   	pop    %ebp
80101def:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101df0:	89 34 24             	mov    %esi,(%esp)
80101df3:	e8 c8 f9 ff ff       	call   801017c0 <iunlock>
  iput(ip);
80101df8:	89 34 24             	mov    %esi,(%esp)
80101dfb:	e8 00 fa ff ff       	call   80101800 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e00:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101e03:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e05:	5b                   	pop    %ebx
80101e06:	5e                   	pop    %esi
80101e07:	5f                   	pop    %edi
80101e08:	5d                   	pop    %ebp
80101e09:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101e0a:	ba 01 00 00 00       	mov    $0x1,%edx
80101e0f:	b8 01 00 00 00       	mov    $0x1,%eax
80101e14:	e8 37 f4 ff ff       	call   80101250 <iget>
80101e19:	89 c6                	mov    %eax,%esi
80101e1b:	e9 c3 fe ff ff       	jmp    80101ce3 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e20:	89 34 24             	mov    %esi,(%esp)
80101e23:	e8 98 f9 ff ff       	call   801017c0 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e28:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101e2b:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e2d:	5b                   	pop    %ebx
80101e2e:	5e                   	pop    %esi
80101e2f:	5f                   	pop    %edi
80101e30:	5d                   	pop    %ebp
80101e31:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e32:	89 34 24             	mov    %esi,(%esp)
80101e35:	e8 c6 f9 ff ff       	call   80101800 <iput>
    return 0;
80101e3a:	31 c0                	xor    %eax,%eax
80101e3c:	eb aa                	jmp    80101de8 <namex+0x148>
80101e3e:	66 90                	xchg   %ax,%ax

80101e40 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e40:	55                   	push   %ebp
80101e41:	89 e5                	mov    %esp,%ebp
80101e43:	57                   	push   %edi
80101e44:	56                   	push   %esi
80101e45:	53                   	push   %ebx
80101e46:	83 ec 2c             	sub    $0x2c,%esp
80101e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e4f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e56:	00 
80101e57:	89 1c 24             	mov    %ebx,(%esp)
80101e5a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e5e:	e8 7d fd ff ff       	call   80101be0 <dirlookup>
80101e63:	85 c0                	test   %eax,%eax
80101e65:	0f 85 8b 00 00 00    	jne    80101ef6 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e6b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e6e:	31 ff                	xor    %edi,%edi
80101e70:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e73:	85 c0                	test   %eax,%eax
80101e75:	75 13                	jne    80101e8a <dirlink+0x4a>
80101e77:	eb 35                	jmp    80101eae <dirlink+0x6e>
80101e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e80:	8d 57 10             	lea    0x10(%edi),%edx
80101e83:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e86:	89 d7                	mov    %edx,%edi
80101e88:	76 24                	jbe    80101eae <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e91:	00 
80101e92:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e96:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e9a:	89 1c 24             	mov    %ebx,(%esp)
80101e9d:	e8 de fa ff ff       	call   80101980 <readi>
80101ea2:	83 f8 10             	cmp    $0x10,%eax
80101ea5:	75 5e                	jne    80101f05 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80101ea7:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101eac:	75 d2                	jne    80101e80 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101eae:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eb1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101eb8:	00 
80101eb9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ebd:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ec0:	89 04 24             	mov    %eax,(%esp)
80101ec3:	e8 38 26 00 00       	call   80104500 <strncpy>
  de.inum = inum;
80101ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ecb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ed2:	00 
80101ed3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ed7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101edb:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101ede:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ee2:	e8 99 fb ff ff       	call   80101a80 <writei>
80101ee7:	83 f8 10             	cmp    $0x10,%eax
80101eea:	75 25                	jne    80101f11 <dirlink+0xd1>
    panic("dirlink");

  return 0;
80101eec:	31 c0                	xor    %eax,%eax
}
80101eee:	83 c4 2c             	add    $0x2c,%esp
80101ef1:	5b                   	pop    %ebx
80101ef2:	5e                   	pop    %esi
80101ef3:	5f                   	pop    %edi
80101ef4:	5d                   	pop    %ebp
80101ef5:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101ef6:	89 04 24             	mov    %eax,(%esp)
80101ef9:	e8 02 f9 ff ff       	call   80101800 <iput>
    return -1;
80101efe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f03:	eb e9                	jmp    80101eee <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101f05:	c7 04 24 95 6e 10 80 	movl   $0x80106e95,(%esp)
80101f0c:	e8 4f e4 ff ff       	call   80100360 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101f11:	c7 04 24 5e 74 10 80 	movl   $0x8010745e,(%esp)
80101f18:	e8 43 e4 ff ff       	call   80100360 <panic>
80101f1d:	8d 76 00             	lea    0x0(%esi),%esi

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
80101f2e:	e8 6d fd ff ff       	call   80101ca0 <namex>
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
80101f4f:	e9 4c fd ff ff       	jmp    80101ca0 <namex>
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
80101f61:	89 e5                	mov    %esp,%ebp
80101f63:	56                   	push   %esi
80101f64:	89 c6                	mov    %eax,%esi
80101f66:	53                   	push   %ebx
80101f67:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f6a:	85 c0                	test   %eax,%eax
80101f6c:	0f 84 99 00 00 00    	je     8010200b <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f72:	8b 48 08             	mov    0x8(%eax),%ecx
80101f75:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f7b:	0f 87 7e 00 00 00    	ja     80101fff <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f81:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f86:	66 90                	xchg   %ax,%ax
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
80101f90:	31 db                	xor    %ebx,%ebx
80101f92:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f97:	89 d8                	mov    %ebx,%eax
80101f99:	ee                   	out    %al,(%dx)
80101f9a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f9f:	b8 01 00 00 00       	mov    $0x1,%eax
80101fa4:	ee                   	out    %al,(%dx)
80101fa5:	0f b6 c1             	movzbl %cl,%eax
80101fa8:	b2 f3                	mov    $0xf3,%dl
80101faa:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101fab:	89 c8                	mov    %ecx,%eax
80101fad:	b2 f4                	mov    $0xf4,%dl
80101faf:	c1 f8 08             	sar    $0x8,%eax
80101fb2:	ee                   	out    %al,(%dx)
80101fb3:	b2 f5                	mov    $0xf5,%dl
80101fb5:	89 d8                	mov    %ebx,%eax
80101fb7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fb8:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fbc:	b2 f6                	mov    $0xf6,%dl
80101fbe:	83 e0 01             	and    $0x1,%eax
80101fc1:	c1 e0 04             	shl    $0x4,%eax
80101fc4:	83 c8 e0             	or     $0xffffffe0,%eax
80101fc7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fc8:	f6 06 04             	testb  $0x4,(%esi)
80101fcb:	75 13                	jne    80101fe0 <idestart+0x80>
80101fcd:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fd2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fd7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fd8:	83 c4 10             	add    $0x10,%esp
80101fdb:	5b                   	pop    %ebx
80101fdc:	5e                   	pop    %esi
80101fdd:	5d                   	pop    %ebp
80101fde:	c3                   	ret    
80101fdf:	90                   	nop
80101fe0:	b2 f7                	mov    $0xf7,%dl
80101fe2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fe7:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101fe8:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101fed:	83 c6 5c             	add    $0x5c,%esi
80101ff0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101ff5:	fc                   	cld    
80101ff6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101ff8:	83 c4 10             	add    $0x10,%esp
80101ffb:	5b                   	pop    %ebx
80101ffc:	5e                   	pop    %esi
80101ffd:	5d                   	pop    %ebp
80101ffe:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101fff:	c7 04 24 00 6f 10 80 	movl   $0x80106f00,(%esp)
80102006:	e8 55 e3 ff ff       	call   80100360 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010200b:	c7 04 24 f7 6e 10 80 	movl   $0x80106ef7,(%esp)
80102012:	e8 49 e3 ff ff       	call   80100360 <panic>
80102017:	89 f6                	mov    %esi,%esi
80102019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102020 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102020:	55                   	push   %ebp
80102021:	89 e5                	mov    %esp,%ebp
80102023:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102026:	c7 44 24 04 12 6f 10 	movl   $0x80106f12,0x4(%esp)
8010202d:	80 
8010202e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102035:	e8 36 21 00 00       	call   80104170 <initlock>
  picenable(IRQ_IDE);
8010203a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102041:	e8 ea 11 00 00       	call   80103230 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102046:	a1 80 2d 11 80       	mov    0x80112d80,%eax
8010204b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102052:	83 e8 01             	sub    $0x1,%eax
80102055:	89 44 24 04          	mov    %eax,0x4(%esp)
80102059:	e8 82 02 00 00       	call   801022e0 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010205e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102063:	90                   	nop
80102064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102068:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102069:	83 e0 c0             	and    $0xffffffc0,%eax
8010206c:	3c 40                	cmp    $0x40,%al
8010206e:	75 f8                	jne    80102068 <ideinit+0x48>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102070:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102075:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010207a:	ee                   	out    %al,(%dx)
8010207b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102080:	b2 f7                	mov    $0xf7,%dl
80102082:	eb 09                	jmp    8010208d <ideinit+0x6d>
80102084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102088:	83 e9 01             	sub    $0x1,%ecx
8010208b:	74 0f                	je     8010209c <ideinit+0x7c>
8010208d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010208e:	84 c0                	test   %al,%al
80102090:	74 f6                	je     80102088 <ideinit+0x68>
      havedisk1 = 1;
80102092:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102099:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010209c:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020a1:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801020a6:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
801020a7:	c9                   	leave  
801020a8:	c3                   	ret    
801020a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

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
801020b6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020b9:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020c0:	e8 2b 21 00 00       	call   801041f0 <acquire>
  if((b = idequeue) == 0){
801020c5:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020cb:	85 db                	test   %ebx,%ebx
801020cd:	74 30                	je     801020ff <ideintr+0x4f>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
801020cf:	8b 43 58             	mov    0x58(%ebx),%eax
801020d2:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020d7:	8b 33                	mov    (%ebx),%esi
801020d9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020df:	74 37                	je     80102118 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020e1:	83 e6 fb             	and    $0xfffffffb,%esi
801020e4:	83 ce 02             	or     $0x2,%esi
801020e7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020e9:	89 1c 24             	mov    %ebx,(%esp)
801020ec:	e8 bf 1d 00 00       	call   80103eb0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020f1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020f6:	85 c0                	test   %eax,%eax
801020f8:	74 05                	je     801020ff <ideintr+0x4f>
    idestart(idequeue);
801020fa:	e8 61 fe ff ff       	call   80101f60 <idestart>
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
  if((b = idequeue) == 0){
    release(&idelock);
801020ff:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102106:	e8 15 22 00 00       	call   80104320 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
8010210b:	83 c4 1c             	add    $0x1c,%esp
8010210e:	5b                   	pop    %ebx
8010210f:	5e                   	pop    %esi
80102110:	5f                   	pop    %edi
80102111:	5d                   	pop    %ebp
80102112:	c3                   	ret    
80102113:	90                   	nop
80102114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102118:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010211d:	8d 76 00             	lea    0x0(%esi),%esi
80102120:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102121:	89 c1                	mov    %eax,%ecx
80102123:	83 e1 c0             	and    $0xffffffc0,%ecx
80102126:	80 f9 40             	cmp    $0x40,%cl
80102129:	75 f5                	jne    80102120 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010212b:	a8 21                	test   $0x21,%al
8010212d:	75 b2                	jne    801020e1 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
8010212f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
80102132:	b9 80 00 00 00       	mov    $0x80,%ecx
80102137:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010213c:	fc                   	cld    
8010213d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010213f:	8b 33                	mov    (%ebx),%esi
80102141:	eb 9e                	jmp    801020e1 <ideintr+0x31>
80102143:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
80102154:	83 ec 14             	sub    $0x14,%esp
80102157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010215a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010215d:	89 04 24             	mov    %eax,(%esp)
80102160:	e8 db 1f 00 00       	call   80104140 <holdingsleep>
80102165:	85 c0                	test   %eax,%eax
80102167:	0f 84 9e 00 00 00    	je     8010220b <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010216d:	8b 03                	mov    (%ebx),%eax
8010216f:	83 e0 06             	and    $0x6,%eax
80102172:	83 f8 02             	cmp    $0x2,%eax
80102175:	0f 84 a8 00 00 00    	je     80102223 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010217b:	8b 53 04             	mov    0x4(%ebx),%edx
8010217e:	85 d2                	test   %edx,%edx
80102180:	74 0d                	je     8010218f <iderw+0x3f>
80102182:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102187:	85 c0                	test   %eax,%eax
80102189:	0f 84 88 00 00 00    	je     80102217 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010218f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102196:	e8 55 20 00 00       	call   801041f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010219b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
801021a0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021a7:	85 c0                	test   %eax,%eax
801021a9:	75 07                	jne    801021b2 <iderw+0x62>
801021ab:	eb 4e                	jmp    801021fb <iderw+0xab>
801021ad:	8d 76 00             	lea    0x0(%esi),%esi
801021b0:	89 d0                	mov    %edx,%eax
801021b2:	8b 50 58             	mov    0x58(%eax),%edx
801021b5:	85 d2                	test   %edx,%edx
801021b7:	75 f7                	jne    801021b0 <iderw+0x60>
801021b9:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
801021bc:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801021be:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021c4:	74 3c                	je     80102202 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021c6:	8b 03                	mov    (%ebx),%eax
801021c8:	83 e0 06             	and    $0x6,%eax
801021cb:	83 f8 02             	cmp    $0x2,%eax
801021ce:	74 1a                	je     801021ea <iderw+0x9a>
    sleep(b, &idelock);
801021d0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801021d7:	80 
801021d8:	89 1c 24             	mov    %ebx,(%esp)
801021db:	e8 30 1b 00 00       	call   80103d10 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021e0:	8b 13                	mov    (%ebx),%edx
801021e2:	83 e2 06             	and    $0x6,%edx
801021e5:	83 fa 02             	cmp    $0x2,%edx
801021e8:	75 e6                	jne    801021d0 <iderw+0x80>
    sleep(b, &idelock);
  }

  release(&idelock);
801021ea:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021f1:	83 c4 14             	add    $0x14,%esp
801021f4:	5b                   	pop    %ebx
801021f5:	5d                   	pop    %ebp
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }

  release(&idelock);
801021f6:	e9 25 21 00 00       	jmp    80104320 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021fb:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
80102200:	eb ba                	jmp    801021bc <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102202:	89 d8                	mov    %ebx,%eax
80102204:	e8 57 fd ff ff       	call   80101f60 <idestart>
80102209:	eb bb                	jmp    801021c6 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010220b:	c7 04 24 16 6f 10 80 	movl   $0x80106f16,(%esp)
80102212:	e8 49 e1 ff ff       	call   80100360 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102217:	c7 04 24 41 6f 10 80 	movl   $0x80106f41,(%esp)
8010221e:	e8 3d e1 ff ff       	call   80100360 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102223:	c7 04 24 2c 6f 10 80 	movl   $0x80106f2c,(%esp)
8010222a:	e8 31 e1 ff ff       	call   80100360 <panic>
8010222f:	90                   	nop

80102230 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
80102230:	a1 84 27 11 80       	mov    0x80112784,%eax
80102235:	85 c0                	test   %eax,%eax
80102237:	0f 84 9b 00 00 00    	je     801022d8 <ioapicinit+0xa8>
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010223d:	55                   	push   %ebp
8010223e:	89 e5                	mov    %esp,%ebp
80102240:	56                   	push   %esi
80102241:	53                   	push   %ebx
80102242:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102245:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
8010224c:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010224f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102256:	00 00 00 
  return ioapic->data;
80102259:	8b 15 54 26 11 80    	mov    0x80112654,%edx
8010225f:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102262:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102268:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010226e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102275:	c1 e8 10             	shr    $0x10,%eax
80102278:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010227b:	8b 43 10             	mov    0x10(%ebx),%eax
  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
8010227e:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102281:	39 c2                	cmp    %eax,%edx
80102283:	74 12                	je     80102297 <ioapicinit+0x67>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102285:	c7 04 24 60 6f 10 80 	movl   $0x80106f60,(%esp)
8010228c:	e8 bf e3 ff ff       	call   80100650 <cprintf>
80102291:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
80102297:	ba 10 00 00 00       	mov    $0x10,%edx
8010229c:	31 c0                	xor    %eax,%eax
8010229e:	eb 02                	jmp    801022a2 <ioapicinit+0x72>
801022a0:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022a2:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
801022a4:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
801022aa:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022ad:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022b3:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022b6:	89 4b 10             	mov    %ecx,0x10(%ebx)
801022b9:	8d 4a 01             	lea    0x1(%edx),%ecx
801022bc:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022bf:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801022c1:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022c7:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022c9:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022d0:	7d ce                	jge    801022a0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022d2:	83 c4 10             	add    $0x10,%esp
801022d5:	5b                   	pop    %ebx
801022d6:	5e                   	pop    %esi
801022d7:	5d                   	pop    %ebp
801022d8:	f3 c3                	repz ret 
801022da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801022e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
801022e0:	8b 15 84 27 11 80    	mov    0x80112784,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801022e6:	55                   	push   %ebp
801022e7:	89 e5                	mov    %esp,%ebp
801022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
801022ec:	85 d2                	test   %edx,%edx
801022ee:	74 29                	je     80102319 <ioapicenable+0x39>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022f0:	8d 48 20             	lea    0x20(%eax),%ecx
801022f3:	8d 54 00 10          	lea    0x10(%eax,%eax,1),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022f7:	a1 54 26 11 80       	mov    0x80112654,%eax
801022fc:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801022fe:	a1 54 26 11 80       	mov    0x80112654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102303:	83 c2 01             	add    $0x1,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102306:	89 48 10             	mov    %ecx,0x10(%eax)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102309:	8b 4d 0c             	mov    0xc(%ebp),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010230c:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
8010230e:	a1 54 26 11 80       	mov    0x80112654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102313:	c1 e1 18             	shl    $0x18,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102316:	89 48 10             	mov    %ecx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102319:	5d                   	pop    %ebp
8010231a:	c3                   	ret    
8010231b:	66 90                	xchg   %ax,%ax
8010231d:	66 90                	xchg   %ax,%ax
8010231f:	90                   	nop

80102320 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	53                   	push   %ebx
80102324:	83 ec 14             	sub    $0x14,%esp
80102327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010232a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102330:	75 7c                	jne    801023ae <kfree+0x8e>
80102332:	81 fb 28 55 11 80    	cmp    $0x80115528,%ebx
80102338:	72 74                	jb     801023ae <kfree+0x8e>
8010233a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102340:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102345:	77 67                	ja     801023ae <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102347:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010234e:	00 
8010234f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102356:	00 
80102357:	89 1c 24             	mov    %ebx,(%esp)
8010235a:	e8 11 20 00 00       	call   80104370 <memset>

  if(kmem.use_lock)
8010235f:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102365:	85 d2                	test   %edx,%edx
80102367:	75 37                	jne    801023a0 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102369:	a1 98 26 11 80       	mov    0x80112698,%eax
8010236e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102370:	a1 94 26 11 80       	mov    0x80112694,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102375:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
8010237b:	85 c0                	test   %eax,%eax
8010237d:	75 09                	jne    80102388 <kfree+0x68>
    release(&kmem.lock);
}
8010237f:	83 c4 14             	add    $0x14,%esp
80102382:	5b                   	pop    %ebx
80102383:	5d                   	pop    %ebp
80102384:	c3                   	ret    
80102385:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102388:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
8010238f:	83 c4 14             	add    $0x14,%esp
80102392:	5b                   	pop    %ebx
80102393:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102394:	e9 87 1f 00 00       	jmp    80104320 <release>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
801023a0:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801023a7:	e8 44 1e 00 00       	call   801041f0 <acquire>
801023ac:	eb bb                	jmp    80102369 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
801023ae:	c7 04 24 92 6f 10 80 	movl   $0x80106f92,(%esp)
801023b5:	e8 a6 df ff ff       	call   80100360 <panic>
801023ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023c0 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
801023c5:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023c8:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801023cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ce:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023d4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023da:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023e0:	39 de                	cmp    %ebx,%esi
801023e2:	73 08                	jae    801023ec <freerange+0x2c>
801023e4:	eb 18                	jmp    801023fe <freerange+0x3e>
801023e6:	66 90                	xchg   %ax,%ax
801023e8:	89 da                	mov    %ebx,%edx
801023ea:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023ec:	89 14 24             	mov    %edx,(%esp)
801023ef:	e8 2c ff ff ff       	call   80102320 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023fa:	39 f0                	cmp    %esi,%eax
801023fc:	76 ea                	jbe    801023e8 <freerange+0x28>
    kfree(p);
}
801023fe:	83 c4 10             	add    $0x10,%esp
80102401:	5b                   	pop    %ebx
80102402:	5e                   	pop    %esi
80102403:	5d                   	pop    %ebp
80102404:	c3                   	ret    
80102405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102410 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	56                   	push   %esi
80102414:	53                   	push   %ebx
80102415:	83 ec 10             	sub    $0x10,%esp
80102418:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010241b:	c7 44 24 04 98 6f 10 	movl   $0x80106f98,0x4(%esp)
80102422:	80 
80102423:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
8010242a:	e8 41 1d 00 00       	call   80104170 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010242f:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102432:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102439:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010243c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102442:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102448:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010244e:	39 de                	cmp    %ebx,%esi
80102450:	73 0a                	jae    8010245c <kinit1+0x4c>
80102452:	eb 1a                	jmp    8010246e <kinit1+0x5e>
80102454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102458:	89 da                	mov    %ebx,%edx
8010245a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010245c:	89 14 24             	mov    %edx,(%esp)
8010245f:	e8 bc fe ff ff       	call   80102320 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102464:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010246a:	39 c6                	cmp    %eax,%esi
8010246c:	73 ea                	jae    80102458 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010246e:	83 c4 10             	add    $0x10,%esp
80102471:	5b                   	pop    %ebx
80102472:	5e                   	pop    %esi
80102473:	5d                   	pop    %ebp
80102474:	c3                   	ret    
80102475:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102480 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	56                   	push   %esi
80102484:	53                   	push   %ebx
80102485:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102488:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
8010248b:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010248e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102494:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010249a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801024a0:	39 de                	cmp    %ebx,%esi
801024a2:	73 08                	jae    801024ac <kinit2+0x2c>
801024a4:	eb 18                	jmp    801024be <kinit2+0x3e>
801024a6:	66 90                	xchg   %ax,%ax
801024a8:	89 da                	mov    %ebx,%edx
801024aa:	89 c3                	mov    %eax,%ebx
    kfree(p);
801024ac:	89 14 24             	mov    %edx,(%esp)
801024af:	e8 6c fe ff ff       	call   80102320 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801024ba:	39 c6                	cmp    %eax,%esi
801024bc:	73 ea                	jae    801024a8 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
801024be:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
801024c5:	00 00 00 
}
801024c8:	83 c4 10             	add    $0x10,%esp
801024cb:	5b                   	pop    %ebx
801024cc:	5e                   	pop    %esi
801024cd:	5d                   	pop    %ebp
801024ce:	c3                   	ret    
801024cf:	90                   	nop

801024d0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	53                   	push   %ebx
801024d4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024d7:	a1 94 26 11 80       	mov    0x80112694,%eax
801024dc:	85 c0                	test   %eax,%eax
801024de:	75 30                	jne    80102510 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024e0:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
801024e6:	85 db                	test   %ebx,%ebx
801024e8:	74 08                	je     801024f2 <kalloc+0x22>
    kmem.freelist = r->next;
801024ea:	8b 13                	mov    (%ebx),%edx
801024ec:	89 15 98 26 11 80    	mov    %edx,0x80112698
  if(kmem.use_lock)
801024f2:	85 c0                	test   %eax,%eax
801024f4:	74 0c                	je     80102502 <kalloc+0x32>
    release(&kmem.lock);
801024f6:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801024fd:	e8 1e 1e 00 00       	call   80104320 <release>
  return (char*)r;
}
80102502:	83 c4 14             	add    $0x14,%esp
80102505:	89 d8                	mov    %ebx,%eax
80102507:	5b                   	pop    %ebx
80102508:	5d                   	pop    %ebp
80102509:	c3                   	ret    
8010250a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102510:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
80102517:	e8 d4 1c 00 00       	call   801041f0 <acquire>
8010251c:	a1 94 26 11 80       	mov    0x80112694,%eax
80102521:	eb bd                	jmp    801024e0 <kalloc+0x10>
80102523:	66 90                	xchg   %ax,%ax
80102525:	66 90                	xchg   %ax,%ax
80102527:	66 90                	xchg   %ax,%ax
80102529:	66 90                	xchg   %ax,%ax
8010252b:	66 90                	xchg   %ax,%ax
8010252d:	66 90                	xchg   %ax,%ax
8010252f:	90                   	nop

80102530 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102530:	ba 64 00 00 00       	mov    $0x64,%edx
80102535:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102536:	a8 01                	test   $0x1,%al
80102538:	0f 84 ba 00 00 00    	je     801025f8 <kbdgetc+0xc8>
8010253e:	b2 60                	mov    $0x60,%dl
80102540:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102541:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102544:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010254a:	0f 84 88 00 00 00    	je     801025d8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102550:	84 c0                	test   %al,%al
80102552:	79 2c                	jns    80102580 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102554:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010255a:	f6 c2 40             	test   $0x40,%dl
8010255d:	75 05                	jne    80102564 <kbdgetc+0x34>
8010255f:	89 c1                	mov    %eax,%ecx
80102561:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102564:	0f b6 81 c0 70 10 80 	movzbl -0x7fef8f40(%ecx),%eax
8010256b:	83 c8 40             	or     $0x40,%eax
8010256e:	0f b6 c0             	movzbl %al,%eax
80102571:	f7 d0                	not    %eax
80102573:	21 d0                	and    %edx,%eax
80102575:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010257a:	31 c0                	xor    %eax,%eax
8010257c:	c3                   	ret    
8010257d:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	53                   	push   %ebx
80102584:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010258a:	f6 c3 40             	test   $0x40,%bl
8010258d:	74 09                	je     80102598 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010258f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102592:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102595:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102598:	0f b6 91 c0 70 10 80 	movzbl -0x7fef8f40(%ecx),%edx
  shift ^= togglecode[data];
8010259f:	0f b6 81 c0 6f 10 80 	movzbl -0x7fef9040(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
801025a6:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801025a8:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801025aa:	89 d0                	mov    %edx,%eax
801025ac:	83 e0 03             	and    $0x3,%eax
801025af:	8b 04 85 a0 6f 10 80 	mov    -0x7fef9060(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801025b6:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
801025bc:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
801025bf:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801025c3:	74 0b                	je     801025d0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
801025c5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025c8:	83 fa 19             	cmp    $0x19,%edx
801025cb:	77 1b                	ja     801025e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025cd:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025d0:	5b                   	pop    %ebx
801025d1:	5d                   	pop    %ebp
801025d2:	c3                   	ret    
801025d3:	90                   	nop
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801025d8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801025df:	31 c0                	xor    %eax,%eax
801025e1:	c3                   	ret    
801025e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025eb:	8d 50 20             	lea    0x20(%eax),%edx
801025ee:	83 f9 19             	cmp    $0x19,%ecx
801025f1:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
801025f4:	eb da                	jmp    801025d0 <kbdgetc+0xa0>
801025f6:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025fd:	c3                   	ret    
801025fe:	66 90                	xchg   %ax,%ax

80102600 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
80102600:	55                   	push   %ebp
80102601:	89 e5                	mov    %esp,%ebp
80102603:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102606:	c7 04 24 30 25 10 80 	movl   $0x80102530,(%esp)
8010260d:	e8 9e e1 ff ff       	call   801007b0 <consoleintr>
}
80102612:	c9                   	leave  
80102613:	c3                   	ret    
80102614:	66 90                	xchg   %ax,%ax
80102616:	66 90                	xchg   %ax,%ax
80102618:	66 90                	xchg   %ax,%ax
8010261a:	66 90                	xchg   %ax,%ax
8010261c:	66 90                	xchg   %ax,%ax
8010261e:	66 90                	xchg   %ax,%ax

80102620 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
80102620:	55                   	push   %ebp
80102621:	89 c1                	mov    %eax,%ecx
80102623:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102625:	ba 70 00 00 00       	mov    $0x70,%edx
8010262a:	53                   	push   %ebx
8010262b:	31 c0                	xor    %eax,%eax
8010262d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010262e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102633:	89 da                	mov    %ebx,%edx
80102635:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102636:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102639:	b2 70                	mov    $0x70,%dl
8010263b:	89 01                	mov    %eax,(%ecx)
8010263d:	b8 02 00 00 00       	mov    $0x2,%eax
80102642:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102643:	89 da                	mov    %ebx,%edx
80102645:	ec                   	in     (%dx),%al
80102646:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102649:	b2 70                	mov    $0x70,%dl
8010264b:	89 41 04             	mov    %eax,0x4(%ecx)
8010264e:	b8 04 00 00 00       	mov    $0x4,%eax
80102653:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102654:	89 da                	mov    %ebx,%edx
80102656:	ec                   	in     (%dx),%al
80102657:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010265a:	b2 70                	mov    $0x70,%dl
8010265c:	89 41 08             	mov    %eax,0x8(%ecx)
8010265f:	b8 07 00 00 00       	mov    $0x7,%eax
80102664:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102665:	89 da                	mov    %ebx,%edx
80102667:	ec                   	in     (%dx),%al
80102668:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010266b:	b2 70                	mov    $0x70,%dl
8010266d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102670:	b8 08 00 00 00       	mov    $0x8,%eax
80102675:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102676:	89 da                	mov    %ebx,%edx
80102678:	ec                   	in     (%dx),%al
80102679:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010267c:	b2 70                	mov    $0x70,%dl
8010267e:	89 41 10             	mov    %eax,0x10(%ecx)
80102681:	b8 09 00 00 00       	mov    $0x9,%eax
80102686:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102687:	89 da                	mov    %ebx,%edx
80102689:	ec                   	in     (%dx),%al
8010268a:	0f b6 d8             	movzbl %al,%ebx
8010268d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102690:	5b                   	pop    %ebx
80102691:	5d                   	pop    %ebp
80102692:	c3                   	ret    
80102693:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026a0 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
801026a0:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}
//PAGEBREAK!

void
lapicinit(void)
{
801026a5:	55                   	push   %ebp
801026a6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801026a8:	85 c0                	test   %eax,%eax
801026aa:	0f 84 c0 00 00 00    	je     80102770 <lapicinit+0xd0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026b7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ba:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026bd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c7:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026ca:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026d1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026d4:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026de:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026e1:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026eb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ee:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026f8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026fb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026fe:	8b 50 30             	mov    0x30(%eax),%edx
80102701:	c1 ea 10             	shr    $0x10,%edx
80102704:	80 fa 03             	cmp    $0x3,%dl
80102707:	77 6f                	ja     80102778 <lapicinit+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102709:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102710:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102713:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102716:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010271d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102720:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102723:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010272a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010272d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102730:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102737:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010273a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010273d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102744:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102747:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010274a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102751:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102754:	8b 50 20             	mov    0x20(%eax),%edx
80102757:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102758:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010275e:	80 e6 10             	and    $0x10,%dh
80102761:	75 f5                	jne    80102758 <lapicinit+0xb8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102763:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010276a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010276d:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102770:	5d                   	pop    %ebp
80102771:	c3                   	ret    
80102772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102778:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010277f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102782:	8b 50 20             	mov    0x20(%eax),%edx
80102785:	eb 82                	jmp    80102709 <lapicinit+0x69>
80102787:	89 f6                	mov    %esi,%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
80102793:	56                   	push   %esi
80102794:	53                   	push   %ebx
80102795:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102798:	9c                   	pushf  
80102799:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
8010279a:	f6 c4 02             	test   $0x2,%ah
8010279d:	74 12                	je     801027b1 <cpunum+0x21>
    static int n;
    if(n++ == 0)
8010279f:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
801027a4:	8d 50 01             	lea    0x1(%eax),%edx
801027a7:	85 c0                	test   %eax,%eax
801027a9:	89 15 b8 a5 10 80    	mov    %edx,0x8010a5b8
801027af:	74 4a                	je     801027fb <cpunum+0x6b>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
801027b1:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801027b6:	85 c0                	test   %eax,%eax
801027b8:	74 5d                	je     80102817 <cpunum+0x87>
    return 0;

  apicid = lapic[ID] >> 24;
801027ba:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
801027bd:	8b 35 80 2d 11 80    	mov    0x80112d80,%esi
  }

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
801027c3:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
801027c6:	85 f6                	test   %esi,%esi
801027c8:	7e 56                	jle    80102820 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
801027ca:	0f b6 05 a0 27 11 80 	movzbl 0x801127a0,%eax
801027d1:	39 d8                	cmp    %ebx,%eax
801027d3:	74 42                	je     80102817 <cpunum+0x87>
801027d5:	ba 5c 28 11 80       	mov    $0x8011285c,%edx

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
801027da:	31 c0                	xor    %eax,%eax
801027dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027e0:	83 c0 01             	add    $0x1,%eax
801027e3:	39 f0                	cmp    %esi,%eax
801027e5:	74 39                	je     80102820 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
801027e7:	0f b6 0a             	movzbl (%edx),%ecx
801027ea:	81 c2 bc 00 00 00    	add    $0xbc,%edx
801027f0:	39 d9                	cmp    %ebx,%ecx
801027f2:	75 ec                	jne    801027e0 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
801027f4:	83 c4 10             	add    $0x10,%esp
801027f7:	5b                   	pop    %ebx
801027f8:	5e                   	pop    %esi
801027f9:	5d                   	pop    %ebp
801027fa:	c3                   	ret    
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
801027fb:	8b 45 04             	mov    0x4(%ebp),%eax
801027fe:	c7 04 24 c0 71 10 80 	movl   $0x801071c0,(%esp)
80102805:	89 44 24 04          	mov    %eax,0x4(%esp)
80102809:	e8 42 de ff ff       	call   80100650 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
8010280e:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102813:	85 c0                	test   %eax,%eax
80102815:	75 a3                	jne    801027ba <cpunum+0x2a>
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
80102817:	83 c4 10             	add    $0x10,%esp
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
    return 0;
8010281a:	31 c0                	xor    %eax,%eax
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
8010281c:	5b                   	pop    %ebx
8010281d:	5e                   	pop    %esi
8010281e:	5d                   	pop    %ebp
8010281f:	c3                   	ret    
  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
80102820:	c7 04 24 ec 71 10 80 	movl   $0x801071ec,(%esp)
80102827:	e8 34 db ff ff       	call   80100360 <panic>
8010282c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102830 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102830:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102835:	55                   	push   %ebp
80102836:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102838:	85 c0                	test   %eax,%eax
8010283a:	74 0d                	je     80102849 <lapiceoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010283c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102843:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102846:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102849:	5d                   	pop    %ebp
8010284a:	c3                   	ret    
8010284b:	90                   	nop
8010284c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102850 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102850:	55                   	push   %ebp
80102851:	89 e5                	mov    %esp,%ebp
}
80102853:	5d                   	pop    %ebp
80102854:	c3                   	ret    
80102855:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102860 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102860:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102861:	ba 70 00 00 00       	mov    $0x70,%edx
80102866:	89 e5                	mov    %esp,%ebp
80102868:	b8 0f 00 00 00       	mov    $0xf,%eax
8010286d:	53                   	push   %ebx
8010286e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102871:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80102874:	ee                   	out    %al,(%dx)
80102875:	b8 0a 00 00 00       	mov    $0xa,%eax
8010287a:	b2 71                	mov    $0x71,%dl
8010287c:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
8010287d:	31 c0                	xor    %eax,%eax
8010287f:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102885:	89 d8                	mov    %ebx,%eax
80102887:	c1 e8 04             	shr    $0x4,%eax
8010288a:	66 a3 69 04 00 80    	mov    %ax,0x80000469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102890:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102895:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102898:	c1 eb 0c             	shr    $0xc,%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010289b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028a1:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028a4:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801028ab:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ae:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028b1:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801028b8:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028bb:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028be:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028c4:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801028c7:	89 da                	mov    %ebx,%edx
801028c9:	80 ce 06             	or     $0x6,%dh
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028cc:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028d2:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028d5:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028db:	8b 48 20             	mov    0x20(%eax),%ecx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028de:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028e4:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801028e7:	5b                   	pop    %ebx
801028e8:	5d                   	pop    %ebp
801028e9:	c3                   	ret    
801028ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028f0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801028f0:	55                   	push   %ebp
801028f1:	ba 70 00 00 00       	mov    $0x70,%edx
801028f6:	89 e5                	mov    %esp,%ebp
801028f8:	b8 0b 00 00 00       	mov    $0xb,%eax
801028fd:	57                   	push   %edi
801028fe:	56                   	push   %esi
801028ff:	53                   	push   %ebx
80102900:	83 ec 4c             	sub    $0x4c,%esp
80102903:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102904:	b2 71                	mov    $0x71,%dl
80102906:	ec                   	in     (%dx),%al
80102907:	88 45 b7             	mov    %al,-0x49(%ebp)
8010290a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010290d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102911:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102918:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010291d:	89 d8                	mov    %ebx,%eax
8010291f:	e8 fc fc ff ff       	call   80102620 <fill_rtcdate>
80102924:	b8 0a 00 00 00       	mov    $0xa,%eax
80102929:	89 f2                	mov    %esi,%edx
8010292b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010292c:	ba 71 00 00 00       	mov    $0x71,%edx
80102931:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102932:	84 c0                	test   %al,%al
80102934:	78 e7                	js     8010291d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102936:	89 f8                	mov    %edi,%eax
80102938:	e8 e3 fc ff ff       	call   80102620 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010293d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102944:	00 
80102945:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102949:	89 1c 24             	mov    %ebx,(%esp)
8010294c:	e8 6f 1a 00 00       	call   801043c0 <memcmp>
80102951:	85 c0                	test   %eax,%eax
80102953:	75 c3                	jne    80102918 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102955:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102959:	75 78                	jne    801029d3 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010295b:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010295e:	89 c2                	mov    %eax,%edx
80102960:	83 e0 0f             	and    $0xf,%eax
80102963:	c1 ea 04             	shr    $0x4,%edx
80102966:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102969:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010296c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010296f:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102972:	89 c2                	mov    %eax,%edx
80102974:	83 e0 0f             	and    $0xf,%eax
80102977:	c1 ea 04             	shr    $0x4,%edx
8010297a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010297d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102980:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102983:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102986:	89 c2                	mov    %eax,%edx
80102988:	83 e0 0f             	and    $0xf,%eax
8010298b:	c1 ea 04             	shr    $0x4,%edx
8010298e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102991:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102994:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102997:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010299a:	89 c2                	mov    %eax,%edx
8010299c:	83 e0 0f             	and    $0xf,%eax
8010299f:	c1 ea 04             	shr    $0x4,%edx
801029a2:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029a5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029a8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029ab:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029ae:	89 c2                	mov    %eax,%edx
801029b0:	83 e0 0f             	and    $0xf,%eax
801029b3:	c1 ea 04             	shr    $0x4,%edx
801029b6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029b9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029bc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029c2:	89 c2                	mov    %eax,%edx
801029c4:	83 e0 0f             	and    $0xf,%eax
801029c7:	c1 ea 04             	shr    $0x4,%edx
801029ca:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029cd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
801029d6:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029d9:	89 01                	mov    %eax,(%ecx)
801029db:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029de:	89 41 04             	mov    %eax,0x4(%ecx)
801029e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029e4:	89 41 08             	mov    %eax,0x8(%ecx)
801029e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029ea:	89 41 0c             	mov    %eax,0xc(%ecx)
801029ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029f0:	89 41 10             	mov    %eax,0x10(%ecx)
801029f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029f6:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
801029f9:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102a00:	83 c4 4c             	add    $0x4c,%esp
80102a03:	5b                   	pop    %ebx
80102a04:	5e                   	pop    %esi
80102a05:	5f                   	pop    %edi
80102a06:	5d                   	pop    %ebp
80102a07:	c3                   	ret    
80102a08:	66 90                	xchg   %ax,%ax
80102a0a:	66 90                	xchg   %ax,%ax
80102a0c:	66 90                	xchg   %ax,%ax
80102a0e:	66 90                	xchg   %ax,%ax

80102a10 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102a10:	55                   	push   %ebp
80102a11:	89 e5                	mov    %esp,%ebp
80102a13:	57                   	push   %edi
80102a14:	56                   	push   %esi
80102a15:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a16:	31 db                	xor    %ebx,%ebx
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102a18:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a1b:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102a20:	85 c0                	test   %eax,%eax
80102a22:	7e 78                	jle    80102a9c <install_trans+0x8c>
80102a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a28:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102a2d:	01 d8                	add    %ebx,%eax
80102a2f:	83 c0 01             	add    $0x1,%eax
80102a32:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a36:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102a3b:	89 04 24             	mov    %eax,(%esp)
80102a3e:	e8 8d d6 ff ff       	call   801000d0 <bread>
80102a43:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a45:	8b 04 9d ec 26 11 80 	mov    -0x7feed914(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a4c:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a53:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102a58:	89 04 24             	mov    %eax,(%esp)
80102a5b:	e8 70 d6 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a60:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102a67:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a68:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a6a:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a6d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a71:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a74:	89 04 24             	mov    %eax,(%esp)
80102a77:	e8 94 19 00 00       	call   80104410 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a7c:	89 34 24             	mov    %esi,(%esp)
80102a7f:	e8 1c d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a84:	89 3c 24             	mov    %edi,(%esp)
80102a87:	e8 54 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a8c:	89 34 24             	mov    %esi,(%esp)
80102a8f:	e8 4c d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a94:	39 1d e8 26 11 80    	cmp    %ebx,0x801126e8
80102a9a:	7f 8c                	jg     80102a28 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a9c:	83 c4 1c             	add    $0x1c,%esp
80102a9f:	5b                   	pop    %ebx
80102aa0:	5e                   	pop    %esi
80102aa1:	5f                   	pop    %edi
80102aa2:	5d                   	pop    %ebp
80102aa3:	c3                   	ret    
80102aa4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102aaa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102ab0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ab0:	55                   	push   %ebp
80102ab1:	89 e5                	mov    %esp,%ebp
80102ab3:	57                   	push   %edi
80102ab4:	56                   	push   %esi
80102ab5:	53                   	push   %ebx
80102ab6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ab9:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102abe:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ac2:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102ac7:	89 04 24             	mov    %eax,(%esp)
80102aca:	e8 01 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102acf:	8b 1d e8 26 11 80    	mov    0x801126e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102ad5:	31 d2                	xor    %edx,%edx
80102ad7:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102ad9:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102adb:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102ade:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ae1:	7e 17                	jle    80102afa <write_head+0x4a>
80102ae3:	90                   	nop
80102ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102ae8:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102aef:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102af3:	83 c2 01             	add    $0x1,%edx
80102af6:	39 da                	cmp    %ebx,%edx
80102af8:	75 ee                	jne    80102ae8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102afa:	89 3c 24             	mov    %edi,(%esp)
80102afd:	e8 9e d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b02:	89 3c 24             	mov    %edi,(%esp)
80102b05:	e8 d6 d6 ff ff       	call   801001e0 <brelse>
}
80102b0a:	83 c4 1c             	add    $0x1c,%esp
80102b0d:	5b                   	pop    %ebx
80102b0e:	5e                   	pop    %esi
80102b0f:	5f                   	pop    %edi
80102b10:	5d                   	pop    %ebp
80102b11:	c3                   	ret    
80102b12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b20 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	56                   	push   %esi
80102b24:	53                   	push   %ebx
80102b25:	83 ec 30             	sub    $0x30,%esp
80102b28:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102b2b:	c7 44 24 04 fc 71 10 	movl   $0x801071fc,0x4(%esp)
80102b32:	80 
80102b33:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102b3a:	e8 31 16 00 00       	call   80104170 <initlock>
  readsb(dev, &sb);
80102b3f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b42:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b46:	89 1c 24             	mov    %ebx,(%esp)
80102b49:	e8 82 e8 ff ff       	call   801013d0 <readsb>
  log.start = sb.logstart;
80102b4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102b51:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b54:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102b57:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b5d:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b61:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b67:	a3 d4 26 11 80       	mov    %eax,0x801126d4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b6c:	e8 5f d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b71:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b73:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102b76:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102b79:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b7b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102b81:	7e 17                	jle    80102b9a <initlog+0x7a>
80102b83:	90                   	nop
80102b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102b88:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102b8c:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b93:	83 c2 01             	add    $0x1,%edx
80102b96:	39 da                	cmp    %ebx,%edx
80102b98:	75 ee                	jne    80102b88 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b9a:	89 04 24             	mov    %eax,(%esp)
80102b9d:	e8 3e d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102ba2:	e8 69 fe ff ff       	call   80102a10 <install_trans>
  log.lh.n = 0;
80102ba7:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102bae:	00 00 00 
  write_head(); // clear the log
80102bb1:	e8 fa fe ff ff       	call   80102ab0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102bb6:	83 c4 30             	add    $0x30,%esp
80102bb9:	5b                   	pop    %ebx
80102bba:	5e                   	pop    %esi
80102bbb:	5d                   	pop    %ebp
80102bbc:	c3                   	ret    
80102bbd:	8d 76 00             	lea    0x0(%esi),%esi

80102bc0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102bc6:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102bcd:	e8 1e 16 00 00       	call   801041f0 <acquire>
80102bd2:	eb 18                	jmp    80102bec <begin_op+0x2c>
80102bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bd8:	c7 44 24 04 a0 26 11 	movl   $0x801126a0,0x4(%esp)
80102bdf:	80 
80102be0:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102be7:	e8 24 11 00 00       	call   80103d10 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102bec:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102bf1:	85 c0                	test   %eax,%eax
80102bf3:	75 e3                	jne    80102bd8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bf5:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102bfa:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102c00:	83 c0 01             	add    $0x1,%eax
80102c03:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c06:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c09:	83 fa 1e             	cmp    $0x1e,%edx
80102c0c:	7f ca                	jg     80102bd8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c0e:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102c15:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102c1a:	e8 01 17 00 00       	call   80104320 <release>
      break;
    }
  }
}
80102c1f:	c9                   	leave  
80102c20:	c3                   	ret    
80102c21:	eb 0d                	jmp    80102c30 <end_op>
80102c23:	90                   	nop
80102c24:	90                   	nop
80102c25:	90                   	nop
80102c26:	90                   	nop
80102c27:	90                   	nop
80102c28:	90                   	nop
80102c29:	90                   	nop
80102c2a:	90                   	nop
80102c2b:	90                   	nop
80102c2c:	90                   	nop
80102c2d:	90                   	nop
80102c2e:	90                   	nop
80102c2f:	90                   	nop

80102c30 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c30:	55                   	push   %ebp
80102c31:	89 e5                	mov    %esp,%ebp
80102c33:	57                   	push   %edi
80102c34:	56                   	push   %esi
80102c35:	53                   	push   %ebx
80102c36:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c39:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102c40:	e8 ab 15 00 00       	call   801041f0 <acquire>
  log.outstanding -= 1;
80102c45:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102c4a:	8b 15 e0 26 11 80    	mov    0x801126e0,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c50:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c53:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c55:	a3 dc 26 11 80       	mov    %eax,0x801126dc
  if(log.committing)
80102c5a:	0f 85 f3 00 00 00    	jne    80102d53 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102c60:	85 c0                	test   %eax,%eax
80102c62:	0f 85 cb 00 00 00    	jne    80102d33 <end_op+0x103>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c68:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c6f:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102c71:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102c78:	00 00 00 
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c7b:	e8 a0 16 00 00       	call   80104320 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c80:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102c85:	85 c0                	test   %eax,%eax
80102c87:	0f 8e 90 00 00 00    	jle    80102d1d <end_op+0xed>
80102c8d:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c90:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102c95:	01 d8                	add    %ebx,%eax
80102c97:	83 c0 01             	add    $0x1,%eax
80102c9a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c9e:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102ca3:	89 04 24             	mov    %eax,(%esp)
80102ca6:	e8 25 d4 ff ff       	call   801000d0 <bread>
80102cab:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cad:	8b 04 9d ec 26 11 80 	mov    -0x7feed914(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cb4:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80102cbb:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102cc0:	89 04 24             	mov    %eax,(%esp)
80102cc3:	e8 08 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102cc8:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102ccf:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cd0:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102cd2:	8d 40 5c             	lea    0x5c(%eax),%eax
80102cd5:	89 44 24 04          	mov    %eax,0x4(%esp)
80102cd9:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cdc:	89 04 24             	mov    %eax,(%esp)
80102cdf:	e8 2c 17 00 00       	call   80104410 <memmove>
    bwrite(to);  // write the log
80102ce4:	89 34 24             	mov    %esi,(%esp)
80102ce7:	e8 b4 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cec:	89 3c 24             	mov    %edi,(%esp)
80102cef:	e8 ec d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102cf4:	89 34 24             	mov    %esi,(%esp)
80102cf7:	e8 e4 d4 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cfc:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102d02:	7c 8c                	jl     80102c90 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d04:	e8 a7 fd ff ff       	call   80102ab0 <write_head>
    install_trans(); // Now install writes to home locations
80102d09:	e8 02 fd ff ff       	call   80102a10 <install_trans>
    log.lh.n = 0;
80102d0e:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d15:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d18:	e8 93 fd ff ff       	call   80102ab0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102d1d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d24:	e8 c7 14 00 00       	call   801041f0 <acquire>
    log.committing = 0;
80102d29:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102d30:	00 00 00 
    wakeup(&log);
80102d33:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d3a:	e8 71 11 00 00       	call   80103eb0 <wakeup>
    release(&log.lock);
80102d3f:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d46:	e8 d5 15 00 00       	call   80104320 <release>
  }
}
80102d4b:	83 c4 1c             	add    $0x1c,%esp
80102d4e:	5b                   	pop    %ebx
80102d4f:	5e                   	pop    %esi
80102d50:	5f                   	pop    %edi
80102d51:	5d                   	pop    %ebp
80102d52:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d53:	c7 04 24 00 72 10 80 	movl   $0x80107200,(%esp)
80102d5a:	e8 01 d6 ff ff       	call   80100360 <panic>
80102d5f:	90                   	nop

80102d60 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	53                   	push   %ebx
80102d64:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d67:	a1 e8 26 11 80       	mov    0x801126e8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d6f:	83 f8 1d             	cmp    $0x1d,%eax
80102d72:	0f 8f 98 00 00 00    	jg     80102e10 <log_write+0xb0>
80102d78:	8b 0d d8 26 11 80    	mov    0x801126d8,%ecx
80102d7e:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102d81:	39 d0                	cmp    %edx,%eax
80102d83:	0f 8d 87 00 00 00    	jge    80102e10 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d89:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102d8e:	85 c0                	test   %eax,%eax
80102d90:	0f 8e 86 00 00 00    	jle    80102e1c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d96:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d9d:	e8 4e 14 00 00       	call   801041f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102da2:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102da8:	83 fa 00             	cmp    $0x0,%edx
80102dab:	7e 54                	jle    80102e01 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dad:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102db0:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102db2:	39 0d ec 26 11 80    	cmp    %ecx,0x801126ec
80102db8:	75 0f                	jne    80102dc9 <log_write+0x69>
80102dba:	eb 3c                	jmp    80102df8 <log_write+0x98>
80102dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dc0:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102dc7:	74 2f                	je     80102df8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102dc9:	83 c0 01             	add    $0x1,%eax
80102dcc:	39 d0                	cmp    %edx,%eax
80102dce:	75 f0                	jne    80102dc0 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102dd0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102dd7:	83 c2 01             	add    $0x1,%edx
80102dda:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
  b->flags |= B_DIRTY; // prevent eviction
80102de0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102de3:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102dea:	83 c4 14             	add    $0x14,%esp
80102ded:	5b                   	pop    %ebx
80102dee:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102def:	e9 2c 15 00 00       	jmp    80104320 <release>
80102df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102df8:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
80102dff:	eb df                	jmp    80102de0 <log_write+0x80>
80102e01:	8b 43 08             	mov    0x8(%ebx),%eax
80102e04:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102e09:	75 d5                	jne    80102de0 <log_write+0x80>
80102e0b:	eb ca                	jmp    80102dd7 <log_write+0x77>
80102e0d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102e10:	c7 04 24 0f 72 10 80 	movl   $0x8010720f,(%esp)
80102e17:	e8 44 d5 ff ff       	call   80100360 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102e1c:	c7 04 24 25 72 10 80 	movl   $0x80107225,(%esp)
80102e23:	e8 38 d5 ff ff       	call   80100360 <panic>
80102e28:	66 90                	xchg   %ax,%ax
80102e2a:	66 90                	xchg   %ax,%ax
80102e2c:	66 90                	xchg   %ax,%ax
80102e2e:	66 90                	xchg   %ax,%ax

80102e30 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpunum());
80102e36:	e8 55 f9 ff ff       	call   80102790 <cpunum>
80102e3b:	c7 04 24 40 72 10 80 	movl   $0x80107240,(%esp)
80102e42:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e46:	e8 05 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102e4b:	e8 50 27 00 00       	call   801055a0 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102e50:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e57:	b8 01 00 00 00       	mov    $0x1,%eax
80102e5c:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102e63:	e8 f8 0b 00 00       	call   80103a60 <scheduler>
80102e68:	90                   	nop
80102e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e70 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e76:	e8 15 39 00 00       	call   80106790 <switchkvm>
  seginit();
80102e7b:	e8 30 37 00 00       	call   801065b0 <seginit>
  lapicinit();
80102e80:	e8 1b f8 ff ff       	call   801026a0 <lapicinit>
  mpmain();
80102e85:	e8 a6 ff ff ff       	call   80102e30 <mpmain>
80102e8a:	66 90                	xchg   %ax,%ax
80102e8c:	66 90                	xchg   %ax,%ax
80102e8e:	66 90                	xchg   %ax,%ax

80102e90 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	53                   	push   %ebx
80102e94:	83 e4 f0             	and    $0xfffffff0,%esp
80102e97:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e9a:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102ea1:	80 
80102ea2:	c7 04 24 28 55 11 80 	movl   $0x80115528,(%esp)
80102ea9:	e8 62 f5 ff ff       	call   80102410 <kinit1>
  kvmalloc();      // kernel page table
80102eae:	e8 bd 38 00 00       	call   80106770 <kvmalloc>
  mpinit();        // detect other processors
80102eb3:	e8 a8 01 00 00       	call   80103060 <mpinit>
  lapicinit();     // interrupt controller
80102eb8:	e8 e3 f7 ff ff       	call   801026a0 <lapicinit>
80102ebd:	8d 76 00             	lea    0x0(%esi),%esi
  seginit();       // segment descriptors
80102ec0:	e8 eb 36 00 00       	call   801065b0 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80102ec5:	e8 c6 f8 ff ff       	call   80102790 <cpunum>
80102eca:	c7 04 24 51 72 10 80 	movl   $0x80107251,(%esp)
80102ed1:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ed5:	e8 76 d7 ff ff       	call   80100650 <cprintf>
  picinit();       // another interrupt controller
80102eda:	e8 81 03 00 00       	call   80103260 <picinit>
  ioapicinit();    // another interrupt controller
80102edf:	e8 4c f3 ff ff       	call   80102230 <ioapicinit>
  consoleinit();   // console hardware
80102ee4:	e8 67 da ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102ee9:	e8 d2 29 00 00       	call   801058c0 <uartinit>
80102eee:	66 90                	xchg   %ax,%ax
  pinit();         // process table
80102ef0:	e8 9b 08 00 00       	call   80103790 <pinit>
  tvinit();        // trap vectors
80102ef5:	e8 06 26 00 00       	call   80105500 <tvinit>
  binit();         // buffer cache
80102efa:	e8 41 d1 ff ff       	call   80100040 <binit>
80102eff:	90                   	nop
  fileinit();      // file table
80102f00:	e8 7b de ff ff       	call   80100d80 <fileinit>
  ideinit();       // disk
80102f05:	e8 16 f1 ff ff       	call   80102020 <ideinit>
  if(!ismp)
80102f0a:	a1 84 27 11 80       	mov    0x80112784,%eax
80102f0f:	85 c0                	test   %eax,%eax
80102f11:	0f 84 ca 00 00 00    	je     80102fe1 <main+0x151>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f17:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102f1e:	00 

  for(c = cpus; c < cpus+ncpu; c++){
80102f1f:	bb a0 27 11 80       	mov    $0x801127a0,%ebx

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f24:	c7 44 24 04 90 a4 10 	movl   $0x8010a490,0x4(%esp)
80102f2b:	80 
80102f2c:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102f33:	e8 d8 14 00 00       	call   80104410 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f38:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80102f3f:	00 00 00 
80102f42:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f47:	39 d8                	cmp    %ebx,%eax
80102f49:	76 78                	jbe    80102fc3 <main+0x133>
80102f4b:	90                   	nop
80102f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == cpus+cpunum())  // We've started already.
80102f50:	e8 3b f8 ff ff       	call   80102790 <cpunum>
80102f55:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80102f5b:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f60:	39 c3                	cmp    %eax,%ebx
80102f62:	74 46                	je     80102faa <main+0x11a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f64:	e8 67 f5 ff ff       	call   801024d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102f69:	c7 05 f8 6f 00 80 70 	movl   $0x80102e70,0x80006ff8
80102f70:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f73:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f7a:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f7d:	05 00 10 00 00       	add    $0x1000,%eax
80102f82:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f87:	0f b6 03             	movzbl (%ebx),%eax
80102f8a:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102f91:	00 
80102f92:	89 04 24             	mov    %eax,(%esp)
80102f95:	e8 c6 f8 ff ff       	call   80102860 <lapicstartap>
80102f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fa0:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80102fa6:	85 c0                	test   %eax,%eax
80102fa8:	74 f6                	je     80102fa0 <main+0x110>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102faa:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80102fb1:	00 00 00 
80102fb4:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
80102fba:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102fbf:	39 c3                	cmp    %eax,%ebx
80102fc1:	72 8d                	jb     80102f50 <main+0xc0>
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fc3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102fca:	8e 
80102fcb:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102fd2:	e8 a9 f4 ff ff       	call   80102480 <kinit2>
  userinit();      // first user process
80102fd7:	e8 d4 07 00 00       	call   801037b0 <userinit>
  mpmain();        // finish this processor's setup
80102fdc:	e8 4f fe ff ff       	call   80102e30 <mpmain>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
80102fe1:	e8 ba 24 00 00       	call   801054a0 <timerinit>
80102fe6:	e9 2c ff ff ff       	jmp    80102f17 <main+0x87>
80102feb:	66 90                	xchg   %ax,%ax
80102fed:	66 90                	xchg   %ax,%ax
80102fef:	90                   	nop

80102ff0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102ff4:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102ffa:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102ffb:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102ffe:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103001:	39 de                	cmp    %ebx,%esi
80103003:	73 3c                	jae    80103041 <mpsearch1+0x51>
80103005:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103008:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010300f:	00 
80103010:	c7 44 24 04 68 72 10 	movl   $0x80107268,0x4(%esp)
80103017:	80 
80103018:	89 34 24             	mov    %esi,(%esp)
8010301b:	e8 a0 13 00 00       	call   801043c0 <memcmp>
80103020:	85 c0                	test   %eax,%eax
80103022:	75 16                	jne    8010303a <mpsearch1+0x4a>
80103024:	31 c9                	xor    %ecx,%ecx
80103026:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103028:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010302c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010302f:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103031:	83 fa 10             	cmp    $0x10,%edx
80103034:	75 f2                	jne    80103028 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103036:	84 c9                	test   %cl,%cl
80103038:	74 10                	je     8010304a <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
8010303a:	83 c6 10             	add    $0x10,%esi
8010303d:	39 f3                	cmp    %esi,%ebx
8010303f:	77 c7                	ja     80103008 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80103041:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103044:	31 c0                	xor    %eax,%eax
}
80103046:	5b                   	pop    %ebx
80103047:	5e                   	pop    %esi
80103048:	5d                   	pop    %ebp
80103049:	c3                   	ret    
8010304a:	83 c4 10             	add    $0x10,%esp
8010304d:	89 f0                	mov    %esi,%eax
8010304f:	5b                   	pop    %ebx
80103050:	5e                   	pop    %esi
80103051:	5d                   	pop    %ebp
80103052:	c3                   	ret    
80103053:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
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
80103083:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010308a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103091:	c1 e0 08             	shl    $0x8,%eax
80103094:	09 d0                	or     %edx,%eax
80103096:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103099:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010309e:	ba 00 04 00 00       	mov    $0x400,%edx
801030a3:	e8 48 ff ff ff       	call   80102ff0 <mpsearch1>
801030a8:	85 c0                	test   %eax,%eax
801030aa:	89 c7                	mov    %eax,%edi
801030ac:	0f 84 4e 01 00 00    	je     80103200 <mpinit+0x1a0>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030b2:	8b 77 04             	mov    0x4(%edi),%esi
801030b5:	85 f6                	test   %esi,%esi
801030b7:	0f 84 ce 00 00 00    	je     8010318b <mpinit+0x12b>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030bd:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801030c3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801030ca:	00 
801030cb:	c7 44 24 04 6d 72 10 	movl   $0x8010726d,0x4(%esp)
801030d2:	80 
801030d3:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801030d9:	e8 e2 12 00 00       	call   801043c0 <memcmp>
801030de:	85 c0                	test   %eax,%eax
801030e0:	0f 85 a5 00 00 00    	jne    8010318b <mpinit+0x12b>
    return 0;
  if(conf->version != 1 && conf->version != 4)
801030e6:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801030ed:	3c 04                	cmp    $0x4,%al
801030ef:	0f 85 29 01 00 00    	jne    8010321e <mpinit+0x1be>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030f5:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030fc:	85 c0                	test   %eax,%eax
801030fe:	74 1d                	je     8010311d <mpinit+0xbd>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
80103100:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103102:	31 d2                	xor    %edx,%edx
80103104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103108:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010310f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103110:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103113:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103115:	39 d0                	cmp    %edx,%eax
80103117:	7f ef                	jg     80103108 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103119:	84 c9                	test   %cl,%cl
8010311b:	75 6e                	jne    8010318b <mpinit+0x12b>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
8010311d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103120:	85 db                	test   %ebx,%ebx
80103122:	74 67                	je     8010318b <mpinit+0x12b>
    return;
  ismp = 1;
80103124:	c7 05 84 27 11 80 01 	movl   $0x1,0x80112784
8010312b:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
8010312e:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103134:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103139:	0f b7 8e 04 00 00 80 	movzwl -0x7ffffffc(%esi),%ecx
80103140:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103146:	01 d9                	add    %ebx,%ecx
80103148:	39 c8                	cmp    %ecx,%eax
8010314a:	0f 83 90 00 00 00    	jae    801031e0 <mpinit+0x180>
    switch(*p){
80103150:	80 38 04             	cmpb   $0x4,(%eax)
80103153:	77 7b                	ja     801031d0 <mpinit+0x170>
80103155:	0f b6 10             	movzbl (%eax),%edx
80103158:	ff 24 95 74 72 10 80 	jmp    *-0x7fef8d8c(,%edx,4)
8010315f:	90                   	nop
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103160:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103163:	39 c1                	cmp    %eax,%ecx
80103165:	77 e9                	ja     80103150 <mpinit+0xf0>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
80103167:	a1 84 27 11 80       	mov    0x80112784,%eax
8010316c:	85 c0                	test   %eax,%eax
8010316e:	75 70                	jne    801031e0 <mpinit+0x180>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103170:	c7 05 80 2d 11 80 01 	movl   $0x1,0x80112d80
80103177:	00 00 00 
    lapic = 0;
8010317a:	c7 05 9c 26 11 80 00 	movl   $0x0,0x8011269c
80103181:	00 00 00 
    ioapicid = 0;
80103184:	c6 05 80 27 11 80 00 	movb   $0x0,0x80112780
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010318b:	83 c4 1c             	add    $0x1c,%esp
8010318e:	5b                   	pop    %ebx
8010318f:	5e                   	pop    %esi
80103190:	5f                   	pop    %edi
80103191:	5d                   	pop    %ebp
80103192:	c3                   	ret    
80103193:	90                   	nop
80103194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103198:	8b 15 80 2d 11 80    	mov    0x80112d80,%edx
8010319e:	83 fa 07             	cmp    $0x7,%edx
801031a1:	7f 17                	jg     801031ba <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031a3:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
801031a7:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
        ncpu++;
801031ad:	83 05 80 2d 11 80 01 	addl   $0x1,0x80112d80
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031b4:	88 9a a0 27 11 80    	mov    %bl,-0x7feed860(%edx)
        ncpu++;
      }
      p += sizeof(struct mpproc);
801031ba:	83 c0 14             	add    $0x14,%eax
      continue;
801031bd:	eb a4                	jmp    80103163 <mpinit+0x103>
801031bf:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801031c0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031c4:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801031c7:	88 15 80 27 11 80    	mov    %dl,0x80112780
      p += sizeof(struct mpioapic);
      continue;
801031cd:	eb 94                	jmp    80103163 <mpinit+0x103>
801031cf:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801031d0:	c7 05 84 27 11 80 00 	movl   $0x0,0x80112784
801031d7:	00 00 00 
      break;
801031da:	eb 87                	jmp    80103163 <mpinit+0x103>
801031dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
801031e0:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801031e4:	74 a5                	je     8010318b <mpinit+0x12b>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031e6:	ba 22 00 00 00       	mov    $0x22,%edx
801031eb:	b8 70 00 00 00       	mov    $0x70,%eax
801031f0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031f1:	b2 23                	mov    $0x23,%dl
801031f3:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031f4:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031f7:	ee                   	out    %al,(%dx)
  }
}
801031f8:	83 c4 1c             	add    $0x1c,%esp
801031fb:	5b                   	pop    %ebx
801031fc:	5e                   	pop    %esi
801031fd:	5f                   	pop    %edi
801031fe:	5d                   	pop    %ebp
801031ff:	c3                   	ret    
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103200:	ba 00 00 01 00       	mov    $0x10000,%edx
80103205:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010320a:	e8 e1 fd ff ff       	call   80102ff0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010320f:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103211:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103213:	0f 85 99 fe ff ff    	jne    801030b2 <mpinit+0x52>
80103219:	e9 6d ff ff ff       	jmp    8010318b <mpinit+0x12b>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
8010321e:	3c 01                	cmp    $0x1,%al
80103220:	0f 84 cf fe ff ff    	je     801030f5 <mpinit+0x95>
80103226:	e9 60 ff ff ff       	jmp    8010318b <mpinit+0x12b>
8010322b:	66 90                	xchg   %ax,%ax
8010322d:	66 90                	xchg   %ax,%ax
8010322f:	90                   	nop

80103230 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103230:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
80103231:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103236:	89 e5                	mov    %esp,%ebp
80103238:	ba 21 00 00 00       	mov    $0x21,%edx
  picsetmask(irqmask & ~(1<<irq));
8010323d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103240:	d3 c0                	rol    %cl,%eax
80103242:	66 23 05 00 a0 10 80 	and    0x8010a000,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
80103249:	66 a3 00 a0 10 80    	mov    %ax,0x8010a000
8010324f:	ee                   	out    %al,(%dx)
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
80103250:	66 c1 e8 08          	shr    $0x8,%ax
80103254:	b2 a1                	mov    $0xa1,%dl
80103256:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
80103257:	5d                   	pop    %ebp
80103258:	c3                   	ret    
80103259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103260 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103260:	55                   	push   %ebp
80103261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103266:	89 e5                	mov    %esp,%ebp
80103268:	57                   	push   %edi
80103269:	56                   	push   %esi
8010326a:	53                   	push   %ebx
8010326b:	bb 21 00 00 00       	mov    $0x21,%ebx
80103270:	89 da                	mov    %ebx,%edx
80103272:	ee                   	out    %al,(%dx)
80103273:	b9 a1 00 00 00       	mov    $0xa1,%ecx
80103278:	89 ca                	mov    %ecx,%edx
8010327a:	ee                   	out    %al,(%dx)
8010327b:	bf 11 00 00 00       	mov    $0x11,%edi
80103280:	be 20 00 00 00       	mov    $0x20,%esi
80103285:	89 f8                	mov    %edi,%eax
80103287:	89 f2                	mov    %esi,%edx
80103289:	ee                   	out    %al,(%dx)
8010328a:	b8 20 00 00 00       	mov    $0x20,%eax
8010328f:	89 da                	mov    %ebx,%edx
80103291:	ee                   	out    %al,(%dx)
80103292:	b8 04 00 00 00       	mov    $0x4,%eax
80103297:	ee                   	out    %al,(%dx)
80103298:	b8 03 00 00 00       	mov    $0x3,%eax
8010329d:	ee                   	out    %al,(%dx)
8010329e:	b3 a0                	mov    $0xa0,%bl
801032a0:	89 f8                	mov    %edi,%eax
801032a2:	89 da                	mov    %ebx,%edx
801032a4:	ee                   	out    %al,(%dx)
801032a5:	b8 28 00 00 00       	mov    $0x28,%eax
801032aa:	89 ca                	mov    %ecx,%edx
801032ac:	ee                   	out    %al,(%dx)
801032ad:	b8 02 00 00 00       	mov    $0x2,%eax
801032b2:	ee                   	out    %al,(%dx)
801032b3:	b8 03 00 00 00       	mov    $0x3,%eax
801032b8:	ee                   	out    %al,(%dx)
801032b9:	bf 68 00 00 00       	mov    $0x68,%edi
801032be:	89 f2                	mov    %esi,%edx
801032c0:	89 f8                	mov    %edi,%eax
801032c2:	ee                   	out    %al,(%dx)
801032c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
801032c8:	89 c8                	mov    %ecx,%eax
801032ca:	ee                   	out    %al,(%dx)
801032cb:	89 f8                	mov    %edi,%eax
801032cd:	89 da                	mov    %ebx,%edx
801032cf:	ee                   	out    %al,(%dx)
801032d0:	89 c8                	mov    %ecx,%eax
801032d2:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
801032d3:	0f b7 05 00 a0 10 80 	movzwl 0x8010a000,%eax
801032da:	66 83 f8 ff          	cmp    $0xffff,%ax
801032de:	74 0a                	je     801032ea <picinit+0x8a>
801032e0:	b2 21                	mov    $0x21,%dl
801032e2:	ee                   	out    %al,(%dx)
static void
picsetmask(ushort mask)
{
  irqmask = mask;
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
801032e3:	66 c1 e8 08          	shr    $0x8,%ax
801032e7:	b2 a1                	mov    $0xa1,%dl
801032e9:	ee                   	out    %al,(%dx)
  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    picsetmask(irqmask);
}
801032ea:	5b                   	pop    %ebx
801032eb:	5e                   	pop    %esi
801032ec:	5f                   	pop    %edi
801032ed:	5d                   	pop    %ebp
801032ee:	c3                   	ret    
801032ef:	90                   	nop

801032f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	57                   	push   %edi
801032f4:	56                   	push   %esi
801032f5:	53                   	push   %ebx
801032f6:	83 ec 1c             	sub    $0x1c,%esp
801032f9:	8b 75 08             	mov    0x8(%ebp),%esi
801032fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801032ff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103305:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010330b:	e8 90 da ff ff       	call   80100da0 <filealloc>
80103310:	85 c0                	test   %eax,%eax
80103312:	89 06                	mov    %eax,(%esi)
80103314:	0f 84 a4 00 00 00    	je     801033be <pipealloc+0xce>
8010331a:	e8 81 da ff ff       	call   80100da0 <filealloc>
8010331f:	85 c0                	test   %eax,%eax
80103321:	89 03                	mov    %eax,(%ebx)
80103323:	0f 84 87 00 00 00    	je     801033b0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103329:	e8 a2 f1 ff ff       	call   801024d0 <kalloc>
8010332e:	85 c0                	test   %eax,%eax
80103330:	89 c7                	mov    %eax,%edi
80103332:	74 7c                	je     801033b0 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
80103334:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010333b:	00 00 00 
  p->writeopen = 1;
8010333e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103345:	00 00 00 
  p->nwrite = 0;
80103348:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010334f:	00 00 00 
  p->nread = 0;
80103352:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103359:	00 00 00 
  initlock(&p->lock, "pipe");
8010335c:	89 04 24             	mov    %eax,(%esp)
8010335f:	c7 44 24 04 88 72 10 	movl   $0x80107288,0x4(%esp)
80103366:	80 
80103367:	e8 04 0e 00 00       	call   80104170 <initlock>
  (*f0)->type = FD_PIPE;
8010336c:	8b 06                	mov    (%esi),%eax
8010336e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103374:	8b 06                	mov    (%esi),%eax
80103376:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010337a:	8b 06                	mov    (%esi),%eax
8010337c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103380:	8b 06                	mov    (%esi),%eax
80103382:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103385:	8b 03                	mov    (%ebx),%eax
80103387:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010338d:	8b 03                	mov    (%ebx),%eax
8010338f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103393:	8b 03                	mov    (%ebx),%eax
80103395:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103399:	8b 03                	mov    (%ebx),%eax
  return 0;
8010339b:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
8010339d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801033a0:	83 c4 1c             	add    $0x1c,%esp
801033a3:	89 d8                	mov    %ebx,%eax
801033a5:	5b                   	pop    %ebx
801033a6:	5e                   	pop    %esi
801033a7:	5f                   	pop    %edi
801033a8:	5d                   	pop    %ebp
801033a9:	c3                   	ret    
801033aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801033b0:	8b 06                	mov    (%esi),%eax
801033b2:	85 c0                	test   %eax,%eax
801033b4:	74 08                	je     801033be <pipealloc+0xce>
    fileclose(*f0);
801033b6:	89 04 24             	mov    %eax,(%esp)
801033b9:	e8 a2 da ff ff       	call   80100e60 <fileclose>
  if(*f1)
801033be:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
801033c0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
801033c5:	85 c0                	test   %eax,%eax
801033c7:	74 d7                	je     801033a0 <pipealloc+0xb0>
    fileclose(*f1);
801033c9:	89 04 24             	mov    %eax,(%esp)
801033cc:	e8 8f da ff ff       	call   80100e60 <fileclose>
  return -1;
}
801033d1:	83 c4 1c             	add    $0x1c,%esp
801033d4:	89 d8                	mov    %ebx,%eax
801033d6:	5b                   	pop    %ebx
801033d7:	5e                   	pop    %esi
801033d8:	5f                   	pop    %edi
801033d9:	5d                   	pop    %ebp
801033da:	c3                   	ret    
801033db:	90                   	nop
801033dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033e0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	56                   	push   %esi
801033e4:	53                   	push   %ebx
801033e5:	83 ec 10             	sub    $0x10,%esp
801033e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801033ee:	89 1c 24             	mov    %ebx,(%esp)
801033f1:	e8 fa 0d 00 00       	call   801041f0 <acquire>
  if(writable){
801033f6:	85 f6                	test   %esi,%esi
801033f8:	74 3e                	je     80103438 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
801033fa:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103400:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103407:	00 00 00 
    wakeup(&p->nread);
8010340a:	89 04 24             	mov    %eax,(%esp)
8010340d:	e8 9e 0a 00 00       	call   80103eb0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103412:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103418:	85 d2                	test   %edx,%edx
8010341a:	75 0a                	jne    80103426 <pipeclose+0x46>
8010341c:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103422:	85 c0                	test   %eax,%eax
80103424:	74 32                	je     80103458 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103426:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103429:	83 c4 10             	add    $0x10,%esp
8010342c:	5b                   	pop    %ebx
8010342d:	5e                   	pop    %esi
8010342e:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010342f:	e9 ec 0e 00 00       	jmp    80104320 <release>
80103434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103438:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
8010343e:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103445:	00 00 00 
    wakeup(&p->nwrite);
80103448:	89 04 24             	mov    %eax,(%esp)
8010344b:	e8 60 0a 00 00       	call   80103eb0 <wakeup>
80103450:	eb c0                	jmp    80103412 <pipeclose+0x32>
80103452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103458:	89 1c 24             	mov    %ebx,(%esp)
8010345b:	e8 c0 0e 00 00       	call   80104320 <release>
    kfree((char*)p);
80103460:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
80103463:	83 c4 10             	add    $0x10,%esp
80103466:	5b                   	pop    %ebx
80103467:	5e                   	pop    %esi
80103468:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103469:	e9 b2 ee ff ff       	jmp    80102320 <kfree>
8010346e:	66 90                	xchg   %ax,%ax

80103470 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103470:	55                   	push   %ebp
80103471:	89 e5                	mov    %esp,%ebp
80103473:	57                   	push   %edi
80103474:	56                   	push   %esi
80103475:	53                   	push   %ebx
80103476:	83 ec 1c             	sub    $0x1c,%esp
80103479:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
8010347c:	89 3c 24             	mov    %edi,(%esp)
8010347f:	e8 6c 0d 00 00       	call   801041f0 <acquire>
  for(i = 0; i < n; i++){
80103484:	8b 45 10             	mov    0x10(%ebp),%eax
80103487:	85 c0                	test   %eax,%eax
80103489:	0f 8e c2 00 00 00    	jle    80103551 <pipewrite+0xe1>
8010348f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103492:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
80103498:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
8010349e:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
801034a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801034a7:	03 45 10             	add    0x10(%ebp),%eax
801034aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034ad:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801034b3:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801034b9:	39 d1                	cmp    %edx,%ecx
801034bb:	0f 85 c4 00 00 00    	jne    80103585 <pipewrite+0x115>
      if(p->readopen == 0 || proc->killed){
801034c1:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
801034c7:	85 d2                	test   %edx,%edx
801034c9:	0f 84 a1 00 00 00    	je     80103570 <pipewrite+0x100>
801034cf:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801034d6:	8b 42 24             	mov    0x24(%edx),%eax
801034d9:	85 c0                	test   %eax,%eax
801034db:	74 22                	je     801034ff <pipewrite+0x8f>
801034dd:	e9 8e 00 00 00       	jmp    80103570 <pipewrite+0x100>
801034e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801034e8:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
801034ee:	85 c0                	test   %eax,%eax
801034f0:	74 7e                	je     80103570 <pipewrite+0x100>
801034f2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801034f8:	8b 48 24             	mov    0x24(%eax),%ecx
801034fb:	85 c9                	test   %ecx,%ecx
801034fd:	75 71                	jne    80103570 <pipewrite+0x100>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801034ff:	89 34 24             	mov    %esi,(%esp)
80103502:	e8 a9 09 00 00       	call   80103eb0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103507:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010350b:	89 1c 24             	mov    %ebx,(%esp)
8010350e:	e8 fd 07 00 00       	call   80103d10 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103513:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
80103519:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
8010351f:	05 00 02 00 00       	add    $0x200,%eax
80103524:	39 c2                	cmp    %eax,%edx
80103526:	74 c0                	je     801034e8 <pipewrite+0x78>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103528:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010352b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010352e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103534:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
8010353a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010353e:	0f b6 00             	movzbl (%eax),%eax
80103541:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103545:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103548:	3b 45 e0             	cmp    -0x20(%ebp),%eax
8010354b:	0f 85 5c ff ff ff    	jne    801034ad <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103551:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
80103557:	89 14 24             	mov    %edx,(%esp)
8010355a:	e8 51 09 00 00       	call   80103eb0 <wakeup>
  release(&p->lock);
8010355f:	89 3c 24             	mov    %edi,(%esp)
80103562:	e8 b9 0d 00 00       	call   80104320 <release>
  return n;
80103567:	8b 45 10             	mov    0x10(%ebp),%eax
8010356a:	eb 11                	jmp    8010357d <pipewrite+0x10d>
8010356c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
80103570:	89 3c 24             	mov    %edi,(%esp)
80103573:	e8 a8 0d 00 00       	call   80104320 <release>
        return -1;
80103578:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010357d:	83 c4 1c             	add    $0x1c,%esp
80103580:	5b                   	pop    %ebx
80103581:	5e                   	pop    %esi
80103582:	5f                   	pop    %edi
80103583:	5d                   	pop    %ebp
80103584:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103585:	89 ca                	mov    %ecx,%edx
80103587:	eb 9f                	jmp    80103528 <pipewrite+0xb8>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103590 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	57                   	push   %edi
80103594:	56                   	push   %esi
80103595:	53                   	push   %ebx
80103596:	83 ec 1c             	sub    $0x1c,%esp
80103599:	8b 75 08             	mov    0x8(%ebp),%esi
8010359c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010359f:	89 34 24             	mov    %esi,(%esp)
801035a2:	e8 49 0c 00 00       	call   801041f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035a7:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801035ad:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801035b3:	75 5b                	jne    80103610 <piperead+0x80>
801035b5:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801035bb:	85 db                	test   %ebx,%ebx
801035bd:	74 51                	je     80103610 <piperead+0x80>
801035bf:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801035c5:	eb 25                	jmp    801035ec <piperead+0x5c>
801035c7:	90                   	nop
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801035c8:	89 74 24 04          	mov    %esi,0x4(%esp)
801035cc:	89 1c 24             	mov    %ebx,(%esp)
801035cf:	e8 3c 07 00 00       	call   80103d10 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035d4:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801035da:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801035e0:	75 2e                	jne    80103610 <piperead+0x80>
801035e2:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035e8:	85 d2                	test   %edx,%edx
801035ea:	74 24                	je     80103610 <piperead+0x80>
    if(proc->killed){
801035ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801035f2:	8b 48 24             	mov    0x24(%eax),%ecx
801035f5:	85 c9                	test   %ecx,%ecx
801035f7:	74 cf                	je     801035c8 <piperead+0x38>
      release(&p->lock);
801035f9:	89 34 24             	mov    %esi,(%esp)
801035fc:	e8 1f 0d 00 00       	call   80104320 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103601:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      return -1;
80103604:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103609:	5b                   	pop    %ebx
8010360a:	5e                   	pop    %esi
8010360b:	5f                   	pop    %edi
8010360c:	5d                   	pop    %ebp
8010360d:	c3                   	ret    
8010360e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103610:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103613:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103615:	85 d2                	test   %edx,%edx
80103617:	7f 2b                	jg     80103644 <piperead+0xb4>
80103619:	eb 31                	jmp    8010364c <piperead+0xbc>
8010361b:	90                   	nop
8010361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103620:	8d 48 01             	lea    0x1(%eax),%ecx
80103623:	25 ff 01 00 00       	and    $0x1ff,%eax
80103628:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010362e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103633:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103636:	83 c3 01             	add    $0x1,%ebx
80103639:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010363c:	74 0e                	je     8010364c <piperead+0xbc>
    if(p->nread == p->nwrite)
8010363e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103644:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010364a:	75 d4                	jne    80103620 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010364c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103652:	89 04 24             	mov    %eax,(%esp)
80103655:	e8 56 08 00 00       	call   80103eb0 <wakeup>
  release(&p->lock);
8010365a:	89 34 24             	mov    %esi,(%esp)
8010365d:	e8 be 0c 00 00       	call   80104320 <release>
  return i;
}
80103662:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
80103665:	89 d8                	mov    %ebx,%eax
}
80103667:	5b                   	pop    %ebx
80103668:	5e                   	pop    %esi
80103669:	5f                   	pop    %edi
8010366a:	5d                   	pop    %ebp
8010366b:	c3                   	ret    
8010366c:	66 90                	xchg   %ax,%ax
8010366e:	66 90                	xchg   %ax,%ax

80103670 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103670:	55                   	push   %ebp
80103671:	89 e5                	mov    %esp,%ebp
80103673:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103674:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103679:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010367c:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103683:	e8 68 0b 00 00       	call   801041f0 <acquire>
80103688:	eb 11                	jmp    8010369b <allocproc+0x2b>
8010368a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103690:	83 c3 7c             	add    $0x7c,%ebx
80103693:	81 fb d4 4c 11 80    	cmp    $0x80114cd4,%ebx
80103699:	74 7d                	je     80103718 <allocproc+0xa8>
    if(p->state == UNUSED)
8010369b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010369e:	85 c0                	test   %eax,%eax
801036a0:	75 ee                	jne    80103690 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801036a2:	a1 08 a0 10 80       	mov    0x8010a008,%eax

  release(&ptable.lock);
801036a7:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801036ae:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801036b5:	8d 50 01             	lea    0x1(%eax),%edx
801036b8:	89 15 08 a0 10 80    	mov    %edx,0x8010a008
801036be:	89 43 10             	mov    %eax,0x10(%ebx)

  release(&ptable.lock);
801036c1:	e8 5a 0c 00 00       	call   80104320 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801036c6:	e8 05 ee ff ff       	call   801024d0 <kalloc>
801036cb:	85 c0                	test   %eax,%eax
801036cd:	89 43 08             	mov    %eax,0x8(%ebx)
801036d0:	74 5a                	je     8010372c <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036d2:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801036d8:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036dd:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801036e0:	c7 40 14 ed 54 10 80 	movl   $0x801054ed,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801036e7:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801036ee:	00 
801036ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801036f6:	00 
801036f7:	89 04 24             	mov    %eax,(%esp)
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801036fa:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036fd:	e8 6e 0c 00 00       	call   80104370 <memset>
  p->context->eip = (uint)forkret;
80103702:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103705:	c7 40 10 40 37 10 80 	movl   $0x80103740,0x10(%eax)

  return p;
8010370c:	89 d8                	mov    %ebx,%eax
}
8010370e:	83 c4 14             	add    $0x14,%esp
80103711:	5b                   	pop    %ebx
80103712:	5d                   	pop    %ebp
80103713:	c3                   	ret    
80103714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103718:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010371f:	e8 fc 0b 00 00       	call   80104320 <release>
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103724:	83 c4 14             	add    $0x14,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
80103727:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103729:	5b                   	pop    %ebx
8010372a:	5d                   	pop    %ebp
8010372b:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010372c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103733:	eb d9                	jmp    8010370e <allocproc+0x9e>
80103735:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103740 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103746:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010374d:	e8 ce 0b 00 00       	call   80104320 <release>

  if (first) {
80103752:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103757:	85 c0                	test   %eax,%eax
80103759:	75 05                	jne    80103760 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010375b:	c9                   	leave  
8010375c:	c3                   	ret    
8010375d:	8d 76 00             	lea    0x0(%esi),%esi
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103760:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103767:	c7 05 04 a0 10 80 00 	movl   $0x0,0x8010a004
8010376e:	00 00 00 
    iinit(ROOTDEV);
80103771:	e8 3a dd ff ff       	call   801014b0 <iinit>
    initlog(ROOTDEV);
80103776:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010377d:	e8 9e f3 ff ff       	call   80102b20 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103782:	c9                   	leave  
80103783:	c3                   	ret    
80103784:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010378a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103790 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103796:	c7 44 24 04 8d 72 10 	movl   $0x8010728d,0x4(%esp)
8010379d:	80 
8010379e:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801037a5:	e8 c6 09 00 00       	call   80104170 <initlock>
}
801037aa:	c9                   	leave  
801037ab:	c3                   	ret    
801037ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801037b0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	53                   	push   %ebx
801037b4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801037b7:	e8 b4 fe ff ff       	call   80103670 <allocproc>
801037bc:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
801037be:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
  if((p->pgdir = setupkvm()) == 0)
801037c3:	e8 28 2f 00 00       	call   801066f0 <setupkvm>
801037c8:	85 c0                	test   %eax,%eax
801037ca:	89 43 04             	mov    %eax,0x4(%ebx)
801037cd:	0f 84 d4 00 00 00    	je     801038a7 <userinit+0xf7>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801037d3:	89 04 24             	mov    %eax,(%esp)
801037d6:	c7 44 24 08 30 00 00 	movl   $0x30,0x8(%esp)
801037dd:	00 
801037de:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
801037e5:	80 
801037e6:	e8 95 30 00 00       	call   80106880 <inituvm>
  p->sz = PGSIZE;
801037eb:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801037f1:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801037f8:	00 
801037f9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103800:	00 
80103801:	8b 43 18             	mov    0x18(%ebx),%eax
80103804:	89 04 24             	mov    %eax,(%esp)
80103807:	e8 64 0b 00 00       	call   80104370 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010380c:	8b 43 18             	mov    0x18(%ebx),%eax
8010380f:	ba 23 00 00 00       	mov    $0x23,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103814:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103819:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010381d:	8b 43 18             	mov    0x18(%ebx),%eax
80103820:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103824:	8b 43 18             	mov    0x18(%ebx),%eax
80103827:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010382b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010382f:	8b 43 18             	mov    0x18(%ebx),%eax
80103832:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103836:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010383a:	8b 43 18             	mov    0x18(%ebx),%eax
8010383d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103844:	8b 43 18             	mov    0x18(%ebx),%eax
80103847:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010384e:	8b 43 18             	mov    0x18(%ebx),%eax
80103851:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103858:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010385b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103862:	00 
80103863:	c7 44 24 04 ad 72 10 	movl   $0x801072ad,0x4(%esp)
8010386a:	80 
8010386b:	89 04 24             	mov    %eax,(%esp)
8010386e:	e8 dd 0c 00 00       	call   80104550 <safestrcpy>
  p->cwd = namei("/");
80103873:	c7 04 24 b6 72 10 80 	movl   $0x801072b6,(%esp)
8010387a:	e8 a1 e6 ff ff       	call   80101f20 <namei>
8010387f:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103882:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103889:	e8 62 09 00 00       	call   801041f0 <acquire>

  p->state = RUNNABLE;
8010388e:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103895:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010389c:	e8 7f 0a 00 00       	call   80104320 <release>
}
801038a1:	83 c4 14             	add    $0x14,%esp
801038a4:	5b                   	pop    %ebx
801038a5:	5d                   	pop    %ebp
801038a6:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
801038a7:	c7 04 24 94 72 10 80 	movl   $0x80107294,(%esp)
801038ae:	e8 ad ca ff ff       	call   80100360 <panic>
801038b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038c0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	83 ec 18             	sub    $0x18,%esp
  uint sz;

  sz = proc->sz;
801038c6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801038cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint sz;

  sz = proc->sz;
801038d0:	8b 02                	mov    (%edx),%eax
  if(n > 0){
801038d2:	83 f9 00             	cmp    $0x0,%ecx
801038d5:	7e 39                	jle    80103910 <growproc+0x50>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801038d7:	01 c1                	add    %eax,%ecx
801038d9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801038dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801038e1:	8b 42 04             	mov    0x4(%edx),%eax
801038e4:	89 04 24             	mov    %eax,(%esp)
801038e7:	e8 d4 30 00 00       	call   801069c0 <allocuvm>
801038ec:	85 c0                	test   %eax,%eax
801038ee:	74 40                	je     80103930 <growproc+0x70>
801038f0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
801038f7:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
801038f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801038ff:	89 04 24             	mov    %eax,(%esp)
80103902:	e8 a9 2e 00 00       	call   801067b0 <switchuvm>
  return 0;
80103907:	31 c0                	xor    %eax,%eax
}
80103909:	c9                   	leave  
8010390a:	c3                   	ret    
8010390b:	90                   	nop
8010390c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103910:	74 e5                	je     801038f7 <growproc+0x37>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80103912:	01 c1                	add    %eax,%ecx
80103914:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80103918:	89 44 24 04          	mov    %eax,0x4(%esp)
8010391c:	8b 42 04             	mov    0x4(%edx),%eax
8010391f:	89 04 24             	mov    %eax,(%esp)
80103922:	e8 89 31 00 00       	call   80106ab0 <deallocuvm>
80103927:	85 c0                	test   %eax,%eax
80103929:	75 c5                	jne    801038f0 <growproc+0x30>
8010392b:	90                   	nop
8010392c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint sz;

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
80103930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}
80103935:	c9                   	leave  
80103936:	c3                   	ret    
80103937:	89 f6                	mov    %esi,%esi
80103939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103940 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	57                   	push   %edi
80103944:	56                   	push   %esi
80103945:	53                   	push   %ebx
80103946:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
80103949:	e8 22 fd ff ff       	call   80103670 <allocproc>
8010394e:	85 c0                	test   %eax,%eax
80103950:	89 c3                	mov    %eax,%ebx
80103952:	0f 84 d5 00 00 00    	je     80103a2d <fork+0xed>
    return -1;
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80103958:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010395e:	8b 10                	mov    (%eax),%edx
80103960:	89 54 24 04          	mov    %edx,0x4(%esp)
80103964:	8b 40 04             	mov    0x4(%eax),%eax
80103967:	89 04 24             	mov    %eax,(%esp)
8010396a:	e8 11 32 00 00       	call   80106b80 <copyuvm>
8010396f:	85 c0                	test   %eax,%eax
80103971:	89 43 04             	mov    %eax,0x4(%ebx)
80103974:	0f 84 ba 00 00 00    	je     80103a34 <fork+0xf4>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
8010397a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent = proc;
  *np->tf = *proc->tf;
80103980:	b9 13 00 00 00       	mov    $0x13,%ecx
80103985:	8b 7b 18             	mov    0x18(%ebx),%edi
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103988:	8b 00                	mov    (%eax),%eax
8010398a:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
8010398c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103992:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
80103995:	8b 70 18             	mov    0x18(%eax),%esi
80103998:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010399a:	31 f6                	xor    %esi,%esi
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
8010399c:	8b 43 18             	mov    0x18(%ebx),%eax
8010399f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801039a6:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801039ad:	8d 76 00             	lea    0x0(%esi),%esi

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
801039b0:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
801039b4:	85 c0                	test   %eax,%eax
801039b6:	74 13                	je     801039cb <fork+0x8b>
      np->ofile[i] = filedup(proc->ofile[i]);
801039b8:	89 04 24             	mov    %eax,(%esp)
801039bb:	e8 50 d4 ff ff       	call   80100e10 <filedup>
801039c0:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
801039c4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801039cb:	83 c6 01             	add    $0x1,%esi
801039ce:	83 fe 10             	cmp    $0x10,%esi
801039d1:	75 dd                	jne    801039b0 <fork+0x70>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801039d3:	8b 42 68             	mov    0x68(%edx),%eax
801039d6:	89 04 24             	mov    %eax,(%esp)
801039d9:	e8 e2 dc ff ff       	call   801016c0 <idup>
801039de:	89 43 68             	mov    %eax,0x68(%ebx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
801039e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801039e7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801039ee:	00 
801039ef:	83 c0 6c             	add    $0x6c,%eax
801039f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801039f6:	8d 43 6c             	lea    0x6c(%ebx),%eax
801039f9:	89 04 24             	mov    %eax,(%esp)
801039fc:	e8 4f 0b 00 00       	call   80104550 <safestrcpy>

  pid = np->pid;
80103a01:	8b 73 10             	mov    0x10(%ebx),%esi

  acquire(&ptable.lock);
80103a04:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103a0b:	e8 e0 07 00 00       	call   801041f0 <acquire>

  np->state = RUNNABLE;
80103a10:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103a17:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103a1e:	e8 fd 08 00 00       	call   80104320 <release>

  return pid;
80103a23:	89 f0                	mov    %esi,%eax
}
80103a25:	83 c4 1c             	add    $0x1c,%esp
80103a28:	5b                   	pop    %ebx
80103a29:	5e                   	pop    %esi
80103a2a:	5f                   	pop    %edi
80103a2b:	5d                   	pop    %ebp
80103a2c:	c3                   	ret    
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103a2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a32:	eb f1                	jmp    80103a25 <fork+0xe5>
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
80103a34:	8b 43 08             	mov    0x8(%ebx),%eax
80103a37:	89 04 24             	mov    %eax,(%esp)
80103a3a:	e8 e1 e8 ff ff       	call   80102320 <kfree>
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
80103a3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
80103a44:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103a4b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103a52:	eb d1                	jmp    80103a25 <fork+0xe5>
80103a54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a60 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	53                   	push   %ebx
80103a64:	83 ec 14             	sub    $0x14,%esp
80103a67:	90                   	nop
}

static inline void
sti(void)
{
  asm volatile("sti");
80103a68:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a69:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a70:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a75:	e8 76 07 00 00       	call   801041f0 <acquire>
80103a7a:	eb 0f                	jmp    80103a8b <scheduler+0x2b>
80103a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a80:	83 c3 7c             	add    $0x7c,%ebx
80103a83:	81 fb d4 4c 11 80    	cmp    $0x80114cd4,%ebx
80103a89:	74 55                	je     80103ae0 <scheduler+0x80>
      if(p->state != RUNNABLE)
80103a8b:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103a8f:	75 ef                	jne    80103a80 <scheduler+0x20>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103a91:	89 1c 24             	mov    %ebx,(%esp)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80103a94:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a9b:	83 c3 7c             	add    $0x7c,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103a9e:	e8 0d 2d 00 00       	call   801067b0 <switchuvm>
      p->state = RUNNING;
      swtch(&cpu->scheduler, p->context);
80103aa3:	8b 43 a0             	mov    -0x60(%ebx),%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103aa6:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)
      swtch(&cpu->scheduler, p->context);
80103aad:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ab1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103ab7:	83 c0 04             	add    $0x4,%eax
80103aba:	89 04 24             	mov    %eax,(%esp)
80103abd:	e8 e9 0a 00 00       	call   801045ab <swtch>
      switchkvm();
80103ac2:	e8 c9 2c 00 00       	call   80106790 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ac7:	81 fb d4 4c 11 80    	cmp    $0x80114cd4,%ebx
      swtch(&cpu->scheduler, p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103acd:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103ad4:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ad8:	75 b1                	jne    80103a8b <scheduler+0x2b>
80103ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80103ae0:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103ae7:	e8 34 08 00 00       	call   80104320 <release>

  }
80103aec:	e9 77 ff ff ff       	jmp    80103a68 <scheduler+0x8>
80103af1:	eb 0d                	jmp    80103b00 <sched>
80103af3:	90                   	nop
80103af4:	90                   	nop
80103af5:	90                   	nop
80103af6:	90                   	nop
80103af7:	90                   	nop
80103af8:	90                   	nop
80103af9:	90                   	nop
80103afa:	90                   	nop
80103afb:	90                   	nop
80103afc:	90                   	nop
80103afd:	90                   	nop
80103afe:	90                   	nop
80103aff:	90                   	nop

80103b00 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	53                   	push   %ebx
80103b04:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
80103b07:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103b0e:	e8 6d 07 00 00       	call   80104280 <holding>
80103b13:	85 c0                	test   %eax,%eax
80103b15:	74 4d                	je     80103b64 <sched+0x64>
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
80103b17:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103b1d:	83 b8 ac 00 00 00 01 	cmpl   $0x1,0xac(%eax)
80103b24:	75 62                	jne    80103b88 <sched+0x88>
    panic("sched locks");
  if(proc->state == RUNNING)
80103b26:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103b2d:	83 7a 0c 04          	cmpl   $0x4,0xc(%edx)
80103b31:	74 49                	je     80103b7c <sched+0x7c>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b33:	9c                   	pushf  
80103b34:	59                   	pop    %ecx
    panic("sched running");
  if(readeflags()&FL_IF)
80103b35:	80 e5 02             	and    $0x2,%ch
80103b38:	75 36                	jne    80103b70 <sched+0x70>
    panic("sched interruptible");
  intena = cpu->intena;
80103b3a:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
  swtch(&proc->context, cpu->scheduler);
80103b40:	83 c2 1c             	add    $0x1c,%edx
80103b43:	8b 40 04             	mov    0x4(%eax),%eax
80103b46:	89 14 24             	mov    %edx,(%esp)
80103b49:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b4d:	e8 59 0a 00 00       	call   801045ab <swtch>
  cpu->intena = intena;
80103b52:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103b58:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80103b5e:	83 c4 14             	add    $0x14,%esp
80103b61:	5b                   	pop    %ebx
80103b62:	5d                   	pop    %ebp
80103b63:	c3                   	ret    
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103b64:	c7 04 24 b8 72 10 80 	movl   $0x801072b8,(%esp)
80103b6b:	e8 f0 c7 ff ff       	call   80100360 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103b70:	c7 04 24 e4 72 10 80 	movl   $0x801072e4,(%esp)
80103b77:	e8 e4 c7 ff ff       	call   80100360 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
80103b7c:	c7 04 24 d6 72 10 80 	movl   $0x801072d6,(%esp)
80103b83:	e8 d8 c7 ff ff       	call   80100360 <panic>
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
80103b88:	c7 04 24 ca 72 10 80 	movl   $0x801072ca,(%esp)
80103b8f:	e8 cc c7 ff ff       	call   80100360 <panic>
80103b94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103ba0 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	56                   	push   %esi
80103ba4:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(proc == initproc)
80103ba5:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103ba7:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80103baa:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103bb1:	3b 15 bc a5 10 80    	cmp    0x8010a5bc,%edx
80103bb7:	0f 84 01 01 00 00    	je     80103cbe <exit+0x11e>
80103bbd:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
80103bc0:	8d 73 08             	lea    0x8(%ebx),%esi
80103bc3:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
80103bc7:	85 c0                	test   %eax,%eax
80103bc9:	74 17                	je     80103be2 <exit+0x42>
      fileclose(proc->ofile[fd]);
80103bcb:	89 04 24             	mov    %eax,(%esp)
80103bce:	e8 8d d2 ff ff       	call   80100e60 <fileclose>
      proc->ofile[fd] = 0;
80103bd3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103bda:	c7 44 b2 08 00 00 00 	movl   $0x0,0x8(%edx,%esi,4)
80103be1:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103be2:	83 c3 01             	add    $0x1,%ebx
80103be5:	83 fb 10             	cmp    $0x10,%ebx
80103be8:	75 d6                	jne    80103bc0 <exit+0x20>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80103bea:	e8 d1 ef ff ff       	call   80102bc0 <begin_op>
  iput(proc->cwd);
80103bef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103bf5:	8b 40 68             	mov    0x68(%eax),%eax
80103bf8:	89 04 24             	mov    %eax,(%esp)
80103bfb:	e8 00 dc ff ff       	call   80101800 <iput>
  end_op();
80103c00:	e8 2b f0 ff ff       	call   80102c30 <end_op>
  proc->cwd = 0;
80103c05:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103c0b:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80103c12:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103c19:	e8 d2 05 00 00       	call   801041f0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103c1e:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c25:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103c2a:	8b 51 14             	mov    0x14(%ecx),%edx
80103c2d:	eb 0b                	jmp    80103c3a <exit+0x9a>
80103c2f:	90                   	nop
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c30:	83 c0 7c             	add    $0x7c,%eax
80103c33:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80103c38:	74 1c                	je     80103c56 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
80103c3a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103c3e:	75 f0                	jne    80103c30 <exit+0x90>
80103c40:	3b 50 20             	cmp    0x20(%eax),%edx
80103c43:	75 eb                	jne    80103c30 <exit+0x90>
      p->state = RUNNABLE;
80103c45:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c4c:	83 c0 7c             	add    $0x7c,%eax
80103c4f:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80103c54:	75 e4                	jne    80103c3a <exit+0x9a>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103c56:	8b 1d bc a5 10 80    	mov    0x8010a5bc,%ebx
80103c5c:	ba d4 2d 11 80       	mov    $0x80112dd4,%edx
80103c61:	eb 10                	jmp    80103c73 <exit+0xd3>
80103c63:	90                   	nop
80103c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c68:	83 c2 7c             	add    $0x7c,%edx
80103c6b:	81 fa d4 4c 11 80    	cmp    $0x80114cd4,%edx
80103c71:	74 33                	je     80103ca6 <exit+0x106>
    if(p->parent == proc){
80103c73:	3b 4a 14             	cmp    0x14(%edx),%ecx
80103c76:	75 f0                	jne    80103c68 <exit+0xc8>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103c78:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103c7c:	89 5a 14             	mov    %ebx,0x14(%edx)
      if(p->state == ZOMBIE)
80103c7f:	75 e7                	jne    80103c68 <exit+0xc8>
80103c81:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103c86:	eb 0a                	jmp    80103c92 <exit+0xf2>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c88:	83 c0 7c             	add    $0x7c,%eax
80103c8b:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80103c90:	74 d6                	je     80103c68 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
80103c92:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103c96:	75 f0                	jne    80103c88 <exit+0xe8>
80103c98:	3b 58 20             	cmp    0x20(%eax),%ebx
80103c9b:	75 eb                	jne    80103c88 <exit+0xe8>
      p->state = RUNNABLE;
80103c9d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103ca4:	eb e2                	jmp    80103c88 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80103ca6:	c7 41 0c 05 00 00 00 	movl   $0x5,0xc(%ecx)
  sched();
80103cad:	e8 4e fe ff ff       	call   80103b00 <sched>
  panic("zombie exit");
80103cb2:	c7 04 24 05 73 10 80 	movl   $0x80107305,(%esp)
80103cb9:	e8 a2 c6 ff ff       	call   80100360 <panic>
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");
80103cbe:	c7 04 24 f8 72 10 80 	movl   $0x801072f8,(%esp)
80103cc5:	e8 96 c6 ff ff       	call   80100360 <panic>
80103cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103cd0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103cd6:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103cdd:	e8 0e 05 00 00       	call   801041f0 <acquire>
  proc->state = RUNNABLE;
80103ce2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ce8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103cef:	e8 0c fe ff ff       	call   80103b00 <sched>
  release(&ptable.lock);
80103cf4:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103cfb:	e8 20 06 00 00       	call   80104320 <release>
}
80103d00:	c9                   	leave  
80103d01:	c3                   	ret    
80103d02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d10 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	56                   	push   %esi
80103d14:	53                   	push   %ebx
80103d15:	83 ec 10             	sub    $0x10,%esp
  if(proc == 0)
80103d18:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103d1e:	8b 75 08             	mov    0x8(%ebp),%esi
80103d21:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
80103d24:	85 c0                	test   %eax,%eax
80103d26:	0f 84 8b 00 00 00    	je     80103db7 <sleep+0xa7>
    panic("sleep");

  if(lk == 0)
80103d2c:	85 db                	test   %ebx,%ebx
80103d2e:	74 7b                	je     80103dab <sleep+0x9b>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d30:	81 fb a0 2d 11 80    	cmp    $0x80112da0,%ebx
80103d36:	74 50                	je     80103d88 <sleep+0x78>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d38:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103d3f:	e8 ac 04 00 00       	call   801041f0 <acquire>
    release(lk);
80103d44:	89 1c 24             	mov    %ebx,(%esp)
80103d47:	e8 d4 05 00 00       	call   80104320 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80103d4c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103d52:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103d55:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103d5c:	e8 9f fd ff ff       	call   80103b00 <sched>

  // Tidy up.
  proc->chan = 0;
80103d61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103d67:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103d6e:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103d75:	e8 a6 05 00 00       	call   80104320 <release>
    acquire(lk);
80103d7a:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
80103d7d:	83 c4 10             	add    $0x10,%esp
80103d80:	5b                   	pop    %ebx
80103d81:	5e                   	pop    %esi
80103d82:	5d                   	pop    %ebp
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103d83:	e9 68 04 00 00       	jmp    801041f0 <acquire>
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
80103d88:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103d8b:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103d92:	e8 69 fd ff ff       	call   80103b00 <sched>

  // Tidy up.
  proc->chan = 0;
80103d97:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103d9d:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103da4:	83 c4 10             	add    $0x10,%esp
80103da7:	5b                   	pop    %ebx
80103da8:	5e                   	pop    %esi
80103da9:	5d                   	pop    %ebp
80103daa:	c3                   	ret    
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103dab:	c7 04 24 17 73 10 80 	movl   $0x80107317,(%esp)
80103db2:	e8 a9 c5 ff ff       	call   80100360 <panic>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
80103db7:	c7 04 24 11 73 10 80 	movl   $0x80107311,(%esp)
80103dbe:	e8 9d c5 ff ff       	call   80100360 <panic>
80103dc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103dd0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	56                   	push   %esi
80103dd4:	53                   	push   %ebx
80103dd5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80103dd8:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103ddf:	e8 0c 04 00 00       	call   801041f0 <acquire>
80103de4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103dea:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dec:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
80103df1:	eb 10                	jmp    80103e03 <wait+0x33>
80103df3:	90                   	nop
80103df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103df8:	83 c3 7c             	add    $0x7c,%ebx
80103dfb:	81 fb d4 4c 11 80    	cmp    $0x80114cd4,%ebx
80103e01:	74 1d                	je     80103e20 <wait+0x50>
      if(p->parent != proc)
80103e03:	39 43 14             	cmp    %eax,0x14(%ebx)
80103e06:	75 f0                	jne    80103df8 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103e08:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103e0c:	74 2f                	je     80103e3d <wait+0x6d>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e0e:	83 c3 7c             	add    $0x7c,%ebx
      if(p->parent != proc)
        continue;
      havekids = 1;
80103e11:	ba 01 00 00 00       	mov    $0x1,%edx

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e16:	81 fb d4 4c 11 80    	cmp    $0x80114cd4,%ebx
80103e1c:	75 e5                	jne    80103e03 <wait+0x33>
80103e1e:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80103e20:	85 d2                	test   %edx,%edx
80103e22:	74 6e                	je     80103e92 <wait+0xc2>
80103e24:	8b 50 24             	mov    0x24(%eax),%edx
80103e27:	85 d2                	test   %edx,%edx
80103e29:	75 67                	jne    80103e92 <wait+0xc2>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80103e2b:	c7 44 24 04 a0 2d 11 	movl   $0x80112da0,0x4(%esp)
80103e32:	80 
80103e33:	89 04 24             	mov    %eax,(%esp)
80103e36:	e8 d5 fe ff ff       	call   80103d10 <sleep>
  }
80103e3b:	eb a7                	jmp    80103de4 <wait+0x14>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103e3d:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103e40:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103e43:	89 04 24             	mov    %eax,(%esp)
80103e46:	e8 d5 e4 ff ff       	call   80102320 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103e4b:	8b 43 04             	mov    0x4(%ebx),%eax
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103e4e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103e55:	89 04 24             	mov    %eax,(%esp)
80103e58:	e8 73 2c 00 00       	call   80106ad0 <freevm>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
80103e5d:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
80103e64:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103e6b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103e72:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103e76:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103e7d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103e84:	e8 97 04 00 00       	call   80104320 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e89:	83 c4 10             	add    $0x10,%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103e8c:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e8e:	5b                   	pop    %ebx
80103e8f:	5e                   	pop    %esi
80103e90:	5d                   	pop    %ebp
80103e91:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
80103e92:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103e99:	e8 82 04 00 00       	call   80104320 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e9e:	83 c4 10             	add    $0x10,%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
80103ea1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103ea6:	5b                   	pop    %ebx
80103ea7:	5e                   	pop    %esi
80103ea8:	5d                   	pop    %ebp
80103ea9:	c3                   	ret    
80103eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103eb0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	53                   	push   %ebx
80103eb4:	83 ec 14             	sub    $0x14,%esp
80103eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103eba:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103ec1:	e8 2a 03 00 00       	call   801041f0 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ec6:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103ecb:	eb 0d                	jmp    80103eda <wakeup+0x2a>
80103ecd:	8d 76 00             	lea    0x0(%esi),%esi
80103ed0:	83 c0 7c             	add    $0x7c,%eax
80103ed3:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80103ed8:	74 1e                	je     80103ef8 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
80103eda:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ede:	75 f0                	jne    80103ed0 <wakeup+0x20>
80103ee0:	3b 58 20             	cmp    0x20(%eax),%ebx
80103ee3:	75 eb                	jne    80103ed0 <wakeup+0x20>
      p->state = RUNNABLE;
80103ee5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103eec:	83 c0 7c             	add    $0x7c,%eax
80103eef:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80103ef4:	75 e4                	jne    80103eda <wakeup+0x2a>
80103ef6:	66 90                	xchg   %ax,%ax
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103ef8:	c7 45 08 a0 2d 11 80 	movl   $0x80112da0,0x8(%ebp)
}
80103eff:	83 c4 14             	add    $0x14,%esp
80103f02:	5b                   	pop    %ebx
80103f03:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103f04:	e9 17 04 00 00       	jmp    80104320 <release>
80103f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f10 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	53                   	push   %ebx
80103f14:	83 ec 14             	sub    $0x14,%esp
80103f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103f1a:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103f21:	e8 ca 02 00 00       	call   801041f0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f26:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103f2b:	eb 0d                	jmp    80103f3a <kill+0x2a>
80103f2d:	8d 76 00             	lea    0x0(%esi),%esi
80103f30:	83 c0 7c             	add    $0x7c,%eax
80103f33:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80103f38:	74 36                	je     80103f70 <kill+0x60>
    if(p->pid == pid){
80103f3a:	39 58 10             	cmp    %ebx,0x10(%eax)
80103f3d:	75 f1                	jne    80103f30 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f3f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103f43:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f4a:	74 14                	je     80103f60 <kill+0x50>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103f4c:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103f53:	e8 c8 03 00 00       	call   80104320 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f58:	83 c4 14             	add    $0x14,%esp
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
80103f5b:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f5d:	5b                   	pop    %ebx
80103f5e:	5d                   	pop    %ebp
80103f5f:	c3                   	ret    
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103f60:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f67:	eb e3                	jmp    80103f4c <kill+0x3c>
80103f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103f70:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103f77:	e8 a4 03 00 00       	call   80104320 <release>
  return -1;
}
80103f7c:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
80103f7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f84:	5b                   	pop    %ebx
80103f85:	5d                   	pop    %ebp
80103f86:	c3                   	ret    
80103f87:	89 f6                	mov    %esi,%esi
80103f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f90 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	57                   	push   %edi
80103f94:	56                   	push   %esi
80103f95:	53                   	push   %ebx
80103f96:	bb 40 2e 11 80       	mov    $0x80112e40,%ebx
80103f9b:	83 ec 4c             	sub    $0x4c,%esp
80103f9e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103fa1:	eb 20                	jmp    80103fc3 <procdump+0x33>
80103fa3:	90                   	nop
80103fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103fa8:	c7 04 24 66 72 10 80 	movl   $0x80107266,(%esp)
80103faf:	e8 9c c6 ff ff       	call   80100650 <cprintf>
80103fb4:	83 c3 7c             	add    $0x7c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fb7:	81 fb 40 4d 11 80    	cmp    $0x80114d40,%ebx
80103fbd:	0f 84 8d 00 00 00    	je     80104050 <procdump+0xc0>
    if(p->state == UNUSED)
80103fc3:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103fc6:	85 c0                	test   %eax,%eax
80103fc8:	74 ea                	je     80103fb4 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103fca:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80103fcd:	ba 28 73 10 80       	mov    $0x80107328,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103fd2:	77 11                	ja     80103fe5 <procdump+0x55>
80103fd4:	8b 14 85 60 73 10 80 	mov    -0x7fef8ca0(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80103fdb:	b8 28 73 10 80       	mov    $0x80107328,%eax
80103fe0:	85 d2                	test   %edx,%edx
80103fe2:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103fe5:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103fe8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103fec:	89 54 24 08          	mov    %edx,0x8(%esp)
80103ff0:	c7 04 24 2c 73 10 80 	movl   $0x8010732c,(%esp)
80103ff7:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ffb:	e8 50 c6 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80104000:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104004:	75 a2                	jne    80103fa8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104006:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104009:	89 44 24 04          	mov    %eax,0x4(%esp)
8010400d:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104010:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104013:	8b 40 0c             	mov    0xc(%eax),%eax
80104016:	83 c0 08             	add    $0x8,%eax
80104019:	89 04 24             	mov    %eax,(%esp)
8010401c:	e8 6f 01 00 00       	call   80104190 <getcallerpcs>
80104021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104028:	8b 17                	mov    (%edi),%edx
8010402a:	85 d2                	test   %edx,%edx
8010402c:	0f 84 76 ff ff ff    	je     80103fa8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104032:	89 54 24 04          	mov    %edx,0x4(%esp)
80104036:	83 c7 04             	add    $0x4,%edi
80104039:	c7 04 24 89 6d 10 80 	movl   $0x80106d89,(%esp)
80104040:	e8 0b c6 ff ff       	call   80100650 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104045:	39 f7                	cmp    %esi,%edi
80104047:	75 df                	jne    80104028 <procdump+0x98>
80104049:	e9 5a ff ff ff       	jmp    80103fa8 <procdump+0x18>
8010404e:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104050:	83 c4 4c             	add    $0x4c,%esp
80104053:	5b                   	pop    %ebx
80104054:	5e                   	pop    %esi
80104055:	5f                   	pop    %edi
80104056:	5d                   	pop    %ebp
80104057:	c3                   	ret    
80104058:	66 90                	xchg   %ax,%ax
8010405a:	66 90                	xchg   %ax,%ax
8010405c:	66 90                	xchg   %ax,%ax
8010405e:	66 90                	xchg   %ax,%ax

80104060 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	53                   	push   %ebx
80104064:	83 ec 14             	sub    $0x14,%esp
80104067:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010406a:	c7 44 24 04 78 73 10 	movl   $0x80107378,0x4(%esp)
80104071:	80 
80104072:	8d 43 04             	lea    0x4(%ebx),%eax
80104075:	89 04 24             	mov    %eax,(%esp)
80104078:	e8 f3 00 00 00       	call   80104170 <initlock>
  lk->name = name;
8010407d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104080:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104086:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010408d:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80104090:	83 c4 14             	add    $0x14,%esp
80104093:	5b                   	pop    %ebx
80104094:	5d                   	pop    %ebp
80104095:	c3                   	ret    
80104096:	8d 76 00             	lea    0x0(%esi),%esi
80104099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040a0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	56                   	push   %esi
801040a4:	53                   	push   %ebx
801040a5:	83 ec 10             	sub    $0x10,%esp
801040a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801040ab:	8d 73 04             	lea    0x4(%ebx),%esi
801040ae:	89 34 24             	mov    %esi,(%esp)
801040b1:	e8 3a 01 00 00       	call   801041f0 <acquire>
  while (lk->locked) {
801040b6:	8b 13                	mov    (%ebx),%edx
801040b8:	85 d2                	test   %edx,%edx
801040ba:	74 16                	je     801040d2 <acquiresleep+0x32>
801040bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801040c0:	89 74 24 04          	mov    %esi,0x4(%esp)
801040c4:	89 1c 24             	mov    %ebx,(%esp)
801040c7:	e8 44 fc ff ff       	call   80103d10 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801040cc:	8b 03                	mov    (%ebx),%eax
801040ce:	85 c0                	test   %eax,%eax
801040d0:	75 ee                	jne    801040c0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801040d2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = proc->pid;
801040d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801040de:	8b 40 10             	mov    0x10(%eax),%eax
801040e1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801040e4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801040e7:	83 c4 10             	add    $0x10,%esp
801040ea:	5b                   	pop    %ebx
801040eb:	5e                   	pop    %esi
801040ec:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = proc->pid;
  release(&lk->lk);
801040ed:	e9 2e 02 00 00       	jmp    80104320 <release>
801040f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104100 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
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
80104111:	e8 da 00 00 00       	call   801041f0 <acquire>
  lk->locked = 0;
80104116:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010411c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104123:	89 1c 24             	mov    %ebx,(%esp)
80104126:	e8 85 fd ff ff       	call   80103eb0 <wakeup>
  release(&lk->lk);
8010412b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010412e:	83 c4 10             	add    $0x10,%esp
80104131:	5b                   	pop    %ebx
80104132:	5e                   	pop    %esi
80104133:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104134:	e9 e7 01 00 00       	jmp    80104320 <release>
80104139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104140 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	56                   	push   %esi
80104144:	53                   	push   %ebx
80104145:	83 ec 10             	sub    $0x10,%esp
80104148:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010414b:	8d 73 04             	lea    0x4(%ebx),%esi
8010414e:	89 34 24             	mov    %esi,(%esp)
80104151:	e8 9a 00 00 00       	call   801041f0 <acquire>
  r = lk->locked;
80104156:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104158:	89 34 24             	mov    %esi,(%esp)
8010415b:	e8 c0 01 00 00       	call   80104320 <release>
  return r;
}
80104160:	83 c4 10             	add    $0x10,%esp
80104163:	89 d8                	mov    %ebx,%eax
80104165:	5b                   	pop    %ebx
80104166:	5e                   	pop    %esi
80104167:	5d                   	pop    %ebp
80104168:	c3                   	ret    
80104169:	66 90                	xchg   %ax,%ax
8010416b:	66 90                	xchg   %ax,%ax
8010416d:	66 90                	xchg   %ax,%ax
8010416f:	90                   	nop

80104170 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104176:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104179:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010417f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104182:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104189:	5d                   	pop    %ebp
8010418a:	c3                   	ret    
8010418b:	90                   	nop
8010418c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104190 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104193:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104196:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104199:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010419a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010419d:	31 c0                	xor    %eax,%eax
8010419f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801041a0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801041a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801041ac:	77 1a                	ja     801041c8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801041ae:	8b 5a 04             	mov    0x4(%edx),%ebx
801041b1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801041b4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801041b7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801041b9:	83 f8 0a             	cmp    $0xa,%eax
801041bc:	75 e2                	jne    801041a0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801041be:	5b                   	pop    %ebx
801041bf:	5d                   	pop    %ebp
801041c0:	c3                   	ret    
801041c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801041c8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801041cf:	83 c0 01             	add    $0x1,%eax
801041d2:	83 f8 0a             	cmp    $0xa,%eax
801041d5:	74 e7                	je     801041be <getcallerpcs+0x2e>
    pcs[i] = 0;
801041d7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801041de:	83 c0 01             	add    $0x1,%eax
801041e1:	83 f8 0a             	cmp    $0xa,%eax
801041e4:	75 e2                	jne    801041c8 <getcallerpcs+0x38>
801041e6:	eb d6                	jmp    801041be <getcallerpcs+0x2e>
801041e8:	90                   	nop
801041e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041f0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	83 ec 18             	sub    $0x18,%esp
801041f6:	9c                   	pushf  
801041f7:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
801041f8:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
801041f9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801041ff:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104205:	85 d2                	test   %edx,%edx
80104207:	75 0c                	jne    80104215 <acquire+0x25>
    cpu->intena = eflags & FL_IF;
80104209:	81 e1 00 02 00 00    	and    $0x200,%ecx
8010420f:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
  cpu->ncli += 1;
80104215:	83 c2 01             	add    $0x1,%edx
80104218:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
8010421e:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104221:	8b 0a                	mov    (%edx),%ecx
80104223:	85 c9                	test   %ecx,%ecx
80104225:	74 05                	je     8010422c <acquire+0x3c>
80104227:	3b 42 08             	cmp    0x8(%edx),%eax
8010422a:	74 3e                	je     8010426a <acquire+0x7a>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010422c:	b9 01 00 00 00       	mov    $0x1,%ecx
80104231:	eb 08                	jmp    8010423b <acquire+0x4b>
80104233:	90                   	nop
80104234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104238:	8b 55 08             	mov    0x8(%ebp),%edx
8010423b:	89 c8                	mov    %ecx,%eax
8010423d:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104240:	85 c0                	test   %eax,%eax
80104242:	75 f4                	jne    80104238 <acquire+0x48>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104244:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104249:	8b 45 08             	mov    0x8(%ebp),%eax
8010424c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  getcallerpcs(&lk, lk->pcs);
80104253:	83 c0 0c             	add    $0xc,%eax
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104256:	89 50 fc             	mov    %edx,-0x4(%eax)
  getcallerpcs(&lk, lk->pcs);
80104259:	89 44 24 04          	mov    %eax,0x4(%esp)
8010425d:	8d 45 08             	lea    0x8(%ebp),%eax
80104260:	89 04 24             	mov    %eax,(%esp)
80104263:	e8 28 ff ff ff       	call   80104190 <getcallerpcs>
}
80104268:	c9                   	leave  
80104269:	c3                   	ret    
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
8010426a:	c7 04 24 83 73 10 80 	movl   $0x80107383,(%esp)
80104271:	e8 ea c0 ff ff       	call   80100360 <panic>
80104276:	8d 76 00             	lea    0x0(%esi),%esi
80104279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104280 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104280:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu;
80104281:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104283:	89 e5                	mov    %esp,%ebp
80104285:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
80104288:	8b 0a                	mov    (%edx),%ecx
8010428a:	85 c9                	test   %ecx,%ecx
8010428c:	74 0f                	je     8010429d <holding+0x1d>
8010428e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104294:	39 42 08             	cmp    %eax,0x8(%edx)
80104297:	0f 94 c0             	sete   %al
8010429a:	0f b6 c0             	movzbl %al,%eax
}
8010429d:	5d                   	pop    %ebp
8010429e:	c3                   	ret    
8010429f:	90                   	nop

801042a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042a3:	9c                   	pushf  
801042a4:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
801042a5:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
801042a6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801042ac:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801042b2:	85 d2                	test   %edx,%edx
801042b4:	75 0c                	jne    801042c2 <pushcli+0x22>
    cpu->intena = eflags & FL_IF;
801042b6:	81 e1 00 02 00 00    	and    $0x200,%ecx
801042bc:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
  cpu->ncli += 1;
801042c2:	83 c2 01             	add    $0x1,%edx
801042c5:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
}
801042cb:	5d                   	pop    %ebp
801042cc:	c3                   	ret    
801042cd:	8d 76 00             	lea    0x0(%esi),%esi

801042d0 <popcli>:

void
popcli(void)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042d6:	9c                   	pushf  
801042d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801042d8:	f6 c4 02             	test   $0x2,%ah
801042db:	75 34                	jne    80104311 <popcli+0x41>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
801042dd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801042e3:	8b 88 ac 00 00 00    	mov    0xac(%eax),%ecx
801042e9:	8d 51 ff             	lea    -0x1(%ecx),%edx
801042ec:	85 d2                	test   %edx,%edx
801042ee:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801042f4:	78 0f                	js     80104305 <popcli+0x35>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
801042f6:	75 0b                	jne    80104303 <popcli+0x33>
801042f8:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801042fe:	85 c0                	test   %eax,%eax
80104300:	74 01                	je     80104303 <popcli+0x33>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104302:	fb                   	sti    
    sti();
}
80104303:	c9                   	leave  
80104304:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
80104305:	c7 04 24 a2 73 10 80 	movl   $0x801073a2,(%esp)
8010430c:	e8 4f c0 ff ff       	call   80100360 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104311:	c7 04 24 8b 73 10 80 	movl   $0x8010738b,(%esp)
80104318:	e8 43 c0 ff ff       	call   80100360 <panic>
8010431d:	8d 76 00             	lea    0x0(%esi),%esi

80104320 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	83 ec 18             	sub    $0x18,%esp
80104326:	8b 45 08             	mov    0x8(%ebp),%eax

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104329:	8b 10                	mov    (%eax),%edx
8010432b:	85 d2                	test   %edx,%edx
8010432d:	74 0c                	je     8010433b <release+0x1b>
8010432f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104336:	39 50 08             	cmp    %edx,0x8(%eax)
80104339:	74 0d                	je     80104348 <release+0x28>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010433b:	c7 04 24 a9 73 10 80 	movl   $0x801073a9,(%esp)
80104342:	e8 19 c0 ff ff       	call   80100360 <panic>
80104347:	90                   	nop

  lk->pcs[0] = 0;
80104348:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010434f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104356:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010435b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
}
80104361:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104362:	e9 69 ff ff ff       	jmp    801042d0 <popcli>
80104367:	66 90                	xchg   %ax,%ax
80104369:	66 90                	xchg   %ax,%ax
8010436b:	66 90                	xchg   %ax,%ax
8010436d:	66 90                	xchg   %ax,%ax
8010436f:	90                   	nop

80104370 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	8b 55 08             	mov    0x8(%ebp),%edx
80104376:	57                   	push   %edi
80104377:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010437a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010437b:	f6 c2 03             	test   $0x3,%dl
8010437e:	75 05                	jne    80104385 <memset+0x15>
80104380:	f6 c1 03             	test   $0x3,%cl
80104383:	74 13                	je     80104398 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104385:	89 d7                	mov    %edx,%edi
80104387:	8b 45 0c             	mov    0xc(%ebp),%eax
8010438a:	fc                   	cld    
8010438b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010438d:	5b                   	pop    %ebx
8010438e:	89 d0                	mov    %edx,%eax
80104390:	5f                   	pop    %edi
80104391:	5d                   	pop    %ebp
80104392:	c3                   	ret    
80104393:	90                   	nop
80104394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104398:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010439c:	c1 e9 02             	shr    $0x2,%ecx
8010439f:	89 f8                	mov    %edi,%eax
801043a1:	89 fb                	mov    %edi,%ebx
801043a3:	c1 e0 18             	shl    $0x18,%eax
801043a6:	c1 e3 10             	shl    $0x10,%ebx
801043a9:	09 d8                	or     %ebx,%eax
801043ab:	09 f8                	or     %edi,%eax
801043ad:	c1 e7 08             	shl    $0x8,%edi
801043b0:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801043b2:	89 d7                	mov    %edx,%edi
801043b4:	fc                   	cld    
801043b5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801043b7:	5b                   	pop    %ebx
801043b8:	89 d0                	mov    %edx,%eax
801043ba:	5f                   	pop    %edi
801043bb:	5d                   	pop    %ebp
801043bc:	c3                   	ret    
801043bd:	8d 76 00             	lea    0x0(%esi),%esi

801043c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	8b 45 10             	mov    0x10(%ebp),%eax
801043c6:	57                   	push   %edi
801043c7:	56                   	push   %esi
801043c8:	8b 75 0c             	mov    0xc(%ebp),%esi
801043cb:	53                   	push   %ebx
801043cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801043cf:	85 c0                	test   %eax,%eax
801043d1:	8d 78 ff             	lea    -0x1(%eax),%edi
801043d4:	74 26                	je     801043fc <memcmp+0x3c>
    if(*s1 != *s2)
801043d6:	0f b6 03             	movzbl (%ebx),%eax
801043d9:	31 d2                	xor    %edx,%edx
801043db:	0f b6 0e             	movzbl (%esi),%ecx
801043de:	38 c8                	cmp    %cl,%al
801043e0:	74 16                	je     801043f8 <memcmp+0x38>
801043e2:	eb 24                	jmp    80104408 <memcmp+0x48>
801043e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043e8:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
801043ed:	83 c2 01             	add    $0x1,%edx
801043f0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801043f4:	38 c8                	cmp    %cl,%al
801043f6:	75 10                	jne    80104408 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801043f8:	39 fa                	cmp    %edi,%edx
801043fa:	75 ec                	jne    801043e8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801043fc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801043fd:	31 c0                	xor    %eax,%eax
}
801043ff:	5e                   	pop    %esi
80104400:	5f                   	pop    %edi
80104401:	5d                   	pop    %ebp
80104402:	c3                   	ret    
80104403:	90                   	nop
80104404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104408:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104409:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010440b:	5e                   	pop    %esi
8010440c:	5f                   	pop    %edi
8010440d:	5d                   	pop    %ebp
8010440e:	c3                   	ret    
8010440f:	90                   	nop

80104410 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	57                   	push   %edi
80104414:	8b 45 08             	mov    0x8(%ebp),%eax
80104417:	56                   	push   %esi
80104418:	8b 75 0c             	mov    0xc(%ebp),%esi
8010441b:	53                   	push   %ebx
8010441c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010441f:	39 c6                	cmp    %eax,%esi
80104421:	73 35                	jae    80104458 <memmove+0x48>
80104423:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104426:	39 c8                	cmp    %ecx,%eax
80104428:	73 2e                	jae    80104458 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010442a:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
8010442c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010442f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104432:	74 1b                	je     8010444f <memmove+0x3f>
80104434:	f7 db                	neg    %ebx
80104436:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104439:	01 fb                	add    %edi,%ebx
8010443b:	90                   	nop
8010443c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104440:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104444:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104447:	83 ea 01             	sub    $0x1,%edx
8010444a:	83 fa ff             	cmp    $0xffffffff,%edx
8010444d:	75 f1                	jne    80104440 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010444f:	5b                   	pop    %ebx
80104450:	5e                   	pop    %esi
80104451:	5f                   	pop    %edi
80104452:	5d                   	pop    %ebp
80104453:	c3                   	ret    
80104454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104458:	31 d2                	xor    %edx,%edx
8010445a:	85 db                	test   %ebx,%ebx
8010445c:	74 f1                	je     8010444f <memmove+0x3f>
8010445e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104460:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104464:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104467:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010446a:	39 da                	cmp    %ebx,%edx
8010446c:	75 f2                	jne    80104460 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010446e:	5b                   	pop    %ebx
8010446f:	5e                   	pop    %esi
80104470:	5f                   	pop    %edi
80104471:	5d                   	pop    %ebp
80104472:	c3                   	ret    
80104473:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104480 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104483:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104484:	e9 87 ff ff ff       	jmp    80104410 <memmove>
80104489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104490 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	56                   	push   %esi
80104494:	8b 75 10             	mov    0x10(%ebp),%esi
80104497:	53                   	push   %ebx
80104498:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010449b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
8010449e:	85 f6                	test   %esi,%esi
801044a0:	74 30                	je     801044d2 <strncmp+0x42>
801044a2:	0f b6 01             	movzbl (%ecx),%eax
801044a5:	84 c0                	test   %al,%al
801044a7:	74 2f                	je     801044d8 <strncmp+0x48>
801044a9:	0f b6 13             	movzbl (%ebx),%edx
801044ac:	38 d0                	cmp    %dl,%al
801044ae:	75 46                	jne    801044f6 <strncmp+0x66>
801044b0:	8d 51 01             	lea    0x1(%ecx),%edx
801044b3:	01 ce                	add    %ecx,%esi
801044b5:	eb 14                	jmp    801044cb <strncmp+0x3b>
801044b7:	90                   	nop
801044b8:	0f b6 02             	movzbl (%edx),%eax
801044bb:	84 c0                	test   %al,%al
801044bd:	74 31                	je     801044f0 <strncmp+0x60>
801044bf:	0f b6 19             	movzbl (%ecx),%ebx
801044c2:	83 c2 01             	add    $0x1,%edx
801044c5:	38 d8                	cmp    %bl,%al
801044c7:	75 17                	jne    801044e0 <strncmp+0x50>
    n--, p++, q++;
801044c9:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801044cb:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801044cd:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801044d0:	75 e6                	jne    801044b8 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801044d2:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
801044d3:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
801044d5:	5e                   	pop    %esi
801044d6:	5d                   	pop    %ebp
801044d7:	c3                   	ret    
801044d8:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801044db:	31 c0                	xor    %eax,%eax
801044dd:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801044e0:	0f b6 d3             	movzbl %bl,%edx
801044e3:	29 d0                	sub    %edx,%eax
}
801044e5:	5b                   	pop    %ebx
801044e6:	5e                   	pop    %esi
801044e7:	5d                   	pop    %ebp
801044e8:	c3                   	ret    
801044e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044f0:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
801044f4:	eb ea                	jmp    801044e0 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801044f6:	89 d3                	mov    %edx,%ebx
801044f8:	eb e6                	jmp    801044e0 <strncmp+0x50>
801044fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104500 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	8b 45 08             	mov    0x8(%ebp),%eax
80104506:	56                   	push   %esi
80104507:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010450a:	53                   	push   %ebx
8010450b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010450e:	89 c2                	mov    %eax,%edx
80104510:	eb 19                	jmp    8010452b <strncpy+0x2b>
80104512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104518:	83 c3 01             	add    $0x1,%ebx
8010451b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010451f:	83 c2 01             	add    $0x1,%edx
80104522:	84 c9                	test   %cl,%cl
80104524:	88 4a ff             	mov    %cl,-0x1(%edx)
80104527:	74 09                	je     80104532 <strncpy+0x32>
80104529:	89 f1                	mov    %esi,%ecx
8010452b:	85 c9                	test   %ecx,%ecx
8010452d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104530:	7f e6                	jg     80104518 <strncpy+0x18>
    ;
  while(n-- > 0)
80104532:	31 c9                	xor    %ecx,%ecx
80104534:	85 f6                	test   %esi,%esi
80104536:	7e 0f                	jle    80104547 <strncpy+0x47>
    *s++ = 0;
80104538:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010453c:	89 f3                	mov    %esi,%ebx
8010453e:	83 c1 01             	add    $0x1,%ecx
80104541:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104543:	85 db                	test   %ebx,%ebx
80104545:	7f f1                	jg     80104538 <strncpy+0x38>
    *s++ = 0;
  return os;
}
80104547:	5b                   	pop    %ebx
80104548:	5e                   	pop    %esi
80104549:	5d                   	pop    %ebp
8010454a:	c3                   	ret    
8010454b:	90                   	nop
8010454c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104550 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104556:	56                   	push   %esi
80104557:	8b 45 08             	mov    0x8(%ebp),%eax
8010455a:	53                   	push   %ebx
8010455b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010455e:	85 c9                	test   %ecx,%ecx
80104560:	7e 26                	jle    80104588 <safestrcpy+0x38>
80104562:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104566:	89 c1                	mov    %eax,%ecx
80104568:	eb 17                	jmp    80104581 <safestrcpy+0x31>
8010456a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104570:	83 c2 01             	add    $0x1,%edx
80104573:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104577:	83 c1 01             	add    $0x1,%ecx
8010457a:	84 db                	test   %bl,%bl
8010457c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010457f:	74 04                	je     80104585 <safestrcpy+0x35>
80104581:	39 f2                	cmp    %esi,%edx
80104583:	75 eb                	jne    80104570 <safestrcpy+0x20>
    ;
  *s = 0;
80104585:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104588:	5b                   	pop    %ebx
80104589:	5e                   	pop    %esi
8010458a:	5d                   	pop    %ebp
8010458b:	c3                   	ret    
8010458c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104590 <strlen>:

int
strlen(const char *s)
{
80104590:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104591:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104593:	89 e5                	mov    %esp,%ebp
80104595:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104598:	80 3a 00             	cmpb   $0x0,(%edx)
8010459b:	74 0c                	je     801045a9 <strlen+0x19>
8010459d:	8d 76 00             	lea    0x0(%esi),%esi
801045a0:	83 c0 01             	add    $0x1,%eax
801045a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801045a7:	75 f7                	jne    801045a0 <strlen+0x10>
    ;
  return n;
}
801045a9:	5d                   	pop    %ebp
801045aa:	c3                   	ret    

801045ab <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801045ab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801045af:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801045b3:	55                   	push   %ebp
  pushl %ebx
801045b4:	53                   	push   %ebx
  pushl %esi
801045b5:	56                   	push   %esi
  pushl %edi
801045b6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801045b7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801045b9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801045bb:	5f                   	pop    %edi
  popl %esi
801045bc:	5e                   	pop    %esi
  popl %ebx
801045bd:	5b                   	pop    %ebx
  popl %ebp
801045be:	5d                   	pop    %ebp
  ret
801045bf:	c3                   	ret    

801045c0 <fetchint>:

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801045c0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801045c7:	55                   	push   %ebp
801045c8:	89 e5                	mov    %esp,%ebp
801045ca:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
801045cd:	8b 12                	mov    (%edx),%edx
801045cf:	39 c2                	cmp    %eax,%edx
801045d1:	76 15                	jbe    801045e8 <fetchint+0x28>
801045d3:	8d 48 04             	lea    0x4(%eax),%ecx
801045d6:	39 ca                	cmp    %ecx,%edx
801045d8:	72 0e                	jb     801045e8 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
801045da:	8b 10                	mov    (%eax),%edx
801045dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801045df:	89 10                	mov    %edx,(%eax)
  return 0;
801045e1:	31 c0                	xor    %eax,%eax
}
801045e3:	5d                   	pop    %ebp
801045e4:	c3                   	ret    
801045e5:	8d 76 00             	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
801045e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  *ip = *(int*)(addr);
  return 0;
}
801045ed:	5d                   	pop    %ebp
801045ee:	c3                   	ret    
801045ef:	90                   	nop

801045f0 <fetchstr>:
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
801045f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801045f6:	55                   	push   %ebp
801045f7:	89 e5                	mov    %esp,%ebp
801045f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *s, *ep;

  if(addr >= proc->sz)
801045fc:	39 08                	cmp    %ecx,(%eax)
801045fe:	76 2c                	jbe    8010462c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104600:	8b 55 0c             	mov    0xc(%ebp),%edx
80104603:	89 c8                	mov    %ecx,%eax
80104605:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
80104607:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010460e:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104610:	39 d1                	cmp    %edx,%ecx
80104612:	73 18                	jae    8010462c <fetchstr+0x3c>
    if(*s == 0)
80104614:	80 39 00             	cmpb   $0x0,(%ecx)
80104617:	75 0c                	jne    80104625 <fetchstr+0x35>
80104619:	eb 1d                	jmp    80104638 <fetchstr+0x48>
8010461b:	90                   	nop
8010461c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104620:	80 38 00             	cmpb   $0x0,(%eax)
80104623:	74 13                	je     80104638 <fetchstr+0x48>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104625:	83 c0 01             	add    $0x1,%eax
80104628:	39 c2                	cmp    %eax,%edx
8010462a:	77 f4                	ja     80104620 <fetchstr+0x30>
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
    return -1;
8010462c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
  return -1;
}
80104631:	5d                   	pop    %ebp
80104632:	c3                   	ret    
80104633:	90                   	nop
80104634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
80104638:	29 c8                	sub    %ecx,%eax
  return -1;
}
8010463a:	5d                   	pop    %ebp
8010463b:	c3                   	ret    
8010463c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104640 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104640:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104647:	55                   	push   %ebp
80104648:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010464a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010464d:	8b 42 18             	mov    0x18(%edx),%eax

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104650:	8b 12                	mov    (%edx),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104652:	8b 40 44             	mov    0x44(%eax),%eax
80104655:	8d 04 88             	lea    (%eax,%ecx,4),%eax
80104658:	8d 48 04             	lea    0x4(%eax),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010465b:	39 d1                	cmp    %edx,%ecx
8010465d:	73 19                	jae    80104678 <argint+0x38>
8010465f:	8d 48 08             	lea    0x8(%eax),%ecx
80104662:	39 ca                	cmp    %ecx,%edx
80104664:	72 12                	jb     80104678 <argint+0x38>
    return -1;
  *ip = *(int*)(addr);
80104666:	8b 50 04             	mov    0x4(%eax),%edx
80104669:	8b 45 0c             	mov    0xc(%ebp),%eax
8010466c:	89 10                	mov    %edx,(%eax)
  return 0;
8010466e:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
80104670:	5d                   	pop    %ebp
80104671:	c3                   	ret    
80104672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104678:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
8010467d:	5d                   	pop    %ebp
8010467e:	c3                   	ret    
8010467f:	90                   	nop

80104680 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104680:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104686:	55                   	push   %ebp
80104687:	89 e5                	mov    %esp,%ebp
80104689:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010468a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010468d:	8b 50 18             	mov    0x18(%eax),%edx
80104690:	8b 52 44             	mov    0x44(%edx),%edx
80104693:	8d 0c 8a             	lea    (%edx,%ecx,4),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104696:	8b 10                	mov    (%eax),%edx
argptr(int n, char **pp, int size)
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
80104698:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010469d:	8d 59 04             	lea    0x4(%ecx),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801046a0:	39 d3                	cmp    %edx,%ebx
801046a2:	73 25                	jae    801046c9 <argptr+0x49>
801046a4:	8d 59 08             	lea    0x8(%ecx),%ebx
801046a7:	39 da                	cmp    %ebx,%edx
801046a9:	72 1e                	jb     801046c9 <argptr+0x49>
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
801046ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
801046ae:	8b 49 04             	mov    0x4(%ecx),%ecx
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
801046b1:	85 db                	test   %ebx,%ebx
801046b3:	78 14                	js     801046c9 <argptr+0x49>
801046b5:	39 d1                	cmp    %edx,%ecx
801046b7:	73 10                	jae    801046c9 <argptr+0x49>
801046b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
801046bc:	01 cb                	add    %ecx,%ebx
801046be:	39 d3                	cmp    %edx,%ebx
801046c0:	77 07                	ja     801046c9 <argptr+0x49>
    return -1;
  *pp = (char*)i;
801046c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801046c5:	89 08                	mov    %ecx,(%eax)
  return 0;
801046c7:	31 c0                	xor    %eax,%eax
}
801046c9:	5b                   	pop    %ebx
801046ca:	5d                   	pop    %ebp
801046cb:	c3                   	ret    
801046cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046d0 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801046d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801046d6:	55                   	push   %ebp
801046d7:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801046d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801046dc:	8b 50 18             	mov    0x18(%eax),%edx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801046df:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801046e1:	8b 52 44             	mov    0x44(%edx),%edx
801046e4:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
801046e7:	8d 4a 04             	lea    0x4(%edx),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801046ea:	39 c1                	cmp    %eax,%ecx
801046ec:	73 07                	jae    801046f5 <argstr+0x25>
801046ee:	8d 4a 08             	lea    0x8(%edx),%ecx
801046f1:	39 c8                	cmp    %ecx,%eax
801046f3:	73 0b                	jae    80104700 <argstr+0x30>
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
801046f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
801046fa:	5d                   	pop    %ebp
801046fb:	c3                   	ret    
801046fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
80104700:	8b 4a 04             	mov    0x4(%edx),%ecx
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
80104703:	39 c1                	cmp    %eax,%ecx
80104705:	73 ee                	jae    801046f5 <argstr+0x25>
    return -1;
  *pp = (char*)addr;
80104707:	8b 55 0c             	mov    0xc(%ebp),%edx
8010470a:	89 c8                	mov    %ecx,%eax
8010470c:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
8010470e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104715:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104717:	39 d1                	cmp    %edx,%ecx
80104719:	73 da                	jae    801046f5 <argstr+0x25>
    if(*s == 0)
8010471b:	80 39 00             	cmpb   $0x0,(%ecx)
8010471e:	75 12                	jne    80104732 <argstr+0x62>
80104720:	eb 1e                	jmp    80104740 <argstr+0x70>
80104722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104728:	80 38 00             	cmpb   $0x0,(%eax)
8010472b:	90                   	nop
8010472c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104730:	74 0e                	je     80104740 <argstr+0x70>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104732:	83 c0 01             	add    $0x1,%eax
80104735:	39 c2                	cmp    %eax,%edx
80104737:	77 ef                	ja     80104728 <argstr+0x58>
80104739:	eb ba                	jmp    801046f5 <argstr+0x25>
8010473b:	90                   	nop
8010473c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == 0)
      return s - *pp;
80104740:	29 c8                	sub    %ecx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104742:	5d                   	pop    %ebp
80104743:	c3                   	ret    
80104744:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010474a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104750 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	53                   	push   %ebx
80104754:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80104757:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010475e:	8b 5a 18             	mov    0x18(%edx),%ebx
80104761:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104764:	8d 48 ff             	lea    -0x1(%eax),%ecx
80104767:	83 f9 14             	cmp    $0x14,%ecx
8010476a:	77 1c                	ja     80104788 <syscall+0x38>
8010476c:	8b 0c 85 e0 73 10 80 	mov    -0x7fef8c20(,%eax,4),%ecx
80104773:	85 c9                	test   %ecx,%ecx
80104775:	74 11                	je     80104788 <syscall+0x38>
    proc->tf->eax = syscalls[num]();
80104777:	ff d1                	call   *%ecx
80104779:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
8010477c:	83 c4 14             	add    $0x14,%esp
8010477f:	5b                   	pop    %ebx
80104780:	5d                   	pop    %ebp
80104781:	c3                   	ret    
80104782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104788:	89 44 24 0c          	mov    %eax,0xc(%esp)
            proc->pid, proc->name, num);
8010478c:	8d 42 6c             	lea    0x6c(%edx),%eax
8010478f:	89 44 24 08          	mov    %eax,0x8(%esp)

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104793:	8b 42 10             	mov    0x10(%edx),%eax
80104796:	c7 04 24 b1 73 10 80 	movl   $0x801073b1,(%esp)
8010479d:	89 44 24 04          	mov    %eax,0x4(%esp)
801047a1:	e8 aa be ff ff       	call   80100650 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801047a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047ac:	8b 40 18             	mov    0x18(%eax),%eax
801047af:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801047b6:	83 c4 14             	add    $0x14,%esp
801047b9:	5b                   	pop    %ebx
801047ba:	5d                   	pop    %ebp
801047bb:	c3                   	ret    
801047bc:	66 90                	xchg   %ax,%ax
801047be:	66 90                	xchg   %ax,%ax

801047c0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	57                   	push   %edi
801047c4:	56                   	push   %esi
801047c5:	53                   	push   %ebx
801047c6:	83 ec 4c             	sub    $0x4c,%esp
801047c9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801047cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801047cf:	8d 5d da             	lea    -0x26(%ebp),%ebx
801047d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801047d6:	89 04 24             	mov    %eax,(%esp)
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801047d9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801047dc:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801047df:	e8 5c d7 ff ff       	call   80101f40 <nameiparent>
801047e4:	85 c0                	test   %eax,%eax
801047e6:	89 c7                	mov    %eax,%edi
801047e8:	0f 84 da 00 00 00    	je     801048c8 <create+0x108>
    return 0;
  ilock(dp);
801047ee:	89 04 24             	mov    %eax,(%esp)
801047f1:	e8 fa ce ff ff       	call   801016f0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801047f6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801047f9:	89 44 24 08          	mov    %eax,0x8(%esp)
801047fd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104801:	89 3c 24             	mov    %edi,(%esp)
80104804:	e8 d7 d3 ff ff       	call   80101be0 <dirlookup>
80104809:	85 c0                	test   %eax,%eax
8010480b:	89 c6                	mov    %eax,%esi
8010480d:	74 41                	je     80104850 <create+0x90>
    iunlockput(dp);
8010480f:	89 3c 24             	mov    %edi,(%esp)
80104812:	e8 19 d1 ff ff       	call   80101930 <iunlockput>
    ilock(ip);
80104817:	89 34 24             	mov    %esi,(%esp)
8010481a:	e8 d1 ce ff ff       	call   801016f0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010481f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104824:	75 12                	jne    80104838 <create+0x78>
80104826:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010482b:	89 f0                	mov    %esi,%eax
8010482d:	75 09                	jne    80104838 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010482f:	83 c4 4c             	add    $0x4c,%esp
80104832:	5b                   	pop    %ebx
80104833:	5e                   	pop    %esi
80104834:	5f                   	pop    %edi
80104835:	5d                   	pop    %ebp
80104836:	c3                   	ret    
80104837:	90                   	nop
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104838:	89 34 24             	mov    %esi,(%esp)
8010483b:	e8 f0 d0 ff ff       	call   80101930 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104840:	83 c4 4c             	add    $0x4c,%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104843:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104845:	5b                   	pop    %ebx
80104846:	5e                   	pop    %esi
80104847:	5f                   	pop    %edi
80104848:	5d                   	pop    %ebp
80104849:	c3                   	ret    
8010484a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104850:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104854:	89 44 24 04          	mov    %eax,0x4(%esp)
80104858:	8b 07                	mov    (%edi),%eax
8010485a:	89 04 24             	mov    %eax,(%esp)
8010485d:	e8 fe cc ff ff       	call   80101560 <ialloc>
80104862:	85 c0                	test   %eax,%eax
80104864:	89 c6                	mov    %eax,%esi
80104866:	0f 84 bf 00 00 00    	je     8010492b <create+0x16b>
    panic("create: ialloc");

  ilock(ip);
8010486c:	89 04 24             	mov    %eax,(%esp)
8010486f:	e8 7c ce ff ff       	call   801016f0 <ilock>
  ip->major = major;
80104874:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104878:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010487c:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104880:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104884:	b8 01 00 00 00       	mov    $0x1,%eax
80104889:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010488d:	89 34 24             	mov    %esi,(%esp)
80104890:	e8 9b cd ff ff       	call   80101630 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104895:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010489a:	74 34                	je     801048d0 <create+0x110>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010489c:	8b 46 04             	mov    0x4(%esi),%eax
8010489f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801048a3:	89 3c 24             	mov    %edi,(%esp)
801048a6:	89 44 24 08          	mov    %eax,0x8(%esp)
801048aa:	e8 91 d5 ff ff       	call   80101e40 <dirlink>
801048af:	85 c0                	test   %eax,%eax
801048b1:	78 6c                	js     8010491f <create+0x15f>
    panic("create: dirlink");

  iunlockput(dp);
801048b3:	89 3c 24             	mov    %edi,(%esp)
801048b6:	e8 75 d0 ff ff       	call   80101930 <iunlockput>

  return ip;
}
801048bb:	83 c4 4c             	add    $0x4c,%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
801048be:	89 f0                	mov    %esi,%eax
}
801048c0:	5b                   	pop    %ebx
801048c1:	5e                   	pop    %esi
801048c2:	5f                   	pop    %edi
801048c3:	5d                   	pop    %ebp
801048c4:	c3                   	ret    
801048c5:	8d 76 00             	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
801048c8:	31 c0                	xor    %eax,%eax
801048ca:	e9 60 ff ff ff       	jmp    8010482f <create+0x6f>
801048cf:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
801048d0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801048d5:	89 3c 24             	mov    %edi,(%esp)
801048d8:	e8 53 cd ff ff       	call   80101630 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801048dd:	8b 46 04             	mov    0x4(%esi),%eax
801048e0:	c7 44 24 04 54 74 10 	movl   $0x80107454,0x4(%esp)
801048e7:	80 
801048e8:	89 34 24             	mov    %esi,(%esp)
801048eb:	89 44 24 08          	mov    %eax,0x8(%esp)
801048ef:	e8 4c d5 ff ff       	call   80101e40 <dirlink>
801048f4:	85 c0                	test   %eax,%eax
801048f6:	78 1b                	js     80104913 <create+0x153>
801048f8:	8b 47 04             	mov    0x4(%edi),%eax
801048fb:	c7 44 24 04 53 74 10 	movl   $0x80107453,0x4(%esp)
80104902:	80 
80104903:	89 34 24             	mov    %esi,(%esp)
80104906:	89 44 24 08          	mov    %eax,0x8(%esp)
8010490a:	e8 31 d5 ff ff       	call   80101e40 <dirlink>
8010490f:	85 c0                	test   %eax,%eax
80104911:	79 89                	jns    8010489c <create+0xdc>
      panic("create dots");
80104913:	c7 04 24 47 74 10 80 	movl   $0x80107447,(%esp)
8010491a:	e8 41 ba ff ff       	call   80100360 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010491f:	c7 04 24 56 74 10 80 	movl   $0x80107456,(%esp)
80104926:	e8 35 ba ff ff       	call   80100360 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
8010492b:	c7 04 24 38 74 10 80 	movl   $0x80107438,(%esp)
80104932:	e8 29 ba ff ff       	call   80100360 <panic>
80104937:	89 f6                	mov    %esi,%esi
80104939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104940 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	89 c6                	mov    %eax,%esi
80104946:	53                   	push   %ebx
80104947:	89 d3                	mov    %edx,%ebx
80104949:	83 ec 20             	sub    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010494c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010494f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104953:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010495a:	e8 e1 fc ff ff       	call   80104640 <argint>
8010495f:	85 c0                	test   %eax,%eax
80104961:	78 35                	js     80104998 <argfd.constprop.0+0x58>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80104963:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104966:	83 f9 0f             	cmp    $0xf,%ecx
80104969:	77 2d                	ja     80104998 <argfd.constprop.0+0x58>
8010496b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104971:	8b 44 88 28          	mov    0x28(%eax,%ecx,4),%eax
80104975:	85 c0                	test   %eax,%eax
80104977:	74 1f                	je     80104998 <argfd.constprop.0+0x58>
    return -1;
  if(pfd)
80104979:	85 f6                	test   %esi,%esi
8010497b:	74 02                	je     8010497f <argfd.constprop.0+0x3f>
    *pfd = fd;
8010497d:	89 0e                	mov    %ecx,(%esi)
  if(pf)
8010497f:	85 db                	test   %ebx,%ebx
80104981:	74 0d                	je     80104990 <argfd.constprop.0+0x50>
    *pf = f;
80104983:	89 03                	mov    %eax,(%ebx)
  return 0;
80104985:	31 c0                	xor    %eax,%eax
}
80104987:	83 c4 20             	add    $0x20,%esp
8010498a:	5b                   	pop    %ebx
8010498b:	5e                   	pop    %esi
8010498c:	5d                   	pop    %ebp
8010498d:	c3                   	ret    
8010498e:	66 90                	xchg   %ax,%ax
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104990:	31 c0                	xor    %eax,%eax
80104992:	eb f3                	jmp    80104987 <argfd.constprop.0+0x47>
80104994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104998:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010499d:	eb e8                	jmp    80104987 <argfd.constprop.0+0x47>
8010499f:	90                   	nop

801049a0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801049a0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801049a1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
801049a3:	89 e5                	mov    %esp,%ebp
801049a5:	53                   	push   %ebx
801049a6:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801049a9:	8d 55 f4             	lea    -0xc(%ebp),%edx
801049ac:	e8 8f ff ff ff       	call   80104940 <argfd.constprop.0>
801049b1:	85 c0                	test   %eax,%eax
801049b3:	78 1b                	js     801049d0 <sys_dup+0x30>
    return -1;
  if((fd=fdalloc(f)) < 0)
801049b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801049b8:	31 db                	xor    %ebx,%ebx
801049ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    if(proc->ofile[fd] == 0){
801049c0:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
801049c4:	85 c9                	test   %ecx,%ecx
801049c6:	74 18                	je     801049e0 <sys_dup+0x40>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801049c8:	83 c3 01             	add    $0x1,%ebx
801049cb:	83 fb 10             	cmp    $0x10,%ebx
801049ce:	75 f0                	jne    801049c0 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
801049d0:	83 c4 24             	add    $0x24,%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
801049d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
801049d8:	5b                   	pop    %ebx
801049d9:	5d                   	pop    %ebp
801049da:	c3                   	ret    
801049db:	90                   	nop
801049dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801049e0:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
801049e4:	89 14 24             	mov    %edx,(%esp)
801049e7:	e8 24 c4 ff ff       	call   80100e10 <filedup>
  return fd;
}
801049ec:	83 c4 24             	add    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
801049ef:	89 d8                	mov    %ebx,%eax
}
801049f1:	5b                   	pop    %ebx
801049f2:	5d                   	pop    %ebp
801049f3:	c3                   	ret    
801049f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a00 <sys_read>:

int
sys_read(void)
{
80104a00:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a01:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104a03:	89 e5                	mov    %esp,%ebp
80104a05:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a08:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104a0b:	e8 30 ff ff ff       	call   80104940 <argfd.constprop.0>
80104a10:	85 c0                	test   %eax,%eax
80104a12:	78 54                	js     80104a68 <sys_read+0x68>
80104a14:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a17:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a1b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104a22:	e8 19 fc ff ff       	call   80104640 <argint>
80104a27:	85 c0                	test   %eax,%eax
80104a29:	78 3d                	js     80104a68 <sys_read+0x68>
80104a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a35:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a39:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a40:	e8 3b fc ff ff       	call   80104680 <argptr>
80104a45:	85 c0                	test   %eax,%eax
80104a47:	78 1f                	js     80104a68 <sys_read+0x68>
    return -1;
  return fileread(f, p, n);
80104a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a4c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a53:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a57:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a5a:	89 04 24             	mov    %eax,(%esp)
80104a5d:	e8 0e c5 ff ff       	call   80100f70 <fileread>
}
80104a62:	c9                   	leave  
80104a63:	c3                   	ret    
80104a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104a6d:	c9                   	leave  
80104a6e:	c3                   	ret    
80104a6f:	90                   	nop

80104a70 <sys_write>:

int
sys_write(void)
{
80104a70:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a71:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104a73:	89 e5                	mov    %esp,%ebp
80104a75:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a78:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104a7b:	e8 c0 fe ff ff       	call   80104940 <argfd.constprop.0>
80104a80:	85 c0                	test   %eax,%eax
80104a82:	78 54                	js     80104ad8 <sys_write+0x68>
80104a84:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a8b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104a92:	e8 a9 fb ff ff       	call   80104640 <argint>
80104a97:	85 c0                	test   %eax,%eax
80104a99:	78 3d                	js     80104ad8 <sys_write+0x68>
80104a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a9e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104aa5:	89 44 24 08          	mov    %eax,0x8(%esp)
80104aa9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104aac:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ab0:	e8 cb fb ff ff       	call   80104680 <argptr>
80104ab5:	85 c0                	test   %eax,%eax
80104ab7:	78 1f                	js     80104ad8 <sys_write+0x68>
    return -1;
  return filewrite(f, p, n);
80104ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104abc:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ac7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104aca:	89 04 24             	mov    %eax,(%esp)
80104acd:	e8 3e c5 ff ff       	call   80101010 <filewrite>
}
80104ad2:	c9                   	leave  
80104ad3:	c3                   	ret    
80104ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104ad8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104add:	c9                   	leave  
80104ade:	c3                   	ret    
80104adf:	90                   	nop

80104ae0 <sys_close>:

int
sys_close(void)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104ae6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104ae9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104aec:	e8 4f fe ff ff       	call   80104940 <argfd.constprop.0>
80104af1:	85 c0                	test   %eax,%eax
80104af3:	78 23                	js     80104b18 <sys_close+0x38>
    return -1;
  proc->ofile[fd] = 0;
80104af5:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104af8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104afe:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104b05:	00 
  fileclose(f);
80104b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b09:	89 04 24             	mov    %eax,(%esp)
80104b0c:	e8 4f c3 ff ff       	call   80100e60 <fileclose>
  return 0;
80104b11:	31 c0                	xor    %eax,%eax
}
80104b13:	c9                   	leave  
80104b14:	c3                   	ret    
80104b15:	8d 76 00             	lea    0x0(%esi),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104b18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  proc->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104b1d:	c9                   	leave  
80104b1e:	c3                   	ret    
80104b1f:	90                   	nop

80104b20 <sys_fstat>:

int
sys_fstat(void)
{
80104b20:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b21:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104b23:	89 e5                	mov    %esp,%ebp
80104b25:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b28:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104b2b:	e8 10 fe ff ff       	call   80104940 <argfd.constprop.0>
80104b30:	85 c0                	test   %eax,%eax
80104b32:	78 34                	js     80104b68 <sys_fstat+0x48>
80104b34:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b37:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104b3e:	00 
80104b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b43:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b4a:	e8 31 fb ff ff       	call   80104680 <argptr>
80104b4f:	85 c0                	test   %eax,%eax
80104b51:	78 15                	js     80104b68 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80104b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b56:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b5d:	89 04 24             	mov    %eax,(%esp)
80104b60:	e8 bb c3 ff ff       	call   80100f20 <filestat>
}
80104b65:	c9                   	leave  
80104b66:	c3                   	ret    
80104b67:	90                   	nop
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104b68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104b6d:	c9                   	leave  
80104b6e:	c3                   	ret    
80104b6f:	90                   	nop

80104b70 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	57                   	push   %edi
80104b74:	56                   	push   %esi
80104b75:	53                   	push   %ebx
80104b76:	83 ec 3c             	sub    $0x3c,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104b79:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104b87:	e8 44 fb ff ff       	call   801046d0 <argstr>
80104b8c:	85 c0                	test   %eax,%eax
80104b8e:	0f 88 e6 00 00 00    	js     80104c7a <sys_link+0x10a>
80104b94:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104b97:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b9b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104ba2:	e8 29 fb ff ff       	call   801046d0 <argstr>
80104ba7:	85 c0                	test   %eax,%eax
80104ba9:	0f 88 cb 00 00 00    	js     80104c7a <sys_link+0x10a>
    return -1;

  begin_op();
80104baf:	e8 0c e0 ff ff       	call   80102bc0 <begin_op>
  if((ip = namei(old)) == 0){
80104bb4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104bb7:	89 04 24             	mov    %eax,(%esp)
80104bba:	e8 61 d3 ff ff       	call   80101f20 <namei>
80104bbf:	85 c0                	test   %eax,%eax
80104bc1:	89 c3                	mov    %eax,%ebx
80104bc3:	0f 84 ac 00 00 00    	je     80104c75 <sys_link+0x105>
    end_op();
    return -1;
  }

  ilock(ip);
80104bc9:	89 04 24             	mov    %eax,(%esp)
80104bcc:	e8 1f cb ff ff       	call   801016f0 <ilock>
  if(ip->type == T_DIR){
80104bd1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104bd6:	0f 84 91 00 00 00    	je     80104c6d <sys_link+0xfd>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104bdc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104be1:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104be4:	89 1c 24             	mov    %ebx,(%esp)
80104be7:	e8 44 ca ff ff       	call   80101630 <iupdate>
  iunlock(ip);
80104bec:	89 1c 24             	mov    %ebx,(%esp)
80104bef:	e8 cc cb ff ff       	call   801017c0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104bf4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104bf7:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104bfb:	89 04 24             	mov    %eax,(%esp)
80104bfe:	e8 3d d3 ff ff       	call   80101f40 <nameiparent>
80104c03:	85 c0                	test   %eax,%eax
80104c05:	89 c6                	mov    %eax,%esi
80104c07:	74 4f                	je     80104c58 <sys_link+0xe8>
    goto bad;
  ilock(dp);
80104c09:	89 04 24             	mov    %eax,(%esp)
80104c0c:	e8 df ca ff ff       	call   801016f0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104c11:	8b 03                	mov    (%ebx),%eax
80104c13:	39 06                	cmp    %eax,(%esi)
80104c15:	75 39                	jne    80104c50 <sys_link+0xe0>
80104c17:	8b 43 04             	mov    0x4(%ebx),%eax
80104c1a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c1e:	89 34 24             	mov    %esi,(%esp)
80104c21:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c25:	e8 16 d2 ff ff       	call   80101e40 <dirlink>
80104c2a:	85 c0                	test   %eax,%eax
80104c2c:	78 22                	js     80104c50 <sys_link+0xe0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104c2e:	89 34 24             	mov    %esi,(%esp)
80104c31:	e8 fa cc ff ff       	call   80101930 <iunlockput>
  iput(ip);
80104c36:	89 1c 24             	mov    %ebx,(%esp)
80104c39:	e8 c2 cb ff ff       	call   80101800 <iput>

  end_op();
80104c3e:	e8 ed df ff ff       	call   80102c30 <end_op>
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104c43:	83 c4 3c             	add    $0x3c,%esp
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;
80104c46:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104c48:	5b                   	pop    %ebx
80104c49:	5e                   	pop    %esi
80104c4a:	5f                   	pop    %edi
80104c4b:	5d                   	pop    %ebp
80104c4c:	c3                   	ret    
80104c4d:	8d 76 00             	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104c50:	89 34 24             	mov    %esi,(%esp)
80104c53:	e8 d8 cc ff ff       	call   80101930 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80104c58:	89 1c 24             	mov    %ebx,(%esp)
80104c5b:	e8 90 ca ff ff       	call   801016f0 <ilock>
  ip->nlink--;
80104c60:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104c65:	89 1c 24             	mov    %ebx,(%esp)
80104c68:	e8 c3 c9 ff ff       	call   80101630 <iupdate>
  iunlockput(ip);
80104c6d:	89 1c 24             	mov    %ebx,(%esp)
80104c70:	e8 bb cc ff ff       	call   80101930 <iunlockput>
  end_op();
80104c75:	e8 b6 df ff ff       	call   80102c30 <end_op>
  return -1;
}
80104c7a:	83 c4 3c             	add    $0x3c,%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104c7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c82:	5b                   	pop    %ebx
80104c83:	5e                   	pop    %esi
80104c84:	5f                   	pop    %edi
80104c85:	5d                   	pop    %ebp
80104c86:	c3                   	ret    
80104c87:	89 f6                	mov    %esi,%esi
80104c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c90 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	57                   	push   %edi
80104c94:	56                   	push   %esi
80104c95:	53                   	push   %ebx
80104c96:	83 ec 5c             	sub    $0x5c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104c99:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ca0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ca7:	e8 24 fa ff ff       	call   801046d0 <argstr>
80104cac:	85 c0                	test   %eax,%eax
80104cae:	0f 88 76 01 00 00    	js     80104e2a <sys_unlink+0x19a>
    return -1;

  begin_op();
80104cb4:	e8 07 df ff ff       	call   80102bc0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104cb9:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104cbc:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104cbf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104cc3:	89 04 24             	mov    %eax,(%esp)
80104cc6:	e8 75 d2 ff ff       	call   80101f40 <nameiparent>
80104ccb:	85 c0                	test   %eax,%eax
80104ccd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104cd0:	0f 84 4f 01 00 00    	je     80104e25 <sys_unlink+0x195>
    end_op();
    return -1;
  }

  ilock(dp);
80104cd6:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104cd9:	89 34 24             	mov    %esi,(%esp)
80104cdc:	e8 0f ca ff ff       	call   801016f0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104ce1:	c7 44 24 04 54 74 10 	movl   $0x80107454,0x4(%esp)
80104ce8:	80 
80104ce9:	89 1c 24             	mov    %ebx,(%esp)
80104cec:	e8 bf ce ff ff       	call   80101bb0 <namecmp>
80104cf1:	85 c0                	test   %eax,%eax
80104cf3:	0f 84 21 01 00 00    	je     80104e1a <sys_unlink+0x18a>
80104cf9:	c7 44 24 04 53 74 10 	movl   $0x80107453,0x4(%esp)
80104d00:	80 
80104d01:	89 1c 24             	mov    %ebx,(%esp)
80104d04:	e8 a7 ce ff ff       	call   80101bb0 <namecmp>
80104d09:	85 c0                	test   %eax,%eax
80104d0b:	0f 84 09 01 00 00    	je     80104e1a <sys_unlink+0x18a>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104d11:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104d14:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d18:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d1c:	89 34 24             	mov    %esi,(%esp)
80104d1f:	e8 bc ce ff ff       	call   80101be0 <dirlookup>
80104d24:	85 c0                	test   %eax,%eax
80104d26:	89 c3                	mov    %eax,%ebx
80104d28:	0f 84 ec 00 00 00    	je     80104e1a <sys_unlink+0x18a>
    goto bad;
  ilock(ip);
80104d2e:	89 04 24             	mov    %eax,(%esp)
80104d31:	e8 ba c9 ff ff       	call   801016f0 <ilock>

  if(ip->nlink < 1)
80104d36:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104d3b:	0f 8e 24 01 00 00    	jle    80104e65 <sys_unlink+0x1d5>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104d41:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d46:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104d49:	74 7d                	je     80104dc8 <sys_unlink+0x138>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104d4b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104d52:	00 
80104d53:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104d5a:	00 
80104d5b:	89 34 24             	mov    %esi,(%esp)
80104d5e:	e8 0d f6 ff ff       	call   80104370 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104d63:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104d66:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104d6d:	00 
80104d6e:	89 74 24 04          	mov    %esi,0x4(%esp)
80104d72:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d76:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d79:	89 04 24             	mov    %eax,(%esp)
80104d7c:	e8 ff cc ff ff       	call   80101a80 <writei>
80104d81:	83 f8 10             	cmp    $0x10,%eax
80104d84:	0f 85 cf 00 00 00    	jne    80104e59 <sys_unlink+0x1c9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104d8a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d8f:	0f 84 a3 00 00 00    	je     80104e38 <sys_unlink+0x1a8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104d95:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d98:	89 04 24             	mov    %eax,(%esp)
80104d9b:	e8 90 cb ff ff       	call   80101930 <iunlockput>

  ip->nlink--;
80104da0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104da5:	89 1c 24             	mov    %ebx,(%esp)
80104da8:	e8 83 c8 ff ff       	call   80101630 <iupdate>
  iunlockput(ip);
80104dad:	89 1c 24             	mov    %ebx,(%esp)
80104db0:	e8 7b cb ff ff       	call   80101930 <iunlockput>

  end_op();
80104db5:	e8 76 de ff ff       	call   80102c30 <end_op>

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104dba:	83 c4 5c             	add    $0x5c,%esp
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;
80104dbd:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104dbf:	5b                   	pop    %ebx
80104dc0:	5e                   	pop    %esi
80104dc1:	5f                   	pop    %edi
80104dc2:	5d                   	pop    %ebp
80104dc3:	c3                   	ret    
80104dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104dc8:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104dcc:	0f 86 79 ff ff ff    	jbe    80104d4b <sys_unlink+0xbb>
80104dd2:	bf 20 00 00 00       	mov    $0x20,%edi
80104dd7:	eb 15                	jmp    80104dee <sys_unlink+0x15e>
80104dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104de0:	8d 57 10             	lea    0x10(%edi),%edx
80104de3:	3b 53 58             	cmp    0x58(%ebx),%edx
80104de6:	0f 83 5f ff ff ff    	jae    80104d4b <sys_unlink+0xbb>
80104dec:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104dee:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104df5:	00 
80104df6:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104dfa:	89 74 24 04          	mov    %esi,0x4(%esp)
80104dfe:	89 1c 24             	mov    %ebx,(%esp)
80104e01:	e8 7a cb ff ff       	call   80101980 <readi>
80104e06:	83 f8 10             	cmp    $0x10,%eax
80104e09:	75 42                	jne    80104e4d <sys_unlink+0x1bd>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104e0b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104e10:	74 ce                	je     80104de0 <sys_unlink+0x150>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104e12:	89 1c 24             	mov    %ebx,(%esp)
80104e15:	e8 16 cb ff ff       	call   80101930 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104e1a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e1d:	89 04 24             	mov    %eax,(%esp)
80104e20:	e8 0b cb ff ff       	call   80101930 <iunlockput>
  end_op();
80104e25:	e8 06 de ff ff       	call   80102c30 <end_op>
  return -1;
}
80104e2a:	83 c4 5c             	add    $0x5c,%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104e2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e32:	5b                   	pop    %ebx
80104e33:	5e                   	pop    %esi
80104e34:	5f                   	pop    %edi
80104e35:	5d                   	pop    %ebp
80104e36:	c3                   	ret    
80104e37:	90                   	nop

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104e38:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e3b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104e40:	89 04 24             	mov    %eax,(%esp)
80104e43:	e8 e8 c7 ff ff       	call   80101630 <iupdate>
80104e48:	e9 48 ff ff ff       	jmp    80104d95 <sys_unlink+0x105>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104e4d:	c7 04 24 78 74 10 80 	movl   $0x80107478,(%esp)
80104e54:	e8 07 b5 ff ff       	call   80100360 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104e59:	c7 04 24 8a 74 10 80 	movl   $0x8010748a,(%esp)
80104e60:	e8 fb b4 ff ff       	call   80100360 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104e65:	c7 04 24 66 74 10 80 	movl   $0x80107466,(%esp)
80104e6c:	e8 ef b4 ff ff       	call   80100360 <panic>
80104e71:	eb 0d                	jmp    80104e80 <sys_open>
80104e73:	90                   	nop
80104e74:	90                   	nop
80104e75:	90                   	nop
80104e76:	90                   	nop
80104e77:	90                   	nop
80104e78:	90                   	nop
80104e79:	90                   	nop
80104e7a:	90                   	nop
80104e7b:	90                   	nop
80104e7c:	90                   	nop
80104e7d:	90                   	nop
80104e7e:	90                   	nop
80104e7f:	90                   	nop

80104e80 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	57                   	push   %edi
80104e84:	56                   	push   %esi
80104e85:	53                   	push   %ebx
80104e86:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104e89:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104e8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104e97:	e8 34 f8 ff ff       	call   801046d0 <argstr>
80104e9c:	85 c0                	test   %eax,%eax
80104e9e:	0f 88 81 00 00 00    	js     80104f25 <sys_open+0xa5>
80104ea4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104ea7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104eab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104eb2:	e8 89 f7 ff ff       	call   80104640 <argint>
80104eb7:	85 c0                	test   %eax,%eax
80104eb9:	78 6a                	js     80104f25 <sys_open+0xa5>
    return -1;

  begin_op();
80104ebb:	e8 00 dd ff ff       	call   80102bc0 <begin_op>

  if(omode & O_CREATE){
80104ec0:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104ec4:	75 72                	jne    80104f38 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104ec6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ec9:	89 04 24             	mov    %eax,(%esp)
80104ecc:	e8 4f d0 ff ff       	call   80101f20 <namei>
80104ed1:	85 c0                	test   %eax,%eax
80104ed3:	89 c7                	mov    %eax,%edi
80104ed5:	74 49                	je     80104f20 <sys_open+0xa0>
      end_op();
      return -1;
    }
    ilock(ip);
80104ed7:	89 04 24             	mov    %eax,(%esp)
80104eda:	e8 11 c8 ff ff       	call   801016f0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104edf:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80104ee4:	0f 84 ae 00 00 00    	je     80104f98 <sys_open+0x118>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104eea:	e8 b1 be ff ff       	call   80100da0 <filealloc>
80104eef:	85 c0                	test   %eax,%eax
80104ef1:	89 c6                	mov    %eax,%esi
80104ef3:	74 23                	je     80104f18 <sys_open+0x98>
80104ef5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104efc:	31 db                	xor    %ebx,%ebx
80104efe:	66 90                	xchg   %ax,%ax
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80104f00:	8b 44 9a 28          	mov    0x28(%edx,%ebx,4),%eax
80104f04:	85 c0                	test   %eax,%eax
80104f06:	74 50                	je     80104f58 <sys_open+0xd8>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104f08:	83 c3 01             	add    $0x1,%ebx
80104f0b:	83 fb 10             	cmp    $0x10,%ebx
80104f0e:	75 f0                	jne    80104f00 <sys_open+0x80>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80104f10:	89 34 24             	mov    %esi,(%esp)
80104f13:	e8 48 bf ff ff       	call   80100e60 <fileclose>
    iunlockput(ip);
80104f18:	89 3c 24             	mov    %edi,(%esp)
80104f1b:	e8 10 ca ff ff       	call   80101930 <iunlockput>
    end_op();
80104f20:	e8 0b dd ff ff       	call   80102c30 <end_op>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104f25:	83 c4 2c             	add    $0x2c,%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80104f28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104f2d:	5b                   	pop    %ebx
80104f2e:	5e                   	pop    %esi
80104f2f:	5f                   	pop    %edi
80104f30:	5d                   	pop    %ebp
80104f31:	c3                   	ret    
80104f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104f38:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f3b:	31 c9                	xor    %ecx,%ecx
80104f3d:	ba 02 00 00 00       	mov    $0x2,%edx
80104f42:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f49:	e8 72 f8 ff ff       	call   801047c0 <create>
    if(ip == 0){
80104f4e:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104f50:	89 c7                	mov    %eax,%edi
    if(ip == 0){
80104f52:	75 96                	jne    80104eea <sys_open+0x6a>
80104f54:	eb ca                	jmp    80104f20 <sys_open+0xa0>
80104f56:	66 90                	xchg   %ax,%ax
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104f58:	89 74 9a 28          	mov    %esi,0x28(%edx,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104f5c:	89 3c 24             	mov    %edi,(%esp)
80104f5f:	e8 5c c8 ff ff       	call   801017c0 <iunlock>
  end_op();
80104f64:	e8 c7 dc ff ff       	call   80102c30 <end_op>

  f->type = FD_INODE;
80104f69:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104f6f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80104f72:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
80104f75:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
80104f7c:	89 d0                	mov    %edx,%eax
80104f7e:	83 e0 01             	and    $0x1,%eax
80104f81:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104f84:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104f87:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
80104f8a:	89 d8                	mov    %ebx,%eax

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104f8c:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
}
80104f90:	83 c4 2c             	add    $0x2c,%esp
80104f93:	5b                   	pop    %ebx
80104f94:	5e                   	pop    %esi
80104f95:	5f                   	pop    %edi
80104f96:	5d                   	pop    %ebp
80104f97:	c3                   	ret    
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80104f98:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104f9b:	85 d2                	test   %edx,%edx
80104f9d:	0f 84 47 ff ff ff    	je     80104eea <sys_open+0x6a>
80104fa3:	e9 70 ff ff ff       	jmp    80104f18 <sys_open+0x98>
80104fa8:	90                   	nop
80104fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fb0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104fb6:	e8 05 dc ff ff       	call   80102bc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104fbb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fbe:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fc2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fc9:	e8 02 f7 ff ff       	call   801046d0 <argstr>
80104fce:	85 c0                	test   %eax,%eax
80104fd0:	78 2e                	js     80105000 <sys_mkdir+0x50>
80104fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fd5:	31 c9                	xor    %ecx,%ecx
80104fd7:	ba 01 00 00 00       	mov    $0x1,%edx
80104fdc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fe3:	e8 d8 f7 ff ff       	call   801047c0 <create>
80104fe8:	85 c0                	test   %eax,%eax
80104fea:	74 14                	je     80105000 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104fec:	89 04 24             	mov    %eax,(%esp)
80104fef:	e8 3c c9 ff ff       	call   80101930 <iunlockput>
  end_op();
80104ff4:	e8 37 dc ff ff       	call   80102c30 <end_op>
  return 0;
80104ff9:	31 c0                	xor    %eax,%eax
}
80104ffb:	c9                   	leave  
80104ffc:	c3                   	ret    
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105000:	e8 2b dc ff ff       	call   80102c30 <end_op>
    return -1;
80105005:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010500a:	c9                   	leave  
8010500b:	c3                   	ret    
8010500c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105010 <sys_mknod>:

int
sys_mknod(void)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105016:	e8 a5 db ff ff       	call   80102bc0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010501b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010501e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105022:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105029:	e8 a2 f6 ff ff       	call   801046d0 <argstr>
8010502e:	85 c0                	test   %eax,%eax
80105030:	78 5e                	js     80105090 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105032:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105035:	89 44 24 04          	mov    %eax,0x4(%esp)
80105039:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105040:	e8 fb f5 ff ff       	call   80104640 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105045:	85 c0                	test   %eax,%eax
80105047:	78 47                	js     80105090 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105049:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010504c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105050:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105057:	e8 e4 f5 ff ff       	call   80104640 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010505c:	85 c0                	test   %eax,%eax
8010505e:	78 30                	js     80105090 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105060:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105064:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80105069:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
8010506d:	89 04 24             	mov    %eax,(%esp)
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105070:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105073:	e8 48 f7 ff ff       	call   801047c0 <create>
80105078:	85 c0                	test   %eax,%eax
8010507a:	74 14                	je     80105090 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010507c:	89 04 24             	mov    %eax,(%esp)
8010507f:	e8 ac c8 ff ff       	call   80101930 <iunlockput>
  end_op();
80105084:	e8 a7 db ff ff       	call   80102c30 <end_op>
  return 0;
80105089:	31 c0                	xor    %eax,%eax
}
8010508b:	c9                   	leave  
8010508c:	c3                   	ret    
8010508d:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105090:	e8 9b db ff ff       	call   80102c30 <end_op>
    return -1;
80105095:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010509a:	c9                   	leave  
8010509b:	c3                   	ret    
8010509c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050a0 <sys_chdir>:

int
sys_chdir(void)
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	53                   	push   %ebx
801050a4:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  begin_op();
801050a7:	e8 14 db ff ff       	call   80102bc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801050ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050af:	89 44 24 04          	mov    %eax,0x4(%esp)
801050b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050ba:	e8 11 f6 ff ff       	call   801046d0 <argstr>
801050bf:	85 c0                	test   %eax,%eax
801050c1:	78 5a                	js     8010511d <sys_chdir+0x7d>
801050c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050c6:	89 04 24             	mov    %eax,(%esp)
801050c9:	e8 52 ce ff ff       	call   80101f20 <namei>
801050ce:	85 c0                	test   %eax,%eax
801050d0:	89 c3                	mov    %eax,%ebx
801050d2:	74 49                	je     8010511d <sys_chdir+0x7d>
    end_op();
    return -1;
  }
  ilock(ip);
801050d4:	89 04 24             	mov    %eax,(%esp)
801050d7:	e8 14 c6 ff ff       	call   801016f0 <ilock>
  if(ip->type != T_DIR){
801050dc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
801050e1:	89 1c 24             	mov    %ebx,(%esp)
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
801050e4:	75 32                	jne    80105118 <sys_chdir+0x78>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801050e6:	e8 d5 c6 ff ff       	call   801017c0 <iunlock>
  iput(proc->cwd);
801050eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050f1:	8b 40 68             	mov    0x68(%eax),%eax
801050f4:	89 04 24             	mov    %eax,(%esp)
801050f7:	e8 04 c7 ff ff       	call   80101800 <iput>
  end_op();
801050fc:	e8 2f db ff ff       	call   80102c30 <end_op>
  proc->cwd = ip;
80105101:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105107:	89 58 68             	mov    %ebx,0x68(%eax)
  return 0;
}
8010510a:	83 c4 24             	add    $0x24,%esp
  }
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
8010510d:	31 c0                	xor    %eax,%eax
}
8010510f:	5b                   	pop    %ebx
80105110:	5d                   	pop    %ebp
80105111:	c3                   	ret    
80105112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105118:	e8 13 c8 ff ff       	call   80101930 <iunlockput>
    end_op();
8010511d:	e8 0e db ff ff       	call   80102c30 <end_op>
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
80105122:	83 c4 24             	add    $0x24,%esp
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
80105125:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
8010512a:	5b                   	pop    %ebx
8010512b:	5d                   	pop    %ebp
8010512c:	c3                   	ret    
8010512d:	8d 76 00             	lea    0x0(%esi),%esi

80105130 <sys_exec>:

int
sys_exec(void)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	57                   	push   %edi
80105134:	56                   	push   %esi
80105135:	53                   	push   %ebx
80105136:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010513c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105142:	89 44 24 04          	mov    %eax,0x4(%esp)
80105146:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010514d:	e8 7e f5 ff ff       	call   801046d0 <argstr>
80105152:	85 c0                	test   %eax,%eax
80105154:	0f 88 84 00 00 00    	js     801051de <sys_exec+0xae>
8010515a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105160:	89 44 24 04          	mov    %eax,0x4(%esp)
80105164:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010516b:	e8 d0 f4 ff ff       	call   80104640 <argint>
80105170:	85 c0                	test   %eax,%eax
80105172:	78 6a                	js     801051de <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105174:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010517a:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010517c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105183:	00 
80105184:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010518a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105191:	00 
80105192:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105198:	89 04 24             	mov    %eax,(%esp)
8010519b:	e8 d0 f1 ff ff       	call   80104370 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801051a0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801051a6:	89 7c 24 04          	mov    %edi,0x4(%esp)
801051aa:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801051ad:	89 04 24             	mov    %eax,(%esp)
801051b0:	e8 0b f4 ff ff       	call   801045c0 <fetchint>
801051b5:	85 c0                	test   %eax,%eax
801051b7:	78 25                	js     801051de <sys_exec+0xae>
      return -1;
    if(uarg == 0){
801051b9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801051bf:	85 c0                	test   %eax,%eax
801051c1:	74 2d                	je     801051f0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801051c3:	89 74 24 04          	mov    %esi,0x4(%esp)
801051c7:	89 04 24             	mov    %eax,(%esp)
801051ca:	e8 21 f4 ff ff       	call   801045f0 <fetchstr>
801051cf:	85 c0                	test   %eax,%eax
801051d1:	78 0b                	js     801051de <sys_exec+0xae>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801051d3:	83 c3 01             	add    $0x1,%ebx
801051d6:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801051d9:	83 fb 20             	cmp    $0x20,%ebx
801051dc:	75 c2                	jne    801051a0 <sys_exec+0x70>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801051de:	81 c4 ac 00 00 00    	add    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801051e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801051e9:	5b                   	pop    %ebx
801051ea:	5e                   	pop    %esi
801051eb:	5f                   	pop    %edi
801051ec:	5d                   	pop    %ebp
801051ed:	c3                   	ret    
801051ee:	66 90                	xchg   %ax,%ax
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801051f0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801051f6:	89 44 24 04          	mov    %eax,0x4(%esp)
801051fa:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105200:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105207:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010520b:	89 04 24             	mov    %eax,(%esp)
8010520e:	e8 ad b7 ff ff       	call   801009c0 <exec>
}
80105213:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105219:	5b                   	pop    %ebx
8010521a:	5e                   	pop    %esi
8010521b:	5f                   	pop    %edi
8010521c:	5d                   	pop    %ebp
8010521d:	c3                   	ret    
8010521e:	66 90                	xchg   %ax,%ax

80105220 <sys_pipe>:

int
sys_pipe(void)
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	57                   	push   %edi
80105224:	56                   	push   %esi
80105225:	53                   	push   %ebx
80105226:	83 ec 2c             	sub    $0x2c,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105229:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010522c:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105233:	00 
80105234:	89 44 24 04          	mov    %eax,0x4(%esp)
80105238:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010523f:	e8 3c f4 ff ff       	call   80104680 <argptr>
80105244:	85 c0                	test   %eax,%eax
80105246:	78 7a                	js     801052c2 <sys_pipe+0xa2>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105248:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010524b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010524f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105252:	89 04 24             	mov    %eax,(%esp)
80105255:	e8 96 e0 ff ff       	call   801032f0 <pipealloc>
8010525a:	85 c0                	test   %eax,%eax
8010525c:	78 64                	js     801052c2 <sys_pipe+0xa2>
8010525e:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105265:	31 c0                	xor    %eax,%eax
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105267:	8b 5d e0             	mov    -0x20(%ebp),%ebx
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
8010526a:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
8010526e:	85 d2                	test   %edx,%edx
80105270:	74 16                	je     80105288 <sys_pipe+0x68>
80105272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105278:	83 c0 01             	add    $0x1,%eax
8010527b:	83 f8 10             	cmp    $0x10,%eax
8010527e:	74 2f                	je     801052af <sys_pipe+0x8f>
    if(proc->ofile[fd] == 0){
80105280:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
80105284:	85 d2                	test   %edx,%edx
80105286:	75 f0                	jne    80105278 <sys_pipe+0x58>
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105288:	8b 7d e4             	mov    -0x1c(%ebp),%edi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
8010528b:	8d 70 08             	lea    0x8(%eax),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010528e:	31 d2                	xor    %edx,%edx
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105290:	89 5c b1 08          	mov    %ebx,0x8(%ecx,%esi,4)
80105294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80105298:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
8010529d:	74 31                	je     801052d0 <sys_pipe+0xb0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010529f:	83 c2 01             	add    $0x1,%edx
801052a2:	83 fa 10             	cmp    $0x10,%edx
801052a5:	75 f1                	jne    80105298 <sys_pipe+0x78>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
801052a7:	c7 44 b1 08 00 00 00 	movl   $0x0,0x8(%ecx,%esi,4)
801052ae:	00 
    fileclose(rf);
801052af:	89 1c 24             	mov    %ebx,(%esp)
801052b2:	e8 a9 bb ff ff       	call   80100e60 <fileclose>
    fileclose(wf);
801052b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801052ba:	89 04 24             	mov    %eax,(%esp)
801052bd:	e8 9e bb ff ff       	call   80100e60 <fileclose>
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801052c2:	83 c4 2c             	add    $0x2c,%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
801052c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801052ca:	5b                   	pop    %ebx
801052cb:	5e                   	pop    %esi
801052cc:	5f                   	pop    %edi
801052cd:	5d                   	pop    %ebp
801052ce:	c3                   	ret    
801052cf:	90                   	nop
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801052d0:	89 7c 91 28          	mov    %edi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801052d4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
801052d7:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
801052d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801052dc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
801052df:	83 c4 2c             	add    $0x2c,%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
801052e2:	31 c0                	xor    %eax,%eax
}
801052e4:	5b                   	pop    %ebx
801052e5:	5e                   	pop    %esi
801052e6:	5f                   	pop    %edi
801052e7:	5d                   	pop    %ebp
801052e8:	c3                   	ret    
801052e9:	66 90                	xchg   %ax,%ax
801052eb:	66 90                	xchg   %ax,%ax
801052ed:	66 90                	xchg   %ax,%ax
801052ef:	90                   	nop

801052f0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801052f3:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801052f4:	e9 47 e6 ff ff       	jmp    80103940 <fork>
801052f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105300 <sys_exit>:
}

int
sys_exit(void)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	83 ec 08             	sub    $0x8,%esp
  exit();
80105306:	e8 95 e8 ff ff       	call   80103ba0 <exit>
  return 0;  // not reached
}
8010530b:	31 c0                	xor    %eax,%eax
8010530d:	c9                   	leave  
8010530e:	c3                   	ret    
8010530f:	90                   	nop

80105310 <sys_wait>:

int
sys_wait(void)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105313:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105314:	e9 b7 ea ff ff       	jmp    80103dd0 <wait>
80105319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105320 <sys_kill>:
}

int
sys_kill(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105326:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105329:	89 44 24 04          	mov    %eax,0x4(%esp)
8010532d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105334:	e8 07 f3 ff ff       	call   80104640 <argint>
80105339:	85 c0                	test   %eax,%eax
8010533b:	78 13                	js     80105350 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010533d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105340:	89 04 24             	mov    %eax,(%esp)
80105343:	e8 c8 eb ff ff       	call   80103f10 <kill>
}
80105348:	c9                   	leave  
80105349:	c3                   	ret    
8010534a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105350:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105355:	c9                   	leave  
80105356:	c3                   	ret    
80105357:	89 f6                	mov    %esi,%esi
80105359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105360 <sys_getpid>:

int
sys_getpid(void)
{
  return proc->pid;
80105360:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
80105366:	55                   	push   %ebp
80105367:	89 e5                	mov    %esp,%ebp
  return proc->pid;
}
80105369:	5d                   	pop    %ebp
}

int
sys_getpid(void)
{
  return proc->pid;
8010536a:	8b 40 10             	mov    0x10(%eax),%eax
}
8010536d:	c3                   	ret    
8010536e:	66 90                	xchg   %ax,%ax

80105370 <sys_sbrk>:

int
sys_sbrk(void)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	53                   	push   %ebx
80105374:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105377:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010537a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010537e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105385:	e8 b6 f2 ff ff       	call   80104640 <argint>
8010538a:	85 c0                	test   %eax,%eax
8010538c:	78 22                	js     801053b0 <sys_sbrk+0x40>
    return -1;
  addr = proc->sz;
8010538e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(growproc(n) < 0)
80105394:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
80105397:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105399:	89 14 24             	mov    %edx,(%esp)
8010539c:	e8 1f e5 ff ff       	call   801038c0 <growproc>
801053a1:	85 c0                	test   %eax,%eax
801053a3:	78 0b                	js     801053b0 <sys_sbrk+0x40>
    return -1;
  return addr;
801053a5:	89 d8                	mov    %ebx,%eax
}
801053a7:	83 c4 24             	add    $0x24,%esp
801053aa:	5b                   	pop    %ebx
801053ab:	5d                   	pop    %ebp
801053ac:	c3                   	ret    
801053ad:	8d 76 00             	lea    0x0(%esi),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
801053b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053b5:	eb f0                	jmp    801053a7 <sys_sbrk+0x37>
801053b7:	89 f6                	mov    %esi,%esi
801053b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053c0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	53                   	push   %ebx
801053c4:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801053c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801053ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053d5:	e8 66 f2 ff ff       	call   80104640 <argint>
801053da:	85 c0                	test   %eax,%eax
801053dc:	78 7e                	js     8010545c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
801053de:	c7 04 24 e0 4c 11 80 	movl   $0x80114ce0,(%esp)
801053e5:	e8 06 ee ff ff       	call   801041f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801053ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
801053ed:	8b 1d 20 55 11 80    	mov    0x80115520,%ebx
  while(ticks - ticks0 < n){
801053f3:	85 d2                	test   %edx,%edx
801053f5:	75 29                	jne    80105420 <sys_sleep+0x60>
801053f7:	eb 4f                	jmp    80105448 <sys_sleep+0x88>
801053f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105400:	c7 44 24 04 e0 4c 11 	movl   $0x80114ce0,0x4(%esp)
80105407:	80 
80105408:	c7 04 24 20 55 11 80 	movl   $0x80115520,(%esp)
8010540f:	e8 fc e8 ff ff       	call   80103d10 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105414:	a1 20 55 11 80       	mov    0x80115520,%eax
80105419:	29 d8                	sub    %ebx,%eax
8010541b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010541e:	73 28                	jae    80105448 <sys_sleep+0x88>
    if(proc->killed){
80105420:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105426:	8b 40 24             	mov    0x24(%eax),%eax
80105429:	85 c0                	test   %eax,%eax
8010542b:	74 d3                	je     80105400 <sys_sleep+0x40>
      release(&tickslock);
8010542d:	c7 04 24 e0 4c 11 80 	movl   $0x80114ce0,(%esp)
80105434:	e8 e7 ee ff ff       	call   80104320 <release>
      return -1;
80105439:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
8010543e:	83 c4 24             	add    $0x24,%esp
80105441:	5b                   	pop    %ebx
80105442:	5d                   	pop    %ebp
80105443:	c3                   	ret    
80105444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105448:	c7 04 24 e0 4c 11 80 	movl   $0x80114ce0,(%esp)
8010544f:	e8 cc ee ff ff       	call   80104320 <release>
  return 0;
}
80105454:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
80105457:	31 c0                	xor    %eax,%eax
}
80105459:	5b                   	pop    %ebx
8010545a:	5d                   	pop    %ebp
8010545b:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
8010545c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105461:	eb db                	jmp    8010543e <sys_sleep+0x7e>
80105463:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105470 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	53                   	push   %ebx
80105474:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105477:	c7 04 24 e0 4c 11 80 	movl   $0x80114ce0,(%esp)
8010547e:	e8 6d ed ff ff       	call   801041f0 <acquire>
  xticks = ticks;
80105483:	8b 1d 20 55 11 80    	mov    0x80115520,%ebx
  release(&tickslock);
80105489:	c7 04 24 e0 4c 11 80 	movl   $0x80114ce0,(%esp)
80105490:	e8 8b ee ff ff       	call   80104320 <release>
  return xticks;
}
80105495:	83 c4 14             	add    $0x14,%esp
80105498:	89 d8                	mov    %ebx,%eax
8010549a:	5b                   	pop    %ebx
8010549b:	5d                   	pop    %ebp
8010549c:	c3                   	ret    
8010549d:	66 90                	xchg   %ax,%ax
8010549f:	90                   	nop

801054a0 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801054a0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801054a1:	ba 43 00 00 00       	mov    $0x43,%edx
801054a6:	89 e5                	mov    %esp,%ebp
801054a8:	b8 34 00 00 00       	mov    $0x34,%eax
801054ad:	83 ec 18             	sub    $0x18,%esp
801054b0:	ee                   	out    %al,(%dx)
801054b1:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
801054b6:	b2 40                	mov    $0x40,%dl
801054b8:	ee                   	out    %al,(%dx)
801054b9:	b8 2e 00 00 00       	mov    $0x2e,%eax
801054be:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
801054bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054c6:	e8 65 dd ff ff       	call   80103230 <picenable>
}
801054cb:	c9                   	leave  
801054cc:	c3                   	ret    

801054cd <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801054cd:	1e                   	push   %ds
  pushl %es
801054ce:	06                   	push   %es
  pushl %fs
801054cf:	0f a0                	push   %fs
  pushl %gs
801054d1:	0f a8                	push   %gs
  pushal
801054d3:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801054d4:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801054d8:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801054da:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
801054dc:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801054e0:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
801054e2:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
801054e4:	54                   	push   %esp
  call trap
801054e5:	e8 e6 00 00 00       	call   801055d0 <trap>
  addl $4, %esp
801054ea:	83 c4 04             	add    $0x4,%esp

801054ed <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801054ed:	61                   	popa   
  popl %gs
801054ee:	0f a9                	pop    %gs
  popl %fs
801054f0:	0f a1                	pop    %fs
  popl %es
801054f2:	07                   	pop    %es
  popl %ds
801054f3:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801054f4:	83 c4 08             	add    $0x8,%esp
  iret
801054f7:	cf                   	iret   
801054f8:	66 90                	xchg   %ax,%ax
801054fa:	66 90                	xchg   %ax,%ax
801054fc:	66 90                	xchg   %ax,%ax
801054fe:	66 90                	xchg   %ax,%ax

80105500 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105500:	31 c0                	xor    %eax,%eax
80105502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105508:	8b 14 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%edx
8010550f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105514:	66 89 0c c5 22 4d 11 	mov    %cx,-0x7feeb2de(,%eax,8)
8010551b:	80 
8010551c:	c6 04 c5 24 4d 11 80 	movb   $0x0,-0x7feeb2dc(,%eax,8)
80105523:	00 
80105524:	c6 04 c5 25 4d 11 80 	movb   $0x8e,-0x7feeb2db(,%eax,8)
8010552b:	8e 
8010552c:	66 89 14 c5 20 4d 11 	mov    %dx,-0x7feeb2e0(,%eax,8)
80105533:	80 
80105534:	c1 ea 10             	shr    $0x10,%edx
80105537:	66 89 14 c5 26 4d 11 	mov    %dx,-0x7feeb2da(,%eax,8)
8010553e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010553f:	83 c0 01             	add    $0x1,%eax
80105542:	3d 00 01 00 00       	cmp    $0x100,%eax
80105547:	75 bf                	jne    80105508 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105549:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010554a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010554f:	89 e5                	mov    %esp,%ebp
80105551:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105554:	a1 0c a1 10 80       	mov    0x8010a10c,%eax

  initlock(&tickslock, "time");
80105559:	c7 44 24 04 99 74 10 	movl   $0x80107499,0x4(%esp)
80105560:	80 
80105561:	c7 04 24 e0 4c 11 80 	movl   $0x80114ce0,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105568:	66 89 15 22 4f 11 80 	mov    %dx,0x80114f22
8010556f:	66 a3 20 4f 11 80    	mov    %ax,0x80114f20
80105575:	c1 e8 10             	shr    $0x10,%eax
80105578:	c6 05 24 4f 11 80 00 	movb   $0x0,0x80114f24
8010557f:	c6 05 25 4f 11 80 ef 	movb   $0xef,0x80114f25
80105586:	66 a3 26 4f 11 80    	mov    %ax,0x80114f26

  initlock(&tickslock, "time");
8010558c:	e8 df eb ff ff       	call   80104170 <initlock>
}
80105591:	c9                   	leave  
80105592:	c3                   	ret    
80105593:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055a0 <idtinit>:

void
idtinit(void)
{
801055a0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801055a1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801055a6:	89 e5                	mov    %esp,%ebp
801055a8:	83 ec 10             	sub    $0x10,%esp
801055ab:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801055af:	b8 20 4d 11 80       	mov    $0x80114d20,%eax
801055b4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801055b8:	c1 e8 10             	shr    $0x10,%eax
801055bb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801055bf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801055c2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801055c5:	c9                   	leave  
801055c6:	c3                   	ret    
801055c7:	89 f6                	mov    %esi,%esi
801055c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055d0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	57                   	push   %edi
801055d4:	56                   	push   %esi
801055d5:	53                   	push   %ebx
801055d6:	83 ec 2c             	sub    $0x2c,%esp
801055d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801055dc:	8b 43 30             	mov    0x30(%ebx),%eax
801055df:	83 f8 40             	cmp    $0x40,%eax
801055e2:	0f 84 00 01 00 00    	je     801056e8 <trap+0x118>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801055e8:	83 e8 20             	sub    $0x20,%eax
801055eb:	83 f8 1f             	cmp    $0x1f,%eax
801055ee:	77 60                	ja     80105650 <trap+0x80>
801055f0:	ff 24 85 40 75 10 80 	jmp    *-0x7fef8ac0(,%eax,4)
801055f7:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
801055f8:	e8 93 d1 ff ff       	call   80102790 <cpunum>
801055fd:	85 c0                	test   %eax,%eax
801055ff:	90                   	nop
80105600:	0f 84 d2 01 00 00    	je     801057d8 <trap+0x208>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
80105606:	e8 25 d2 ff ff       	call   80102830 <lapiceoi>
8010560b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105611:	85 c0                	test   %eax,%eax
80105613:	74 2d                	je     80105642 <trap+0x72>
80105615:	8b 50 24             	mov    0x24(%eax),%edx
80105618:	85 d2                	test   %edx,%edx
8010561a:	0f 85 9c 00 00 00    	jne    801056bc <trap+0xec>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105620:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105624:	0f 84 86 01 00 00    	je     801057b0 <trap+0x1e0>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010562a:	8b 40 24             	mov    0x24(%eax),%eax
8010562d:	85 c0                	test   %eax,%eax
8010562f:	74 11                	je     80105642 <trap+0x72>
80105631:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105635:	83 e0 03             	and    $0x3,%eax
80105638:	66 83 f8 03          	cmp    $0x3,%ax
8010563c:	0f 84 d0 00 00 00    	je     80105712 <trap+0x142>
    exit();
}
80105642:	83 c4 2c             	add    $0x2c,%esp
80105645:	5b                   	pop    %ebx
80105646:	5e                   	pop    %esi
80105647:	5f                   	pop    %edi
80105648:	5d                   	pop    %ebp
80105649:	c3                   	ret    
8010564a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80105650:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80105657:	85 c9                	test   %ecx,%ecx
80105659:	0f 84 a9 01 00 00    	je     80105808 <trap+0x238>
8010565f:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105663:	0f 84 9f 01 00 00    	je     80105808 <trap+0x238>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105669:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010566c:	8b 73 38             	mov    0x38(%ebx),%esi
8010566f:	e8 1c d1 ff ff       	call   80102790 <cpunum>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105674:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010567b:	89 7c 24 1c          	mov    %edi,0x1c(%esp)
8010567f:	89 74 24 18          	mov    %esi,0x18(%esp)
80105683:	89 44 24 14          	mov    %eax,0x14(%esp)
80105687:	8b 43 34             	mov    0x34(%ebx),%eax
8010568a:	89 44 24 10          	mov    %eax,0x10(%esp)
8010568e:	8b 43 30             	mov    0x30(%ebx),%eax
80105691:	89 44 24 0c          	mov    %eax,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105695:	8d 42 6c             	lea    0x6c(%edx),%eax
80105698:	89 44 24 08          	mov    %eax,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010569c:	8b 42 10             	mov    0x10(%edx),%eax
8010569f:	c7 04 24 fc 74 10 80 	movl   $0x801074fc,(%esp)
801056a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801056aa:	e8 a1 af ff ff       	call   80100650 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
801056af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056b5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801056bc:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
801056c0:	83 e2 03             	and    $0x3,%edx
801056c3:	66 83 fa 03          	cmp    $0x3,%dx
801056c7:	0f 85 53 ff ff ff    	jne    80105620 <trap+0x50>
    exit();
801056cd:	e8 ce e4 ff ff       	call   80103ba0 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801056d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056d8:	85 c0                	test   %eax,%eax
801056da:	0f 85 40 ff ff ff    	jne    80105620 <trap+0x50>
801056e0:	e9 5d ff ff ff       	jmp    80105642 <trap+0x72>
801056e5:	8d 76 00             	lea    0x0(%esi),%esi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
801056e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056ee:	8b 70 24             	mov    0x24(%eax),%esi
801056f1:	85 f6                	test   %esi,%esi
801056f3:	0f 85 a7 00 00 00    	jne    801057a0 <trap+0x1d0>
      exit();
    proc->tf = tf;
801056f9:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801056fc:	e8 4f f0 ff ff       	call   80104750 <syscall>
    if(proc->killed)
80105701:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105707:	8b 58 24             	mov    0x24(%eax),%ebx
8010570a:	85 db                	test   %ebx,%ebx
8010570c:	0f 84 30 ff ff ff    	je     80105642 <trap+0x72>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105712:	83 c4 2c             	add    $0x2c,%esp
80105715:	5b                   	pop    %ebx
80105716:	5e                   	pop    %esi
80105717:	5f                   	pop    %edi
80105718:	5d                   	pop    %ebp
    if(proc->killed)
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
80105719:	e9 82 e4 ff ff       	jmp    80103ba0 <exit>
8010571e:	66 90                	xchg   %ax,%ax
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105720:	e8 db ce ff ff       	call   80102600 <kbdintr>
    lapiceoi();
80105725:	e8 06 d1 ff ff       	call   80102830 <lapiceoi>
8010572a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105730:	e9 dc fe ff ff       	jmp    80105611 <trap+0x41>
80105735:	8d 76 00             	lea    0x0(%esi),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105738:	e8 73 c9 ff ff       	call   801020b0 <ideintr>
    lapiceoi();
8010573d:	e8 ee d0 ff ff       	call   80102830 <lapiceoi>
80105742:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105748:	e9 c4 fe ff ff       	jmp    80105611 <trap+0x41>
8010574d:	8d 76 00             	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105750:	e8 1b 02 00 00       	call   80105970 <uartintr>
    lapiceoi();
80105755:	e8 d6 d0 ff ff       	call   80102830 <lapiceoi>
8010575a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105760:	e9 ac fe ff ff       	jmp    80105611 <trap+0x41>
80105765:	8d 76 00             	lea    0x0(%esi),%esi
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105768:	8b 7b 38             	mov    0x38(%ebx),%edi
8010576b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010576f:	e8 1c d0 ff ff       	call   80102790 <cpunum>
80105774:	c7 04 24 a4 74 10 80 	movl   $0x801074a4,(%esp)
8010577b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
8010577f:	89 74 24 08          	mov    %esi,0x8(%esp)
80105783:	89 44 24 04          	mov    %eax,0x4(%esp)
80105787:	e8 c4 ae ff ff       	call   80100650 <cprintf>
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
8010578c:	e8 9f d0 ff ff       	call   80102830 <lapiceoi>
80105791:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105797:	e9 75 fe ff ff       	jmp    80105611 <trap+0x41>
8010579c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
801057a0:	e8 fb e3 ff ff       	call   80103ba0 <exit>
801057a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057ab:	e9 49 ff ff ff       	jmp    801056f9 <trap+0x129>
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801057b0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801057b4:	0f 85 70 fe ff ff    	jne    8010562a <trap+0x5a>
    yield();
801057ba:	e8 11 e5 ff ff       	call   80103cd0 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801057bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057c5:	85 c0                	test   %eax,%eax
801057c7:	0f 85 5d fe ff ff    	jne    8010562a <trap+0x5a>
801057cd:	e9 70 fe ff ff       	jmp    80105642 <trap+0x72>
801057d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
801057d8:	c7 04 24 e0 4c 11 80 	movl   $0x80114ce0,(%esp)
801057df:	e8 0c ea ff ff       	call   801041f0 <acquire>
      ticks++;
      wakeup(&ticks);
801057e4:	c7 04 24 20 55 11 80 	movl   $0x80115520,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
      ticks++;
801057eb:	83 05 20 55 11 80 01 	addl   $0x1,0x80115520
      wakeup(&ticks);
801057f2:	e8 b9 e6 ff ff       	call   80103eb0 <wakeup>
      release(&tickslock);
801057f7:	c7 04 24 e0 4c 11 80 	movl   $0x80114ce0,(%esp)
801057fe:	e8 1d eb ff ff       	call   80104320 <release>
80105803:	e9 fe fd ff ff       	jmp    80105606 <trap+0x36>
80105808:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010580b:	8b 73 38             	mov    0x38(%ebx),%esi
8010580e:	e8 7d cf ff ff       	call   80102790 <cpunum>
80105813:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105817:	89 74 24 0c          	mov    %esi,0xc(%esp)
8010581b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010581f:	8b 43 30             	mov    0x30(%ebx),%eax
80105822:	c7 04 24 c8 74 10 80 	movl   $0x801074c8,(%esp)
80105829:	89 44 24 04          	mov    %eax,0x4(%esp)
8010582d:	e8 1e ae ff ff       	call   80100650 <cprintf>
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
80105832:	c7 04 24 9e 74 10 80 	movl   $0x8010749e,(%esp)
80105839:	e8 22 ab ff ff       	call   80100360 <panic>
8010583e:	66 90                	xchg   %ax,%ax

80105840 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105840:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105845:	55                   	push   %ebp
80105846:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105848:	85 c0                	test   %eax,%eax
8010584a:	74 14                	je     80105860 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010584c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105851:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105852:	a8 01                	test   $0x1,%al
80105854:	74 0a                	je     80105860 <uartgetc+0x20>
80105856:	b2 f8                	mov    $0xf8,%dl
80105858:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105859:	0f b6 c0             	movzbl %al,%eax
}
8010585c:	5d                   	pop    %ebp
8010585d:	c3                   	ret    
8010585e:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105865:	5d                   	pop    %ebp
80105866:	c3                   	ret    
80105867:	89 f6                	mov    %esi,%esi
80105869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105870 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105870:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
80105875:	85 c0                	test   %eax,%eax
80105877:	74 3f                	je     801058b8 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
80105879:	55                   	push   %ebp
8010587a:	89 e5                	mov    %esp,%ebp
8010587c:	56                   	push   %esi
8010587d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105882:	53                   	push   %ebx
  int i;

  if(!uart)
80105883:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
80105888:	83 ec 10             	sub    $0x10,%esp
8010588b:	eb 14                	jmp    801058a1 <uartputc+0x31>
8010588d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105890:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105897:	e8 b4 cf ff ff       	call   80102850 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010589c:	83 eb 01             	sub    $0x1,%ebx
8010589f:	74 07                	je     801058a8 <uartputc+0x38>
801058a1:	89 f2                	mov    %esi,%edx
801058a3:	ec                   	in     (%dx),%al
801058a4:	a8 20                	test   $0x20,%al
801058a6:	74 e8                	je     80105890 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
801058a8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801058ac:	ba f8 03 00 00       	mov    $0x3f8,%edx
801058b1:	ee                   	out    %al,(%dx)
}
801058b2:	83 c4 10             	add    $0x10,%esp
801058b5:	5b                   	pop    %ebx
801058b6:	5e                   	pop    %esi
801058b7:	5d                   	pop    %ebp
801058b8:	f3 c3                	repz ret 
801058ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058c0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801058c0:	55                   	push   %ebp
801058c1:	31 c9                	xor    %ecx,%ecx
801058c3:	89 e5                	mov    %esp,%ebp
801058c5:	89 c8                	mov    %ecx,%eax
801058c7:	57                   	push   %edi
801058c8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801058cd:	56                   	push   %esi
801058ce:	89 fa                	mov    %edi,%edx
801058d0:	53                   	push   %ebx
801058d1:	83 ec 1c             	sub    $0x1c,%esp
801058d4:	ee                   	out    %al,(%dx)
801058d5:	be fb 03 00 00       	mov    $0x3fb,%esi
801058da:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801058df:	89 f2                	mov    %esi,%edx
801058e1:	ee                   	out    %al,(%dx)
801058e2:	b8 0c 00 00 00       	mov    $0xc,%eax
801058e7:	b2 f8                	mov    $0xf8,%dl
801058e9:	ee                   	out    %al,(%dx)
801058ea:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801058ef:	89 c8                	mov    %ecx,%eax
801058f1:	89 da                	mov    %ebx,%edx
801058f3:	ee                   	out    %al,(%dx)
801058f4:	b8 03 00 00 00       	mov    $0x3,%eax
801058f9:	89 f2                	mov    %esi,%edx
801058fb:	ee                   	out    %al,(%dx)
801058fc:	b2 fc                	mov    $0xfc,%dl
801058fe:	89 c8                	mov    %ecx,%eax
80105900:	ee                   	out    %al,(%dx)
80105901:	b8 01 00 00 00       	mov    $0x1,%eax
80105906:	89 da                	mov    %ebx,%edx
80105908:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105909:	b2 fd                	mov    $0xfd,%dl
8010590b:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010590c:	3c ff                	cmp    $0xff,%al
8010590e:	74 52                	je     80105962 <uartinit+0xa2>
    return;
  uart = 1;
80105910:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
80105917:	00 00 00 
8010591a:	89 fa                	mov    %edi,%edx
8010591c:	ec                   	in     (%dx),%al
8010591d:	b2 f8                	mov    $0xf8,%dl
8010591f:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
80105920:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105927:	bb c0 75 10 80       	mov    $0x801075c0,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
8010592c:	e8 ff d8 ff ff       	call   80103230 <picenable>
  ioapicenable(IRQ_COM1, 0);
80105931:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105938:	00 
80105939:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105940:	e8 9b c9 ff ff       	call   801022e0 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105945:	b8 78 00 00 00       	mov    $0x78,%eax
8010594a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartputc(*p);
80105950:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105953:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105956:	e8 15 ff ff ff       	call   80105870 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010595b:	0f be 03             	movsbl (%ebx),%eax
8010595e:	84 c0                	test   %al,%al
80105960:	75 ee                	jne    80105950 <uartinit+0x90>
    uartputc(*p);
}
80105962:	83 c4 1c             	add    $0x1c,%esp
80105965:	5b                   	pop    %ebx
80105966:	5e                   	pop    %esi
80105967:	5f                   	pop    %edi
80105968:	5d                   	pop    %ebp
80105969:	c3                   	ret    
8010596a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105970 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105976:	c7 04 24 40 58 10 80 	movl   $0x80105840,(%esp)
8010597d:	e8 2e ae ff ff       	call   801007b0 <consoleintr>
}
80105982:	c9                   	leave  
80105983:	c3                   	ret    

80105984 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105984:	6a 00                	push   $0x0
  pushl $0
80105986:	6a 00                	push   $0x0
  jmp alltraps
80105988:	e9 40 fb ff ff       	jmp    801054cd <alltraps>

8010598d <vector1>:
.globl vector1
vector1:
  pushl $0
8010598d:	6a 00                	push   $0x0
  pushl $1
8010598f:	6a 01                	push   $0x1
  jmp alltraps
80105991:	e9 37 fb ff ff       	jmp    801054cd <alltraps>

80105996 <vector2>:
.globl vector2
vector2:
  pushl $0
80105996:	6a 00                	push   $0x0
  pushl $2
80105998:	6a 02                	push   $0x2
  jmp alltraps
8010599a:	e9 2e fb ff ff       	jmp    801054cd <alltraps>

8010599f <vector3>:
.globl vector3
vector3:
  pushl $0
8010599f:	6a 00                	push   $0x0
  pushl $3
801059a1:	6a 03                	push   $0x3
  jmp alltraps
801059a3:	e9 25 fb ff ff       	jmp    801054cd <alltraps>

801059a8 <vector4>:
.globl vector4
vector4:
  pushl $0
801059a8:	6a 00                	push   $0x0
  pushl $4
801059aa:	6a 04                	push   $0x4
  jmp alltraps
801059ac:	e9 1c fb ff ff       	jmp    801054cd <alltraps>

801059b1 <vector5>:
.globl vector5
vector5:
  pushl $0
801059b1:	6a 00                	push   $0x0
  pushl $5
801059b3:	6a 05                	push   $0x5
  jmp alltraps
801059b5:	e9 13 fb ff ff       	jmp    801054cd <alltraps>

801059ba <vector6>:
.globl vector6
vector6:
  pushl $0
801059ba:	6a 00                	push   $0x0
  pushl $6
801059bc:	6a 06                	push   $0x6
  jmp alltraps
801059be:	e9 0a fb ff ff       	jmp    801054cd <alltraps>

801059c3 <vector7>:
.globl vector7
vector7:
  pushl $0
801059c3:	6a 00                	push   $0x0
  pushl $7
801059c5:	6a 07                	push   $0x7
  jmp alltraps
801059c7:	e9 01 fb ff ff       	jmp    801054cd <alltraps>

801059cc <vector8>:
.globl vector8
vector8:
  pushl $8
801059cc:	6a 08                	push   $0x8
  jmp alltraps
801059ce:	e9 fa fa ff ff       	jmp    801054cd <alltraps>

801059d3 <vector9>:
.globl vector9
vector9:
  pushl $0
801059d3:	6a 00                	push   $0x0
  pushl $9
801059d5:	6a 09                	push   $0x9
  jmp alltraps
801059d7:	e9 f1 fa ff ff       	jmp    801054cd <alltraps>

801059dc <vector10>:
.globl vector10
vector10:
  pushl $10
801059dc:	6a 0a                	push   $0xa
  jmp alltraps
801059de:	e9 ea fa ff ff       	jmp    801054cd <alltraps>

801059e3 <vector11>:
.globl vector11
vector11:
  pushl $11
801059e3:	6a 0b                	push   $0xb
  jmp alltraps
801059e5:	e9 e3 fa ff ff       	jmp    801054cd <alltraps>

801059ea <vector12>:
.globl vector12
vector12:
  pushl $12
801059ea:	6a 0c                	push   $0xc
  jmp alltraps
801059ec:	e9 dc fa ff ff       	jmp    801054cd <alltraps>

801059f1 <vector13>:
.globl vector13
vector13:
  pushl $13
801059f1:	6a 0d                	push   $0xd
  jmp alltraps
801059f3:	e9 d5 fa ff ff       	jmp    801054cd <alltraps>

801059f8 <vector14>:
.globl vector14
vector14:
  pushl $14
801059f8:	6a 0e                	push   $0xe
  jmp alltraps
801059fa:	e9 ce fa ff ff       	jmp    801054cd <alltraps>

801059ff <vector15>:
.globl vector15
vector15:
  pushl $0
801059ff:	6a 00                	push   $0x0
  pushl $15
80105a01:	6a 0f                	push   $0xf
  jmp alltraps
80105a03:	e9 c5 fa ff ff       	jmp    801054cd <alltraps>

80105a08 <vector16>:
.globl vector16
vector16:
  pushl $0
80105a08:	6a 00                	push   $0x0
  pushl $16
80105a0a:	6a 10                	push   $0x10
  jmp alltraps
80105a0c:	e9 bc fa ff ff       	jmp    801054cd <alltraps>

80105a11 <vector17>:
.globl vector17
vector17:
  pushl $17
80105a11:	6a 11                	push   $0x11
  jmp alltraps
80105a13:	e9 b5 fa ff ff       	jmp    801054cd <alltraps>

80105a18 <vector18>:
.globl vector18
vector18:
  pushl $0
80105a18:	6a 00                	push   $0x0
  pushl $18
80105a1a:	6a 12                	push   $0x12
  jmp alltraps
80105a1c:	e9 ac fa ff ff       	jmp    801054cd <alltraps>

80105a21 <vector19>:
.globl vector19
vector19:
  pushl $0
80105a21:	6a 00                	push   $0x0
  pushl $19
80105a23:	6a 13                	push   $0x13
  jmp alltraps
80105a25:	e9 a3 fa ff ff       	jmp    801054cd <alltraps>

80105a2a <vector20>:
.globl vector20
vector20:
  pushl $0
80105a2a:	6a 00                	push   $0x0
  pushl $20
80105a2c:	6a 14                	push   $0x14
  jmp alltraps
80105a2e:	e9 9a fa ff ff       	jmp    801054cd <alltraps>

80105a33 <vector21>:
.globl vector21
vector21:
  pushl $0
80105a33:	6a 00                	push   $0x0
  pushl $21
80105a35:	6a 15                	push   $0x15
  jmp alltraps
80105a37:	e9 91 fa ff ff       	jmp    801054cd <alltraps>

80105a3c <vector22>:
.globl vector22
vector22:
  pushl $0
80105a3c:	6a 00                	push   $0x0
  pushl $22
80105a3e:	6a 16                	push   $0x16
  jmp alltraps
80105a40:	e9 88 fa ff ff       	jmp    801054cd <alltraps>

80105a45 <vector23>:
.globl vector23
vector23:
  pushl $0
80105a45:	6a 00                	push   $0x0
  pushl $23
80105a47:	6a 17                	push   $0x17
  jmp alltraps
80105a49:	e9 7f fa ff ff       	jmp    801054cd <alltraps>

80105a4e <vector24>:
.globl vector24
vector24:
  pushl $0
80105a4e:	6a 00                	push   $0x0
  pushl $24
80105a50:	6a 18                	push   $0x18
  jmp alltraps
80105a52:	e9 76 fa ff ff       	jmp    801054cd <alltraps>

80105a57 <vector25>:
.globl vector25
vector25:
  pushl $0
80105a57:	6a 00                	push   $0x0
  pushl $25
80105a59:	6a 19                	push   $0x19
  jmp alltraps
80105a5b:	e9 6d fa ff ff       	jmp    801054cd <alltraps>

80105a60 <vector26>:
.globl vector26
vector26:
  pushl $0
80105a60:	6a 00                	push   $0x0
  pushl $26
80105a62:	6a 1a                	push   $0x1a
  jmp alltraps
80105a64:	e9 64 fa ff ff       	jmp    801054cd <alltraps>

80105a69 <vector27>:
.globl vector27
vector27:
  pushl $0
80105a69:	6a 00                	push   $0x0
  pushl $27
80105a6b:	6a 1b                	push   $0x1b
  jmp alltraps
80105a6d:	e9 5b fa ff ff       	jmp    801054cd <alltraps>

80105a72 <vector28>:
.globl vector28
vector28:
  pushl $0
80105a72:	6a 00                	push   $0x0
  pushl $28
80105a74:	6a 1c                	push   $0x1c
  jmp alltraps
80105a76:	e9 52 fa ff ff       	jmp    801054cd <alltraps>

80105a7b <vector29>:
.globl vector29
vector29:
  pushl $0
80105a7b:	6a 00                	push   $0x0
  pushl $29
80105a7d:	6a 1d                	push   $0x1d
  jmp alltraps
80105a7f:	e9 49 fa ff ff       	jmp    801054cd <alltraps>

80105a84 <vector30>:
.globl vector30
vector30:
  pushl $0
80105a84:	6a 00                	push   $0x0
  pushl $30
80105a86:	6a 1e                	push   $0x1e
  jmp alltraps
80105a88:	e9 40 fa ff ff       	jmp    801054cd <alltraps>

80105a8d <vector31>:
.globl vector31
vector31:
  pushl $0
80105a8d:	6a 00                	push   $0x0
  pushl $31
80105a8f:	6a 1f                	push   $0x1f
  jmp alltraps
80105a91:	e9 37 fa ff ff       	jmp    801054cd <alltraps>

80105a96 <vector32>:
.globl vector32
vector32:
  pushl $0
80105a96:	6a 00                	push   $0x0
  pushl $32
80105a98:	6a 20                	push   $0x20
  jmp alltraps
80105a9a:	e9 2e fa ff ff       	jmp    801054cd <alltraps>

80105a9f <vector33>:
.globl vector33
vector33:
  pushl $0
80105a9f:	6a 00                	push   $0x0
  pushl $33
80105aa1:	6a 21                	push   $0x21
  jmp alltraps
80105aa3:	e9 25 fa ff ff       	jmp    801054cd <alltraps>

80105aa8 <vector34>:
.globl vector34
vector34:
  pushl $0
80105aa8:	6a 00                	push   $0x0
  pushl $34
80105aaa:	6a 22                	push   $0x22
  jmp alltraps
80105aac:	e9 1c fa ff ff       	jmp    801054cd <alltraps>

80105ab1 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ab1:	6a 00                	push   $0x0
  pushl $35
80105ab3:	6a 23                	push   $0x23
  jmp alltraps
80105ab5:	e9 13 fa ff ff       	jmp    801054cd <alltraps>

80105aba <vector36>:
.globl vector36
vector36:
  pushl $0
80105aba:	6a 00                	push   $0x0
  pushl $36
80105abc:	6a 24                	push   $0x24
  jmp alltraps
80105abe:	e9 0a fa ff ff       	jmp    801054cd <alltraps>

80105ac3 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ac3:	6a 00                	push   $0x0
  pushl $37
80105ac5:	6a 25                	push   $0x25
  jmp alltraps
80105ac7:	e9 01 fa ff ff       	jmp    801054cd <alltraps>

80105acc <vector38>:
.globl vector38
vector38:
  pushl $0
80105acc:	6a 00                	push   $0x0
  pushl $38
80105ace:	6a 26                	push   $0x26
  jmp alltraps
80105ad0:	e9 f8 f9 ff ff       	jmp    801054cd <alltraps>

80105ad5 <vector39>:
.globl vector39
vector39:
  pushl $0
80105ad5:	6a 00                	push   $0x0
  pushl $39
80105ad7:	6a 27                	push   $0x27
  jmp alltraps
80105ad9:	e9 ef f9 ff ff       	jmp    801054cd <alltraps>

80105ade <vector40>:
.globl vector40
vector40:
  pushl $0
80105ade:	6a 00                	push   $0x0
  pushl $40
80105ae0:	6a 28                	push   $0x28
  jmp alltraps
80105ae2:	e9 e6 f9 ff ff       	jmp    801054cd <alltraps>

80105ae7 <vector41>:
.globl vector41
vector41:
  pushl $0
80105ae7:	6a 00                	push   $0x0
  pushl $41
80105ae9:	6a 29                	push   $0x29
  jmp alltraps
80105aeb:	e9 dd f9 ff ff       	jmp    801054cd <alltraps>

80105af0 <vector42>:
.globl vector42
vector42:
  pushl $0
80105af0:	6a 00                	push   $0x0
  pushl $42
80105af2:	6a 2a                	push   $0x2a
  jmp alltraps
80105af4:	e9 d4 f9 ff ff       	jmp    801054cd <alltraps>

80105af9 <vector43>:
.globl vector43
vector43:
  pushl $0
80105af9:	6a 00                	push   $0x0
  pushl $43
80105afb:	6a 2b                	push   $0x2b
  jmp alltraps
80105afd:	e9 cb f9 ff ff       	jmp    801054cd <alltraps>

80105b02 <vector44>:
.globl vector44
vector44:
  pushl $0
80105b02:	6a 00                	push   $0x0
  pushl $44
80105b04:	6a 2c                	push   $0x2c
  jmp alltraps
80105b06:	e9 c2 f9 ff ff       	jmp    801054cd <alltraps>

80105b0b <vector45>:
.globl vector45
vector45:
  pushl $0
80105b0b:	6a 00                	push   $0x0
  pushl $45
80105b0d:	6a 2d                	push   $0x2d
  jmp alltraps
80105b0f:	e9 b9 f9 ff ff       	jmp    801054cd <alltraps>

80105b14 <vector46>:
.globl vector46
vector46:
  pushl $0
80105b14:	6a 00                	push   $0x0
  pushl $46
80105b16:	6a 2e                	push   $0x2e
  jmp alltraps
80105b18:	e9 b0 f9 ff ff       	jmp    801054cd <alltraps>

80105b1d <vector47>:
.globl vector47
vector47:
  pushl $0
80105b1d:	6a 00                	push   $0x0
  pushl $47
80105b1f:	6a 2f                	push   $0x2f
  jmp alltraps
80105b21:	e9 a7 f9 ff ff       	jmp    801054cd <alltraps>

80105b26 <vector48>:
.globl vector48
vector48:
  pushl $0
80105b26:	6a 00                	push   $0x0
  pushl $48
80105b28:	6a 30                	push   $0x30
  jmp alltraps
80105b2a:	e9 9e f9 ff ff       	jmp    801054cd <alltraps>

80105b2f <vector49>:
.globl vector49
vector49:
  pushl $0
80105b2f:	6a 00                	push   $0x0
  pushl $49
80105b31:	6a 31                	push   $0x31
  jmp alltraps
80105b33:	e9 95 f9 ff ff       	jmp    801054cd <alltraps>

80105b38 <vector50>:
.globl vector50
vector50:
  pushl $0
80105b38:	6a 00                	push   $0x0
  pushl $50
80105b3a:	6a 32                	push   $0x32
  jmp alltraps
80105b3c:	e9 8c f9 ff ff       	jmp    801054cd <alltraps>

80105b41 <vector51>:
.globl vector51
vector51:
  pushl $0
80105b41:	6a 00                	push   $0x0
  pushl $51
80105b43:	6a 33                	push   $0x33
  jmp alltraps
80105b45:	e9 83 f9 ff ff       	jmp    801054cd <alltraps>

80105b4a <vector52>:
.globl vector52
vector52:
  pushl $0
80105b4a:	6a 00                	push   $0x0
  pushl $52
80105b4c:	6a 34                	push   $0x34
  jmp alltraps
80105b4e:	e9 7a f9 ff ff       	jmp    801054cd <alltraps>

80105b53 <vector53>:
.globl vector53
vector53:
  pushl $0
80105b53:	6a 00                	push   $0x0
  pushl $53
80105b55:	6a 35                	push   $0x35
  jmp alltraps
80105b57:	e9 71 f9 ff ff       	jmp    801054cd <alltraps>

80105b5c <vector54>:
.globl vector54
vector54:
  pushl $0
80105b5c:	6a 00                	push   $0x0
  pushl $54
80105b5e:	6a 36                	push   $0x36
  jmp alltraps
80105b60:	e9 68 f9 ff ff       	jmp    801054cd <alltraps>

80105b65 <vector55>:
.globl vector55
vector55:
  pushl $0
80105b65:	6a 00                	push   $0x0
  pushl $55
80105b67:	6a 37                	push   $0x37
  jmp alltraps
80105b69:	e9 5f f9 ff ff       	jmp    801054cd <alltraps>

80105b6e <vector56>:
.globl vector56
vector56:
  pushl $0
80105b6e:	6a 00                	push   $0x0
  pushl $56
80105b70:	6a 38                	push   $0x38
  jmp alltraps
80105b72:	e9 56 f9 ff ff       	jmp    801054cd <alltraps>

80105b77 <vector57>:
.globl vector57
vector57:
  pushl $0
80105b77:	6a 00                	push   $0x0
  pushl $57
80105b79:	6a 39                	push   $0x39
  jmp alltraps
80105b7b:	e9 4d f9 ff ff       	jmp    801054cd <alltraps>

80105b80 <vector58>:
.globl vector58
vector58:
  pushl $0
80105b80:	6a 00                	push   $0x0
  pushl $58
80105b82:	6a 3a                	push   $0x3a
  jmp alltraps
80105b84:	e9 44 f9 ff ff       	jmp    801054cd <alltraps>

80105b89 <vector59>:
.globl vector59
vector59:
  pushl $0
80105b89:	6a 00                	push   $0x0
  pushl $59
80105b8b:	6a 3b                	push   $0x3b
  jmp alltraps
80105b8d:	e9 3b f9 ff ff       	jmp    801054cd <alltraps>

80105b92 <vector60>:
.globl vector60
vector60:
  pushl $0
80105b92:	6a 00                	push   $0x0
  pushl $60
80105b94:	6a 3c                	push   $0x3c
  jmp alltraps
80105b96:	e9 32 f9 ff ff       	jmp    801054cd <alltraps>

80105b9b <vector61>:
.globl vector61
vector61:
  pushl $0
80105b9b:	6a 00                	push   $0x0
  pushl $61
80105b9d:	6a 3d                	push   $0x3d
  jmp alltraps
80105b9f:	e9 29 f9 ff ff       	jmp    801054cd <alltraps>

80105ba4 <vector62>:
.globl vector62
vector62:
  pushl $0
80105ba4:	6a 00                	push   $0x0
  pushl $62
80105ba6:	6a 3e                	push   $0x3e
  jmp alltraps
80105ba8:	e9 20 f9 ff ff       	jmp    801054cd <alltraps>

80105bad <vector63>:
.globl vector63
vector63:
  pushl $0
80105bad:	6a 00                	push   $0x0
  pushl $63
80105baf:	6a 3f                	push   $0x3f
  jmp alltraps
80105bb1:	e9 17 f9 ff ff       	jmp    801054cd <alltraps>

80105bb6 <vector64>:
.globl vector64
vector64:
  pushl $0
80105bb6:	6a 00                	push   $0x0
  pushl $64
80105bb8:	6a 40                	push   $0x40
  jmp alltraps
80105bba:	e9 0e f9 ff ff       	jmp    801054cd <alltraps>

80105bbf <vector65>:
.globl vector65
vector65:
  pushl $0
80105bbf:	6a 00                	push   $0x0
  pushl $65
80105bc1:	6a 41                	push   $0x41
  jmp alltraps
80105bc3:	e9 05 f9 ff ff       	jmp    801054cd <alltraps>

80105bc8 <vector66>:
.globl vector66
vector66:
  pushl $0
80105bc8:	6a 00                	push   $0x0
  pushl $66
80105bca:	6a 42                	push   $0x42
  jmp alltraps
80105bcc:	e9 fc f8 ff ff       	jmp    801054cd <alltraps>

80105bd1 <vector67>:
.globl vector67
vector67:
  pushl $0
80105bd1:	6a 00                	push   $0x0
  pushl $67
80105bd3:	6a 43                	push   $0x43
  jmp alltraps
80105bd5:	e9 f3 f8 ff ff       	jmp    801054cd <alltraps>

80105bda <vector68>:
.globl vector68
vector68:
  pushl $0
80105bda:	6a 00                	push   $0x0
  pushl $68
80105bdc:	6a 44                	push   $0x44
  jmp alltraps
80105bde:	e9 ea f8 ff ff       	jmp    801054cd <alltraps>

80105be3 <vector69>:
.globl vector69
vector69:
  pushl $0
80105be3:	6a 00                	push   $0x0
  pushl $69
80105be5:	6a 45                	push   $0x45
  jmp alltraps
80105be7:	e9 e1 f8 ff ff       	jmp    801054cd <alltraps>

80105bec <vector70>:
.globl vector70
vector70:
  pushl $0
80105bec:	6a 00                	push   $0x0
  pushl $70
80105bee:	6a 46                	push   $0x46
  jmp alltraps
80105bf0:	e9 d8 f8 ff ff       	jmp    801054cd <alltraps>

80105bf5 <vector71>:
.globl vector71
vector71:
  pushl $0
80105bf5:	6a 00                	push   $0x0
  pushl $71
80105bf7:	6a 47                	push   $0x47
  jmp alltraps
80105bf9:	e9 cf f8 ff ff       	jmp    801054cd <alltraps>

80105bfe <vector72>:
.globl vector72
vector72:
  pushl $0
80105bfe:	6a 00                	push   $0x0
  pushl $72
80105c00:	6a 48                	push   $0x48
  jmp alltraps
80105c02:	e9 c6 f8 ff ff       	jmp    801054cd <alltraps>

80105c07 <vector73>:
.globl vector73
vector73:
  pushl $0
80105c07:	6a 00                	push   $0x0
  pushl $73
80105c09:	6a 49                	push   $0x49
  jmp alltraps
80105c0b:	e9 bd f8 ff ff       	jmp    801054cd <alltraps>

80105c10 <vector74>:
.globl vector74
vector74:
  pushl $0
80105c10:	6a 00                	push   $0x0
  pushl $74
80105c12:	6a 4a                	push   $0x4a
  jmp alltraps
80105c14:	e9 b4 f8 ff ff       	jmp    801054cd <alltraps>

80105c19 <vector75>:
.globl vector75
vector75:
  pushl $0
80105c19:	6a 00                	push   $0x0
  pushl $75
80105c1b:	6a 4b                	push   $0x4b
  jmp alltraps
80105c1d:	e9 ab f8 ff ff       	jmp    801054cd <alltraps>

80105c22 <vector76>:
.globl vector76
vector76:
  pushl $0
80105c22:	6a 00                	push   $0x0
  pushl $76
80105c24:	6a 4c                	push   $0x4c
  jmp alltraps
80105c26:	e9 a2 f8 ff ff       	jmp    801054cd <alltraps>

80105c2b <vector77>:
.globl vector77
vector77:
  pushl $0
80105c2b:	6a 00                	push   $0x0
  pushl $77
80105c2d:	6a 4d                	push   $0x4d
  jmp alltraps
80105c2f:	e9 99 f8 ff ff       	jmp    801054cd <alltraps>

80105c34 <vector78>:
.globl vector78
vector78:
  pushl $0
80105c34:	6a 00                	push   $0x0
  pushl $78
80105c36:	6a 4e                	push   $0x4e
  jmp alltraps
80105c38:	e9 90 f8 ff ff       	jmp    801054cd <alltraps>

80105c3d <vector79>:
.globl vector79
vector79:
  pushl $0
80105c3d:	6a 00                	push   $0x0
  pushl $79
80105c3f:	6a 4f                	push   $0x4f
  jmp alltraps
80105c41:	e9 87 f8 ff ff       	jmp    801054cd <alltraps>

80105c46 <vector80>:
.globl vector80
vector80:
  pushl $0
80105c46:	6a 00                	push   $0x0
  pushl $80
80105c48:	6a 50                	push   $0x50
  jmp alltraps
80105c4a:	e9 7e f8 ff ff       	jmp    801054cd <alltraps>

80105c4f <vector81>:
.globl vector81
vector81:
  pushl $0
80105c4f:	6a 00                	push   $0x0
  pushl $81
80105c51:	6a 51                	push   $0x51
  jmp alltraps
80105c53:	e9 75 f8 ff ff       	jmp    801054cd <alltraps>

80105c58 <vector82>:
.globl vector82
vector82:
  pushl $0
80105c58:	6a 00                	push   $0x0
  pushl $82
80105c5a:	6a 52                	push   $0x52
  jmp alltraps
80105c5c:	e9 6c f8 ff ff       	jmp    801054cd <alltraps>

80105c61 <vector83>:
.globl vector83
vector83:
  pushl $0
80105c61:	6a 00                	push   $0x0
  pushl $83
80105c63:	6a 53                	push   $0x53
  jmp alltraps
80105c65:	e9 63 f8 ff ff       	jmp    801054cd <alltraps>

80105c6a <vector84>:
.globl vector84
vector84:
  pushl $0
80105c6a:	6a 00                	push   $0x0
  pushl $84
80105c6c:	6a 54                	push   $0x54
  jmp alltraps
80105c6e:	e9 5a f8 ff ff       	jmp    801054cd <alltraps>

80105c73 <vector85>:
.globl vector85
vector85:
  pushl $0
80105c73:	6a 00                	push   $0x0
  pushl $85
80105c75:	6a 55                	push   $0x55
  jmp alltraps
80105c77:	e9 51 f8 ff ff       	jmp    801054cd <alltraps>

80105c7c <vector86>:
.globl vector86
vector86:
  pushl $0
80105c7c:	6a 00                	push   $0x0
  pushl $86
80105c7e:	6a 56                	push   $0x56
  jmp alltraps
80105c80:	e9 48 f8 ff ff       	jmp    801054cd <alltraps>

80105c85 <vector87>:
.globl vector87
vector87:
  pushl $0
80105c85:	6a 00                	push   $0x0
  pushl $87
80105c87:	6a 57                	push   $0x57
  jmp alltraps
80105c89:	e9 3f f8 ff ff       	jmp    801054cd <alltraps>

80105c8e <vector88>:
.globl vector88
vector88:
  pushl $0
80105c8e:	6a 00                	push   $0x0
  pushl $88
80105c90:	6a 58                	push   $0x58
  jmp alltraps
80105c92:	e9 36 f8 ff ff       	jmp    801054cd <alltraps>

80105c97 <vector89>:
.globl vector89
vector89:
  pushl $0
80105c97:	6a 00                	push   $0x0
  pushl $89
80105c99:	6a 59                	push   $0x59
  jmp alltraps
80105c9b:	e9 2d f8 ff ff       	jmp    801054cd <alltraps>

80105ca0 <vector90>:
.globl vector90
vector90:
  pushl $0
80105ca0:	6a 00                	push   $0x0
  pushl $90
80105ca2:	6a 5a                	push   $0x5a
  jmp alltraps
80105ca4:	e9 24 f8 ff ff       	jmp    801054cd <alltraps>

80105ca9 <vector91>:
.globl vector91
vector91:
  pushl $0
80105ca9:	6a 00                	push   $0x0
  pushl $91
80105cab:	6a 5b                	push   $0x5b
  jmp alltraps
80105cad:	e9 1b f8 ff ff       	jmp    801054cd <alltraps>

80105cb2 <vector92>:
.globl vector92
vector92:
  pushl $0
80105cb2:	6a 00                	push   $0x0
  pushl $92
80105cb4:	6a 5c                	push   $0x5c
  jmp alltraps
80105cb6:	e9 12 f8 ff ff       	jmp    801054cd <alltraps>

80105cbb <vector93>:
.globl vector93
vector93:
  pushl $0
80105cbb:	6a 00                	push   $0x0
  pushl $93
80105cbd:	6a 5d                	push   $0x5d
  jmp alltraps
80105cbf:	e9 09 f8 ff ff       	jmp    801054cd <alltraps>

80105cc4 <vector94>:
.globl vector94
vector94:
  pushl $0
80105cc4:	6a 00                	push   $0x0
  pushl $94
80105cc6:	6a 5e                	push   $0x5e
  jmp alltraps
80105cc8:	e9 00 f8 ff ff       	jmp    801054cd <alltraps>

80105ccd <vector95>:
.globl vector95
vector95:
  pushl $0
80105ccd:	6a 00                	push   $0x0
  pushl $95
80105ccf:	6a 5f                	push   $0x5f
  jmp alltraps
80105cd1:	e9 f7 f7 ff ff       	jmp    801054cd <alltraps>

80105cd6 <vector96>:
.globl vector96
vector96:
  pushl $0
80105cd6:	6a 00                	push   $0x0
  pushl $96
80105cd8:	6a 60                	push   $0x60
  jmp alltraps
80105cda:	e9 ee f7 ff ff       	jmp    801054cd <alltraps>

80105cdf <vector97>:
.globl vector97
vector97:
  pushl $0
80105cdf:	6a 00                	push   $0x0
  pushl $97
80105ce1:	6a 61                	push   $0x61
  jmp alltraps
80105ce3:	e9 e5 f7 ff ff       	jmp    801054cd <alltraps>

80105ce8 <vector98>:
.globl vector98
vector98:
  pushl $0
80105ce8:	6a 00                	push   $0x0
  pushl $98
80105cea:	6a 62                	push   $0x62
  jmp alltraps
80105cec:	e9 dc f7 ff ff       	jmp    801054cd <alltraps>

80105cf1 <vector99>:
.globl vector99
vector99:
  pushl $0
80105cf1:	6a 00                	push   $0x0
  pushl $99
80105cf3:	6a 63                	push   $0x63
  jmp alltraps
80105cf5:	e9 d3 f7 ff ff       	jmp    801054cd <alltraps>

80105cfa <vector100>:
.globl vector100
vector100:
  pushl $0
80105cfa:	6a 00                	push   $0x0
  pushl $100
80105cfc:	6a 64                	push   $0x64
  jmp alltraps
80105cfe:	e9 ca f7 ff ff       	jmp    801054cd <alltraps>

80105d03 <vector101>:
.globl vector101
vector101:
  pushl $0
80105d03:	6a 00                	push   $0x0
  pushl $101
80105d05:	6a 65                	push   $0x65
  jmp alltraps
80105d07:	e9 c1 f7 ff ff       	jmp    801054cd <alltraps>

80105d0c <vector102>:
.globl vector102
vector102:
  pushl $0
80105d0c:	6a 00                	push   $0x0
  pushl $102
80105d0e:	6a 66                	push   $0x66
  jmp alltraps
80105d10:	e9 b8 f7 ff ff       	jmp    801054cd <alltraps>

80105d15 <vector103>:
.globl vector103
vector103:
  pushl $0
80105d15:	6a 00                	push   $0x0
  pushl $103
80105d17:	6a 67                	push   $0x67
  jmp alltraps
80105d19:	e9 af f7 ff ff       	jmp    801054cd <alltraps>

80105d1e <vector104>:
.globl vector104
vector104:
  pushl $0
80105d1e:	6a 00                	push   $0x0
  pushl $104
80105d20:	6a 68                	push   $0x68
  jmp alltraps
80105d22:	e9 a6 f7 ff ff       	jmp    801054cd <alltraps>

80105d27 <vector105>:
.globl vector105
vector105:
  pushl $0
80105d27:	6a 00                	push   $0x0
  pushl $105
80105d29:	6a 69                	push   $0x69
  jmp alltraps
80105d2b:	e9 9d f7 ff ff       	jmp    801054cd <alltraps>

80105d30 <vector106>:
.globl vector106
vector106:
  pushl $0
80105d30:	6a 00                	push   $0x0
  pushl $106
80105d32:	6a 6a                	push   $0x6a
  jmp alltraps
80105d34:	e9 94 f7 ff ff       	jmp    801054cd <alltraps>

80105d39 <vector107>:
.globl vector107
vector107:
  pushl $0
80105d39:	6a 00                	push   $0x0
  pushl $107
80105d3b:	6a 6b                	push   $0x6b
  jmp alltraps
80105d3d:	e9 8b f7 ff ff       	jmp    801054cd <alltraps>

80105d42 <vector108>:
.globl vector108
vector108:
  pushl $0
80105d42:	6a 00                	push   $0x0
  pushl $108
80105d44:	6a 6c                	push   $0x6c
  jmp alltraps
80105d46:	e9 82 f7 ff ff       	jmp    801054cd <alltraps>

80105d4b <vector109>:
.globl vector109
vector109:
  pushl $0
80105d4b:	6a 00                	push   $0x0
  pushl $109
80105d4d:	6a 6d                	push   $0x6d
  jmp alltraps
80105d4f:	e9 79 f7 ff ff       	jmp    801054cd <alltraps>

80105d54 <vector110>:
.globl vector110
vector110:
  pushl $0
80105d54:	6a 00                	push   $0x0
  pushl $110
80105d56:	6a 6e                	push   $0x6e
  jmp alltraps
80105d58:	e9 70 f7 ff ff       	jmp    801054cd <alltraps>

80105d5d <vector111>:
.globl vector111
vector111:
  pushl $0
80105d5d:	6a 00                	push   $0x0
  pushl $111
80105d5f:	6a 6f                	push   $0x6f
  jmp alltraps
80105d61:	e9 67 f7 ff ff       	jmp    801054cd <alltraps>

80105d66 <vector112>:
.globl vector112
vector112:
  pushl $0
80105d66:	6a 00                	push   $0x0
  pushl $112
80105d68:	6a 70                	push   $0x70
  jmp alltraps
80105d6a:	e9 5e f7 ff ff       	jmp    801054cd <alltraps>

80105d6f <vector113>:
.globl vector113
vector113:
  pushl $0
80105d6f:	6a 00                	push   $0x0
  pushl $113
80105d71:	6a 71                	push   $0x71
  jmp alltraps
80105d73:	e9 55 f7 ff ff       	jmp    801054cd <alltraps>

80105d78 <vector114>:
.globl vector114
vector114:
  pushl $0
80105d78:	6a 00                	push   $0x0
  pushl $114
80105d7a:	6a 72                	push   $0x72
  jmp alltraps
80105d7c:	e9 4c f7 ff ff       	jmp    801054cd <alltraps>

80105d81 <vector115>:
.globl vector115
vector115:
  pushl $0
80105d81:	6a 00                	push   $0x0
  pushl $115
80105d83:	6a 73                	push   $0x73
  jmp alltraps
80105d85:	e9 43 f7 ff ff       	jmp    801054cd <alltraps>

80105d8a <vector116>:
.globl vector116
vector116:
  pushl $0
80105d8a:	6a 00                	push   $0x0
  pushl $116
80105d8c:	6a 74                	push   $0x74
  jmp alltraps
80105d8e:	e9 3a f7 ff ff       	jmp    801054cd <alltraps>

80105d93 <vector117>:
.globl vector117
vector117:
  pushl $0
80105d93:	6a 00                	push   $0x0
  pushl $117
80105d95:	6a 75                	push   $0x75
  jmp alltraps
80105d97:	e9 31 f7 ff ff       	jmp    801054cd <alltraps>

80105d9c <vector118>:
.globl vector118
vector118:
  pushl $0
80105d9c:	6a 00                	push   $0x0
  pushl $118
80105d9e:	6a 76                	push   $0x76
  jmp alltraps
80105da0:	e9 28 f7 ff ff       	jmp    801054cd <alltraps>

80105da5 <vector119>:
.globl vector119
vector119:
  pushl $0
80105da5:	6a 00                	push   $0x0
  pushl $119
80105da7:	6a 77                	push   $0x77
  jmp alltraps
80105da9:	e9 1f f7 ff ff       	jmp    801054cd <alltraps>

80105dae <vector120>:
.globl vector120
vector120:
  pushl $0
80105dae:	6a 00                	push   $0x0
  pushl $120
80105db0:	6a 78                	push   $0x78
  jmp alltraps
80105db2:	e9 16 f7 ff ff       	jmp    801054cd <alltraps>

80105db7 <vector121>:
.globl vector121
vector121:
  pushl $0
80105db7:	6a 00                	push   $0x0
  pushl $121
80105db9:	6a 79                	push   $0x79
  jmp alltraps
80105dbb:	e9 0d f7 ff ff       	jmp    801054cd <alltraps>

80105dc0 <vector122>:
.globl vector122
vector122:
  pushl $0
80105dc0:	6a 00                	push   $0x0
  pushl $122
80105dc2:	6a 7a                	push   $0x7a
  jmp alltraps
80105dc4:	e9 04 f7 ff ff       	jmp    801054cd <alltraps>

80105dc9 <vector123>:
.globl vector123
vector123:
  pushl $0
80105dc9:	6a 00                	push   $0x0
  pushl $123
80105dcb:	6a 7b                	push   $0x7b
  jmp alltraps
80105dcd:	e9 fb f6 ff ff       	jmp    801054cd <alltraps>

80105dd2 <vector124>:
.globl vector124
vector124:
  pushl $0
80105dd2:	6a 00                	push   $0x0
  pushl $124
80105dd4:	6a 7c                	push   $0x7c
  jmp alltraps
80105dd6:	e9 f2 f6 ff ff       	jmp    801054cd <alltraps>

80105ddb <vector125>:
.globl vector125
vector125:
  pushl $0
80105ddb:	6a 00                	push   $0x0
  pushl $125
80105ddd:	6a 7d                	push   $0x7d
  jmp alltraps
80105ddf:	e9 e9 f6 ff ff       	jmp    801054cd <alltraps>

80105de4 <vector126>:
.globl vector126
vector126:
  pushl $0
80105de4:	6a 00                	push   $0x0
  pushl $126
80105de6:	6a 7e                	push   $0x7e
  jmp alltraps
80105de8:	e9 e0 f6 ff ff       	jmp    801054cd <alltraps>

80105ded <vector127>:
.globl vector127
vector127:
  pushl $0
80105ded:	6a 00                	push   $0x0
  pushl $127
80105def:	6a 7f                	push   $0x7f
  jmp alltraps
80105df1:	e9 d7 f6 ff ff       	jmp    801054cd <alltraps>

80105df6 <vector128>:
.globl vector128
vector128:
  pushl $0
80105df6:	6a 00                	push   $0x0
  pushl $128
80105df8:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105dfd:	e9 cb f6 ff ff       	jmp    801054cd <alltraps>

80105e02 <vector129>:
.globl vector129
vector129:
  pushl $0
80105e02:	6a 00                	push   $0x0
  pushl $129
80105e04:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105e09:	e9 bf f6 ff ff       	jmp    801054cd <alltraps>

80105e0e <vector130>:
.globl vector130
vector130:
  pushl $0
80105e0e:	6a 00                	push   $0x0
  pushl $130
80105e10:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105e15:	e9 b3 f6 ff ff       	jmp    801054cd <alltraps>

80105e1a <vector131>:
.globl vector131
vector131:
  pushl $0
80105e1a:	6a 00                	push   $0x0
  pushl $131
80105e1c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105e21:	e9 a7 f6 ff ff       	jmp    801054cd <alltraps>

80105e26 <vector132>:
.globl vector132
vector132:
  pushl $0
80105e26:	6a 00                	push   $0x0
  pushl $132
80105e28:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105e2d:	e9 9b f6 ff ff       	jmp    801054cd <alltraps>

80105e32 <vector133>:
.globl vector133
vector133:
  pushl $0
80105e32:	6a 00                	push   $0x0
  pushl $133
80105e34:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105e39:	e9 8f f6 ff ff       	jmp    801054cd <alltraps>

80105e3e <vector134>:
.globl vector134
vector134:
  pushl $0
80105e3e:	6a 00                	push   $0x0
  pushl $134
80105e40:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105e45:	e9 83 f6 ff ff       	jmp    801054cd <alltraps>

80105e4a <vector135>:
.globl vector135
vector135:
  pushl $0
80105e4a:	6a 00                	push   $0x0
  pushl $135
80105e4c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105e51:	e9 77 f6 ff ff       	jmp    801054cd <alltraps>

80105e56 <vector136>:
.globl vector136
vector136:
  pushl $0
80105e56:	6a 00                	push   $0x0
  pushl $136
80105e58:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105e5d:	e9 6b f6 ff ff       	jmp    801054cd <alltraps>

80105e62 <vector137>:
.globl vector137
vector137:
  pushl $0
80105e62:	6a 00                	push   $0x0
  pushl $137
80105e64:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105e69:	e9 5f f6 ff ff       	jmp    801054cd <alltraps>

80105e6e <vector138>:
.globl vector138
vector138:
  pushl $0
80105e6e:	6a 00                	push   $0x0
  pushl $138
80105e70:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105e75:	e9 53 f6 ff ff       	jmp    801054cd <alltraps>

80105e7a <vector139>:
.globl vector139
vector139:
  pushl $0
80105e7a:	6a 00                	push   $0x0
  pushl $139
80105e7c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105e81:	e9 47 f6 ff ff       	jmp    801054cd <alltraps>

80105e86 <vector140>:
.globl vector140
vector140:
  pushl $0
80105e86:	6a 00                	push   $0x0
  pushl $140
80105e88:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105e8d:	e9 3b f6 ff ff       	jmp    801054cd <alltraps>

80105e92 <vector141>:
.globl vector141
vector141:
  pushl $0
80105e92:	6a 00                	push   $0x0
  pushl $141
80105e94:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105e99:	e9 2f f6 ff ff       	jmp    801054cd <alltraps>

80105e9e <vector142>:
.globl vector142
vector142:
  pushl $0
80105e9e:	6a 00                	push   $0x0
  pushl $142
80105ea0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105ea5:	e9 23 f6 ff ff       	jmp    801054cd <alltraps>

80105eaa <vector143>:
.globl vector143
vector143:
  pushl $0
80105eaa:	6a 00                	push   $0x0
  pushl $143
80105eac:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105eb1:	e9 17 f6 ff ff       	jmp    801054cd <alltraps>

80105eb6 <vector144>:
.globl vector144
vector144:
  pushl $0
80105eb6:	6a 00                	push   $0x0
  pushl $144
80105eb8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105ebd:	e9 0b f6 ff ff       	jmp    801054cd <alltraps>

80105ec2 <vector145>:
.globl vector145
vector145:
  pushl $0
80105ec2:	6a 00                	push   $0x0
  pushl $145
80105ec4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105ec9:	e9 ff f5 ff ff       	jmp    801054cd <alltraps>

80105ece <vector146>:
.globl vector146
vector146:
  pushl $0
80105ece:	6a 00                	push   $0x0
  pushl $146
80105ed0:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105ed5:	e9 f3 f5 ff ff       	jmp    801054cd <alltraps>

80105eda <vector147>:
.globl vector147
vector147:
  pushl $0
80105eda:	6a 00                	push   $0x0
  pushl $147
80105edc:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105ee1:	e9 e7 f5 ff ff       	jmp    801054cd <alltraps>

80105ee6 <vector148>:
.globl vector148
vector148:
  pushl $0
80105ee6:	6a 00                	push   $0x0
  pushl $148
80105ee8:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105eed:	e9 db f5 ff ff       	jmp    801054cd <alltraps>

80105ef2 <vector149>:
.globl vector149
vector149:
  pushl $0
80105ef2:	6a 00                	push   $0x0
  pushl $149
80105ef4:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105ef9:	e9 cf f5 ff ff       	jmp    801054cd <alltraps>

80105efe <vector150>:
.globl vector150
vector150:
  pushl $0
80105efe:	6a 00                	push   $0x0
  pushl $150
80105f00:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105f05:	e9 c3 f5 ff ff       	jmp    801054cd <alltraps>

80105f0a <vector151>:
.globl vector151
vector151:
  pushl $0
80105f0a:	6a 00                	push   $0x0
  pushl $151
80105f0c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105f11:	e9 b7 f5 ff ff       	jmp    801054cd <alltraps>

80105f16 <vector152>:
.globl vector152
vector152:
  pushl $0
80105f16:	6a 00                	push   $0x0
  pushl $152
80105f18:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105f1d:	e9 ab f5 ff ff       	jmp    801054cd <alltraps>

80105f22 <vector153>:
.globl vector153
vector153:
  pushl $0
80105f22:	6a 00                	push   $0x0
  pushl $153
80105f24:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105f29:	e9 9f f5 ff ff       	jmp    801054cd <alltraps>

80105f2e <vector154>:
.globl vector154
vector154:
  pushl $0
80105f2e:	6a 00                	push   $0x0
  pushl $154
80105f30:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105f35:	e9 93 f5 ff ff       	jmp    801054cd <alltraps>

80105f3a <vector155>:
.globl vector155
vector155:
  pushl $0
80105f3a:	6a 00                	push   $0x0
  pushl $155
80105f3c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105f41:	e9 87 f5 ff ff       	jmp    801054cd <alltraps>

80105f46 <vector156>:
.globl vector156
vector156:
  pushl $0
80105f46:	6a 00                	push   $0x0
  pushl $156
80105f48:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105f4d:	e9 7b f5 ff ff       	jmp    801054cd <alltraps>

80105f52 <vector157>:
.globl vector157
vector157:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $157
80105f54:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105f59:	e9 6f f5 ff ff       	jmp    801054cd <alltraps>

80105f5e <vector158>:
.globl vector158
vector158:
  pushl $0
80105f5e:	6a 00                	push   $0x0
  pushl $158
80105f60:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105f65:	e9 63 f5 ff ff       	jmp    801054cd <alltraps>

80105f6a <vector159>:
.globl vector159
vector159:
  pushl $0
80105f6a:	6a 00                	push   $0x0
  pushl $159
80105f6c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105f71:	e9 57 f5 ff ff       	jmp    801054cd <alltraps>

80105f76 <vector160>:
.globl vector160
vector160:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $160
80105f78:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105f7d:	e9 4b f5 ff ff       	jmp    801054cd <alltraps>

80105f82 <vector161>:
.globl vector161
vector161:
  pushl $0
80105f82:	6a 00                	push   $0x0
  pushl $161
80105f84:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105f89:	e9 3f f5 ff ff       	jmp    801054cd <alltraps>

80105f8e <vector162>:
.globl vector162
vector162:
  pushl $0
80105f8e:	6a 00                	push   $0x0
  pushl $162
80105f90:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105f95:	e9 33 f5 ff ff       	jmp    801054cd <alltraps>

80105f9a <vector163>:
.globl vector163
vector163:
  pushl $0
80105f9a:	6a 00                	push   $0x0
  pushl $163
80105f9c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105fa1:	e9 27 f5 ff ff       	jmp    801054cd <alltraps>

80105fa6 <vector164>:
.globl vector164
vector164:
  pushl $0
80105fa6:	6a 00                	push   $0x0
  pushl $164
80105fa8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105fad:	e9 1b f5 ff ff       	jmp    801054cd <alltraps>

80105fb2 <vector165>:
.globl vector165
vector165:
  pushl $0
80105fb2:	6a 00                	push   $0x0
  pushl $165
80105fb4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105fb9:	e9 0f f5 ff ff       	jmp    801054cd <alltraps>

80105fbe <vector166>:
.globl vector166
vector166:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $166
80105fc0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105fc5:	e9 03 f5 ff ff       	jmp    801054cd <alltraps>

80105fca <vector167>:
.globl vector167
vector167:
  pushl $0
80105fca:	6a 00                	push   $0x0
  pushl $167
80105fcc:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105fd1:	e9 f7 f4 ff ff       	jmp    801054cd <alltraps>

80105fd6 <vector168>:
.globl vector168
vector168:
  pushl $0
80105fd6:	6a 00                	push   $0x0
  pushl $168
80105fd8:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105fdd:	e9 eb f4 ff ff       	jmp    801054cd <alltraps>

80105fe2 <vector169>:
.globl vector169
vector169:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $169
80105fe4:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105fe9:	e9 df f4 ff ff       	jmp    801054cd <alltraps>

80105fee <vector170>:
.globl vector170
vector170:
  pushl $0
80105fee:	6a 00                	push   $0x0
  pushl $170
80105ff0:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105ff5:	e9 d3 f4 ff ff       	jmp    801054cd <alltraps>

80105ffa <vector171>:
.globl vector171
vector171:
  pushl $0
80105ffa:	6a 00                	push   $0x0
  pushl $171
80105ffc:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106001:	e9 c7 f4 ff ff       	jmp    801054cd <alltraps>

80106006 <vector172>:
.globl vector172
vector172:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $172
80106008:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010600d:	e9 bb f4 ff ff       	jmp    801054cd <alltraps>

80106012 <vector173>:
.globl vector173
vector173:
  pushl $0
80106012:	6a 00                	push   $0x0
  pushl $173
80106014:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106019:	e9 af f4 ff ff       	jmp    801054cd <alltraps>

8010601e <vector174>:
.globl vector174
vector174:
  pushl $0
8010601e:	6a 00                	push   $0x0
  pushl $174
80106020:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106025:	e9 a3 f4 ff ff       	jmp    801054cd <alltraps>

8010602a <vector175>:
.globl vector175
vector175:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $175
8010602c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106031:	e9 97 f4 ff ff       	jmp    801054cd <alltraps>

80106036 <vector176>:
.globl vector176
vector176:
  pushl $0
80106036:	6a 00                	push   $0x0
  pushl $176
80106038:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010603d:	e9 8b f4 ff ff       	jmp    801054cd <alltraps>

80106042 <vector177>:
.globl vector177
vector177:
  pushl $0
80106042:	6a 00                	push   $0x0
  pushl $177
80106044:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106049:	e9 7f f4 ff ff       	jmp    801054cd <alltraps>

8010604e <vector178>:
.globl vector178
vector178:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $178
80106050:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106055:	e9 73 f4 ff ff       	jmp    801054cd <alltraps>

8010605a <vector179>:
.globl vector179
vector179:
  pushl $0
8010605a:	6a 00                	push   $0x0
  pushl $179
8010605c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106061:	e9 67 f4 ff ff       	jmp    801054cd <alltraps>

80106066 <vector180>:
.globl vector180
vector180:
  pushl $0
80106066:	6a 00                	push   $0x0
  pushl $180
80106068:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010606d:	e9 5b f4 ff ff       	jmp    801054cd <alltraps>

80106072 <vector181>:
.globl vector181
vector181:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $181
80106074:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106079:	e9 4f f4 ff ff       	jmp    801054cd <alltraps>

8010607e <vector182>:
.globl vector182
vector182:
  pushl $0
8010607e:	6a 00                	push   $0x0
  pushl $182
80106080:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106085:	e9 43 f4 ff ff       	jmp    801054cd <alltraps>

8010608a <vector183>:
.globl vector183
vector183:
  pushl $0
8010608a:	6a 00                	push   $0x0
  pushl $183
8010608c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106091:	e9 37 f4 ff ff       	jmp    801054cd <alltraps>

80106096 <vector184>:
.globl vector184
vector184:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $184
80106098:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010609d:	e9 2b f4 ff ff       	jmp    801054cd <alltraps>

801060a2 <vector185>:
.globl vector185
vector185:
  pushl $0
801060a2:	6a 00                	push   $0x0
  pushl $185
801060a4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801060a9:	e9 1f f4 ff ff       	jmp    801054cd <alltraps>

801060ae <vector186>:
.globl vector186
vector186:
  pushl $0
801060ae:	6a 00                	push   $0x0
  pushl $186
801060b0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801060b5:	e9 13 f4 ff ff       	jmp    801054cd <alltraps>

801060ba <vector187>:
.globl vector187
vector187:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $187
801060bc:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801060c1:	e9 07 f4 ff ff       	jmp    801054cd <alltraps>

801060c6 <vector188>:
.globl vector188
vector188:
  pushl $0
801060c6:	6a 00                	push   $0x0
  pushl $188
801060c8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801060cd:	e9 fb f3 ff ff       	jmp    801054cd <alltraps>

801060d2 <vector189>:
.globl vector189
vector189:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $189
801060d4:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801060d9:	e9 ef f3 ff ff       	jmp    801054cd <alltraps>

801060de <vector190>:
.globl vector190
vector190:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $190
801060e0:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801060e5:	e9 e3 f3 ff ff       	jmp    801054cd <alltraps>

801060ea <vector191>:
.globl vector191
vector191:
  pushl $0
801060ea:	6a 00                	push   $0x0
  pushl $191
801060ec:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801060f1:	e9 d7 f3 ff ff       	jmp    801054cd <alltraps>

801060f6 <vector192>:
.globl vector192
vector192:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $192
801060f8:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801060fd:	e9 cb f3 ff ff       	jmp    801054cd <alltraps>

80106102 <vector193>:
.globl vector193
vector193:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $193
80106104:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106109:	e9 bf f3 ff ff       	jmp    801054cd <alltraps>

8010610e <vector194>:
.globl vector194
vector194:
  pushl $0
8010610e:	6a 00                	push   $0x0
  pushl $194
80106110:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106115:	e9 b3 f3 ff ff       	jmp    801054cd <alltraps>

8010611a <vector195>:
.globl vector195
vector195:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $195
8010611c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106121:	e9 a7 f3 ff ff       	jmp    801054cd <alltraps>

80106126 <vector196>:
.globl vector196
vector196:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $196
80106128:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010612d:	e9 9b f3 ff ff       	jmp    801054cd <alltraps>

80106132 <vector197>:
.globl vector197
vector197:
  pushl $0
80106132:	6a 00                	push   $0x0
  pushl $197
80106134:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106139:	e9 8f f3 ff ff       	jmp    801054cd <alltraps>

8010613e <vector198>:
.globl vector198
vector198:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $198
80106140:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106145:	e9 83 f3 ff ff       	jmp    801054cd <alltraps>

8010614a <vector199>:
.globl vector199
vector199:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $199
8010614c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106151:	e9 77 f3 ff ff       	jmp    801054cd <alltraps>

80106156 <vector200>:
.globl vector200
vector200:
  pushl $0
80106156:	6a 00                	push   $0x0
  pushl $200
80106158:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010615d:	e9 6b f3 ff ff       	jmp    801054cd <alltraps>

80106162 <vector201>:
.globl vector201
vector201:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $201
80106164:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106169:	e9 5f f3 ff ff       	jmp    801054cd <alltraps>

8010616e <vector202>:
.globl vector202
vector202:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $202
80106170:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106175:	e9 53 f3 ff ff       	jmp    801054cd <alltraps>

8010617a <vector203>:
.globl vector203
vector203:
  pushl $0
8010617a:	6a 00                	push   $0x0
  pushl $203
8010617c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106181:	e9 47 f3 ff ff       	jmp    801054cd <alltraps>

80106186 <vector204>:
.globl vector204
vector204:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $204
80106188:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010618d:	e9 3b f3 ff ff       	jmp    801054cd <alltraps>

80106192 <vector205>:
.globl vector205
vector205:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $205
80106194:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106199:	e9 2f f3 ff ff       	jmp    801054cd <alltraps>

8010619e <vector206>:
.globl vector206
vector206:
  pushl $0
8010619e:	6a 00                	push   $0x0
  pushl $206
801061a0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801061a5:	e9 23 f3 ff ff       	jmp    801054cd <alltraps>

801061aa <vector207>:
.globl vector207
vector207:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $207
801061ac:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801061b1:	e9 17 f3 ff ff       	jmp    801054cd <alltraps>

801061b6 <vector208>:
.globl vector208
vector208:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $208
801061b8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801061bd:	e9 0b f3 ff ff       	jmp    801054cd <alltraps>

801061c2 <vector209>:
.globl vector209
vector209:
  pushl $0
801061c2:	6a 00                	push   $0x0
  pushl $209
801061c4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801061c9:	e9 ff f2 ff ff       	jmp    801054cd <alltraps>

801061ce <vector210>:
.globl vector210
vector210:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $210
801061d0:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801061d5:	e9 f3 f2 ff ff       	jmp    801054cd <alltraps>

801061da <vector211>:
.globl vector211
vector211:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $211
801061dc:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801061e1:	e9 e7 f2 ff ff       	jmp    801054cd <alltraps>

801061e6 <vector212>:
.globl vector212
vector212:
  pushl $0
801061e6:	6a 00                	push   $0x0
  pushl $212
801061e8:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801061ed:	e9 db f2 ff ff       	jmp    801054cd <alltraps>

801061f2 <vector213>:
.globl vector213
vector213:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $213
801061f4:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801061f9:	e9 cf f2 ff ff       	jmp    801054cd <alltraps>

801061fe <vector214>:
.globl vector214
vector214:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $214
80106200:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106205:	e9 c3 f2 ff ff       	jmp    801054cd <alltraps>

8010620a <vector215>:
.globl vector215
vector215:
  pushl $0
8010620a:	6a 00                	push   $0x0
  pushl $215
8010620c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106211:	e9 b7 f2 ff ff       	jmp    801054cd <alltraps>

80106216 <vector216>:
.globl vector216
vector216:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $216
80106218:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010621d:	e9 ab f2 ff ff       	jmp    801054cd <alltraps>

80106222 <vector217>:
.globl vector217
vector217:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $217
80106224:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106229:	e9 9f f2 ff ff       	jmp    801054cd <alltraps>

8010622e <vector218>:
.globl vector218
vector218:
  pushl $0
8010622e:	6a 00                	push   $0x0
  pushl $218
80106230:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106235:	e9 93 f2 ff ff       	jmp    801054cd <alltraps>

8010623a <vector219>:
.globl vector219
vector219:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $219
8010623c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106241:	e9 87 f2 ff ff       	jmp    801054cd <alltraps>

80106246 <vector220>:
.globl vector220
vector220:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $220
80106248:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010624d:	e9 7b f2 ff ff       	jmp    801054cd <alltraps>

80106252 <vector221>:
.globl vector221
vector221:
  pushl $0
80106252:	6a 00                	push   $0x0
  pushl $221
80106254:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106259:	e9 6f f2 ff ff       	jmp    801054cd <alltraps>

8010625e <vector222>:
.globl vector222
vector222:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $222
80106260:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106265:	e9 63 f2 ff ff       	jmp    801054cd <alltraps>

8010626a <vector223>:
.globl vector223
vector223:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $223
8010626c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106271:	e9 57 f2 ff ff       	jmp    801054cd <alltraps>

80106276 <vector224>:
.globl vector224
vector224:
  pushl $0
80106276:	6a 00                	push   $0x0
  pushl $224
80106278:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010627d:	e9 4b f2 ff ff       	jmp    801054cd <alltraps>

80106282 <vector225>:
.globl vector225
vector225:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $225
80106284:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106289:	e9 3f f2 ff ff       	jmp    801054cd <alltraps>

8010628e <vector226>:
.globl vector226
vector226:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $226
80106290:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106295:	e9 33 f2 ff ff       	jmp    801054cd <alltraps>

8010629a <vector227>:
.globl vector227
vector227:
  pushl $0
8010629a:	6a 00                	push   $0x0
  pushl $227
8010629c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801062a1:	e9 27 f2 ff ff       	jmp    801054cd <alltraps>

801062a6 <vector228>:
.globl vector228
vector228:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $228
801062a8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801062ad:	e9 1b f2 ff ff       	jmp    801054cd <alltraps>

801062b2 <vector229>:
.globl vector229
vector229:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $229
801062b4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801062b9:	e9 0f f2 ff ff       	jmp    801054cd <alltraps>

801062be <vector230>:
.globl vector230
vector230:
  pushl $0
801062be:	6a 00                	push   $0x0
  pushl $230
801062c0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801062c5:	e9 03 f2 ff ff       	jmp    801054cd <alltraps>

801062ca <vector231>:
.globl vector231
vector231:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $231
801062cc:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801062d1:	e9 f7 f1 ff ff       	jmp    801054cd <alltraps>

801062d6 <vector232>:
.globl vector232
vector232:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $232
801062d8:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801062dd:	e9 eb f1 ff ff       	jmp    801054cd <alltraps>

801062e2 <vector233>:
.globl vector233
vector233:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $233
801062e4:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801062e9:	e9 df f1 ff ff       	jmp    801054cd <alltraps>

801062ee <vector234>:
.globl vector234
vector234:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $234
801062f0:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801062f5:	e9 d3 f1 ff ff       	jmp    801054cd <alltraps>

801062fa <vector235>:
.globl vector235
vector235:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $235
801062fc:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106301:	e9 c7 f1 ff ff       	jmp    801054cd <alltraps>

80106306 <vector236>:
.globl vector236
vector236:
  pushl $0
80106306:	6a 00                	push   $0x0
  pushl $236
80106308:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010630d:	e9 bb f1 ff ff       	jmp    801054cd <alltraps>

80106312 <vector237>:
.globl vector237
vector237:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $237
80106314:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106319:	e9 af f1 ff ff       	jmp    801054cd <alltraps>

8010631e <vector238>:
.globl vector238
vector238:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $238
80106320:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106325:	e9 a3 f1 ff ff       	jmp    801054cd <alltraps>

8010632a <vector239>:
.globl vector239
vector239:
  pushl $0
8010632a:	6a 00                	push   $0x0
  pushl $239
8010632c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106331:	e9 97 f1 ff ff       	jmp    801054cd <alltraps>

80106336 <vector240>:
.globl vector240
vector240:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $240
80106338:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010633d:	e9 8b f1 ff ff       	jmp    801054cd <alltraps>

80106342 <vector241>:
.globl vector241
vector241:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $241
80106344:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106349:	e9 7f f1 ff ff       	jmp    801054cd <alltraps>

8010634e <vector242>:
.globl vector242
vector242:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $242
80106350:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106355:	e9 73 f1 ff ff       	jmp    801054cd <alltraps>

8010635a <vector243>:
.globl vector243
vector243:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $243
8010635c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106361:	e9 67 f1 ff ff       	jmp    801054cd <alltraps>

80106366 <vector244>:
.globl vector244
vector244:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $244
80106368:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010636d:	e9 5b f1 ff ff       	jmp    801054cd <alltraps>

80106372 <vector245>:
.globl vector245
vector245:
  pushl $0
80106372:	6a 00                	push   $0x0
  pushl $245
80106374:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106379:	e9 4f f1 ff ff       	jmp    801054cd <alltraps>

8010637e <vector246>:
.globl vector246
vector246:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $246
80106380:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106385:	e9 43 f1 ff ff       	jmp    801054cd <alltraps>

8010638a <vector247>:
.globl vector247
vector247:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $247
8010638c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106391:	e9 37 f1 ff ff       	jmp    801054cd <alltraps>

80106396 <vector248>:
.globl vector248
vector248:
  pushl $0
80106396:	6a 00                	push   $0x0
  pushl $248
80106398:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010639d:	e9 2b f1 ff ff       	jmp    801054cd <alltraps>

801063a2 <vector249>:
.globl vector249
vector249:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $249
801063a4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801063a9:	e9 1f f1 ff ff       	jmp    801054cd <alltraps>

801063ae <vector250>:
.globl vector250
vector250:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $250
801063b0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801063b5:	e9 13 f1 ff ff       	jmp    801054cd <alltraps>

801063ba <vector251>:
.globl vector251
vector251:
  pushl $0
801063ba:	6a 00                	push   $0x0
  pushl $251
801063bc:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801063c1:	e9 07 f1 ff ff       	jmp    801054cd <alltraps>

801063c6 <vector252>:
.globl vector252
vector252:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $252
801063c8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801063cd:	e9 fb f0 ff ff       	jmp    801054cd <alltraps>

801063d2 <vector253>:
.globl vector253
vector253:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $253
801063d4:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801063d9:	e9 ef f0 ff ff       	jmp    801054cd <alltraps>

801063de <vector254>:
.globl vector254
vector254:
  pushl $0
801063de:	6a 00                	push   $0x0
  pushl $254
801063e0:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801063e5:	e9 e3 f0 ff ff       	jmp    801054cd <alltraps>

801063ea <vector255>:
.globl vector255
vector255:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $255
801063ec:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801063f1:	e9 d7 f0 ff ff       	jmp    801054cd <alltraps>
801063f6:	66 90                	xchg   %ax,%ax
801063f8:	66 90                	xchg   %ax,%ax
801063fa:	66 90                	xchg   %ax,%ax
801063fc:	66 90                	xchg   %ax,%ax
801063fe:	66 90                	xchg   %ax,%ax

80106400 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106400:	55                   	push   %ebp
80106401:	89 e5                	mov    %esp,%ebp
80106403:	57                   	push   %edi
80106404:	56                   	push   %esi
80106405:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106407:	c1 ea 16             	shr    $0x16,%edx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010640a:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010640b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010640e:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106411:	8b 1f                	mov    (%edi),%ebx
80106413:	f6 c3 01             	test   $0x1,%bl
80106416:	74 28                	je     80106440 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106418:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010641e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106424:	c1 ee 0a             	shr    $0xa,%esi
}
80106427:	83 c4 1c             	add    $0x1c,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010642a:	89 f2                	mov    %esi,%edx
8010642c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106432:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106435:	5b                   	pop    %ebx
80106436:	5e                   	pop    %esi
80106437:	5f                   	pop    %edi
80106438:	5d                   	pop    %ebp
80106439:	c3                   	ret    
8010643a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106440:	85 c9                	test   %ecx,%ecx
80106442:	74 34                	je     80106478 <walkpgdir+0x78>
80106444:	e8 87 c0 ff ff       	call   801024d0 <kalloc>
80106449:	85 c0                	test   %eax,%eax
8010644b:	89 c3                	mov    %eax,%ebx
8010644d:	74 29                	je     80106478 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010644f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106456:	00 
80106457:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010645e:	00 
8010645f:	89 04 24             	mov    %eax,(%esp)
80106462:	e8 09 df ff ff       	call   80104370 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106467:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010646d:	83 c8 07             	or     $0x7,%eax
80106470:	89 07                	mov    %eax,(%edi)
80106472:	eb b0                	jmp    80106424 <walkpgdir+0x24>
80106474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  return &pgtab[PTX(va)];
}
80106478:	83 c4 1c             	add    $0x1c,%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
8010647b:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
8010647d:	5b                   	pop    %ebx
8010647e:	5e                   	pop    %esi
8010647f:	5f                   	pop    %edi
80106480:	5d                   	pop    %ebp
80106481:	c3                   	ret    
80106482:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106490 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106490:	55                   	push   %ebp
80106491:	89 e5                	mov    %esp,%ebp
80106493:	57                   	push   %edi
80106494:	56                   	push   %esi
80106495:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106496:	89 d3                	mov    %edx,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106498:	83 ec 1c             	sub    $0x1c,%esp
8010649b:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010649e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801064a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801064a7:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801064ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801064ae:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801064b2:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
801064b9:	29 df                	sub    %ebx,%edi
801064bb:	eb 18                	jmp    801064d5 <mappages+0x45>
801064bd:	8d 76 00             	lea    0x0(%esi),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801064c0:	f6 00 01             	testb  $0x1,(%eax)
801064c3:	75 3d                	jne    80106502 <mappages+0x72>
      panic("remap");
    *pte = pa | perm | PTE_P;
801064c5:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
801064c8:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801064cb:	89 30                	mov    %esi,(%eax)
    if(a == last)
801064cd:	74 29                	je     801064f8 <mappages+0x68>
      break;
    a += PGSIZE;
801064cf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801064d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801064d8:	b9 01 00 00 00       	mov    $0x1,%ecx
801064dd:	89 da                	mov    %ebx,%edx
801064df:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801064e2:	e8 19 ff ff ff       	call   80106400 <walkpgdir>
801064e7:	85 c0                	test   %eax,%eax
801064e9:	75 d5                	jne    801064c0 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801064eb:	83 c4 1c             	add    $0x1c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
801064ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801064f3:	5b                   	pop    %ebx
801064f4:	5e                   	pop    %esi
801064f5:	5f                   	pop    %edi
801064f6:	5d                   	pop    %ebp
801064f7:	c3                   	ret    
801064f8:	83 c4 1c             	add    $0x1c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801064fb:	31 c0                	xor    %eax,%eax
}
801064fd:	5b                   	pop    %ebx
801064fe:	5e                   	pop    %esi
801064ff:	5f                   	pop    %edi
80106500:	5d                   	pop    %ebp
80106501:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106502:	c7 04 24 c8 75 10 80 	movl   $0x801075c8,(%esp)
80106509:	e8 52 9e ff ff       	call   80100360 <panic>
8010650e:	66 90                	xchg   %ax,%ax

80106510 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106510:	55                   	push   %ebp
80106511:	89 e5                	mov    %esp,%ebp
80106513:	57                   	push   %edi
80106514:	89 c7                	mov    %eax,%edi
80106516:	56                   	push   %esi
80106517:	89 d6                	mov    %edx,%esi
80106519:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010651a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106520:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106523:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106529:	39 d3                	cmp    %edx,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010652b:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010652e:	72 3b                	jb     8010656b <deallocuvm.part.0+0x5b>
80106530:	eb 5e                	jmp    80106590 <deallocuvm.part.0+0x80>
80106532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106538:	8b 10                	mov    (%eax),%edx
8010653a:	f6 c2 01             	test   $0x1,%dl
8010653d:	74 22                	je     80106561 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010653f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106545:	74 54                	je     8010659b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106547:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010654d:	89 14 24             	mov    %edx,(%esp)
80106550:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106553:	e8 c8 bd ff ff       	call   80102320 <kfree>
      *pte = 0;
80106558:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010655b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106561:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106567:	39 f3                	cmp    %esi,%ebx
80106569:	73 25                	jae    80106590 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010656b:	31 c9                	xor    %ecx,%ecx
8010656d:	89 da                	mov    %ebx,%edx
8010656f:	89 f8                	mov    %edi,%eax
80106571:	e8 8a fe ff ff       	call   80106400 <walkpgdir>
    if(!pte)
80106576:	85 c0                	test   %eax,%eax
80106578:	75 be                	jne    80106538 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010657a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106580:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106586:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010658c:	39 f3                	cmp    %esi,%ebx
8010658e:	72 db                	jb     8010656b <deallocuvm.part.0+0x5b>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106590:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106593:	83 c4 1c             	add    $0x1c,%esp
80106596:	5b                   	pop    %ebx
80106597:	5e                   	pop    %esi
80106598:	5f                   	pop    %edi
80106599:	5d                   	pop    %ebp
8010659a:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010659b:	c7 04 24 92 6f 10 80 	movl   $0x80106f92,(%esp)
801065a2:	e8 b9 9d ff ff       	call   80100360 <panic>
801065a7:	89 f6                	mov    %esi,%esi
801065a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065b0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801065b0:	55                   	push   %ebp
801065b1:	89 e5                	mov    %esp,%ebp
801065b3:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801065b6:	e8 d5 c1 ff ff       	call   80102790 <cpunum>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801065bb:	31 c9                	xor    %ecx,%ecx
801065bd:	ba ff ff ff ff       	mov    $0xffffffff,%edx

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801065c2:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801065c8:	05 a0 27 11 80       	add    $0x801127a0,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801065cd:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801065d1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801065d6:	66 89 48 7a          	mov    %cx,0x7a(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801065da:	31 c9                	xor    %ecx,%ecx
801065dc:	66 89 90 80 00 00 00 	mov    %dx,0x80(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801065e3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801065e8:	66 89 88 82 00 00 00 	mov    %cx,0x82(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801065ef:	31 c9                	xor    %ecx,%ecx
801065f1:	66 89 90 90 00 00 00 	mov    %dx,0x90(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801065f8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801065fd:	66 89 88 92 00 00 00 	mov    %cx,0x92(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106604:	31 c9                	xor    %ecx,%ecx
80106606:	66 89 90 98 00 00 00 	mov    %dx,0x98(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010660d:	8d 90 b4 00 00 00    	lea    0xb4(%eax),%edx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106613:	66 89 88 9a 00 00 00 	mov    %cx,0x9a(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010661a:	31 c9                	xor    %ecx,%ecx
8010661c:	66 89 88 88 00 00 00 	mov    %cx,0x88(%eax)
80106623:	89 d1                	mov    %edx,%ecx
80106625:	c1 e9 10             	shr    $0x10,%ecx
80106628:	66 89 90 8a 00 00 00 	mov    %dx,0x8a(%eax)
8010662f:	c1 ea 18             	shr    $0x18,%edx
80106632:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106638:	b9 37 00 00 00       	mov    $0x37,%ecx
8010663d:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80106643:	8d 50 70             	lea    0x70(%eax),%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106646:	c6 40 7d 9a          	movb   $0x9a,0x7d(%eax)
8010664a:	c6 40 7e cf          	movb   $0xcf,0x7e(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010664e:	c6 80 85 00 00 00 92 	movb   $0x92,0x85(%eax)
80106655:	c6 80 86 00 00 00 cf 	movb   $0xcf,0x86(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010665c:	c6 80 95 00 00 00 fa 	movb   $0xfa,0x95(%eax)
80106663:	c6 80 96 00 00 00 cf 	movb   $0xcf,0x96(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010666a:	c6 80 9d 00 00 00 f2 	movb   $0xf2,0x9d(%eax)
80106671:	c6 80 9e 00 00 00 cf 	movb   $0xcf,0x9e(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106678:	c6 80 8d 00 00 00 92 	movb   $0x92,0x8d(%eax)
8010667f:	c6 80 8e 00 00 00 c0 	movb   $0xc0,0x8e(%eax)
80106686:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  pd[1] = (uint)p;
8010668a:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
8010668e:	c1 ea 10             	shr    $0x10,%edx
80106691:	66 89 55 f6          	mov    %dx,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106695:	8d 55 f2             	lea    -0xe(%ebp),%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106698:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010669c:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801066a0:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801066a7:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801066ae:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801066b5:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801066bc:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801066c3:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)
801066ca:	0f 01 12             	lgdtl  (%edx)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
801066cd:	ba 18 00 00 00       	mov    $0x18,%edx
801066d2:	8e ea                	mov    %edx,%gs
  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
801066d4:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801066db:	00 00 00 00 

  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
801066df:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
}
801066e5:	c9                   	leave  
801066e6:	c3                   	ret    
801066e7:	89 f6                	mov    %esi,%esi
801066e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066f0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801066f0:	55                   	push   %ebp
801066f1:	89 e5                	mov    %esp,%ebp
801066f3:	56                   	push   %esi
801066f4:	53                   	push   %ebx
801066f5:	83 ec 10             	sub    $0x10,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801066f8:	e8 d3 bd ff ff       	call   801024d0 <kalloc>
801066fd:	85 c0                	test   %eax,%eax
801066ff:	89 c6                	mov    %eax,%esi
80106701:	74 55                	je     80106758 <setupkvm+0x68>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106703:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010670a:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010670b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106710:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106717:	00 
80106718:	89 04 24             	mov    %eax,(%esp)
8010671b:	e8 50 dc ff ff       	call   80104370 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106720:	8b 53 0c             	mov    0xc(%ebx),%edx
80106723:	8b 43 04             	mov    0x4(%ebx),%eax
80106726:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106729:	89 54 24 04          	mov    %edx,0x4(%esp)
8010672d:	8b 13                	mov    (%ebx),%edx
8010672f:	89 04 24             	mov    %eax,(%esp)
80106732:	29 c1                	sub    %eax,%ecx
80106734:	89 f0                	mov    %esi,%eax
80106736:	e8 55 fd ff ff       	call   80106490 <mappages>
8010673b:	85 c0                	test   %eax,%eax
8010673d:	78 19                	js     80106758 <setupkvm+0x68>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010673f:	83 c3 10             	add    $0x10,%ebx
80106742:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106748:	72 d6                	jb     80106720 <setupkvm+0x30>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
8010674a:	83 c4 10             	add    $0x10,%esp
8010674d:	89 f0                	mov    %esi,%eax
8010674f:	5b                   	pop    %ebx
80106750:	5e                   	pop    %esi
80106751:	5d                   	pop    %ebp
80106752:	c3                   	ret    
80106753:	90                   	nop
80106754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106758:	83 c4 10             	add    $0x10,%esp
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
8010675b:	31 c0                	xor    %eax,%eax
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
8010675d:	5b                   	pop    %ebx
8010675e:	5e                   	pop    %esi
8010675f:	5d                   	pop    %ebp
80106760:	c3                   	ret    
80106761:	eb 0d                	jmp    80106770 <kvmalloc>
80106763:	90                   	nop
80106764:	90                   	nop
80106765:	90                   	nop
80106766:	90                   	nop
80106767:	90                   	nop
80106768:	90                   	nop
80106769:	90                   	nop
8010676a:	90                   	nop
8010676b:	90                   	nop
8010676c:	90                   	nop
8010676d:	90                   	nop
8010676e:	90                   	nop
8010676f:	90                   	nop

80106770 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106770:	55                   	push   %ebp
80106771:	89 e5                	mov    %esp,%ebp
80106773:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106776:	e8 75 ff ff ff       	call   801066f0 <setupkvm>
8010677b:	a3 24 55 11 80       	mov    %eax,0x80115524
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106780:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106785:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
80106788:	c9                   	leave  
80106789:	c3                   	ret    
8010678a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106790 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106790:	a1 24 55 11 80       	mov    0x80115524,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106795:	55                   	push   %ebp
80106796:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106798:	05 00 00 00 80       	add    $0x80000000,%eax
8010679d:	0f 22 d8             	mov    %eax,%cr3
}
801067a0:	5d                   	pop    %ebp
801067a1:	c3                   	ret    
801067a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067b0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801067b0:	55                   	push   %ebp
801067b1:	89 e5                	mov    %esp,%ebp
801067b3:	53                   	push   %ebx
801067b4:	83 ec 14             	sub    $0x14,%esp
801067b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801067ba:	85 db                	test   %ebx,%ebx
801067bc:	0f 84 94 00 00 00    	je     80106856 <switchuvm+0xa6>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801067c2:	8b 43 08             	mov    0x8(%ebx),%eax
801067c5:	85 c0                	test   %eax,%eax
801067c7:	0f 84 a1 00 00 00    	je     8010686e <switchuvm+0xbe>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801067cd:	8b 43 04             	mov    0x4(%ebx),%eax
801067d0:	85 c0                	test   %eax,%eax
801067d2:	0f 84 8a 00 00 00    	je     80106862 <switchuvm+0xb2>
    panic("switchuvm: no pgdir");

  pushcli();
801067d8:	e8 c3 da ff ff       	call   801042a0 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801067dd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801067e3:	b9 67 00 00 00       	mov    $0x67,%ecx
801067e8:	8d 50 08             	lea    0x8(%eax),%edx
801067eb:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
801067f2:	89 d1                	mov    %edx,%ecx
801067f4:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
801067fb:	c1 ea 18             	shr    $0x18,%edx
801067fe:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
80106804:	c1 e9 10             	shr    $0x10,%ecx
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
80106807:	ba 10 00 00 00       	mov    $0x10,%edx
8010680c:	66 89 50 10          	mov    %dx,0x10(%eax)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106810:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80106816:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010681d:	c6 80 a5 00 00 00 89 	movb   $0x89,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106824:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106827:	8d 91 00 10 00 00    	lea    0x1000(%ecx),%edx
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
8010682d:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106832:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106835:	66 89 48 6e          	mov    %cx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106839:	b8 30 00 00 00       	mov    $0x30,%eax
8010683e:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106841:	8b 43 04             	mov    0x4(%ebx),%eax
80106844:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106849:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
8010684c:	83 c4 14             	add    $0x14,%esp
8010684f:	5b                   	pop    %ebx
80106850:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106851:	e9 7a da ff ff       	jmp    801042d0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106856:	c7 04 24 ce 75 10 80 	movl   $0x801075ce,(%esp)
8010685d:	e8 fe 9a ff ff       	call   80100360 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106862:	c7 04 24 f9 75 10 80 	movl   $0x801075f9,(%esp)
80106869:	e8 f2 9a ff ff       	call   80100360 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
8010686e:	c7 04 24 e4 75 10 80 	movl   $0x801075e4,(%esp)
80106875:	e8 e6 9a ff ff       	call   80100360 <panic>
8010687a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106880 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	57                   	push   %edi
80106884:	56                   	push   %esi
80106885:	53                   	push   %ebx
80106886:	83 ec 1c             	sub    $0x1c,%esp
80106889:	8b 75 10             	mov    0x10(%ebp),%esi
8010688c:	8b 45 08             	mov    0x8(%ebp),%eax
8010688f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106892:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106898:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
8010689b:	77 54                	ja     801068f1 <inituvm+0x71>
    panic("inituvm: more than a page");
  mem = kalloc();
8010689d:	e8 2e bc ff ff       	call   801024d0 <kalloc>
  memset(mem, 0, PGSIZE);
801068a2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801068a9:	00 
801068aa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801068b1:	00 
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
801068b2:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801068b4:	89 04 24             	mov    %eax,(%esp)
801068b7:	e8 b4 da ff ff       	call   80104370 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801068bc:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801068c2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801068c7:	89 04 24             	mov    %eax,(%esp)
801068ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068cd:	31 d2                	xor    %edx,%edx
801068cf:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
801068d6:	00 
801068d7:	e8 b4 fb ff ff       	call   80106490 <mappages>
  memmove(mem, init, sz);
801068dc:	89 75 10             	mov    %esi,0x10(%ebp)
801068df:	89 7d 0c             	mov    %edi,0xc(%ebp)
801068e2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801068e5:	83 c4 1c             	add    $0x1c,%esp
801068e8:	5b                   	pop    %ebx
801068e9:	5e                   	pop    %esi
801068ea:	5f                   	pop    %edi
801068eb:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
801068ec:	e9 1f db ff ff       	jmp    80104410 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
801068f1:	c7 04 24 0d 76 10 80 	movl   $0x8010760d,(%esp)
801068f8:	e8 63 9a ff ff       	call   80100360 <panic>
801068fd:	8d 76 00             	lea    0x0(%esi),%esi

80106900 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106900:	55                   	push   %ebp
80106901:	89 e5                	mov    %esp,%ebp
80106903:	57                   	push   %edi
80106904:	56                   	push   %esi
80106905:	53                   	push   %ebx
80106906:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106909:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106910:	0f 85 98 00 00 00    	jne    801069ae <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106916:	8b 75 18             	mov    0x18(%ebp),%esi
80106919:	31 db                	xor    %ebx,%ebx
8010691b:	85 f6                	test   %esi,%esi
8010691d:	75 1a                	jne    80106939 <loaduvm+0x39>
8010691f:	eb 77                	jmp    80106998 <loaduvm+0x98>
80106921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106928:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010692e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106934:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106937:	76 5f                	jbe    80106998 <loaduvm+0x98>
80106939:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010693c:	31 c9                	xor    %ecx,%ecx
8010693e:	8b 45 08             	mov    0x8(%ebp),%eax
80106941:	01 da                	add    %ebx,%edx
80106943:	e8 b8 fa ff ff       	call   80106400 <walkpgdir>
80106948:	85 c0                	test   %eax,%eax
8010694a:	74 56                	je     801069a2 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010694c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
8010694e:	bf 00 10 00 00       	mov    $0x1000,%edi
80106953:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106956:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
8010695b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106961:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106964:	05 00 00 00 80       	add    $0x80000000,%eax
80106969:	89 44 24 04          	mov    %eax,0x4(%esp)
8010696d:	8b 45 10             	mov    0x10(%ebp),%eax
80106970:	01 d9                	add    %ebx,%ecx
80106972:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106976:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010697a:	89 04 24             	mov    %eax,(%esp)
8010697d:	e8 fe af ff ff       	call   80101980 <readi>
80106982:	39 f8                	cmp    %edi,%eax
80106984:	74 a2                	je     80106928 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106986:	83 c4 1c             	add    $0x1c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106989:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
8010698e:	5b                   	pop    %ebx
8010698f:	5e                   	pop    %esi
80106990:	5f                   	pop    %edi
80106991:	5d                   	pop    %ebp
80106992:	c3                   	ret    
80106993:	90                   	nop
80106994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106998:	83 c4 1c             	add    $0x1c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010699b:	31 c0                	xor    %eax,%eax
}
8010699d:	5b                   	pop    %ebx
8010699e:	5e                   	pop    %esi
8010699f:	5f                   	pop    %edi
801069a0:	5d                   	pop    %ebp
801069a1:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
801069a2:	c7 04 24 27 76 10 80 	movl   $0x80107627,(%esp)
801069a9:	e8 b2 99 ff ff       	call   80100360 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
801069ae:	c7 04 24 c8 76 10 80 	movl   $0x801076c8,(%esp)
801069b5:	e8 a6 99 ff ff       	call   80100360 <panic>
801069ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801069c0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	57                   	push   %edi
801069c4:	56                   	push   %esi
801069c5:	53                   	push   %ebx
801069c6:	83 ec 1c             	sub    $0x1c,%esp
801069c9:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801069cc:	85 ff                	test   %edi,%edi
801069ce:	0f 88 7e 00 00 00    	js     80106a52 <allocuvm+0x92>
    return 0;
  if(newsz < oldsz)
801069d4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
801069d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
801069da:	72 78                	jb     80106a54 <allocuvm+0x94>
    return oldsz;

  a = PGROUNDUP(oldsz);
801069dc:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801069e2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801069e8:	39 df                	cmp    %ebx,%edi
801069ea:	77 4a                	ja     80106a36 <allocuvm+0x76>
801069ec:	eb 72                	jmp    80106a60 <allocuvm+0xa0>
801069ee:	66 90                	xchg   %ax,%ax
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
801069f0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801069f7:	00 
801069f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069ff:	00 
80106a00:	89 04 24             	mov    %eax,(%esp)
80106a03:	e8 68 d9 ff ff       	call   80104370 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106a08:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106a0e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a13:	89 04 24             	mov    %eax,(%esp)
80106a16:	8b 45 08             	mov    0x8(%ebp),%eax
80106a19:	89 da                	mov    %ebx,%edx
80106a1b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106a22:	00 
80106a23:	e8 68 fa ff ff       	call   80106490 <mappages>
80106a28:	85 c0                	test   %eax,%eax
80106a2a:	78 44                	js     80106a70 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106a2c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a32:	39 df                	cmp    %ebx,%edi
80106a34:	76 2a                	jbe    80106a60 <allocuvm+0xa0>
    mem = kalloc();
80106a36:	e8 95 ba ff ff       	call   801024d0 <kalloc>
    if(mem == 0){
80106a3b:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106a3d:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106a3f:	75 af                	jne    801069f0 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106a41:	c7 04 24 45 76 10 80 	movl   $0x80107645,(%esp)
80106a48:	e8 03 9c ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106a4d:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106a50:	77 48                	ja     80106a9a <allocuvm+0xda>
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106a52:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106a54:	83 c4 1c             	add    $0x1c,%esp
80106a57:	5b                   	pop    %ebx
80106a58:	5e                   	pop    %esi
80106a59:	5f                   	pop    %edi
80106a5a:	5d                   	pop    %ebp
80106a5b:	c3                   	ret    
80106a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a60:	83 c4 1c             	add    $0x1c,%esp
80106a63:	89 f8                	mov    %edi,%eax
80106a65:	5b                   	pop    %ebx
80106a66:	5e                   	pop    %esi
80106a67:	5f                   	pop    %edi
80106a68:	5d                   	pop    %ebp
80106a69:	c3                   	ret    
80106a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106a70:	c7 04 24 5d 76 10 80 	movl   $0x8010765d,(%esp)
80106a77:	e8 d4 9b ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106a7c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106a7f:	76 0d                	jbe    80106a8e <allocuvm+0xce>
80106a81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106a84:	89 fa                	mov    %edi,%edx
80106a86:	8b 45 08             	mov    0x8(%ebp),%eax
80106a89:	e8 82 fa ff ff       	call   80106510 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106a8e:	89 34 24             	mov    %esi,(%esp)
80106a91:	e8 8a b8 ff ff       	call   80102320 <kfree>
      return 0;
80106a96:	31 c0                	xor    %eax,%eax
80106a98:	eb ba                	jmp    80106a54 <allocuvm+0x94>
80106a9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106a9d:	89 fa                	mov    %edi,%edx
80106a9f:	8b 45 08             	mov    0x8(%ebp),%eax
80106aa2:	e8 69 fa ff ff       	call   80106510 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106aa7:	31 c0                	xor    %eax,%eax
80106aa9:	eb a9                	jmp    80106a54 <allocuvm+0x94>
80106aab:	90                   	nop
80106aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ab0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106ab0:	55                   	push   %ebp
80106ab1:	89 e5                	mov    %esp,%ebp
80106ab3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ab6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106abc:	39 d1                	cmp    %edx,%ecx
80106abe:	73 08                	jae    80106ac8 <deallocuvm+0x18>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106ac0:	5d                   	pop    %ebp
80106ac1:	e9 4a fa ff ff       	jmp    80106510 <deallocuvm.part.0>
80106ac6:	66 90                	xchg   %ax,%ax
80106ac8:	89 d0                	mov    %edx,%eax
80106aca:	5d                   	pop    %ebp
80106acb:	c3                   	ret    
80106acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ad0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	56                   	push   %esi
80106ad4:	53                   	push   %ebx
80106ad5:	83 ec 10             	sub    $0x10,%esp
80106ad8:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106adb:	85 f6                	test   %esi,%esi
80106add:	74 59                	je     80106b38 <freevm+0x68>
80106adf:	31 c9                	xor    %ecx,%ecx
80106ae1:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106ae6:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ae8:	31 db                	xor    %ebx,%ebx
80106aea:	e8 21 fa ff ff       	call   80106510 <deallocuvm.part.0>
80106aef:	eb 12                	jmp    80106b03 <freevm+0x33>
80106af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106af8:	83 c3 01             	add    $0x1,%ebx
80106afb:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106b01:	74 27                	je     80106b2a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106b03:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106b06:	f6 c2 01             	test   $0x1,%dl
80106b09:	74 ed                	je     80106af8 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106b0b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106b11:	83 c3 01             	add    $0x1,%ebx
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106b14:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106b1a:	89 14 24             	mov    %edx,(%esp)
80106b1d:	e8 fe b7 ff ff       	call   80102320 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106b22:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106b28:	75 d9                	jne    80106b03 <freevm+0x33>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106b2a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106b2d:	83 c4 10             	add    $0x10,%esp
80106b30:	5b                   	pop    %ebx
80106b31:	5e                   	pop    %esi
80106b32:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106b33:	e9 e8 b7 ff ff       	jmp    80102320 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106b38:	c7 04 24 79 76 10 80 	movl   $0x80107679,(%esp)
80106b3f:	e8 1c 98 ff ff       	call   80100360 <panic>
80106b44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106b50 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106b50:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106b51:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106b53:	89 e5                	mov    %esp,%ebp
80106b55:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106b58:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b5b:	8b 45 08             	mov    0x8(%ebp),%eax
80106b5e:	e8 9d f8 ff ff       	call   80106400 <walkpgdir>
  if(pte == 0)
80106b63:	85 c0                	test   %eax,%eax
80106b65:	74 05                	je     80106b6c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106b67:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106b6a:	c9                   	leave  
80106b6b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106b6c:	c7 04 24 8a 76 10 80 	movl   $0x8010768a,(%esp)
80106b73:	e8 e8 97 ff ff       	call   80100360 <panic>
80106b78:	90                   	nop
80106b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b80 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106b80:	55                   	push   %ebp
80106b81:	89 e5                	mov    %esp,%ebp
80106b83:	57                   	push   %edi
80106b84:	56                   	push   %esi
80106b85:	53                   	push   %ebx
80106b86:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106b89:	e8 62 fb ff ff       	call   801066f0 <setupkvm>
80106b8e:	85 c0                	test   %eax,%eax
80106b90:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106b93:	0f 84 b2 00 00 00    	je     80106c4b <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106b99:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b9c:	85 c0                	test   %eax,%eax
80106b9e:	0f 84 9c 00 00 00    	je     80106c40 <copyuvm+0xc0>
80106ba4:	31 db                	xor    %ebx,%ebx
80106ba6:	eb 48                	jmp    80106bf0 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106ba8:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106bae:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106bb5:	00 
80106bb6:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106bba:	89 04 24             	mov    %eax,(%esp)
80106bbd:	e8 4e d8 ff ff       	call   80104410 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106bc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bc5:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106bcb:	89 14 24             	mov    %edx,(%esp)
80106bce:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106bd3:	89 da                	mov    %ebx,%edx
80106bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106bdc:	e8 af f8 ff ff       	call   80106490 <mappages>
80106be1:	85 c0                	test   %eax,%eax
80106be3:	78 41                	js     80106c26 <copyuvm+0xa6>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106be5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106beb:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106bee:	76 50                	jbe    80106c40 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106bf0:	8b 45 08             	mov    0x8(%ebp),%eax
80106bf3:	31 c9                	xor    %ecx,%ecx
80106bf5:	89 da                	mov    %ebx,%edx
80106bf7:	e8 04 f8 ff ff       	call   80106400 <walkpgdir>
80106bfc:	85 c0                	test   %eax,%eax
80106bfe:	74 5b                	je     80106c5b <copyuvm+0xdb>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106c00:	8b 30                	mov    (%eax),%esi
80106c02:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106c08:	74 45                	je     80106c4f <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106c0a:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106c0c:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106c12:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106c15:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106c1b:	e8 b0 b8 ff ff       	call   801024d0 <kalloc>
80106c20:	85 c0                	test   %eax,%eax
80106c22:	89 c6                	mov    %eax,%esi
80106c24:	75 82                	jne    80106ba8 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106c26:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c29:	89 04 24             	mov    %eax,(%esp)
80106c2c:	e8 9f fe ff ff       	call   80106ad0 <freevm>
  return 0;
80106c31:	31 c0                	xor    %eax,%eax
}
80106c33:	83 c4 2c             	add    $0x2c,%esp
80106c36:	5b                   	pop    %ebx
80106c37:	5e                   	pop    %esi
80106c38:	5f                   	pop    %edi
80106c39:	5d                   	pop    %ebp
80106c3a:	c3                   	ret    
80106c3b:	90                   	nop
80106c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c40:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c43:	83 c4 2c             	add    $0x2c,%esp
80106c46:	5b                   	pop    %ebx
80106c47:	5e                   	pop    %esi
80106c48:	5f                   	pop    %edi
80106c49:	5d                   	pop    %ebp
80106c4a:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106c4b:	31 c0                	xor    %eax,%eax
80106c4d:	eb e4                	jmp    80106c33 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106c4f:	c7 04 24 ae 76 10 80 	movl   $0x801076ae,(%esp)
80106c56:	e8 05 97 ff ff       	call   80100360 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106c5b:	c7 04 24 94 76 10 80 	movl   $0x80107694,(%esp)
80106c62:	e8 f9 96 ff ff       	call   80100360 <panic>
80106c67:	89 f6                	mov    %esi,%esi
80106c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c70 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106c70:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c71:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106c73:	89 e5                	mov    %esp,%ebp
80106c75:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c78:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c7b:	8b 45 08             	mov    0x8(%ebp),%eax
80106c7e:	e8 7d f7 ff ff       	call   80106400 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106c83:	8b 00                	mov    (%eax),%eax
80106c85:	89 c2                	mov    %eax,%edx
80106c87:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106c8a:	83 fa 05             	cmp    $0x5,%edx
80106c8d:	75 11                	jne    80106ca0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106c8f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c94:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106c99:	c9                   	leave  
80106c9a:	c3                   	ret    
80106c9b:	90                   	nop
80106c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106ca0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106ca2:	c9                   	leave  
80106ca3:	c3                   	ret    
80106ca4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106caa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106cb0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106cb0:	55                   	push   %ebp
80106cb1:	89 e5                	mov    %esp,%ebp
80106cb3:	57                   	push   %edi
80106cb4:	56                   	push   %esi
80106cb5:	53                   	push   %ebx
80106cb6:	83 ec 1c             	sub    $0x1c,%esp
80106cb9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106cbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106cbf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106cc2:	85 db                	test   %ebx,%ebx
80106cc4:	75 3a                	jne    80106d00 <copyout+0x50>
80106cc6:	eb 68                	jmp    80106d30 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106cc8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ccb:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106ccd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106cd1:	29 ca                	sub    %ecx,%edx
80106cd3:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106cd9:	39 da                	cmp    %ebx,%edx
80106cdb:	0f 47 d3             	cmova  %ebx,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106cde:	29 f1                	sub    %esi,%ecx
80106ce0:	01 c8                	add    %ecx,%eax
80106ce2:	89 54 24 08          	mov    %edx,0x8(%esp)
80106ce6:	89 04 24             	mov    %eax,(%esp)
80106ce9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106cec:	e8 1f d7 ff ff       	call   80104410 <memmove>
    len -= n;
    buf += n;
80106cf1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106cf4:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106cfa:	01 d7                	add    %edx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106cfc:	29 d3                	sub    %edx,%ebx
80106cfe:	74 30                	je     80106d30 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
80106d00:	8b 45 08             	mov    0x8(%ebp),%eax
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106d03:	89 ce                	mov    %ecx,%esi
80106d05:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106d0b:	89 74 24 04          	mov    %esi,0x4(%esp)
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106d0f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106d12:	89 04 24             	mov    %eax,(%esp)
80106d15:	e8 56 ff ff ff       	call   80106c70 <uva2ka>
    if(pa0 == 0)
80106d1a:	85 c0                	test   %eax,%eax
80106d1c:	75 aa                	jne    80106cc8 <copyout+0x18>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106d1e:	83 c4 1c             	add    $0x1c,%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106d21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106d26:	5b                   	pop    %ebx
80106d27:	5e                   	pop    %esi
80106d28:	5f                   	pop    %edi
80106d29:	5d                   	pop    %ebp
80106d2a:	c3                   	ret    
80106d2b:	90                   	nop
80106d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d30:	83 c4 1c             	add    $0x1c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106d33:	31 c0                	xor    %eax,%eax
}
80106d35:	5b                   	pop    %ebx
80106d36:	5e                   	pop    %esi
80106d37:	5f                   	pop    %edi
80106d38:	5d                   	pop    %ebp
80106d39:	c3                   	ret    
