; FUN_10017b68 @ 0x10017b68  (92 instructions)
10017b68  7c0802a6    mfspr r0,LR                 
10017b6c  bf41ffe8    stmw r26,-0x18(r1)             ; -> Stack[-0x18]
10017b70  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10017b74  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10017b78  3b6261a4    addi r27,r2,0x61a4          
10017b7c  3b820928    addi r28,r2,0x928           
10017b80  3ba24e88    addi r29,r2,0x4e88          
10017b84  3b400000    li r26,0x0                  
10017b88  4bfffee9    bl 0x10017a70                  ; -> 10017a70
10017b8c  3be00001    li r31,0x1                  
10017b90  48000110    b 0x10017ca0                   ; -> 10017ca0
10017b94  7fe30734    extsh r3,r31                
10017b98  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10017b9c  7c7d18ae    lbzx r3,r29,r3              
10017ba0  28030000    cmplwi r3,0x0               
10017ba4  418200f8    beq 0x10017c9c                 ; -> 10017c9c
10017ba8  7fe40734    extsh r4,r31                
10017bac  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
10017bb0  38840001    addi r4,r4,0x1              
10017bb4  7c9d20ae    lbzx r4,r29,r4              
10017bb8  28040000    cmplwi r4,0x0               
10017bbc  408200e0    bne 0x10017c9c                 ; -> 10017c9c
10017bc0  7fe50734    extsh r5,r31                
10017bc4  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
10017bc8  7c9c2aae    lhax r4,r28,r5              
10017bcc  387f03e8    addi r3,r31,0x3e8           
10017bd0  4bfe8435    bl 0x10000004                  ; -> 10000004
10017bd4  60000000    ori r0,r0,0x0               
10017bd8  7c7e1b78    or r30,r3,r3                
10017bdc  281e0000    cmplwi r30,0x0              
10017be0  40820014    bne 0x10017bf4                 ; -> 10017bf4
10017be4  38600005    li r3,0x5                   
10017be8  48001711    bl 0x100192f8                  ; -> 100192f8
10017bec  60000000    ori r0,r0,0x0               
10017bf0  480000ac    b 0x10017c9c                   ; -> 10017c9c
10017bf4  38c0ffff    li r6,-0x1                  
10017bf8  7c1e3040    cmplw r30,r6                
10017bfc  40820080    bne 0x10017c7c                 ; -> 10017c7c
10017c00  480004d9    bl 0x100180d8                  ; -> 100180d8
10017c04  60000000    ori r0,r0,0x0               
10017c08  7fe70734    extsh r7,r31                
10017c0c  54e7083c    rlwinm r7,r7,0x1,0x0,0x1e   
10017c10  7c9c3aae    lhax r4,r28,r7              
10017c14  387f03e8    addi r3,r31,0x3e8           
10017c18  4bfe83ed    bl 0x10000004                  ; -> 10000004
10017c1c  60000000    ori r0,r0,0x0               
10017c20  7c7e1b78    or r30,r3,r3                
10017c24  281e0000    cmplwi r30,0x0              
10017c28  40820014    bne 0x10017c3c                 ; -> 10017c3c
10017c2c  38600005    li r3,0x5                   
10017c30  480016c9    bl 0x100192f8                  ; -> 100192f8
10017c34  60000000    ori r0,r0,0x0               
10017c38  48000064    b 0x10017c9c                   ; -> 10017c9c
10017c3c  3900ffff    li r8,-0x1                  
10017c40  7c1e4040    cmplw r30,r8                
10017c44  40820014    bne 0x10017c58                 ; -> 10017c58
10017c48  38600006    li r3,0x6                   
10017c4c  480016ad    bl 0x100192f8                  ; -> 100192f8
10017c50  60000000    ori r0,r0,0x0               
10017c54  48000048    b 0x10017c9c                   ; -> 10017c9c
10017c58  7fe90734    extsh r9,r31                
10017c5c  7feb0734    extsh r11,r31               
10017c60  5529103a    rlwinm r9,r9,0x2,0x0,0x1d   
10017c64  556b103a    rlwinm r11,r11,0x2,0x0,0x1d 
10017c68  7fdb492e    stwx r30,r27,r9             
10017c6c  39400001    li r10,0x1                  
10017c70  396b0001    addi r11,r11,0x1            
10017c74  7d5d59ae    stbx r10,r29,r11            
10017c78  48000024    b 0x10017c9c                   ; -> 10017c9c
10017c7c  7fec0734    extsh r12,r31               
10017c80  7fe40734    extsh r4,r31                
10017c84  558c103a    rlwinm r12,r12,0x2,0x0,0x1d 
10017c88  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
10017c8c  7fdb612e    stwx r30,r27,r12            
10017c90  38600001    li r3,0x1                   
10017c94  38840001    addi r4,r4,0x1              
10017c98  7c7d21ae    stbx r3,r29,r4              
10017c9c  3bff0001    addi r31,r31,0x1            
10017ca0  7fe50734    extsh r5,r31                
10017ca4  2c050013    cmpwi r5,0x13               
10017ca8  41810010    bgt 0x10017cb8                 ; -> 10017cb8
10017cac  5746063e    rlwinm r6,r26,0x0,0x18,0x1f 
10017cb0  28060000    cmplwi r6,0x0               
10017cb4  4182fee0    beq 0x10017b94                 ; -> 10017b94
10017cb8  48000021    bl 0x10017cd8                  ; -> 10017cd8
10017cbc  60000000    ori r0,r0,0x0               
10017cc0  38600001    li r3,0x1                   
10017cc4  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10017cc8  38210050    addi r1,r1,0x50             
10017ccc  7c0803a6    mtspr LR,r0                 
10017cd0  bb41ffe8    lmw r26,-0x18(r1)              ; -> Stack[-0x18]
10017cd4  4e800020    blr                         
