; TickCount @ 0x10030fc8
10030fc8  8182f7dc    lwz r12,-0x824(r2)             ; -> 1003394c
10030fcc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10030fd0  800c0000    lwz r0,0x0(r12)             
10030fd4  804c0004    lwz r2,0x4(r12)             
10030fd8  7c0903a6    mtspr CTR,r0                
10030fdc  4e800420    bctr                        
