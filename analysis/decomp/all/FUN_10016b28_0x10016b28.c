
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10016b28(void)

{
  uint uVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  int iVar4;
  int iVar5;
  
  for (iVar4 = 1; (short)iVar4 < 0x14; iVar4 = iVar4 + 1) {
    for (iVar5 = 1; (short)iVar5 < 0xe; iVar5 = iVar5 + 1) {
      if ((*(uint *)(&DAT_1003ad68 + (short)iVar4 * 0x3c + (short)iVar5 * 4) & 0x1000) != 0) {
        uVar2 = FUN_1002e6bc(iVar5);
        uVar3 = FUN_1002e6ac(iVar4);
        FUN_10004bb4(_DAT_1003ad2c,0x33,uVar3,uVar2);
      }
    }
  }
  iVar4 = .glue::TickCount();
  do {
    uVar1 = .glue::TickCount();
  } while (uVar1 < iVar4 + 300U);
  for (iVar4 = 1; (short)iVar4 < 0x14; iVar4 = iVar4 + 1) {
    for (iVar5 = 1; (short)iVar5 < 0xe; iVar5 = iVar5 + 1) {
      if ((*(uint *)(&DAT_1003ad68 + (short)iVar4 * 0x3c + (short)iVar5 * 4) & 0x1000) != 0) {
        uVar2 = FUN_1002e6bc(iVar5);
        uVar3 = FUN_1002e6ac(iVar4);
        FUN_10004cb0(_DAT_1003ad2c,0x33,uVar3,uVar2);
      }
    }
  }
  return;
}

