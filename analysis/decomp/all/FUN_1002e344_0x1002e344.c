
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1002e344(void)

{
  int iVar1;
  
  FUN_10004080();
  for (iVar1 = 0; (short)iVar1 < 0x13; iVar1 = iVar1 + 1) {
    FUN_10004108(_DAT_1003ad28,0x21,iVar1 * 0x20 + 0x10,0x20);
    FUN_10004108(_DAT_1003ad28,0x23,iVar1 * 0x20 + 0x10,0x1d0);
  }
  FUN_10004180();
  for (iVar1 = 0; (short)iVar1 < 0xd; iVar1 = iVar1 + 1) {
    FUN_10004108(_DAT_1003ad28,0x20,0,iVar1 * 0x20 + 0x30);
    FUN_10004108(_DAT_1003ad28,0x22,0x270,iVar1 * 0x20 + 0x30);
  }
  FUN_10004108(_DAT_1003ad28,0x27,0,0x1d0);
  FUN_10004108(_DAT_1003ad28,0x24,0,0x20);
  FUN_10004108(_DAT_1003ad28,0x26,0x270,0x1d0);
  FUN_10004108(_DAT_1003ad28,0x25,0x270,0x20);
  FUN_10004180();
  return;
}

