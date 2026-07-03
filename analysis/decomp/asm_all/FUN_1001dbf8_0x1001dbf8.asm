; FUN_1001dbf8 @ 0x1001dbf8
1001dbf8  7c0802a6    mfspr r0,LR                 
1001dbfc  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001dc00  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1001dc04  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1001dc08  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
1001dc0c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001dc10  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1001dc14  3bc25238    addi r30,r2,0x5238          
1001dc18  3b825200    addi r28,r2,0x5200          
1001dc1c  3ba00000    li r29,0x0                  
1001dc20  38600001    li r3,0x1                   
1001dc24  48013645    bl 0x10031268                  ; -> 10031268
1001dc28  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dc2c  807e0000    lwz r3,0x0(r30)             
1001dc30  480144c1    bl 0x100320f0                  ; -> 100320f0
1001dc34  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dc38  807e0000    lwz r3,0x0(r30)             
1001dc3c  480144cd    bl 0x10032108                  ; -> 10032108
1001dc40  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dc44  807e0000    lwz r3,0x0(r30)             
1001dc48  480140e9    bl 0x10031d30                  ; -> 10031d30
1001dc4c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dc50  3be00000    li r31,0x0                  
1001dc54  48000058    b 0x1001dcac                   ; -> 1001dcac
1001dc58  807c0000    lwz r3,0x0(r28)             
1001dc5c  38810038    addi r4,r1,0x38             
1001dc60  480144c1    bl 0x10032120                  ; -> 10032120
1001dc64  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dc68  a8610038    lha r3,0x38(r1)                ; -> Stack[-0x18]
1001dc6c  2c030002    cmpwi r3,0x2                
1001dc70  4182002c    beq 0x1001dc9c                 ; -> 1001dc9c
1001dc74  40800038    bge 0x1001dcac                 ; -> 1001dcac
1001dc78  2c030001    cmpwi r3,0x1                
1001dc7c  40800008    bge 0x1001dc84                 ; -> 1001dc84
1001dc80  4800002c    b 0x1001dcac                   ; -> 1001dcac
1001dc84  807e0000    lwz r3,0x0(r30)             
1001dc88  480144b1    bl 0x10032138                  ; -> 10032138
1001dc8c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dc90  3be00001    li r31,0x1                  
1001dc94  3ba00001    li r29,0x1                  
1001dc98  48000014    b 0x1001dcac                   ; -> 1001dcac
1001dc9c  807e0000    lwz r3,0x0(r30)             
1001dca0  48014499    bl 0x10032138                  ; -> 10032138
1001dca4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dca8  3be00001    li r31,0x1                  
1001dcac  57e4063e    rlwinm r4,r31,0x0,0x18,0x1f 
1001dcb0  28040000    cmplwi r4,0x0               
1001dcb4  4182ffa4    beq 0x1001dc58                 ; -> 1001dc58
1001dcb8  48013299    bl 0x10030f50                  ; -> 10030f50
1001dcbc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dcc0  807e0000    lwz r3,0x0(r30)             
1001dcc4  48014475    bl 0x10032138                  ; -> 10032138
1001dcc8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dccc  7fa3eb78    or r3,r29,r29               
1001dcd0  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1001dcd4  38210050    addi r1,r1,0x50             
1001dcd8  7c0803a6    mtspr LR,r0                 
1001dcdc  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001dce0  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1001dce4  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1001dce8  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
1001dcec  4e800020    blr                         
