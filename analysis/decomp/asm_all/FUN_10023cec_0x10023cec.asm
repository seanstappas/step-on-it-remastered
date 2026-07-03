; FUN_10023cec @ 0x10023cec
10023cec  7c0802a6    mfspr r0,LR                 
10023cf0  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10023cf4  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10023cf8  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10023cfc  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
10023d00  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10023d04  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10023d08  7c7c1b78    or r28,r3,r3                
10023d0c  7c9d2378    or r29,r4,r4                
10023d10  7cbe2b78    or r30,r5,r5                
10023d14  3be26140    addi r31,r2,0x6140          
10023d18  7fa3eb78    or r3,r29,r29               
10023d1c  7fc4f378    or r4,r30,r30               
10023d20  4bfffdb1    bl 0x10023ad0                  ; -> 10023ad0
10023d24  7f840734    extsh r4,r28                
10023d28  1c84001c    mulli r4,r4,0x1c            
10023d2c  7c630734    extsh r3,r3                 
10023d30  7c7f212e    stwx r3,r31,r4              
10023d34  7fa3eb78    or r3,r29,r29               
10023d38  389e000c    addi r4,r30,0xc             
10023d3c  4bfffd95    bl 0x10023ad0                  ; -> 10023ad0
10023d40  7f850734    extsh r5,r28                
10023d44  1ca5001c    mulli r5,r5,0x1c            
10023d48  7c630734    extsh r3,r3                 
10023d4c  38a50004    addi r5,r5,0x4              
10023d50  7c7f292e    stwx r3,r31,r5              
10023d54  7fa3eb78    or r3,r29,r29               
10023d58  389e0018    addi r4,r30,0x18            
10023d5c  4bfffd75    bl 0x10023ad0                  ; -> 10023ad0
10023d60  7f860734    extsh r6,r28                
10023d64  1cc6001c    mulli r6,r6,0x1c            
10023d68  7c630734    extsh r3,r3                 
10023d6c  38c60008    addi r6,r6,0x8              
10023d70  7c7f312e    stwx r3,r31,r6              
10023d74  7fa3eb78    or r3,r29,r29               
10023d78  389e0024    addi r4,r30,0x24            
10023d7c  4bfffd55    bl 0x10023ad0                  ; -> 10023ad0
10023d80  7f870734    extsh r7,r28                
10023d84  1ce7001c    mulli r7,r7,0x1c            
10023d88  7c630734    extsh r3,r3                 
10023d8c  38e7000c    addi r7,r7,0xc              
10023d90  7c7f392e    stwx r3,r31,r7              
10023d94  7fa3eb78    or r3,r29,r29               
10023d98  389e0030    addi r4,r30,0x30            
10023d9c  4bfffd35    bl 0x10023ad0                  ; -> 10023ad0
10023da0  7f880734    extsh r8,r28                
10023da4  1d08001c    mulli r8,r8,0x1c            
10023da8  7c630734    extsh r3,r3                 
10023dac  39080010    addi r8,r8,0x10             
10023db0  7c7f412e    stwx r3,r31,r8              
10023db4  7fa3eb78    or r3,r29,r29               
10023db8  389e003c    addi r4,r30,0x3c            
10023dbc  4bfffd15    bl 0x10023ad0                  ; -> 10023ad0
10023dc0  7f890734    extsh r9,r28                
10023dc4  1d29001c    mulli r9,r9,0x1c            
10023dc8  7c630734    extsh r3,r3                 
10023dcc  39290014    addi r9,r9,0x14             
10023dd0  7c7f492e    stwx r3,r31,r9              
10023dd4  7fa3eb78    or r3,r29,r29               
10023dd8  389e0048    addi r4,r30,0x48            
10023ddc  4bfffcf5    bl 0x10023ad0                  ; -> 10023ad0
10023de0  7f8a0734    extsh r10,r28               
10023de4  1d4a001c    mulli r10,r10,0x1c          
10023de8  7c630734    extsh r3,r3                 
10023dec  394a0018    addi r10,r10,0x18           
10023df0  7c7f512e    stwx r3,r31,r10             
10023df4  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10023df8  38210050    addi r1,r1,0x50             
10023dfc  7c0803a6    mtspr LR,r0                 
10023e00  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10023e04  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10023e08  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10023e0c  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
10023e10  4e800020    blr                         
