; FUN_1000cafc @ 0x1000cafc
1000cafc  7c0802a6    mfspr r0,LR                 
1000cb00  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
1000cb04  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000cb08  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000cb0c  90610068    stw r3,0x68(r1)                ; -> Stack[0x18]
1000cb10  9081006c    stw r4,0x6c(r1)                ; -> Stack[0x1c]
1000cb14  3b626bf8    addi r27,r2,0x6bf8          
1000cb18  3b800000    li r28,0x0                  
1000cb1c  3ba00000    li r29,0x0                  
1000cb20  4800006c    b 0x1000cb8c                   ; -> 1000cb8c
1000cb24  38600013    li r3,0x13                  
1000cb28  480000b9    bl 0x1000cbe0                  ; -> 1000cbe0
1000cb2c  60000000    ori r0,r0,0x0               
1000cb30  7c7f1b78    or r31,r3,r3                
1000cb34  3860000d    li r3,0xd                   
1000cb38  480000a9    bl 0x1000cbe0                  ; -> 1000cbe0
1000cb3c  60000000    ori r0,r0,0x0               
1000cb40  7c7e1b78    or r30,r3,r3                
1000cb44  7fe30734    extsh r3,r31                
1000cb48  7fc40734    extsh r4,r30                
1000cb4c  1c63003c    mulli r3,r3,0x3c            
1000cb50  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
1000cb54  7c632214    add r3,r3,r4                
1000cb58  7c7b182e    lwzx r3,r27,r3              
1000cb5c  2c030000    cmpwi r3,0x0                
1000cb60  40820028    bne 0x1000cb88                 ; -> 1000cb88
1000cb64  7fe3fb78    or r3,r31,r31               
1000cb68  7fc4f378    or r4,r30,r30               
1000cb6c  480000e5    bl 0x1000cc50                  ; -> 1000cc50
1000cb70  60000000    ori r0,r0,0x0               
1000cb74  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000cb78  28030000    cmplwi r3,0x0               
1000cb7c  4182000c    beq 0x1000cb88                 ; -> 1000cb88
1000cb80  3ba00001    li r29,0x1                  
1000cb84  48000008    b 0x1000cb8c                   ; -> 1000cb8c
1000cb88  3b9c0001    addi r28,r28,0x1            
1000cb8c  57a5063e    rlwinm r5,r29,0x0,0x18,0x1f 
1000cb90  28050000    cmplwi r5,0x0               
1000cb94  40820010    bne 0x1000cba4                 ; -> 1000cba4
1000cb98  7f860734    extsh r6,r28                
1000cb9c  2c06000a    cmpwi r6,0xa                
1000cba0  4180ff84    blt 0x1000cb24                 ; -> 1000cb24
1000cba4  57a7063e    rlwinm r7,r29,0x0,0x18,0x1f 
1000cba8  28070000    cmplwi r7,0x0               
1000cbac  4182001c    beq 0x1000cbc8                 ; -> 1000cbc8
1000cbb0  81010068    lwz r8,0x68(r1)                ; -> Stack[0x18]
1000cbb4  8121006c    lwz r9,0x6c(r1)                ; -> Stack[0x1c]
1000cbb8  b3e80000    sth r31,0x0(r8)             
1000cbbc  b3c90000    sth r30,0x0(r9)             
1000cbc0  38600001    li r3,0x1                   
1000cbc4  48000008    b 0x1000cbcc                   ; -> 1000cbcc
1000cbc8  38600000    li r3,0x0                   
1000cbcc  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000cbd0  38210050    addi r1,r1,0x50             
1000cbd4  7c0803a6    mtspr LR,r0                 
1000cbd8  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
1000cbdc  4e800020    blr                         
