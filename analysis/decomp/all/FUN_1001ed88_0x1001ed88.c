
uint FUN_1001ed88(int param_1)

{
  uint uVar1;
  
  if (param_1 == 0) {
    uVar1 = 0;
  }
  else {
    uVar1 = ((uint)(byte)((*(short *)(param_1 + 0x6c) == 2) << 1) << 0x1c) >> 0x1d;
  }
  return uVar1;
}

