
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_100283a0(void)

{
  short sVar1;
  short sVar2;
  undefined4 uVar3;
  short sVar4;
  int iVar5;
  short sVar6;
  
  sVar1 = _DAT_1003ad58;
  sVar4 = -1;
  while (sVar6 = sVar1, sVar6 != -1) {
    iVar5 = (int)*(short *)(sVar6 * 0x10 + 0x1003a374) + (int)*(short *)(sVar6 * 0x10 + 0x1003a376);
    sVar1 = (short)iVar5;
    if ((sVar1 < 6) && (0 < sVar1)) {
      if ((*(short *)(sVar6 * 0x10 + 0x1003a374) == 6) ||
         (*(short *)(sVar6 * 0x10 + 0x1003a374) == 0)) {
        FUN_10004bb4(_DAT_1003ad30,iVar5,(int)*(short *)(&DAT_1003a370 + sVar6 * 0x10),
                     (int)*(short *)(sVar6 * 0x10 + 0x1003a372));
      }
      else {
        FUN_100043a0(_DAT_1003ad30,(int)*(short *)(sVar6 * 0x10 + 0x1003a374),
                     (int)*(short *)(&DAT_1003a370 + sVar6 * 0x10),
                     (int)*(short *)(sVar6 * 0x10 + 0x1003a372),_DAT_1003ad30,iVar5,
                     (int)*(short *)(&DAT_1003a370 + sVar6 * 0x10),
                     (int)*(short *)(sVar6 * 0x10 + 0x1003a372));
      }
      *(short *)(sVar6 * 0x10 + 0x1003a374) = sVar1;
      sVar1 = *(short *)(sVar6 * 0x10 + 0x1003a37e);
      sVar4 = sVar6;
    }
    else {
      FUN_10004cb0(_DAT_1003ad30,(int)*(short *)(sVar6 * 0x10 + 0x1003a374),
                   (int)*(short *)(&DAT_1003a370 + sVar6 * 0x10),
                   (int)*(short *)(sVar6 * 0x10 + 0x1003a372));
      if (5 < sVar1) {
        FUN_10004108(_DAT_1003ad30,(int)*(short *)(sVar6 * 0x10 + 0x1003a378),
                     (int)*(short *)(&DAT_1003a370 + sVar6 * 0x10),
                     (int)*(short *)(sVar6 * 0x10 + 0x1003a372));
      }
      uVar3 = *(undefined4 *)(sVar6 * 0x10 + 0x1003a37a);
      sVar1 = FUN_1002e6f8((int)*(short *)(sVar6 * 0x10 + 0x1003a372));
      sVar2 = FUN_1002e6cc((int)*(short *)(&DAT_1003a370 + sVar6 * 0x10));
      *(undefined4 *)(&DAT_1003ad68 + sVar2 * 0x3c + sVar1 * 4) = uVar3;
      if (sVar4 == -1) {
        _DAT_1003ad58 = *(short *)(sVar6 * 0x10 + 0x1003a37e);
        *(short *)(sVar6 * 0x10 + 0x1003a37e) = _DAT_1003ad5a;
        sVar1 = _DAT_1003ad58;
        _DAT_1003ad5a = sVar6;
      }
      else {
        *(undefined2 *)(sVar4 * 0x10 + 0x1003a37e) = *(undefined2 *)(sVar6 * 0x10 + 0x1003a37e);
        *(short *)(sVar6 * 0x10 + 0x1003a37e) = _DAT_1003ad5a;
        sVar1 = *(short *)(sVar4 * 0x10 + 0x1003a37e);
        _DAT_1003ad5a = sVar6;
      }
    }
  }
  return;
}

