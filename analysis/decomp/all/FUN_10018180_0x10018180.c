
void FUN_10018180(void)

{
  short sVar1;
  
  for (sVar1 = 1; sVar1 < 0x14; sVar1 = sVar1 + 1) {
    if (*(char *)(sVar1 * 4 + 0x10038ff9) != '\0') {
      .glue::DisposeHandle(*(undefined4 *)(&DAT_1003a314 + sVar1 * 4));
      *(undefined1 *)(sVar1 * 4 + 0x10038ff9) = 0;
    }
  }
  return;
}

