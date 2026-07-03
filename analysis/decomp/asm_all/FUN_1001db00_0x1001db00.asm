; FUN_1001db00 @ 0x1001db00
1001db00  7c0802a6    mfspr r0,LR                 
1001db04  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001db08  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1001db0c  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1001db10  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
1001db14  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001db18  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1001db1c  3b825200    addi r28,r2,0x5200          
1001db20  3bc25218    addi r30,r2,0x5218          
1001db24  3ba00000    li r29,0x0                  
1001db28  38600001    li r3,0x1                   
1001db2c  4801373d    bl 0x10031268                  ; -> 10031268
1001db30  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001db34  807e0000    lwz r3,0x0(r30)             
1001db38  480145b9    bl 0x100320f0                  ; -> 100320f0
1001db3c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001db40  807e0000    lwz r3,0x0(r30)             
1001db44  480145c5    bl 0x10032108                  ; -> 10032108
1001db48  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001db4c  807e0000    lwz r3,0x0(r30)             
1001db50  480141e1    bl 0x10031d30                  ; -> 10031d30
1001db54  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001db58  3be00000    li r31,0x0                  
1001db5c  48000058    b 0x1001dbb4                   ; -> 1001dbb4
1001db60  807c0000    lwz r3,0x0(r28)             
1001db64  38810038    addi r4,r1,0x38             
1001db68  480145b9    bl 0x10032120                  ; -> 10032120
1001db6c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001db70  a8610038    lha r3,0x38(r1)                ; -> Stack[-0x18]
1001db74  2c030002    cmpwi r3,0x2                
1001db78  4182002c    beq 0x1001dba4                 ; -> 1001dba4
1001db7c  40800038    bge 0x1001dbb4                 ; -> 1001dbb4
1001db80  2c030001    cmpwi r3,0x1                
1001db84  40800008    bge 0x1001db8c                 ; -> 1001db8c
1001db88  4800002c    b 0x1001dbb4                   ; -> 1001dbb4
1001db8c  807e0000    lwz r3,0x0(r30)             
1001db90  480145a9    bl 0x10032138                  ; -> 10032138
1001db94  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001db98  3be00001    li r31,0x1                  
1001db9c  3ba00001    li r29,0x1                  
1001dba0  48000014    b 0x1001dbb4                   ; -> 1001dbb4
1001dba4  807e0000    lwz r3,0x0(r30)             
1001dba8  48014591    bl 0x10032138                  ; -> 10032138
1001dbac  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dbb0  3be00001    li r31,0x1                  
1001dbb4  57e4063e    rlwinm r4,r31,0x0,0x18,0x1f 
1001dbb8  28040000    cmplwi r4,0x0               
1001dbbc  4182ffa4    beq 0x1001db60                 ; -> 1001db60
1001dbc0  48013391    bl 0x10030f50                  ; -> 10030f50
1001dbc4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dbc8  807e0000    lwz r3,0x0(r30)             
1001dbcc  4801456d    bl 0x10032138                  ; -> 10032138
1001dbd0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dbd4  7fa3eb78    or r3,r29,r29               
1001dbd8  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1001dbdc  38210050    addi r1,r1,0x50             
1001dbe0  7c0803a6    mtspr LR,r0                 
1001dbe4  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001dbe8  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1001dbec  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1001dbf0  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
1001dbf4  4e800020    blr                         
