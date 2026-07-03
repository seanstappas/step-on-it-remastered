; FUN_10022628 @ 0x10022628
10022628  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002262c  90610018    stw r3,0x18(r1)                ; -> Stack[0x18]
10022630  7c850734    extsh r5,r4                 
10022634  a861001a    lha r3,0x1a(r1)                ; -> Stack[0x1a]
10022638  1ca50014    mulli r5,r5,0x14            
1002263c  3be2539c    addi r31,r2,0x539c          
10022640  7c630734    extsh r3,r3                 
10022644  7cbf2aae    lhax r5,r31,r5              
10022648  7c032800    cmpw r3,r5                  
1002264c  4081006c    ble 0x100226b8                 ; -> 100226b8
10022650  7c870734    extsh r7,r4                 
10022654  1ce70014    mulli r7,r7,0x14            
10022658  a8c1001a    lha r6,0x1a(r1)                ; -> Stack[0x1a]
1002265c  38e70004    addi r7,r7,0x4              
10022660  7cff3aae    lhax r7,r31,r7              
10022664  7cc60734    extsh r6,r6                 
10022668  7c063800    cmpw r6,r7                  
1002266c  4080004c    bge 0x100226b8                 ; -> 100226b8
10022670  7c890734    extsh r9,r4                 
10022674  1d290014    mulli r9,r9,0x14            
10022678  a9010018    lha r8,0x18(r1)                ; -> Stack[0x18]
1002267c  39290002    addi r9,r9,0x2              
10022680  7d3f4aae    lhax r9,r31,r9              
10022684  7d080734    extsh r8,r8                 
10022688  7c084800    cmpw r8,r9                  
1002268c  4081002c    ble 0x100226b8                 ; -> 100226b8
10022690  7c8b0734    extsh r11,r4                
10022694  1d6b0014    mulli r11,r11,0x14          
10022698  a9410018    lha r10,0x18(r1)               ; -> Stack[0x18]
1002269c  396b0006    addi r11,r11,0x6            
100226a0  7d7f5aae    lhax r11,r31,r11            
100226a4  7d4a0734    extsh r10,r10               
100226a8  7c0a5800    cmpw r10,r11                
100226ac  4080000c    bge 0x100226b8                 ; -> 100226b8
100226b0  38600001    li r3,0x1                   
100226b4  48000008    b 0x100226bc                   ; -> 100226bc
100226b8  38600000    li r3,0x0                   
100226bc  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100226c0  4e800020    blr                         
