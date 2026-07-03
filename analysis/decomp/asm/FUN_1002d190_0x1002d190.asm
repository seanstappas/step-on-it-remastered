; FUN_1002d190 @ 0x1002d190  (81 instructions)
1002d190  7c0802a6    mfspr r0,LR                 
1002d194  bf41ffe8    stmw r26,-0x18(r1)             ; -> Stack[-0x18]
1002d198  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002d19c  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1002d1a0  7c7e1b78    or r30,r3,r3                
1002d1a4  7c9f2378    or r31,r4,r4                
1002d1a8  7cba2b78    or r26,r5,r5                
1002d1ac  3ba26bf8    addi r29,r2,0x6bf8          
1002d1b0  7fc3f378    or r3,r30,r30               
1002d1b4  480014f9    bl 0x1002e6ac                  ; -> 1002e6ac
1002d1b8  60000000    ori r0,r0,0x0               
1002d1bc  7c7c1b78    or r28,r3,r3                
1002d1c0  7fe3fb78    or r3,r31,r31               
1002d1c4  480014f9    bl 0x1002e6bc                  ; -> 1002e6bc
1002d1c8  60000000    ori r0,r0,0x0               
1002d1cc  7c7b1b78    or r27,r3,r3                
1002d1d0  7fc30734    extsh r3,r30                
1002d1d4  7fe40734    extsh r4,r31                
1002d1d8  1c63003c    mulli r3,r3,0x3c            
1002d1dc  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
1002d1e0  7c632214    add r3,r3,r4                
1002d1e4  7c7d182e    lwzx r3,r29,r3              
1002d1e8  546305ee    rlwinm r3,r3,0x0,0x17,0x17  
1002d1ec  2c030000    cmpwi r3,0x0                
1002d1f0  408200d0    bne 0x1002d2c0                 ; -> 1002d2c0
1002d1f4  7fc50734    extsh r5,r30                
1002d1f8  7fe60734    extsh r6,r31                
1002d1fc  1ca5003c    mulli r5,r5,0x3c            
1002d200  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
1002d204  7ca53214    add r5,r5,r6                
1002d208  7cbd282e    lwzx r5,r29,r5              
1002d20c  54a5063e    rlwinm r5,r5,0x0,0x18,0x1f  
1002d210  2c050000    cmpwi r5,0x0                
1002d214  40820094    bne 0x1002d2a8                 ; -> 1002d2a8
1002d218  7fc3f378    or r3,r30,r30               
1002d21c  7fe4fb78    or r4,r31,r31               
1002d220  4bfd7431    bl 0x10004650                  ; -> 10004650
1002d224  60000000    ori r0,r0,0x0               
1002d228  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002d22c  28030000    cmplwi r3,0x0               
1002d230  41820090    beq 0x1002d2c0                 ; -> 1002d2c0
1002d234  38600004    li r3,0x4                   
1002d238  38800007    li r4,0x7                   
1002d23c  4bffdde5    bl 0x1002b020                  ; -> 1002b020
1002d240  7f480734    extsh r8,r26                
1002d244  7fcb0734    extsh r11,r30               
1002d248  38e26840    addi r7,r2,0x6840           
1002d24c  7f4a0734    extsh r10,r26               
1002d250  7fec0734    extsh r12,r31               
1002d254  39226840    addi r9,r2,0x6840           
1002d258  1d080070    mulli r8,r8,0x70            
1002d25c  38e70036    addi r7,r7,0x36             
1002d260  7ce742ae    lhax r7,r7,r8               
1002d264  1d6b003c    mulli r11,r11,0x3c          
1002d268  558c103a    rlwinm r12,r12,0x2,0x0,0x1d 
1002d26c  7d6b6214    add r11,r11,r12             
1002d270  3d00ffff    lis r8,-0x1                 
1002d274  1d4a0070    mulli r10,r10,0x70          
1002d278  39290036    addi r9,r9,0x36             
1002d27c  7d7d582e    lwzx r11,r29,r11            
1002d280  39081000    addi r8,r8,0x1000           
1002d284  7d2952ae    lhax r9,r9,r10              
1002d288  54e6063e    rlwinm r6,r7,0x0,0x18,0x1f  
1002d28c  7d6b4038    and r11,r11,r8              
1002d290  7f83e378    or r3,r28,r28               
1002d294  7f64db78    or r4,r27,r27               
1002d298  38a00001    li r5,0x1                   
1002d29c  7ce95a14    add r7,r9,r11               
1002d2a0  4bffa2ad    bl 0x1002754c                  ; -> 1002754c
1002d2a4  4800001c    b 0x1002d2c0                   ; -> 1002d2c0
1002d2a8  38600003    li r3,0x3                   
1002d2ac  38800007    li r4,0x7                   
1002d2b0  4bffdd71    bl 0x1002b020                  ; -> 1002b020
1002d2b4  7fc3f378    or r3,r30,r30               
1002d2b8  7fe4fb78    or r4,r31,r31               
1002d2bc  4bffa709    bl 0x100279c4                  ; -> 100279c4
1002d2c0  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1002d2c4  38210050    addi r1,r1,0x50             
1002d2c8  7c0803a6    mtspr LR,r0                 
1002d2cc  bb41ffe8    lmw r26,-0x18(r1)              ; -> Stack[-0x18]
1002d2d0  4e800020    blr                         
