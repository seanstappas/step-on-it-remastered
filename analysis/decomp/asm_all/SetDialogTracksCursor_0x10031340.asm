; SetDialogTracksCursor @ 0x10031340
10031340  8182f7f4    lwz r12,-0x80c(r2)             ; -> 10033964
10031344  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031348  800c0000    lwz r0,0x0(r12)             
1003134c  804c0004    lwz r2,0x4(r12)             
10031350  7c0903a6    mtspr CTR,r0                
10031354  4e800420    bctr                        
