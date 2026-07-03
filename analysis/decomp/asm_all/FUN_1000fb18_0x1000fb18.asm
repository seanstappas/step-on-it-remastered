; FUN_1000fb18 @ 0x1000fb18
1000fb18  7c0802a6    mfspr r0,LR                 
1000fb1c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1000fb20  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000fb24  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1000fb28  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000fb2c  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000fb30  38622f74    addi r3,r2,0x2f74           
1000fb34  3ba25332    addi r29,r2,0x5332          
1000fb38  88630000    lbz r3,0x0(r3)              
1000fb3c  3bc26bb8    addi r30,r2,0x6bb8          
1000fb40  28030000    cmplwi r3,0x0               
1000fb44  3be26840    addi r31,r2,0x6840          
1000fb48  41820120    beq 0x1000fc68                 ; -> 1000fc68
1000fb4c  388269fe    addi r4,r2,0x69fe           
1000fb50  88840000    lbz r4,0x0(r4)              
1000fb54  28040000    cmplwi r4,0x0               
1000fb58  41820110    beq 0x1000fc68                 ; -> 1000fc68
1000fb5c  807e0000    lwz r3,0x0(r30)             
1000fb60  3880000f    li r4,0xf                   
1000fb64  38a00140    li r5,0x140                 
1000fb68  38c00004    li r6,0x4                   
1000fb6c  4bff5049    bl 0x10004bb4                  ; -> 10004bb4
1000fb70  60000000    ori r0,r0,0x0               
1000fb74  a8bf00b6    lha r5,0xb6(r31)            
1000fb78  2c050000    cmpwi r5,0x0                
1000fb7c  4080001c    bge 0x1000fb98                 ; -> 1000fb98
1000fb80  38600000    li r3,0x0                   
1000fb84  3880015c    li r4,0x15c                 
1000fb88  38a00000    li r5,0x0                   
1000fb8c  4801e901    bl 0x1002e48c                  ; -> 1002e48c
1000fb90  60000000    ori r0,r0,0x0               
1000fb94  48000018    b 0x1000fbac                   ; -> 1000fbac
1000fb98  a87f00b6    lha r3,0xb6(r31)            
1000fb9c  3880015c    li r4,0x15c                 
1000fba0  38a00000    li r5,0x0                   
1000fba4  4801e8e9    bl 0x1002e48c                  ; -> 1002e48c
1000fba8  60000000    ori r0,r0,0x0               
1000fbac  a8df0126    lha r6,0x126(r31)           
1000fbb0  2c060000    cmpwi r6,0x0                
1000fbb4  4080001c    bge 0x1000fbd0                 ; -> 1000fbd0
1000fbb8  38600000    li r3,0x0                   
1000fbbc  3880015c    li r4,0x15c                 
1000fbc0  38a00010    li r5,0x10                  
1000fbc4  4801e8c9    bl 0x1002e48c                  ; -> 1002e48c
1000fbc8  60000000    ori r0,r0,0x0               
1000fbcc  48000018    b 0x1000fbe4                   ; -> 1000fbe4
1000fbd0  a87f0126    lha r3,0x126(r31)           
1000fbd4  3880015c    li r4,0x15c                 
1000fbd8  38a00010    li r5,0x10                  
1000fbdc  4801e8b1    bl 0x1002e48c                  ; -> 1002e48c
1000fbe0  60000000    ori r0,r0,0x0               
1000fbe4  807e0000    lwz r3,0x0(r30)             
1000fbe8  38800010    li r4,0x10                  
1000fbec  38a0016e    li r5,0x16e                 
1000fbf0  38c00004    li r6,0x4                   
1000fbf4  4bff4fc1    bl 0x10004bb4                  ; -> 10004bb4
1000fbf8  60000000    ori r0,r0,0x0               
1000fbfc  a87f00ba    lha r3,0xba(r31)            
1000fc00  38800184    li r4,0x184                 
1000fc04  38a00000    li r5,0x0                   
1000fc08  4801e885    bl 0x1002e48c                  ; -> 1002e48c
1000fc0c  60000000    ori r0,r0,0x0               
1000fc10  a87f012a    lha r3,0x12a(r31)           
1000fc14  38800184    li r4,0x184                 
1000fc18  38a00010    li r5,0x10                  
1000fc1c  4801e871    bl 0x1002e48c                  ; -> 1002e48c
1000fc20  60000000    ori r0,r0,0x0               
1000fc24  807e0000    lwz r3,0x0(r30)             
1000fc28  38800011    li r4,0x11                  
1000fc2c  38a001b8    li r5,0x1b8                 
1000fc30  38c00004    li r6,0x4                   
1000fc34  4bff4f81    bl 0x10004bb4                  ; -> 10004bb4
1000fc38  60000000    ori r0,r0,0x0               
1000fc3c  a87f00bc    lha r3,0xbc(r31)            
1000fc40  388001d4    li r4,0x1d4                 
1000fc44  38a00000    li r5,0x0                   
1000fc48  4801e845    bl 0x1002e48c                  ; -> 1002e48c
1000fc4c  60000000    ori r0,r0,0x0               
1000fc50  a87f012c    lha r3,0x12c(r31)           
1000fc54  388001d4    li r4,0x1d4                 
1000fc58  38a00010    li r5,0x10                  
1000fc5c  4801e831    bl 0x1002e48c                  ; -> 1002e48c
1000fc60  60000000    ori r0,r0,0x0               
1000fc64  480000dc    b 0x1000fd40                   ; -> 1000fd40
1000fc68  807e0000    lwz r3,0x0(r30)             
1000fc6c  3880000f    li r4,0xf                   
1000fc70  38a00140    li r5,0x140                 
1000fc74  38c00004    li r6,0x4                   
1000fc78  4bff4f3d    bl 0x10004bb4                  ; -> 10004bb4
1000fc7c  60000000    ori r0,r0,0x0               
1000fc80  a8fd0000    lha r7,0x0(r29)             
1000fc84  1ce70070    mulli r7,r7,0x70            
1000fc88  38e70046    addi r7,r7,0x46             
1000fc8c  7cff3aae    lhax r7,r31,r7              
1000fc90  2c070000    cmpwi r7,0x0                
1000fc94  4080001c    bge 0x1000fcb0                 ; -> 1000fcb0
1000fc98  38600000    li r3,0x0                   
1000fc9c  3880015c    li r4,0x15c                 
1000fca0  38a00008    li r5,0x8                   
1000fca4  4801e7e9    bl 0x1002e48c                  ; -> 1002e48c
1000fca8  60000000    ori r0,r0,0x0               
1000fcac  48000024    b 0x1000fcd0                   ; -> 1000fcd0
1000fcb0  a91d0000    lha r8,0x0(r29)             
1000fcb4  3880015c    li r4,0x15c                 
1000fcb8  1d080070    mulli r8,r8,0x70            
1000fcbc  39080046    addi r8,r8,0x46             
1000fcc0  7c7f42ae    lhax r3,r31,r8              
1000fcc4  38a00008    li r5,0x8                   
1000fcc8  4801e7c5    bl 0x1002e48c                  ; -> 1002e48c
1000fccc  60000000    ori r0,r0,0x0               
1000fcd0  807e0000    lwz r3,0x0(r30)             
1000fcd4  38800010    li r4,0x10                  
1000fcd8  38a0016e    li r5,0x16e                 
1000fcdc  38c00004    li r6,0x4                   
1000fce0  4bff4ed5    bl 0x10004bb4                  ; -> 10004bb4
1000fce4  60000000    ori r0,r0,0x0               
1000fce8  a93d0000    lha r9,0x0(r29)             
1000fcec  38800184    li r4,0x184                 
1000fcf0  1d290070    mulli r9,r9,0x70            
1000fcf4  3929004a    addi r9,r9,0x4a             
1000fcf8  7c7f4aae    lhax r3,r31,r9              
1000fcfc  38a00008    li r5,0x8                   
1000fd00  4801e78d    bl 0x1002e48c                  ; -> 1002e48c
1000fd04  60000000    ori r0,r0,0x0               
1000fd08  807e0000    lwz r3,0x0(r30)             
1000fd0c  38800011    li r4,0x11                  
1000fd10  38a001b8    li r5,0x1b8                 
1000fd14  38c00004    li r6,0x4                   
1000fd18  4bff4e9d    bl 0x10004bb4                  ; -> 10004bb4
1000fd1c  60000000    ori r0,r0,0x0               
1000fd20  a95d0000    lha r10,0x0(r29)            
1000fd24  388001d4    li r4,0x1d4                 
1000fd28  1d4a0070    mulli r10,r10,0x70          
1000fd2c  394a004c    addi r10,r10,0x4c           
1000fd30  7c7f52ae    lhax r3,r31,r10             
1000fd34  38a00008    li r5,0x8                   
1000fd38  4801e755    bl 0x1002e48c                  ; -> 1002e48c
1000fd3c  60000000    ori r0,r0,0x0               
1000fd40  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000fd44  38210050    addi r1,r1,0x50             
1000fd48  7c0803a6    mtspr LR,r0                 
1000fd4c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000fd50  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1000fd54  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1000fd58  4e800020    blr                         
