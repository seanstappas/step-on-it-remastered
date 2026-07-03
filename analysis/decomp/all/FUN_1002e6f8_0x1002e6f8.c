
int FUN_1002e6f8(short param_1)

{
  int iVar1;
  uint uVar2;
  
  if (param_1 < 0x30) {
    iVar1 = 0;
  }
  else {
    uVar2 = (int)param_1 - 0x30;
    iVar1 = ((int)uVar2 >> 5) + (uint)((int)uVar2 < 0 && (uVar2 & 0x1f) != 0) + 1;
  }
  return iVar1;
}

