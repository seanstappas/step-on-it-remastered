
void FUN_100137f8(short param_1)

{
  undefined4 uVar1;
  short sVar2;
  
  uVar1 = FUN_1002e6f8((int)*(short *)(param_1 * 0x70 + 0x1003a9b4));
  sVar2 = FUN_1002e6bc(uVar1);
  *(short *)(param_1 * 0x70 + 0x1003a9b4) = sVar2 + 1;
  return;
}

