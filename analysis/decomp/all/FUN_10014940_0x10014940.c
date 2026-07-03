
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10014940(short param_1)

{
  if (((0 < _DAT_1003b698) && (*(short *)(param_1 * 0x70 + 0x1003aa0c) != 0)) &&
     (*(short *)(param_1 * 0x70 + 0x1003aa10) != 0)) {
    FUN_10004cb0(*(undefined4 *)(param_1 * 0x70 + 0x1003aa1a),
                 (int)*(short *)(param_1 * 0x70 + 0x1003aa10),
                 (int)*(short *)(param_1 * 0x70 + 0x1003aa16),
                 (int)*(short *)(param_1 * 0x70 + 0x1003aa18));
    *(undefined2 *)(param_1 * 0x70 + 0x1003aa10) = 0;
  }
  return;
}

