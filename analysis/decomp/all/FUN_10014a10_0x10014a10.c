
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10014a10(short param_1)

{
  if ((0 < _DAT_1003b698) && (*(short *)(param_1 * 0x70 + 0x1003aa0c) != 0)) {
    if (*(short *)(param_1 * 0x70 + 0x1003aa0e) == 0) {
      if (*(short *)(param_1 * 0x70 + 0x1003aa10) != 0) {
        FUN_10004cb0(*(undefined4 *)(param_1 * 0x70 + 0x1003aa1a),
                     (int)*(short *)(param_1 * 0x70 + 0x1003aa10),
                     (int)*(short *)(param_1 * 0x70 + 0x1003aa16),
                     (int)*(short *)(param_1 * 0x70 + 0x1003aa18));
      }
    }
    else if (*(short *)(param_1 * 0x70 + 0x1003aa10) == 0) {
      FUN_10004bb4(*(undefined4 *)(param_1 * 0x70 + 0x1003aa1a),
                   (int)*(short *)(param_1 * 0x70 + 0x1003aa0e),
                   *(short *)(&DAT_1003a9b0 + param_1 * 0x70) + 6,
                   *(short *)(param_1 * 0x70 + 0x1003a9b4) + -0x10);
    }
    else {
      FUN_10004cb0(*(undefined4 *)(param_1 * 0x70 + 0x1003aa1a),
                   (int)*(short *)(param_1 * 0x70 + 0x1003aa10),
                   (int)*(short *)(param_1 * 0x70 + 0x1003aa16),
                   (int)*(short *)(param_1 * 0x70 + 0x1003aa18));
      FUN_10004bb4(*(undefined4 *)(param_1 * 0x70 + 0x1003aa1a),
                   (int)*(short *)(param_1 * 0x70 + 0x1003aa0e),
                   *(short *)(&DAT_1003a9b0 + param_1 * 0x70) + 6,
                   *(short *)(param_1 * 0x70 + 0x1003a9b4) + -0x10);
    }
    *(short *)(param_1 * 0x70 + 0x1003aa16) = *(short *)(&DAT_1003a9b0 + param_1 * 0x70) + 6;
    *(short *)(param_1 * 0x70 + 0x1003aa18) = *(short *)(param_1 * 0x70 + 0x1003a9b4) + -0x10;
  }
  return;
}

