
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10016784(void)

{
  char cVar3;
  undefined4 uVar1;
  undefined4 uVar2;
  short sVar4;
  
  for (sVar4 = 0; sVar4 < _DAT_10038ec6; sVar4 = sVar4 + 1) {
    if (*(short *)(sVar4 * 0xe + 0x10038ecc) == 4) {
      if (*(short *)(sVar4 * 0xe + 0x10038ece) == 8) {
        cVar3 = FUN_10004650((int)*(short *)(&DAT_10038ec8 + sVar4 * 0xe),
                             (int)*(short *)(sVar4 * 0xe + 0x10038eca));
        if (cVar3 != '\0') {
          *(short *)(sVar4 * 0xe + 0x10038ece) = *(short *)(sVar4 * 0xe + 0x10038ece) + -1;
          *(int *)(&DAT_1003ad68 +
                  *(short *)(&DAT_10038ec8 + sVar4 * 0xe) * 0x3c +
                  *(short *)(sVar4 * 0xe + 0x10038eca) * 4) =
               *(short *)(sVar4 * 0xe + 0x10038ed2) + 0x300;
          uVar1 = FUN_1002e6bc((int)*(short *)(sVar4 * 0xe + 0x10038eca));
          uVar2 = FUN_1002e6ac((int)*(short *)(&DAT_10038ec8 + sVar4 * 0xe));
          FUN_10004108(_DAT_1003ad18,
                       (int)*(short *)(sVar4 * 0xe + 0x10038ece) +
                       *(short *)(sVar4 * 0xe + 0x10038ed0) * 8,uVar2,uVar1);
        }
      }
      else {
        *(short *)(sVar4 * 0xe + 0x10038ece) = *(short *)(sVar4 * 0xe + 0x10038ece) + -1;
        if (*(short *)(sVar4 * 0xe + 0x10038ece) < 1) {
          *(undefined2 *)(sVar4 * 0xe + 0x10038ecc) = 2;
        }
        else {
          uVar1 = FUN_1002e6bc((int)*(short *)(sVar4 * 0xe + 0x10038eca));
          uVar2 = FUN_1002e6ac((int)*(short *)(&DAT_10038ec8 + sVar4 * 0xe));
          FUN_10004108(_DAT_1003ad18,
                       (int)*(short *)(sVar4 * 0xe + 0x10038ece) +
                       *(short *)(sVar4 * 0xe + 0x10038ed0) * 8,uVar2,uVar1);
        }
      }
    }
    else if (*(short *)(sVar4 * 0xe + 0x10038ecc) == 3) {
      if (*(short *)(sVar4 * 0xe + 0x10038ece) == 0) {
        *(int *)(&DAT_1003ad68 +
                *(short *)(&DAT_10038ec8 + sVar4 * 0xe) * 0x3c +
                *(short *)(sVar4 * 0xe + 0x10038eca) * 4) =
             *(short *)(sVar4 * 0xe + 0x10038ed4) + 0x300;
      }
      *(short *)(sVar4 * 0xe + 0x10038ece) = *(short *)(sVar4 * 0xe + 0x10038ece) + 1;
      if (*(short *)(sVar4 * 0xe + 0x10038ece) < 9) {
        uVar1 = FUN_1002e6bc((int)*(short *)(sVar4 * 0xe + 0x10038eca));
        uVar2 = FUN_1002e6ac((int)*(short *)(&DAT_10038ec8 + sVar4 * 0xe));
        FUN_10004108(_DAT_1003ad18,
                     (int)*(short *)(sVar4 * 0xe + 0x10038ece) +
                     *(short *)(sVar4 * 0xe + 0x10038ed0) * 8,uVar2,uVar1);
      }
      else {
        *(undefined2 *)(sVar4 * 0xe + 0x10038ecc) = 1;
        *(int *)(&DAT_1003ad68 +
                *(short *)(&DAT_10038ec8 + sVar4 * 0xe) * 0x3c +
                *(short *)(sVar4 * 0xe + 0x10038eca) * 4) =
             *(short *)(sVar4 * 0xe + 0x10038ed4) + 0x100;
      }
    }
  }
  return;
}

