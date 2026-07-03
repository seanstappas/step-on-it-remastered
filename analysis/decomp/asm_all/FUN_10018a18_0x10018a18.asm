; FUN_10018a18 @ 0x10018a18
10018a18  7c0802a6    mfspr r0,LR                 
10018a1c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10018a20  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10018a24  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10018a28  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10018a2c  7c7e1b78    or r30,r3,r3                
10018a30  386269fe    addi r3,r2,0x69fe           
10018a34  3be26840    addi r31,r2,0x6840          
10018a38  88630000    lbz r3,0x0(r3)              
10018a3c  28030000    cmplwi r3,0x0               
10018a40  4182006c    beq 0x10018aac                 ; -> 10018aac
10018a44  38822f74    addi r4,r2,0x2f74           
10018a48  88840000    lbz r4,0x0(r4)              
10018a4c  28040000    cmplwi r4,0x0               
10018a50  4182005c    beq 0x10018aac                 ; -> 10018aac
10018a54  7fc50734    extsh r5,r30                
10018a58  2c050001    cmpwi r5,0x1                
10018a5c  40820024    bne 0x10018a80                 ; -> 10018a80
10018a60  a8df0120    lha r6,0x120(r31)           
10018a64  2c0603e8    cmpwi r6,0x3e8              
10018a68  40810018    ble 0x10018a80                 ; -> 10018a80
10018a6c  88ff011a    lbz r7,0x11a(r31)           
10018a70  28070000    cmplwi r7,0x0               
10018a74  4082000c    bne 0x10018a80                 ; -> 10018a80
10018a78  4800004d    bl 0x10018ac4                  ; -> 10018ac4
10018a7c  60000000    ori r0,r0,0x0               
10018a80  7fc80734    extsh r8,r30                
10018a84  2c080002    cmpwi r8,0x2                
10018a88  40820024    bne 0x10018aac                 ; -> 10018aac
10018a8c  a93f00b0    lha r9,0xb0(r31)            
10018a90  2c0903e8    cmpwi r9,0x3e8              
10018a94  40810018    ble 0x10018aac                 ; -> 10018aac
10018a98  895f00aa    lbz r10,0xaa(r31)           
10018a9c  280a0000    cmplwi r10,0x0              
10018aa0  4082000c    bne 0x10018aac                 ; -> 10018aac
10018aa4  48000021    bl 0x10018ac4                  ; -> 10018ac4
10018aa8  60000000    ori r0,r0,0x0               
10018aac  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10018ab0  38210040    addi r1,r1,0x40             
10018ab4  7c0803a6    mtspr LR,r0                 
10018ab8  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10018abc  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10018ac0  4e800020    blr                         
