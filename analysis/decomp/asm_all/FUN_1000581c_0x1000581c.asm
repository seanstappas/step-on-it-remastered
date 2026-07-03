; FUN_1000581c @ 0x1000581c
1000581c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10005820  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10005824  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10005828  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
1000582c  38c23be6    addi r6,r2,0x3be6           
10005830  39023be4    addi r8,r2,0x3be4           
10005834  39823be2    addi r12,r2,0x3be2          
10005838  a8c60000    lha r6,0x0(r6)              
1000583c  7c650734    extsh r5,r3                 
10005840  7fe53050    subf r31,r5,r6              
10005844  38c23be0    addi r6,r2,0x3be0           
10005848  a9080000    lha r8,0x0(r8)              
1000584c  7c870734    extsh r7,r4                 
10005850  7fc74050    subf r30,r7,r8              
10005854  7d3ff9d6    mullw r9,r31,r31            
10005858  7d5ef1d6    mullw r10,r30,r30           
1000585c  a98c0000    lha r12,0x0(r12)            
10005860  7c6b0734    extsh r11,r3                
10005864  7feb6050    subf r31,r11,r12            
10005868  a8c60000    lha r6,0x0(r6)              
1000586c  7c850734    extsh r5,r4                 
10005870  7fc53050    subf r30,r5,r6              
10005874  7cfff9d6    mullw r7,r31,r31            
10005878  7d1ef1d6    mullw r8,r30,r30            
1000587c  7fa95214    add r29,r9,r10              
10005880  7f874214    add r28,r7,r8               
10005884  7c1de000    cmpw r29,r28                
10005888  4080000c    bge 0x10005894                 ; -> 10005894
1000588c  38600001    li r3,0x1                   
10005890  48000008    b 0x10005898                   ; -> 10005898
10005894  38600002    li r3,0x2                   
10005898  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000589c  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
100058a0  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
100058a4  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
100058a8  4e800020    blr                         
