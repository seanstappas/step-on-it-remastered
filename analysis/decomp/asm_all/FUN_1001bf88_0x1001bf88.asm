; FUN_1001bf88 @ 0x1001bf88
1001bf88  7c0802a6    mfspr r0,LR                 
1001bf8c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001bf90  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1001bf94  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001bf98  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1001bf9c  7c7e1b78    or r30,r3,r3                
1001bfa0  83fe0002    lwz r31,0x2(r30)            
1001bfa4  7fe3fb78    or r3,r31,r31               
1001bfa8  48002d79    bl 0x1001ed20                  ; -> 1001ed20
1001bfac  60000000    ori r0,r0,0x0               
1001bfb0  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1001bfb4  28030000    cmplwi r3,0x0               
1001bfb8  4182004c    beq 0x1001c004                 ; -> 1001c004
1001bfbc  7fe3fb78    or r3,r31,r31               
1001bfc0  480165b1    bl 0x10032570                  ; -> 10032570
1001bfc4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
1001bfc8  807f0018    lwz r3,0x18(r31)            
1001bfcc  480165bd    bl 0x10032588                  ; -> 10032588
1001bfd0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
1001bfd4  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1001bfd8  28030000    cmplwi r3,0x0               
1001bfdc  4082001c    bne 0x1001bff8                 ; -> 1001bff8
1001bfe0  7fe3fb78    or r3,r31,r31               
1001bfe4  480151dd    bl 0x100311c0                  ; -> 100311c0
1001bfe8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
1001bfec  7fc3f378    or r3,r30,r30               
1001bff0  48002f81    bl 0x1001ef70                  ; -> 1001ef70
1001bff4  60000000    ori r0,r0,0x0               
1001bff8  7fe3fb78    or r3,r31,r31               
1001bffc  480165a5    bl 0x100325a0                  ; -> 100325a0
1001c000  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
1001c004  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1001c008  38210040    addi r1,r1,0x40             
1001c00c  7c0803a6    mtspr LR,r0                 
1001c010  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001c014  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1001c018  4e800020    blr                         
