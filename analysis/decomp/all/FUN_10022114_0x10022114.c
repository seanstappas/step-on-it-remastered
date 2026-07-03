
void FUN_10022114(void)

{
  short sVar1;
  
  for (sVar1 = 0; sVar1 < 0x1f; sVar1 = sVar1 + 1) {
    *(undefined4 *)(sVar1 * 0x14 + 0x10039518) = 0;
    *(undefined4 *)(sVar1 * 0x14 + 0x1003951c) = 0;
  }
  FUN_1002218c();
  return;
}

