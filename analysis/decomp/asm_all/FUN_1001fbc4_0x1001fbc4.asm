; FUN_1001fbc4 @ 0x1001fbc4
1001fbc4  7c0802a6    mfspr r0,LR                 
1001fbc8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001fbcc  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1001fbd0  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1001fbd4  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
1001fbd8  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001fbdc  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1001fbe0  480113d1    bl 0x10030fb0                  ; -> 10030fb0
1001fbe4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001fbe8  7c7f1b78    or r31,r3,r3                
1001fbec  807f0000    lwz r3,0x0(r31)             
1001fbf0  388251ee    addi r4,r2,0x51ee           
1001fbf4  83c30016    lwz r30,0x16(r3)            
1001fbf8  a8840000    lha r4,0x0(r4)              
1001fbfc  80be0000    lwz r5,0x0(r30)             
1001fc00  7c840734    extsh r4,r4                 
1001fc04  a8a50020    lha r5,0x20(r5)             
1001fc08  7c042800    cmpw r4,r5                  
1001fc0c  41820028    beq 0x1001fc34                 ; -> 1001fc34
1001fc10  38c251ee    addi r6,r2,0x51ee           
1001fc14  7fe3fb78    or r3,r31,r31               
1001fc18  a8860000    lha r4,0x0(r6)              
1001fc1c  38a00001    li r5,0x1                   
1001fc20  38c00001    li r6,0x1                   
1001fc24  480117dd    bl 0x10031400                  ; -> 10031400
1001fc28  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001fc2c  b0610038    sth r3,0x38(r1)                ; -> Stack[-0x18]
1001fc30  48000060    b 0x1001fc90                   ; -> 1001fc90
1001fc34  38e2613e    addi r7,r2,0x613e           
1001fc38  a8e70000    lha r7,0x0(r7)              
1001fc3c  2c070002    cmpwi r7,0x2                
1001fc40  41820050    beq 0x1001fc90                 ; -> 1001fc90
1001fc44  48011ccd    bl 0x10031910                  ; -> 10031910
1001fc48  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001fc4c  480129fd    bl 0x10032648                  ; -> 10032648
1001fc50  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001fc54  7c7d1b78    or r29,r3,r3                
1001fc58  38600000    li r3,0x0                   
1001fc5c  7fa4eb78    or r4,r29,r29               
1001fc60  48012a01    bl 0x10032660                  ; -> 10032660
1001fc64  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001fc68  480129e1    bl 0x10032648                  ; -> 10032648
1001fc6c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001fc70  7c7d1b78    or r29,r3,r3                
1001fc74  48012a05    bl 0x10032678                  ; -> 10032678
1001fc78  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001fc7c  7c7c1b78    or r28,r3,r3                
1001fc80  7f83e378    or r3,r28,r28               
1001fc84  7fa4eb78    or r4,r29,r29               
1001fc88  48012a09    bl 0x10032690                  ; -> 10032690
1001fc8c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001fc90  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1001fc94  38210050    addi r1,r1,0x50             
1001fc98  7c0803a6    mtspr LR,r0                 
1001fc9c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001fca0  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1001fca4  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1001fca8  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
1001fcac  4e800020    blr                         
