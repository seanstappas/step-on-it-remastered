
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10005c64(short param_1)

{
  *(undefined2 *)(&DAT_10037e48 + *(short *)(param_1 * 0x46 + 0x10037e86) * 0x46) =
       *(undefined2 *)(&DAT_10037e48 + param_1 * 0x46);
  if (*(short *)(&DAT_10037e48 + param_1 * 0x46) == 0) {
    _DAT_1003a36a = *(undefined2 *)(param_1 * 0x46 + 0x10037e86);
  }
  else {
    *(undefined2 *)(*(short *)(&DAT_10037e48 + param_1 * 0x46) * 0x46 + 0x10037e86) =
         *(undefined2 *)(param_1 * 0x46 + 0x10037e86);
  }
  *(short *)(&DAT_10037e48 + _DAT_1003a368 * 0x46) = param_1;
  *(undefined2 *)(&DAT_10037e48 + param_1 * 0x46) = 0;
  *(short *)(param_1 * 0x46 + 0x10037e86) = _DAT_1003a368;
  _DAT_1003a368 = param_1;
  return;
}

