
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_100035e4(void)

{
  int iVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  short sVar5;
  short sVar6;
  
  for (sVar5 = 0; sVar5 < 0xdf; sVar5 = sVar5 + 1) {
    *(int *)(&DAT_10037124 + sVar5 * 4) = (int)sVar5 << 0x18;
  }
  for (sVar5 = 0xdf; sVar5 < 0x100; sVar5 = sVar5 + 1) {
    iVar4 = 0x2fffd;
    for (sVar6 = 0; sVar6 < 0xdf; sVar6 = sVar6 + 1) {
      iVar1 = FUN_10003760((uint)*(ushort *)(*_DAT_1003b26c + 0xe + sVar5 * 8) -
                           (uint)*(ushort *)(*_DAT_1003b26c + 0xe + sVar6 * 8));
      iVar2 = FUN_10003760((uint)*(ushort *)(*_DAT_1003b26c + 0xc + sVar5 * 8) -
                           (uint)*(ushort *)(*_DAT_1003b26c + 0xc + sVar6 * 8));
      iVar3 = FUN_10003760((uint)*(ushort *)(*_DAT_1003b26c + 10 + sVar5 * 8) -
                           (uint)*(ushort *)(*_DAT_1003b26c + 10 + sVar6 * 8));
      iVar3 = iVar3 + iVar2 + iVar1;
      if (iVar3 < iVar4) {
        *(int *)(&DAT_10037124 + sVar5 * 4) = (int)sVar6 << 0x18;
        iVar4 = iVar3;
      }
    }
  }
  uRam10037520 = 0xff000000;
  return;
}

