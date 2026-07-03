; FUN_1001fe54 @ 0x1001fe54
1001fe54  7c0802a6    mfspr r0,LR                 
1001fe58  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001fe5c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001fe60  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1001fe64  480000cd    bl 0x1001ff30                  ; -> 1001ff30
1001fe68  60000000    ori r0,r0,0x0               
1001fe6c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1001fe70  28030000    cmplwi r3,0x0               
1001fe74  4082000c    bne 0x1001fe80                 ; -> 1001fe80
1001fe78  38600000    li r3,0x0                   
1001fe7c  480000a0    b 0x1001ff1c                   ; -> 1001ff1c
1001fe80  3c607174    lis r3,0x7174               
1001fe84  3863696d    addi r3,r3,0x696d           
1001fe88  3881004c    addi r4,r1,0x4c             
1001fe8c  480114cd    bl 0x10031358                  ; -> 10031358
1001fe90  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001fe94  7c7f1b78    or r31,r3,r3                
1001fe98  7fe30734    extsh r3,r31                
1001fe9c  2c030000    cmpwi r3,0x0                
1001fea0  4182000c    beq 0x1001feac                 ; -> 1001feac
1001fea4  38600000    li r3,0x0                   
1001fea8  48000074    b 0x1001ff1c                   ; -> 1001ff1c
1001feac  8081004c    lwz r4,0x4c(r1)                ; -> Stack[-0x14]
1001feb0  3ca00200    lis r5,0x200                
1001feb4  7c042800    cmpw r4,r5                  
1001feb8  4080000c    bge 0x1001fec4                 ; -> 1001fec4
1001febc  38600000    li r3,0x0                   
1001fec0  4800005c    b 0x1001ff1c                   ; -> 1001ff1c
1001fec4  3cc0696e    lis r6,0x696e               
1001fec8  38c67374    addi r6,r6,0x7374           
1001fecc  3ce07373    lis r7,0x7373               
1001fed0  3d006170    lis r8,0x6170               
1001fed4  90c10038    stw r6,0x38(r1)                ; -> Stack[-0x28]
1001fed8  38e72020    addi r7,r7,0x2020           
1001fedc  90e1003c    stw r7,0x3c(r1)                ; -> Stack[-0x24]
1001fee0  3908706c    addi r8,r8,0x706c           
1001fee4  91010040    stw r8,0x40(r1)                ; -> Stack[-0x20]
1001fee8  39200000    li r9,0x0                   
1001feec  91210044    stw r9,0x44(r1)                ; -> Stack[-0x1c]
1001fef0  39400000    li r10,0x0                  
1001fef4  91410048    stw r10,0x48(r1)               ; -> Stack[-0x18]
1001fef8  38600000    li r3,0x0                   
1001fefc  38810038    addi r4,r1,0x38             
1001ff00  48011531    bl 0x10031430                  ; -> 10031430
1001ff04  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001ff08  28030000    cmplwi r3,0x0               
1001ff0c  4182000c    beq 0x1001ff18                 ; -> 1001ff18
1001ff10  38600001    li r3,0x1                   
1001ff14  48000008    b 0x1001ff1c                   ; -> 1001ff1c
1001ff18  38600000    li r3,0x0                   
1001ff1c  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1001ff20  38210060    addi r1,r1,0x60             
1001ff24  7c0803a6    mtspr LR,r0                 
1001ff28  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001ff2c  4e800020    blr                         
