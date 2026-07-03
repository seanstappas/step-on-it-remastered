; FUN_10023770 @ 0x10023770
10023770  7c0802a6    mfspr r0,LR                 
10023774  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10023778  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1002377c  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10023780  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
10023784  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10023788  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1002378c  7c7e1b78    or r30,r3,r3                
10023790  3ba25336    addi r29,r2,0x5336          
10023794  3be2539c    addi r31,r2,0x539c          
10023798  38610038    addi r3,r1,0x38             
1002379c  4800da0d    bl 0x100311a8                  ; -> 100311a8
100237a0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
100237a4  38827570    addi r4,r2,0x7570           
100237a8  80640000    lwz r3,0x0(r4)              
100237ac  4800da15    bl 0x100311c0                  ; -> 100311c0
100237b0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
100237b4  38a2756c    addi r5,r2,0x756c           
100237b8  80650000    lwz r3,0x0(r5)              
100237bc  4800e305    bl 0x10031ac0                  ; -> 10031ac0
100237c0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
100237c4  7fc60734    extsh r6,r30                
100237c8  1cc60014    mulli r6,r6,0x14            
100237cc  38c60008    addi r6,r6,0x8              
100237d0  7cdf30ae    lbzx r6,r31,r6              
100237d4  28060000    cmplwi r6,0x0               
100237d8  41820018    beq 0x100237f0                 ; -> 100237f0
100237dc  7fc70734    extsh r7,r30                
100237e0  1ce70014    mulli r7,r7,0x14            
100237e4  38e70010    addi r7,r7,0x10             
100237e8  7f9f382e    lwzx r28,r31,r7             
100237ec  48000014    b 0x10023800                   ; -> 10023800
100237f0  7fc80734    extsh r8,r30                
100237f4  1d080014    mulli r8,r8,0x14            
100237f8  3908000c    addi r8,r8,0xc              
100237fc  7f9f402e    lwzx r28,r31,r8             
10023800  7fca0734    extsh r10,r30               
10023804  1d4a0014    mulli r10,r10,0x14          
10023808  7fc80734    extsh r8,r30                
1002380c  7fcc0734    extsh r12,r30               
10023810  1d080014    mulli r8,r8,0x14            
10023814  1d8c0014    mulli r12,r12,0x14          
10023818  39080004    addi r8,r8,0x4              
1002381c  398c0002    addi r12,r12,0x2            
10023820  a93d0002    lha r9,0x2(r29)             
10023824  7d5f52ae    lhax r10,r31,r10            
10023828  a8fd0002    lha r7,0x2(r29)             
1002382c  7c895214    add r4,r9,r10               
10023830  7fca0734    extsh r10,r30               
10023834  1d4a0014    mulli r10,r10,0x14          
10023838  7d1f42ae    lhax r8,r31,r8              
1002383c  394a0006    addi r10,r10,0x6            
10023840  a97d0000    lha r11,0x0(r29)            
10023844  7d9f62ae    lhax r12,r31,r12            
10023848  a93d0000    lha r9,0x0(r29)             
1002384c  7d5f52ae    lhax r10,r31,r10            
10023850  7cc74214    add r6,r7,r8                
10023854  3861003c    addi r3,r1,0x3c             
10023858  7cab6214    add r5,r11,r12              
1002385c  7ce95214    add r7,r9,r10               
10023860  4800e2d9    bl 0x10031b38                  ; -> 10031b38
10023864  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023868  3861003c    addi r3,r1,0x3c             
1002386c  7f84e378    or r4,r28,r28               
10023870  4800e449    bl 0x10031cb8                  ; -> 10031cb8
10023874  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023878  80610038    lwz r3,0x38(r1)                ; -> Stack[-0x28]
1002387c  4800d945    bl 0x100311c0                  ; -> 100311c0
10023880  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023884  39627564    addi r11,r2,0x7564          
10023888  806b0000    lwz r3,0x0(r11)             
1002388c  4800e235    bl 0x10031ac0                  ; -> 10031ac0
10023890  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023894  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
10023898  38210060    addi r1,r1,0x60             
1002389c  7c0803a6    mtspr LR,r0                 
100238a0  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100238a4  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
100238a8  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
100238ac  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
100238b0  4e800020    blr                         
