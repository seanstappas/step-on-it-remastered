/* FUN_1002d2d4 @ 0x1002d2d4  calls: GetKeys */

int FUN_1002d2d4(void)

{
  uint uVar1;
  uint uVar2;
  short sVar3;
  short sVar4;
  
  .glue::GetKeys(&DAT_1003b6fc);
  sVar4 = 0;
  while( true ) {
    if (0x7e < sVar4) {
      return -1;
    }
    uVar1 = (uint)sVar4;
    uVar2 = (uint)sVar4;
    sVar3 = sVar4 + (short)(((int)uVar2 >> 5) + (uint)((int)uVar2 < 0 && (uVar2 & 0x1f) != 0)) *
                    -0x20;
    uVar2 = (uint)sVar3;
    if ((0x80000000U >>
         (((((int)uVar2 >> 3) + (uint)((int)uVar2 < 0 && (uVar2 & 7) != 0)) * 0x10 + 7) - (int)sVar3
         & 0x3f) &
        *(uint *)(&DAT_1003b6fc +
                 (((int)uVar1 >> 5) + (uint)((int)uVar1 < 0 && (uVar1 & 0x1f) != 0)) * 4)) != 0)
    break;
    sVar4 = sVar4 + 1;
  }
  return (int)sVar4 << 8;
}

