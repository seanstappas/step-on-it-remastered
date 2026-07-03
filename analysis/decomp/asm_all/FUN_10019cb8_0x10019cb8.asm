; FUN_10019cb8 @ 0x10019cb8
10019cb8  7c0802a6    mfspr r0,LR                 
10019cbc  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
10019cc0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10019cc4  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10019cc8  7c7b1b78    or r27,r3,r3                
10019ccc  7f640734    extsh r4,r27                
10019cd0  38626a7c    addi r3,r2,0x6a7c           
10019cd4  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
10019cd8  7f83202e    lwzx r28,r3,r4              
10019cdc  3bc24f54    addi r30,r2,0x4f54          
10019ce0  281c0000    cmplwi r28,0x0              
10019ce4  41820094    beq 0x10019d78                 ; -> 10019d78
10019ce8  3ba00001    li r29,0x1                  
10019cec  48000060    b 0x10019d4c                   ; -> 10019d4c
10019cf0  3ba00000    li r29,0x0                  
10019cf4  3be00000    li r31,0x0                  
10019cf8  48000048    b 0x10019d40                   ; -> 10019d40
10019cfc  7fe50734    extsh r5,r31                
10019d00  1ca50024    mulli r5,r5,0x24            
10019d04  7cbe282e    lwzx r5,r30,r5              
10019d08  7c05e040    cmplw r5,r28                
10019d0c  40820030    bne 0x10019d3c                 ; -> 10019d3c
10019d10  7fe60734    extsh r6,r31                
10019d14  7fe70734    extsh r7,r31                
10019d18  1cc60024    mulli r6,r6,0x24            
10019d1c  1ce70024    mulli r7,r7,0x24            
10019d20  38c60008    addi r6,r6,0x8              
10019d24  38e70004    addi r7,r7,0x4              
10019d28  7cde302e    lwzx r6,r30,r6              
10019d2c  7cfe382e    lwzx r7,r30,r7              
10019d30  7c063800    cmpw r6,r7                  
10019d34  40800008    bge 0x10019d3c                 ; -> 10019d3c
10019d38  3ba00001    li r29,0x1                  
10019d3c  3bff0001    addi r31,r31,0x1            
10019d40  7fe80734    extsh r8,r31                
10019d44  2c080004    cmpwi r8,0x4                
10019d48  4180ffb4    blt 0x10019cfc                 ; -> 10019cfc
10019d4c  57a9063e    rlwinm r9,r29,0x0,0x18,0x1f 
10019d50  28090000    cmplwi r9,0x0               
10019d54  4082ff9c    bne 0x10019cf0                 ; -> 10019cf0
10019d58  7f83e378    or r3,r28,r28               
10019d5c  480172fd    bl 0x10031058                  ; -> 10031058
10019d60  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10019d64  7f6c0734    extsh r12,r27               
10019d68  39626a7c    addi r11,r2,0x6a7c          
10019d6c  39400000    li r10,0x0                  
10019d70  558c103a    rlwinm r12,r12,0x2,0x0,0x1d 
10019d74  7d4b612e    stwx r10,r11,r12            
10019d78  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10019d7c  38210050    addi r1,r1,0x50             
10019d80  7c0803a6    mtspr LR,r0                 
10019d84  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
10019d88  4e800020    blr                         
