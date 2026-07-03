
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10004108(undefined4 param_1,undefined2 param_2,undefined2 param_3,undefined2 param_4)

{
  _DAT_100375a0 = _DAT_100375a0 + 1;
  *(undefined2 *)(&DAT_100375a2 + _DAT_100375a0 * 0xc) = 1;
  *(undefined4 *)(_DAT_100375a0 * 0xc + 0x100375a4) = param_1;
  *(undefined2 *)(_DAT_100375a0 * 0xc + 0x100375a8) = param_2;
  *(undefined2 *)(_DAT_100375a0 * 0xc + 0x100375aa) = param_3;
  *(undefined2 *)(_DAT_100375a0 * 0xc + 0x100375ac) = param_4;
  return;
}

