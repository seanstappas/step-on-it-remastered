
void FUN_1000e9c8(int param_1,short param_2)

{
  short sVar1;
  
  if (DAT_100370e4 == '\0') {
    param_1 = 1;
  }
  sVar1 = (short)param_1;
  if ((int)param_2 + (int)*(short *)(sVar1 * 0x70 + 0x1003a9f6) < 0) {
    *(short *)(sVar1 * 0x70 + 0x1003a9f6) = *(short *)(sVar1 * 0x70 + 0x1003a9f6) + param_2;
  }
  else if ((DAT_100370e4 == '\0') || (DAT_1003ab6e == '\0')) {
    FUN_1002e610((int)*(short *)(sVar1 * 0x70 + 0x1003a9f6),0x15c,8);
    *(short *)(sVar1 * 0x70 + 0x1003a9f6) = *(short *)(sVar1 * 0x70 + 0x1003a9f6) + param_2;
    FUN_1002e48c((int)*(short *)(sVar1 * 0x70 + 0x1003a9f6),0x15c,8);
  }
  else {
    FUN_1002e610((int)*(short *)(sVar1 * 0x70 + 0x1003a9f6),0x15c,param_1 * 0x10 + -0x10);
    *(short *)(sVar1 * 0x70 + 0x1003a9f6) = *(short *)(sVar1 * 0x70 + 0x1003a9f6) + param_2;
    FUN_1002e48c((int)*(short *)(sVar1 * 0x70 + 0x1003a9f6),0x15c,param_1 * 0x10 + -0x10);
  }
  return;
}

