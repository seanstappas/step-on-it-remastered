
void FUN_1000ec50(int param_1,short param_2)

{
  short sVar1;
  
  sVar1 = (short)param_1;
  if ((DAT_100370e4 == '\0') || (DAT_1003ab6e == '\0')) {
    FUN_1002e610((int)*(short *)(sVar1 * 0x70 + 0x1003a9fa),0x184,8);
    *(short *)(sVar1 * 0x70 + 0x1003a9fa) = *(short *)(sVar1 * 0x70 + 0x1003a9fa) + param_2;
    FUN_1002e48c((int)*(short *)(sVar1 * 0x70 + 0x1003a9fa),0x184,8);
  }
  else {
    FUN_1002e610((int)*(short *)(sVar1 * 0x70 + 0x1003a9fa),0x184,param_1 * 0x10 + -0x10);
    *(short *)(sVar1 * 0x70 + 0x1003a9fa) = *(short *)(sVar1 * 0x70 + 0x1003a9fa) + param_2;
    FUN_1002e48c((int)*(short *)(sVar1 * 0x70 + 0x1003a9fa),0x184,param_1 * 0x10 + -0x10);
  }
  return;
}

