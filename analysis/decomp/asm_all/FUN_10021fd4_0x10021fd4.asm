; FUN_10021fd4 @ 0x10021fd4
10021fd4  7c0802a6    mfspr r0,LR                 
10021fd8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10021fdc  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10021fe0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10021fe4  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10021fe8  7c7e1b78    or r30,r3,r3                
10021fec  7fc30734    extsh r3,r30                
10021ff0  1c630014    mulli r3,r3,0x14            
10021ff4  3be2539c    addi r31,r2,0x539c          
10021ff8  3863000c    addi r3,r3,0xc              
10021ffc  7c7f182e    lwzx r3,r31,r3              
10022000  28030000    cmplwi r3,0x0               
10022004  408200f8    bne 0x100220fc                 ; -> 100220fc
10022008  7fc40734    extsh r4,r30                
1002200c  1c840014    mulli r4,r4,0x14            
10022010  3884000a    addi r4,r4,0xa              
10022014  7c7f22ae    lhax r3,r31,r4              
10022018  4800fc89    bl 0x10031ca0                  ; -> 10031ca0
1002201c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
10022020  7fc50734    extsh r5,r30                
10022024  1ca50014    mulli r5,r5,0x14            
10022028  7fc60734    extsh r6,r30                
1002202c  1cc60014    mulli r6,r6,0x14            
10022030  38a5000c    addi r5,r5,0xc              
10022034  7c7f292e    stwx r3,r31,r5              
10022038  38c6000a    addi r6,r6,0xa              
1002203c  7cdf32ae    lhax r6,r31,r6              
10022040  38660001    addi r3,r6,0x1              
10022044  4800fc5d    bl 0x10031ca0                  ; -> 10031ca0
10022048  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
1002204c  7fc70734    extsh r7,r30                
10022050  1ce70014    mulli r7,r7,0x14            
10022054  7fc80734    extsh r8,r30                
10022058  7fca0734    extsh r10,r30               
1002205c  38e70010    addi r7,r7,0x10             
10022060  7c7f392e    stwx r3,r31,r7              
10022064  1d080014    mulli r8,r8,0x14            
10022068  1d4a0014    mulli r10,r10,0x14          
1002206c  7d3f42ae    lhax r9,r31,r8              
10022070  7fc30734    extsh r3,r30                
10022074  39290002    addi r9,r9,0x2              
10022078  1c630014    mulli r3,r3,0x14            
1002207c  7fcc0734    extsh r12,r30               
10022080  7fc40734    extsh r4,r30                
10022084  1c840014    mulli r4,r4,0x14            
10022088  7fc60734    extsh r6,r30                
1002208c  1cc60014    mulli r6,r6,0x14            
10022090  7fc50734    extsh r5,r30                
10022094  1ca50014    mulli r5,r5,0x14            
10022098  7fc70734    extsh r7,r30                
1002209c  1ce70014    mulli r7,r7,0x14            
100220a0  7d3f432e    sthx r9,r31,r8              
100220a4  394a0002    addi r10,r10,0x2            
100220a8  7d7f52ae    lhax r11,r31,r10            
100220ac  1d8c0014    mulli r12,r12,0x14          
100220b0  396bfff8    subi r11,r11,0x8            
100220b4  7d7f532e    sthx r11,r31,r10            
100220b8  3863000c    addi r3,r3,0xc              
100220bc  7c7f182e    lwzx r3,r31,r3              
100220c0  7d9f62ae    lhax r12,r31,r12            
100220c4  80630000    lwz r3,0x0(r3)              
100220c8  38840004    addi r4,r4,0x4              
100220cc  a863000c    lha r3,0xc(r3)              
100220d0  38c6000c    addi r6,r6,0xc              
100220d4  7d8c1a14    add r12,r12,r3              
100220d8  7d9f232e    sthx r12,r31,r4             
100220dc  7cdf302e    lwzx r6,r31,r6              
100220e0  38a50002    addi r5,r5,0x2              
100220e4  80c60000    lwz r6,0x0(r6)              
100220e8  7cbf2aae    lhax r5,r31,r5              
100220ec  a8c6000a    lha r6,0xa(r6)              
100220f0  38e70006    addi r7,r7,0x6              
100220f4  7ca53214    add r5,r5,r6                
100220f8  7cbf3b2e    sthx r5,r31,r7              
100220fc  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10022100  38210040    addi r1,r1,0x40             
10022104  7c0803a6    mtspr LR,r0                 
10022108  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002210c  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10022110  4e800020    blr                         
