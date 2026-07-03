; FUN_10027834 @ 0x10027834
10027834  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10027838  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1002783c  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10027840  38a26be8    addi r5,r2,0x6be8           
10027844  3bc26200    addi r30,r2,0x6200          
10027848  abe50000    lha r31,0x0(r5)             
1002784c  3ba0ffff    li r29,-0x1                 
10027850  4800004c    b 0x1002789c                   ; -> 1002789c
10027854  7fe70734    extsh r7,r31                
10027858  54e72036    rlwinm r7,r7,0x4,0x0,0x1b   
1002785c  7cfe3aae    lhax r7,r30,r7              
10027860  7c660734    extsh r6,r3                 
10027864  7c063800    cmpw r6,r7                  
10027868  40820024    bne 0x1002788c                 ; -> 1002788c
1002786c  7fe90734    extsh r9,r31                
10027870  55292036    rlwinm r9,r9,0x4,0x0,0x1b   
10027874  39290002    addi r9,r9,0x2              
10027878  7d3e4aae    lhax r9,r30,r9              
1002787c  7c880734    extsh r8,r4                 
10027880  7c084800    cmpw r8,r9                  
10027884  40820008    bne 0x1002788c                 ; -> 1002788c
10027888  7ffdfb78    or r29,r31,r31              
1002788c  7fea0734    extsh r10,r31               
10027890  554a2036    rlwinm r10,r10,0x4,0x0,0x1b 
10027894  394a000e    addi r10,r10,0xe            
10027898  7ffe52ae    lhax r31,r30,r10            
1002789c  7feb0734    extsh r11,r31               
100278a0  2c0bffff    cmpwi r11,-0x1              
100278a4  4082ffb0    bne 0x10027854                 ; -> 10027854
100278a8  7fa3eb78    or r3,r29,r29               
100278ac  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100278b0  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
100278b4  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
100278b8  4e800020    blr                         
