
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10027aec(undefined4 param_1,undefined4 param_2)

{
  uint uVar1;
  int iVar2;
  int iVar3;
  short sVar4;
  short sVar5;
  
  sVar4 = (short)param_1;
  sVar5 = (short)param_2;
  if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x100) == 0) {
    if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0xff) != 0) {
      iVar2 = FUN_1002e6ac(param_1);
      iVar3 = FUN_1002e6bc(param_2);
      uVar1 = *(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0xff;
      FUN_1002cc10(param_1,param_2);
      FUN_100278bc(_DAT_1003ad30,uVar1 + 2,iVar2,iVar3,0xfffffff6,10,1);
      FUN_100278bc(_DAT_1003ad30,uVar1 + 3,iVar2 + 0x10,iVar3,10,10,1);
      FUN_100278bc(_DAT_1003ad30,uVar1 + 4,iVar2 + 0x10,iVar3 + 0x10,0xf,0xf,1);
      FUN_100278bc(_DAT_1003ad30,uVar1 + 5,iVar2,iVar3 + 0x10,0xfffffff1,0xf,1);
    }
  }
  return;
}

