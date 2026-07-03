; FUN_10025cf4 @ 0x10025cf4
10025cf4  7c0802a6    mfspr r0,LR                 
10025cf8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10025cfc  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10025d00  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10025d04  9421ff80    stwu r1,-0x80(r1)              ; -> Stack[-0x80]
10025d08  38625346    addi r3,r2,0x5346           
10025d0c  3be270ec    addi r31,r2,0x70ec          
10025d10  88630000    lbz r3,0x0(r3)              
10025d14  28030000    cmplwi r3,0x0               
10025d18  408200d8    bne 0x10025df0                 ; -> 10025df0
10025d1c  38600190    li r3,0x190                 
10025d20  480000e9    bl 0x10025e08                  ; -> 10025e08
10025d24  60000000    ori r0,r0,0x0               
10025d28  38827570    addi r4,r2,0x7570           
10025d2c  80640000    lwz r3,0x0(r4)              
10025d30  4800b491    bl 0x100311c0                  ; -> 100311c0
10025d34  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
10025d38  38a2756c    addi r5,r2,0x756c           
10025d3c  80650000    lwz r3,0x0(r5)              
10025d40  4800bd81    bl 0x10031ac0                  ; -> 10031ac0
10025d44  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
10025d48  38c00000    li r6,0x0                   
10025d4c  b0df0004    sth r6,0x4(r31)             
10025d50  38e00000    li r7,0x0                   
10025d54  b0ff0002    sth r7,0x2(r31)             
10025d58  39000000    li r8,0x0                   
10025d5c  b11f0000    sth r8,0x0(r31)             
10025d60  7fe3fb78    or r3,r31,r31               
10025d64  4800be35    bl 0x10031b98                  ; -> 10031b98
10025d68  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
10025d6c  3860000a    li r3,0xa                   
10025d70  4800bea1    bl 0x10031c10                  ; -> 10031c10
10025d74  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
10025d78  38600000    li r3,0x0                   
10025d7c  4800bead    bl 0x10031c28                  ; -> 10031c28
10025d80  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
10025d84  38600014    li r3,0x14                  
10025d88  4800beb9    bl 0x10031c40                  ; -> 10031c40
10025d8c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
10025d90  3860017c    li r3,0x17c                 
10025d94  38800050    li r4,0x50                  
10025d98  4800be61    bl 0x10031bf8                  ; -> 10031bf8
10025d9c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
10025da0  4800b631    bl 0x100313d0                  ; -> 100313d0
10025da4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
10025da8  7c635670    srawi r3,r3,0xa             
10025dac  7c630194    addze r3,r3                 
10025db0  7c7e1b78    or r30,r3,r3                
10025db4  7fc3f378    or r3,r30,r30               
10025db8  38810038    addi r4,r1,0x38             
10025dbc  4800be9d    bl 0x10031c58                  ; -> 10031c58
10025dc0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
10025dc4  39227568    addi r9,r2,0x7568           
10025dc8  80690000    lwz r3,0x0(r9)              
10025dcc  4800b3f5    bl 0x100311c0                  ; -> 100311c0
10025dd0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
10025dd4  39427564    addi r10,r2,0x7564          
10025dd8  806a0000    lwz r3,0x0(r10)             
10025ddc  4800bce5    bl 0x10031ac0                  ; -> 10031ac0
10025de0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
10025de4  39825346    addi r12,r2,0x5346          
10025de8  39600001    li r11,0x1                  
10025dec  996c0000    stb r11,0x0(r12)            
10025df0  80010088    lwz r0,0x88(r1)                ; -> Stack[0x8]
10025df4  38210080    addi r1,r1,0x80             
10025df8  7c0803a6    mtspr LR,r0                 
10025dfc  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10025e00  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10025e04  4e800020    blr                         
