; FUN_1001bcb0 @ 0x1001bcb0
1001bcb0  7c0802a6    mfspr r0,LR                 
1001bcb4  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001bcb8  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1001bcbc  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1001bcc0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001bcc4  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1001bcc8  7c7d1b78    or r29,r3,r3                
1001bccc  807d0002    lwz r3,0x2(r29)             
1001bcd0  3be25261    addi r31,r2,0x5261          
1001bcd4  5463463e    rlwinm r3,r3,0x8,0x18,0x1f  
1001bcd8  2c0300fa    cmpwi r3,0xfa               
1001bcdc  8bdf0000    lbz r30,0x0(r31)            
1001bce0  418200d8    beq 0x1001bdb8                 ; -> 1001bdb8
1001bce4  408000d4    bge 0x1001bdb8                 ; -> 1001bdb8
1001bce8  2c030001    cmpwi r3,0x1                
1001bcec  41820008    beq 0x1001bcf4                 ; -> 1001bcf4
1001bcf0  480000c8    b 0x1001bdb8                   ; -> 1001bdb8
1001bcf4  809d0002    lwz r4,0x2(r29)             
1001bcf8  548407fe    rlwinm r4,r4,0x0,0x1f,0x1f  
1001bcfc  28040000    cmplwi r4,0x0               
1001bd00  7ca00026    mfcr r5                     
1001bd04  54a51ffe    rlwinm r5,r5,0x3,0x1f,0x1f  
1001bd08  98bf0000    stb r5,0x0(r31)             
1001bd0c  88df0000    lbz r6,0x0(r31)             
1001bd10  28060000    cmplwi r6,0x0               
1001bd14  41820034    beq 0x1001bd48                 ; -> 1001bd48
1001bd18  3860001e    li r3,0x1e                  
1001bd1c  4bffca21    bl 0x1001873c                  ; -> 1001873c
1001bd20  60000000    ori r0,r0,0x0               
1001bd24  38e27534    addi r7,r2,0x7534           
1001bd28  80670000    lwz r3,0x0(r7)              
1001bd2c  4801640d    bl 0x10032138                  ; -> 10032138
1001bd30  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001bd34  3902753c    addi r8,r2,0x753c           
1001bd38  80680000    lwz r3,0x0(r8)              
1001bd3c  48015c1d    bl 0x10031958                  ; -> 10031958
1001bd40  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001bd44  4800006c    b 0x1001bdb0                   ; -> 1001bdb0
1001bd48  57c9063e    rlwinm r9,r30,0x0,0x18,0x1f 
1001bd4c  28090000    cmplwi r9,0x0               
1001bd50  41820060    beq 0x1001bdb0                 ; -> 1001bdb0
1001bd54  48000081    bl 0x1001bdd4                  ; -> 1001bdd4
1001bd58  60000000    ori r0,r0,0x0               
1001bd5c  39427534    addi r10,r2,0x7534          
1001bd60  806a0000    lwz r3,0x0(r10)             
1001bd64  4801638d    bl 0x100320f0                  ; -> 100320f0
1001bd68  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001bd6c  3862753c    addi r3,r2,0x753c           
1001bd70  48015bd1    bl 0x10031940                  ; -> 10031940
1001bd74  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001bd78  3c600100    lis r3,0x100                
1001bd7c  38630100    addi r3,r3,0x100            
1001bd80  48015bd9    bl 0x10031958                  ; -> 10031958
1001bd84  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001bd88  39624fe5    addi r11,r2,0x4fe5          
1001bd8c  896b0000    lbz r11,0x0(r11)            
1001bd90  280b0000    cmplwi r11,0x0              
1001bd94  4182001c    beq 0x1001bdb0                 ; -> 1001bdb0
1001bd98  38600005    li r3,0x5                   
1001bd9c  4bffc679    bl 0x10018414                  ; -> 10018414
1001bda0  60000000    ori r0,r0,0x0               
1001bda4  38600001    li r3,0x1                   
1001bda8  4bffca85    bl 0x1001882c                  ; -> 1001882c
1001bdac  60000000    ori r0,r0,0x0               
1001bdb0  48015b19    bl 0x100318c8                  ; -> 100318c8
1001bdb4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001bdb8  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1001bdbc  38210050    addi r1,r1,0x50             
1001bdc0  7c0803a6    mtspr LR,r0                 
1001bdc4  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001bdc8  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1001bdcc  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1001bdd0  4e800020    blr                         
