
void FUN_100251d8(void)

{
  short sVar1;
  
  DAT_100393af = 1;
  for (sVar1 = 1; sVar1 < 3; sVar1 = sVar1 + 1) {
    *(undefined4 *)(&DAT_1003ab06 + sVar1 * 0x1c) = *(undefined4 *)(&DAT_1003a2b0 + sVar1 * 0x1c);
    *(undefined4 *)(sVar1 * 0x1c + 0x1003ab0a) = *(undefined4 *)(sVar1 * 0x1c + 0x1003a2b4);
    *(undefined4 *)(sVar1 * 0x1c + 0x1003ab0e) = *(undefined4 *)(sVar1 * 0x1c + 0x1003a2b8);
    *(undefined4 *)(sVar1 * 0x1c + 0x1003ab12) = *(undefined4 *)(sVar1 * 0x1c + 0x1003a2bc);
    *(undefined4 *)(sVar1 * 0x1c + 0x1003ab16) = *(undefined4 *)(sVar1 * 0x1c + 0x1003a2c0);
    *(undefined4 *)(sVar1 * 0x1c + 0x1003ab1a) = *(undefined4 *)(sVar1 * 0x1c + 0x1003a2c4);
    *(undefined4 *)(sVar1 * 0x1c + 0x1003ab1e) = *(undefined4 *)(sVar1 * 0x1c + 0x1003a2c8);
  }
  return;
}

