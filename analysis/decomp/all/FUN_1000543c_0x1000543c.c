
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1000543c(undefined2 param_1)

{
  short sVar1;
  
  for (sVar1 = _DAT_1003a36a; sVar1 != 0; sVar1 = *(short *)(sVar1 * 0x46 + 0x10037e86)) {
    if (99 < *(short *)(sVar1 * 0x46 + 0x10037e4a)) {
      *(undefined2 *)(sVar1 * 0x46 + 0x10037e88) = param_1;
    }
  }
  return;
}

