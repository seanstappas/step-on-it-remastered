; FUN_10015e90 @ 0x10015e90
10015e90  7c0802a6    mfspr r0,LR                 
10015e94  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
10015e98  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10015e9c  9421ff90    stwu r1,-0x70(r1)              ; -> Stack[-0x70]
10015ea0  90610088    stw r3,0x88(r1)                ; -> Stack[0x18]
10015ea4  7c9b2378    or r27,r4,r4                
10015ea8  7cbc2b78    or r28,r5,r5                
10015eac  3ba26bb8    addi r29,r2,0x6bb8          
10015eb0  80610088    lwz r3,0x88(r1)                ; -> Stack[0x18]
10015eb4  3bc00000    li r30,0x0                  
10015eb8  38810038    addi r4,r1,0x38             
10015ebc  48015a45    bl 0x1002b900                  ; -> 1002b900
10015ec0  60000000    ori r0,r0,0x0               
10015ec4  3be00009    li r31,0x9                  
10015ec8  480000a4    b 0x10015f6c                   ; -> 10015f6c
10015ecc  7fe30734    extsh r3,r31                
10015ed0  2c030000    cmpwi r3,0x0                
10015ed4  40820008    bne 0x10015edc                 ; -> 10015edc
10015ed8  3bc00001    li r30,0x1                  
10015edc  7fe40734    extsh r4,r31                
10015ee0  5484083c    rlwinm r4,r4,0x1,0x0,0x1e   
10015ee4  38a10038    addi r5,r1,0x38             
10015ee8  7ca522ae    lhax r5,r5,r4               
10015eec  2c050000    cmpwi r5,0x0                
10015ef0  40820044    bne 0x10015f34                 ; -> 10015f34
10015ef4  57c6063e    rlwinm r6,r30,0x0,0x18,0x1f 
10015ef8  28060000    cmplwi r6,0x0               
10015efc  4182006c    beq 0x10015f68                 ; -> 10015f68
10015f00  7fe70734    extsh r7,r31                
10015f04  393f0001    addi r9,r31,0x1             
10015f08  55291838    rlwinm r9,r9,0x3,0x0,0x1c   
10015f0c  54e7083c    rlwinm r7,r7,0x1,0x0,0x1e   
10015f10  39010038    addi r8,r1,0x38             
10015f14  7d083aae    lhax r8,r8,r7               
10015f18  807d0000    lwz r3,0x0(r29)             
10015f1c  38880005    addi r4,r8,0x5              
10015f20  7ca9d850    subf r5,r9,r27              
10015f24  7f86e378    or r6,r28,r28               
10015f28  4bfeece1    bl 0x10004c08                  ; -> 10004c08
10015f2c  60000000    ori r0,r0,0x0               
10015f30  48000038    b 0x10015f68                   ; -> 10015f68
10015f34  7fea0734    extsh r10,r31               
10015f38  399f0001    addi r12,r31,0x1            
10015f3c  558c1838    rlwinm r12,r12,0x3,0x0,0x1c 
10015f40  554a083c    rlwinm r10,r10,0x1,0x0,0x1e 
10015f44  39610038    addi r11,r1,0x38            
10015f48  7d6b52ae    lhax r11,r11,r10            
10015f4c  807d0000    lwz r3,0x0(r29)             
10015f50  3bc00001    li r30,0x1                  
10015f54  388b0005    addi r4,r11,0x5             
10015f58  7cacd850    subf r5,r12,r27             
10015f5c  7f86e378    or r6,r28,r28               
10015f60  4bfeeca9    bl 0x10004c08                  ; -> 10004c08
10015f64  60000000    ori r0,r0,0x0               
10015f68  3bffffff    subi r31,r31,0x1            
10015f6c  7fe30734    extsh r3,r31                
10015f70  2c030000    cmpwi r3,0x0                
10015f74  4080ff58    bge 0x10015ecc                 ; -> 10015ecc
10015f78  80010078    lwz r0,0x78(r1)                ; -> Stack[0x8]
10015f7c  38210070    addi r1,r1,0x70             
10015f80  7c0803a6    mtspr LR,r0                 
10015f84  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
10015f88  4e800020    blr                         
