
void FUN_100279c4(undefined4 param_1,undefined4 param_2)

{
  undefined4 uVar1;
  undefined4 uVar2;
  short sVar3;
  short sVar4;
  
  sVar3 = (short)param_1;
  sVar4 = (short)param_2;
  if ((*(uint *)(&DAT_1003ad68 + sVar3 * 0x3c + sVar4 * 4) & 0x100) == 0) {
    if ((*(uint *)(&DAT_1003ad68 + sVar3 * 0x3c + sVar4 * 4) & 0xff) != 0) {
      if ((*(uint *)(&DAT_1003ad68 + sVar3 * 0x3c + sVar4 * 4) & 0x1000) == 0) {
        uVar1 = FUN_1002e6bc(param_2);
        uVar2 = FUN_1002e6ac(param_1);
        FUN_1002754c(uVar2,uVar1,0xffffffff,0,0);
      }
      else {
        uVar1 = FUN_1002e6bc(param_2);
        uVar2 = FUN_1002e6ac(param_1);
        FUN_1002754c(uVar2,uVar1,0xffffffff,0,
                     *(uint *)(&DAT_1003ad68 + sVar3 * 0x3c + sVar4 * 4) >> 0x10);
      }
    }
  }
  return;
}

