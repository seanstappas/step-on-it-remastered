; SetDialogCancelItem @ 0x10031328
10031328  8182f7d0    lwz r12,-0x830(r2)             ; -> 10033940
1003132c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031330  800c0000    lwz r0,0x0(r12)             
10031334  804c0004    lwz r2,0x4(r12)             
10031338  7c0903a6    mtspr CTR,r0                
1003133c  4e800420    bctr                        
