; DisposeGDevice @ 0x10032618
10032618  8182f97c    lwz r12,-0x684(r2)             ; -> 10033aec
1003261c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10032620  800c0000    lwz r0,0x0(r12)             
10032624  804c0004    lwz r2,0x4(r12)             
10032628  7c0903a6    mtspr CTR,r0                
1003262c  4e800420    bctr                        
