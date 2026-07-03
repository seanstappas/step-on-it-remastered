; FUN_1001bab8 @ 0x1001bab8
1001bab8  7c0802a6    mfspr r0,LR                 
1001babc  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001bac0  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1001bac4  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1001bac8  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
1001bacc  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001bad0  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1001bad4  7c7f1b78    or r31,r3,r3                
1001bad8  807f000a    lwz r3,0xa(r31)             
1001badc  38810038    addi r4,r1,0x38             
1001bae0  480165b1    bl 0x10032090                  ; -> 10032090
1001bae4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001bae8  7c7d1b78    or r29,r3,r3                
1001baec  7fa30734    extsh r3,r29                
1001baf0  28030008    cmplwi r3,0x8               
1001baf4  4181019c    bgt 0x1001bc90                 ; -> 1001bc90
1001baf8  38820b68    addi r4,r2,0xb68            
1001bafc  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
1001bb00  7c84182e    lwzx r4,r4,r3               
1001bb04  7c8903a6    mtspr CTR,r4                
1001bb08  4e800420    bctr                        
1001bc90  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1001bc94  38210060    addi r1,r1,0x60             
1001bc98  7c0803a6    mtspr LR,r0                 
1001bc9c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001bca0  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1001bca4  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1001bca8  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
1001bcac  4e800020    blr                         
