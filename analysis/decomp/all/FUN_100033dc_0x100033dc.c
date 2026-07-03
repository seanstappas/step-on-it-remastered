
undefined4 FUN_100033dc(int param_1,int param_2,int param_3,int param_4)

{
  int *piVar1;
  int *piVar2;
  short sVar3;
  
  piVar2 = (int *)(param_2 + 0xc);
  piVar1 = (int *)(param_1 + 0xc);
  sVar3 = 0;
  while( true ) {
    if (7 < sVar3) {
      return 1;
    }
    if ((*piVar1 != *piVar2) && ((sVar3 < 2 || (6 < sVar3)))) {
      return 0;
    }
    if (piVar1[1] != piVar2[1]) {
      return 0;
    }
    if (piVar1[2] != piVar2[2]) break;
    if (piVar1[3] != piVar2[3]) {
      return 0;
    }
    if (piVar1[4] != piVar2[4]) {
      return 0;
    }
    piVar1 = piVar1 + (param_3 * 4 + -0x14) / 4 + 5;
    piVar2 = piVar2 + (param_4 * 4 + -0x14) / 4 + 5;
    sVar3 = sVar3 + 1;
  }
  return 0;
}

