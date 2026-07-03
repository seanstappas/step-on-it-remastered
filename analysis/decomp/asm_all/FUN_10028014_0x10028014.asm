; FUN_10028014 @ 0x10028014
10028014  7c0802a6    mfspr r0,LR                 
10028018  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002801c  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10028020  90610058    stw r3,0x58(r1)                ; -> Stack[0x18]
10028024  b081005e    sth r4,0x5e(r1)                ; -> Stack[0x1e]
10028028  b0a10062    sth r5,0x62(r1)                ; -> Stack[0x22]
1002802c  b0c10066    sth r6,0x66(r1)                ; -> Stack[0x26]
10028030  80610058    lwz r3,0x58(r1)                ; -> Stack[0x18]
10028034  a881005e    lha r4,0x5e(r1)                ; -> Stack[0x1e]
10028038  a8a10062    lha r5,0x62(r1)                ; -> Stack[0x22]
1002803c  a8c10066    lha r6,0x66(r1)                ; -> Stack[0x26]
10028040  38e00028    li r7,0x28                  
10028044  3900ffb0    li r8,-0x50                 
10028048  39200001    li r9,0x1                   
1002804c  4bfff871    bl 0x100278bc                  ; -> 100278bc
10028050  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10028054  38210040    addi r1,r1,0x40             
10028058  7c0803a6    mtspr LR,r0                 
1002805c  4e800020    blr                         
