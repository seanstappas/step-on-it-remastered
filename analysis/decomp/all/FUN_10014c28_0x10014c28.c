
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10014c28(short param_1)

{
  *(undefined2 *)(param_1 * 0x70 + 0x1003aa14) = 0x1e;
  *(undefined2 *)(param_1 * 0x70 + 0x1003aa12) = 1;
  *(undefined2 *)(param_1 * 0x70 + 0x1003aa1e) = 600;
  *(undefined4 *)(param_1 * 0x70 + 0x1003aa1a) = _DAT_1003ad1c;
  if (*(short *)(param_1 * 0x70 + 0x1003aa0c) == 0) {
    *(undefined2 *)(param_1 * 0x70 + 0x1003aa10) = 0;
  }
  *(undefined2 *)(param_1 * 0x70 + 0x1003aa0c) = 2;
  return;
}

