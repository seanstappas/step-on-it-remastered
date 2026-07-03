; PBHGetVolParmsSync @ 0x100314c0
100314c0  8182f68c    lwz r12,-0x974(r2)             ; -> 100337fc
100314c4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100314c8  800c0000    lwz r0,0x0(r12)             
100314cc  804c0004    lwz r2,0x4(r12)             
100314d0  7c0903a6    mtspr CTR,r0                
100314d4  4e800420    bctr                        
