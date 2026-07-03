; FUN_1001dde8 @ 0x1001dde8
1001dde8  7c0802a6    mfspr r0,LR                 
1001ddec  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001ddf0  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1001ddf4  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1001ddf8  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001ddfc  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1001de00  3bc2522c    addi r30,r2,0x522c          
1001de04  3ba00000    li r29,0x0                  
1001de08  38600001    li r3,0x1                   
1001de0c  4801345d    bl 0x10031268                  ; -> 10031268
1001de10  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001de14  807e0000    lwz r3,0x0(r30)             
1001de18  480142d9    bl 0x100320f0                  ; -> 100320f0
1001de1c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001de20  807e0000    lwz r3,0x0(r30)             
1001de24  480142e5    bl 0x10032108                  ; -> 10032108
1001de28  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001de2c  807e0000    lwz r3,0x0(r30)             
1001de30  48013f01    bl 0x10031d30                  ; -> 10031d30
1001de34  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001de38  3be00000    li r31,0x0                  
1001de3c  48000058    b 0x1001de94                   ; -> 1001de94
1001de40  38600000    li r3,0x0                   
1001de44  38810038    addi r4,r1,0x38             
1001de48  480142d9    bl 0x10032120                  ; -> 10032120
1001de4c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001de50  a8610038    lha r3,0x38(r1)                ; -> Stack[-0x18]
1001de54  2c030002    cmpwi r3,0x2                
1001de58  4182002c    beq 0x1001de84                 ; -> 1001de84
1001de5c  40800038    bge 0x1001de94                 ; -> 1001de94
1001de60  2c030001    cmpwi r3,0x1                
1001de64  40800008    bge 0x1001de6c                 ; -> 1001de6c
1001de68  4800002c    b 0x1001de94                   ; -> 1001de94
1001de6c  807e0000    lwz r3,0x0(r30)             
1001de70  480142c9    bl 0x10032138                  ; -> 10032138
1001de74  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001de78  3be00001    li r31,0x1                  
1001de7c  3ba00001    li r29,0x1                  
1001de80  48000014    b 0x1001de94                   ; -> 1001de94
1001de84  807e0000    lwz r3,0x0(r30)             
1001de88  480142b1    bl 0x10032138                  ; -> 10032138
1001de8c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001de90  3be00001    li r31,0x1                  
1001de94  57e4063e    rlwinm r4,r31,0x0,0x18,0x1f 
1001de98  28040000    cmplwi r4,0x0               
1001de9c  4182ffa4    beq 0x1001de40                 ; -> 1001de40
1001dea0  480130b1    bl 0x10030f50                  ; -> 10030f50
1001dea4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dea8  807e0000    lwz r3,0x0(r30)             
1001deac  4801428d    bl 0x10032138                  ; -> 10032138
1001deb0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001deb4  7fa3eb78    or r3,r29,r29               
1001deb8  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1001debc  38210050    addi r1,r1,0x50             
1001dec0  7c0803a6    mtspr LR,r0                 
1001dec4  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001dec8  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1001decc  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1001ded0  4e800020    blr                         
