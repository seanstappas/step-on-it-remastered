
void FUN_1002cf08(undefined4 param_1,undefined4 param_2,short param_3)

{
  undefined4 uVar1;
  undefined4 uVar2;
  char cVar3;
  short sVar4;
  short sVar5;
  
  uVar1 = FUN_1002e6ac(param_1);
  uVar2 = FUN_1002e6bc(param_2);
  sVar4 = (short)param_1;
  sVar5 = (short)param_2;
  if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x100) == 0) {
    if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0xff) == 0) {
      cVar3 = FUN_1000471c(param_1,param_2);
      if (cVar3 != '\0') {
        FUN_1002b020(4,7);
        FUN_1002754c(uVar1,uVar2,1,*(ushort *)(param_3 * 0x70 + 0x1003a9e6) & 0xff,
                     (int)*(short *)(param_3 * 0x70 + 0x1003a9e6) +
                     (*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0xffff1000));
      }
    }
    else {
      FUN_1002b020(3,7);
      FUN_100279c4(param_1,param_2);
    }
  }
  return;
}

