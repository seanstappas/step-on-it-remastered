; FUN_1002e990 @ 0x1002e990
1002e990  7c0802a6    mfspr r0,LR                 
1002e994  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002e998  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1002e99c  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1002e9a0  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
1002e9a4  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002e9a8  9421ff70    stwu r1,-0x90(r1)              ; -> Stack[-0x90]
1002e9ac  906100a8    stw r3,0xa8(r1)                ; -> Stack[0x18]
1002e9b0  908100ac    stw r4,0xac(r1)                ; -> Stack[0x1c]
1002e9b4  7cbc2b78    or r28,r5,r5                
1002e9b8  281c0000    cmplwi r28,0x0              
1002e9bc  3be00000    li r31,0x0                  
1002e9c0  41820080    beq 0x1002ea40                 ; -> 1002ea40
1002e9c4  480025a5    bl 0x10030f68                  ; -> 10030f68
1002e9c8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
1002e9cc  7c7e1b78    or r30,r3,r3                
1002e9d0  806100a8    lwz r3,0xa8(r1)                ; -> Stack[0x18]
1002e9d4  808100ac    lwz r4,0xac(r1)                ; -> Stack[0x1c]
1002e9d8  38a10038    addi r5,r1,0x38             
1002e9dc  4800095d    bl 0x1002f338                  ; -> 1002f338
1002e9e0  7c7f1b78    or r31,r3,r3                
1002e9e4  7fe30734    extsh r3,r31                
1002e9e8  2c030000    cmpwi r3,0x0                
1002e9ec  40820058    bne 0x1002ea44                 ; -> 1002ea44
1002e9f0  38610038    addi r3,r1,0x38             
1002e9f4  38800003    li r4,0x3                   
1002e9f8  480011e1    bl 0x1002fbd8                  ; -> 1002fbd8
1002e9fc  60000000    ori r0,r0,0x0               
1002ea00  7c7d1b78    or r29,r3,r3                
1002ea04  48002c25    bl 0x10031628                  ; -> 10031628
1002ea08  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
1002ea0c  7c7f1b78    or r31,r3,r3                
1002ea10  7fe40734    extsh r4,r31                
1002ea14  2c040000    cmpwi r4,0x0                
1002ea18  40820024    bne 0x1002ea3c                 ; -> 1002ea3c
1002ea1c  b3bc0000    sth r29,0x0(r28)            
1002ea20  7fc3f378    or r3,r30,r30               
1002ea24  48002c65    bl 0x10031688                  ; -> 10031688
1002ea28  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
1002ea2c  48002bfd    bl 0x10031628                  ; -> 10031628
1002ea30  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
1002ea34  7c7f1b78    or r31,r3,r3                
1002ea38  4800000c    b 0x1002ea44                   ; -> 1002ea44
1002ea3c  48000008    b 0x1002ea44                   ; -> 1002ea44
1002ea40  3be0ffce    li r31,-0x32                
1002ea44  7fe3fb78    or r3,r31,r31               
1002ea48  80010098    lwz r0,0x98(r1)                ; -> Stack[0x8]
1002ea4c  38210090    addi r1,r1,0x90             
1002ea50  7c0803a6    mtspr LR,r0                 
1002ea54  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002ea58  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1002ea5c  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1002ea60  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
1002ea64  4e800020    blr                         
