
undefined4 FUN_100299b4(short param_1)

{
  short sVar1;
  
  if (*(short *)(param_1 * 0x70 + 0x1003a9cc) == 2) {
    sVar1 = FUN_100030ac(*(short *)(&DAT_1003a9b0 + param_1 * 0x70) + 0xd,
                         *(short *)(param_1 * 0x70 + 0x1003a9b4) + 4,
                         *(short *)(&DAT_1003a9b0 + param_1 * 0x70) + 0x12,
                         *(short *)(param_1 * 0x70 + 0x1003a9b4) + 0x19);
    if (sVar1 != 0) {
      return 1;
    }
  }
  else {
    sVar1 = FUN_100030ac(*(short *)(&DAT_1003a9b0 + param_1 * 0x70) + 0xd,
                         *(short *)(param_1 * 0x70 + 0x1003a9b4) + 4,
                         *(short *)(&DAT_1003a9b0 + param_1 * 0x70) + 0x12,
                         *(short *)(param_1 * 0x70 + 0x1003a9b4) + 0x1d);
    if (sVar1 != 0) {
      return 1;
    }
  }
  return 0;
}

