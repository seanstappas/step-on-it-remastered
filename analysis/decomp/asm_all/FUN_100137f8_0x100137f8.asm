; FUN_100137f8 @ 0x100137f8
100137f8  7c0802a6    mfspr r0,LR                 
100137fc  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10013800  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10013804  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10013808  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1001380c  7c7f1b78    or r31,r3,r3                
10013810  7fe50734    extsh r5,r31                
10013814  38826840    addi r4,r2,0x6840           
10013818  1ca50070    mulli r5,r5,0x70            
1001381c  38840004    addi r4,r4,0x4              
10013820  7c642aae    lhax r3,r4,r5               
10013824  4801aed5    bl 0x1002e6f8                  ; -> 1002e6f8
10013828  60000000    ori r0,r0,0x0               
1001382c  7c7e1b78    or r30,r3,r3                
10013830  7fc3f378    or r3,r30,r30               
10013834  4801ae89    bl 0x1002e6bc                  ; -> 1002e6bc
10013838  60000000    ori r0,r0,0x0               
1001383c  7fe70734    extsh r7,r31                
10013840  38c26840    addi r6,r2,0x6840           
10013844  1ce70070    mulli r7,r7,0x70            
10013848  38630001    addi r3,r3,0x1              
1001384c  38c60004    addi r6,r6,0x4              
10013850  7c663b2e    sthx r3,r6,r7               
10013854  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10013858  38210040    addi r1,r1,0x40             
1001385c  7c0803a6    mtspr LR,r0                 
10013860  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10013864  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10013868  4e800020    blr                         
