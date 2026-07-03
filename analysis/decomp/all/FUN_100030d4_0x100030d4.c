
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int FUN_100030d4(short param_1,short param_2,short param_3,short param_4)

{
  int iVar1;
  int iVar2;
  
  iVar2 = (int)_DAT_1003a36a;
  while( true ) {
    while( true ) {
      while( true ) {
        while( true ) {
          if ((short)iVar2 == 0) {
            return 0;
          }
          iVar1 = (short)iVar2 * 0x46;
          if (param_2 <= *(short *)(iVar1 + 0x10037e7e)) break;
          iVar2 = (int)*(short *)(iVar1 + 0x10037e86);
        }
        if (*(short *)(iVar1 + 0x10037e80) <= param_4) break;
        iVar2 = (int)*(short *)(iVar1 + 0x10037e86);
      }
      if (*(short *)(iVar1 + 0x10037e82) <= param_3) break;
      iVar2 = (int)*(short *)(iVar1 + 0x10037e86);
    }
    if (param_1 <= *(short *)(iVar1 + 0x10037e84)) break;
    iVar2 = (int)*(short *)(iVar1 + 0x10037e86);
  }
  return iVar2;
}

