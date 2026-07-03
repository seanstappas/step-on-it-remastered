
void FUN_100147b8(short param_1)

{
  short sVar1;
  short sVar2;
  
  if (*(short *)(param_1 * 0x70 + 0x1003aa0c) != 0) {
    *(undefined2 *)(param_1 * 0x70 + 0x1003aa10) = *(undefined2 *)(param_1 * 0x70 + 0x1003aa0e);
    sVar1 = *(short *)(param_1 * 0x70 + 0x1003aa1e);
    sVar2 = (*(short *)(param_1 * 0x70 + 0x1003aa14) - *(short *)(param_1 * 0x70 + 0x1003aa12)) + 1;
    *(short *)(param_1 * 0x70 + 0x1003aa0e) =
         (sVar1 - (sVar1 / sVar2) * sVar2) + *(short *)(param_1 * 0x70 + 0x1003aa12);
    if ((*(short *)(param_1 * 0x70 + 0x1003aa1e) < 0x78) &&
       ((*(short *)(param_1 * 0x70 + 0x1003aa1e) / 3 & 1U) == 0)) {
      *(undefined2 *)(param_1 * 0x70 + 0x1003aa0e) = 0;
    }
    sVar1 = *(short *)(param_1 * 0x70 + 0x1003aa1e);
    *(short *)(param_1 * 0x70 + 0x1003aa1e) = sVar1 + -1;
    if (sVar1 < 0) {
      *(undefined2 *)(param_1 * 0x70 + 0x1003aa0c) = 0;
    }
    if (*(char *)(param_1 * 0x70 + 0x1003a9d8) != '\0') {
      *(undefined2 *)(param_1 * 0x70 + 0x1003aa1e) = 0;
    }
  }
  return;
}

