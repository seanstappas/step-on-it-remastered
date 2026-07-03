
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1002ca5c(undefined4 param_1,undefined4 param_2)

{
  uint uVar1;
  int iVar2;
  int iVar3;
  uint uVar4;
  short sVar5;
  short sVar6;
  
  iVar2 = FUN_1002e6ac(param_1);
  iVar3 = FUN_1002e6bc(param_2);
  sVar5 = (short)param_1;
  sVar6 = (short)param_2;
  uVar4 = *(uint *)(&DAT_1003ad68 + sVar5 * 0x3c + sVar6 * 4);
  uVar1 = *(uint *)(&DAT_1003ad68 + sVar5 * 0x3c + sVar6 * 4) & 0xff;
  if ((((uVar4 & 0x100) == 0) && ((short)uVar1 != 0)) && ((uVar4 & 0x800) == 0)) {
    if ((uVar4 & 0x4000) == 0) {
      FUN_1002b020(0x23,7);
      FUN_10004090(_DAT_1003ad30,uVar1,iVar2,iVar3);
      FUN_10004108(_DAT_1003ad30,uVar1 + 1,iVar2,iVar3);
      iVar2 = sVar5 * 0x3c + sVar6 * 4;
      *(int *)(&DAT_1003ad68 + iVar2) = *(int *)(&DAT_1003ad68 + iVar2) + 0x4000;
    }
    else {
      FUN_1002b020(0x24,7);
      FUN_1002cc10(param_1,param_2);
      FUN_100278bc(_DAT_1003ad30,uVar1 + 2,iVar2,iVar3,0xffffffd8,0xffffffb0,1);
      FUN_100278bc(_DAT_1003ad30,uVar1 + 3,iVar2 + 0x10,iVar3,0x28,0xffffffb0,1);
      FUN_100278bc(_DAT_1003ad30,uVar1 + 4,iVar2 + 0x10,iVar3 + 0x10,0x3c,0xffffffba,1);
      FUN_100278bc(_DAT_1003ad30,uVar1 + 5,iVar2,iVar3 + 0x10,0xffffffc4,0xffffffba,1);
    }
  }
  return;
}

