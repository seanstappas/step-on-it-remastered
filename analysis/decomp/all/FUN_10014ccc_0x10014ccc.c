
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10014ccc(short param_1)

{
  *(undefined2 *)(param_1 * 0x70 + 0x1003aa14) = 0x3c;
  *(undefined2 *)(param_1 * 0x70 + 0x1003aa12) = 0x1f;
  *(undefined2 *)(param_1 * 0x70 + 0x1003aa1e) = 0x4b0;
  *(undefined4 *)(param_1 * 0x70 + 0x1003aa1a) = _DAT_1003ad1c;
  if (*(short *)(param_1 * 0x70 + 0x1003aa0c) == 0) {
    *(undefined2 *)(param_1 * 0x70 + 0x1003aa10) = 0;
  }
  *(undefined2 *)(param_1 * 0x70 + 0x1003aa0c) = 1;
  return;
}

