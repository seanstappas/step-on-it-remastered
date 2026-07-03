; DisposePtr @ 0x100315e0
100315e0  8182f808    lwz r12,-0x7f8(r2)             ; -> 10033978
100315e4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100315e8  800c0000    lwz r0,0x0(r12)             
100315ec  804c0004    lwz r2,0x4(r12)             
100315f0  7c0903a6    mtspr CTR,r0                
100315f4  4e800420    bctr                        
