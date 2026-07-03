; FUN_10018394 @ 0x10018394
10018394  7c0802a6    mfspr r0,LR                 
10018398  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001839c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100183a0  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
100183a4  38624eda    addi r3,r2,0x4eda           
100183a8  88630000    lbz r3,0x0(r3)              
100183ac  28030000    cmplwi r3,0x0               
100183b0  41820050    beq 0x10018400                 ; -> 10018400
100183b4  480196f5    bl 0x10031aa8                  ; -> 10031aa8
100183b8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
100183bc  7c7f1b78    or r31,r3,r3                
100183c0  7fe40734    extsh r4,r31                
100183c4  2c040000    cmpwi r4,0x0                
100183c8  4182000c    beq 0x100183d4                 ; -> 100183d4
100183cc  48018d95    bl 0x10031160                  ; -> 10031160
100183d0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
100183d4  38c24ed8    addi r6,r2,0x4ed8           
100183d8  38a00000    li r5,0x0                   
100183dc  39024ee0    addi r8,r2,0x4ee0           
100183e0  98a60000    stb r5,0x0(r6)              
100183e4  38e00000    li r7,0x0                   
100183e8  39224ee4    addi r9,r2,0x4ee4           
100183ec  90e80000    stw r7,0x0(r8)              
100183f0  39624ede    addi r11,r2,0x4ede          
100183f4  90e90000    stw r7,0x0(r9)              
100183f8  39400000    li r10,0x0                  
100183fc  b14b0000    sth r10,0x0(r11)            
10018400  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10018404  38210040    addi r1,r1,0x40             
10018408  7c0803a6    mtspr LR,r0                 
1001840c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10018410  4e800020    blr                         
