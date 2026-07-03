
void FUN_100166b8(short param_1)

{
  short sVar1;
  
  sVar1 = *(short *)(param_1 * 0xe + 0x10038ecc);
  if (sVar1 == 3) {
    *(undefined2 *)(param_1 * 0xe + 0x10038ecc) = 4;
  }
  else if (sVar1 < 3) {
    if (sVar1 == 1) {
      *(undefined2 *)(param_1 * 0xe + 0x10038ecc) = 4;
      *(undefined2 *)(param_1 * 0xe + 0x10038ece) = 8;
    }
    else if (0 < sVar1) {
      *(undefined2 *)(param_1 * 0xe + 0x10038ecc) = 3;
      *(undefined2 *)(param_1 * 0xe + 0x10038ece) = 0;
    }
  }
  else if (sVar1 < 5) {
    *(undefined2 *)(param_1 * 0xe + 0x10038ecc) = 3;
  }
  return;
}

