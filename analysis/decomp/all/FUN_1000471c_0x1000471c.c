
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1000471c(undefined4 param_1,undefined4 param_2)

{
  short sVar1;
  short sVar2;
  int iVar3;
  int iVar4;
  
  sVar1 = FUN_1002e6bc(param_2);
  iVar3 = (int)_DAT_1003ad40;
  sVar2 = FUN_1002e6ac(param_1);
  iVar4 = _DAT_1003ad44 + (int)sVar2 + sVar1 * iVar3;
  sVar1 = FUN_1002e6bc(param_2);
  iVar3 = _DAT_1003b254 * sVar1;
  sVar1 = FUN_1002e6ac(param_1);
  FUN_100032d0(iVar4,_DAT_1003b258 + sVar1 + iVar3,(int)_DAT_1003ad40,_DAT_1003b254);
  return;
}

