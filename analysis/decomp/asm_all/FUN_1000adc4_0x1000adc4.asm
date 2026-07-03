; FUN_1000adc4 @ 0x1000adc4
1000adc4  7c0802a6    mfspr r0,LR                 
1000adc8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1000adcc  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000add0  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1000add4  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
1000add8  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000addc  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000ade0  7c7e1b78    or r30,r3,r3                
1000ade4  7fc40734    extsh r4,r30                
1000ade8  1c840046    mulli r4,r4,0x46            
1000adec  38623cd8    addi r3,r2,0x3cd8           
1000adf0  7fe32214    add r31,r3,r4               
1000adf4  88bf001f    lbz r5,0x1f(r31)            
1000adf8  28050000    cmplwi r5,0x0               
1000adfc  418200a4    beq 0x1000aea0                 ; -> 1000aea0
1000ae00  38c00000    li r6,0x0                   
1000ae04  3980040e    li r12,0x40e                
1000ae08  98df001f    stb r6,0x1f(r31)            
1000ae0c  38e00002    li r7,0x2                   
1000ae10  b0ff0024    sth r7,0x24(r31)            
1000ae14  39000001    li r8,0x1                   
1000ae18  392261a4    addi r9,r2,0x61a4           
1000ae1c  b11f0026    sth r8,0x26(r31)            
1000ae20  81290038    lwz r9,0x38(r9)             
1000ae24  39400000    li r10,0x0                  
1000ae28  913f000a    stw r9,0xa(r31)             
1000ae2c  915f0014    stw r10,0x14(r31)           
1000ae30  39600001    li r11,0x1                  
1000ae34  b17f000e    sth r11,0xe(r31)            
1000ae38  a87f0012    lha r3,0x12(r31)            
1000ae3c  7d9d6378    or r29,r12,r12              
1000ae40  480238b9    bl 0x1002e6f8                  ; -> 1002e6f8
1000ae44  60000000    ori r0,r0,0x0               
1000ae48  7c630734    extsh r3,r3                 
1000ae4c  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
1000ae50  7c7c1b78    or r28,r3,r3                
1000ae54  a87f0010    lha r3,0x10(r31)            
1000ae58  48023875    bl 0x1002e6cc                  ; -> 1002e6cc
1000ae5c  60000000    ori r0,r0,0x0               
1000ae60  7c630734    extsh r3,r3                 
1000ae64  1c63003c    mulli r3,r3,0x3c            
1000ae68  38826bf8    addi r4,r2,0x6bf8           
1000ae6c  7c63e214    add r3,r3,r28               
1000ae70  7fa4192e    stwx r29,r4,r3              
1000ae74  a8bf0012    lha r5,0x12(r31)            
1000ae78  38e00001    li r7,0x1                   
1000ae7c  38a5ffd5    subi r5,r5,0x2b             
1000ae80  b0bf0012    sth r5,0x12(r31)            
1000ae84  a8df0010    lha r6,0x10(r31)            
1000ae88  390003e8    li r8,0x3e8                 
1000ae8c  38c6ffe8    subi r6,r6,0x18             
1000ae90  b0df0010    sth r6,0x10(r31)            
1000ae94  98ff001e    stb r7,0x1e(r31)            
1000ae98  b11f0042    sth r8,0x42(r31)            
1000ae9c  480001e8    b 0x1000b084                   ; -> 1000b084
1000aea0  a93f0024    lha r9,0x24(r31)            
1000aea4  7d2a4b78    or r10,r9,r9                
1000aea8  7d4a0734    extsh r10,r10               
1000aeac  3929ffff    subi r9,r9,0x1              
1000aeb0  2c0a0000    cmpwi r10,0x0               
1000aeb4  b13f0024    sth r9,0x24(r31)            
1000aeb8  418101cc    bgt 0x1000b084                 ; -> 1000b084
1000aebc  39600001    li r11,0x1                  
1000aec0  997f001e    stb r11,0x1e(r31)           
1000aec4  a99f0026    lha r12,0x26(r31)           
1000aec8  2c0c0001    cmpwi r12,0x1               
1000aecc  4082005c    bne 0x1000af28                 ; -> 1000af28
1000aed0  3b800005    li r28,0x5                  
1000aed4  b39f0024    sth r28,0x24(r31)           
1000aed8  abbf000e    lha r29,0xe(r31)            
1000aedc  2c1d0010    cmpwi r29,0x10              
1000aee0  40810038    ble 0x1000af18                 ; -> 1000af18
1000aee4  38600002    li r3,0x2                   
1000aee8  b07f0026    sth r3,0x26(r31)            
1000aeec  a89f0006    lha r4,0x6(r31)             
1000aef0  38a00050    li r5,0x50                  
1000aef4  1c840006    mulli r4,r4,0x6             
1000aef8  7c842bd6    divw r4,r4,r5               
1000aefc  b09f0028    sth r4,0x28(r31)            
1000af00  a8df0028    lha r6,0x28(r31)            
1000af04  2c060001    cmpwi r6,0x1                
1000af08  4080014c    bge 0x1000b054                 ; -> 1000b054
1000af0c  38e00001    li r7,0x1                   
1000af10  b0ff0028    sth r7,0x28(r31)            
1000af14  48000140    b 0x1000b054                   ; -> 1000b054
1000af18  a91f000e    lha r8,0xe(r31)             
1000af1c  39080001    addi r8,r8,0x1              
1000af20  b11f000e    sth r8,0xe(r31)             
1000af24  48000130    b 0x1000b054                   ; -> 1000b054
1000af28  a93f0026    lha r9,0x26(r31)            
1000af2c  2c090002    cmpwi r9,0x2                
1000af30  40820058    bne 0x1000af88                 ; -> 1000af88
1000af34  39400003    li r10,0x3                  
1000af38  b15f0024    sth r10,0x24(r31)           
1000af3c  a97f000e    lha r11,0xe(r31)            
1000af40  2c0b001f    cmpwi r11,0x1f              
1000af44  40810034    ble 0x1000af78                 ; -> 1000af78
1000af48  a99f0028    lha r12,0x28(r31)           
1000af4c  398cffff    subi r12,r12,0x1            
1000af50  b19f0028    sth r12,0x28(r31)           
1000af54  7d8c0734    extsh r12,r12               
1000af58  2c0c0000    cmpwi r12,0x0               
1000af5c  41810010    bgt 0x1000af6c                 ; -> 1000af6c
1000af60  3b800003    li r28,0x3                  
1000af64  b39f0026    sth r28,0x26(r31)           
1000af68  480000ec    b 0x1000b054                   ; -> 1000b054
1000af6c  3ba00011    li r29,0x11                 
1000af70  b3bf000e    sth r29,0xe(r31)            
1000af74  480000e0    b 0x1000b054                   ; -> 1000b054
1000af78  a87f000e    lha r3,0xe(r31)             
1000af7c  38630001    addi r3,r3,0x1              
1000af80  b07f000e    sth r3,0xe(r31)             
1000af84  480000d0    b 0x1000b054                   ; -> 1000b054
1000af88  a89f0026    lha r4,0x26(r31)            
1000af8c  2c040003    cmpwi r4,0x3                
1000af90  408200c0    bne 0x1000b050                 ; -> 1000b050
1000af94  38a00003    li r5,0x3                   
1000af98  b0bf0024    sth r5,0x24(r31)            
1000af9c  a8df000e    lha r6,0xe(r31)             
1000afa0  2c060048    cmpwi r6,0x48               
1000afa4  4081009c    ble 0x1000b040                 ; -> 1000b040
1000afa8  38e00002    li r7,0x2                   
1000afac  b0ff0026    sth r7,0x26(r31)            
1000afb0  a91f0008    lha r8,0x8(r31)             
1000afb4  39200050    li r9,0x50                  
1000afb8  1d080006    mulli r8,r8,0x6             
1000afbc  7d084bd6    divw r8,r8,r9               
1000afc0  b11f0028    sth r8,0x28(r31)            
1000afc4  a95f0028    lha r10,0x28(r31)           
1000afc8  2c0a0001    cmpwi r10,0x1               
1000afcc  4080000c    bge 0x1000afd8                 ; -> 1000afd8
1000afd0  39600001    li r11,0x1                  
1000afd4  b17f0028    sth r11,0x28(r31)           
1000afd8  39800010    li r12,0x10                 
1000afdc  b19f000e    sth r12,0xe(r31)            
1000afe0  38600064    li r3,0x64                  
1000afe4  48001295    bl 0x1000c278                  ; -> 1000c278
1000afe8  60000000    ori r0,r0,0x0               
1000afec  3b82711c    addi r28,r2,0x711c          
1000aff0  7c630734    extsh r3,r3                 
1000aff4  ab9c0000    lha r28,0x0(r28)            
1000aff8  7c03e000    cmpw r3,r28                 
1000affc  40810024    ble 0x1000b020                 ; -> 1000b020
1000b000  a8bf0012    lha r5,0x12(r31)            
1000b004  abbf0010    lha r29,0x10(r31)           
1000b008  3885fff8    subi r4,r5,0x8              
1000b00c  387d001e    addi r3,r29,0x1e            
1000b010  7fc5f378    or r5,r30,r30               
1000b014  48000439    bl 0x1000b44c                  ; -> 1000b44c
1000b018  60000000    ori r0,r0,0x0               
1000b01c  48000038    b 0x1000b054                   ; -> 1000b054
1000b020  a8df0010    lha r6,0x10(r31)            
1000b024  a8ff0012    lha r7,0x12(r31)            
1000b028  3866001e    addi r3,r6,0x1e             
1000b02c  3887fff8    subi r4,r7,0x8              
1000b030  7fc5f378    or r5,r30,r30               
1000b034  48000f21    bl 0x1000bf54                  ; -> 1000bf54
1000b038  60000000    ori r0,r0,0x0               
1000b03c  48000018    b 0x1000b054                   ; -> 1000b054
1000b040  a91f000e    lha r8,0xe(r31)             
1000b044  39080001    addi r8,r8,0x1              
1000b048  b11f000e    sth r8,0xe(r31)             
1000b04c  48000008    b 0x1000b054                   ; -> 1000b054
1000b050  48000034    b 0x1000b084                   ; -> 1000b084
1000b054  a93f0010    lha r9,0x10(r31)            
1000b058  39290009    addi r9,r9,0x9              
1000b05c  b13f003a    sth r9,0x3a(r31)            
1000b060  a95f0010    lha r10,0x10(r31)           
1000b064  394a0019    addi r10,r10,0x19           
1000b068  b15f003c    sth r10,0x3c(r31)           
1000b06c  a97f0012    lha r11,0x12(r31)           
1000b070  396b0006    addi r11,r11,0x6            
1000b074  b17f0038    sth r11,0x38(r31)           
1000b078  a99f0012    lha r12,0x12(r31)           
1000b07c  398c001e    addi r12,r12,0x1e           
1000b080  b19f0036    sth r12,0x36(r31)           
1000b084  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000b088  38210050    addi r1,r1,0x50             
1000b08c  7c0803a6    mtspr LR,r0                 
1000b090  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000b094  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1000b098  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1000b09c  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
1000b0a0  4e800020    blr                         
