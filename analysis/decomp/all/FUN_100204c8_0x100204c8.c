
void FUN_100204c8(void)

{
  undefined **ppuVar1;
  short sVar4;
  int *piVar2;
  undefined4 *puVar3;
  undefined4 *puVar5;
  int iVar6;
  undefined **local_5c;
  undefined2 local_38;
  short local_36 [9];
  
  if (((DAT_100393b0 != '\0') || (DAT_100393af != '\0')) || (DAT_100393ae != '\0')) {
    sVar4 = FUN_1002e990(0x53734178,0x53735066,local_36);
    if (sVar4 == 0) {
      ppuVar1 = &_toc;
      if (DAT_100393b0 != '\0') {
        piVar2 = (int *).glue::NewHandle(0x20);
        if (piVar2 == (int *)0x0) {
          FUN_1002ea68((int)local_36[0]);
          FUN_100192f8(6);
        }
        *(short *)*piVar2 = (short)local_5c[0x13d3];
        *(undefined1 *)(*piVar2 + 2) = *(undefined1 *)((int)local_5c + 0x4fe5);
        *(undefined1 *)(*piVar2 + 0xc) = *(undefined1 *)(local_5c + 0x13f9);
        *(undefined1 *)(*piVar2 + 0xd) = *(undefined1 *)((int)local_5c + 0x51e6);
        *(undefined2 *)(*piVar2 + 4) = *(undefined2 *)(local_5c + 0x13b7);
        *(undefined4 *)(*piVar2 + 6) = *(undefined4 *)((int)local_5c + 0x7116);
        *(undefined1 *)(*piVar2 + 10) = *(undefined1 *)((int)local_5c + 0x523d);
        *(undefined1 *)(*piVar2 + 0xb) = *(undefined1 *)((int)local_5c + 0x342e);
        local_38 = 400;
        FUN_1002ef44((int)local_36[0],0x53735052,&local_38,piVar2);
        .glue::DisposeHandle(piVar2);
        ppuVar1 = local_5c;
      }
      if (*(char *)((int)ppuVar1 + 0x523f) != '\0') {
        puVar3 = (undefined4 *).glue::NewHandle(0x40);
        if (puVar3 == (undefined4 *)0x0) {
          FUN_1002ea68((int)local_36[0]);
          FUN_100192f8(6);
        }
        .glue::MoveHHi(puVar3);
        .glue::HLock(puVar3);
        puVar5 = (undefined4 *)*puVar3;
        *puVar5 = uRam1003ab22;
        puVar5[1] = uRam1003ab26;
        puVar5[2] = uRam1003ab2a;
        puVar5[3] = uRam1003ab2e;
        puVar5[4] = uRam1003ab32;
        puVar5[5] = uRam1003ab36;
        puVar5[6] = uRam1003ab3a;
        puVar5[7] = uRam1003ab3e;
        puVar5[8] = uRam1003ab42;
        puVar5[9] = uRam1003ab46;
        puVar5[10] = uRam1003ab4a;
        puVar5[0xb] = uRam1003ab4e;
        puVar5[0xc] = uRam1003ab52;
        puVar5[0xd] = uRam1003ab56;
        .glue::HUnlock(puVar3);
        local_38 = 400;
        FUN_1002ef44((int)local_36[0],0x53734b50,&local_38,puVar3);
        .glue::DisposeHandle(puVar3);
        ppuVar1 = local_5c;
      }
      if (*(char *)((int)ppuVar1 + 0x523e) != '\0') {
        piVar2 = (int *).glue::NewHandle(0xa28);
        if (piVar2 == (int *)0x0) {
          FUN_1002ea68((int)local_36[0]);
          FUN_100192f8(6);
        }
        .glue::MoveHHi(piVar2);
        .glue::HLock(piVar2);
        iVar6 = *piVar2;
        for (sVar4 = 1; sVar4 < 0xb; sVar4 = sVar4 + 1) {
          FUN_10026fd8(&DAT_10039782 + sVar4 * 0x104,iVar6);
          *(undefined4 *)(iVar6 + 0x100) = *(undefined4 *)(sVar4 * 0x104 + 0x10039882);
          iVar6 = iVar6 + 0x104;
        }
        .glue::HUnlock(piVar2);
        local_38 = 400;
        FUN_1002ef44((int)local_36[0],0x53734853,&local_38,piVar2);
      }
    }
  }
  return;
}

