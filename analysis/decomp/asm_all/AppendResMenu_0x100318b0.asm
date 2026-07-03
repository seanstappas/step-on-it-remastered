; AppendResMenu @ 0x100318b0
100318b0  8182f8e8    lwz r12,-0x718(r2)             ; -> 10033a58
100318b4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100318b8  800c0000    lwz r0,0x0(r12)             
100318bc  804c0004    lwz r2,0x4(r12)             
100318c0  7c0903a6    mtspr CTR,r0                
100318c4  4e800420    bctr                        
