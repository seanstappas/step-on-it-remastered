; NewRgn @ 0x10031b50
10031b50  8182f984    lwz r12,-0x67c(r2)             ; -> 10033af4
10031b54  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031b58  800c0000    lwz r0,0x0(r12)             
10031b5c  804c0004    lwz r2,0x4(r12)             
10031b60  7c0903a6    mtspr CTR,r0                
10031b64  4e800420    bctr                        
