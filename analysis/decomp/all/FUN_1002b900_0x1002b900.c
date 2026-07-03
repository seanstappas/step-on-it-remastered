
void FUN_1002b900(int param_1,int param_2)

{
  int iVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  
  iVar3 = 1000000000;
  for (iVar4 = 9; -1 < iVar4; iVar4 = iVar4 + -1) {
    iVar1 = param_1 / iVar3;
    iVar2 = (param_1 / iVar3) * iVar3;
    iVar3 = iVar3 / 10;
    *(short *)(param_2 + iVar4 * 2) = (short)iVar1;
    param_1 = param_1 - iVar2;
  }
  return;
}

