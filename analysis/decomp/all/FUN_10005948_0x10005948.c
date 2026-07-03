
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int FUN_10005948(void)

{
  int iVar1;
  short sVar2;
  
  sVar2 = _DAT_1003a368;
  iVar1 = 0;
  if (_DAT_1003a368 == 0) {
    FUN_100192f8(8);
  }
  else {
    iVar1 = (int)_DAT_1003a368;
    _DAT_1003a368 = *(short *)(_DAT_1003a368 * 0x46 + 0x10037e86);
    *(undefined2 *)(&DAT_10037e48 + _DAT_1003a368 * 0x46) = 0;
    if (_DAT_1003a36a == 0) {
      _DAT_1003a36a = sVar2;
      *(undefined2 *)(sVar2 * 0x46 + 0x10037e86) = 0;
    }
    else {
      *(short *)(sVar2 * 0x46 + 0x10037e86) = _DAT_1003a36a;
      *(short *)(&DAT_10037e48 + _DAT_1003a36a * 0x46) = sVar2;
      _DAT_1003a36a = sVar2;
    }
  }
  sVar2 = (short)iVar1;
  *(undefined1 *)(sVar2 * 0x46 + 0x10037e67) = 1;
  *(undefined1 *)(sVar2 * 0x46 + 0x10037e68) = 0;
  *(undefined2 *)(sVar2 * 0x46 + 0x10037e88) = 0;
  *(undefined2 *)(sVar2 * 0x46 + 0x10037e82) = 0;
  *(undefined2 *)(sVar2 * 0x46 + 0x10037e80) = 0;
  *(undefined2 *)(sVar2 * 0x46 + 0x10037e84) = 0;
  *(undefined2 *)(sVar2 * 0x46 + 0x10037e7e) = 0;
  *(undefined1 *)(sVar2 * 0x46 + 0x10037e7d) = 0;
  return iVar1;
}

