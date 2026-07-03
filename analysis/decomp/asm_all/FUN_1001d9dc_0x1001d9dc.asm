; FUN_1001d9dc @ 0x1001d9dc
1001d9dc  7c0802a6    mfspr r0,LR                 
1001d9e0  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001d9e4  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1001d9e8  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1001d9ec  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
1001d9f0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001d9f4  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1001d9f8  3b8251fc    addi r28,r2,0x51fc          
1001d9fc  3bc25228    addi r30,r2,0x5228          
1001da00  3ba00000    li r29,0x0                  
1001da04  38600001    li r3,0x1                   
1001da08  48013861    bl 0x10031268                  ; -> 10031268
1001da0c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001da10  807e0000    lwz r3,0x0(r30)             
1001da14  480146dd    bl 0x100320f0                  ; -> 100320f0
1001da18  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001da1c  807e0000    lwz r3,0x0(r30)             
1001da20  480146e9    bl 0x10032108                  ; -> 10032108
1001da24  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001da28  807e0000    lwz r3,0x0(r30)             
1001da2c  48014305    bl 0x10031d30                  ; -> 10031d30
1001da30  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001da34  3be00000    li r31,0x0                  
1001da38  48000084    b 0x1001dabc                   ; -> 1001dabc
1001da3c  807c0000    lwz r3,0x0(r28)             
1001da40  38810038    addi r4,r1,0x38             
1001da44  480146dd    bl 0x10032120                  ; -> 10032120
1001da48  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001da4c  a8610038    lha r3,0x38(r1)                ; -> Stack[-0x18]
1001da50  2c030002    cmpwi r3,0x2                
1001da54  41820040    beq 0x1001da94                 ; -> 1001da94
1001da58  40800010    bge 0x1001da68                 ; -> 1001da68
1001da5c  2c030001    cmpwi r3,0x1                
1001da60  40800014    bge 0x1001da74                 ; -> 1001da74
1001da64  48000058    b 0x1001dabc                   ; -> 1001dabc
1001da68  2c030004    cmpwi r3,0x4                
1001da6c  40800050    bge 0x1001dabc                 ; -> 1001dabc
1001da70  48000038    b 0x1001daa8                   ; -> 1001daa8
1001da74  807e0000    lwz r3,0x0(r30)             
1001da78  480146c1    bl 0x10032138                  ; -> 10032138
1001da7c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001da80  48003431    bl 0x10020eb0                  ; -> 10020eb0
1001da84  60000000    ori r0,r0,0x0               
1001da88  3be00001    li r31,0x1                  
1001da8c  3ba00001    li r29,0x1                  
1001da90  4800002c    b 0x1001dabc                   ; -> 1001dabc
1001da94  807e0000    lwz r3,0x0(r30)             
1001da98  480146a1    bl 0x10032138                  ; -> 10032138
1001da9c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001daa0  3be00001    li r31,0x1                  
1001daa4  48000018    b 0x1001dabc                   ; -> 1001dabc
1001daa8  807e0000    lwz r3,0x0(r30)             
1001daac  4801468d    bl 0x10032138                  ; -> 10032138
1001dab0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dab4  3be00001    li r31,0x1                  
1001dab8  3ba00001    li r29,0x1                  
1001dabc  57e4063e    rlwinm r4,r31,0x0,0x18,0x1f 
1001dac0  28040000    cmplwi r4,0x0               
1001dac4  4182ff78    beq 0x1001da3c                 ; -> 1001da3c
1001dac8  48013489    bl 0x10030f50                  ; -> 10030f50
1001dacc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dad0  807e0000    lwz r3,0x0(r30)             
1001dad4  48014665    bl 0x10032138                  ; -> 10032138
1001dad8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dadc  7fa3eb78    or r3,r29,r29               
1001dae0  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1001dae4  38210050    addi r1,r1,0x50             
1001dae8  7c0803a6    mtspr LR,r0                 
1001daec  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001daf0  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1001daf4  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1001daf8  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
1001dafc  4e800020    blr                         
