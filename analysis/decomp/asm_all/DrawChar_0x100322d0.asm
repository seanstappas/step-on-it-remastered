; DrawChar @ 0x100322d0
100322d0  8182f9d0    lwz r12,-0x630(r2)             ; -> 10033b40
100322d4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100322d8  800c0000    lwz r0,0x0(r12)             
100322dc  804c0004    lwz r2,0x4(r12)             
100322e0  7c0903a6    mtspr CTR,r0                
100322e4  4e800420    bctr                        
