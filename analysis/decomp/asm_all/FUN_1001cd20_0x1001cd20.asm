; FUN_1001cd20 @ 0x1001cd20
1001cd20  7c0802a6    mfspr r0,LR                 
1001cd24  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
1001cd28  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001cd2c  9421fe90    stwu r1,-0x170(r1)             ; -> Stack[-0x170]
1001cd30  386269fe    addi r3,r2,0x69fe           
1001cd34  3b827128    addi r28,r2,0x7128          
1001cd38  88630000    lbz r3,0x0(r3)              
1001cd3c  3b62520c    addi r27,r2,0x520c          
1001cd40  28030000    cmplwi r3,0x0               
1001cd44  3be25224    addi r31,r2,0x5224          
1001cd48  41820020    beq 0x1001cd68                 ; -> 1001cd68
1001cd4c  38822f74    addi r4,r2,0x2f74           
1001cd50  88840000    lbz r4,0x0(r4)              
1001cd54  28040000    cmplwi r4,0x0               
1001cd58  41820010    beq 0x1001cd68                 ; -> 1001cd68
1001cd5c  38a2712a    addi r5,r2,0x712a           
1001cd60  aba50000    lha r29,0x0(r5)             
1001cd64  4800000c    b 0x1001cd70                   ; -> 1001cd70
1001cd68  38c2712c    addi r6,r2,0x712c           
1001cd6c  aba60000    lha r29,0x0(r6)             
1001cd70  7fa70734    extsh r7,r29                
1001cd74  2c070000    cmpwi r7,0x0                
1001cd78  40820018    bne 0x1001cd90                 ; -> 1001cd90
1001cd7c  3860019e    li r3,0x19e                 
1001cd80  38800000    li r4,0x0                   
1001cd84  480143c5    bl 0x10031148                  ; -> 10031148
1001cd88  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x15c]
1001cd8c  480001a0    b 0x1001cf2c                   ; -> 1001cf2c
1001cd90  a91c0000    lha r8,0x0(r28)             
1001cd94  7fa90734    extsh r9,r29                
1001cd98  7d080734    extsh r8,r8                 
1001cd9c  7c084800    cmpw r8,r9                  
1001cda0  4081000c    ble 0x1001cdac                 ; -> 1001cdac
1001cda4  39400001    li r10,0x1                  
1001cda8  b15c0000    sth r10,0x0(r28)            
1001cdac  807f0000    lwz r3,0x0(r31)             
1001cdb0  38800003    li r4,0x3                   
1001cdb4  38a10148    addi r5,r1,0x148            
1001cdb8  38c10144    addi r6,r1,0x144            
1001cdbc  38e1013c    addi r7,r1,0x13c            
1001cdc0  48014419    bl 0x100311d8                  ; -> 100311d8
1001cdc4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x15c]
1001cdc8  a87c0000    lha r3,0x0(r28)             
1001cdcc  3881003c    addi r4,r1,0x3c             
1001cdd0  48014e89    bl 0x10031c58                  ; -> 10031c58
1001cdd4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x15c]
1001cdd8  80610144    lwz r3,0x144(r1)               ; -> Stack[-0x2c]
1001cddc  3881003c    addi r4,r1,0x3c             
1001cde0  480145c1    bl 0x100313a0                  ; -> 100313a0
1001cde4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x15c]
1001cde8  807f0000    lwz r3,0x0(r31)             
1001cdec  38800003    li r4,0x3                   
1001cdf0  38a00000    li r5,0x0                   
1001cdf4  38c07fff    li r6,0x7fff                
1001cdf8  480145c1    bl 0x100313b8                  ; -> 100313b8
1001cdfc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x15c]
1001ce00  7fa30734    extsh r3,r29                
1001ce04  3881003c    addi r4,r1,0x3c             
1001ce08  48014e51    bl 0x10031c58                  ; -> 10031c58
1001ce0c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x15c]
1001ce10  3861003c    addi r3,r1,0x3c             
1001ce14  3882ffe4    subi r4,r2,0x1c             
1001ce18  38a2ffe4    subi r5,r2,0x1c             
1001ce1c  38c2ffe4    subi r6,r2,0x1c             
1001ce20  48014311    bl 0x10031130                  ; -> 10031130
1001ce24  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x15c]
1001ce28  807f0000    lwz r3,0x0(r31)             
1001ce2c  480152c5    bl 0x100320f0                  ; -> 100320f0
1001ce30  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x15c]
1001ce34  807f0000    lwz r3,0x0(r31)             
1001ce38  480152d1    bl 0x10032108                  ; -> 10032108
1001ce3c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x15c]
1001ce40  807f0000    lwz r3,0x0(r31)             
1001ce44  48014eed    bl 0x10031d30                  ; -> 10031d30
1001ce48  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x15c]
1001ce4c  3bc00000    li r30,0x0                  
1001ce50  480000bc    b 0x1001cf0c                   ; -> 1001cf0c
1001ce54  807b0000    lwz r3,0x0(r27)             
1001ce58  3881014a    addi r4,r1,0x14a            
1001ce5c  480152c5    bl 0x10032120                  ; -> 10032120
1001ce60  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x15c]
1001ce64  a961014a    lha r11,0x14a(r1)              ; -> Stack[-0x26]
1001ce68  2c0b0002    cmpwi r11,0x2               
1001ce6c  41820090    beq 0x1001cefc                 ; -> 1001cefc
1001ce70  4080009c    bge 0x1001cf0c                 ; -> 1001cf0c
1001ce74  2c0b0001    cmpwi r11,0x1               
1001ce78  40800008    bge 0x1001ce80                 ; -> 1001ce80
1001ce7c  48000090    b 0x1001cf0c                   ; -> 1001cf0c
1001ce80  807f0000    lwz r3,0x0(r31)             
1001ce84  480152b5    bl 0x10032138                  ; -> 10032138
1001ce88  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x15c]
1001ce8c  807f0000    lwz r3,0x0(r31)             
1001ce90  3bc00001    li r30,0x1                  
1001ce94  38800003    li r4,0x3                   
1001ce98  38a10148    addi r5,r1,0x148            
1001ce9c  38c10144    addi r6,r1,0x144            
1001cea0  38e1013c    addi r7,r1,0x13c            
1001cea4  48014335    bl 0x100311d8                  ; -> 100311d8
1001cea8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x15c]
1001ceac  80610144    lwz r3,0x144(r1)               ; -> Stack[-0x2c]
1001ceb0  3881003c    addi r4,r1,0x3c             
1001ceb4  48015525    bl 0x100323d8                  ; -> 100323d8
1001ceb8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x15c]
1001cebc  3861003c    addi r3,r1,0x3c             
1001cec0  38810038    addi r4,r1,0x38             
1001cec4  4801552d    bl 0x100323f0                  ; -> 100323f0
1001cec8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x15c]
1001cecc  81810038    lwz r12,0x38(r1)               ; -> Stack[-0x138]
1001ced0  7d8c0734    extsh r12,r12               
1001ced4  2c0c0001    cmpwi r12,0x1               
1001ced8  41800034    blt 0x1001cf0c                 ; -> 1001cf0c
1001cedc  80610038    lwz r3,0x38(r1)                ; -> Stack[-0x138]
1001cee0  7fa40734    extsh r4,r29                
1001cee4  7c630734    extsh r3,r3                 
1001cee8  7c032000    cmpw r3,r4                  
1001ceec  41810020    bgt 0x1001cf0c                 ; -> 1001cf0c
1001cef0  80a10038    lwz r5,0x38(r1)                ; -> Stack[-0x138]
1001cef4  b0bc0000    sth r5,0x0(r28)             
1001cef8  48000014    b 0x1001cf0c                   ; -> 1001cf0c
1001cefc  807f0000    lwz r3,0x0(r31)             
1001cf00  48015239    bl 0x10032138                  ; -> 10032138
1001cf04  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x15c]
1001cf08  3bc00001    li r30,0x1                  
1001cf0c  57c6063e    rlwinm r6,r30,0x0,0x18,0x1f 
1001cf10  28060000    cmplwi r6,0x0               
1001cf14  4182ff40    beq 0x1001ce54                 ; -> 1001ce54
1001cf18  807f0000    lwz r3,0x0(r31)             
1001cf1c  4801521d    bl 0x10032138                  ; -> 10032138
1001cf20  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x15c]
1001cf24  4801402d    bl 0x10030f50                  ; -> 10030f50
1001cf28  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x15c]
1001cf2c  80010178    lwz r0,0x178(r1)               ; -> Stack[0x8]
1001cf30  38210170    addi r1,r1,0x170            
1001cf34  7c0803a6    mtspr LR,r0                 
1001cf38  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
1001cf3c  4e800020    blr                         
