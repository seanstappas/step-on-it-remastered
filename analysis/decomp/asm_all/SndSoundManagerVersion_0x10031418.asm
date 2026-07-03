; SndSoundManagerVersion @ 0x10031418
10031418  8182f680    lwz r12,-0x980(r2)             ; -> 100337f0
1003141c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031420  800c0000    lwz r0,0x0(r12)             
10031424  804c0004    lwz r2,0x4(r12)             
10031428  7c0903a6    mtspr CTR,r0                
1003142c  4e800420    bctr                        
