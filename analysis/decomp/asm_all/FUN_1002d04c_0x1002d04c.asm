; FUN_1002d04c @ 0x1002d04c
1002d04c  7c0802a6    mfspr r0,LR                 
1002d050  bf41ffe8    stmw r26,-0x18(r1)             ; -> Stack[-0x18]
1002d054  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002d058  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1002d05c  7c7e1b78    or r30,r3,r3                
1002d060  7c9f2378    or r31,r4,r4                
1002d064  7cba2b78    or r26,r5,r5                
1002d068  3ba26bf8    addi r29,r2,0x6bf8          
1002d06c  7fc3f378    or r3,r30,r30               
1002d070  4800163d    bl 0x1002e6ac                  ; -> 1002e6ac
1002d074  60000000    ori r0,r0,0x0               
1002d078  7c7c1b78    or r28,r3,r3                
1002d07c  7fe3fb78    or r3,r31,r31               
1002d080  4800163d    bl 0x1002e6bc                  ; -> 1002e6bc
1002d084  60000000    ori r0,r0,0x0               
1002d088  7c7b1b78    or r27,r3,r3                
1002d08c  7fc30734    extsh r3,r30                
1002d090  7fe40734    extsh r4,r31                
1002d094  1c63003c    mulli r3,r3,0x3c            
1002d098  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
1002d09c  7c632214    add r3,r3,r4                
1002d0a0  7c7d182e    lwzx r3,r29,r3              
1002d0a4  546305ee    rlwinm r3,r3,0x0,0x17,0x17  
1002d0a8  2c030000    cmpwi r3,0x0                
1002d0ac  408200d0    bne 0x1002d17c                 ; -> 1002d17c
1002d0b0  7fc50734    extsh r5,r30                
1002d0b4  7fe60734    extsh r6,r31                
1002d0b8  1ca5003c    mulli r5,r5,0x3c            
1002d0bc  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
1002d0c0  7ca53214    add r5,r5,r6                
1002d0c4  7cbd282e    lwzx r5,r29,r5              
1002d0c8  54a5063e    rlwinm r5,r5,0x0,0x18,0x1f  
1002d0cc  2c050000    cmpwi r5,0x0                
1002d0d0  40820094    bne 0x1002d164                 ; -> 1002d164
1002d0d4  7fc3f378    or r3,r30,r30               
1002d0d8  7fe4fb78    or r4,r31,r31               
1002d0dc  4bfd770d    bl 0x100047e8                  ; -> 100047e8
1002d0e0  60000000    ori r0,r0,0x0               
1002d0e4  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002d0e8  28030000    cmplwi r3,0x0               
1002d0ec  41820090    beq 0x1002d17c                 ; -> 1002d17c
1002d0f0  38600004    li r3,0x4                   
1002d0f4  38800007    li r4,0x7                   
1002d0f8  4bffdf29    bl 0x1002b020                  ; -> 1002b020
1002d0fc  7f480734    extsh r8,r26                
1002d100  7fcb0734    extsh r11,r30               
1002d104  38e26840    addi r7,r2,0x6840           
1002d108  7f4a0734    extsh r10,r26               
1002d10c  7fec0734    extsh r12,r31               
1002d110  39226840    addi r9,r2,0x6840           
1002d114  1d080070    mulli r8,r8,0x70            
1002d118  38e70036    addi r7,r7,0x36             
1002d11c  7ce742ae    lhax r7,r7,r8               
1002d120  1d6b003c    mulli r11,r11,0x3c          
1002d124  558c103a    rlwinm r12,r12,0x2,0x0,0x1d 
1002d128  7d6b6214    add r11,r11,r12             
1002d12c  3d00ffff    lis r8,-0x1                 
1002d130  1d4a0070    mulli r10,r10,0x70          
1002d134  39290036    addi r9,r9,0x36             
1002d138  7d7d582e    lwzx r11,r29,r11            
1002d13c  39081000    addi r8,r8,0x1000           
1002d140  7d2952ae    lhax r9,r9,r10              
1002d144  54e6063e    rlwinm r6,r7,0x0,0x18,0x1f  
1002d148  7d6b4038    and r11,r11,r8              
1002d14c  7f83e378    or r3,r28,r28               
1002d150  7f64db78    or r4,r27,r27               
1002d154  38a00001    li r5,0x1                   
1002d158  7ce95a14    add r7,r9,r11               
1002d15c  4bffa3f1    bl 0x1002754c                  ; -> 1002754c
1002d160  4800001c    b 0x1002d17c                   ; -> 1002d17c
1002d164  38600003    li r3,0x3                   
1002d168  38800007    li r4,0x7                   
1002d16c  4bffdeb5    bl 0x1002b020                  ; -> 1002b020
1002d170  7fc3f378    or r3,r30,r30               
1002d174  7fe4fb78    or r4,r31,r31               
1002d178  4bffa84d    bl 0x100279c4                  ; -> 100279c4
1002d17c  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1002d180  38210050    addi r1,r1,0x50             
1002d184  7c0803a6    mtspr LR,r0                 
1002d188  bb41ffe8    lmw r26,-0x18(r1)              ; -> Stack[-0x18]
1002d18c  4e800020    blr                         
