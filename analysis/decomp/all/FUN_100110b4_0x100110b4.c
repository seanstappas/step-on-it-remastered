
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_100110b4(undefined4 param_1)

{
  undefined4 uVar1;
  short sVar2;
  short sVar3;
  undefined2 uVar4;
  short sVar5;
  
  uVar1 = param_1;
  if (DAT_100370e4 == '\0') {
    uVar1 = 1;
  }
  sVar5 = (short)param_1;
  if ((*(short *)(sVar5 * 0x70 + 0x1003a9fe) == 0) &&
     (0 < *(short *)((short)uVar1 * 0x70 + 0x1003a9fa))) {
    *(undefined1 *)(sVar5 * 0x70 + 0x1003a9d4) = 0;
    FUN_1002b020(1,7);
    FUN_1000ed6c(uVar1);
    *(undefined2 *)((short)uVar1 * 0x70 + 0x1003a9f2) = 0;
    uVar1 = FUN_1002e6cc(*(short *)(sVar5 * 0x70 + 0x1003a9b4) + 0x10);
    sVar2 = FUN_1002e6ac(uVar1);
    *(short *)(sVar5 * 0x70 + 0x1003aa00) = sVar2 + 8;
    *(undefined2 *)(sVar5 * 0x70 + 0x1003aa04) = 1;
    *(undefined1 *)(sVar5 * 0x70 + 0x1003aa08) = 0;
    if (*(short *)(sVar5 * 0x70 + 0x1003a9e4) == 1) {
      *(short *)(sVar5 * 0x70 + 0x1003a9fe) = *(short *)(&DAT_1003a9b0 + sVar5 * 0x70) + 0x14;
      sVar2 = FUN_1002e6f8((int)*(short *)(sVar5 * 0x70 + 0x1003aa00));
      sVar3 = FUN_1002e6cc(*(short *)(sVar5 * 0x70 + 0x1003a9fe) + 0x18);
      if ((*(uint *)(&DAT_1003ad68 + sVar3 * 0x3c + sVar2 * 4) & 0x200) != 0) {
        uVar1 = FUN_1002e6cc(*(short *)(sVar5 * 0x70 + 0x1003a9fe) + -8);
        sVar2 = FUN_1002e6ac(uVar1);
        *(short *)(sVar5 * 0x70 + 0x1003a9fe) = sVar2 + 8;
      }
      *(undefined2 *)(sVar5 * 0x70 + 0x1003aa02) = *(undefined2 *)(sVar5 * 0x70 + 0x1003a9e4);
      FUN_10004bb4(_DAT_1003ad20,10,(int)*(short *)(sVar5 * 0x70 + 0x1003a9fe),
                   (int)*(short *)(sVar5 * 0x70 + 0x1003aa00));
    }
    else {
      *(short *)(sVar5 * 0x70 + 0x1003a9fe) = *(short *)(&DAT_1003a9b0 + sVar5 * 0x70) + -0xe;
      sVar2 = FUN_1002e6f8((int)*(short *)(sVar5 * 0x70 + 0x1003aa00));
      sVar3 = FUN_1002e6cc((int)*(short *)(sVar5 * 0x70 + 0x1003a9fe));
      if ((*(uint *)(&DAT_1003ad68 + sVar3 * 0x3c + sVar2 * 4) & 0x200) != 0) {
        uVar1 = FUN_1002e6cc(*(short *)(sVar5 * 0x70 + 0x1003a9fe) + 0x20);
        uVar4 = FUN_1002e6ac(uVar1);
        *(undefined2 *)(sVar5 * 0x70 + 0x1003a9fe) = uVar4;
      }
      *(undefined2 *)(sVar5 * 0x70 + 0x1003aa02) = *(undefined2 *)(sVar5 * 0x70 + 0x1003a9e4);
      FUN_10004bb4(_DAT_1003ad20,9,(int)*(short *)(sVar5 * 0x70 + 0x1003a9fe),
                   (int)*(short *)(sVar5 * 0x70 + 0x1003aa00));
    }
  }
  return;
}

