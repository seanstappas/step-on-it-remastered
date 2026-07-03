
void FUN_10017a1c(void)

{
  short sVar1;
  
  for (sVar1 = 1; sVar1 < 0x14; sVar1 = sVar1 + 1) {
    *(undefined1 *)(sVar1 * 4 + 0x10038ffa) = 0;
    *(undefined1 *)(sVar1 * 4 + 0x10038ff9) = 0;
  }
  return;
}

