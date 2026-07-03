
uint FUN_1001ed64(int param_1)

{
  uint uVar1;
  
  if (param_1 == 0) {
    uVar1 = 0;
  }
  else {
    uVar1 = ((uint)(byte)((*(short *)(param_1 + 0x6c) < 0) << 3) << 0x1c) >> 0x1f;
  }
  return uVar1;
}

