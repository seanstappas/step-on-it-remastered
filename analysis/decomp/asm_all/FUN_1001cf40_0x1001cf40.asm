; FUN_1001cf40 @ 0x1001cf40
1001cf40  7c0802a6    mfspr r0,LR                 
1001cf44  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001cf48  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1001cf4c  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1001cf50  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001cf54  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1001cf58  3be25234    addi r31,r2,0x5234          
1001cf5c  3ba26140    addi r29,r2,0x6140          
1001cf60  3bc20df2    addi r30,r2,0xdf2           
1001cf64  807f0000    lwz r3,0x0(r31)             
1001cf68  38800004    li r4,0x4                   
1001cf6c  38a10044    addi r5,r1,0x44             
1001cf70  38c10040    addi r6,r1,0x40             
1001cf74  38e10038    addi r7,r1,0x38             
1001cf78  48014261    bl 0x100311d8                  ; -> 100311d8
1001cf7c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001cf80  80bd001c    lwz r5,0x1c(r29)            
1001cf84  80610040    lwz r3,0x40(r1)                ; -> Stack[-0x20]
1001cf88  7ca54670    srawi r5,r5,0x8             
1001cf8c  7ca50194    addze r5,r5                 
1001cf90  54a53032    rlwinm r5,r5,0x6,0x0,0x19   
1001cf94  7c9e2a14    add r4,r30,r5               
1001cf98  48014409    bl 0x100313a0                  ; -> 100313a0
1001cf9c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001cfa0  807f0000    lwz r3,0x0(r31)             
1001cfa4  38800005    li r4,0x5                   
1001cfa8  38a10044    addi r5,r1,0x44             
1001cfac  38c10040    addi r6,r1,0x40             
1001cfb0  38e10038    addi r7,r1,0x38             
1001cfb4  48014225    bl 0x100311d8                  ; -> 100311d8
1001cfb8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001cfbc  80dd0020    lwz r6,0x20(r29)            
1001cfc0  80610040    lwz r3,0x40(r1)                ; -> Stack[-0x20]
1001cfc4  7cc64670    srawi r6,r6,0x8             
1001cfc8  7cc60194    addze r6,r6                 
1001cfcc  54c63032    rlwinm r6,r6,0x6,0x0,0x19   
1001cfd0  7c9e3214    add r4,r30,r6               
1001cfd4  480143cd    bl 0x100313a0                  ; -> 100313a0
1001cfd8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001cfdc  807f0000    lwz r3,0x0(r31)             
1001cfe0  38800006    li r4,0x6                   
1001cfe4  38a10044    addi r5,r1,0x44             
1001cfe8  38c10040    addi r6,r1,0x40             
1001cfec  38e10038    addi r7,r1,0x38             
1001cff0  480141e9    bl 0x100311d8                  ; -> 100311d8
1001cff4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001cff8  80fd0024    lwz r7,0x24(r29)            
1001cffc  80610040    lwz r3,0x40(r1)                ; -> Stack[-0x20]
1001d000  7ce74670    srawi r7,r7,0x8             
1001d004  7ce70194    addze r7,r7                 
1001d008  54e73032    rlwinm r7,r7,0x6,0x0,0x19   
1001d00c  7c9e3a14    add r4,r30,r7               
1001d010  48014391    bl 0x100313a0                  ; -> 100313a0
1001d014  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d018  807f0000    lwz r3,0x0(r31)             
1001d01c  38800007    li r4,0x7                   
1001d020  38a10044    addi r5,r1,0x44             
1001d024  38c10040    addi r6,r1,0x40             
1001d028  38e10038    addi r7,r1,0x38             
1001d02c  480141ad    bl 0x100311d8                  ; -> 100311d8
1001d030  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d034  811d0028    lwz r8,0x28(r29)            
1001d038  80610040    lwz r3,0x40(r1)                ; -> Stack[-0x20]
1001d03c  7d084670    srawi r8,r8,0x8             
1001d040  7d080194    addze r8,r8                 
1001d044  55083032    rlwinm r8,r8,0x6,0x0,0x19   
1001d048  7c9e4214    add r4,r30,r8               
1001d04c  48014355    bl 0x100313a0                  ; -> 100313a0
1001d050  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d054  807f0000    lwz r3,0x0(r31)             
1001d058  38800008    li r4,0x8                   
1001d05c  38a10044    addi r5,r1,0x44             
1001d060  38c10040    addi r6,r1,0x40             
1001d064  38e10038    addi r7,r1,0x38             
1001d068  48014171    bl 0x100311d8                  ; -> 100311d8
1001d06c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d070  813d002c    lwz r9,0x2c(r29)            
1001d074  80610040    lwz r3,0x40(r1)                ; -> Stack[-0x20]
1001d078  7d294670    srawi r9,r9,0x8             
1001d07c  7d290194    addze r9,r9                 
1001d080  55293032    rlwinm r9,r9,0x6,0x0,0x19   
1001d084  7c9e4a14    add r4,r30,r9               
1001d088  48014319    bl 0x100313a0                  ; -> 100313a0
1001d08c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d090  807f0000    lwz r3,0x0(r31)             
1001d094  38800009    li r4,0x9                   
1001d098  38a10044    addi r5,r1,0x44             
1001d09c  38c10040    addi r6,r1,0x40             
1001d0a0  38e10038    addi r7,r1,0x38             
1001d0a4  48014135    bl 0x100311d8                  ; -> 100311d8
1001d0a8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d0ac  815d0030    lwz r10,0x30(r29)           
1001d0b0  80610040    lwz r3,0x40(r1)                ; -> Stack[-0x20]
1001d0b4  7d4a4670    srawi r10,r10,0x8           
1001d0b8  7d4a0194    addze r10,r10               
1001d0bc  554a3032    rlwinm r10,r10,0x6,0x0,0x19 
1001d0c0  7c9e5214    add r4,r30,r10              
1001d0c4  480142dd    bl 0x100313a0                  ; -> 100313a0
1001d0c8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d0cc  807f0000    lwz r3,0x0(r31)             
1001d0d0  3880000a    li r4,0xa                   
1001d0d4  38a10044    addi r5,r1,0x44             
1001d0d8  38c10040    addi r6,r1,0x40             
1001d0dc  38e10038    addi r7,r1,0x38             
1001d0e0  480140f9    bl 0x100311d8                  ; -> 100311d8
1001d0e4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d0e8  817d0034    lwz r11,0x34(r29)           
1001d0ec  80610040    lwz r3,0x40(r1)                ; -> Stack[-0x20]
1001d0f0  7d6b4670    srawi r11,r11,0x8           
1001d0f4  7d6b0194    addze r11,r11               
1001d0f8  556b3032    rlwinm r11,r11,0x6,0x0,0x19 
1001d0fc  7c9e5a14    add r4,r30,r11              
1001d100  480142a1    bl 0x100313a0                  ; -> 100313a0
1001d104  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d108  807f0000    lwz r3,0x0(r31)             
1001d10c  3880000b    li r4,0xb                   
1001d110  38a10044    addi r5,r1,0x44             
1001d114  38c10040    addi r6,r1,0x40             
1001d118  38e10038    addi r7,r1,0x38             
1001d11c  480140bd    bl 0x100311d8                  ; -> 100311d8
1001d120  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d124  819d0038    lwz r12,0x38(r29)           
1001d128  80610040    lwz r3,0x40(r1)                ; -> Stack[-0x20]
1001d12c  7d8c4670    srawi r12,r12,0x8           
1001d130  7d8c0194    addze r12,r12               
1001d134  558c3032    rlwinm r12,r12,0x6,0x0,0x19 
1001d138  7c9e6214    add r4,r30,r12              
1001d13c  48014265    bl 0x100313a0                  ; -> 100313a0
1001d140  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d144  807f0000    lwz r3,0x0(r31)             
1001d148  3880000c    li r4,0xc                   
1001d14c  38a10044    addi r5,r1,0x44             
1001d150  38c10040    addi r6,r1,0x40             
1001d154  38e10038    addi r7,r1,0x38             
1001d158  48014081    bl 0x100311d8                  ; -> 100311d8
1001d15c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d160  80bd003c    lwz r5,0x3c(r29)            
1001d164  80610040    lwz r3,0x40(r1)                ; -> Stack[-0x20]
1001d168  7ca54670    srawi r5,r5,0x8             
1001d16c  7ca50194    addze r5,r5                 
1001d170  54a53032    rlwinm r5,r5,0x6,0x0,0x19   
1001d174  7c9e2a14    add r4,r30,r5               
1001d178  48014229    bl 0x100313a0                  ; -> 100313a0
1001d17c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d180  807f0000    lwz r3,0x0(r31)             
1001d184  3880000d    li r4,0xd                   
1001d188  38a10044    addi r5,r1,0x44             
1001d18c  38c10040    addi r6,r1,0x40             
1001d190  38e10038    addi r7,r1,0x38             
1001d194  48014045    bl 0x100311d8                  ; -> 100311d8
1001d198  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d19c  80dd0040    lwz r6,0x40(r29)            
1001d1a0  80610040    lwz r3,0x40(r1)                ; -> Stack[-0x20]
1001d1a4  7cc64670    srawi r6,r6,0x8             
1001d1a8  7cc60194    addze r6,r6                 
1001d1ac  54c63032    rlwinm r6,r6,0x6,0x0,0x19   
1001d1b0  7c9e3214    add r4,r30,r6               
1001d1b4  480141ed    bl 0x100313a0                  ; -> 100313a0
1001d1b8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d1bc  807f0000    lwz r3,0x0(r31)             
1001d1c0  3880000e    li r4,0xe                   
1001d1c4  38a10044    addi r5,r1,0x44             
1001d1c8  38c10040    addi r6,r1,0x40             
1001d1cc  38e10038    addi r7,r1,0x38             
1001d1d0  48014009    bl 0x100311d8                  ; -> 100311d8
1001d1d4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d1d8  80fd0044    lwz r7,0x44(r29)            
1001d1dc  80610040    lwz r3,0x40(r1)                ; -> Stack[-0x20]
1001d1e0  7ce74670    srawi r7,r7,0x8             
1001d1e4  7ce70194    addze r7,r7                 
1001d1e8  54e73032    rlwinm r7,r7,0x6,0x0,0x19   
1001d1ec  7c9e3a14    add r4,r30,r7               
1001d1f0  480141b1    bl 0x100313a0                  ; -> 100313a0
1001d1f4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d1f8  807f0000    lwz r3,0x0(r31)             
1001d1fc  3880000f    li r4,0xf                   
1001d200  38a10044    addi r5,r1,0x44             
1001d204  38c10040    addi r6,r1,0x40             
1001d208  38e10038    addi r7,r1,0x38             
1001d20c  48013fcd    bl 0x100311d8                  ; -> 100311d8
1001d210  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d214  811d0048    lwz r8,0x48(r29)            
1001d218  80610040    lwz r3,0x40(r1)                ; -> Stack[-0x20]
1001d21c  7d084670    srawi r8,r8,0x8             
1001d220  7d080194    addze r8,r8                 
1001d224  55083032    rlwinm r8,r8,0x6,0x0,0x19   
1001d228  7c9e4214    add r4,r30,r8               
1001d22c  48014175    bl 0x100313a0                  ; -> 100313a0
1001d230  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d234  807f0000    lwz r3,0x0(r31)             
1001d238  38800010    li r4,0x10                  
1001d23c  38a10044    addi r5,r1,0x44             
1001d240  38c10040    addi r6,r1,0x40             
1001d244  38e10038    addi r7,r1,0x38             
1001d248  48013f91    bl 0x100311d8                  ; -> 100311d8
1001d24c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d250  813d004c    lwz r9,0x4c(r29)            
1001d254  80610040    lwz r3,0x40(r1)                ; -> Stack[-0x20]
1001d258  7d294670    srawi r9,r9,0x8             
1001d25c  7d290194    addze r9,r9                 
1001d260  55293032    rlwinm r9,r9,0x6,0x0,0x19   
1001d264  7c9e4a14    add r4,r30,r9               
1001d268  48014139    bl 0x100313a0                  ; -> 100313a0
1001d26c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d270  807f0000    lwz r3,0x0(r31)             
1001d274  38800011    li r4,0x11                  
1001d278  38a10044    addi r5,r1,0x44             
1001d27c  38c10040    addi r6,r1,0x40             
1001d280  38e10038    addi r7,r1,0x38             
1001d284  48013f55    bl 0x100311d8                  ; -> 100311d8
1001d288  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d28c  815d0050    lwz r10,0x50(r29)           
1001d290  80610040    lwz r3,0x40(r1)                ; -> Stack[-0x20]
1001d294  7d4a4670    srawi r10,r10,0x8           
1001d298  7d4a0194    addze r10,r10               
1001d29c  554a3032    rlwinm r10,r10,0x6,0x0,0x19 
1001d2a0  7c9e5214    add r4,r30,r10              
1001d2a4  480140fd    bl 0x100313a0                  ; -> 100313a0
1001d2a8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001d2ac  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1001d2b0  38210060    addi r1,r1,0x60             
1001d2b4  7c0803a6    mtspr LR,r0                 
1001d2b8  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001d2bc  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1001d2c0  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1001d2c4  4e800020    blr                         
