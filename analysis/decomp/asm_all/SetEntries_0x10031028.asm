; SetEntries @ 0x10031028
10031028  8182f934    lwz r12,-0x6cc(r2)             ; -> 10033aa4
1003102c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031030  800c0000    lwz r0,0x0(r12)             
10031034  804c0004    lwz r2,0x4(r12)             
10031038  7c0903a6    mtspr CTR,r0                
1003103c  4e800420    bctr                        
