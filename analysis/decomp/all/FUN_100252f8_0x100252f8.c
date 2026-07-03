
undefined4 FUN_100252f8(void)

{
  short sVar1;
  
  FUN_100254a0();
  sVar1 = 1;
  while( true ) {
    if (2 < sVar1) {
      return 0;
    }
    if (*(int *)(&DAT_1003ab06 + sVar1 * 0x1c) != *(int *)(&DAT_1003a2b0 + sVar1 * 0x1c)) {
      return 1;
    }
    if (*(int *)(sVar1 * 0x1c + 0x1003ab0a) != *(int *)(sVar1 * 0x1c + 0x1003a2b4)) {
      return 1;
    }
    if (*(int *)(sVar1 * 0x1c + 0x1003ab0e) != *(int *)(sVar1 * 0x1c + 0x1003a2b8)) {
      return 1;
    }
    if (*(int *)(sVar1 * 0x1c + 0x1003ab12) != *(int *)(sVar1 * 0x1c + 0x1003a2bc)) {
      return 1;
    }
    if (*(int *)(sVar1 * 0x1c + 0x1003ab16) != *(int *)(sVar1 * 0x1c + 0x1003a2c0)) {
      return 1;
    }
    if (*(int *)(sVar1 * 0x1c + 0x1003ab1a) != *(int *)(sVar1 * 0x1c + 0x1003a2c4)) {
      return 1;
    }
    if (*(int *)(sVar1 * 0x1c + 0x1003ab1e) != *(int *)(sVar1 * 0x1c + 0x1003a2c8)) break;
    sVar1 = sVar1 + 1;
  }
  return 1;
}

