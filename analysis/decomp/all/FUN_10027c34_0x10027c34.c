
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10027c34(undefined4 param_1,undefined4 param_2,int param_3,int param_4)

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
      FUN_100278bc(_DAT_1003ad30,uVar1 + 2,iVar2,iVar3,param_3 + -3,param_4 + -3,0);
      FUN_100278bc(_DAT_1003ad30,uVar1 + 3,iVar2 + 0x10,iVar3,param_3 + 3,param_4 + -3,0);
      FUN_100278bc(_DAT_1003ad30,uVar1 + 4,iVar2 + 0x10,iVar3 + 0x10,param_3 + 3,param_4 + 3,0);
      FUN_100278bc(_DAT_1003ad30,uVar1 + 5,iVar2,iVar3 + 0x10,param_3 + -3,param_4 + 3,0);
    }
  }
  return;
}

