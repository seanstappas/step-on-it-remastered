
undefined4 FUN_100032d0(int *param_1,int *param_2,int param_3,int param_4)

{
  short sVar1;
  
  sVar1 = 0;
  while( true ) {
    if (7 < sVar1) {
      return 1;
    }
    if (*param_1 != *param_2) {
      return 0;
    }
    if (param_1[1] != param_2[1]) {
      return 0;
    }
    if (param_1[2] != param_2[2]) break;
    if (param_1[3] != param_2[3]) {
      return 0;
    }
    if (param_1[4] != param_2[4]) {
      return 0;
    }
    if (param_1[5] != param_2[5]) {
      return 0;
    }
    param_1 = param_1 + (param_3 * 4 + -0x18) / 4 + 6;
    param_2 = param_2 + (param_4 * 4 + -0x18) / 4 + 6;
    sVar1 = sVar1 + 1;
  }
  return 0;
}

