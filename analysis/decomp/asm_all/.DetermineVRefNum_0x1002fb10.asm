; .DetermineVRefNum @ 0x1002fb10
1002fb10  7c0802a6    mfspr r0,LR                 
1002fb14  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002fb18  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002fb1c  9421ff40    stwu r1,-0xc0(r1)              ; -> Stack[-0xc0]
1002fb20  906100d8    stw r3,0xd8(r1)                ; -> Stack[0x18]
1002fb24  b08100de    sth r4,0xde(r1)                ; -> Stack[0x1e]
1002fb28  90a100e0    stw r5,0xe0(r1)                ; -> Stack[0x20]
1002fb2c  806100d8    lwz r3,0xd8(r1)                ; -> Stack[0x18]
1002fb30  a88100de    lha r4,0xde(r1)                ; -> Stack[0x1e]
1002fb34  38a10038    addi r5,r1,0x38             
1002fb38  4bfffef9    bl 0x1002fa30                  ; -> 1002fa30
1002fb3c  7c7f1b78    or r31,r3,r3                
1002fb40  a861004e    lha r3,0x4e(r1)                ; -> Stack[-0x72]
1002fb44  808100e0    lwz r4,0xe0(r1)                ; -> Stack[0x20]
1002fb48  b0640000    sth r3,0x0(r4)              
1002fb4c  7fe3fb78    or r3,r31,r31               
1002fb50  800100c8    lwz r0,0xc8(r1)                ; -> Stack[0x8]
1002fb54  382100c0    addi r1,r1,0xc0             
1002fb58  7c0803a6    mtspr LR,r0                 
1002fb5c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002fb60  4e800020    blr                         
