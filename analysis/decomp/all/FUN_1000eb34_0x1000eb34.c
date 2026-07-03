
void FUN_1000eb34(int param_1,short param_2)

{
  short sVar1;
  
  sVar1 = (short)param_1;
  if ((DAT_100370e4 == '\0') || (DAT_1003ab6e == '\0')) {
    FUN_1002e610((int)*(short *)(sVar1 * 0x70 + 0x1003a9fc),0x1d4,8);
    *(short *)(sVar1 * 0x70 + 0x1003a9fc) = *(short *)(sVar1 * 0x70 + 0x1003a9fc) + param_2;
    FUN_1002e48c((int)*(short *)(sVar1 * 0x70 + 0x1003a9fc),0x1d4,8);
  }
  else {
    FUN_1002e610((int)*(short *)(sVar1 * 0x70 + 0x1003a9fc),0x1d4,param_1 * 0x10 + -0x10);
    *(short *)(sVar1 * 0x70 + 0x1003a9fc) = *(short *)(sVar1 * 0x70 + 0x1003a9fc) + param_2;
    FUN_1002e48c((int)*(short *)(sVar1 * 0x70 + 0x1003a9fc),0x1d4,param_1 * 0x10 + -0x10);
  }
  return;
}

