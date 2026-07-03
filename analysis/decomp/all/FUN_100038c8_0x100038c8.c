
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int FUN_100038c8(void)

{
  int iVar1;
  
  if (_DAT_10037872 == -1) {
    iVar1 = 0;
  }
  else {
    iVar1 = (int)_DAT_10037872;
    _DAT_10037872 = *(short *)(_DAT_10037872 * 0x14 + 0x100378a0);
  }
  return iVar1;
}

