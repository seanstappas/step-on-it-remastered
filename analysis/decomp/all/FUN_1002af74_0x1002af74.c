
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1002af74(void)

{
  undefined4 uVar1;
  short sVar2;
  
  _DAT_1003b6e4 = 0;
  for (sVar2 = 1; sVar2 < 0x35; sVar2 = sVar2 + 1) {
    uVar1 = FUN_10019894((int)*(short *)(&DAT_10037074 + sVar2 * 2),0x2a);
    *(undefined4 *)(&DAT_1003abec + sVar2 * 4) = uVar1;
    if (*(int *)(&DAT_1003abec + sVar2 * 4) == 0) {
      FUN_100192f8(6);
    }
    FUN_10023e70();
  }
  return;
}

