; InitDialogs @ 0x10030f38
10030f38  8182f9b0    lwz r12,-0x650(r2)             ; -> 10033b20
10030f3c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10030f40  800c0000    lwz r0,0x0(r12)             
10030f44  804c0004    lwz r2,0x4(r12)             
10030f48  7c0903a6    mtspr CTR,r0                
10030f4c  4e800420    bctr                        
