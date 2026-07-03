
/* WARNING: Removing unreachable block (ram,0x10020288) */
/* WARNING: Removing unreachable block (ram,0x10020378) */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1001ff7c(void)

{
  char cVar3;
  short sVar2;
  undefined4 *puVar1;
  undefined4 *puVar4;
  undefined4 uVar5;
  int iVar6;
  int local_26c;
  undefined4 auStack_250 [2];
  undefined4 local_248 [62];
  undefined4 auStack_150 [2];
  undefined4 local_148 [64];
  undefined1 auStack_48 [4];
  undefined4 local_44;
  undefined1 auStack_40 [2];
  undefined2 local_3e;
  int *local_3c;
  undefined4 *local_38;
  int *local_34;
  short local_30 [10];
  
  iVar6 = 0x20;
  puVar1 = (undefined4 *)0x1003924e;
  puVar4 = auStack_150;
  do {
    uVar5 = puVar1[3];
    puVar4[2] = puVar1[2];
    puVar4[3] = uVar5;
    iVar6 = iVar6 + -1;
    puVar1 = puVar1 + 2;
    puVar4 = puVar4 + 2;
  } while (iVar6 != 0);
  iVar6 = 0x20;
  puVar1 = (undefined4 *)0x1003914e;
  puVar4 = auStack_250;
  do {
    uVar5 = puVar1[3];
    puVar4[2] = puVar1[2];
    puVar4[3] = uVar5;
    iVar6 = iVar6 + -1;
    puVar1 = puVar1 + 2;
    puVar4 = puVar4 + 2;
  } while (iVar6 != 0);
  cVar3 = FUN_1002eb2c(0x53734178,0x53735066);
  if (cVar3 == '\0') {
    FUN_1002082c();
  }
  sVar2 = FUN_1002e990(0x53734178,0x53735066,local_30);
  if (sVar2 != 0) {
    FUN_10020d74();
    return;
  }
  .glue::UseResFile((int)_DAT_10039360);
  puVar1 = (undefined4 *).glue::Get1Resource(0x76657273,1);
  if (puVar1 == (undefined4 *)0x0) {
    local_44 = 0x1008006;
  }
  else {
    local_44 = *(undefined4 *)*puVar1;
  }
  FUN_1002eb80((int)local_30[0],1,auStack_48,auStack_40,local_148,local_248);
  cVar3 = FUN_10020450(auStack_48,&local_44);
  sVar2 = 0;
  if (cVar3 != '\0') {
    FUN_1002ea68((int)local_30[0]);
    sVar2 = FUN_1002eacc(0x53734178,0x53735066);
    if (sVar2 != 0) {
      FUN_10020d74();
      return;
    }
    FUN_1002082c();
    sVar2 = FUN_1002e990(0x53734178,0x53735066,local_30);
    if (sVar2 != 0) {
      FUN_10020d74();
      return;
    }
  }
  local_3e = 400;
  FUN_1002edf0((int)local_30[0],0x53735052,&local_3e,&local_34);
  if (sVar2 == 0) {
    *(int *)(local_26c + 0x4f4c) = (int)*(short *)*local_34;
    *(undefined1 *)(local_26c + 0x4fe5) = *(undefined1 *)(*local_34 + 2);
    *(undefined1 *)(local_26c + 0x4fe4) = *(undefined1 *)(*local_34 + 0xc);
    *(undefined1 *)(local_26c + 0x51e6) = *(undefined1 *)(*local_34 + 0xd);
    *(undefined2 *)(local_26c + 0x4edc) = *(undefined2 *)(*local_34 + 4);
    *(undefined1 *)(local_26c + 0x523d) = *(undefined1 *)(*local_34 + 10);
    *(undefined4 *)(local_26c + 0x7116) = *(undefined4 *)(*local_34 + 6);
    *(undefined1 *)(local_26c + 0x342e) = *(undefined1 *)(*local_34 + 0xb);
    .glue::DisposeHandle(local_34);
    local_3e = 400;
    FUN_1002edf0((int)local_30[0],0x53734b50,&local_3e,&local_38);
    .glue::MoveHHi(local_38);
    .glue::HLock(local_38);
    puVar1 = (undefined4 *)*local_38;
    uRam1003ab22 = *puVar1;
    uRam1003ab26 = puVar1[1];
    uRam1003ab2a = puVar1[2];
    uRam1003ab2e = puVar1[3];
    uRam1003ab32 = puVar1[4];
    uRam1003ab36 = puVar1[5];
    uRam1003ab3a = puVar1[6];
    uRam1003ab3e = puVar1[7];
    uRam1003ab42 = puVar1[8];
    uRam1003ab46 = puVar1[9];
    uRam1003ab4a = puVar1[10];
    uRam1003ab4e = puVar1[0xb];
    uRam1003ab52 = puVar1[0xc];
    uRam1003ab56 = puVar1[0xd];
    .glue::HUnlock(local_38);
    .glue::DisposeHandle(local_38);
    local_3e = 400;
    FUN_1002edf0((int)local_30[0],0x53734853,&local_3e,&local_3c);
    .glue::MoveHHi(local_3c);
    .glue::HLock(local_3c);
    iVar6 = *local_3c;
    for (sVar2 = 1; sVar2 < 0xb; sVar2 = sVar2 + 1) {
      FUN_10026fd8(iVar6,&DAT_10039782 + sVar2 * 0x104);
      *(undefined4 *)(sVar2 * 0x104 + 0x10039882) = *(undefined4 *)(iVar6 + 0x100);
      iVar6 = iVar6 + 0x104;
    }
    .glue::HUnlock(local_3c);
    .glue::DisposeHandle(local_3c);
    FUN_1002ea68((int)local_30[0]);
    *(undefined1 *)(local_26c + 0x5240) = 0;
    *(undefined1 *)(local_26c + 0x523f) = 0;
    *(undefined1 *)(local_26c + 0x523e) = 0;
  }
  else {
    FUN_1002ea68((int)local_30[0]);
    FUN_10020d74();
  }
  return;
}

