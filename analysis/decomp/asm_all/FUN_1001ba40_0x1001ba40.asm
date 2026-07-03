; FUN_1001ba40 @ 0x1001ba40
1001ba40  7c0802a6    mfspr r0,LR                 
1001ba44  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001ba48  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1001ba4c  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1001ba50  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001ba54  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1001ba58  7c7f1b78    or r31,r3,r3                
1001ba5c  a09f000e    lhz r4,0xe(r31)             
1001ba60  807f0002    lwz r3,0x2(r31)             
1001ba64  548405ee    rlwinm r4,r4,0x0,0x17,0x17  
1001ba68  2c040000    cmpwi r4,0x0                
1001ba6c  547e063e    rlwinm r30,r3,0x0,0x18,0x1f 
1001ba70  4182002c    beq 0x1001ba9c                 ; -> 1001ba9c
1001ba74  480005a9    bl 0x1001c01c                  ; -> 1001c01c
1001ba78  60000000    ori r0,r0,0x0               
1001ba7c  7fc30774    extsb r3,r30                
1001ba80  48016ad9    bl 0x10032558                  ; -> 10032558
1001ba84  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001ba88  7c7d1b78    or r29,r3,r3                
1001ba8c  7fa3eb78    or r3,r29,r29               
1001ba90  7fe4fb78    or r4,r31,r31               
1001ba94  48000905    bl 0x1001c398                  ; -> 1001c398
1001ba98  60000000    ori r0,r0,0x0               
1001ba9c  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1001baa0  38210050    addi r1,r1,0x50             
1001baa4  7c0803a6    mtspr LR,r0                 
1001baa8  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001baac  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1001bab0  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1001bab4  4e800020    blr                         
