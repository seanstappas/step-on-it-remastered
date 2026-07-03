
void FUN_10003914(void)

{
  short sVar1;
  short sVar2;
  short sVar3;
  
  FUN_10003b68();
  for (sVar3 = 0; sVar3 < 0x14; sVar3 = sVar3 + 1) {
    for (sVar1 = *(short *)(&DAT_10037874 + sVar3 * 2); sVar1 != -1;
        sVar1 = *(short *)(sVar1 * 0x14 + 0x100378a0)) {
      sVar2 = *(short *)(sVar1 * 0x14 + 0x100378a0);
      while( true ) {
        if (sVar2 == -1) break;
        FUN_10003a0c((int)sVar1,(int)sVar2);
        sVar2 = *(short *)(sVar2 * 0x14 + 0x100378a0);
      }
      sVar2 = *(short *)(&DAT_10037874 + (sVar3 + 1) * 2);
      while( true ) {
        if (sVar2 == -1) break;
        FUN_10003a0c((int)sVar1,(int)sVar2);
        sVar2 = *(short *)(sVar2 * 0x14 + 0x100378a0);
      }
    }
  }
  return;
}

