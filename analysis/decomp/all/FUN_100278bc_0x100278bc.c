
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_100278bc(undefined4 param_1,undefined2 param_2,undefined2 param_3,undefined2 param_4,
                 undefined2 param_5,undefined2 param_6,undefined1 param_7)

{
  short sVar1;
  int iVar2;
  
  sVar1 = _DAT_1003a36e;
  if (_DAT_1003a36e != -1) {
    iVar2 = (int)_DAT_1003a36e;
    _DAT_1003a36e = *(short *)(_DAT_1003a36e * 0x18 + 0x1003a426);
    *(short *)(iVar2 * 0x18 + 0x1003a426) = _DAT_1003a36c;
    _DAT_1003a36c = sVar1;
    *(undefined4 *)(&DAT_1003a410 + sVar1 * 0x18) = param_1;
    *(undefined2 *)(sVar1 * 0x18 + 0x1003a414) = param_2;
    *(undefined2 *)(sVar1 * 0x18 + 0x1003a416) = param_3;
    *(undefined2 *)(sVar1 * 0x18 + 0x1003a418) = param_4;
    *(undefined2 *)(sVar1 * 0x18 + 0x1003a41a) = param_3;
    *(undefined2 *)(sVar1 * 0x18 + 0x1003a41c) = param_4;
    *(undefined2 *)(sVar1 * 0x18 + 0x1003a41e) = param_5;
    *(undefined2 *)(sVar1 * 0x18 + 0x1003a420) = param_6;
    *(undefined1 *)(sVar1 * 0x18 + 0x1003a422) = param_7;
    *(undefined2 *)(sVar1 * 0x18 + 0x1003a424) = 0;
  }
  return;
}

