; FUN_1002cf08 @ 0x1002cf08  (81 instructions)
1002cf08  7c0802a6    mfspr r0,LR                 
1002cf0c  bf41ffe8    stmw r26,-0x18(r1)             ; -> Stack[-0x18]
1002cf10  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002cf14  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1002cf18  7c7e1b78    or r30,r3,r3                
1002cf1c  7c9f2378    or r31,r4,r4                
1002cf20  7cba2b78    or r26,r5,r5                
1002cf24  3ba26bf8    addi r29,r2,0x6bf8          
1002cf28  7fc3f378    or r3,r30,r30               
1002cf2c  48001781    bl 0x1002e6ac                  ; -> 1002e6ac
1002cf30  60000000    ori r0,r0,0x0               
1002cf34  7c7c1b78    or r28,r3,r3                
1002cf38  7fe3fb78    or r3,r31,r31               
1002cf3c  48001781    bl 0x1002e6bc                  ; -> 1002e6bc
1002cf40  60000000    ori r0,r0,0x0               
1002cf44  7c7b1b78    or r27,r3,r3                
1002cf48  7fc30734    extsh r3,r30                
1002cf4c  7fe40734    extsh r4,r31                
1002cf50  1c63003c    mulli r3,r3,0x3c            
1002cf54  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
1002cf58  7c632214    add r3,r3,r4                
1002cf5c  7c7d182e    lwzx r3,r29,r3              
1002cf60  546305ee    rlwinm r3,r3,0x0,0x17,0x17  
1002cf64  2c030000    cmpwi r3,0x0                
1002cf68  408200d0    bne 0x1002d038                 ; -> 1002d038
1002cf6c  7fc50734    extsh r5,r30                
1002cf70  7fe60734    extsh r6,r31                
1002cf74  1ca5003c    mulli r5,r5,0x3c            
1002cf78  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
1002cf7c  7ca53214    add r5,r5,r6                
1002cf80  7cbd282e    lwzx r5,r29,r5              
1002cf84  54a5063e    rlwinm r5,r5,0x0,0x18,0x1f  
1002cf88  2c050000    cmpwi r5,0x0                
1002cf8c  40820094    bne 0x1002d020                 ; -> 1002d020
1002cf90  7fc3f378    or r3,r30,r30               
1002cf94  7fe4fb78    or r4,r31,r31               
1002cf98  4bfd7785    bl 0x1000471c                  ; -> 1000471c
1002cf9c  60000000    ori r0,r0,0x0               
1002cfa0  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002cfa4  28030000    cmplwi r3,0x0               
1002cfa8  41820090    beq 0x1002d038                 ; -> 1002d038
1002cfac  38600004    li r3,0x4                   
1002cfb0  38800007    li r4,0x7                   
1002cfb4  4bffe06d    bl 0x1002b020                  ; -> 1002b020
1002cfb8  7f480734    extsh r8,r26                
1002cfbc  7fcb0734    extsh r11,r30               
1002cfc0  38e26840    addi r7,r2,0x6840           
1002cfc4  7f4a0734    extsh r10,r26               
1002cfc8  7fec0734    extsh r12,r31               
1002cfcc  39226840    addi r9,r2,0x6840           
1002cfd0  1d080070    mulli r8,r8,0x70            
1002cfd4  38e70036    addi r7,r7,0x36             
1002cfd8  7ce742ae    lhax r7,r7,r8               
1002cfdc  1d6b003c    mulli r11,r11,0x3c          
1002cfe0  558c103a    rlwinm r12,r12,0x2,0x0,0x1d 
1002cfe4  7d6b6214    add r11,r11,r12             
1002cfe8  3d00ffff    lis r8,-0x1                 
1002cfec  1d4a0070    mulli r10,r10,0x70          
1002cff0  39290036    addi r9,r9,0x36             
1002cff4  7d7d582e    lwzx r11,r29,r11            
1002cff8  39081000    addi r8,r8,0x1000           
1002cffc  7d2952ae    lhax r9,r9,r10              
1002d000  54e6063e    rlwinm r6,r7,0x0,0x18,0x1f  
1002d004  7d6b4038    and r11,r11,r8              
1002d008  7f83e378    or r3,r28,r28               
1002d00c  7f64db78    or r4,r27,r27               
1002d010  38a00001    li r5,0x1                   
1002d014  7ce95a14    add r7,r9,r11               
1002d018  4bffa535    bl 0x1002754c                  ; -> 1002754c
1002d01c  4800001c    b 0x1002d038                   ; -> 1002d038
1002d020  38600003    li r3,0x3                   
1002d024  38800007    li r4,0x7                   
1002d028  4bffdff9    bl 0x1002b020                  ; -> 1002b020
1002d02c  7fc3f378    or r3,r30,r30               
1002d030  7fe4fb78    or r4,r31,r31               
1002d034  4bffa991    bl 0x100279c4                  ; -> 100279c4
1002d038  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1002d03c  38210050    addi r1,r1,0x50             
1002d040  7c0803a6    mtspr LR,r0                 
1002d044  bb41ffe8    lmw r26,-0x18(r1)              ; -> Stack[-0x18]
1002d048  4e800020    blr                         
