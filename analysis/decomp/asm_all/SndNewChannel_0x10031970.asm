; SndNewChannel @ 0x10031970
10031970  8182f734    lwz r12,-0x8cc(r2)             ; -> 100338a4
10031974  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031978  800c0000    lwz r0,0x0(r12)             
1003197c  804c0004    lwz r2,0x4(r12)             
10031980  7c0903a6    mtspr CTR,r0                
10031984  4e800420    bctr                        
