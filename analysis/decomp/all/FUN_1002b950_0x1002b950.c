
void FUN_1002b950(int param_1,int param_2)

{
  short sVar1;
  int iVar2;
  short sVar3;
  short sVar4;
  
  iVar2 = 10000;
  for (sVar4 = 4; -1 < sVar4; sVar4 = sVar4 + -1) {
    sVar3 = (short)iVar2;
    sVar1 = (short)param_1;
    iVar2 = (int)sVar3 / 10;
    *(short *)(param_2 + sVar4 * 2) = sVar1 / sVar3;
    param_1 = (int)sVar1 - ((int)sVar1 / (int)sVar3) * (int)sVar3;
  }
  return;
}

