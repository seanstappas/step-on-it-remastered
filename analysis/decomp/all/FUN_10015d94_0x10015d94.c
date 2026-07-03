
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10015d94(undefined4 param_1,int param_2,undefined4 param_3)

{
  bool bVar1;
  int iVar2;
  short sVar3;
  undefined4 uStack00000018;
  short asStack_38 [18];
  
  bVar1 = false;
  uStack00000018 = param_1;
  FUN_1002b900(param_1,asStack_38);
  for (iVar2 = 9; sVar3 = (short)iVar2, -1 < sVar3; iVar2 = iVar2 + -1) {
    if (sVar3 == 0) {
      bVar1 = true;
    }
    if (asStack_38[sVar3] == 0) {
      if (bVar1) {
        FUN_10004bb4(_DAT_1003ad28,asStack_38[sVar3] + 5,param_2 + (iVar2 + 1) * -8,param_3);
      }
    }
    else {
      bVar1 = true;
      FUN_10004bb4(_DAT_1003ad28,asStack_38[sVar3] + 5,param_2 + (iVar2 + 1) * -8,param_3);
    }
  }
  return;
}

