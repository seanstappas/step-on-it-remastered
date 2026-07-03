; FUN_100326a8 @ 0x100326a8
100326a8  800c0000    lwz r0,0x0(r12)             
100326ac  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100326b0  7c0903a6    mtspr CTR,r0                
100326b4  804c0004    lwz r2,0x4(r12)             
100326b8  4e800420    bctr                        
