
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10003f7c(void)

{
  short sVar1;
  
  for (sVar1 = 0; sVar1 < _DAT_10037524; sVar1 = sVar1 + 1) {
    FUN_1000189c(*(short *)(&DAT_10037526 + sVar1 * 2) * 0x14 + 0x100378aa,_DAT_1003ad4c,
                 _DAT_1003ad48,_DAT_1003ad44,(int)_DAT_1003ad40);
  }
  for (sVar1 = 0; sVar1 < _DAT_10037524; sVar1 = sVar1 + 1) {
    FUN_1000189c(*(short *)(&DAT_10037526 + sVar1 * 2) * 0x14 + 0x100378a2,_DAT_1003b258,
                 _DAT_1003b254,_DAT_1003ad4c,_DAT_1003ad48);
  }
  return;
}

