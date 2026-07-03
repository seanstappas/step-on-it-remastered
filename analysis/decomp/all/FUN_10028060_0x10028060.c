
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10028060(void)

{
  int iVar1;
  uint uVar2;
  short sVar3;
  int iVar4;
  short sVar5;
  short sVar6;
  short sVar7;
  
  sVar5 = _DAT_1003a36c;
  sVar3 = -1;
  while (sVar7 = sVar5, sVar7 != -1) {
    *(short *)(sVar7 * 0x18 + 0x1003a424) = *(short *)(sVar7 * 0x18 + 0x1003a424) + 1;
    if (*(char *)(sVar7 * 0x18 + 0x1003a422) == '\0') {
      iVar1 = *(short *)(sVar7 * 0x18 + 0x1003a41c) * 10 +
              (int)*(short *)(sVar7 * 0x18 + 0x1003a424) *
              (int)*(short *)(sVar7 * 0x18 + 0x1003a420);
    }
    else {
      uVar2 = *(short *)(sVar7 * 0x18 + 0x1003a424) * 5 * (int)*(short *)(sVar7 * 0x18 + 0x1003a424)
      ;
      iVar1 = *(short *)(sVar7 * 0x18 + 0x1003a41c) * 10 +
              (int)*(short *)(sVar7 * 0x18 + 0x1003a424) *
              (int)*(short *)(sVar7 * 0x18 + 0x1003a420) +
              ((int)uVar2 >> 1) + (uint)((int)uVar2 < 0 && (uVar2 & 1) != 0);
    }
    iVar1 = iVar1 / 10;
    iVar4 = (*(short *)(sVar7 * 0x18 + 0x1003a41a) * 10 +
            (int)*(short *)(sVar7 * 0x18 + 0x1003a424) * (int)*(short *)(sVar7 * 0x18 + 0x1003a41e))
            / 10;
    if (((short)iVar1 < 0x28) && (*(char *)(sVar7 * 0x18 + 0x1003a422) != '\0')) {
      iVar1 = 0x28;
    }
    sVar5 = (short)iVar4;
    if ((((sVar5 < 0x25e) && (4 < sVar5)) && (sVar6 = (short)iVar1, sVar6 < 0x1be)) &&
       (0x27 < sVar6)) {
      FUN_100043a0(*(undefined4 *)(&DAT_1003a410 + sVar7 * 0x18),
                   (int)*(short *)(sVar7 * 0x18 + 0x1003a414),
                   (int)*(short *)(sVar7 * 0x18 + 0x1003a416),
                   (int)*(short *)(sVar7 * 0x18 + 0x1003a418),
                   *(undefined4 *)(&DAT_1003a410 + sVar7 * 0x18),
                   (int)*(short *)(sVar7 * 0x18 + 0x1003a414),iVar4,iVar1);
      *(short *)(sVar7 * 0x18 + 0x1003a416) = sVar5;
      *(short *)(sVar7 * 0x18 + 0x1003a418) = sVar6;
      sVar5 = *(short *)(sVar7 * 0x18 + 0x1003a426);
      sVar3 = sVar7;
    }
    else {
      FUN_10004cb0(*(undefined4 *)(&DAT_1003a410 + sVar7 * 0x18),
                   (int)*(short *)(sVar7 * 0x18 + 0x1003a414),
                   (int)*(short *)(sVar7 * 0x18 + 0x1003a416),
                   (int)*(short *)(sVar7 * 0x18 + 0x1003a418));
      if (sVar3 == -1) {
        _DAT_1003a36c = *(short *)(sVar7 * 0x18 + 0x1003a426);
        *(short *)(sVar7 * 0x18 + 0x1003a426) = _DAT_1003a36e;
        sVar5 = _DAT_1003a36c;
        _DAT_1003a36e = sVar7;
      }
      else {
        *(undefined2 *)(sVar3 * 0x18 + 0x1003a426) = *(undefined2 *)(sVar7 * 0x18 + 0x1003a426);
        *(short *)(sVar7 * 0x18 + 0x1003a426) = _DAT_1003a36e;
        sVar5 = *(short *)(sVar3 * 0x18 + 0x1003a426);
        _DAT_1003a36e = sVar7;
      }
    }
  }
  return;
}

