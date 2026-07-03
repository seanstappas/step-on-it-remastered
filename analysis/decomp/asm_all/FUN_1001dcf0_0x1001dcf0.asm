; FUN_1001dcf0 @ 0x1001dcf0
1001dcf0  7c0802a6    mfspr r0,LR                 
1001dcf4  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001dcf8  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1001dcfc  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1001dd00  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
1001dd04  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001dd08  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1001dd0c  3bc25214    addi r30,r2,0x5214          
1001dd10  3b825200    addi r28,r2,0x5200          
1001dd14  3ba00000    li r29,0x0                  
1001dd18  38600001    li r3,0x1                   
1001dd1c  4801354d    bl 0x10031268                  ; -> 10031268
1001dd20  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dd24  807e0000    lwz r3,0x0(r30)             
1001dd28  480143c9    bl 0x100320f0                  ; -> 100320f0
1001dd2c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dd30  807e0000    lwz r3,0x0(r30)             
1001dd34  480143d5    bl 0x10032108                  ; -> 10032108
1001dd38  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dd3c  807e0000    lwz r3,0x0(r30)             
1001dd40  48013ff1    bl 0x10031d30                  ; -> 10031d30
1001dd44  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dd48  3be00000    li r31,0x0                  
1001dd4c  48000058    b 0x1001dda4                   ; -> 1001dda4
1001dd50  807c0000    lwz r3,0x0(r28)             
1001dd54  38810038    addi r4,r1,0x38             
1001dd58  480143c9    bl 0x10032120                  ; -> 10032120
1001dd5c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dd60  a8610038    lha r3,0x38(r1)                ; -> Stack[-0x18]
1001dd64  2c030002    cmpwi r3,0x2                
1001dd68  4182002c    beq 0x1001dd94                 ; -> 1001dd94
1001dd6c  40800038    bge 0x1001dda4                 ; -> 1001dda4
1001dd70  2c030001    cmpwi r3,0x1                
1001dd74  40800008    bge 0x1001dd7c                 ; -> 1001dd7c
1001dd78  4800002c    b 0x1001dda4                   ; -> 1001dda4
1001dd7c  807e0000    lwz r3,0x0(r30)             
1001dd80  480143b9    bl 0x10032138                  ; -> 10032138
1001dd84  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dd88  3be00001    li r31,0x1                  
1001dd8c  3ba00001    li r29,0x1                  
1001dd90  48000014    b 0x1001dda4                   ; -> 1001dda4
1001dd94  807e0000    lwz r3,0x0(r30)             
1001dd98  480143a1    bl 0x10032138                  ; -> 10032138
1001dd9c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dda0  3be00001    li r31,0x1                  
1001dda4  57e4063e    rlwinm r4,r31,0x0,0x18,0x1f 
1001dda8  28040000    cmplwi r4,0x0               
1001ddac  4182ffa4    beq 0x1001dd50                 ; -> 1001dd50
1001ddb0  480131a1    bl 0x10030f50                  ; -> 10030f50
1001ddb4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001ddb8  807e0000    lwz r3,0x0(r30)             
1001ddbc  4801437d    bl 0x10032138                  ; -> 10032138
1001ddc0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001ddc4  7fa3eb78    or r3,r29,r29               
1001ddc8  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1001ddcc  38210050    addi r1,r1,0x50             
1001ddd0  7c0803a6    mtspr LR,r0                 
1001ddd4  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001ddd8  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1001dddc  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1001dde0  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
1001dde4  4e800020    blr                         
